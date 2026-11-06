from __future__ import annotations

import argparse
import csv
import random
import sys
import time
from pathlib import Path

import pygame
from pygame.math import Vector2

from aquarium_boids.boids import Boid
from aquarium_boids.config import (
    BOID_COUNT,
    BPM,
    CONTROL_PORT,
    ENABLE_MIDI_INPUT,
    FPS,
    GRAN_MAX_VOICES,
    HEIGHT,
    JOY_DEAD_ZONE,
    JOY_INVERT_Y,
    JOY_MARGIN,
    JOY_SMOOTHING,
    MIDI_CC_MAPPING,
    MIDI_DEBUG,
    MIDI_INPUT_NAME,
    MIDI_PROFILES,
    OSC_HOST,
    OSC_PORT,
    PAD_PREDATOR_BURST_S,
    SEND_DESCRIPTOR_HZ,
    WIDTH,
)
from aquarium_boids.control_in import ControlReceiver
from aquarium_boids.controls import RuntimeControls, clamp01
from aquarium_boids.descriptors import DESCRIPTOR_ORDER, OnePoleSmoother, compute_descriptors
from aquarium_boids.markov import LAYERS, SECTIONS, SymbolicGenerator
from aquarium_boids.midi_in import MidiControllerInput
from aquarium_boids.osc_io import OscSender
from aquarium_boids.render import ClassicRenderer, Display, ThermalRenderer


BASE_DIR = Path(__file__).resolve().parent


def create_flock(count: int) -> list[Boid]:
    return [Boid.create(i, WIDTH, HEIGHT) for i in range(count)]


def resize_flock(flock: list[Boid], target: int) -> list[Boid]:
    """Grow or shrink the flock in place to `target` fish (1..BOID_COUNT).

    Lets the number of fish be a live control (keyboard -/= or MIDIMIX fader),
    so fish_count -> granular density/probability actually varies.
    """
    target = max(1, min(BOID_COUNT, int(target)))
    if len(flock) > target:
        del flock[target:]
    elif len(flock) < target:
        for i in range(len(flock), target):
            flock.append(Boid.create(i, WIDTH, HEIGHT))
    return flock


def write_log_header(path: Path) -> None:
    path.parent.mkdir(exist_ok=True)
    if not path.exists():
        with path.open("w", newline="", encoding="utf-8") as f:
            writer = csv.writer(f)
            writer.writerow(["time", *DESCRIPTOR_ORDER, "density_fader", "section"])


def append_log(path: Path, now: float, descriptors: dict[str, float], controls: RuntimeControls) -> None:
    with path.open("a", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow([
            f"{now:.3f}",
            *[f"{descriptors.get(key, 0.0):.5f}" for key in DESCRIPTOR_ORDER],
            f"{controls.density_fader:.5f}",
            controls.section_name,
        ])


def handle_key(event: pygame.event.Event, controls: RuntimeControls, flock: list[Boid]) -> list[Boid]:
    step = 0.05
    if event.key == pygame.K_ESCAPE:
        pygame.quit()
        sys.exit(0)
    if event.key == pygame.K_SPACE:
        controls.paused = not controls.paused
    elif event.key == pygame.K_UP:
        controls.density_fader = clamp01(controls.density_fader + step)
    elif event.key == pygame.K_DOWN:
        controls.density_fader = clamp01(controls.density_fader - step)
    elif event.key == pygame.K_a:
        controls.alignment_weight += 0.1
    elif event.key == pygame.K_z:
        controls.alignment_weight = max(0.0, controls.alignment_weight - 0.1)
    elif event.key == pygame.K_s:
        controls.cohesion_weight += 0.1
    elif event.key == pygame.K_x:
        controls.cohesion_weight = max(0.0, controls.cohesion_weight - 0.1)
    elif event.key == pygame.K_d:
        controls.separation_weight += 0.1
    elif event.key == pygame.K_c:
        controls.separation_weight = max(0.0, controls.separation_weight - 0.1)
    elif event.key == pygame.K_n:
        controls.noise_weight += 0.03
    elif event.key == pygame.K_m:
        controls.noise_weight = max(0.0, controls.noise_weight - 0.03)
    elif event.key == pygame.K_MINUS:
        controls.population = max(1, controls.population - 5)
    elif event.key == pygame.K_EQUALS:
        controls.population = min(BOID_COUNT, controls.population + 5)
    elif event.key == pygame.K_r:
        return create_flock(controls.population)
    elif pygame.K_1 <= event.key <= pygame.K_6:
        controls.section_id = event.key - pygame.K_1
    return flock


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="SynthFish: a flock of fish -> OSC -> Max")
    parser.add_argument(
        "--classic",
        action="store_true",
        help="original look (flat background, triangle fish, text HUD) instead of the thermal look",
    )
    parser.add_argument(
        "--mode",
        choices=ThermalRenderer.MODES,
        default="art",
        help="thermal look: 'art' = no text (default, for recording), 'data' = with HUD; H toggles",
    )
    parser.add_argument("--no-trails", action="store_true", help="thermal look: start without trails (T toggles)")
    parser.add_argument("--no-glow", action="store_true", help="thermal look: start without glow (G toggles)")
    parser.add_argument(
        "--no-particles", action="store_true", help="thermal look: start without drifting particles (P toggles)"
    )
    parser.add_argument(
        "--size",
        type=parse_size,
        default=(WIDTH, HEIGHT),
        metavar="WxH",
        help=f"window size, e.g. 1920x1080 (default {WIDTH}x{HEIGHT}); the simulation stays {WIDTH}x{HEIGHT}",
    )
    parser.add_argument("--fullscreen", action="store_true", help="start fullscreen (F11 toggles)")
    return parser.parse_args(argv)


def parse_size(text: str) -> tuple[int, int]:
    try:
        w, h = (int(part) for part in text.lower().split("x"))
    except ValueError:
        raise argparse.ArgumentTypeError(f"expected WxH, e.g. 1920x1080, got {text!r}")
    if w < 320 or h < 200:
        raise argparse.ArgumentTypeError("size must be at least 320x200")
    return (w, h)


def main(argv: list[str] | None = None) -> None:
    args = parse_args(argv)
    pygame.init()
    display = Display((WIDTH, HEIGHT), args.size, "SynthFish - boids -> OSC -> Max", fullscreen=args.fullscreen)
    clock = pygame.time.Clock()
    font = pygame.font.SysFont("consolas", 16)
    renderer = (
        ClassicRenderer(font)
        if args.classic
        else ThermalRenderer(
            font,
            mode=args.mode,
            trails=not args.no_trails,
            glow=not args.no_glow,
            particles=not args.no_particles,
        )
    )

    controls = RuntimeControls()
    flock = create_flock(BOID_COUNT)
    smoother = OnePoleSmoother(alpha=0.16)
    osc = OscSender(OSC_HOST, OSC_PORT)
    generator = SymbolicGenerator()
    control_receiver = ControlReceiver(port=CONTROL_PORT)
    control_receiver.start()
    print(f"Listening for Max/MIDIMIX controls on UDP {CONTROL_PORT}")

    midi_input = MidiControllerInput(
        device_name=MIDI_INPUT_NAME,
        mapping=MIDI_CC_MAPPING,
        debug=MIDI_DEBUG,
        profiles=MIDI_PROFILES,
        joy_dead_zone=JOY_DEAD_ZONE,
        joy_invert_y=JOY_INVERT_Y,
    )
    if ENABLE_MIDI_INPUT:
        midi_input.start()
    print(f"[midi] active profile: {midi_input.profile_name if ENABLE_MIDI_INPUT else 'none (MIDI disabled in config)'}")

    log_path = BASE_DIR / "logs" / f"descriptors_{int(time.time())}.csv"
    write_log_header(log_path)

    last_descriptor_send = 0.0
    last_log = 0.0
    last_print = 0.0
    next_event_time = 0.0
    descriptors: dict[str, float] = {}
    gran = [0.0, 0.0, 1, 0.0]
    plaud_xy = (0.0, 0.0)
    predator_active = False
    predator_burst_until = 0.0  # pad 2
    food_pad_on = False  # pad 3
    joy_food: Vector2 | None = None  # MPK joystick food point (smoothed), None while the stick rests
    joy_food_since = 0.0
    mouse_food_since = 0.0
    mouse_left_was = False

    while True:
        dt = clock.tick(FPS) / (1000.0 / FPS)
        now = time.time()

        applied_controls = control_receiver.drain(controls)
        for command in applied_controls:
            print(f"[control] {command.name} = {command.value}")

        midi_controls = midi_input.poll(controls)
        for command in midi_controls:
            print(f"[midi-map] cc={command.cc} -> {command.parameter} = {command.scaled_value}")
            if command.parameter.startswith("/"):  # knob mapped to a Max mix level, not to the flock
                osc.send_mix(command.parameter, command.scaled_value)

        for pad in midi_input.take_pads():  # only controllers whose profile defines pads (MPK)
            if pad == 1:
                osc.send_pad_kick()
            elif pad == 2:  # predator at the centre for a moment: same path as the mouse right button
                predator_burst_until = now + PAD_PREDATOR_BURST_S
            elif pad == 3:  # food at the centre on/off
                food_pad_on = not food_pad_on
            elif pad == 4:  # clear food and predator
                food_pad_on = False
                predator_burst_until = 0.0
                controls.food_amount = 0.0
                controls.predator_amount = 0.0
            elif 5 <= pad <= 8:
                osc.send_pad_sample(pad - 4)

        for name, velocity in midi_input.take_drums():  # MPK pad bank B: drum hits for Max, display-only visuals
            osc.send_drum(name, velocity)
            renderer.drum_hit(name, velocity, flock)
        renderer.drums.bank_b = midi_input.last_bank == "B"

        transpose = midi_input.take_transpose()  # MPK keys: latched transpose for the grain source
        if transpose is not None:
            osc.send_transpose(transpose)

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                osc.send_fx_predator(False)  # never leave Max in a predator scare
                pygame.quit()
                return
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    osc.send_fx_predator(False)  # handle_key quits on ESC
                if event.key == pygame.K_F11:
                    display.toggle_fullscreen()
                    continue
                if renderer.handle_key(event.key):
                    continue
                flock = handle_key(event, controls, flock)

        mouse_buttons = pygame.mouse.get_pressed(num_buttons=3)
        mouse_pos = display.view.to_world(pygame.mouse.get_pos())
        attractor = mouse_pos if mouse_buttons[0] else None
        if mouse_buttons[0] and not mouse_left_was:
            mouse_food_since = now
        mouse_left_was = mouse_buttons[0]
        # MPK joystick: food at centre + deflection (full = near the edge), glides there, gone in the dead zone.
        joy = midi_input.joystick()
        if joy is None:
            joy_food = None
        else:
            target = Vector2(WIDTH * 0.5 + joy[0] * (WIDTH * 0.5 - JOY_MARGIN),
                             HEIGHT * 0.5 - joy[1] * (HEIGHT * 0.5 - JOY_MARGIN))  # joystick up = screen up
            if joy_food is None:
                joy_food = Vector2(WIDTH * 0.5, HEIGHT * 0.5)
                joy_food_since = now
            joy_food += (target - joy_food) * JOY_SMOOTHING
        if joy_food is not None and (attractor is None or joy_food_since > mouse_food_since):
            attractor = Vector2(joy_food)  # same food path as the mouse; the most recent source wins
        repeller = mouse_pos if mouse_buttons[2] else None
        if attractor is None and food_pad_on:
            attractor = Vector2(WIDTH * 0.5, HEIGHT * 0.5)
        if repeller is None and now < predator_burst_until:
            repeller = Vector2(WIDTH * 0.5, HEIGHT * 0.5)
        if attractor is None and controls.food_amount > 0.01:
            attractor = Vector2(WIDTH * 0.5, HEIGHT * 0.5)
        if repeller is None and controls.predator_amount > 0.01:
            repeller = Vector2(WIDTH * 0.5, HEIGHT * 0.5)

        # Predator scare onset/release for Max: the same state the boids react to (repeller set).
        if (repeller is not None) != predator_active:
            predator_active = repeller is not None
            if predator_active:
                osc.send_fx_predator_strength(controls)  # so Max has the strength before the first kick
            osc.send_fx_predator(predator_active)

        flock = resize_flock(flock, controls.population)

        if not controls.paused:
            for boid in flock:
                boid.flock(flock, controls, WIDTH, HEIGHT, attractor=attractor, repeller=repeller)
            for boid in flock:
                boid.update(dt_scale=dt)

        descriptors = smoother.process(compute_descriptors(flock, WIDTH, HEIGHT))

        if now - last_descriptor_send >= 1.0 / SEND_DESCRIPTOR_HZ:
            osc.send_descriptors(descriptors)
            osc.send_controls(controls)
            osc.send_direct_mapping(descriptors, controls)
            gran = osc.send_granular(descriptors, controls)
            plaud_xy = osc.send_plaud(descriptors)
            if predator_active:
                osc.send_fx_predator_strength(controls)
            osc.send_fish_x(flock, WIDTH, GRAN_MAX_VOICES)
            last_descriptor_send = now

        # Clean terminal readout: granular controls + PLAUD latent point (~2x/sec).
        if now - last_print >= 0.5:
            pan, density, nchan, noise = gran
            px, py = plaud_xy
            print(
                f"GRAN fish={controls.population:3d} density={density:5.1f} nchan={nchan:2d} noise={noise:.2f}  "
                f"|  PLAUD x={px:+.2f} y={py:+.2f}  |  coherence={descriptors.get('direction_coherence', 0):.2f} "
                f"spread={descriptors.get('spread', 0):.2f}"
            )
            last_print = now

        if now - last_log >= 0.25:
            append_log(log_path, now, descriptors, controls)
            last_log = now

        # Event rate: collective/slow at low density, granular/fast at high density and high fish speed.
        if now >= next_event_time:
            burst = 1 + int(controls.density_fader * 3.2)
            for _ in range(burst):
                event = generator.generate(descriptors, controls)
                osc.send_music_event(event)
                if event.event_type == "note" and flock:
                    random.choice(flock).flash = 1.0
            events_per_second = 0.45 + controls.density_fader * 5.5 + descriptors.get("mean_speed", 0.0) * 2.0
            next_event_time = now + max(0.08, 1.0 / events_per_second)

        renderer.draw(display.canvas, display.view, flock, attractor, repeller, controls, descriptors)
        pygame.display.flip()


if __name__ == "__main__":
    main()
