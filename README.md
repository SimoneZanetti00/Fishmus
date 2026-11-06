# SynthFish

A flock of simulated fish performs **PLAUD**, a DDSP neural synthesis model trained on about
30 minutes of recordings by the musician Rafael. Nobody plays notes or writes prompts. The fish
swim, and their collective behaviour (where the flock is, how agitated it is, when a predator
scatters it) drives the model live. The performer shapes the ecosystem (food, predators,
cohesion, number of fish), and the sound follows the flock.

SynthFish is the name used in the demo video; the repository is called Fishmus, and the project started as Generative Boids / Musish at the Barcelona workshop.

**Demo video:** <https://youtu.be/3ueGfejkkj8>

## How it works

```
 boids simulation (Python / pygame)
   |  alignment, cohesion, separation, noise, food, predator
   v
 flock descriptors, 0-1, ~15 Hz
   |  position, spread, speed, energy, density, coherence, fish count, per-fish x
   v
 OSC over UDP -> 127.0.0.1:7400
   v
 Max/MSP
   |- PLAUD (nn~)        flock position steers PLAUD's prior territory;
   |                     fish count -> loudness, agitation -> latent L2
   |- max/shoal_fx       predator events -> a kick (with reverb) + a spectral shake of PLAUD
   '- max/shoal_gran     each fish is a grain voice, panned by its x position

 AKAI MPK mini 3 (MIDI) -> live control of the flock and of the mix
```

## Quick start (no Max needed)

Needs Python 3.13 (tested on Windows).

```
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
python src/main.py
```

Without Max the simulation runs normally, and the OSC packets simply go unanswered.

| Input | Action |
|---|---|
| mouse left (hold) | food: the fish are attracted to the pointer |
| mouse right (hold) | predator: the fish flee from the pointer; Max receives a scare event |
| `-` / `=` | fewer / more fish |
| H | art view (no text) / data view (HUD with descriptors) |
| T / G / P | trails / glow / drifting particles on or off |
| F11 | fullscreen on/off |
| ESC | quit |

Options:
- `--fullscreen`: start fullscreen.
- `--classic`: the original flat look.
- `--size 1920x1080`: set the window size; the simulation itself is always 1200x750.

All keys and options are listed in [docs/CONTROLS.md](docs/CONTROLS.md).

## With Max

**What you need:**
- Max 9.
- The `nn~` external.
- A PLAUD device and a trained PLAUD model. PLAUD is by Błażej Kotowski and is **not included**
  in this repository.

**Setup, in three steps:**
1. In the PLAUD device, add `[udpreceive 7400]` with one `route` for each address family: `/plaud/*`, `/fx/*`, `/gran/*`, `/mix/*`, `/pad/*`.
2. In `prior~`, connect the flock position to the territory. Also switch off prior~'s own random walk.
3. Open `max/shoal_fx.maxpat` (predator kick, spectral shake and reverb) and `max/shoal_gran.maxpat` (one grain voice per fish).

No audio is shipped. Put your own `shoal_kick.wav` and `shoal_gran.aiff` next to the patches. To switch sources live, put your own sounds in `max/grains/` and pick them from the menu.

The exact routes, sends and prior~ edits are in [docs/MAX_SETUP.md](docs/MAX_SETUP.md). Every OSC address is in [docs/OSC.md](docs/OSC.md).

## Live control: AKAI MPK mini 3

Use **bank A**; the pads work in either pad mode (NOTE or PROG CHANGE). The mapping profile is chosen
automatically from the MIDI device name.
- **Knobs:** grain length, agitation, cohesion, number of fish, grain gain, slice gain, PLAUD wet, PLAUD dry.
- **Pads:** kick, scare, food, calm, and four slices of the grain source.
- **Joystick:** steers a food point around the screen; at rest, no food.
- **Keys:** transpose the grain source by −12…+12 semitones (latched until the next key).
- **Pad bank B:** eight drums, see [Drums (bank B)](#drums-bank-b) below.

The full tables, and the alternative AKAI MIDIMIX mapping, are in [docs/CONTROLS.md](docs/CONTROLS.md).

## Drums (bank B)

On the `drums` branch, the MPK's pad **bank B** plays eight drums in `max/shoal_drums.maxpat`. Bank A, the knobs, the
joystick and the keys keep working as before, and nothing changes while bank B is not used.

| Pad | Drum | With drums>latent on, it also… |
|---|---|---|
| 1 | kick | pushes PLAUD's posterior ch1, and the prior territory down |
| 2 | snare | pushes posterior ch2, and the prior territory right |
| 3 | hi-hat | pushes posterior ch3 (short) |
| 4 | dirty | bends Stretch and Limit (*bend*) and Shape (*grit*) |
| 5 | slice (a burst of the grain source) | reseeds the prior: a fresh phrase |
| 6 | open hat | pushes posterior ch3 (short) |
| 7 | clap | pushes posterior ch4 |
| 8 | perc | pushes posterior ch4 |

- **On screen:** each hit draws a short reaction. It is display only, so the fish and the sound descriptors are not affected.
- **Groove energy:** Python also sends how densely you play (`/drum/energy`, 0–1, smoothed). While you play, it gently raises Stretch/Limit and the prior temperature; about 2.7 s after you stop it is back to 0.

**drums>latent** is a toggle in the Drums copy of the PLAUD device, always off at load. With it off, the drums only make sound.

With it on, every hit adds a short offset on top of your own setting and glides back to it exactly. A hit never writes a dial, so rapid hits cannot "stick".

The **drums** panel next to the toggle sets:
- *amount* (posterior hits), *decay* (0.2–2 s), *grit* (Shape), *bend* (Stretch/Limit);
- *push* (prior territory), *reseed* (on slice), *E>tmp* and *E>bend* (groove energy);
- one on/off per pad group.

The device changes are listed in [docs/MAX_PATCH_CHANGES.md](docs/MAX_PATCH_CHANGES.md), since the device is not in this repository.

**Start the drums version:**
1. `git switch drums`, then `.venv\Scripts\activate` and `python src/main.py`.
2. In Max, open `PLAUD_Simo_DEV2-2.amxd.maxpat`, `shoal_fx.maxpat`, `shoal_gran.maxpat` and `shoal_drums.maxpat` from the Drums working copy (`PLAUD_Drums_work\patchers\`), then turn DSP on.
3. Switch the MPK to pad bank B, and turn on drums>latent if you want the drums to move PLAUD.

Drum samples live in `drums\` next to that `patchers\` folder, outside the repository; see [docs/MAX_SETUP.md](docs/MAX_SETUP.md#the-drums-set).

## Documentation

| Page | Contents |
|---|---|
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | modules, the frame loop, the boid forces, what each descriptor measures, how it reaches the sound |
| [docs/OSC.md](docs/OSC.md) | every OSC address with its range, plus the control input on UDP 7500 |
| [docs/CONTROLS.md](docs/CONTROLS.md) | keyboard, mouse, command line, MPK mini 3, MIDIMIX, troubleshooting |
| [docs/MAX_SETUP.md](docs/MAX_SETUP.md) | the PLAUD device routes, the prior~ edits, the `shoal_fx`, `shoal_gran` and `shoal_drums` patches, the Drums set |
| [docs/MAX_PATCH_CHANGES.md](docs/MAX_PATCH_CHANGES.md) | every change made to the PLAUD device and prior~ in the Drums working copy (drum route, drums>latent, load defaults) |
| [docs/IDEAS.md](docs/IDEAS.md) | known limitations and future work |

## Repository layout

```
requirements.txt     pinned Python dependencies
src/
  main.py            entry point: window, main loop, inputs
  aquarium_boids/    simulation, descriptors, OSC, MIDI, rendering
  tools/             send_control_test.py (test controls on UDP 7500)
max/
  shoal_fx.maxpat    predator kick + spectral shake + reverb
  shoal_gran.maxpat  per-fish granulator, slice player, source menu
  shoal_drums.maxpat drum voices for the MPK pad bank B (samples or synthesized)
docs/                the pages listed above
```

## Credits

- Simone Zanetti and Alessandro Murru (system design and development); Rafael (music, live performance, training recordings).
- PLAUD (Performative Latents for Adaptive Unsupervised DDSP) by Błażej Kotowski.
- Developed at the Generative Music AI Workshop (UPF / MTG with The Sound of AI), Barcelona, July 2026.

## Limitations

- Tested on Windows only.
- The PLAUD device, the PLAUD model and all audio assets are not included. Without them, the Max
  side cannot be run as shown in the demo.
- The Max patches were built for standalone Max 9, not for Max for Live.

## License

To be agreed with co-authors.
