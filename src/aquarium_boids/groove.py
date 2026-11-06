"""Groove energy: how densely the MPK bank-B drums are being played, as one slow value 0..1 for Max.

Hits are counted over a sliding window; the count is mapped to 0..1 (DRUM_ENERGY_FULL_HITS in the window = 1)
and smoothed with separate attack and release times. Nothing is sent before the first hit, and one final 0 is
sent once the value has decayed, so the OSC stream is unchanged when bank B is never used.
"""
from __future__ import annotations

import math
from collections import deque


class GrooveEnergy:
    def __init__(self, window_s: float = 2.0, full_hits: int = 16, attack_s: float = 0.25, release_s: float = 0.5,
                 idle_s: float = 0.75):
        self.window_s = window_s
        self.full_hits = full_hits
        self.attack_s = attack_s
        self.release_s = release_s
        self.idle_s = idle_s  # no hit for this long: start relaxing to 0
        self.hits: deque[float] = deque()
        self.value = 0.0
        self._sending = False

    def hit(self, t: float) -> None:
        self.hits.append(t)

    def update(self, t: float, dt_s: float) -> None:
        while self.hits and t - self.hits[0] > self.window_s:
            self.hits.popleft()
        idle = not self.hits or t - self.hits[-1] > self.idle_s
        target = 0.0 if idle else min(1.0, len(self.hits) / self.full_hits)
        tau = self.attack_s if target > self.value else self.release_s
        self.value += (target - self.value) * (1.0 - math.exp(-max(0.0, dt_s) / tau))
        if idle and self.value < 0.02:
            self.value = 0.0

    def to_send(self) -> float | None:
        """The value to send now, or None (nothing to send)."""
        if self.value > 0.0:
            self._sending = True
            return self.value
        if self._sending:
            self._sending = False
            return 0.0
        return None
