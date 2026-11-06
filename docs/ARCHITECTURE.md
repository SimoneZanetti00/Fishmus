# Architecture

SynthFish has two halves that talk over OSC on the local machine. The Python half simulates the flock and turns its behaviour into numbers; the Max half makes all the sound.

```
 src/main.py (Python 3.13, pygame)                       Max 9
 ┌──────────────────────────────────────────┐            ┌──────────────────────────────┐
 │ inputs: keyboard, mouse, MIDI, UDP 7500  │            │ PLAUD device (nn~, not here) │
 │   ↓                                      │   OSC      │   /plaud/* → prior~ territory│
 │ boids (alignment, cohesion, separation,  │ ─────────► │   /mix/master → output gain  │
 │        noise, walls, food, predator)     │ UDP 7400   │ max/shoal_fx.maxpat          │
 │   ↓                                      │            │   /fx/* → kick + shake       │
 │ descriptors (0–1, smoothed)              │            │ max/shoal_gran.maxpat        │
 │   ↓                                      │            │   /gran/* → 1 grain voice    │
 │ osc_io → OSC (+ FUDI copy on UDP 7401)   │            │             per fish         │
 │ render → window (thermal or classic)     │            └──────────────────────────────┘
 └──────────────────────────────────────────┘
```

## Modules (`src/`)

| File | Role |
|---|---|
| `main.py` | Command line, main loop, keyboard handling, pads, timing, CSV log |
| `aquarium_boids/config.py` | Ports, MIDI mappings and profiles, window size, frame rate, fish count, send rate, music constants |
| `aquarium_boids/controls.py` | `RuntimeControls`: the live state every input writes to |
| `aquarium_boids/boids.py` | One fish: steering forces and motion |
| `aquarium_boids/descriptors.py` | Flock measures (0–1) and the one-pole smoother |
| `aquarium_boids/osc_io.py` | Every outgoing OSC message, plus the FUDI copy |
| `aquarium_boids/midi_in.py` | MIDI input: device choice, controller profiles, knobs and pads |
| `aquarium_boids/control_in.py` | Plain-text control input on UDP 7500 |
| `aquarium_boids/groove.py` | Groove energy: how densely the bank-B drums are played, as one smoothed 0–1 value (`/drum/energy`) |
| `aquarium_boids/render.py` | Window, letterboxed view, the thermal and classic looks |
| `aquarium_boids/markov.py` | Legacy symbolic note generator (`/music/*`) |
| `tools/send_control_test.py` | Sends a sequence of test controls to UDP 7500 |

## One frame

`main.py` runs at 60 fps. Every frame it:

1. reads the controls that arrived on UDP 7500, the MIDI input and the pads;
2. handles keyboard and window events;
3. works out the **attractor** and the **repeller**:
   - attractor: left mouse at the pointer or the MPK joystick food point (the most recently started wins), otherwise pad 3 or `food_amount > 0.01` at the centre;
   - repeller: right mouse at the pointer, otherwise a pad-2 burst (0.7 s) or `predator_amount > 0.01` at the centre;
4. sends `/fx/predator 1` or `0` when the repeller appears or disappears (strength first on onset);
5. grows or shrinks the flock to the `population` control (1–100);
6. moves every fish (unless paused);
7. computes the descriptors and smooths them;
8. if 1/20 s has passed since the last send, sends the descriptor messages. The gate is checked once per frame. At a steady 60 fps it opens every 4th frame (measured: 450 sends in 1800 frames), so the real rate is about **15 Hz**, not 20;
9. prints a status line every 0.5 s and appends a CSV row to `src/logs/descriptors_<unix time>.csv` every 0.25 s;
10. emits legacy Markov events when they are due;
11. draws the frame.

The simulation world is always 1200 × 750. The window can be any size (`--size`, F11); the view scales the world uniformly and letterboxes it.

## The fish (`boids.py`)

Each fish has a position, a velocity (at most 4 px/frame) and a steering limit (`max_force` 0.055). Its acceleration is the sum of:

| Force | Rule | Weight |
|---|---|---|
| alignment | steer to the mean heading of neighbours within 90 px | `alignment_weight` |
| cohesion | steer to the centre of neighbours within 105 px | `cohesion_weight` |
| separation | steer away from neighbours closer than 38 px | `separation_weight` |
| noise | random vector × `max_force` | `noise_weight` |
| walls | steer inward within 80 px of an edge, × 2.5 | fixed |
| food | steer to the attractor × 0.9 | `food_amount` if > 0, else `food_strength` |
| predator | flee the repeller within 220 px × 2.8, fading with distance | `predator_amount` if > 0, else `predator_strength` |

There is no wrap-around and no hard border: very strong forces can push fish off screen.

## Descriptors (`descriptors.py`)

Computed every frame over the whole flock, then smoothed with a one-pole filter (`state += 0.16 × (value − state)` per frame).

| Name | Definition (before smoothing) |
|---|---|
| `fish_count` | number of fish / 100 |
| `mean_speed` | mean speed / max speed |
| `energy` | **agitation**: mean steering force / (6 × `max_force`). Independent of speed: a fast calm school is low, a scared or jittery one is high |
| `center_x`, `center_y` | centroid, **expanded** around 0.5 by × 2.2 and clipped. The mean of 100 fish rarely leaves 0.3–0.7, so this makes the pan usable |
| `center_x_raw`, `center_y_raw` | centroid / world size, not expanded. Used for PLAUD, so the flock reaches the edges of the map only when it really goes there. Not part of `/aquarium/descriptors` |
| `spread` | mean distance to the centroid / (0.28 × screen diagonal) |
| `nearest_distance` | mean distance to the nearest neighbour / 120 px |
| `density` | 1 − `nearest_distance` (so these two carry the same signal) |
| `direction_coherence` | length of the mean unit heading (1 = all fish swim the same way) |
| `cluster_count` | occupied 180 px grid cells / 12 (a cheap estimate, not real clustering) |

## From descriptors to sound

| Sound | Driven by | How |
|---|---|---|
| PLAUD position | `center_x_raw`, `center_y_raw` | `/plaud/x`, `/plaud/y` → the device's `prior~` territory (y inverted there, because pygame's y points down) |
| PLAUD loudness and components limit | `fish_count` | `/plaud/loudness = 0.6 + 0.8 × fish_count` |
| PLAUD latent L2 | `energy` | `/plaud/temp = clip(0.2 + 1.3 × energy, 0, 1)` (the name is historical) |
| Kick + spectral shake | predator onset / release, strength | `/fx/predator`, `/fx/predator_strength`; `shoal_fx.maxpat` kicks every 800 ms while the scare lasts |
| Grain voices | each fish's x | `/gran/fish_x` (first 32 fish; `shoal_gran.maxpat` uses 16), one voice per fish, panned by x |
| Grain rate and jitter | `fish_count`, agitation, predator, disorder | `/gran/density = 100 × fish_count`; `/gran/noise = clip(1.2·energy + 0.7·predator/3 + 0.2·(1 − coherence))` |
| Mix, pads, transpose | MPK mini 3 | `/mix/*` when a knob moves, `/pad/*` when a pad is hit, `/mix/transpose` when a key is pressed |
| Drums | MPK pad bank B | `/drum/<name> <velocity>` → `shoal_drums.maxpat`; the fish are not affected. `groove.py` turns the hit density into `/drum/energy`; in the Drums device, drums>latent turns hits and energy into short offsets on PLAUD (see [MAX_PATCH_CHANGES.md](MAX_PATCH_CHANGES.md)) |

Design rule: the flock drives a few expressive parameters; everything else in PLAUD stays in the performer's hands.

## Legacy layer: symbolic notes (`markov.py`)

The project began as "fish → descriptors → symbolic music". That layer still runs and still sends `/music/*`, but the SynthFish patches do not use it.

- Two first-order Markov chains:
  - **pitch** over scale degrees 0–6;
  - **rhythm** over half / quarter / eighth / sixteenth / rest.
- Their temperature is `0.25 + 0.9 × density_fader + 0.35 × mean_speed`.
- The rest is not Markov:
  - **velocity** follows `energy`;
  - **octave range** follows `spread`;
  - **layer** (drone, bass, lead, perc, granular, noise) is a weighted choice by section and `density_fader`;
  - **chords** cycle through `[0, 5, 3, 4]` every 16 events;
  - **sections** (intro … outro) are set by hand with keys 1–6.
- Events fire at `0.45 + 5.5 × density_fader + 2 × mean_speed` per second (at most every 80 ms), with no beat grid.
- `/music/midi` converts degrees with `ROOT_MIDI` 57 and `SCALE_INTERVALS` (natural minor) from `config.py`.

## Rendering (`render.py`)

Rendering only reads the simulation; it never changes it.

**Thermal look (default):**
- fish are coloured by heat = speed / max speed;
- trails grow longer with agitation;
- a low-resolution glow follows the fish;
- drifting particles move with `mean_speed`;
- food shows as a teal glow; the predator shows as pulsing rings at its 220 px fear radius.
- Two views: **art** (no text, for recording) and **data** (with a HUD); H switches between them.

**Classic look (`--classic`):** the original flat background, triangle fish and text HUD.

**Drum layer (both looks):** short display-only reactions to bank-B hits, plus the BANK B label. It uses its own random generator, so the simulation's random stream (and the OSC output) is never touched.

## Design notes

These came out of testing during the workshop:
- `energy` used to be a copy of `mean_speed`. It now measures agitation, so it is an independent channel.
- The raw centroid stayed near 0.5, so the pan barely moved. Hence the expanded `center_x/y`.
- The expanded centroid then saturated PLAUD's map halfway across the screen. Hence the separate raw centroid for `/plaud/*`.
- `fish_count` became a live control (1–100) instead of a constant.
- The Max side gets pre-scaled values (`/gran/*`, `/plaud/*`), so the patches do no maths on raw descriptors.
- The OSC contract only grows. New addresses were added without changing old ones, which is why the legacy streams are still there.

## Inspiration

The flocking rules follow Craig Reynolds' boids, as presented in Shivank1006's p5.js sketch [Bird-Flocking-Simulation](https://github.com/Shivank1006/Bird-Flocking-Simulation). From it we took:
- the three forces with live weights;
- the `max_speed` / `max_force` limits;
- the heading-oriented triangle, still used by the classic look.
