"""Display-only rendering.

Rule for everything in this module: read the flock, controls and descriptors, never
write to them, and never call the global `random` module (it shares its stream with
the simulation and the Markov generator, so any extra call would change the OSC output).
"""
from __future__ import annotations

import math
import random
import time
from contextlib import contextmanager

import pygame
import pygame.gfxdraw
from pygame.math import Vector2

from .boids import Boid
from .config import BACKGROUND, CONTROL_PORT, OSC_HOST, OSC_PORT, TEXT
from .controls import RuntimeControls

# Optional per-stage timing: an external profiler may set this to a dict; stays None otherwise.
STAGE_ACC: dict[str, float] | None = None


@contextmanager
def _stage(name: str):
    if STAGE_ACC is None:
        yield
        return
    start = time.perf_counter()
    try:
        yield
    finally:
        STAGE_ACC[name] = STAGE_ACC.get(name, 0.0) + time.perf_counter() - start


class View:
    """Maps the fixed simulation world into a canvas: uniform scale, centred, letterboxed.

    The simulation always runs at the world size (config WIDTH x HEIGHT); only the
    picture is scaled. With canvas == world size this is the identity mapping.
    """

    def __init__(self, world_size: tuple[int, int], canvas_size: tuple[int, int]):
        ww, wh = world_size
        cw, ch = canvas_size
        self.world_size = (ww, wh)
        self.canvas_size = (cw, ch)
        self.is_identity = (cw, ch) == (ww, wh)
        self.scale = min(cw / ww, ch / wh)
        vw, vh = round(ww * self.scale), round(wh * self.scale)
        self.rect = pygame.Rect((cw - vw) // 2, (ch - vh) // 2, vw, vh)

    def to_world(self, pos: tuple[int, int]) -> Vector2:
        """Canvas pixel (e.g. mouse) -> world coordinates, clamped to the world."""
        if self.is_identity:
            return Vector2(pos)
        ww, wh = self.world_size
        x = (pos[0] - self.rect.x) / self.scale
        y = (pos[1] - self.rect.y) / self.scale
        return Vector2(max(0.0, min(ww - 1.0, x)), max(0.0, min(wh - 1.0, y)))


class Display:
    """Owns the window: windowed size, fullscreen toggle, current canvas and view."""

    def __init__(
        self,
        world_size: tuple[int, int],
        window_size: tuple[int, int],
        caption: str,
        fullscreen: bool = False,
    ):
        self.world_size = world_size
        self.window_size = window_size
        self.caption = caption
        self.fullscreen = False
        self.canvas: pygame.Surface
        self.view: View
        desktop = pygame.display.get_desktop_sizes()[0]
        if window_size[0] > desktop[0] or window_size[1] > desktop[1]:
            print(f"[display] window {window_size[0]}x{window_size[1]} is larger than the desktop "
                  f"{desktop[0]}x{desktop[1]}; press F11 for fullscreen")
        self._set_mode(fullscreen)

    def _set_mode(self, fullscreen: bool) -> None:
        # "Fullscreen" is a borderless window covering the desktop, not exclusive
        # fullscreen: no display-mode switch, and it is not minimised when focus moves
        # to another app (e.g. Max) during a recording.
        pygame.display.set_caption(self.caption)
        if fullscreen:
            self.canvas = pygame.display.set_mode(pygame.display.get_desktop_sizes()[0], pygame.NOFRAME)
            self._move_window((0, 0))
        else:
            self.canvas = pygame.display.set_mode(self.window_size)
            if self.fullscreen:
                self._move_window(None)
        self.fullscreen = fullscreen
        self.view = View(self.world_size, self.canvas.get_size())

    @staticmethod
    def _move_window(position: tuple[int, int] | None) -> None:
        """Move the window (None = centre). Best effort: pygame._sdl2 ships with pygame."""
        try:
            from pygame._sdl2.video import WINDOWPOS_CENTERED, Window

            window = Window.from_display_module()
            window.position = WINDOWPOS_CENTERED if position is None else position
        except Exception:
            pass

    def toggle_fullscreen(self) -> None:
        self._set_mode(not self.fullscreen)


def draw_hud(
    surface: pygame.Surface,
    font: pygame.font.Font,
    controls: RuntimeControls,
    descriptors: dict[str, float],
    origin: tuple[int, int] = (0, 0),
) -> None:
    lines = [
        "SynthFish | boids -> OSC -> Max | MIDI and UDP 7500 control active",
        f"density_fader UP/DOWN: {controls.density_fader:.2f} | section 1-6: {controls.section_name}",
        f"A/Z align {controls.alignment_weight:.2f} | S/X cohesion {controls.cohesion_weight:.2f} | D/C separation {controls.separation_weight:.2f} | N/M noise {controls.noise_weight:.2f}",
        f"food_amount {controls.food_amount:.2f} | predator_amount {controls.predator_amount:.2f} | mouse food/pred {controls.food_strength:.2f}/{controls.predator_strength:.2f}",
        f"fish -/= : {controls.population} (fish_count {descriptors.get('fish_count', 0):.2f}) -> granular density",
        "Mouse left = food/attractor | mouse right = predator/repeller | SPACE pause | R reset",
        f"OSC out: {OSC_HOST}:{OSC_PORT} | plain out: 7401 | control in: {CONTROL_PORT}",
        f"mean_speed {descriptors.get('mean_speed', 0):.2f} | density {descriptors.get('density', 0):.2f} | spread {descriptors.get('spread', 0):.2f} | coherence {descriptors.get('direction_coherence', 0):.2f}",
    ]
    x0, y = origin[0] + 12, origin[1] + 10
    for line in lines:
        img = font.render(line, True, TEXT)
        surface.blit(img, (x0, y))
        y += 20


class ClassicRenderer:
    """The original look: flat background, triangle fish, rings, text HUD.

    At the native size it draws straight onto the canvas (pixel-identical to the
    original). Otherwise it draws the world at native size and smooth-scales it into
    the view, so the classic look stays exactly the same, only bigger.
    """

    def __init__(self, font: pygame.font.Font):
        self.font = font
        self._world: pygame.Surface | None = None
        self.drums = DrumLayer()

    def handle_key(self, key: int) -> bool:
        """Display keys; the classic look has none (H stays a no-op, as before)."""
        return False

    def drum_hit(self, name: str, velocity: float, flock: list[Boid]) -> None:
        self.drums.hit(name, velocity, flock)

    def draw(
        self,
        canvas: pygame.Surface,
        view: View,
        flock: list[Boid],
        attractor: Vector2 | None,
        repeller: Vector2 | None,
        controls: RuntimeControls,
        descriptors: dict[str, float],
    ) -> None:
        if view.is_identity:
            self._draw_world(canvas, flock, attractor, repeller)
            self.drums.draw(canvas, view, self.font)
            draw_hud(canvas, self.font, controls, descriptors)
            return
        if self._world is None or self._world.get_size() != view.world_size:
            self._world = pygame.Surface(view.world_size)
        self._draw_world(self._world, flock, attractor, repeller)
        canvas.fill(BACKGROUND)
        pygame.transform.smoothscale(self._world, view.rect.size, canvas.subsurface(view.rect))
        self.drums.draw(canvas, view, self.font)
        draw_hud(canvas, self.font, controls, descriptors, origin=view.rect.topleft)

    @staticmethod
    def _draw_world(
        surface: pygame.Surface,
        flock: list[Boid],
        attractor: Vector2 | None,
        repeller: Vector2 | None,
    ) -> None:
        surface.fill(BACKGROUND)
        if attractor is not None:
            pygame.draw.circle(surface, (80, 255, 150), attractor, 18, 2)
        if repeller is not None:
            pygame.draw.circle(surface, (255, 80, 90), repeller, 34, 2)
        for boid in flock:
            boid.draw(surface)


THERMAL_BACKGROUND = (0, 0, 0)

# Fish silhouette, upper half from nose to tail notch, in units of boid.size, pointing +x
# (mirrored for the lower half). Same overall length as the classic triangle (1.8 .. -1.3).
FISH_OUTLINE = [
    (1.8, 0.0), (1.55, 0.26), (1.1, 0.46), (0.5, 0.54), (-0.1, 0.44),
    (-0.55, 0.2), (-0.8, 0.1), (-1.3, 0.56), (-1.08, 0.0),
]
# Thin bright core along the spine (ellipse), in the same units.
CORE_CENTER, CORE_HALF_LENGTH, CORE_HALF_WIDTH = 0.55, 0.8, 0.18
HALO_GROWTH = 1.3  # halo extent relative to the body
HEADINGS = 64
HEAT_LEVELS = 8
SIZE_BINS = (6.8, 8.5, 10.2)  # boid.size is uniform 6..11 (boids.py:40)
SIZE_EDGES = (7.67, 9.33)
SUPERSAMPLE = 4

# Heat palette (heat = speed / max_speed): colour stops at heat 0, 0.5, 1.
# Body is blitted with MAX, so overlapping fish never add up. Its blue stays low and the
# core is dim, so the hottest fish peak around (255, 225, 45): warm yellow, never white.
BODY_STOPS = ((70, 20, 110), (210, 50, 50), (255, 140, 30))
CORE_STOPS = ((10, 5, 15), (30, 40, 10), (0, 85, 15))
# Halo is additive (dense areas glow). Green kept near zero, so piled-up halos saturate
# toward magenta instead of white.
HALO_STOPS = ((16, 3, 32), (34, 5, 30), (45, 8, 24))


# Trails: each frame the previous picture is multiplied by fade/256, then TRAIL_FLOOR is
# subtracted (an 8-bit multiply alone never reaches black; it stalls at a dim residue).
# Persistence follows flock energy (agitation): calm = short trails, agitated = long.
TRAIL_FADE_CALM = 205  # x0.80 per frame
TRAIL_FADE_AGITATED = 245  # x0.96 per frame (~0.25 s)
TRAIL_ENERGY_FULL = 0.45  # energy at which trails reach full length (live logs: p50 ~0.2, p95 ~0.4)
TRAIL_FLOOR = 2


def energy_level(energy: float) -> float:
    """Flock energy (agitation descriptor) mapped to 0..1 for visual intensity."""
    return max(0.0, min(1.0, energy / TRAIL_ENERGY_FULL))


def trail_fade(energy: float) -> int:
    t = energy_level(energy)
    return int(round(TRAIL_FADE_CALM + (TRAIL_FADE_AGITATED - TRAIL_FADE_CALM) * t))


# Glow: drawn directly at 1/GLOW_DOWNSCALE resolution (one pre-blurred blob per fish into a
# small fading buffer), never by shrinking the full frame (that read alone costs ~2 ms).
# Then gain (flock energy) and a MIN cap at low resolution, smooth upscale to 1/2,
# nearest x2 to full size, added on top. The cap keeps dense clusters from turning white.
GLOW_DOWNSCALE = 4
GLOW_RADIUS = 2.6  # blob radius in units of the mean boid.size
GLOW_STOPS = ((40, 6, 34), (110, 16, 22), (150, 28, 10))  # by heat; green kept low
GLOW_GAIN_CALM = 0.35
GLOW_GAIN_AGITATED = 1.0
GLOW_CAP = (170, 30, 70)


def glow_gain(energy: float) -> int:
    t = energy_level(energy)
    return int(round(255 * (GLOW_GAIN_CALM + (GLOW_GAIN_AGITATED - GLOW_GAIN_CALM) * t)))


class GlowBlobs:
    """Soft round blobs per heat level, sized for the low-resolution glow buffer."""

    def __init__(self, scale: float):
        radius = GLOW_RADIUS * (sum(SIZE_BINS) / len(SIZE_BINS)) * scale / GLOW_DOWNSCALE
        self.half = int(math.ceil(radius * 1.6)) + 1
        side = 2 * self.half
        mask = pygame.Surface((side * 4, side * 4))
        pygame.draw.circle(mask, (255, 255, 255), (side * 2, side * 2), radius * 4)
        mask = _soft(_soft(pygame.transform.smoothscale(mask, (side, side)), 2), 2)
        self.blobs: list[pygame.Surface] = []
        for h in range(HEAT_LEVELS):
            blob = mask.copy()
            blob.fill(_lerp_stops(GLOW_STOPS, (h + 0.5) / HEAT_LEVELS), special_flags=pygame.BLEND_RGB_MULT)
            self.blobs.append(blob.convert())


class GlowBuffers:
    """Low-resolution glow pipeline for one view size; `output` is the full-size result."""

    def __init__(self, view_size: tuple[int, int]):
        self.view_size = view_size
        vw, vh = view_size
        small_size = (max(1, vw // GLOW_DOWNSCALE), max(1, vh // GLOW_DOWNSCALE))
        self.small = pygame.Surface(small_size).convert()  # persistent: fades like the trails
        self.small.fill(THERMAL_BACKGROUND)
        self.work = self.small.copy()
        self.fade = self.small.copy()
        self.fade_value = -1
        self.floor = self.small.copy()
        self.floor.fill((TRAIL_FLOOR,) * 3)
        self.gain = self.small.copy()
        self.gain_value = -1
        self.cap = self.small.copy()
        self.cap.fill(GLOW_CAP)
        self.mid = pygame.Surface((max(1, vw // 2), max(1, vh // 2))).convert()
        self.output = pygame.Surface(view_size).convert()

    def update(self, blob_blits: list, fade: int | None, gain: int) -> None:
        small, work = self.small, self.work
        if fade is None:
            small.fill(THERMAL_BACKGROUND)
        else:
            if fade != self.fade_value:
                self.fade.fill((fade, fade, fade))
                self.fade_value = fade
            small.blit(self.fade, (0, 0), special_flags=pygame.BLEND_RGB_MULT)
            small.blit(self.floor, (0, 0), special_flags=pygame.BLEND_RGB_SUB)
        # MAX, not ADD: lingering fish do not pile up in the fading buffer.
        small.blits(blob_blits, doreturn=False)
        work.blit(small, (0, 0))
        if gain != self.gain_value:
            self.gain.fill((gain, gain, gain))
            self.gain_value = gain
        work.blit(self.gain, (0, 0), special_flags=pygame.BLEND_RGB_MULT)
        work.blit(self.cap, (0, 0), special_flags=pygame.BLEND_RGB_MIN)
        pygame.transform.smoothscale(work, self.mid.get_size(), self.mid)
        pygame.transform.scale(self.mid, self.view_size, self.output)


def _lerp_stops(stops: tuple[tuple[int, int, int], ...], t: float) -> tuple[int, int, int]:
    t = max(0.0, min(1.0, t)) * (len(stops) - 1)
    i = min(int(t), len(stops) - 2)
    f = t - i
    a, b = stops[i], stops[i + 1]
    return tuple(int(round(a[c] + (b[c] - a[c]) * f)) for c in range(3))


def _rotated(points: list[tuple[float, float]], angle: float, scale: float, center: float) -> list[tuple[float, float]]:
    cos_a, sin_a = math.cos(angle), math.sin(angle)
    return [(center + (x * cos_a - y * sin_a) * scale, center + (x * sin_a + y * cos_a) * scale) for x, y in points]


def _fish_polygon() -> list[tuple[float, float]]:
    lower = [(x, -y) for x, y in reversed(FISH_OUTLINE[1:-1])]
    return FISH_OUTLINE + lower


def _core_polygon(steps: int = 20) -> list[tuple[float, float]]:
    return [
        (CORE_CENTER + CORE_HALF_LENGTH * math.cos(a), CORE_HALF_WIDTH * math.sin(a))
        for a in (math.tau * i / steps for i in range(steps))
    ]


def _mask(points: list[tuple[float, float]], angle: float, unit: float, side: int, render_side: int) -> pygame.Surface:
    """White-on-black anti-aliased coverage mask: drawn at render_side, smooth-scaled to side."""
    k = render_side / side
    surface = pygame.Surface((render_side, render_side))
    pygame.draw.polygon(surface, (255, 255, 255), _rotated(points, angle, unit * k, render_side / 2))
    return pygame.transform.smoothscale(surface, (side, side))


def _soft(mask: pygame.Surface, factor: int = 4) -> pygame.Surface:
    """Cheap blur: average down by `factor`, then bilinear back up."""
    side = mask.get_width()
    small = pygame.transform.smoothscale(mask, (max(2, side // factor), max(2, side // factor)))
    return pygame.transform.smoothscale(small, (side, side))


class FishSprites:
    """Pre-rendered fish for one view scale: [size_bin][heat_level][heading] -> Surface."""

    def __init__(self, scale: float):
        fish = _fish_polygon()
        core = _core_polygon()
        halo = [(x * HALO_GROWTH, y * HALO_GROWTH * 1.4) for x, y in fish]
        body_colors = [_lerp_stops(BODY_STOPS, (h + 0.5) / HEAT_LEVELS) for h in range(HEAT_LEVELS)]
        core_colors = [_lerp_stops(CORE_STOPS, (h + 0.5) / HEAT_LEVELS) for h in range(HEAT_LEVELS)]
        halo_colors = [_lerp_stops(HALO_STOPS, (h + 0.5) / HEAT_LEVELS) for h in range(HEAT_LEVELS)]

        self.half: list[int] = []
        self.body: list[list[list[pygame.Surface]]] = []
        self.halo: list[list[list[pygame.Surface]]] = []
        for size in SIZE_BINS:
            unit = size * scale
            half = int(math.ceil(1.85 * HALO_GROWTH * unit)) + 2
            side = 2 * half
            self.half.append(half)
            body_by_heat = [[] for _ in range(HEAT_LEVELS)]
            halo_by_heat = [[] for _ in range(HEAT_LEVELS)]
            for k in range(HEADINGS):
                angle = math.tau * k / HEADINGS
                body_mask = _mask(fish, angle, unit, side, side * SUPERSAMPLE)
                core_mask = _mask(core, angle, unit, side, side * SUPERSAMPLE)
                halo_mask = _soft(_mask(halo, angle, unit, side, side * 2))
                for h in range(HEAT_LEVELS):
                    body = body_mask.copy()
                    body.fill(body_colors[h], special_flags=pygame.BLEND_RGB_MULT)
                    tinted_core = core_mask.copy()
                    tinted_core.fill(core_colors[h], special_flags=pygame.BLEND_RGB_MULT)
                    body.blit(tinted_core, (0, 0), special_flags=pygame.BLEND_RGB_ADD)
                    glow = halo_mask.copy()
                    glow.fill(halo_colors[h], special_flags=pygame.BLEND_RGB_MULT)
                    body_by_heat[h].append(body.convert())
                    halo_by_heat[h].append(glow.convert())
            self.body.append(body_by_heat)
            self.halo.append(halo_by_heat)


# Food and predator cues. Strength mirrors the simulation (boids.py:130,136): the fader
# amount if > 0, else the mouse strength; both range 0..3. Timing uses frame counts, never
# the global random or the clock, so the picture stays deterministic for a given run.
FOOD_COLOR = (20, 150, 140)  # teal; drawn with MAX, so fish gathering on it never add to white
FOOD_RADIUS = (34.0, 90.0)  # world px at strength 0 .. max
FOOD_STEPS = 12
FOOD_BREATH_FRAMES = 150  # one gentle breath every 2.5 s at 60 fps
PREDATOR_RADIUS = 220.0  # the boids' fear radius (boids.py:135): the pulse shows it
PREDATOR_RING_COLOR = (120, 60, 255)
PREDATOR_CORE_COLOR = (60, 24, 150)
PREDATOR_CORE_RADIUS = 26.0
PREDATOR_PULSE_FRAMES = 48  # a new ring every 0.8 s while the predator is active
PREDATOR_RING_FRAMES = 42  # ring lifetime
PREDATOR_FLASH = (46, 0, 38)  # additive tint at onset
PREDATOR_FLASH_DECAY = 0.82  # per frame (~0.3 s)


def strength01(amount: float, mouse_strength: float) -> float:
    return max(0.0, min(1.0, (amount if amount > 0.0 else mouse_strength) / 3.0))


def _soft_disc(radius_px: float, color: tuple[int, int, int], brightness: float) -> pygame.Surface:
    """Round glow sprite with a smooth radial falloff (1 - r/R)^1.3 that reaches 0 at radius_px."""
    side = 2 * (int(math.ceil(radius_px)) + 2)
    big = pygame.Surface((side * 2, side * 2))
    steps = 32
    for k in range(steps):  # outer to inner: each smaller circle is brighter
        r = 1.0 - k / steps
        level = int(255 * (1.0 - r) ** 1.3)
        pygame.draw.circle(big, (level, level, level), (side, side), radius_px * 2 * r)
    disc = _soft(pygame.transform.smoothscale(big, (side, side)), 2)
    disc.fill(tuple(int(c * brightness) for c in color), special_flags=pygame.BLEND_RGB_MULT)
    return disc.convert()


class EventSprites:
    """Pre-rendered food glows (by strength) and predator core for one view scale."""

    def __init__(self, scale: float):
        lo, hi = FOOD_RADIUS
        self.food = [
            _soft_disc((lo + (hi - lo) * i / (FOOD_STEPS - 1)) * scale, FOOD_COLOR, 0.7 + 0.3 * i / (FOOD_STEPS - 1))
            for i in range(FOOD_STEPS)
        ]
        self.predator_core = _soft_disc(PREDATOR_CORE_RADIUS * scale, PREDATOR_CORE_COLOR, 1.0)


class EventLayer:
    """Food glow, predator rings and onset flash, drawn on top of the fish."""

    def __init__(self) -> None:
        self.frame = 0
        self.predator_was_active = False
        self.last_ring = -PREDATOR_PULSE_FRAMES
        self.rings: list[tuple[int, Vector2, float]] = []  # (birth frame, world position, strength)
        self.flash = 0.0
        self._sprites: dict[float, EventSprites] = {}
        self._tint: pygame.Surface | None = None

    def draw(
        self,
        canvas: pygame.Surface,
        view: View,
        attractor: Vector2 | None,
        repeller: Vector2 | None,
        controls: RuntimeControls,
    ) -> None:
        self.frame += 1
        scale = view.scale
        ox, oy = view.rect.topleft
        key = round(scale, 4)
        sprites = self._sprites.get(key)
        if sprites is None:
            sprites = self._sprites[key] = EventSprites(scale)

        if attractor is not None:
            food = strength01(controls.food_amount, controls.food_strength)
            breath = 0.5 + 0.5 * math.sin(math.tau * self.frame / FOOD_BREATH_FRAMES)
            index = round((0.25 + 0.75 * food) * (FOOD_STEPS - 1) - breath * 1.5)
            glow = sprites.food[max(0, min(FOOD_STEPS - 1, index))]
            half = glow.get_width() // 2
            canvas.blit(glow, (ox + attractor.x * scale - half, oy + attractor.y * scale - half),
                        special_flags=pygame.BLEND_RGB_MAX)

        active = repeller is not None
        if active:
            predator = strength01(controls.predator_amount, controls.predator_strength)
            if not self.predator_was_active:
                self.flash = 1.0
            if self.frame - self.last_ring >= PREDATOR_PULSE_FRAMES:
                self.rings.append((self.frame, Vector2(repeller), predator))
                self.last_ring = self.frame
            core = sprites.predator_core
            half = core.get_width() // 2
            canvas.blit(core, (ox + repeller.x * scale - half, oy + repeller.y * scale - half),
                        special_flags=pygame.BLEND_RGB_MAX)
        else:
            self.last_ring = -PREDATOR_PULSE_FRAMES  # next onset rings immediately
        self.predator_was_active = active

        alive = []
        for birth, pos, strength in self.rings:
            t = (self.frame - birth) / PREDATOR_RING_FRAMES
            if t >= 1.0:
                continue
            alive.append((birth, pos, strength))
            radius = PREDATOR_RADIUS * scale * (0.15 + 0.85 * (1.0 - (1.0 - t) ** 2))
            level = (1.0 - t) * (0.4 + 0.6 * strength)
            color = tuple(int(c * level) for c in PREDATOR_RING_COLOR)
            cx, cy = int(ox + pos.x * scale), int(oy + pos.y * scale)
            for dr in (0, 1, 2):
                pygame.gfxdraw.aacircle(canvas, cx, cy, int(radius) + dr, color)
        self.rings = alive

        if self.flash > 0.03:
            if self._tint is None or self._tint.get_size() != view.rect.size:
                self._tint = pygame.Surface(view.rect.size).convert()
            self._tint.fill(tuple(int(c * self.flash) for c in PREDATOR_FLASH))
            canvas.blit(self._tint, view.rect.topleft, special_flags=pygame.BLEND_RGB_ADD)
            self.flash *= PREDATOR_FLASH_DECAY
        else:
            self.flash = 0.0


# Particles: sparse drifting motes in three depth layers, behind the fish. They use a
# private random.Random instance; the global `random` (shared with the simulation) is
# never touched. Drift speed follows the flock's mean_speed: the water stirs with the school.
PARTICLE_COUNT = 180
PARTICLE_SEED = 7
# (radius in world px, speed factor, colour) from far to near
PARTICLE_LAYERS = (
    (1.1, 0.35, (22, 18, 46)),
    (1.7, 0.6, (32, 26, 64)),
    (2.4, 1.0, (44, 36, 88)),
)
PARTICLE_DRIFT = (0.06, -0.16)  # world px per frame at speed factor 1 (slow rise)
PARTICLE_SPEED_GAIN = 1.6  # drift multiplier = 0.4 + gain * mean_speed
PARTICLE_TWINKLE_LEVELS = 4


class ParticleField:
    def __init__(self, world_size: tuple[int, int]):
        self.world_size = world_size
        rng = random.Random(PARTICLE_SEED)
        ww, wh = world_size
        # [x, y, layer, phase]
        self.particles = [
            [rng.uniform(0, ww), rng.uniform(0, wh), rng.choice((0, 0, 1, 1, 2)), rng.uniform(0, math.tau)]
            for _ in range(PARTICLE_COUNT)
        ]
        self.frame = 0
        self._sprites: dict[float, tuple[list[list[pygame.Surface]], list[int]]] = {}

    def _sprites_for(self, scale: float) -> tuple[list[list[pygame.Surface]], list[int]]:
        key = round(scale, 4)
        cached = self._sprites.get(key)
        if cached is None:
            sprites = []
            halves = []
            for radius, _speed, color in PARTICLE_LAYERS:
                levels = [
                    _soft_disc(radius * 2.2 * scale, color, 0.45 + 0.55 * i / (PARTICLE_TWINKLE_LEVELS - 1))
                    for i in range(PARTICLE_TWINKLE_LEVELS)
                ]
                sprites.append(levels)
                halves.append(levels[0].get_width() // 2)
            cached = self._sprites[key] = (sprites, halves)
        return cached

    def draw(self, canvas: pygame.Surface, view: View, mean_speed: float) -> None:
        self.frame += 1
        sprites, halves = self._sprites_for(view.scale)
        scale = view.scale
        ox, oy = view.rect.topleft
        ww, wh = self.world_size
        drift = 0.4 + PARTICLE_SPEED_GAIN * mean_speed
        dx, dy = PARTICLE_DRIFT
        frame = self.frame
        top = PARTICLE_TWINKLE_LEVELS - 1
        blits = []
        for p in self.particles:
            layer = p[2]
            speed = PARTICLE_LAYERS[layer][1] * drift
            sway = 0.12 * math.sin(frame * 0.013 + p[3])
            p[0] = (p[0] + (dx + sway) * speed) % ww
            p[1] = (p[1] + dy * speed) % wh
            level = int((0.5 + 0.5 * math.sin(frame * 0.035 + p[3] * 3.0)) * top + 0.5)
            half = halves[layer]
            blits.append((sprites[layer][level], (ox + p[0] * scale - half, oy + p[1] * scale - half), None,
                          pygame.BLEND_RGB_ADD))
        canvas.blits(blits, doreturn=False)


# ---------------------------------------------------------------- MPK pad bank B: drum reactions (display only)
# Each hit starts a short effect drawn through the view on top of everything else. Positions are copied at the
# hit, so effects never follow (or touch) the fish. Own RNG: the global random stream is never used here.
DRUM_SEED = 23
DRUM_FRAMES = {"kick": 45, "snare": 16, "hihat": 14, "dirty": 9, "slice": 48, "openhat": 30, "clap": 10, "perc": 12}
KICK_RING_COLOR = (255, 120, 40)
SNARE_COLOR = (255, 225, 190)
SPARK_COLOR = (255, 248, 210)
BUBBLE_COLOR = (90, 200, 255)
OPENHAT_COLOR = (190, 215, 255)
CLAP_COLOR = (255, 255, 255)
PERC_COLOR = (255, 200, 90)
BANK_COLOR = (255, 170, 40)


def _faded(color: tuple[int, int, int], level: float) -> tuple[int, int, int]:
    level = max(0.0, min(1.0, level))
    return tuple(int(c * level) for c in color)


class DrumLayer:
    """Short display-only reactions to drum hits (kick ring, snare shock, hi-hat sparks, dirty glitch, slice
    bubbles, open-hat halos, clap flash, perc ticks) and the BANK B indicator."""

    def __init__(self) -> None:
        self.frame = 0
        self.rng = random.Random(DRUM_SEED)
        self.effects: list[dict] = []
        self.bank_b = False
        self._label: pygame.Surface | None = None

    def hit(self, name: str, velocity: float, flock: list[Boid]) -> None:
        if name not in DRUM_FRAMES:
            return
        rng = self.rng
        v = max(0.0, min(1.0, velocity))
        positions = [Vector2(boid.position) for boid in flock]
        effect: dict = {"name": name, "birth": self.frame, "v": v}
        if name == "snare":
            effect["side"] = rng.choice((-1, 1))
            effect["fish"] = rng.sample(positions, k=len(positions) // 3) if positions else []
        elif name == "hihat":
            fastest = sorted(flock, key=lambda b: b.velocity.length_squared(), reverse=True)[:8]
            effect["sparks"] = [(Vector2(b.position), Vector2(1, 0).rotate(rng.uniform(0, 360)) * rng.uniform(1.5, 4.0))
                                for b in fastest for _ in range(4)]
        elif name == "dirty":
            effect["bands"] = [(rng.uniform(0.0, 0.95), rng.uniform(0.02, 0.08), rng.choice((-1, 1)) * rng.uniform(10, 40))
                               for _ in range(5)]
            effect["shake"] = (rng.choice((-1, 1)), rng.choice((-1, 1)))
        elif name == "slice":
            chosen = rng.sample(positions, k=min(10, len(positions))) if positions else []
            effect["bubbles"] = [(p, rng.uniform(-0.4, 0.4), rng.uniform(0.8, 1.6)) for p in chosen]
        elif name == "openhat":
            effect["fish"] = rng.sample(positions, k=min(40, len(positions))) if positions else []
        elif name == "perc":
            chosen = rng.sample(positions, k=min(6, len(positions))) if positions else []
            effect["ticks"] = [(p, rng.uniform(0, 360)) for p in chosen]
        self.effects.append(effect)

    def draw(self, canvas: pygame.Surface, view: View, font: pygame.font.Font) -> None:
        self.frame += 1
        if not self.effects and not self.bank_b:
            return
        scale = view.scale
        ox, oy = view.rect.topleft
        ww, wh = view.world_size

        def to_canvas(p: Vector2) -> tuple[int, int]:
            return int(ox + p.x * scale), int(oy + p.y * scale)

        alive, glitches = [], []
        for e in self.effects:
            age = self.frame - e["birth"]
            t = age / DRUM_FRAMES[e["name"]]
            if t >= 1.0:
                continue
            alive.append(e)
            v, name, fade = e["v"], e["name"], 1.0 - t
            if name == "kick":
                cx, cy = int(ox + ww * 0.5 * scale), int(oy + wh * 0.5 * scale)
                reach = min(ww, wh) * 0.55 * (0.5 + 0.5 * v) * scale
                for delay in (0.0, 0.15):
                    tt = (t - delay) / (1.0 - delay)
                    if 0.0 <= tt < 1.0:
                        r = int(20 * scale + reach * (1.0 - (1.0 - tt) ** 2))
                        color = _faded(KICK_RING_COLOR, (1.0 - tt) * (0.5 + 0.5 * v))
                        for dr in (0, 1, 2):
                            pygame.gfxdraw.aacircle(canvas, cx, cy, r + dr, color)
            elif name == "snare":
                side = e["side"]
                x = ww * (0.5 - 0.6 * side * (t - 0.5))
                color = _faded(SNARE_COLOR, fade * (0.5 + 0.5 * v))
                pygame.draw.line(canvas, color, to_canvas(Vector2(x, 0)), to_canvas(Vector2(x, wh)), max(1, int(3 * scale)))
                length = 40 * fade * (0.4 + 0.6 * v)
                for p in e["fish"]:
                    pygame.draw.line(canvas, color, to_canvas(p), to_canvas(p + Vector2(side * length, 0)), 1)
            elif name == "hihat":
                color = _faded(SPARK_COLOR, fade * (0.5 + 0.5 * v))
                for p, d in e["sparks"]:
                    pygame.draw.circle(canvas, color, to_canvas(p + d * age), max(1, int(2 * scale)))
            elif name == "dirty":
                glitches.append(e)
            elif name == "slice":
                color = _faded(BUBBLE_COLOR, fade * (0.5 + 0.5 * v))
                for p, drift, rise in e["bubbles"]:
                    q = to_canvas(p + Vector2(drift * age, -rise * age))
                    pygame.gfxdraw.aacircle(canvas, q[0], q[1], max(2, int((3 + 6 * t) * scale)), color)
            elif name == "openhat":
                color = _faded(OPENHAT_COLOR, fade * 0.6 * (0.5 + 0.5 * v))
                r = max(2, int((6 + 16 * t) * scale))
                for p in e["fish"]:
                    q = to_canvas(p)
                    pygame.gfxdraw.aacircle(canvas, q[0], q[1], r, color)
            elif name == "clap":
                color = _faded(CLAP_COLOR, fade * (0.5 + 0.5 * v))
                pygame.draw.rect(canvas, color, view.rect, max(1, int(8 * fade * scale)))
            elif name == "perc":
                color = _faded(PERC_COLOR, fade * (0.5 + 0.5 * v))
                for p, angle in e["ticks"]:
                    for k in range(6):
                        d = Vector2(1, 0).rotate(angle + 60 * k)
                        pygame.draw.line(canvas, color, to_canvas(p + d * 8), to_canvas(p + d * (8 + 10 * fade)), 1)
        self.effects = alive
        for e in glitches:  # last, so the glitch also tears the other effects
            fade = 1.0 - (self.frame - e["birth"]) / DRUM_FRAMES["dirty"]
            amount = fade * (0.4 + 0.6 * e["v"])
            rect = view.rect
            for y0, h, dx in e["bands"]:
                band = pygame.Rect(rect.x, rect.y + int(y0 * rect.h), rect.w, max(1, int(h * rect.h))).clip(rect)
                if band.h > 0:
                    canvas.blit(canvas.subsurface(band).copy(), (band.x + int(dx * amount * scale), band.y))
            sx, sy = e["shake"]
            canvas.scroll(int(sx * 6 * amount * scale), int(sy * 4 * amount * scale))
        if self.bank_b:
            if self._label is None:
                self._label = font.render("BANK B", True, BANK_COLOR)
            canvas.blit(self._label, (view.rect.right - self._label.get_width() - 10, view.rect.y + 8))


class ThermalRenderer:
    """Dark "thermal" look, drawn directly at canvas resolution through the view.

    Modes: "art" (no text, for recording) and "data" (same picture + HUD), toggled with H.
    """

    MODES = ("art", "data")

    def __init__(
        self,
        font: pygame.font.Font,
        mode: str = "art",
        trails: bool = True,
        glow: bool = True,
        particles: bool = True,
    ):
        self.font = font
        self.mode = mode
        self.trails = trails
        self.glow = glow
        self.particles = particles
        self._particle_field: ParticleField | None = None
        self._sprite_cache: dict[float, FishSprites] = {}
        self._glow_blob_cache: dict[float, GlowBlobs] = {}
        self._glow_buffers: GlowBuffers | None = None
        self._events = EventLayer()
        self.drums = DrumLayer()
        # Persistent picture of the world area: faded each frame instead of cleared (trails).
        # Only fish go in here; rings and HUD are drawn on the canvas so they never smear.
        self._scene: pygame.Surface | None = None
        self._fade_surface: pygame.Surface | None = None
        self._fade_value = -1
        self._floor_surface: pygame.Surface | None = None

    def handle_key(self, key: int) -> bool:
        if key == pygame.K_h:
            self.mode = "data" if self.mode == "art" else "art"
            return True
        if key == pygame.K_t:
            self.trails = not self.trails
            return True
        if key == pygame.K_g:
            self.glow = not self.glow
            return True
        if key == pygame.K_p:
            self.particles = not self.particles
            return True
        return False

    def drum_hit(self, name: str, velocity: float, flock: list[Boid]) -> None:
        self.drums.hit(name, velocity, flock)

    def draw(
        self,
        canvas: pygame.Surface,
        view: View,
        flock: list[Boid],
        attractor: Vector2 | None,
        repeller: Vector2 | None,
        controls: RuntimeControls,
        descriptors: dict[str, float],
    ) -> None:
        scale = view.scale
        ox, oy = view.rect.topleft
        scene = self._scene
        if scene is None or scene.get_size() != view.rect.size:
            scene = self._scene = pygame.Surface(view.rect.size).convert()
            scene.fill(THERMAL_BACKGROUND)
            # Fade via blits from constant surfaces: blit blending has SIMD paths, while
            # Surface.fill(special_flags=...) is scalar (measured ~0.2 ms vs ~11 ms).
            self._fade_surface = scene.copy()
            self._fade_value = -1
            self._floor_surface = scene.copy()
            self._floor_surface.fill((TRAIL_FLOOR,) * 3)
        with _stage("thermal.trails"):
            if self.trails:
                fade = trail_fade(descriptors.get("energy", 0.0))
                if fade != self._fade_value:
                    self._fade_surface.fill((fade, fade, fade))
                    self._fade_value = fade
                scene.blit(self._fade_surface, (0, 0), special_flags=pygame.BLEND_RGB_MULT)
                scene.blit(self._floor_surface, (0, 0), special_flags=pygame.BLEND_RGB_SUB)
            else:
                scene.fill(THERMAL_BACKGROUND)
        canvas.fill(THERMAL_BACKGROUND)
        canvas.set_clip(view.rect)
        if self.particles:
            with _stage("thermal.particles"):
                if self._particle_field is None or self._particle_field.world_size != view.world_size:
                    self._particle_field = ParticleField(view.world_size)
                self._particle_field.draw(canvas, view, descriptors.get("mean_speed", 0.0))
        with _stage("thermal.fish"):
            blobs = self._glow_blobs_for(scale) if self.glow else None
            halos, bodies, scene_bodies, glow_blobs = self._fish_blits(
                flock, self._sprites_for(scale), blobs, scale, ox, oy
            )
            canvas.blits(halos, doreturn=False)
        with _stage("thermal.compose"):
            # The scene holds only the past (faded). MAX keeps every pixel at
            # max(halo glow, trail, body): trails never stack on top of the glow.
            canvas.blit(scene, view.rect.topleft, special_flags=pygame.BLEND_RGB_MAX)
        with _stage("thermal.fish"):
            canvas.blits(bodies, doreturn=False)
            if self.trails:
                # Trails hold bodies only, with MAX: however long the trail, a pixel never gets
                # brighter than one sprite (additive halos in a fading buffer would pile up).
                scene.blits(scene_bodies, doreturn=False)
        if self.glow:
            with _stage("thermal.glow"):
                buffers = self._glow_buffers
                if buffers is None or buffers.view_size != view.rect.size:
                    buffers = self._glow_buffers = GlowBuffers(view.rect.size)
                energy = descriptors.get("energy", 0.0)
                buffers.update(glow_blobs, trail_fade(energy) if self.trails else None, glow_gain(energy))
                canvas.blit(buffers.output, view.rect.topleft, special_flags=pygame.BLEND_RGB_ADD)
        with _stage("thermal.events"):
            self._events.draw(canvas, view, attractor, repeller, controls)
        with _stage("thermal.drums"):
            self.drums.draw(canvas, view, self.font)
        canvas.set_clip(None)
        if self.mode == "data":
            draw_hud(canvas, self.font, controls, descriptors, origin=view.rect.topleft)

    def _sprites_for(self, scale: float) -> FishSprites:
        key = round(scale, 4)
        sprites = self._sprite_cache.get(key)
        if sprites is None:
            sprites = FishSprites(scale)
            self._sprite_cache[key] = sprites
        return sprites

    def _glow_blobs_for(self, scale: float) -> GlowBlobs:
        key = round(scale, 4)
        blobs = self._glow_blob_cache.get(key)
        if blobs is None:
            blobs = GlowBlobs(scale)
            self._glow_blob_cache[key] = blobs
        return blobs

    @staticmethod
    def _fish_blits(
        flock: list[Boid],
        sprites: FishSprites,
        blobs: GlowBlobs | None,
        scale: float,
        ox: int,
        oy: int,
    ) -> tuple[list, list, list, list]:
        """Blit lists: halos (additive, canvas), bodies (MAX, canvas), bodies (MAX, scene),
        glow blobs (MAX, low-resolution glow buffer).

        Halos go first so dense areas glow; bodies use MAX so overlapping fish never sum.
        """
        halos = []
        bodies = []
        scene_bodies = []
        glow = []
        glow_scale = scale / GLOW_DOWNSCALE
        for boid in flock:
            velocity = boid.velocity
            heat = min(1.0, velocity.length() / boid.max_speed + 0.6 * boid.flash)
            heat_i = min(HEAT_LEVELS - 1, int(heat * HEAT_LEVELS))
            heading_i = round(math.atan2(velocity.y, velocity.x) * HEADINGS / math.tau) % HEADINGS
            size_i = 0 if boid.size < SIZE_EDGES[0] else (1 if boid.size < SIZE_EDGES[1] else 2)
            half = sprites.half[size_i]
            body = sprites.body[size_i][heat_i][heading_i]
            x = boid.position.x * scale - half
            y = boid.position.y * scale - half
            halos.append((sprites.halo[size_i][heat_i][heading_i], (ox + x, oy + y), None, pygame.BLEND_RGB_ADD))
            bodies.append((body, (ox + x, oy + y), None, pygame.BLEND_RGB_MAX))
            scene_bodies.append((body, (x, y), None, pygame.BLEND_RGB_MAX))
            if blobs is not None:
                glow.append((
                    blobs.blobs[heat_i],
                    (boid.position.x * glow_scale - blobs.half, boid.position.y * glow_scale - blobs.half),
                    None,
                    pygame.BLEND_RGB_MAX,
                ))
        return halos, bodies, scene_bodies, glow
