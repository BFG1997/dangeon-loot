# -*- coding: utf-8 -*-
"""Шаг 20: ПЕРЕГЕНЕРАЦИЯ звука «Dungeon Loot» — мягче и приятнее.

Отзыв игрока на шаг 19: звуки резкие, эмбиент жёсткий и немелодичный.
Здесь весь звук синтезируется заново по новым правилам:

  SFX (все 14 прежних имён + 4 новых для приёмов T):
    - меньше резких высоких частот (шумовые полосы срезаны ниже),
    - пила/квадрат заменены синусами и мягкими гармониками,
    - атаки огибающих длиннее — нет щелчков на старте,
    - каждый эффект мягко занижен по громкости и прогнан через ФНЧ,
    - новые: sfx_surge (выплеск магии мага), sfx_heal (передышка бомжа),
      sfx_leap (смертельный прыжок варвара), sfx_rain (град мечей рыцаря).

  ambient_dungeon.wav — эмбиент в духе Silent Hill, но МЕЛОДИЧНЫЙ:
    ля минор, тёплые аккорды Am–F–C–E, колыбельная колокольная мелодия
    с эхом, мягкий ветер; жёсткие скрежеты убраны — редкий далёкий
    колокол и глухой удар остались, но втрое тише. Бесшовный луп ~48 с.

Запуск:  python3 tools/gen_audio_step20.py
Результат: assets/audio/sfx/*.wav, assets/audio/music/ambient_dungeon.wav
"""
import os
import numpy as np
import wave

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SR = 22050
RNG = np.random.default_rng(201043)

# Общий запас громкости: эффекты заметно мягче шага 19 (там пик 0.8-0.9).
SFX_PEAK = 0.58


def save_wav(rel_dir: str, name: str, data: np.ndarray, stereo: bool = True,
             peak: float = SFX_PEAK) -> None:
    out_dir = os.path.join(ROOT, rel_dir)
    os.makedirs(out_dir, exist_ok=True)
    path = os.path.join(out_dir, name)
    if not stereo:
        data = np.stack([data, data], axis=1)
    # мягкая нормализация: пик ниже, без жёсткого клиппинга
    peak_now = np.max(np.abs(data))
    if peak_now > 0:
        data = data / peak_now * peak
    data = np.clip(data, -1.0, 1.0)
    pcm = (data * 32767.0).astype("<i2")
    with wave.open(path, "wb") as w:
        w.setnchannels(2)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(pcm.tobytes())
    print("OK", os.path.relpath(path, ROOT), "%.2f с" % (pcm.shape[0] / SR))


def env(n: int, attack: float, release: float) -> np.ndarray:
    """Огибающая: плавная атака и спад (доли длины). Атака мягче шага 19."""
    t = np.linspace(0.0, 1.0, n)
    a = np.clip(t / max(attack, 1e-4), 0.0, 1.0)
    a = a * a * (3.0 - 2.0 * a)          # smoothstep — без щелчка
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
    if shape == "tri":
        return 2.0 * np.abs(2.0 * ((freq * t + phase / (2 * np.pi)) % 1.0) - 1.0) - 1.0
    return np.sin(2 * np.pi * freq * t + phase)


def sweep(f0: float, f1: float, n: int, shape: str = "sine") -> np.ndarray:
    t = np.arange(n) / SR
    freqs = np.geomspace(f0, f1, n)
    phase = 2 * np.pi * np.cumsum(freqs) / SR
    return np.sin(phase)


# ------------------------------------------------------------------ SFX
# Все эффекты шага 20: тихие, мягкие, без верхних 4-5 кГц.

def sfx_swing() -> np.ndarray:
    """Свист взмаха: дышащий шум без жала (было 500-3000, стало мягче)."""
    n = int(SR * 0.24)
    base = noise_band(n, 350, 1400)
    lfo = sweep(420, 1500, n)
    x = base * (0.45 + 0.55 * np.abs(lfo) / 1500.0)
    x = lowpass(x, 0.45)
    x *= env(n, 0.3, 0.5)
    return x * 0.62


def sfx_throw() -> np.ndarray:
    """Тяжёлый бросок: мягкий свист + глухой толчок."""
    n = int(SR * 0.32)
    x = noise_band(n, 220, 900) * env(n, 0.22, 0.45) * 0.5
    thump = sweep(130, 55, n) * env(n, 0.04, 0.6) * 0.7
    return lowpass(x * 0.6 + thump * 0.5, 0.4)


def sfx_hit() -> np.ndarray:
    """Удар: глухой толчок + короткий шорох (треск убран вниз)."""
    n = int(SR * 0.18)
    crack = noise_band(n, 400, 1900) * env(n, 0.01, 0.3) * 0.5
    thump = sweep(150, 62, n) * env(n, 0.02, 0.45) * 0.75
    return lowpass(crack * 0.6 + thump * 0.6, 0.4)


def sfx_hurt() -> np.ndarray:
    """Герой получил урон: мягкий стон-свип вниз."""
    n = int(SR * 0.3)
    x = sweep(175, 82, n) * env(n, 0.08, 0.5)
    x += noise_band(n, 90, 550) * env(n, 0.05, 0.4) * 0.25
    return lowpass(x * 0.7, 0.35)


def sfx_die() -> np.ndarray:
    """Враг рассыпался: мягкий нисходящий вздох (без пилы)."""
    n = int(SR * 0.52)
    x = sweep(240, 72, n) * env(n, 0.06, 0.55) * 0.5
    x += tone(120.0, n) * env(n, 0.05, 0.5) * 0.2
    x += noise_band(n, 120, 620) * env(n, 0.04, 0.6) * 0.35
    return lowpass(x, 0.28)


def sfx_bolt() -> np.ndarray:
    """Каст магии: тёплый свип с тихой harmonic."""
    n = int(SR * 0.34)
    x = sweep(880, 280, n) * 0.55
    x += sweep(1320, 420, n) * 0.12
    x += noise_band(n, 700, 2200) * env(n, 0.12, 0.4) * 0.1
    return lowpass(x * env(n, 0.08, 0.45), 0.4)


def sfx_chest() -> np.ndarray:
    """Открытие сундука: мягкий скрип + нежный блеск находки."""
    n = int(SR * 0.46)
    creak = lowpass(sweep(85, 62, n, "tri"), 0.16) * env(n, 0.18, 0.5) * 0.42
    sparkle = np.zeros(n)
    for i, f in enumerate((1046.5, 1318.5, 1568.0)):
        seg = tone(f, n) * np.exp(-np.arange(n) / (SR * 0.12))
        shift = np.zeros(n)
        d = i * int(SR * 0.06)
        shift[d:] = seg[:n - d]
        sparkle += shift * 0.13
    return lowpass(creak + sparkle, 0.5)


def sfx_coin() -> np.ndarray:
    """Золото: двойной мягкий звон."""
    n = int(SR * 0.24)
    x = np.zeros(n)
    for i, f in enumerate((1046.5, 1318.5)):
        seg = tone(f, n) + 0.22 * tone(f * 2.01, n)
        fade = np.exp(-np.arange(n) / (SR * 0.09))
        delay = int(i * SR * 0.07)
        x[delay:] += (seg * fade)[:(n - delay)] * 0.36
    return lowpass(x * env(n, 0.006, 0.5), 0.5)


def sfx_levelup() -> np.ndarray:
    """Повышение уровня: нежный восходящий перелив."""
    n = int(SR * 1.5)
    x = np.zeros(n)
    notes = (523.25, 659.25, 783.99, 1046.5, 1318.5)
    for i, f in enumerate(notes):
        delay = int(i * SR * 0.14)
        dur = n - delay
        seg = (tone(f, dur) + 0.2 * tone(f * 2, dur))
        fade = np.exp(-np.arange(dur) / (SR * 0.35))
        x[delay:] += seg * fade * 0.26
    x += noise_band(n, 1800, 4200) * env(n, 0.25, 0.5) * 0.03
    return lowpass(x * env(n, 0.01, 0.3), 0.5)


def sfx_dust() -> np.ndarray:
    """Горсть пыли: глухой шлепок с оседающим шумом."""
    n = int(SR * 0.46)
    x = noise_band(n, 150, 750) * env(n, 0.07, 0.5) * 0.55
    x += sweep(110, 55, n) * env(n, 0.03, 0.4) * 0.4
    return lowpass(x, 0.26)


def sfx_gas() -> np.ndarray:
    """Гнилой газ: мягкое шипение с клокотанием."""
    n = int(SR * 0.72)
    hiss = noise_band(n, 280, 1300) * env(n, 0.32, 0.45) * 0.32
    rumble = sweep(65, 44, n) * env(n, 0.22, 0.5) * 0.4
    lfo = 0.65 + 0.35 * np.sin(2 * np.pi * 11 * np.arange(n) / SR)
    return lowpass((hiss * lfo + rumble), 0.3) * 0.8


def sfx_shield() -> np.ndarray:
    """Щит: приглушённый лязг (высокие обертоны сняты)."""
    n = int(SR * 0.42)
    x = np.zeros(n)
    for f, a in ((660, 0.4), (880, 0.25), (1175, 0.15)):
        x += tone(f, n) * np.exp(-np.arange(n) / (SR * 0.15)) * a
    x += noise_band(n, 800, 2400) * env(n, 0.01, 0.12) * 0.12
    return lowpass(x * env(n, 0.01, 0.25), 0.4)


def sfx_barrier() -> np.ndarray:
    """Барьер мага: мерцающий мягкий хор."""
    n = int(SR * 0.58)
    x = np.zeros(n)
    for i, f in enumerate((587, 740, 880, 1109)):
        seg = tone(f, n, phase=i * 0.7)
        x += seg * env(n, 0.3 + i * 0.05, 0.4) * 0.18
    return lowpass(x, 0.35)


def sfx_stairs() -> np.ndarray:
    """Каменные ступени: два глухих шага."""
    n = int(SR * 0.46)
    x = np.zeros(n)
    for delay, f in ((0, 92), (int(SR * 0.19), 78)):
        dur = n - delay
        seg = sweep(f, f * 0.5, dur) * env(dur, 0.02, 0.5) * 0.7
        seg += noise_band(dur, 80, 420) * env(dur, 0.02, 0.3) * 0.25
        x[delay:] += seg
    return lowpass(x, 0.3)


# --- новые эффекты приёмов T (шаг 20) ---

def sfx_surge() -> np.ndarray:
    """Выплеск магии (маг, T): взлёт и мягкий взрыв волны."""
    n = int(SR * 0.8)
    rise = sweep(180, 720, int(n * 0.35)) * env(int(n * 0.35), 0.2, 0.5) * 0.5
    boom_n = n - int(n * 0.35)
    boom = sweep(220, 48, boom_n) * env(boom_n, 0.02, 0.55) * 0.8
    boom += noise_band(boom_n, 120, 800) * env(boom_n, 0.02, 0.4) * 0.3
    x = np.zeros(n)
    x[:int(n * 0.35)] = rise
    x[int(n * 0.35):] = boom
    shimmer = np.zeros(n)
    for i, f in enumerate((784, 988, 1319)):
        seg = tone(f, n) * np.exp(-np.arange(n) / (SR * 0.18))
        d = int(n * 0.38) + i * int(SR * 0.03)
        shimmer[d:] += seg[:n - d] * 0.1
    return lowpass(x + shimmer, 0.35)


def sfx_heal() -> np.ndarray:
    """Передышка бомжа (T): тёплое мажорное трезвучие."""
    n = int(SR * 1.1)
    x = np.zeros(n)
    for i, f in enumerate((523.25, 659.25, 783.99, 1046.5)):
        delay = int(i * SR * 0.09)
        dur = n - delay
        seg = tone(f, dur) + 0.18 * tone(f * 2, dur)
        fade = np.exp(-np.arange(dur) / (SR * 0.4))
        x[delay:] += seg * fade * 0.22
    return lowpass(x * env(n, 0.01, 0.35), 0.45)


def sfx_leap() -> np.ndarray:
    """Смертельный прыжок варвара (T): взлёт и сокрушительный приземление."""
    n = int(SR * 0.7)
    up_n = int(n * 0.4)
    whoosh = noise_band(up_n, 300, 1500) * env(up_n, 0.15, 0.4) * 0.5
    rise = sweep(140, 520, up_n) * env(up_n, 0.2, 0.4) * 0.35
    land_n = n - up_n
    slam = sweep(110, 38, land_n) * env(land_n, 0.01, 0.5) * 0.9
    slam += noise_band(land_n, 60, 380) * env(land_n, 0.01, 0.35) * 0.45
    x = np.zeros(n)
    x[:up_n] = whoosh * 0.6 + rise
    x[up_n:] = slam
    return lowpass(x, 0.35)


def sfx_rain() -> np.ndarray:
    """Град мечей рыцаря (T): россыпь стальных звонов."""
    n = int(SR * 1.3)
    x = np.zeros(n)
    pings = 11
    for i in range(pings):
        f = float(RNG.choice([1175, 1319, 1568, 1760, 2093]))
        at = int(i * n / (pings + 1.0) + RNG.integers(0, int(SR * 0.05)))
        dur = n - at
        seg = tone(f, dur) + 0.25 * tone(f * 1.51, dur)
        fade = np.exp(-np.arange(dur) / (SR * 0.1))
        x[at:] += seg * fade * 0.16
    x += noise_band(n, 900, 3000) * env(n, 0.3, 0.5) * 0.05
    return lowpass(x * env(n, 0.01, 0.3), 0.45)


# -------------------------------------------------------------- эмбиент
# Ля минор: тёплые аккорды, колокольная мелодия, мягкий ветер.

NOTE_FREQS = {
    "A1": 55.0, "E2": 82.41, "A2": 110.0, "C3": 130.81, "E3": 164.81,
    "F3": 174.61, "G3": 196.0, "A3": 220.0, "B3": 246.94, "C4": 261.63,
    "D4": 293.66, "E4": 329.63, "F4": 349.23, "G4": 392.0, "A4": 440.0,
    "B4": 493.88, "C5": 523.25, "D5": 587.33, "E5": 659.26, "G5": 783.99,
}


def _pad_chord(total: int, chord: list, t0: float, dur: float) -> np.ndarray:
    """Мягкий аккорд-пад: синусы с лёгкой расстройкой и медленными огибающими."""
    n0 = int(t0 * SR)
    n1 = min(total, int((t0 + dur) * SR))
    seg = np.zeros(n1 - n0)
    ln = n1 - n0
    for name in chord:
        f = NOTE_FREQS[name]
        det = 1.0 + 0.0015 * RNG.standard_normal()
        voice = (np.sin(2 * np.pi * f * det * np.arange(ln) / SR)
                 + 0.35 * np.sin(2 * np.pi * f * 2.003 * np.arange(ln) / SR)
                 + 0.12 * np.sin(2 * np.pi * f * 0.5 * np.arange(ln) / SR))
        seg += voice * (1.0 / len(chord))
    seg = lowpass(seg, 0.16)
    seg *= env(ln, 0.3, 0.42)
    out = np.zeros(total)
    out[n0:n1] += seg
    return out


def _melody(total: int) -> np.ndarray:
    """Колокольная мелодия: медленные ноты ля-минора с эхом (тихо, нежно)."""
    # (время с, нота, сила) — колыбельная фраза поверх Am–F–C–E
    phrase = [
        (1.5, "E5", 0.9), (4.0, "C5", 0.8), (6.5, "B4", 0.75),
        (9.0, "A4", 0.9), (13.0, "G4", 0.7), (15.5, "E4", 0.8),
        (18.0, "A4", 0.85), (21.5, "C5", 0.75), (24.0, "D5", 0.7),
        (26.5, "E5", 0.8), (30.5, "B4", 0.7), (33.0, "C5", 0.75),
        (35.5, "A4", 0.9), (39.5, "G4", 0.7), (42.0, "E4", 0.75),
        (44.5, "A4", 0.8),
    ]
    x = np.zeros(total)
    for (t0, name, amp) in phrase:
        f = NOTE_FREQS[name]
        dur = int(SR * 2.8)
        n0 = int(t0 * SR)
        if n0 + dur > total:
            dur = total - n0
            if dur <= 0:
                continue
        tt = np.arange(dur) / SR
        seg = (np.sin(2 * np.pi * f * tt)
               + 0.3 * np.sin(2 * np.pi * f * 2.0 * tt + 0.4)
               + 0.1 * np.sin(2 * np.pi * f * 3.01 * tt))
        seg *= np.exp(-tt / 1.1) * env(dur, 0.004, 0.2) * amp * 0.14
        x[n0:n0 + dur] += seg
        # эхо через 0.45 с, тише вдвое
        d = int(SR * 0.45)
        if n0 + d + dur < total:
            x[n0 + d:n0 + d + dur] += seg * 0.4
    return x


def _drone_soft(total: int) -> np.ndarray:
    """Глубокий тёплый дрон: A1+E2 с почти незаметным биением."""
    t = np.arange(total) / SR
    x = (np.sin(2 * np.pi * 55.0 * t)
         + 0.6 * np.sin(2 * np.pi * 55.15 * t)      # биение 0.15 Гц
         + 0.55 * np.sin(2 * np.pi * 82.41 * t + 0.5)
         + 0.3 * np.sin(2 * np.pi * 110.0 * t))
    lfo = 0.6 + 0.4 * np.sin(2 * np.pi * t / 16.0 + 1.0)
    return x * lfo * 0.16


def _wind_soft(total: int) -> np.ndarray:
    """Мягкий дальний ветер: узкий шум, медленные валы."""
    n = noise_band(total, 90, 480)
    t = np.arange(total) / SR
    swell = 0.4 + 0.6 * np.clip(np.sin(2 * np.pi * t / 11.0 - 2.0), 0, 1)
    return lowpass(n, 0.3) * swell * 0.09


def _events_soft(total: int) -> np.ndarray:
    """Редкие тихие события: далёкий колокол и глухой удар (без скрежетов)."""
    x = np.zeros(total)
    slots = np.linspace(int(SR * 6.0), total - int(SR * 5), 5).astype(int)
    for i, at in enumerate(slots):
        if i % 2 == 0:      # далёкий колокол: чистая нота с частичным
            dur = int(SR * 3.2)
            seg = (tone(220.0, dur) + 0.4 * tone(331.0, dur)
                   + 0.2 * tone(442.0, dur))
            seg *= np.exp(-np.arange(dur) / (SR * 1.3)) * 0.16
        else:               # глухой удар из глубины
            dur = int(SR * 1.6)
            seg = sweep(55, 30, dur) * env(dur, 0.05, 0.7) * 0.28
            seg += noise_band(dur, 35, 160) * env(dur, 0.05, 0.5) * 0.14
        end = min(total, at + seg.shape[0])
        x[at:end] += seg[:end - at]
    return lowpass(x, 0.35)


def gen_ambient() -> np.ndarray:
    """Мелодичный эмбиент ~48 с, бесшовный луп (кроссфейд хвоста в начало)."""
    tail = int(SR * 3.0)
    body_len = int(SR * 48.0)
    total = body_len + tail
    # гармоническая сетка: 12-секундные аккорды Am → F → C → E (луп = 48 с)
    mono = np.zeros(total)
    prog = (["A2", "C3", "E3", "A3"], ["F3", "A3", "C4", "F4"],
            ["C3", "E3", "G3", "C4"], ["E3", "G3", "B3", "E4"])
    for i, chord in enumerate(prog):
        mono += _pad_chord(total, chord, i * 12.0, 13.5)
    mono += _drone_soft(total)
    mono += _melody(total)
    mono += _wind_soft(total)
    mono += _events_soft(total)
    peak = np.max(np.abs(mono))
    mono = mono / peak * 0.6
    # хвост кроссфейдим в начало — луп без стыка
    body = mono[:body_len]
    fade = np.linspace(0.0, 1.0, tail)
    body[-tail:] = body[-tail:] * (1.0 - fade) \
        + mono[body_len:body_len + tail] * fade
    body[-tail:] = body[-tail:] / (np.max(np.abs(body[-tail:]) + 1e-9)) \
        * np.max(np.abs(mono[:tail]))
    # псевдо-стерео: правый канал с задержкой и лёгким сдвигом
    delay = int(SR * 0.013)
    left = body
    right = np.roll(body, delay)
    right[:delay] = body[:delay]
    stereo = np.stack([left, right * 0.95], axis=1)
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
        # шаг 20: приёмы T
        ("sfx_surge.wav", sfx_surge), ("sfx_heal.wav", sfx_heal),
        ("sfx_leap.wav", sfx_leap), ("sfx_rain.wav", sfx_rain),
    ):
        save_wav(sfx_dir, fname, gen(), stereo=False)
    save_wav(os.path.join("assets", "audio", "music"),
             "ambient_dungeon.wav", gen_ambient(), stereo=True, peak=0.62)


if __name__ == "__main__":
    main()
