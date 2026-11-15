# -*- coding: utf-8 -*-
"""Шаг 19: генерация звука игры «Dungeon Loot».

До этого шага в игре не было ни одного звука (assets/audio не существовал).
Здесь синтезируются:
  1. 14 SFX-эффектов: swing/hit/bolt/chest/coin/die/hurt/levelup/dust/gas/
     throw/shield/barrier/stairs (моно-синтез, 22050 Гц, WAV 16 бит);
  2. ambient_dungeon.wav — жуткий ~44-секундный ЭМБИЕНТ в духе Silent Hill
     (низкие гулкие дроны с биениями, диссонансные «струнные» кластеры,
     шумовые валы, редкие металлические скрежеты и далёкие «колокола»,
     глухие удары). Бесшовный луп: хвост кроссфейдится в начало.

Запуск:  python3 tools/gen_audio_step19.py
Результат: assets/audio/sfx/*.wav, assets/audio/music/ambient_dungeon.wav
"""
import os
import numpy as np
import wave

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SR = 22050
RNG = np.random.default_rng(191043)


def save_wav(rel_dir: str, name: str, data: np.ndarray, stereo: bool = True) -> None:
    """data: float [-1..1], shape (n,) mono или (n,2) stereo."""
    out_dir = os.path.join(ROOT, rel_dir)
    os.makedirs(out_dir, exist_ok=True)
    path = os.path.join(out_dir, name)
    if not stereo:
        data = np.stack([data, data], axis=1)
    data = np.clip(data, -1.0, 1.0)
    pcm = (data * 32767.0).astype("<i2")
    with wave.open(path, "wb") as w:
        w.setnchannels(2)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(pcm.tobytes())
    print("OK", os.path.relpath(path, ROOT),
          "%.2f с" % (pcm.shape[0] / SR))


def env(n: int, attack: float, release: float) -> np.ndarray:
    """Огибающая: плавная атака и спад (доли длины)."""
    t = np.linspace(0.0, 1.0, n)
    a = np.clip(t / max(attack, 1e-4), 0.0, 1.0)
    r = np.clip((1.0 - t) / max(release, 1e-4), 0.0, 1.0)
    return np.minimum(a, r)


def lowpass(x: np.ndarray, alpha: float) -> np.ndarray:
    """Однополюсный ФНЧ (alpha < 1 — сильнее срез)."""
    y = np.empty_like(x)
    acc = 0.0
    for i in range(x.shape[0]):
        acc += alpha * (x[i] - acc)
        y[i] = acc
    return y


def noise_band(n: int, lo: float, hi: float) -> np.ndarray:
    """Полосовой шум через FFT."""
    x = RNG.standard_normal(n)
    spec = np.fft.rfft(x)
    freqs = np.fft.rfftfreq(n, 1.0 / SR)
    mask = (freqs >= lo) & (freqs <= hi)
    spec[~mask] = 0.0
    return np.fft.irfft(spec, n)


def tone(freq: float, n: int, shape: str = "sine", phase: float = 0.0) \
        -> np.ndarray:
    t = np.arange(n) / SR
    if shape == "sine":
        return np.sin(2 * np.pi * freq * t + phase)
    if shape == "saw":
        return 2.0 * ((freq * t + phase / (2 * np.pi)) % 1.0) - 1.0
    if shape == "square":
        return np.sign(np.sin(2 * np.pi * freq * t + phase))
    raise ValueError(shape)


def sweep(f0: float, f1: float, n: int, shape: str = "sine") -> np.ndarray:
    """Частотный свип (кумулятивная фаза)."""
    t = np.arange(n) / SR
    freqs = np.geomspace(f0, f1, n)
    phase = 2 * np.pi * np.cumsum(freqs) / SR
    if shape == "sine":
        return np.sin(phase)
    if shape == "saw":
        return 2.0 * ((phase / (2 * np.pi)) % 1.0) - 1.0
    return np.sin(phase)


# ------------------------------------------------------------------ SFX

def sfx_swing() -> np.ndarray:
    """Свист взмаха: шум с бегающим центром полосы."""
    n = int(SR * 0.22)
    base = noise_band(n, 500, 3000)
    lfo = sweep(500, 2200, n)
    x = base * (0.4 + 0.6 * np.abs(lfo) / 2200.0)
    x *= env(n, 0.25, 0.45)
    return x * 0.8


def sfx_throw() -> np.ndarray:
    """Тяжёлый бросок: свист + глухой толчок."""
    n = int(SR * 0.3)
    x = noise_band(n, 300, 1600) * env(n, 0.2, 0.4) * 0.7
    thump = sweep(140, 55, n) * env(n, 0.02, 0.6) * 0.8
    return x * 0.7 + thump * 0.6


def sfx_hit() -> np.ndarray:
    """Удар: щелчок шума + низкий толчок."""
    n = int(SR * 0.16)
    crack = noise_band(n, 900, 4200) * env(n, 0.006, 0.25) * 0.9
    thump = sweep(160, 62, n) * env(n, 0.01, 0.4) * 0.9
    return crack * 0.8 + thump * 0.7


def sfx_hurt() -> np.ndarray:
    """Герой получил урон: глухой стон-свип вниз."""
    n = int(SR * 0.28)
    x = sweep(190, 80, n) * env(n, 0.05, 0.5)
    x += noise_band(n, 100, 700) * env(n, 0.03, 0.4) * 0.35
    return x * 0.85


def sfx_die() -> np.ndarray:
    """Враг рассыпался: нисходящий хрип."""
    n = int(SR * 0.5)
    x = sweep(280, 70, n, "saw") * env(n, 0.03, 0.55) * 0.4
    x += noise_band(n, 150, 900) * env(n, 0.02, 0.6) * 0.5
    return lowpass(x, 0.35) * 0.9


def sfx_bolt() -> np.ndarray:
    """Каст магии: свистящий свип с гармониками."""
    n = int(SR * 0.32)
    x = sweep(1100, 260, n) * 0.7
    x += sweep(2200, 520, n) * 0.25
    x += noise_band(n, 1500, 5000) * env(n, 0.1, 0.4) * 0.2
    return x * env(n, 0.06, 0.4)


def sfx_chest() -> np.ndarray:
    """Открытие сундука: скрип крышки + блеск находки."""
    n = int(SR * 0.42)
    creak = lowpass(sweep(90, 65, n, "saw"), 0.2) \
        * env(n, 0.15, 0.5) * 0.55
    sparkle = np.zeros(n)
    for i, f in enumerate((1318, 1760, 2093)):
        seg = tone(f, n) * np.exp(-np.arange(n) / (SR * 0.09)) \
            * np.roll(env(n, 0.02, 0.6), i * int(SR * 0.05))
        sparkle += seg * 0.22
    return creak + sparkle


def sfx_coin() -> np.ndarray:
    """Золото: двойной звон."""
    n = int(SR * 0.22)
    x = np.zeros(n)
    for i, f in enumerate((1318, 1760)):
        seg = tone(f, n) + 0.35 * tone(f * 2.01, n)
        fade = np.exp(-np.arange(n) / (SR * 0.06))
        delay = int(i * SR * 0.06)
        x[delay:] += (seg * fade)[:(n - delay)] * 0.5
    return x * env(n, 0.004, 0.5)


def sfx_levelup() -> np.ndarray:
    """Повышение уровня: восходящий мажорный перелив."""
    n = int(SR * 1.5)
    x = np.zeros(n)
    notes = (523.25, 659.25, 783.99, 1046.5, 1318.5)
    for i, f in enumerate(notes):
        delay = int(i * SR * 0.13)
        dur = n - delay
        seg = (tone(f, dur) + 0.3 * tone(f * 2, dur)
               + 0.15 * tone(f * 3.01, dur))
        fade = np.exp(-np.arange(dur) / (SR * 0.3))
        x[delay:] += seg * fade * 0.34
    x += noise_band(n, 3000, 8000) * env(n, 0.2, 0.5) * 0.06
    return x * env(n, 0.005, 0.25)


def sfx_dust() -> np.ndarray:
    """Горсть пыли: глухой шлепок с оседающим шумом."""
    n = int(SR * 0.45)
    x = noise_band(n, 200, 1200) * env(n, 0.05, 0.5) * 0.7
    x += sweep(120, 55, n) * env(n, 0.02, 0.4) * 0.5
    return lowpass(x, 0.3)


def sfx_gas() -> np.ndarray:
    """Гнилой газ: долгое шипение с клокотанием."""
    n = int(SR * 0.7)
    hiss = noise_band(n, 400, 2600) * env(n, 0.3, 0.45) * 0.45
    rumble = sweep(70, 45, n) * env(n, 0.2, 0.5) * 0.5
    lfo = 0.6 + 0.4 * np.sin(2 * np.pi * 13 * np.arange(n) / SR)
    return (hiss * lfo + rumble) * 0.85


def sfx_shield() -> np.ndarray:
    """Щит: металлический лязг."""
    n = int(SR * 0.4)
    x = np.zeros(n)
    for f, a in ((740, 0.5), (1120, 0.35), (1660, 0.25), (2210, 0.15)):
        x += tone(f, n) * np.exp(-np.arange(n) / (SR * 0.12)) * a
    x += noise_band(n, 2000, 6000) * env(n, 0.004, 0.1) * 0.3
    return x * env(n, 0.003, 0.2)


def sfx_barrier() -> np.ndarray:
    """Барьер мага: мерцающий восходящий хор."""
    n = int(SR * 0.55)
    x = np.zeros(n)
    for i, f in enumerate((660, 831, 990, 1244)):
        seg = tone(f, n, phase=i * 0.7)
        x += seg * env(n, 0.25 + i * 0.05, 0.4) * 0.22
    return lowpass(x, 0.5)


def sfx_stairs() -> np.ndarray:
    """Каменные ступени: два глухих шага."""
    n = int(SR * 0.45)
    x = np.zeros(n)
    for delay, f in ((0, 95), (int(SR * 0.18), 80)):
        dur = n - delay
        seg = sweep(f, f * 0.5, dur) * env(dur, 0.01, 0.5) * 0.8
        seg += noise_band(dur, 100, 500) * env(dur, 0.01, 0.3) * 0.3
        x[delay:] += seg
    return lowpass(x, 0.4)


# -------------------------------------------------------------- эмбиент

def _drone(total: int) -> np.ndarray:
    """Слой 1: гулкие дроны с медленными биениями (55 Гц + фифт)."""
    t = np.arange(total) / SR
    x = (np.sin(2 * np.pi * 55.0 * t)
         + 0.8 * np.sin(2 * np.pi * 55.4 * t)      # биение 0.4 Гц
         + 0.7 * np.sin(2 * np.pi * 82.5 * t + 0.5)
         + 0.5 * np.sin(2 * np.pi * 36.7 * t)
         + 0.4 * np.sin(2 * np.pi * 110.9 * t))
    lfo = 0.55 + 0.45 * np.sin(2 * np.pi * t / 13.0 + 1.0)
    return x * lfo * 0.24


def _pad(total: int) -> np.ndarray:
    """Слой 2: диссонансные «струнные» кластеры (минорные секунды)."""
    t = np.arange(total) / SR
    x = np.zeros(total)
    for f, a in ((220.0, 0.5), (233.1, 0.42), (466.2, 0.2), (155.6, 0.35)):
        x += a * (np.sin(2 * np.pi * f * t + 0.3)
                  + 0.5 * np.sin(2 * np.pi * f * 2.02 * t))
    drift = 0.5 + 0.5 * np.sin(2 * np.pi * t / 23.0)
    x = lowpass(x, 0.18) * (0.35 + 0.65 * drift)
    return x * 0.11


def _washes(total: int) -> np.ndarray:
    """Слой 3: медленные шумовые валы (как дальний ветер в тоннелях)."""
    n = noise_band(total, 80, 700)
    t = np.arange(total) / SR
    swell = 0.35 + 0.65 * np.clip(np.sin(2 * np.pi * t / 9.5 - 2.0), 0, 1)
    return n * swell * 0.16


def _events(total: int) -> np.ndarray:
    """Слой 4: редкие события — скрежет, далёкий «колокол», глухой удар."""
    x = np.zeros(total)
    slots = np.linspace(int(SR * 3.5), total - int(SR * 3), 11).astype(int)
    kinds = ("screech", "bell", "boom", "creak")
    for i, at in enumerate(slots):
        kind = kinds[i % 4] if i % 7 else "screech"
        kind = kinds[int(RNG.integers(0, 4))]
        if kind == "screech":      # металлический скрежет ~1.6 с
            dur = int(SR * 1.6)
            seg = np.zeros(dur)
            for f in (1230.0, 1741.0, 2453.0, 3120.0):
                wob = 1.0 + 0.02 * np.sin(2 * np.pi * 7.0
                                          * np.arange(dur) / SR)
                seg += tone(f * float(wob.mean()), dur) * 0.2
            seg += noise_band(dur, 1800, 4200) * 0.3
            seg *= env(dur, 0.25, 0.6) * 0.3
        elif kind == "bell":       # далёкий колокол ~2.6 с
            dur = int(SR * 2.6)
            seg = tone(146.8, dur) * 0.6 + tone(147.9, dur) * 0.6 \
                + tone(220.0, dur) * 0.3
            seg *= np.exp(-np.arange(dur) / (SR * 0.9)) * 0.4
        elif kind == "boom":       # глухой удар из глубины ~1.2 с
            dur = int(SR * 1.2)
            seg = sweep(60, 32, dur) * env(dur, 0.02, 0.7) * 0.8
            seg += noise_band(dur, 40, 200) * env(dur, 0.02, 0.5) * 0.5
        else:                      # скрип металла/дерева ~1.1 с
            dur = int(SR * 1.1)
            seg = lowpass(sweep(120, 95, dur, "saw"), 0.15) \
                * env(dur, 0.35, 0.5) * 0.5
        end = min(total, at + seg.shape[0])
        x[at:end] += seg[:end - at]
    return x


def gen_ambient() -> np.ndarray:
    """Жуткий эмбиент ~44 с, бесшовный луп (кроссфейд хвоста в начало)."""
    tail = int(SR * 3.0)
    body_len = int(SR * 44.0)
    total = body_len + tail
    mono = _drone(total) + _pad(total) + _washes(total) + _events(total)
    # нормализация с запасом
    peak = np.max(np.abs(mono))
    mono = mono / peak * 0.85
    # хвост (tail) кроссфейдим в начало — луп без стыка
    body = mono[:body_len]
    fade = np.linspace(0.0, 1.0, tail)
    body[-tail:] = body[-tail:] * (1.0 - fade) \
        + mono[body_len:body_len + tail] * fade
    body[-tail:] = body[-tail:] / np.max(np.abs(body[-tail:]) + 1e-9) \
        * np.max(np.abs(mono[:tail]))
    # простое псевдо-стерео: правый канал с задержкой и лёгким сдвигом
    delay = int(SR * 0.011)
    left = body
    right = np.roll(body, delay)
    right[:delay] = body[:delay]
    stereo = np.stack([left, right * 0.94], axis=1)
    return stereo * 0.9


def main() -> None:
    sfx_dir = os.path.join("assets", "audio", "sfx")
    for fname, gen in (
        ("sfx_swing.wav", sfx_swing), ("sfx_throw.wav", sfx_throw),
        ("sfx_hit.wav", sfx_hit), ("sfx_hurt.wav", sfx_hurt),
        ("sfx_die.wav", sfx_die), ("sfx_bolt.wav", sfx_bolt),
        ("sfx_chest.wav", sfx_chest), ("sfx_coin.wav", sfx_coin),
        ("sfx_levelup.wav", sfx_levelup), ("sfx_dust.wav", sfx_dust),
        ("sfx_gas.wav", sfx_gas), ("sfx_shield.wav", sfx_shield),
        ("sfx_barrier.wav", sfx_barrier), ("sfx_stairs.wav", sfx_stairs),
    ):
        save_wav(sfx_dir, fname, gen(), stereo=False)
    save_wav(os.path.join("assets", "audio", "music"),
             "ambient_dungeon.wav", gen_ambient(), stereo=True)


if __name__ == "__main__":
    main()
