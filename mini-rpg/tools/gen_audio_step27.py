# -*- coding: utf-8 -*-
"""Шаг 27: боевые звуки — два новых эффекта.

  sfx_crit.wav — критический удар (0.3 с): острый металлический
    «звон-свист» — синус 1500->820 Гц + октава + искровой шум в полосе
    2.5-6 кГц; атака 0.02, быстрый спад. Отделяет крит от обычного
    попадания (sfx_hit) — план шага 27 «крупная жёлтая цифра и звук».
  sfx_dash.wav — рывок (0.22 с): «вжух» — шумовой свип 300->2200->500 Гц
    без тональной основы; мягкая атака 0.03. Звук уклонения.

Правила шага 20 сохранены: пик 0.55, ФНЧ на хвосте, без щелчков.
Запуск:  python3 tools/gen_audio_step27.py
"""
import os
import sys

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from gen_audio_step20 import SR, save_wav, env, lowpass, noise_band  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def sfx_crit() -> np.ndarray:
    n = int(SR * 0.3)
    e = env(n, attack=0.02, release=0.55)
    t = np.arange(n) / SR
    # тон: острый свип вниз (звон металла) + октава для яркости
    f = 1500.0 * (820.0 / 1500.0) ** t
    phase = 2 * np.pi * np.cumsum(f) / SR
    tone = np.sin(phase) * 0.8 + np.sin(2 * phase) * 0.25
    # искровой шум: верхняя полоса, быстро гаснет (свист)
    spark = noise_band(n, 2500.0, 6000.0) * np.exp(-t * 14.0)
    x = (tone + spark * 0.7) * e
    x = lowpass(x, 0.5)
    return np.stack([x, x], axis=1)


def sfx_dash() -> np.ndarray:
    n = int(SR * 0.22)
    e = env(n, attack=0.03, release=0.45)
    t = np.arange(n) / SR
    # свип полосы шума: взлёт на 2.2 кГц и падение к 500 Гц (вжух)
    center = 300.0 + (2200.0 - 300.0) * np.sin(np.pi * np.minimum(t / 0.22, 1.0)) \
        * np.exp(-t * 3.0) + 200.0
    center = np.clip(center, 200.0, 2400.0)
    white = np.random.default_rng(27).standard_normal(n)
    # простой полосовой: скользящее среднее с меняющимся окном
    x = np.zeros(n)
    for i in range(1, n):
        alpha = float(np.clip(SR / (2.0 * center[i]), 0.02, 0.6))
        x[i] = x[i - 1] + alpha * (white[i] - x[i - 1])
    x = x * e
    x = lowpass(x, 0.35)
    return np.stack([x, x], axis=1)


def main() -> None:
    print("Шаг 27: звуки боя -> assets/audio/sfx/")
    save_wav("assets/audio/sfx", "sfx_crit.wav", sfx_crit())
    save_wav("assets/audio/sfx", "sfx_dash.wav", sfx_dash())
    print("OK")


if __name__ == "__main__":
    main()
