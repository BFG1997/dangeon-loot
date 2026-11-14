# -*- coding: utf-8 -*-
"""Шаг 9: явные запертые двери данжей для мира «Dungeon Loot».
Спрайт 32x16 — ровно две верхних тайла стены (D D): каменная рама,
двойные створки с железными полосами, золотые заклёпки и фиолетовый
зловещий зев между створками (подземелья ещё спят).
Запуск: python3 tools/gen_doors.py"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from px import *  # noqa: F401,F403

STONE = C(96, 94, 116)
STONE_HI = C(118, 116, 138)
STONE_SH = C(76, 74, 94)
WOOD = C(92, 62, 38)
WOOD_SH = C(72, 48, 30)
WOOD_HI = C(110, 78, 48)
IRON = C(116, 122, 136)
IRON_HI = C(146, 152, 166)
GOLD = C(224, 188, 80)
GLOW = C(150, 80, 220)
GLOW_HI = C(210, 160, 255)
VOID = C(18, 14, 30)


def gen_door() -> None:
    """Двойная запертая дверь данжа 32x16 (два тайла стены)."""
    c = Cv(32, 16)
    # каменная рама по всему периметру
    c.R(0, 0, 31, 15, STONE)
    c.HLINE(0, 0, 31, STONE_HI)
    c.HLINE(15, 0, 31, STONE_SH)
    # кладка рамы
    for x in (7, 16, 24):
        c.VLINE(x, 0, 1, STONE_SH)
    c.P(3, 1, STONE_SH); c.P(28, 1, STONE_SH)
    # зловещий зев подземелья: тьма за створками
    c.R(2, 2, 29, 14, VOID)
    # створки: левая x=3..15, правая x=16..28
    c.R(3, 2, 15, 14, WOOD)
    c.R(16, 2, 28, 14, WOOD)
    for x in range(3, 16, 4):                    # доски
        c.VLINE(x, 2, 14, WOOD_SH)
    for x in range(16, 29, 4):
        c.VLINE(x, 2, 14, WOOD_SH)
    c.HLINE(2, 3, 15, WOOD_HI)
    c.HLINE(2, 16, 28, WOOD_HI)
    # щель между створками: фиолетовый свет изнутри
    c.VLINE(15, 2, 14, GLOW)
    c.VLINE(16, 2, 14, GLOW)
    for y in (4, 8, 12):
        c.P(15, y, GLOW_HI)
        c.P(16, y, GLOW_HI)
    # железные полосы поперёк створок
    for y in (5, 10):
        c.R(3, y, 15, y + 1, IRON)
        c.R(16, y, 28, y + 1, IRON)
        c.HLINE(y, 3, 28, IRON_HI)
        # полосы не гасят свет щели
        c.P(15, y, GLOW); c.P(15, y + 1, GLOW)
        c.P(16, y, GLOW); c.P(16, y + 1, GLOW)
    # золотые заклёпки на полосах и рога рамы
    for x in (4, 9, 14, 17, 22, 27):
        c.P(x, 5, GOLD)
        c.P(x, 11, GOLD)
    c.P(1, 1, GOLD); c.P(30, 1, GOLD)
    c.P(1, 14, GOLD); c.P(30, 14, GOLD)
    # рунные точки над створками: данжи ещё «спят»
    for x in (6, 11, 20, 25):
        c.P(x, 1, GLOW)
    # замковая накладка по центру
    c.R(14, 6, 17, 9, IRON)
    c.HLINE(6, 14, 17, IRON_HI)
    c.P(15, 7, GOLD); c.P(16, 7, GOLD)
    c.P(15, 8, GOLD); c.P(16, 8, GOLD)
    c.outline()
    save(c.img, "sprites/props/door_dungeon.png")


if __name__ == "__main__":
    print("Генерация двери данжа (шаг 9):")
    gen_door()
    print("Готово.")
