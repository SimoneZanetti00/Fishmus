# Changes to the PLAUD device and prior~ (Drums set)

The PLAUD device is not in this repository (PLAUD is by Błażej Kotowski). This page lists every change made to the
**Drums** working copy of the device and of `prior~`, so they can be redone on another copy.

- Working copy: `C:\dev\max-work\PLAUD_Drums_work\patchers\` (a copy of `PLAUD_Simo_work`, which is unchanged).
- Files: `PLAUD_Simo_DEV2-2.amxd.maxpat` (the device) and `prior~.maxpat` (loaded by the device as a bpatcher from
  the same folder).
- The base is the SynthFish device described in [MAX_SETUP.md](MAX_SETUP.md): the `/plaud/*`, `/fx/*`, `/gran/*`,
  `/mix/*` + `/pad/*` routes, and the prior~ edits (flock → territory, `metro 2754 @active 0`).
- Every step was made with a script, with a backup first (`.bak9` … `.bak13` for the device, `.bak4` / `.bak5`
  for prior~, next to the files).

## 1. Drum route (device)

After `[udpreceive 7400]`, a fifth route:

```
route /drum/kick /drum/snare /drum/hihat /drum/dirty /drum/slice /drum/openhat /drum/clap /drum/perc /drum/energy
  -> s drumKick, s drumSnare, s drumHihat, s drumDirty, s drumSlice, s drumOpenhat, s drumClap, s drumPerc, s drumEnergy
```

`max/shoal_drums.maxpat` plays the drums from `r drumKick` … `r drumPerc`. Everything below reads the same sends.

## 2. drums>latent (device)

A toggle **drums>latent** (presentation next to *prior glitch*; always **off** at load, `loadmess 0`) and a **drums**
panel next to it. With the toggle off, no drum or energy message gets past the gates, every offset is reset to 0 at
once, and the device behaves exactly as without these changes.

### Principle: base + offset, never writing a control

For every target, what reaches the destination is **the user's own value (the base) + an offset**:

```
user control -> [t b f] -> [+ 0.]  (base into the right inlet, then a bang)  -> [clip] -> original destination
offset                  -> [+ 0.]  (left inlet, hot)
```

Each offset comes from its own chain:

```
velocity -> [* size] -> [* control] -> [clip 0. cap] -> [maximum 0.] -> [pack 0. <decay>] -> ($1, 0. $2) -> [line 0. 10]
                                                         ^ right inlet: the line's current value
```

- The line jumps to the hit size and glides to **exactly 0** in *decay* ms, so the output returns exactly to the base.
- A new hit on the same target gives max(current, new), never a sum, so rapid hits cannot ratchet.
- Toggle off sends `0` to every line: all outputs jump to their bases at once.
- No user dial or number box is ever written; moving one while a glide runs just moves the base.

### The seven cables that were replaced

| Removed direct cable | Now |
|---|---|
| `Ch1Offset` … `Ch4Offset` → `mc.pack~ 4` inlets 0–3 | base + posterior offset (with the global cap) → the same inlets |
| `SpectralStretch` → `s ---spectral-stretch` | base + bend offset (+ energy) → the same send |
| `Shape` → `s ---waveshaping` | base + grit offset → the same send |
| `scale 0.7 1.4 1. 0.` → `Limit` | loudness stream + 0.8 × bend offset → `Limit`; an offset change re-sends at once |

### What each drum does

| Drum | Target | Size at full velocity |
|---|---|---|
| kick | posterior ch1 + prior territory Y (down) | 0.6 × amount; push |
| snare | posterior ch2 + prior territory X (right) | 0.6 × amount; push |
| hihat, openhat | posterior ch3 (glide 0.375 × decay) | 0.6 × amount |
| clap, perc | posterior ch4 | 0.6 × amount |
| dirty | Stretch (bend) and Limit (0.8 × bend); Shape (grit) | bend; grit |
| slice | prior reseed trigger | — |
| groove energy (`/drum/energy`) | Stretch/Limit (E>bend); prior temperature (E>tmp) | energy × E>bend; energy × E>tmp |

- **Caps:** each posterior channel ≤ 0.6; the four posterior offsets are scaled together so their sum is ≤ 1.0 at
  every instant (`pak` → sum → `maximum 1.` → `!/ 1.` → every channel re-sent with the new factor). Bend + energy
  ≤ 0.6 (Stretch units), grit ≤ 0.6, push ≤ 0.3.
- **Energy** comes from Python already smoothed. It relaxes to exactly 0 about 2.7 s after the last hit, and so do
  the Stretch, Limit and tmp offsets it drives.
- **Reseed:** a slice sends 1, and 0 again 300 ms after the last slice (`delay 300`). The model fires on a rising edge
  above 0.5, so a slice roll faster than that reseeds once.

### The drums panel (live.dial / live.text, Live parameters)

| Control | Parameter | Range | Default |
|---|---|---|---|
| amount (posterior hits) | `DrAmount` | 0–1 | 0.5 |
| decay | `DrDecay` | 200–2000 ms | 400 ms |
| grit (Shape in dirty) | `DrGrit` | 0–0.6 | 0.08 |
| bend (Stretch in dirty; Limit 0.8 ×) | `DrBend` | 0–0.5 | 0.25 |
| push (prior territory, kick/snare) | `DrPriorPush` | 0–0.3 | 0.1 |
| reseed (on slice) | `DrReseed` | off/on | on |
| E>tmp | `DrEnergyTmp` | 0–1 | 0.2 |
| E>bend | `DrEnergyBend` | 0–0.3 | 0.15 |
| kick, snare, hats, clap/perc, dirty, slice | `DrKick` … `DrSlice` | off/on | on |

- The defaults are the parameters' initial values. The dials are re-sent once after load (`loadbang` → `deferlow`).
- The pad gates are `gate 1 1`, open until their toggle says otherwise.

## 3. prior~ (Drums copy)

Offsets on top of the prior's own inputs. The prior's input labels (from the model) are: LFO 1–4, Style X, Style Y,
Temperature, Style CFG, Smoothing, Reseed Trigger.

| Input (`mc.pack~ 10` inlet) | Change |
|---|---|
| Style X (4) | `/ 127.` (after the pictslider) → `[t b f]` → `[+ 0.]` ← `r ---drum-terr-x` → `clip 0. 1.` → `sig~` |
| Style Y (5) | the same with `r ---drum-terr-y` |
| Temperature (6) | tmp number box → `[t b f]` → `[+ 0.]` ← `r ---drum-tmp` → `clip 0. 5.` → `sig~` |
| Reseed Trigger (9, unconnected before) | `r ---drum-reseed` → `sig~` → inlet 9 |

The flock's `/plaud/x,y`, the territory number boxes and the pictslider are never written. With every offset at 0,
the values reaching the `sig~` objects are the same as before.

## 4. Load defaults (Drums copy)

| Value | Where | Load value |
|---|---|---|
| loudness, centroid, L1, L2 | device live.dials: `parameter_initial` and the `autopattr` restore values | 1.00, 0.78, 0.51, 0.42 |
| cfg, tmp | prior~ number boxes: `parameter_initial` | 20.0, 1.26 |
| display map | prior~ live.menu: `parameter_initial` | noisiness |
| latent toggle | device: its own `loadmess 1` (the shared `loadmess 0` still sets rythme, kick and prior glitch) | on |

Once SynthFish runs, loudness and L2 follow `/plaud/loudness` and `/plaud/temp`, so their load values only matter
before the flock starts.

## How it was checked

- **Validator:** JSON, ids, cable endpoints, overlaps, absolute paths and cycles. The only cycles are through cold
  inlets (each line feeding its own `maximum`).
- **Simulator:** an event-driven model of the Max message order (right-to-left, hot/cold inlets, `line` and `delay`
  timing) over the real cables of both files. Every scenario returns exactly to the bases:
  - rapid hits;
  - toggle off mid-glide;
  - 8 bars at 120 BPM with groove energy;
  - the global cap;
  - the decay dial;
  - the per-pad toggles;
  - reseed.
- Then tested in Max.
