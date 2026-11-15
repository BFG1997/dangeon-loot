# -*- coding: utf-8 -*-
"""Шаг 21: голос Большего Ктулху — два новых эффекта для данжа 3.

  sfx_cthulhu_roar.wav — глубокий рёв пробудившегося (1.6 с):
    под-свип 55->34 Гц + расстроенная октава + «формантный» шумовой
    горловой гул 120-380 Гц; атака 0.22 длины — рёв НАРАСТАЕТ, как
    землетрясение, резких высоких нет (ФНЧ + мягкая нормализация);
  sfx_tentacle_slam.wav — мокрый удар щупалец (0.55 с):
    под-удар 72->38 Гц с быстрым спадом + влажный всплеск в полосе
    140-900 Гц; глухо, тяжело, без звона.

Оба эффекта страшные, но НЕ резкие: те же правила шага 20 (пик 0.55,
ФНЧ, без щелчков). Запуск:  python3 tools/gen_audio_step21.py
"""
import os
import sys

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from gen_audio_step20 import SR, save_wav, env, lowpass, noise_band, sweep


def sfx_cthulhu_roar() -> np.ndarray:
    n = int(SR * 1.6)
    e = env(n, attack=0.22, release=0.5)
    sub = sweep(55.0, 34.0, n) * 0.9                      # утроба
    octv = sweep(112.0, 68.0, n, shape="tri") * 0.35      # расстроенная октава
    throat = noise_band(n, 120.0, 380.0)                  # горловой гул
    # вибрато горла: медленная модуляция громкости (жуткое «дрожание»)
    vib = 0.75 + 0.25 * np.sin(2 * np.pi * 5.5 * np.arange(n) / SR)
    throat = throat * vib
    x = (sub + octv + throat * 0.8) * e
    x = lowpass(x, 0.22)                                  # срез верхов
    # стерео: лёгкое расщепление каналов (рёв «шире» героя)
    delay = int(SR * 0.012)
    left = np.concatenate([x, np.zeros(delay)])
    right = np.concatenate([np.zeros(delay), x])
    return np.stack([left, right], axis=1)


def sfx_tentacle_slam() -> np.ndarray:
    n = int(SR * 0.55)
    thump = sweep(72.0, 38.0, n) * np.exp(-np.arange(n) / (SR * 0.13))
    splash = noise_band(n, 140.0, 900.0) * np.exp(-np.arange(n) / (SR * 0.09))
    x = (thump * 1.0 + splash * 0.5) * env(n, attack=0.02, release=0.35)
    x = lowpass(x, 0.3)
    wet = noise_band(n, 300.0, 1400.0) * np.exp(-np.arange(n) / (SR * 0.05))
    x = x + wet * 0.18
    left = lowpass(x, 0.5)
    right = np.roll(left, int(SR * 0.006))
    return np.stack([left, right], axis=1)


if __name__ == "__main__":
    print("Шаг 21: голос Ктулху — рёв и удар щупалец")
    save_wav("assets/audio/sfx", "sfx_cthulhu_roar.wav", sfx_cthulhu_roar())
    save_wav("assets/audio/sfx", "sfx_tentacle_slam.wav", sfx_tentacle_slam())
