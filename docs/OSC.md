# OSC and network messages

All traffic stays on the local machine (`127.0.0.1`).

| Port | Direction | Format | Used for |
|---|---|---|---|
| 7400 | Python → Max | OSC (UDP) | everything below |
| 7401 | Python → Max | FUDI text (`name values;`) | legacy copy of the main streams, for Max without `[oscparse]` |
| 7500 | Max / anything → Python | plain text | live controls (see the end of this page) |

Rates:
- **Descriptor-rate** messages go out together about 15 times per second (a 1/20 s gate checked once per 60 fps frame).
- **Event** messages go out when something happens.

All values are floats unless noted.

## Used by the SynthFish setup

### PLAUD (`/plaud/*`): descriptor rate

| Address | Range | Meaning |
|---|---|---|
| `/plaud/x` | 0–1 | raw flock centroid, horizontal. The device sends it to `prior~` territory_x |
| `/plaud/y` | 0–1 | raw flock centroid, vertical (0 = top). The device inverts it (`!- 1.`) for territory_y |
| `/plaud/loudness` | 0.6–1.4 | `0.6 + 0.8 × fish_count`. In the device: PLAUD loudness and its "components" limit |
| `/plaud/temp` | 0.2–1.0 | `clip(0.2 + 1.3 × energy)`. In the device: latent L2 (the name is historical) |
| `/plaud/xy` | [x, y] | same as above, as a pair. Not routed by the device |
| `/plaud/latent` | [x, y, spread, mean_speed] | 4-vector for direct latent driving. Not routed by the device |

### Predator effects (`/fx/*`)

| Address | Range | When | Meaning |
|---|---|---|---|
| `/fx/predator` | int 1 / 0 | on change | the scare starts / ends. 0 is also sent when the window closes or on ESC |
| `/fx/predator_strength` | 0–1 | before each onset, then at descriptor rate while active | the force the fish feel: `predator_amount` if > 0, else `predator_strength`, / 3 |

### Granulator (`/gran/*`): descriptor rate

| Address | Range | Meaning |
|---|---|---|
| `/gran/fish_x` | list of up to 32 floats, 0–1 | x of each fish in flock order (voice i = fish i). The list length is the number of fish |
| `/gran/density` | 0–100 | `100 × fish_count` (grain rate) |
| `/gran/noise` | 0–1 | `clip(1.2·energy + 0.7·predator_amount/3 + 0.2·(1 − direction_coherence))` (grain jitter and region spread) |
| `/gran/pan` | −1–1 | `2 × center_x − 1` (expanded centroid). Legacy granulator |
| `/gran/nchan` | int 1–48 | `1 + round(47 × fish_count)`. Legacy granulator |
| `/gran` | [pan, density, nchan, noise] | the four values above in one message |

### Mix and pads (`/mix/*`, `/pad/*`): only when a control is used

| Address | Range | Source | Meaning |
|---|---|---|---|
| `/mix/master` | 0–1 | MPK K8 | PLAUD dry level: the output gain (the device maps it to −70…0 dB) |
| `/mix/wet` | 0–1 | MPK K7 | PLAUD wet level: the gain into the effect (`vst~`), −70…0 dB, smoothed like `/mix/master` |
| `/mix/gran_gain` | 0–1 | MPK K5 | granulator master gain |
| `/mix/slice_gain` | 0–1 | MPK K6 | slice player gain |
| `/mix/grain_ms` | 10–400 | MPK K1 | grain length in ms |
| `/mix/transpose` | int −12–12 | MPK keys 48–72 | transpose of the grain source in semitones (note − 60), latched until the next key; grains and slices |
| `/mix/kick_gain` | 0–1 | — | kick level (synth and sample). The device and `shoal_fx.maxpat` still accept it, but no controller sends it now |
| `/pad/kick` | no arguments | MPK pad 1 | one kick now |
| `/pad/sample` | int 1–4 | MPK pads 5–8 | play slice 1–4 of the grain source |

### Drums (`/drum/*`): when a bank-B pad is hit

| Address | Range | Source | Meaning |
|---|---|---|---|
| `/drum/kick`, `/drum/snare`, `/drum/hihat`, `/drum/dirty`, `/drum/slice`, `/drum/openhat`, `/drum/clap`, `/drum/perc` | 0–1 | MPK pad bank B, pads 1–8 | one hit, with the pad velocity (velocity / 127) |
| `/drum/energy` | 0–1 | bank-B hits | groove energy: hits over the last 2 s (16 = 1.0), smoothed. Sent at the descriptor rate only once bank B has been used, while it is above 0, then one final 0. Back to 0 about 2.7 s after the last hit |

In the Drums set, the device routes all nine to `s drumKick` … `s drumPerc` and `s drumEnergy` (see [MAX_PATCH_CHANGES.md](MAX_PATCH_CHANGES.md)).

## Legacy streams (still sent, not used by SynthFish)

Kept so that nothing that listened to them before breaks.

### Flock state: descriptor rate

| Address | Values |
|---|---|
| `/aquarium/descriptors` | 10 values in this order: `fish_count mean_speed energy center_x center_y spread density nearest_distance direction_coherence cluster_count` (all 0–1; definitions in [ARCHITECTURE.md](ARCHITECTURE.md#descriptors-descriptorspy)) |
| `/aquarium/descriptor/<name>` | the same 10, one address each |
| `/aquarium/direct` | `mean_speed energy center_x center_y density spread density_fader` |
| `/aquarium/controls` | `density_fader alignment cohesion separation noise food_strength predator_strength food_amount predator_amount section_id` |
| `/aquarium/section` | `section_id section_name` (0 intro, 1 growth, 2 dense, 3 chaos, 4 release, 5 outro) |

Note: `density` is `1 − nearest_distance`, so these two carry the same signal.

### Symbolic notes (`/music/*`): when an event is due

| Address | Values |
|---|---|
| `/music/event` | `event_id type degree octave duration_beats velocity layer_id chord_degree section_id` (type 1 = note, 0 = rest) |
| `/music/note` | `event_id degree octave duration_beats velocity layer_id layer_name chord_degree section_id` |
| `/music/midi` | `event_id midi_note velocity duration_ms layer_id section_id` |
| `/music/rest` | `event_id duration_beats section_id` |

Further details:
- `degree` and `chord_degree` are scale degrees, not MIDI notes.
- `/music/midi` converts them with `ROOT_MIDI` (57 = A) and `SCALE_INTERVALS` (natural minor) from `config.py`.
- Layers: 0 drone, 1 bass, 2 lead, 3 perc, 4 granular, 5 noise.
- Durations use `BPM` 120.

### FUDI copy on port 7401

Each of these is also sent as text, for `[netreceive -u 7401]`, e.g. `direct 0.31 0.12 …;`.

| Label | Copy of |
|---|---|
| `descriptors` | `/aquarium/descriptors` |
| `controls` | `/aquarium/controls` |
| `section` | `/aquarium/section` |
| `direct` | `/aquarium/direct` |
| `gran` | `/gran` |
| `plaud` | `/plaud/latent` |
| `event` | `/music/event` |
| `note` | `/music/note` |
| `midi` | `/music/midi` |
| `rest` | `/music/rest` |

## Control input on port 7500

Python listens on UDP 7500 for plain-text lines (not OSC), one or more per packet, separated by `;` or newlines:

```
control density_fader 0.75;
control section_id chaos;
cohesion 2.2;
```

The word `control` is optional. Values are clipped to the ranges below; `src/tools/send_control_test.py` sends a test sequence.

| Name (aliases) | Range |
|---|---|
| `density_fader` (`density`, `granularity`) | 0–1 |
| `alignment_weight` (`alignment`, `align`) | 0–3 |
| `cohesion_weight` (`cohesion`) | 0–3 |
| `separation_weight` (`separation`, `sep`) | 0–4 |
| `noise_weight` (`noise`, `turbulence`) | 0–1.5 |
| `food_amount` (`food`, `attractor`) | 0–3 |
| `food_strength` (`mouse_food_strength`) | 0–3 |
| `predator_amount` (`predator`, `repeller`) | 0–3 |
| `predator_strength` (`mouse_predator_strength`) | 0–3 |
| `section_id` (`section`) | 0–5, or a section name |
| `paused` | ≥ 0.5 pauses |
