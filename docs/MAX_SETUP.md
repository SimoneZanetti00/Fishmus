# Max setup

The Python simulation runs on its own (see the [README](../README.md)). To hear it, you need Max and the PLAUD device.

## What you need

- **Max 9**, standalone. The two SynthFish patches were built for standalone Max, not for Max for Live.
- The **`nn~`** external.
- A **PLAUD device and a trained PLAUD model**. PLAUD is by Błażej Kotowski and is not included in this repository. The performance used a model trained on about 30 minutes of recordings by Rafael.
- **Your own audio files.** No audio is shipped (see step 3).

## 1. Receive OSC in the PLAUD device

Add one `[udpreceive 7400]` to the device and four `route` objects. Each output goes to a `send` that the device or the SynthFish patches listen to:

| `route` | Outlet → destination |
|---|---|
| `route /plaud/x /plaud/y /plaud/loudness /plaud/temp` | `s plaudX`, `s plaudY` (read by `prior~`); `/plaud/loudness` → the loudness dial and, through `scale 0.7 1.4 1. 0.`, the components limit; `/plaud/temp` → the latent L2 dial |
| `route /fx/predator /fx/predator_strength` | `s fxPredator`, `s fxPredatorStrength` |
| `route /gran/fish_x /gran/density /gran/noise` | `s granFishX`, `s granDensity`, `s granNoise` |
| `route /mix/master /mix/kick_gain /mix/gran_gain /pad/kick /pad/sample /mix/grain_ms /mix/slice_gain /mix/wet /mix/transpose` | `/mix/master` → `scale 0. 1. -70. 0.` → `pack f 30` → `line 0. 10` → the dry `live.gain~` (PLAUD output); `/mix/wet` → the same chain → the wet `live.gain~` that feeds `vst~` (the one CC 61 also drives); the others → `s mixKickGain`, `s mixGranGain`, `s padKick`, `s padSample`, `s mixGrainMs`, `s mixSliceGain`, `s mixTranspose` |

All addresses and ranges are listed in [OSC.md](OSC.md).

## 2. Let the flock steer PLAUD's prior

In `prior~`, the device's prior subpatch, make three changes:

1. `[r plaudX]` → the `territory_x` number box.
2. `[r plaudY]` → `[!- 1.]` → the `territory_y` number box. pygame's y axis points down, so it is inverted here.
3. Change `metro 2754 @active 1` to `metro 2754 @active 0`. This stops prior~'s own random walk on Y, so only the flock moves the point.

## 3. Open the SynthFish patches and add audio

Open `max/shoal_fx.maxpat` and `max/shoal_gran.maxpat` in the same Max session as the device, then turn DSP on. Both open in presentation view. Both have their own `dac~ 1 2`. For the MPK pad bank B, see [The Drums set](#the-drums-set) below.

Put your own files next to the patches:

| File | Used by | Notes |
|---|---|---|
| `max/shoal_kick.wav` | `shoal_fx.maxpat` | any short kick; loaded 2 s after the patch opens |
| `max/shoal_gran.aiff` | `shoal_gran.maxpat` | the default grain source, loaded at start |
| `max/grains/*.wav`, `*.aif`, `*.aiff` | `shoal_gran.maxpat` | optional: more sources, picked from the menu ("rescan" refreshes the list) |
| `drums/<pad>.wav` (in the folder **above** `max/`) | `shoal_drums.maxpat` | optional: the default sample of each drum (`kick`, `snare`, `hihat`, `dirty`, `openhat`, `clap`, `perc`); without it the voice is synthesized |
| `drums/candidates/<pad>/*.wav` | `shoal_drums.maxpat` | optional: more samples per drum, picked from that voice's menu |

Git ignores audio files, `max/grains/` and `drums/`, so your sounds never end up in the repository.

## The Drums set

The drums version (branch `drums`) runs on its own Max working copy, `C:\dev\max-work\PLAUD_Drums_work\`. It is a copy of `PLAUD_Simo_work`, which stays unchanged for SynthFish as before. Open these four patches from its `patchers\` folder, in one Max session, then turn DSP on:

| Patch | Role |
|---|---|
| `PLAUD_Simo_DEV2-2.amxd.maxpat` | the PLAUD device, with the drum route and **drums>latent** + its panel; it loads `prior~.maxpat` from the same folder |
| `shoal_fx.maxpat` | predator kick, spectral shake, reverb (as in `max/`) |
| `shoal_gran.maxpat` | the granulator and slices (as in `max/`); the drums' slice voice also reads its buffer |
| `shoal_drums.maxpat` | the eight drum voices (as in `max/`) |

The device and `prior~` changes are not in this repository; they are listed step by step in [MAX_PATCH_CHANGES.md](MAX_PATCH_CHANGES.md). In short:
- a fifth route `/drum/kick … /drum/perc /drum/energy` → `s drumKick` … `s drumPerc`, `s drumEnergy`;
- the drums>latent toggle and the drums panel;
- offsets on the prior's territory, temperature and reseed;
- the load defaults.

**Samples, outside the repository:**

```
PLAUD_Drums_work\
  patchers\            the four patches (+ shoal_kick.wav, shoal_gran.aiff, grains\)
  drums\
    <pad>.wav          optional default sample per drum: kick, snare, hihat, dirty, openhat, clap, perc
    candidates\<pad>\  more samples per drum, chosen from the voice's menu; SOURCES.txt lists where each came from
```

`shoal_drums.maxpat` finds `drums\` as the folder next to its own folder, at run time, so nothing absolute is saved. A pad without `drums\<pad>.wav` plays its synthesized fallback until you pick a sample from its menu. The candidate samples are copies from third-party drum kits for private use: keep them out of any repository (git already ignores `drums/` and audio files).

## shoal_fx.maxpat: predator kick, spectral shake and reverb

- **Inputs:** `r fxPredator` (1 = the scare starts, 0 = it ends) and `r fxPredatorStrength` (0–1).
- **Repeats:**
  - while the scare lasts and the patch is on, a kick fires at once and then every 800 ms;
  - safety: if nothing arrives for 1 s while active, the state switches off (the console prints `shoal_fx_timeout`).
- **Kick:**
  - *synth*: pitch 220 → 55 Hz in 120 ms, a 400 ms decay, a 5 ms noise click, light `tanh~` saturation;
  - *sample*: `shoal_kick.wav` from the start, in stereo;
  - the kick-source menu chooses synth / sample / both (default: sample).
- **Shake:** on each kick, PLAUD's `---waveshaping` (0–1) and `---spectral-warp` (−1–1) jump to base + shake × strength, then glide back to base in 400 ms.
- **Reverb (kick only):** a long stereo reverb is added to the kick, synth and sample. The dry kick is unchanged; the reverb only listens to it. Freeverb-style, standard MSP objects only:
  - the three dry kick signals are summed, high-passed at 150 Hz so the sub does not boom, and scaled by 0.015;
  - 8 parallel `comb~` filters per channel (25.3–36.7 ms; the right channel is 0.52 ms longer, for width). Their feedback is set from the decay, so *decay* is the time for the tail to fall by 60 dB;
  - a `onepole~` low-pass (*tone*, the damping), then 4 `allpass~` in series;
  - the wet signal × 3 × mix × on (30 ms ramp) goes to the same `dac~ 1 2`.
- **Controls:**
  - on/off, test kick, kick gain (0.8), shake amount (0.1), base waveshaping (0), base spectral warp (0), sample gain;
  - `r mixKickGain` sets the kick level (no MPK knob sends it now);
  - MPK pad 1 (`r padKick`) fires one kick;
  - reverb: on/off (on), mix 0–1 (0.35), decay 1–10 s (6 s), tone / damping 200–10000 Hz (3000 Hz).

## shoal_gran.maxpat: one grain voice per fish

- **Inputs:** `r granFishX`, `r granDensity`, `r granNoise`.
- **Voices:**
  - 16 MC voices; voice i follows fish i;
  - voices above the number of fish fade out in about 50 ms.
- **Onsets:**
  - each voice has its own onset clock at `(0.5 + 0.075 × density)` grains/s;
  - a slowly drifting random factor makes onsets drift instead of buzzing; its depth grows with `noise`;
  - the rate is capped so a grain ends before the next one starts.
- **Grains:**
  - each grain lasts *grain length* ms under a Hann window and reads the source at the transpose ratio (1× at 0 st);
  - the read position is random inside the region, over a span that widens with `noise`;
  - grains come from the left channel of the source.
- **Pan and output:**
  - each voice is panned by its fish's x (equal power, smoothed over ~60 ms);
  - then a low-pass "tone" filter;
  - master gain × 1/√(active voices).
- **Source:**
  - `shoal_gran.aiff` at start, or a file chosen from the `grains/` menu;
  - after each load, `info~` reads the file length; the region (start + width) is clamped to it.
- **Transpose:** `r mixTranspose` (−12…+12 st, from the MPK keys) gives a ratio 2^(st/12).
  - Grains keep their duration (K1) but read *grain length* × ratio ms of the source. The ratio glides over 20 ms; grain-length changes stay instant. The region start is limited using that span.
  - Slices read 1500 × ratio ms in their 1.5 s; a change applies from the next pad.
  - The presentation shows it as *transpose (st, MPK keys)*.
- **Slice player:** MPK pads 5–8 (`r padSample` 1–4) play a 1.5 s stereo slice from 10 / 30 / 55 / 80 % of the file, with 20 ms fades and their own gain.
- **Test mode:** 16 fake fish drift on slow sines, so you can hear the patch without Python.
- **Controls and defaults:**

| Control | Default | MPK knob |
|---|---|---|
| master gain | 0.614 | K5 (`r mixGranGain`) |
| grain length | 344.7 ms | K1 (`r mixGrainMs`) |
| slice gain | 0.457 | K6 (`r mixSliceGain`) |
| region start | 81.3 s | — |
| region width | 118 s | — |
| tone (low-pass) | 2584 Hz | — |

## shoal_drums.maxpat: drum voices for the MPK pad bank B

- **Inputs:** `r drumKick` … `r drumPerc`, each the hit velocity 0–1.
- **Level:** velocity² × the voice gain (0.8 at load), then master (0.8) and on/off, into its own `dac~ 1 2`.
- **Samples:** at load each voice tries `drums/<pad>.wav` from the folder above the patch. The path is worked out at run time, so nothing absolute is saved; in the Max working copy that is `PLAUD_Drums_work\drums\`. When the file loads, the status shows *sample*; a mono file plays on both sides. Otherwise the status shows *synth* and the voice plays its fallback:
  - kick: sine sweep 150 → 45 Hz;
  - snare: band-passed noise + 185 Hz tone;
  - hi-hat / open hat: high-passed noise, 45 ms / 420 ms;
  - clap: three band-passed noise bursts;
  - dirty: noise and a 90 Hz buzz, bit-crushed;
  - perc: a short tuned blip.
- **Sample menu (each voice but slice):** *default* (`drums/<pad>.wav`), *synth*, or any file in `drums/candidates/<pad>/`. A choice loads at once. It switches the voice to synth first, and back to sample only when the file has loaded, so a missing file never leaves an old sample playing.
- **Slice:** no file. A 300 ms burst from a random position of the grain source (`buffer~ shoal_gran`), so `shoal_gran.maxpat` must be open.
- **Controls:** on/off, master gain, and per voice a test button, gain, status and sample menu.

## Console messages

| Message | Meaning |
|---|---|
| `shoal_gran: source <name> loaded` | a grain source is in memory |
| `shoal_gran: duration_ms …`, `shoal_gran: channels …` | what `info~` read from the file |
| `shoal_gran: ERROR source shoal_gran.aiff NOT FOUND …` | no default source next to the patch (after 5 s) |
| `shoal_gran: sounds_in_grains N` | the menu found N files in `grains/` |
| `shoal_gran_region start_s … / width_s …` | the region actually used after clamping |
| `shoal_gran_slice …` | a pad slice was played |
| `shoal_fx: kick sample shoal_kick.wav loaded` | the sample kick is ready |
| `shoal_fx: ERROR kick sample shoal_kick.wav NOT FOUND …` | no kick file next to the patch (after 2 s); the synth kick still works |
| `shoal_fx_strength_in …` | raw `/fx/predator_strength` values as they arrive (diagnostic) |
| `shoal_fx_timeout` | no predator message for 1 s while active; the state switched off |
| `shoal_drums: <pad> sample loaded` | a drum sample is in memory (default or from the menu) |

## Audio troubleshooting

- **No sound at all:** check that DSP is on (Options → Audio Status) and that the output device is the right one.
- **Max receives nothing:**
  - is `python src/main.py` running?
  - does another program already use UDP port 7400?
  - add `[print]` after `udpreceive 7400` to see the raw messages.
- **Two copies of a patch open:** they share the `buffer~` names and the `send`/`receive` names, so only one copy of each should be open.
- **Large sources** load completely into RAM with `replace`. Very long files take a moment, and memory.
