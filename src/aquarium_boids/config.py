OSC_HOST = "127.0.0.1"
OSC_PORT = 7400
PLAIN_UDP_PORT = 7401  # Max fallback via [netreceive -u 7401], no oscparse needed
CONTROL_PORT = 7500  # Max/MIDIMAX -> Python controls via [udpsend 127.0.0.1 7500]

# Direct MIDI controller input. Main live workflow: MIDIMIX -> Python -> Max.
ENABLE_MIDI_INPUT = True
MIDI_INPUT_NAME = "MIDIMIX"  # substring match; fallback to first available MIDI input
MIDI_DEBUG = True  # prints incoming CCs, useful for learning the real fader numbers

# Configurable CC mapping: cc_number -> (RuntimeControls field, min_value, max_value, quantize_to_int)
# NOTE: AKAI MIDIMIX CC numbers can vary by preset. If the mapping does not react,
# move faders and read printed CC numbers in the terminal, then edit this table.
# AKAI MIDIMIX: the 8 physical faders emit CC 19, 23, 27, 31, 49, 53, 57, 61 (fader 1..8).
# Live mapping (Rafael's setup): one physical fader per control.
# alignment_weight is intentionally left unmapped -> stays at its default (1.0).
MIDI_CC_MAPPING = {
    # Ecosystem controls (move the boids; the sound follows the descriptors):
    19: ("population", 1.0, 100.0, True),        # fader 1 -> number of fish -> granular density
    23: ("cohesion_weight", 0.0, 3.0, False),    # fader 2 -> flock compactness
    27: ("separation_weight", 0.0, 4.0, False),  # fader 3 -> flock dispersion
    31: ("noise_weight", 0.0, 1.5, False),       # fader 4 -> agitation -> noise/distortion
    49: ("food_amount", 0.0, 3.0, False),        # fader 5 -> center attractor
    53: ("predator_amount", 0.0, 3.0, False),    # fader 6 -> center repeller -> chaos
    # Musical controls (do NOT move the boids):
    57: ("density_fader", 0.0, 1.0, False),      # fader 7 -> Markov event density
    61: ("section_id", 0.0, 5.0, True),          # fader 8 -> musical section
}

# Controller profiles, chosen by the name of the MIDI input actually opened (substring,
# case-insensitive). Any other device, including the MIDIMIX, uses MIDI_CC_MAPPING above.
# A parameter starting with "/" is not a simulation control: it is sent to Max as an OSC
# message (address, scaled value) whenever the knob moves.
# AKAI MPK mini 3 (measured with the MIDI monitor): knobs K1..K8 send CC 16..23 on channel 1; pads 1..8
# send Program Change 16..23 (pad mode PROG CHANGE) or note-on 16..23 (pad mode NOTE), on channel 10.
# Both pad modes are accepted, notes on any channel; note-off and velocity 0 are ignored.
MIDI_CC_MAPPING_MPK = {
    16: ("/mix/grain_ms", 10.0, 400.0, False),   # K1 -> Max granulator grain length (ms)
    17: ("noise_weight", 0.0, 1.5, False),       # K2 -> agitation (range as MIDIMIX fader 4)
    18: ("cohesion_weight", 0.0, 3.0, False),    # K3 -> cohesion (as MIDIMIX fader 2)
    19: ("population", 1.0, 100.0, True),        # K4 -> number of fish (as MIDIMIX fader 1)
    20: ("/mix/gran_gain", 0.0, 1.0, False),     # K5 -> Max granulator gain
    21: ("/mix/slice_gain", 0.0, 1.0, False),    # K6 -> Max slice player gain
    22: ("/mix/wet", 0.0, 1.0, False),           # K7 -> PLAUD wet level (the gain into vst~)
    23: ("/mix/master", 0.0, 1.0, False),        # K8 -> PLAUD dry level
}  # alignment stays 1.0; predator on pad 2 / mouse; kick gain stays at the shoal_fx value
MIDI_PC_PADS_MPK = {16 + i: i + 1 for i in range(8)}  # Program Change 16..23 -> pad 1..8
MIDI_NOTE_PADS_MPK = {16 + i: i + 1 for i in range(8)}  # note-on 16..23 -> pad 1..8
# MPK joystick (CC 80 = x, 0 = left; CC 81 = y) steers a food point; keyboard notes set a transpose.
JOY_CC_X_MPK = 80
JOY_CC_Y_MPK = 81
JOY_INVERT_Y = False  # False: CC 81 = 127 is up; True: 0 is up
JOY_DEAD_ZONE = 8  # |value - 64| <= this on both axes = centre: no joystick food
JOY_MARGIN = 60.0  # world px kept free at the edges at full deflection
JOY_SMOOTHING = 0.15  # per-frame glide of the joystick food point towards its target
MIDI_KEYS_MPK = (1, 48, 72, 60)  # channel, lowest, highest, root: note-on -> transpose = note - root
# Pad bank B (note-on 32..39, any channel; measured: channel 10, velocity-sensitive) -> drum hits /drum/<name>.
DRUM_PADS_MPK = {32: "kick", 33: "snare", 34: "hihat", 35: "dirty", 36: "slice", 37: "openhat", 38: "clap", 39: "perc"}
# Groove energy (/drum/energy 0..1): bank-B hits over a sliding window, smoothed; sent only once bank B is used.
DRUM_ENERGY_WINDOW_S = 2.0
DRUM_ENERGY_FULL_HITS = 16  # hits in the window that give 1.0 (16th notes at 120 BPM)
DRUM_ENERGY_ATTACK_S = 0.25
DRUM_ENERGY_RELEASE_S = 0.5
DRUM_ENERGY_IDLE_S = 0.75  # no hit for this long: the energy starts relaxing (back to 0 in ~2.7 s)
MIDI_PROFILES = {  # name substring -> what the controller adds to (or replaces in) the default MIDIMIX setup
    "MPK": {
        "cc": MIDI_CC_MAPPING_MPK,
        "pc_pads": MIDI_PC_PADS_MPK,
        "note_pads": MIDI_NOTE_PADS_MPK,
        "joystick": (JOY_CC_X_MPK, JOY_CC_Y_MPK),
        "keys": MIDI_KEYS_MPK,
        "drum_pads": DRUM_PADS_MPK,
    },
}
PAD_PREDATOR_BURST_S = 0.7  # pad 2: predator at the centre for this long (< shoal_fx's 800 ms repeat: one kick)

WIDTH = 1200
HEIGHT = 750
FPS = 60
BOID_COUNT = 100

SEND_DESCRIPTOR_HZ = 20
GRAN_MAX_VOICES = 32  # /gran/fish_x carries at most this many fish (Max uses its own N <= this)
BPM = 120
ROOT_MIDI = 57  # A minor by default
SCALE_INTERVALS = [0, 2, 3, 5, 7, 8, 10]

BACKGROUND = (8, 16, 28)
TEXT = (220, 235, 245)
