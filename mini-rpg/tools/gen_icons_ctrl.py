# -*- coding: utf-8 -*-
"""Шаг 29: иконки приёмов на Ctrl (у каждого героя свой).

4 иконки 32x32 в стиле шага 27 (тёмно-синий фон, золотая рамка):

  dash   — рывок воина: cyan-шевроны движения
  blink  — телепорт мага: фиолетовый портал со звездой
  kick   — пинок варвара: сапог с линиями скорости
  drink  — хмельной запал бомжа: зелёная бутыль

Запуск:  python3 tools/gen_icons_ctrl.py
Результат: assets/sprites/icons/ability_<kind>.png
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from px import Cv, shade  # noqa: E402

OUT_ICONS = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                         "assets", "sprites", "icons")

BG = (26, 24, 42, 255)
BG_HI = (38, 34, 58, 255)
GOLD = (222, 178, 60, 255)
GOLD_HI = (246, 214, 120, 255)
STEEL = (186, 196, 210, 255)
STEEL_HI = (230, 236, 246, 255)
STEEL_DK = (120, 130, 150, 255)
DASHC = (96, 168, 210, 255)
DASH_HI = (170, 222, 244, 255)
PORTAL = (158, 107, 242, 255)
PORTAL_HI = (208, 172, 252, 255)
BOOZE = (118, 178, 92, 255)
BOOZE_HI = (180, 226, 140, 255)


def base() -> Cv:
    """Фон слота: тёмный квадрат с золотой рамкой и бликами по углам."""
    cv = Cv(32, 32)
    cv.R(1, 1, 30, 30, BG)
    cv.R(2, 2, 29, 29, BG_HI)
    for i in range(32):
        for j in range(32):
            if i in (0, 31) or j in (0, 31):
                cv.P(i, j, GOLD)
    cv.P(1, 1, GOLD_HI)
    cv.P(30, 1, GOLD_HI)
    cv.P(1, 30, GOLD_HI)
    cv.P(30, 30, GOLD_HI)
    return cv


def icon_dash() -> Cv:
    cv = base()
    # три шеврона «>>>» — движение на скорости
    for x0 in (5, 12, 19):
        for i in range(6):
            cv.P(x0 + i, 9 + i, DASHC)
            cv.P(x0 + i + 1, 9 + i, DASH_HI)
            cv.P(x0 + i, 23 - i, DASHC)
            cv.P(x0 + i + 1, 23 - i, DASH_HI)
        cv.P(x0 + 5, 15, DASH_HI)
        cv.P(x0 + 5, 16, DASH_HI)
        cv.P(x0 + 6, 16, shade(DASHC, -0.25))
    # хвост скорости у последнего
    cv.HLINE(15, 26, 28, DASH_HI)
    cv.HLINE(17, 25, 27, DASHC)
    return cv


def icon_blink() -> Cv:
    cv = base()
    # портал: кольцо, тёмная глубина, завихрение и звезда
    for ang in range(0, 360, 10):
        import math
        a = math.radians(ang)
        x = 15 + int(round(9.0 * math.cos(a)))
        y = 15 + int(round(7.0 * math.sin(a)))
        cv.P(x, y, PORTAL)
        cv.P(x, y - 1, shade(PORTAL, -0.2))
    cv.ellipse(15, 15, 6, 4, (18, 12, 34, 255))
    for dx, dy in ((-3, -1), (0, 1), (3, -1), (1, -3)):
        cv.P(15 + dx, 15 + dy, PORTAL_HI)
    # звезда телепорта у верхнего края кольца
    cv.P(24, 8, GOLD_HI)
    cv.P(23, 8, PORTAL_HI)
    cv.P(25, 8, PORTAL_HI)
    cv.P(24, 7, PORTAL_HI)
    cv.P(24, 9, PORTAL_HI)
    cv.HLINE(8, 22, 26, PORTAL_HI)
    return cv


def icon_kick() -> Cv:
    cv = base()
    # сапог варвара: голенище, ступня, стальная подошва, линии удара
    cv.R(10, 7, 15, 15, STEEL)
    cv.R(11, 8, 13, 14, STEEL_DK)
    cv.R(10, 15, 22, 20, STEEL)
    cv.R(12, 16, 20, 19, shade(STEEL, -0.15))
    cv.HLINE(21, 9, 23, GOLD)          # подошва
    cv.HLINE(22, 9, 23, shade(GOLD, -0.2))
    cv.P(23, 21, GOLD_HI)
    cv.VLINE(10, 8, 14, STEEL_HI)      # блик голенища
    cv.HLINE(9, 11, 14, STEEL_HI)
    # линии скорости позади сапога
    cv.HLINE(11, 4, 7, BOOZE_HI)
    cv.HLINE(14, 3, 6, BOOZE)
    cv.HLINE(17, 4, 7, BOOZE_HI)
    return cv


def icon_drink() -> Cv:
    cv = base()
    # бутыль: горлышко, кобальтовая пробка, зелёное стекло, пузырьки
    cv.R(13, 4, 18, 6, GOLD)           # пробка
    cv.HLINE(6, 13, 18, shade(GOLD, -0.25))
    cv.R(14, 7, 17, 10, BOOZE)         # горлышко
    cv.R(11, 11, 20, 25, BOOZE)        # корпус
    cv.R(12, 12, 19, 24, shade(BOOZE, -0.18))
    cv.R(10, 12, 11, 22, BOOZE)        # скругление плеч
    cv.R(20, 12, 21, 22, BOOZE)
    cv.VLINE(12, 13, 23, BOOZE_HI)     # блик стекла
    cv.HLINE(14, 11, 21, BOOZE_HI)
    # пузырьки хмеля
    cv.P(16, 16, BOOZE_HI)
    cv.P(18, 19, BOOZE_HI)
    cv.P(15, 21, BOOZE_HI)
    cv.P(17, 23, BOOZE_HI)
    return cv


ICONS = {
    "dash": icon_dash,
    "blink": icon_blink,
    "kick": icon_kick,
    "drink": icon_drink,
}


def main() -> None:
    os.makedirs(OUT_ICONS, exist_ok=True)
    print("Шаг 29: иконки Ctrl-приёмов ->", OUT_ICONS)
    for kind, fn in ICONS.items():
        cv = fn()
        cv.outline(shade(BG, -0.5), inside=True)   # мягкий контур глифа
        path = os.path.join(OUT_ICONS, "ability_%s.png" % kind)
        cv.img.save(path)
        print("  -> ability_%s.png" % kind)
    print("OK: %d иконок" % len(ICONS))


if __name__ == "__main__":
    main()
