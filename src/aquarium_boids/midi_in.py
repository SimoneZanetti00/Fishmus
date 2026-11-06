from __future__ import annotations

from dataclasses import dataclass
from typing import Any

from .controls import RuntimeControls, clamp01


@dataclass
class MidiAppliedControl:
    cc: int
    value: int
    parameter: str
    scaled_value: float | int


class MidiControllerInput:
    """Direct MIDI input for the controller -> Python -> Max workflow.

    Uses pygame.midi to avoid adding a new dependency. The device is optional:
    if no MIDI input is available, the project continues with keyboard/mouse and
    Max UDP controls.

    Profiles: after a device is opened, the first profile whose key is contained in
    the device name (case-insensitive) replaces the default CC mapping and can add
    pads (Program Change and/or note-on), a joystick (two CCs) and keys (notes that set
    a transpose). Any other device keeps the default mapping (MIDIMIX) and nothing else.
    Mapping entries whose parameter starts with "/" are not simulation controls:
    they are returned to the caller (an OSC address for Max) and not applied.
    """

    def __init__(
        self,
        device_name: str = "MIDIMIX",
        mapping: dict[int, tuple[str, float, float, bool]] | None = None,
        debug: bool = True,
        profiles: dict[str, dict[str, Any]] | None = None,
        joy_dead_zone: int = 8,
        joy_invert_y: bool = False,
    ):
        self.device_name = device_name.lower()
        self.mapping = mapping or {}
        self.debug = debug
        self.profiles = profiles or {}
        self.profile_name = "none (MIDI input not started)"
        self.pc_pads: dict[int, int] = {}  # Program Change number -> pad number
        self.note_pads: dict[int, int] = {}  # note number (note-on, any channel) -> pad number
        self.joystick_ccs: tuple[int, int] | None = None  # (x CC, y CC)
        self.keys: tuple[int, int, int, int] | None = None  # (channel, lowest, highest, root)
        self.joy_dead_zone = joy_dead_zone
        self.joy_invert_y = joy_invert_y
        self._joy_raw = [64, 64]
        self._pending_transpose: int | None = None
        self.drum_pads: dict[int, str] = {}  # note number (note-on, any channel) -> drum name (MPK bank B)
        self._pending_drums: list[tuple[str, float]] = []
        self.last_bank: str | None = None  # "A" or "B": bank of the last pad hit (the MPK sends no bank change)
        self._pending_pads: list[int] = []
        self.enabled = False
        self.device_id: int | None = None
        self.device_label = "no MIDI input"
        self._device_name_found = ""
        self._pygame_midi: Any = None
        self._input: Any = None
        self._seen_values: dict[int, int] = {}

    def start(self) -> None:
        try:
            import pygame.midi as pygame_midi
        except Exception as exc:  # pragma: no cover - depends on local pygame install
            self.device_label = f"pygame.midi unavailable: {exc}"
            print(f"[midi] {self.device_label}")
            return

        self._pygame_midi = pygame_midi
        pygame_midi.init()
        self.device_id = self._find_device_id(pygame_midi)
        if self.device_id is None:
            self.profile_name = "none (no MIDI input)"
            print("[midi] no MIDI input device found; keyboard/Max UDP controls remain active")
            return

        try:
            self._input = pygame_midi.Input(self.device_id)
        except Exception as exc:  # pragma: no cover - hardware dependent
            self.device_label = f"could not open MIDI input {self.device_id}: {exc}"
            self.profile_name = "none (MIDI input could not be opened)"
            print(f"[midi] {self.device_label}")
            return

        self.enabled = True
        self._select_profile()
        print(f"[midi] listening to {self.device_label}")
        if self.debug:
            print("[midi] debug enabled: move controls to print CC/value (and Program Change)")

    def _select_profile(self) -> None:
        name = self._device_name_found.lower()
        for key, profile in self.profiles.items():
            if key.lower() in name:
                self.mapping = profile.get("cc", self.mapping)
                self.pc_pads = profile.get("pc_pads", {})
                self.note_pads = profile.get("note_pads", {})
                self.joystick_ccs = profile.get("joystick")
                self.keys = profile.get("keys")
                self.drum_pads = profile.get("drum_pads", {})
                self.profile_name = key
                return
        self.profile_name = "MIDIMIX (default mapping)"

    def take_pads(self) -> list[int]:
        """Pads (1..8) pressed since the last call, in order."""
        pads, self._pending_pads = self._pending_pads, []
        return pads

    def take_drums(self) -> list[tuple[str, float]]:
        """Drum hits (name, velocity 0..1) since the last call, in order."""
        drums, self._pending_drums = self._pending_drums, []
        return drums

    def take_transpose(self) -> int | None:
        """Transpose (semitones) from the last key pressed since the last call, or None."""
        transpose, self._pending_transpose = self._pending_transpose, None
        return transpose

    def joystick(self) -> tuple[float, float] | None:
        """Joystick deflection (x right, y up), each -1..1, or None while it rests in the dead zone.

        An axis inside the dead zone counts as 0, so the rest position (about 64) never drifts.
        """
        if self.joystick_ccs is None:
            return None
        offsets = [raw - 64 for raw in self._joy_raw]
        if all(abs(o) <= self.joy_dead_zone for o in offsets):
            return None
        x, y = (0.0 if abs(o) <= self.joy_dead_zone else max(-1.0, min(1.0, o / 63.5)) for o in offsets)
        return (x, -y if self.joy_invert_y else y)

    def stop(self) -> None:
        if self._input is not None:
            try:
                self._input.close()
            except Exception:
                pass
        if self._pygame_midi is not None:
            try:
                self._pygame_midi.quit()
            except Exception:
                pass

    def _find_device_id(self, pygame_midi: Any) -> int | None:
        fallback: int | None = None
        for device_id in range(pygame_midi.get_count()):
            interf, name, is_input, _is_output, _opened = pygame_midi.get_device_info(device_id)
            label = name.decode(errors="ignore") if isinstance(name, bytes) else str(name)
            interface = interf.decode(errors="ignore") if isinstance(interf, bytes) else str(interf)
            if is_input:
                print(f"[midi] input device {device_id}: {label} ({interface})")
                if fallback is None:
                    fallback = device_id
                if self.device_name and self.device_name in label.lower():
                    self.device_label = f"{label} [{device_id}]"
                    self._device_name_found = label
                    return device_id
        if fallback is not None:
            info = pygame_midi.get_device_info(fallback)
            label = info[1].decode(errors="ignore") if isinstance(info[1], bytes) else str(info[1])
            self.device_label = f"{label} [{fallback}] fallback"
            self._device_name_found = label
        return fallback

    def poll(self, controls: RuntimeControls, max_events: int = 64) -> list[MidiAppliedControl]:
        if not self.enabled or self._input is None:
            return []
        if not self._input.poll():
            return []

        applied: list[MidiAppliedControl] = []
        events = self._input.read(max_events)
        for event in events:
            data = event[0]
            status = int(data[0])
            cc = int(data[1])
            value = int(data[2])
            message_type = status & 0xF0
            channel = (status & 0x0F) + 1

            # Program Change 0xC0..0xCF: pads, only for profiles that define them.
            if message_type == 0xC0:
                pad = self.pc_pads.get(cc)  # data[1] is the program number
                if pad is not None:
                    self._pending_pads.append(pad)
                    self.last_bank = "A"
                    if self.debug:
                        print(f"[pad] {pad}  (program {cc}, channel {channel})")
                elif self.debug:
                    print(f"[midi] program={cc} channel={channel}: not a pad in profile {self.profile_name}")
                continue

            # Note-on 0x90..0x9F with velocity > 0: pads, only for profiles that map notes (any channel).
            # Note-off and note-on with velocity 0 are ignored.
            if message_type in (0x80, 0x90):
                is_on = message_type == 0x90 and value > 0
                pad = self.note_pads.get(cc) if is_on else None  # data[1] is the note number
                if pad is not None:
                    self._pending_pads.append(pad)
                    self.last_bank = "A"
                    if self.debug:
                        print(f"[pad] {pad}  (note {cc}, channel {channel})")
                elif is_on and cc in self.drum_pads:  # bank B: drum hit with velocity
                    name, velocity = self.drum_pads[cc], clamp01(value / 127.0)
                    self._pending_drums.append((name, velocity))
                    self.last_bank = "B"
                    if self.debug:
                        print(f"[drum] {name} v={velocity:.2f}  (note {cc}, channel {channel})")
                elif is_on and self.keys is not None and channel == self.keys[0] and self.keys[1] <= cc <= self.keys[2]:
                    self._pending_transpose = cc - self.keys[3]  # latched until the next key; note-off does nothing
                    if self.debug:
                        print(f"[key] note {cc} -> transpose {cc - self.keys[3]:+d}")
                elif self.debug:
                    state = "on" if is_on else "off"
                    print(f"[midi] note {state} {cc} velocity={value} channel={channel}: ignored")
                continue

            # MIDI CC messages are 0xB0..0xBF.
            if message_type != 0xB0:
                continue

            if self.joystick_ccs is not None and cc in self.joystick_ccs:  # stored, not printed (it floods)
                self._joy_raw[self.joystick_ccs.index(cc)] = value
                continue

            if self.debug and self._seen_values.get(cc) != value:
                self._seen_values[cc] = value
                print(f"[midi] cc={cc} value={value} channel={channel}")

            if cc not in self.mapping:
                continue

            parameter, min_value, max_value, quantize = self.mapping[cc]
            normalized = clamp01(value / 127.0)
            scaled = min_value + normalized * (max_value - min_value)
            if quantize:
                scaled_value: float | int = int(round(scaled))
            else:
                scaled_value = float(scaled)

            if not parameter.startswith("/"):  # "/..." = OSC address for Max, handled by the caller
                apply_parameter(controls, parameter, scaled_value)
            applied.append(MidiAppliedControl(cc, value, parameter, scaled_value))
        return applied


def apply_parameter(controls: RuntimeControls, parameter: str, value: float | int) -> None:
    if parameter == "density_fader":
        controls.density_fader = clamp01(float(value))
    elif parameter == "alignment_weight":
        controls.alignment_weight = max(0.0, min(3.0, float(value)))
    elif parameter == "cohesion_weight":
        controls.cohesion_weight = max(0.0, min(3.0, float(value)))
    elif parameter == "separation_weight":
        controls.separation_weight = max(0.0, min(4.0, float(value)))
    elif parameter == "noise_weight":
        controls.noise_weight = max(0.0, min(1.5, float(value)))
    elif parameter == "food_strength":
        controls.food_strength = max(0.0, min(3.0, float(value)))
    elif parameter == "predator_strength":
        controls.predator_strength = max(0.0, min(3.0, float(value)))
    elif parameter == "food_amount":
        controls.food_amount = max(0.0, min(3.0, float(value)))
    elif parameter == "predator_amount":
        controls.predator_amount = max(0.0, min(3.0, float(value)))
    elif parameter == "population":
        controls.population = max(1, min(100, int(value)))
    elif parameter == "section_id":
        controls.section_id = max(0, min(5, int(value)))
