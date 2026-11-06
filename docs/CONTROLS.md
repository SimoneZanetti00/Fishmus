# Controls

Keyboard and mouse, MIDI and the UDP control port all work at the same time. Every one of them writes to the same live state (`RuntimeControls` in `src/aquarium_boids/controls.py`).

## Command line

```
python src/main.py [--fullscreen] [--classic] [--mode art|data] [--size WxH]
                   [--no-trails] [--no-glow] [--no-particles]
```

| Option | Effect |
|---|---|
| `--fullscreen` | start fullscreen (a borderless window at desktop size) |
| `--classic` | the original flat look with a text HUD, instead of the thermal look |
| `--mode art` / `--mode data` | thermal look without / with the HUD (default `art`) |
| `--size 1920x1080` | window size (at least 320x200); the simulation is always 1200x750 |
| `--no-trails`, `--no-glow`, `--no-particles` | start with that thermal layer off |

## Keyboard and mouse

| Input | Effect |
|---|---|
| mouse left (hold) | food: fish are drawn to the pointer. If the MPK joystick is also placing food, the most recently started source wins |
| mouse right (hold) | predator: fish flee the pointer (within 220 px); Max gets `/fx/predator 1`, then `0` on release |
| `-` / `=` | fewer / more fish (steps of 5, 1–100) |
| `A`/`Z`, `S`/`X`, `D`/`C` | alignment, cohesion, separation up / down (steps of 0.1) |
| `N`/`M` | noise up / down (steps of 0.03) |
| `SPACE` | pause / resume the simulation |
| `R` | new flock (keeps the current number of fish) |
| `UP`/`DOWN` | `density_fader` ± 0.05 (legacy Markov layer only) |
| `1`–`6` | section: intro, growth, dense, chaos, release, outro (legacy Markov layer only) |
| `H` | thermal look: art view ↔ data view (HUD) |
| `T` / `G` / `P` | thermal look: trails / glow / particles on or off |
| `F11` | fullscreen on / off |
| `ESC` | quit (sends `/fx/predator 0` first) |

The keyboard has no upper limit on the weights, unlike MIDI and UDP, which clip.

## AKAI MPK mini 3

**Controller settings:** select **bank A**. Then:
- the knobs K1–K8 send CC 16–23 on channel 1;
- the pads send note-on 16–23 on channel 10 (pad mode NOTE) or Program Change 16–23 (pad mode PROG CHANGE). Both are accepted; notes on any channel;
- the joystick sends CC 80 (x, 0 = left, 127 = right) and CC 81 (y) on channel 1, resting at about 64;
- the keys send note-on 48–72 on channel 1 (middle C = 60), with a real note-off on release.

**Knobs** (from `MIDI_CC_MAPPING_MPK` in `config.py`). A parameter that starts with `/` is not a simulation control: it is sent to Max as that OSC address whenever the knob moves.

| Knob | CC | Controls | Range |
|---|---|---|---|
| K1 | 16 | grain length → `/mix/grain_ms` | 10–400 ms |
| K2 | 17 | agitation (`noise_weight`) | 0–1.5 |
| K3 | 18 | `cohesion_weight` | 0–3 |
| K4 | 19 | number of fish (`population`) | 1–100 |
| K5 | 20 | grain gain → `/mix/gran_gain` | 0–1 |
| K6 | 21 | slice gain → `/mix/slice_gain` | 0–1 |
| K7 | 22 | PLAUD wet level (the gain into the effect) → `/mix/wet` | 0–1 |
| K8 | 23 | PLAUD dry level → `/mix/master` | 0–1 |

Alignment stays at 1.0 with this controller. The predator is on pad 2 and the right mouse button. The kick level is no longer on a knob: it stays at the value set in `shoal_fx.maxpat`.

**Pads:**

| Pad | Action |
|---|---|
| 1 | one kick (`/pad/kick`) |
| 2 | scare: a predator at the centre for 0.7 s (same path as the right mouse button, so Max gets the predator events). That is shorter than the 800 ms kick repeat in `shoal_fx.maxpat`, so a pad hit gives exactly one kick; holding the right mouse button still repeats every 800 ms |
| 3 | food at the centre, on / off |
| 4 | calm: removes pad food, the scare and any fader-set food or predator |
| 5–8 | play slice 1–4 of the grain source (`/pad/sample 1–4`) |

Note-off and note-on with velocity 0 are ignored. Notes outside 16–23 are ignored as pads (the keys below use 48–72 on channel 1).

**Joystick:** steers a food point, through the same path as the left mouse button.
- Inside the dead zone (both axes within 64 ± 8, `JOY_DEAD_ZONE`) there is no joystick food; returning there removes it.
- Outside it, the food sits at the screen centre plus the deflection: full deflection is 60 px from the edge (`JOY_MARGIN`). The food glides there (`JOY_SMOOTHING`); an axis inside the dead zone counts as 0.
- `JOY_INVERT_Y = False` means CC 81 = 127 is up; set it to `True` if up and down are reversed on your controller.
- If the mouse is also placing food, the most recently started source wins.

**Keys:** a key 48–72 on channel 1 sets the transpose of the grain source to note − 60 semitones (−12…+12) and sends `/mix/transpose`. It stays latched until the next key; releasing the key does nothing. Other notes on channel 1 are ignored.

**Pad bank B (drums):** switch the MPK to pad bank B. The pads then send note-on 32–39 on channel 10, velocity-sensitive (pad 1 = 32 … pad 8 = 39).

| Pad | Drum |
|---|---|
| 1 | kick |
| 2 | snare |
| 3 | hi-hat |
| 4 | dirty |
| 5 | slice (a burst of the grain source) |
| 6 | open hat |
| 7 | clap |
| 8 | perc |

- Each hit sends `/drum/<name> <velocity 0–1>` to `max/shoal_drums.maxpat` and starts a short reaction on screen. The reactions are display only: they never move the fish, so the descriptors are not affected.
- A **BANK B** label (top right) shows while the last pad you hit was in bank B. The MPK sends nothing when you switch banks, so the label follows your last hit.
- Bank A, the knobs, the joystick and the keys work as before.

## AKAI MIDIMIX

The 8 faders control the ecosystem (`MIDI_CC_MAPPING` in `config.py`). Alignment stays at 1.0.

| Fader | CC | Parameter | Range |
|---|---|---|---|
| 1 | 19 | number of fish (`population`) | 1–100 |
| 2 | 23 | `cohesion_weight` | 0–3 |
| 3 | 27 | `separation_weight` | 0–4 |
| 4 | 31 | `noise_weight` | 0–1.5 |
| 5 | 49 | `food_amount` (attractor at the centre) | 0–3 |
| 6 | 53 | `predator_amount` (repeller at the centre) | 0–3 |
| 7 | 57 | `density_fader` (legacy Markov layer) | 0–1 |
| 8 | 61 | `section_id` (legacy Markov layer) | 0–5 |

## Which device and which mapping

At start Python lists every MIDI input (`[midi] input device N: <name>`). It then chooses the device and the mapping like this:

1. **Device:**
   - the first input whose name contains `MIDI_INPUT_NAME` (default `"MIDIMIX"`, case-insensitive);
   - otherwise the **first** input ("fallback").
2. **Mapping:** taken from the name of the device it opened:
   - a name containing `MPK` → the MPK profile;
   - anything else → the MIDIMIX table.
3. The terminal confirms the choice: `[midi] active profile: …`.

So with only the MPK connected you get the MPK profile. With both controllers connected, the MIDIMIX wins.

With `MIDI_DEBUG = True` (the default), every message is printed:
- `[midi] cc=X value=Y channel=Z`: a raw knob or fader;
- `[midi-map] cc=X -> parameter = value`: the mapped result;
- `[pad] n  (program P, channel C)` or `[pad] n  (note N, channel C)`: a pad;
- `[key] note N -> transpose +k`: a key;
- `[drum] name v=…  (note N, channel C)`: a bank-B drum hit;
- `[midi] note on/off …: ignored`: a note that is neither a pad nor a key.

The joystick (CC 80 / 81) is not printed: it sends a continuous stream and would flood the terminal.

### Re-mapping a control

1. Move the knob or fader and read `cc=X` in the terminal.
2. In `src/aquarium_boids/config.py`, edit the right table. Each entry is `cc: ("parameter", min, max, round_to_int)`.
3. Restart.

### MIDI troubleshooting

| Symptom | Check |
|---|---|
| no `[midi] listening to …` line | Another program (Max, a DAW) may hold the controller: close it, unplug and replug, restart. Python opens the device itself; Max must not read it |
| the wrong device opened (`… fallback`) | Set `MIDI_INPUT_NAME` in `config.py` to part of the name printed at start |
| `[midi] cc=…` lines but no `[midi-map]` | That CC is not in the active table: re-map it |
| MPK pads print `note on N … ignored` or `program=N … not a pad` | The pads are not on bank A (they send numbers outside 16–23) |
| joystick food appears with the stick at rest | Raise `JOY_DEAD_ZONE` in `config.py` (the stick may rest a few values away from 64) |
| joystick up moves the food down | Set `JOY_INVERT_Y = True` in `config.py` |

## UDP control port 7500

Any program can set controls with plain-text UDP messages such as `control cohesion_weight 2.2;`. The format and the accepted names are listed in [OSC.md](OSC.md#control-input-on-port-7500).

To try it: run `python src/tools/send_control_test.py` while the simulation runs.

## Defaults

| Control | Default |
|---|---|
| number of fish | 100 |
| `alignment_weight` | 1.0 |
| `cohesion_weight` | 0.9 |
| `separation_weight` | 1.35 |
| `noise_weight` | 0.18 |
| `food_strength`, `predator_strength` (mouse) | 1.0 |
| `food_amount`, `predator_amount` (centre) | 0 |
| `density_fader` | 0.25 |
| section | 0 (intro) |
