# -*- coding: utf-8 -*-
"""Шаг 31: иконки приёмов новых героев (Демоноолог и Некромант).

8 иконок 32x32 в стиле gen_icons_step27 (тёмный фон, золотая рамка):
  summon          — призыв демона (Демоноолог Q)
  summon_winged   — крылатый демон (пробел)
  summon_huge     — огромный демон (T)
  summon_succubus — суккуб (Ctrl)
  resurrect       — подъём мёртвых (Некромант Q)
  phase           — прохождение сквозь стены (пробел)
  madness         — безумие (T)
  summon_boss     — зов поверженного босса (Ctrl)

Запуск:  python3 tools/gen_icons_step31.py
Результат: assets/sprites/icons/ability_<kind>.png
"""
import os
import sys

TOOLS = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, TOOLS)
from px import Cv, C, shade  # noqa: E402
from gen_icons_step27 import base  # noqa: E402  (тот же фон слота)

GAME = os.path.dirname(TOOLS)
OUT_ICONS = os.path.join(GAME, "assets", "sprites", "icons")

DEMON = C(196, 74, 58)
DEMON_HI = C(240, 132, 96)
DEMON_D = C(132, 44, 40)
VIOLET = C(148, 86, 200)
VIOLET_HI = C(204, 152, 250)
BONE = C(214, 204, 182)
BONE_HI = C(242, 236, 220)
BONE_D = C(172, 156, 134)
NECRO = C(110, 190, 120)
NECRO_HI = C(170, 240, 176)
GOLD = C(222, 178, 60)
GOLD_HI = C(246, 214, 120)


def icon_summon() -> Cv:
    cv = base()
    # голова демона: рога, глаза-угольки
    cv.R(11, 8, 20, 19, DEMON)
    cv.R(12, 6, 19, 8, DEMON)
    cv.R(9, 4, 11, 9, BONE)          # рога
    cv.R(20, 4, 22, 9, BONE)
    cv.P(9, 3, BONE_HI)
    cv.P(22, 3, BONE_HI)
    cv.R(13, 12, 14, 14, C(255, 214, 120))   # глаза
    cv.R(17, 12, 18, 14, C(255, 214, 120))
    cv.HLINE(17, 14, 17, DEMON_D)
    cv.R(12, 20, 19, 23, DEMON_D)    # подбородок
    cv.outline()
    return cv


def icon_winged() -> Cv:
    cv = base()
    cv.R(12, 10, 19, 20, DEMON)      # тело
    cv.R(13, 6, 18, 10, DEMON_HI)    # голова
    cv.R(6, 8, 11, 17, VIOLET)       # левое крыло
    cv.R(20, 8, 25, 17, VIOLET)
    cv.R(7, 9, 10, 12, VIOLET_HI)
    cv.R(21, 9, 24, 12, VIOLET_HI)
    cv.VLINE(6, 8, 17, BONE)
    cv.VLINE(25, 8, 17, BONE)
    cv.R(13, 8, 14, 10, C(255, 214, 120))    # глаза
    cv.R(17, 8, 18, 10, C(255, 214, 120))
    cv.R(13, 21, 18, 24, DEMON_D)    # лапы
    cv.outline()
    return cv


def icon_huge() -> Cv:
    cv = base()
    # огромный силуэт во весь слот
    cv.R(7, 7, 24, 26, DEMON_D)
    cv.R(9, 6, 22, 12, DEMON)
    cv.R(11, 3, 13, 7, BONE)         # рога крупнее
    cv.R(18, 3, 20, 7, BONE)
    cv.P(11, 2, BONE_HI)
    cv.P(20, 2, BONE_HI)
    cv.R(12, 12, 14, 15, C(255, 214, 120))
    cv.R(17, 12, 19, 15, C(255, 214, 120))
    cv.HLINE(16, 13, 18, DEMON_D)
    cv.R(9, 14, 11, 22, DEMON)       # руки
    cv.R(20, 14, 22, 22, DEMON)
    cv.R(7, 22, 24, 24, DEMON_D)
    cv.outline()
    return cv


def icon_succubus() -> Cv:
    cv = base()
    cv.R(6, 9, 11, 18, WING := C(74, 36, 88))    # крылья
    cv.R(20, 9, 25, 18, WING)
    cv.R(7, 10, 10, 13, C(108, 56, 124))
    cv.R(21, 10, 24, 13, C(108, 56, 124))
    cv.R(12, 8, 19, 24, C(142, 34, 52))          # платье
    cv.R(13, 5, 18, 8, C(232, 168, 150))         # лицо
    cv.R(10, 3, 12, 6, C(206, 186, 158))         # рога
    cv.R(19, 3, 21, 6, C(206, 186, 158))
    cv.R(14, 6, 15, 7, C(255, 120, 130))         # глаза
    cv.R(17, 6, 18, 7, C(255, 120, 130))
    cv.R(14, 14, 17, 16, GOLD)                   # сердце на груди
    cv.P(13, 15, GOLD)
    cv.P(18, 15, GOLD)
    cv.outline()
    return cv


def icon_resurrect() -> Cv:
    cv = base()
    # череп поднимается из могилы: рука снизу и искры
    cv.R(12, 14, 19, 22, BONE)       # череп
    cv.R(13, 12, 18, 14, BONE)
    cv.R(13, 17, 14, 19, C(40, 36, 46))      # глазницы
    cv.R(17, 17, 18, 19, C(40, 36, 46))
    cv.R(15, 21, 16, 22, shade(BONE, -0.3))
    cv.R(8, 25, 23, 27, C(58, 50, 42))       # земля
    cv.R(14, 23, 17, 25, BONE_D)             # шея/рука
    for (x, y) in ((9, 10), (22, 9), (7, 16), (24, 16)):
        cv.P(x, y, NECRO_HI)         # зелёные искры
        cv.P(x, y + 1, shade(NECRO, -0.2))
    cv.outline()
    return cv


def icon_phase() -> Cv:
    cv = base()
    # силуэт проходит сквозь стену: половина — фантом
    cv.R(6, 6, 14, 25, C(52, 56, 74))        # стена слева
    cv.R(6, 6, 14, 25, C(60, 64, 84))
    cv.VLINE(9, 6, 25, C(44, 48, 64))
    cv.VLINE(12, 6, 25, C(44, 48, 64))
    cv.R(16, 10, 22, 22, VIOLET)             # призрачный силуэт
    cv.R(17, 7, 21, 10, VIOLET_HI)
    cv.R(18, 12, 20, 14, C(30, 28, 44))      # глаза
    cv.P(18, 12, C(255, 255, 255))
    cv.P(20, 12, C(255, 255, 255))
    cv.P(25, 14, VIOLET_HI)                  # след фазового рывка
    cv.P(26, 17, shade(VIOLET, -0.2))
    cv.P(25, 20, VIOLET_HI)
    cv.outline()
    return cv


def icon_madness() -> Cv:
    cv = base()
    # два врага бьют друг друга: зигзаги безумия между ними
    cv.R(7, 12, 13, 24, C(180, 92, 52))      # враг 1
    cv.R(8, 8, 12, 12, C(214, 130, 74))
    cv.R(8, 14, 9, 16, C(255, 214, 120))
    cv.R(18, 12, 24, 24, C(120, 150, 96))    # враг 2
    cv.R(19, 8, 23, 12, C(160, 190, 120))
    cv.R(22, 14, 23, 16, C(255, 214, 120))
    for (x, y) in ((15, 9), (16, 13), (14, 17), (17, 20), (15, 23)):
        cv.P(x, y, C(255, 90, 70))           # злые искры
        cv.P(x - 1, y + 1, C(230, 60, 50))
    cv.outline()
    return cv


def icon_boss() -> Cv:
    cv = base()
    # горящий череп босса с короной — зов поверженного
    cv.R(10, 10, 21, 24, BONE)
    cv.R(12, 7, 19, 10, BONE)
    cv.R(9, 5, 11, 8, GOLD)          # корона
    cv.R(20, 5, 22, 8, GOLD)
    cv.P(15, 4, GOLD_HI)
    cv.P(16, 4, GOLD_HI)
    cv.R(12, 15, 14, 18, C(40, 36, 46))      # глазницы
    cv.R(17, 15, 19, 18, C(40, 36, 46))
    cv.P(13, 16, C(255, 150, 60))    # огонь в глазницах
    cv.P(18, 16, C(255, 150, 60))
    cv.R(14, 21, 17, 23, shade(BONE, -0.3))  # челюсть
    for (x, y) in ((7, 12), (25, 12), (9, 26), (23, 26)):
        cv.P(x, y, DEMON_HI)         # багровые искры призыва
    cv.outline()
    return cv


def main() -> None:
    os.makedirs(OUT_ICONS, exist_ok=True)
    print("Шаг 31: иконки приёмов ->", os.path.relpath(OUT_ICONS, GAME))
    icons = {
        "summon": icon_summon,
        "summon_winged": icon_winged,
        "summon_huge": icon_huge,
        "summon_succubus": icon_succubus,
        "resurrect": icon_resurrect,
        "phase": icon_phase,
        "madness": icon_madness,
        "summon_boss": icon_boss,
    }
    for kind, fn in icons.items():
        path = os.path.join(OUT_ICONS, "ability_%s.png" % kind)
        fn().img.save(path)
        print("  -> ability_%s.png" % kind)
    print("OK")


if __name__ == "__main__":
    main()
