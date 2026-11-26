# -*- coding: utf-8 -*-
"""Шаг 27: иконки приёмов для слотов HUD (Q / пробел / T).

12 иконок 32x32 — по одной на приём каждого класса. Слот в консоли
52x52, иконка показывается 1:1 (32 px), на экране x2 = 64 px.
Стиль: тёмно-синий фон с золотой рамкой, пиксельный глиф по палитре
класса (сталь, магия-циан, яд-зелёный, ярость-красный).

  whirl        — вихрь клинка (воин Q)
  hold_shield  — оборона щитом (воин пробел)
  sword_rain   — град мечей (воин T)
  axe          — метательный топор (варвар Q)
  death_leap   — смертельный прыжок (варвар пробел)
  titan_rage   — гнев титана (варвар T)
  dust         — горсть пыли (бомж Q)
  gas          — гнилой газ (бомж пробел)
  second_wind  — передышка (бомж T)
  spell        — магия (маг Q)
  hold_barrier — барьер (маг пробел)
  mana_burst   — выплеск магии (маг T)

Запуск:  python3 tools/gen_icons_step27.py
Результат: assets/sprites/icons/ability_<kind>.png
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from px import Cv, INK, C, shade  # noqa: E402

OUT_ICONS = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                         "assets", "sprites", "icons")

BG = C(26, 24, 42, 255)
BG_HI = C(38, 34, 58, 255)
GOLD = C(222, 178, 60)
GOLD_HI = C(246, 214, 120)
STEEL = C(186, 196, 210)
STEEL_HI = C(230, 236, 246)
STEEL_DK = C(120, 130, 150)
MAGIC = C(110, 200, 235)
MAGIC_HI = C(190, 240, 252)
POISON = C(118, 178, 92)
POISON_HI = C(180, 226, 140)
RAGE = C(206, 74, 52)
RAGE_HI = C(244, 132, 96)
DUSTC = C(168, 152, 132)
DUST_HI = C(208, 196, 176)


def base() -> Cv:
    """Фон слота: тёмный квадрат с золотой рамкой и внутренней подсветкой."""
    cv = Cv(32, 32)
    cv.R(1, 1, 30, 30, BG)
    cv.R(2, 2, 29, 29, BG_HI)
    for i in range(32):
        for j in range(32):
            if i in (0, 31) or j in (0, 31):
                cv.P(i, j, GOLD)
    # блики рамки по углам (тот же приём, что у рамок UI)
    cv.P(1, 1, GOLD_HI)
    cv.P(30, 1, GOLD_HI)
    cv.P(1, 30, GOLD_HI)
    cv.P(30, 30, GOLD_HI)
    return cv


def blade(cv, cx, cy, dx, dy, c_body=STEEL, c_hi=STEEL_HI):
    """Маленький клинок из центра (dx, dy) — диагональ 5-6 px."""
    for i in range(6):
        x = cx + dx * i
        y = cy + dy * i
        cv.P(x, y, c_body)
        cv.P(x + (1 if dx >= 0 else -1), y, shade(c_body, -0.2))
    cv.P(cx + dx * 5, cy + dy * 5, c_hi)


def icon_whirl() -> Cv:
    cv = base()
    # три клинка по кругу вокруг центра — вихрь
    for dx, dy in ((2, 0), (-1, 2), (-1, -2)):
        blade(cv, 13, 15, dx, dy)
    cv.ellipse(15, 15, 3, 3, MAGIC)
    cv.P(15, 14, MAGIC_HI)
    cv.P(14, 15, MAGIC_HI)
    return cv


def icon_hold_shield() -> Cv:
    cv = base()
    # щит: круглая верхушка, остриё вниз
    cv.ellipse(16, 11, 8, 4, STEEL)          # круглая голова щита
    for y in range(12, 24):
        half = max(1, 8 - (y - 12))
        cv.HLINE(y, 16 - half, 16 + half, STEEL)
    cv.HLINE(9, 10, 14, STEEL_HI)            # блик слева
    cv.P(10, 10, STEEL_HI)
    cv.R(15, 8, 17, 12, GOLD)                # босса
    cv.VLINE(16, 13, 19, GOLD)               # грань к острию
    cv.P(16, 22, GOLD_HI)
    cv.VLINE(16, 23, 23, GOLD)
    return cv


def icon_sword_rain() -> Cv:
    cv = base()
    # три клинка остриями вниз на разной высоте
    for x, y0 in ((9, 6), (16, 10), (23, 6)):
        for i in range(8):
            cv.P(x, y0 + i, STEEL)
            cv.P(x + 1, y0 + i, STEEL_DK)
        cv.P(x, y0 + 8, STEEL_HI)
        cv.HLINE(y0 + 9, x - 2, x + 3, GOLD)
    return cv


def icon_axe() -> Cv:
    cv = base()
    # метательный топор: лезвие сверху, рукоять по диагонали
    cv.R(18, 6, 25, 14, STEEL)
    cv.R(19, 6, 24, 7, STEEL_HI)
    cv.R(18, 13, 25, 14, STEEL_DK)
    cv.VLINE(21, 15, 15, STEEL_DK)
    for i in range(11):
        cv.P(18 - i // 2, 14 + i, C(138, 90, 43, 255))
        cv.P(19 - i // 2, 14 + i, C(170, 116, 62, 255))
    cv.P(13, 24, C(96, 62, 34, 255))
    return cv


def icon_death_leap() -> Cv:
    cv = base()
    # дуга прыжка со стрелкой вниз
    pts = [(7, 22), (8, 16), (11, 11), (16, 9), (21, 11), (24, 16), (25, 21)]
    for i in range(len(pts) - 1):
        x0, y0 = pts[i]
        x1, y1 = pts[i + 1]
        steps = max(abs(x1 - x0), abs(y1 - y0)) + 1
        for s in range(steps):
            x = x0 + (x1 - x0) * s // max(1, steps - 1)
            y = y0 + (y1 - y0) * s // max(1, steps - 1)
            cv.P(x, y, MAGIC_HI)
    cv.VLINE(25, 21, 24, RAGE_HI)
    cv.P(23, 24, RAGE)
    cv.P(24, 24, RAGE)
    cv.P(25, 25, RAGE)
    cv.P(26, 24, RAGE)
    cv.P(27, 24, RAGE)
    cv.P(24, 25, RAGE_HI)
    cv.P(26, 25, RAGE_HI)
    return cv


def icon_titan_rage() -> Cv:
    cv = base()
    # кулак: костяшки вверх, искры ярости
    cv.R(10, 12, 21, 21, C(236, 179, 134, 255))
    cv.R(10, 12, 21, 14, C(249, 208, 172, 255))
    for x in range(11, 21, 3):
        cv.VLINE(x, 13, 15, C(206, 138, 98, 255))
    cv.R(10, 22, 21, 24, C(206, 138, 98, 255))
    cv.HLINE(12, 11, 20, C(206, 138, 98, 255))   # линия костяшек
    cv.VLINE(10, 12, 24, C(206, 138, 98, 255))   # боковая тень
    for x, y in ((8, 8), (23, 7), (16, 5), (26, 12), (6, 14)):
        cv.P(x, y, RAGE_HI)
        cv.P(x - 1, y + 1, RAGE)
    return cv


def icon_dust() -> Cv:
    cv = base()
    # облачко пыли из горсти
    for cx, cy, r in ((11, 18, 3), (16, 15, 4), (21, 18, 3), (14, 20, 3)):
        for y in range(cy - r, cy + r + 1):
            for x in range(cx - r, cx + r + 1):
                if (x - cx) ** 2 + (y - cy) ** 2 <= r * r:
                    cv.P(x, y, DUSTC)
    cv.P(15, 14, DUST_HI)
    cv.P(16, 14, DUST_HI)
    cv.P(10, 17, DUST_HI)
    cv.P(20, 17, DUST_HI)
    # ладонь снизу
    cv.HLINE(23, 12, 19, C(236, 179, 134, 255))
    return cv


def icon_gas() -> Cv:
    cv = base()
    # пузыри гнилого газа поднимаются
    for cx, cy, r in ((10, 20, 3), (17, 15, 4), (22, 19, 2), (14, 11, 2)):
        for y in range(cy - r, cy + r + 1):
            for x in range(cx - r, cx + r + 1):
                d2 = (x - cx) ** 2 + (y - cy) ** 2
                if d2 <= r * r:
                    cv.P(x, y, POISON if d2 > r * r // 2 else POISON_HI)
    return cv


def icon_second_wind() -> Cv:
    cv = base()
    # крест лечения + искра бодрости
    cv.R(13, 8, 18, 24, POISON)
    cv.R(8, 13, 23, 18, POISON)
    cv.R(14, 9, 17, 23, POISON_HI)
    cv.R(9, 14, 22, 17, POISON_HI)
    cv.P(24, 7, GOLD_HI)
    cv.P(7, 24, GOLD_HI)
    return cv


def icon_spell() -> Cv:
    cv = base()
    # магическая стрела: звезда-комета с хвостом
    cv.R(14, 13, 18, 17, MAGIC)
    cv.P(15, 14, MAGIC_HI)
    cv.P(16, 14, MAGIC_HI)
    cv.P(15, 15, MAGIC_HI)
    for i in range(4):
        cv.P(12 - i, 20 + i, MAGIC)
        cv.P(13 - i, 20 + i, shade(MAGIC, -0.25))
    cv.P(16, 9, MAGIC_HI)
    cv.P(16, 21, MAGIC_HI)
    cv.P(9, 15, MAGIC_HI)
    cv.P(23, 15, MAGIC_HI)
    return cv


def icon_hold_barrier() -> Cv:
    cv = base()
    # купол барьера над героем: узко сверху, широко снизу
    for y in range(7, 21):
        half = int(round(((y - 6) / 14.0) * 9.0)) + 3
        cv.HLINE(y, 16 - half, 16 + half, MAGIC)
    for y in range(7, 21):
        half = int(round(((y - 6) / 14.0) * 9.0)) + 3
        cv.P(16 - half, y, MAGIC_HI)
        cv.P(16 + half, y, MAGIC_HI)
    cv.HLINE(21, 5, 27, MAGIC_HI)            # опора купола
    cv.R(14, 22, 18, 26, C(236, 179, 134, 255))
    cv.P(14, 22, C(249, 208, 172, 255))
    return cv


def icon_mana_burst() -> Cv:
    cv = base()
    # выплеск: 8 лучей из центра
    for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (-1, 1), (1, -1), (-1, -1)):
        for i in range(1, 7):
            cv.P(16 + dx * i, 16 + dy * i, MAGIC if i < 5 else MAGIC_HI)
    cv.ellipse(16, 16, 3, 3, MAGIC_HI)
    cv.P(16, 16, C(255, 255, 255, 255))
    return cv


ICONS = {
    "whirl": icon_whirl,
    "hold_shield": icon_hold_shield,
    "sword_rain": icon_sword_rain,
    "axe": icon_axe,
    "death_leap": icon_death_leap,
    "titan_rage": icon_titan_rage,
    "dust": icon_dust,
    "gas": icon_gas,
    "second_wind": icon_second_wind,
    "spell": icon_spell,
    "hold_barrier": icon_hold_barrier,
    "mana_burst": icon_mana_burst,
}


def main() -> None:
    os.makedirs(OUT_ICONS, exist_ok=True)
    print("Шаг 27: иконки приёмов ->", OUT_ICONS)
    for kind, fn in ICONS.items():
        cv = fn()
        cv.outline(shade(BG, -0.5), inside=True)   # мягкий контур глифа
        path = os.path.join(OUT_ICONS, "ability_%s.png" % kind)
        cv.img.save(path)
        print("  -> ability_%s.png" % kind)
    print("OK: %d иконок" % len(ICONS))


if __name__ == "__main__":
    main()
