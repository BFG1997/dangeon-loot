# -*- coding: utf-8 -*-
"""Генератор персонажей «Dungeon Loot» v2 — листы 24x32.
Ряды: idle_down(6), idle_side(6), idle_up(6), walk_down(4), walk_side(4), walk_up(4).
Персонажи: warrior, barbarian, bum, gura, viras, zlus, lira."""
import sys
sys.path.insert(0, "/home/z/my-project/scripts")
from px import *

W, H = 24, 32

# ---------------------------------------------------------------- позы
def pose(walking, f, dir):
    """Возвращает dict позы кадра."""
    p = {"bob": 0, "arm": 0, "lift": None, "stride": 0, "blink": False}
    if walking:
        if dir == "side":
            p["stride"] = [3, 0, -3, 0][f]
            p["bob"] = 1 if f % 2 == 1 else 0
            p["arm"] = [1, 0, -1, 0][f]
        else:
            p["lift"] = "L" if f == 0 else ("R" if f == 2 else None)
            p["bob"] = 1 if f % 2 == 1 else 0
            p["arm"] = [1, 0, -1, 0][f]
    else:
        p["bob"] = [0, 1, 1, 0, 1, 1][f % 6]
        p["blink"] = (f % 6 == 5)
    return p


def rr(c, x0, y0, x1, y1, col, r=1):
    """Прямоугольник со скруглёнными углами (r=1 — срезаны угловые пиксели)."""
    c.R(x0, y0, x1, y1, col)
    if r >= 1:
        for (x, y) in ((x0, y0), (x1, y0), (x0, y1), (x1, y1)):
            c.P(x, y, (0, 0, 0, 0))
    if r >= 2:
        for (x, y) in ((x0 + 1, y0), (x1 - 1, y0), (x0, y0 + 1), (x1, y0 + 1),
                       (x0 + 1, y1), (x1 - 1, y1), (x0, y1 - 1), (x1, y1 - 1)):
            c.P(x, y, (0, 0, 0, 0))


def erase_row(c, y, x0, x1):
    c.R(x0, y, x1, y, (0, 0, 0, 0))


# ---------------------------------------------------------------- голова
def draw_head(c, g, dir, p):
    """Череп/лицо y 3..12. bob сдвигает верх тела; здесь рисуем с учётом bob."""
    b = p["bob"]
    skin, skin_sh = g["skin"], g["skin_sh"]
    hy = b  # сдвиг головы
    # череп: y 3+hy .. 12+hy, скруглённый
    rr(c, 7, 3 + hy, 16, 12 + hy, skin, r=1)
    c.R(8, 2 + hy, 15, 3 + hy, skin)                    # макушка
    erase_row(c, 2 + hy, 8, 8); erase_row(c, 2 + hy, 15, 15)
    c.VLINE(16, 5 + hy, 11 + hy, skin_sh)               # тень справа
    c.HLINE(12 + hy, 9, 15, skin_sh)                    # низ
    c.P(8, 4 + hy, g["skin_hi"]); c.P(9, 3 + hy, g["skin_hi"])
    if dir == "down":
        if p["blink"]:
            c.HLINE(9 + hy, 9, 10, skin_sh); c.HLINE(9 + hy, 13, 14, skin_sh)
        else:
            c.R(9, 8 + hy, 10, 9 + hy, g["eye"])        # глаза 2x2
            c.R(13, 8 + hy, 14, 9 + hy, g["eye"])
            c.P(9, 8 + hy, (232, 238, 244, 255)); c.P(13, 8 + hy, (232, 238, 244, 255))
        c.P(11, 10 + hy, skin_sh); c.P(12, 10 + hy, skin_sh)     # нос
        if g.get("mouth"):
            c.HLINE(11 + hy, 11, 12, g["mouth"])
        else:
            c.HLINE(11 + hy, 11, 12, shade(skin_sh, -0.2))
        if g.get("rosy"):
            c.P(8, 10 + hy, (226, 132, 122, 255)); c.P(15, 10 + hy, (226, 132, 122, 255))
    elif dir == "side":
        c.P(17, 8 + hy, skin); c.P(17, 9 + hy, skin)    # нос
        c.P(17, 10 + hy, skin_sh)
        if p["blink"]:
            c.HLINE(9 + hy, 13, 14, skin_sh)
        else:
            c.R(13, 8 + hy, 14, 9 + hy, g["eye"])
            c.P(13, 8 + hy, (232, 238, 244, 255))
        c.HLINE(11 + hy, 12, 14, shade(skin_sh, -0.2))
        if g.get("rosy"):
            c.P(12, 10 + hy, (226, 132, 122, 255))
    # уши
    if dir == "side":
        c.R(8, 8 + hy, 9, 10 + hy, skin)
        c.P(8, 9 + hy, skin_sh)
    elif dir == "down":
        c.P(6, 9 + hy, skin); c.P(17, 9 + hy, skin)
    return hy


def draw_face_overlay(c, g, dir, p, hy):
    """Борода/усы/шрамы поверх лица (после волос)."""
    if g.get("beard") == "stubble" and dir != "up":
        d = shade(g["hair"], -0.1)
        for x in (9, 11, 13, 15):
            c.P(x, 11 + hy, d)
        if dir == "side":
            c.P(15, 11 + hy, d)
    if g.get("beard") == "mustache" and dir == "down":
        m = g["beard_c"]
        c.P(9, 10 + hy, m); c.P(10, 10 + hy, m)          # усы уголками
        c.P(13, 10 + hy, m); c.P(14, 10 + hy, m)
        c.P(9, 9 + hy, m); c.P(14, 9 + hy, m)
        c.P(11, 11 + hy, shade(m, -0.2)); c.P(12, 11 + hy, shade(m, -0.2))
    if g.get("beard") == "full" and dir != "up":
        bc = g["beard_c"]
        c.R(8, 11 + hy, 15, 12 + hy, bc)         # борода ниже рта
        c.R(9, 13 + hy, 14, 14 + hy, bc)
        c.HLINE(15 + hy, 10, 13, shade(bc, -0.2))
        if dir == "down":
            c.R(6, 11 + hy, 7, 13 + hy, bc); c.R(16, 11 + hy, 17, 13 + hy, bc)
            c.HLINE(10 + hy, 9, 10, bc)          # усы в стороны
            c.HLINE(10 + hy, 13, 14, bc)
            c.P(11, 11 + hy, shade(bc, 0.2)); c.P(12, 11 + hy, shade(bc, 0.2))
        if dir == "side":
            c.R(15, 11 + hy, 17, 13 + hy, bc)
            c.HLINE(10 + hy, 13, 15, bc)


# ---------------------------------------------------------------- волосы/головные уборы
def hair_short(c, g, dir, hy):
    hr, hr_d, hr_hi = g["hair"], g["hair_d"], g["hair_hi"]
    rr(c, 6, 2 + hy, 17, 6 + hy, hr, r=1)
    c.R(7, 1 + hy, 16, 2 + hy, hr)
    erase_row(c, 1 + hy, 7, 7); erase_row(c, 1 + hy, 16, 16)
    c.HLINE(2 + hy, 9, 14, hr_hi)
    c.HLINE(5 + hy, 6, 8, hr_d); c.HLINE(5 + hy, 15, 17, hr_d)
    if dir == "down":
        c.P(8, 6 + hy, hr); c.P(15, 6 + hy, hr)         # чёлка зубцами
        c.P(7, 7 + hy, hr_d); c.P(16, 7 + hy, hr_d)
    elif dir == "side":
        c.R(6, 3 + hy, 8, 8 + hy, hr)
        c.VLINE(6, 6 + hy, 9 + hy, hr_d)
        c.P(9, 3 + hy, hr_hi)
    else:  # up
        c.R(7, 4 + hy, 16, 11 + hy, hr)                 # затылок
        c.R(9, 5 + hy, 14, 9 + hy, hr_hi)
        c.HLINE(11 + hy, 8, 15, hr_d)
        c.R(7, 12 + hy, 16, 12 + hy, hr_d)


def hair_wild(c, g, dir, hy):
    hr, hr_d, hr_hi = g["hair"], g["hair_d"], g["hair_hi"]
    rr(c, 6, 2 + hy, 17, 5 + hy, hr, r=1)
    c.R(8, 1 + hy, 15, 2 + hy, hr)
    erase_row(c, 1 + hy, 8, 8); erase_row(c, 1 + hy, 15, 15)
    for x in (6, 9, 12, 15, 17):                         # вихры
        c.P(x, 1 + hy, hr); c.P(x, hy, hr_d)
    c.P(7, 2 + hy, hr_hi); c.P(13, 1 + hy, hr_hi)
    if dir == "up":
        c.R(7, 4 + hy, 16, 12 + hy, hr)
        c.R(9, 6 + hy, 14, 10 + hy, hr_hi)
        c.R(7, 11 + hy, 16, 12 + hy, hr_d)
    elif dir == "side":
        c.R(6, 3 + hy, 9, 10 + hy, hr)
        c.VLINE(6, 7 + hy, 10 + hy, hr_d)
        c.P(10, 4 + hy, hr_hi)
    else:
        c.P(8, 5 + hy, hr_d); c.P(15, 5 + hy, hr_d)      # рваная чёлка
        c.P(11, 5 + hy, hr); c.P(7, 6 + hy, hr_d); c.P(16, 6 + hy, hr_d)


def hair_long(c, g, dir, hy, flower=True):
    hr, hr_d, hr_hi = g["hair"], g["hair_d"], g["hair_hi"]
    rr(c, 6, 2 + hy, 17, 6 + hy, hr, r=1)
    c.R(7, 1 + hy, 16, 2 + hy, hr)
    erase_row(c, 1 + hy, 7, 7); erase_row(c, 1 + hy, 16, 16)
    # пробор
    c.VLINE(11, 2 + hy, 5 + hy, hr_d); c.VLINE(12, 2 + hy, 5 + hy, shade(hr, -0.15))
    c.HLINE(2 + hy, 8, 10, hr_hi); c.HLINE(2 + hy, 13, 15, hr_hi)
    # пряди у лица
    if dir == "down":
        c.R(5, 4 + hy, 6, 15 + hy, hr)                   # длинные пряди
        c.R(17, 4 + hy, 18, 15 + hy, hr)
        c.VLINE(5, 6 + hy, 14 + hy, hr_d); c.VLINE(18, 6 + hy, 14 + hy, hr_d)
        c.HLINE(15 + hy, 5, 6, hr_d); c.HLINE(15 + hy, 17, 18, hr_d)
        c.P(6, 4 + hy, hr_hi); c.P(17, 4 + hy, hr_hi)
        # чёлка-зубцы
        c.P(8, 5 + hy, hr); c.P(15, 5 + hy, hr); c.P(7, 6 + hy, hr); c.P(16, 6 + hy, hr)
    elif dir == "side":
        c.R(5, 3 + hy, 8, 15 + hy, hr)
        c.VLINE(5, 6 + hy, 14 + hy, hr_d)
        c.P(8, 4 + hy, hr_hi)
        c.P(9, 5 + hy, hr)
    else:
        c.R(6, 3 + hy, 17, 17 + hy, hr)                  # вся спина в волосах
        c.R(8, 4 + hy, 15, 14 + hy, hr_hi)
        c.R(6, 14 + hy, 17, 17 + hy, hr_d)
        c.HLINE(12 + hy, 7, 16, hr_d)
        c.HLINE(18 + hy, 8, 15, hr_d)
    if flower and dir != "up":
        fx = 5 if dir == "down" else 6
        c.R(fx, 2 + hy, fx + 2, 4 + hy, (250, 224, 234, 255))
        c.P(fx + 1, 3 + hy, (255, 250, 214, 255))
        c.P(fx + 1, 2 + hy, (233, 170, 190, 255)); c.P(fx, 3 + hy, (233, 170, 190, 255))


def helmet_warrior(c, g, dir, hy):
    st, st_d, st_hi = g["steel"], shade(g["steel"], -0.25), shade(g["steel"], 0.25)
    rr(c, 6, 2 + hy, 17, 6 + hy, st, r=1)
    c.R(7, 1 + hy, 16, 2 + hy, st)
    erase_row(c, 1 + hy, 7, 7); erase_row(c, 1 + hy, 16, 16)
    c.HLINE(2 + hy, 8, 15, st_hi)
    c.HLINE(6 + hy, 6, 17, st_d)                          # нижний край купола
    # гребень
    c.R(10, 0 + hy, 13, 1 + hy, (172, 44, 54, 255))
    c.P(9, 1 + hy, (172, 44, 54, 255)); c.P(14, 1 + hy, (172, 44, 54, 255))
    c.P(11, 0 + hy, (224, 96, 100, 255)); c.P(12, 0 + hy, (224, 96, 100, 255))
    if dir == "down":
        c.VLINE(11, 7 + hy, 10 + hy, st_d)                # нозальная пластина
        c.VLINE(12, 7 + hy, 10 + hy, st)
        c.R(6, 7 + hy, 8, 11 + hy, shade(st, -0.12))      # щёчные пластины
        c.R(15, 7 + hy, 17, 11 + hy, shade(st, -0.12))
        c.P(7, 7 + hy, st); c.P(16, 7 + hy, st)
    elif dir == "side":
        c.R(16, 7 + hy, 17, 11 + hy, shade(st, -0.12))    # передняя пластина
        c.P(16, 10 + hy, st_d)
    else:
        c.R(8, 7 + hy, 15, 11 + hy, shade(st, -0.18))
        c.HLINE(11 + hy, 9, 14, st_d)


def hat_chef(c, g, dir, hy):
    wh, wh_d = (242, 242, 246, 255), (206, 208, 218, 255)
    rr(c, 6, 0 + hy, 17, 3 + hy, wh, r=1)
    c.R(7, 0 + hy, 16, 0 + hy, wh)
    c.P(8, 0 + hy, wh); c.P(11, 0 + hy, wh); c.P(15, 0 + hy, wh)
    c.VLINE(17, 1 + hy, 3 + hy, wh_d)
    c.HLINE(2 + hy, 7, 12, (255, 255, 255, 255))
    c.R(7, 4 + hy, 16, 5 + hy, wh_d)                      # лента
    c.HLINE(4 + hy, 7, 16, (255, 255, 255, 255))
    if dir == "down":
        c.P(7, 5 + hy, shade(wh_d, -0.1)); c.P(16, 5 + hy, shade(wh_d, -0.1))


def hat_wizard(c, g, dir, hy):
    rc, rc_d = g["top"], shade(g["top"], -0.3)
    rc_hi = shade(g["top"], 0.25)
    c.R(5, 6 + hy, 19, 7 + hy, rc_d)                      # поля
    c.HLINE(7 + hy, 5, 19, shade(rc_d, -0.2))
    c.R(8, 3 + hy, 15, 5 + hy, rc)                        # конус
    c.R(10, 1 + hy, 13, 2 + hy, rc)
    c.R(11, 0 + hy, 12, 0 + hy, rc)
    c.P(11, 1 + hy, rc_hi); c.HLINE(4 + hy, 9, 12, rc_hi)
    c.HLINE(5 + hy, 8, 15, g.get("trim", (222, 178, 74, 255)))   # лента
    if dir == "down":
        c.P(10, 3 + hy, (238, 222, 128, 255))             # звёздочки
        c.P(14, 5 + hy, (238, 222, 128, 255))
        c.P(6, 6 + hy, rc_d); c.P(18, 6 + hy, rc_d)


# ---------------------------------------------------------------- тело
def torso(c, g, dir, p):
    b = p["bob"]
    ty = 13 + b
    top, top_d, top_hi = g["top"], shade(g["top"], -0.28), shade(g["top"], 0.2)
    if g.get("belly"):
        rr(c, 5, ty, 18, ty + 7, top, r=1)
        c.R(6, ty + 7, 17, ty + 8, top_d)
        c.R(5, ty + 5, 18, ty + 6, top)                  # живот напуском
        c.HLINE(ty + 8, 7, 16, shade(top, -0.38))
    else:
        rr(c, 6, ty, 17, ty + 7, top, r=1)
        c.R(7, ty + 7, 16, ty + 8, top_d)                # талия уже
        erase_row(c, ty + 8, 7, 7); erase_row(c, ty + 8, 16, 16)
    c.VLINE(17, ty + 1, ty + 7, top_d)
    c.HLINE(ty, 8, 15, top_hi)
    return ty


def arms(c, g, dir, p, ty, sleeve=None):
    """Руки по бокам; arm=+1/-1 мах."""
    sl = sleeve or g["sleeve"] or g["top"]
    a = p["arm"]
    if dir == "side":
        # передняя рука по центру силуэта
        y0 = ty + 1 + (1 if a > 0 else 0)
        y1 = ty + 7 + (1 if a < 0 else 0)
        c.R(11, y0, 13, y1 - 1, sl)
        c.R(11, y1, 13, y1 + 1, g["skin"])               # кисть
        c.VLINE(13, y0, y1 + 1, shade(sl, -0.28))
        return
    y0L, y1L = ty + 1 + (1 if a < 0 else 0), ty + 7
    y0R, y1R = ty + 1 + (1 if a > 0 else 0), ty + 7
    c.R(4, y0L, 6, y1L, sl); c.R(17, y0R, 19, y1R, sl)
    c.R(4, y1L + 1, 6, y1L + 1, g["skin"]); c.R(17, y1R + 1, 19, y1R + 1, g["skin"])
    c.VLINE(6, y0L, y1L, shade(sl, -0.28)); c.VLINE(19, y0R, y1R, shade(sl, -0.28))
    c.VLINE(4, y0L, y1L, shade(sl, 0.15)); c.VLINE(17, y0R, y1R, shade(sl, 0.15))


def belt(c, g, ty, x0=6, x1=17):
    c.HLINE(ty + 8, x0, x1, g.get("belt", (94, 66, 44, 255)))
    c.P((x0 + x1) // 2, ty + 8, (226, 182, 78, 255))
    c.P((x0 + x1) // 2 + 1, ty + 8, (226, 182, 78, 255))


def legs(c, g, dir, p):
    """Ноги y22..31. lift: поднятая нога; stride: шаг вбок."""
    pants, boots = g["pants"], g["boots"]
    pants_d, boots_d = shade(pants, -0.25), shade(boots, -0.28)
    if dir == "side":
        s = p["stride"]
        if s != 0:
            fx0 = 12 + (1 if s > 0 else 0)               # передняя нога
            bx0 = 8 - (1 if s > 0 else 0)
            c.R(fx0, 22, fx0 + 2, 29, pants)
            c.R(bx0, 22, bx0 + 2, 29, pants_d)
            c.R(fx0 - 1 if s > 0 else fx0, 30, fx0 + 3 if s > 0 else fx0 + 2, 31, boots)
            c.R(bx0 - 1 if s < 0 else bx0, 30, bx0 + 2, 31, boots_d)
        else:
            c.R(10, 22, 12, 29, pants); c.R(13, 22, 15, 29, pants_d)
            c.R(9, 30, 12, 31, boots); c.R(13, 30, 16, 31, boots_d)
        return
    lift = p["lift"]
    l_end, r_end = 29, 29
    if lift == "L":
        l_end = 26
    elif lift == "R":
        r_end = 26
    c.R(7, 22, 10, l_end, pants); c.R(13, 22, 16, r_end, pants)
    c.VLINE(10, 22, l_end, pants_d); c.VLINE(16, 22, r_end, pants_d)
    if l_end == 29:
        c.R(6, 30, 11, 31, boots)
        c.HLINE(30, 6, 11, shade(boots, 0.2))
    else:
        c.R(6, l_end + 1, 11, l_end + 3, boots)          # поднятая ступня
        c.HLINE(l_end + 1, 6, 11, shade(boots, 0.2))
    if r_end == 29:
        c.R(12, 30, 17, 31, boots)
        c.HLINE(30, 12, 17, shade(boots, 0.2))
    else:
        c.R(12, r_end + 1, 17, r_end + 3, boots)
        c.HLINE(r_end + 1, 12, 17, shade(boots, 0.2))


def robe(c, g, dir, p):
    rc, rc_d, rc_hi = g["top"], shade(g["top"], -0.3), shade(g["top"], 0.2)
    b = p["bob"]
    ty = 13 + b
    rr(c, 6, ty, 17, ty + 6, rc, r=1)
    c.R(5, ty + 5, 18, ty + 9, rc)
    c.R(4, ty + 9, 19, ty + 13, rc)
    erase_row(c, ty + 13, 4, 4); erase_row(c, ty + 13, 19, 19)
    c.VLINE(17, ty + 1, ty + 12, rc_d)
    c.R(5, ty + 12, 18, ty + 13, rc_d)
    c.HLINE(ty, 8, 15, rc_hi)
    c.VLINE(9, ty + 6, ty + 12, rc_d)                     # складки
    c.VLINE(13, ty + 7, ty + 12, rc_d)
    # широкие рукава
    a = p["arm"]
    c.R(3, ty + 1 + (1 if a < 0 else 0), 6, ty + 7, rc)
    c.R(17, ty + 1 + (1 if a > 0 else 0), 20, ty + 7, rc)
    c.R(3, ty + 7, 6, ty + 9, rc_d); c.R(17, ty + 7, 20, ty + 9, rc_d)
    c.P(5, ty + 9, g["skin"]); c.P(18, ty + 9, g["skin"])
    # кайма
    c.HLINE(ty + 12, 5, 18, g.get("trim", (222, 178, 74, 255)))
    c.HLINE(ty + 13, 6, 17, shade(g.get("trim", (222, 178, 74, 255)), -0.3))
    # ступни
    c.R(7, 30, 10, 31, g["boots"]); c.R(13, 30, 16, 31, g["boots"])


def dress(c, g, dir, p):
    dc = g["top"]
    dc_d, dc_hi = shade(dc, -0.26), shade(dc, 0.24)
    trim = g.get("trim", (238, 196, 92, 255))
    b = p["bob"]
    ty = 13 + b
    # лиф
    rr(c, 7, ty, 16, ty + 5, dc, r=1)
    c.VLINE(16, ty + 1, ty + 5, dc_d)
    c.HLINE(ty, 9, 14, dc_hi)
    # руки (открытые)
    a = p["arm"]
    c.R(5, ty + 1 + (1 if a < 0 else 0), 6, ty + 6, g["skin"])
    c.R(17, ty + 1 + (1 if a > 0 else 0), 18, ty + 6, g["skin"])
    c.VLINE(6, ty + 1, ty + 6, g["skin_sh"]); c.VLINE(17, ty + 1, ty + 6, g["skin_sh"])
    c.P(5, ty + 7 + (1 if a < 0 else 0), g["skin"]); c.P(18, ty + 7 + (1 if a > 0 else 0), g["skin"])
    if dir == "down":
        c.P(5, ty + 6, g["skin"]); c.P(18, ty + 6, g["skin"])    # плечи
    # пышные рукавчики
    c.R(4, ty, 6, ty + 2, dc); c.R(17, ty, 19, ty + 2, dc)
    c.P(5, ty + 2, dc_d); c.P(18, ty + 2, dc_d)
    # пояс
    c.HLINE(ty + 6, 7, 16, trim)
    c.P(11, ty + 6, (255, 236, 150, 255)); c.P(12, ty + 6, (255, 236, 150, 255))
    # юбка-колокол
    sway = p["stride"] if dir == "side" else 0
    x0, x1 = 6 - (1 if sway > 0 else 0), 17 + (1 if sway > 0 else 0)
    if sway < 0:
        x0, x1 = 7, 16
    c.R(7, ty + 7, 16, ty + 9, dc)
    c.R(x0, ty + 10, x1, ty + 13, dc)
    hem_x0, hem_x1 = (x0 - 1 if sway >= 0 else x0), (x1 + 1 if sway >= 0 else x1)
    c.R(hem_x0, ty + 14, hem_x1, ty + 16, dc)
    c.VLINE(x1, ty + 7, ty + 16, dc_d)
    c.VLINE(10, ty + 8, ty + 15, dc_d); c.VLINE(14, ty + 8, ty + 15, dc_d)
    c.HLINE(ty + 7, 8, 15, dc_hi)
    c.HLINE(ty + 15, hem_x0 + 1, hem_x1 - 1, shade(dc, 0.3))  # свет на кромке
    c.HLINE(ty + 16, hem_x0, hem_x1, dc_d)
    # подвеска
    if dir == "down":
        c.P(11, ty + 1, trim); c.P(12, ty + 2, (255, 244, 190, 255))
        c.P(11, ty + 2, trim)
    # туфельки
    c.R(7, 30, 10, 31, g["boots"]); c.R(13, 30, 16, 31, g["boots"])


# ---------------------------------------------------------------- оружие/детали
def weapon(c, g, dir, p, ty):
    w = g.get("weapon")
    if not w:
        return
    wd = (96, 68, 44, 255)
    met, met_d = (196, 206, 220, 255), (128, 138, 154, 255)
    gold = (226, 182, 78, 255)
    if w == "sword":
        if dir == "up":
            c.R(17, ty - 7, 18, ty + 2, met_d)            # клинок над плечом
            c.VLINE(17, ty - 7, ty + 2, met)
            c.HLINE(ty - 8, 16, 19, gold)
            c.P(17, ty - 9, met_d); c.P(18, ty - 9, met_d)
        else:
            c.R(3, ty + 6, 4, ty + 14, (58, 66, 92, 255))  # ножны у левого бедра
            c.P(4, ty + 6, (70, 80, 108, 255))
            c.HLINE(ty + 5, 3, 5, gold)
            c.P(5, ty + 4, (58, 66, 92, 255))
    elif w == "axe":
        if dir == "up":
            c.VLINE(16, ty - 6, ty + 8, wd)
            c.R(13, ty - 9, 18, ty - 7, met)
            c.VLINE(18, ty - 9, ty - 7, met_d)
            c.P(14, ty - 10, met); c.P(17, ty - 10, met)
        else:
            c.VLINE(19, ty - 3, ty + 2, wd)               # топорище над плечом
            c.R(18, ty - 6, 20, ty - 4, met)
            c.P(20, ty - 5, met_d); c.P(18, ty - 6, shade(met, 0.25))
    elif w == "staff":
        orb = (128, 224, 242, 255)
        c.VLINE(20, ty - 5, ty + 13, wd)                  # посох справа
        c.R(19, ty - 8, 21, ty - 6, orb)
        c.P(20, ty - 8, (222, 248, 255, 255))
        c.P(19, ty - 6, shade(orb, -0.3))
        c.P(20, ty - 5, shade(wd, -0.3))
    elif w == "hammer":
        if dir == "up":
            c.VLINE(7, ty - 4, ty + 8, wd)
            c.R(5, ty - 7, 9, ty - 5, met)
            c.HLINE(ty - 7, 6, 8, shade(met, 0.25))
        else:
            c.VLINE(19, ty - 1, ty + 8, wd)               # в правой руке
            c.R(17, ty - 4, 21, ty - 2, met)
            c.HLINE(ty - 4, 18, 20, shade(met, 0.3))
            c.VLINE(21, ty - 4, ty - 2, met_d)


def char_extras(c, g, dir, p, ty):
    if g.get("fur") and dir != "up":
        f = g["fur_c"]
        c.R(3, ty - 1, 7, ty + 1, f); c.R(16, ty - 1, 20, ty + 1, f)
        c.P(4, ty + 2, f); c.P(6, ty + 2, f); c.P(17, ty + 2, f); c.P(19, ty + 2, f)
        c.P(5, ty - 2, shade(f, 0.22)); c.P(18, ty - 2, shade(f, 0.22))
        c.P(3, ty, f); c.P(8, ty, f); c.P(15, ty, f); c.P(20, ty, f)
    if g.get("apron") and dir != "up":
        ap = g["apron"]
        c.R(8, ty + 1, 15, ty + 7, ap)
        c.VLINE(15, ty + 1, ty + 7, shade(ap, -0.25))
        c.HLINE(ty + 1, 9, 14, shade(ap, 0.18))
        c.VLINE(8, ty + 1, ty + 2, shade(ap, -0.15))
        if g.get("belly"):
            c.R(8, ty + 6, 16, ty + 8, ap)
            c.VLINE(16, ty + 6, ty + 8, shade(ap, -0.25))
    if g.get("neckerchief") and dir == "down":
        c.HLINE(ty, 9, 14, g["neckerchief"])
        c.P(11, ty + 1, g["neckerchief"]); c.P(12, ty + 1, g["neckerchief"])
    if g.get("patches"):
        for (px, py, pc) in g["patches"]:
            c.R(ty + py, px, ty + py + 1, px + 1, pc)
    if g.get("bottle") and dir == "down":
        c.R(3, ty + 4, 4, ty + 8, (118, 82, 44, 255))
        c.P(3, ty + 3, (154, 172, 92, 255)); c.P(4, ty + 3, (154, 172, 92, 255))
    if g.get("bracers") and dir != "side":
        br = g["bracers"]
        c.R(4, ty + 5, 6, ty + 6, br); c.R(17, ty + 5, 19, ty + 6, br)
    if g.get("soot") and dir == "down":
        c.P(15, 9 + p["bob"], (92, 88, 92, 255)); c.P(15, 10 + p["bob"], (92, 88, 92, 255))
    if g.get("armor_ridge") and dir != "up":
        st = g["armor_ridge"]
        c.VLINE(11, ty + 1, ty + 6, st)
        c.VLINE(12, ty + 1, ty + 6, shade(st, -0.2))
        c.P(8, ty + 2, st); c.P(15, ty + 2, st)          # заклёпки
        c.P(8, ty + 5, st); c.P(15, ty + 5, st)


# ---------------------------------------------------------------- сборка
def draw_frame(g, dir, f, walking):
    c = Cv(W, H)
    p = pose(walking, f, dir)
    hy = p["bob"]
    if g.get("robe"):
        robe(c, g, dir, p)
    elif g.get("dress"):
        dress(c, g, dir, p)
    else:
        legs(c, g, dir, p)
        ty = torso(c, g, dir, p)
        arms(c, g, dir, p, ty)
        belt(c, g, ty)
        char_extras(c, g, dir, p, ty)
    draw_head(c, g, dir, p)
    if g.get("helmet"):
        helmet_warrior(c, g, dir, hy)
        draw_face_overlay(c, g, dir, p, hy)
    else:
        hs = g.get("hair_style", "short")
        if hs == "short":
            hair_short(c, g, dir, hy)
        elif hs == "wild":
            hair_wild(c, g, dir, hy)
        elif hs == "long":
            hair_long(c, g, dir, hy, flower=g.get("flower", False))
        h = g.get("hat")
        if h == "chef":
            hat_chef(c, g, dir, hy)
        elif h == "wizard":
            hat_wizard(c, g, dir, hy)
        draw_face_overlay(c, g, dir, p, hy)
    if g.get("robe"):
        # борода поверх мантии + посох
        draw_face_overlay(c, g, dir, p, hy)
    if g.get("weapon"):
        weapon(c, g, dir, p, 13 + p["bob"])
    if g.get("bow_back") and dir == "up":
        c.R(10, 6, 13, 8, (198, 42, 62, 255))            # бант на затылке
        c.P(11, 7, (240, 198, 94, 255)); c.P(12, 7, (240, 198, 94, 255))
    c.outline()
    return c.img


# ---------------------------------------------------------------- конфиги
def G(**kw):
    d = {
        "skin": SKIN, "skin_sh": SKIN_SH, "skin_hi": SKIN_HI,
        "hair": (74, 52, 38, 255), "hair_d": shade((74, 52, 38, 255), -0.35),
        "hair_hi": shade((74, 52, 38, 255), 0.3),
        "top": (110, 110, 130, 255), "sleeve": None,
        "pants": (52, 56, 74, 255), "boots": (74, 56, 44, 255),
        "belt": (94, 66, 44, 255), "eye": (40, 36, 50, 255),
        "hair_style": "short", "beard": "none",
    }
    d.update(kw)
    return d


CHARS = {
    "warrior": G(
        hair=(84, 62, 44, 255), hair_style="short",
        top=(62, 86, 158, 255), pants=(58, 62, 84, 255), boots=(66, 52, 44, 255),
        belt=(70, 74, 92, 255), helmet=True,
        steel=(176, 186, 200, 255), armor_ridge=(150, 190, 230, 255),
        weapon="sword",
    ),
    "barbarian": G(
        hair=(72, 50, 36, 255), hair_style="wild",
        top=(152, 98, 62, 255), sleeve=(152, 98, 62, 255),
        pants=(108, 44, 52, 255), boots=(62, 46, 38, 255),
        belt=(84, 60, 38, 255), fur=True, fur_c=(134, 92, 58, 255),
        beard="stubble", weapon="axe", bracers=(96, 66, 40, 255),
    ),
    "bum": G(
        skin=(224, 176, 138, 255), skin_sh=(192, 138, 100, 255),
        hair=(84, 70, 56, 255), hair_style="wild",
        top=(120, 110, 94, 255), pants=(76, 70, 62, 255), boots=(54, 48, 42, 255),
        beard="stubble", patches=[(9, 2, (96, 108, 72, 255)), (13, 5, (88, 78, 66, 255))],
        bottle=True,
    ),
    "gura": G(
        skin=(242, 192, 152, 255), rosy=True, hair=(148, 96, 58, 255),
        top=(240, 240, 246, 255), sleeve=(240, 240, 246, 255),
        pants=(54, 62, 86, 255), boots=(58, 50, 46, 255),
        hat="chef", beard="mustache", beard_c=(118, 108, 98, 255),
        belly=True, neckerchief=(196, 60, 60, 255),
    ),
    "viras": G(
        skin=(216, 158, 112, 255), hair=(60, 44, 34, 255), hair_style="bald",
        top=(150, 98, 62, 255), sleeve=(150, 98, 62, 255),
        pants=(64, 56, 50, 255), boots=(50, 44, 40, 255),
        beard="full", beard_c=(66, 50, 40, 255), apron=(122, 84, 52, 255),
        weapon="hammer", soot=True,
    ),
    "zlus": G(
        skin=(228, 180, 142, 255), hair=(224, 224, 232, 255),
        hair_d=(188, 188, 200, 255), hair_hi=(255, 255, 255, 255),
        top=(108, 74, 164, 255), pants=(78, 52, 122, 255), boots=(52, 38, 66, 255),
        hat="wizard", beard="full", beard_c=(224, 224, 232, 255),
        robe=True, trim=(226, 182, 78, 255), weapon="staff",
    ),
    "lira": G(
        skin=(248, 202, 160, 255), rosy=True,
        hair=(228, 184, 98, 255), hair_d=(186, 140, 62, 255), hair_hi=(252, 226, 150, 255),
        hair_style="long", flower=True,
        top=(198, 42, 62, 255), boots=(208, 166, 86, 255),
        dress=True, trim=(240, 198, 94, 255), mouth=(190, 76, 80, 255),
        bow_back=True,
    ),
    # --- шаг 6: играбельный маг + два торговца в замке ---
    "mage": G(
        skin=(240, 196, 156, 255), rosy=True,
        hair=(56, 48, 76, 255), hair_d=(40, 34, 56, 255), hair_hi=(88, 78, 116, 255),
        hair_style="short",
        top=(44, 96, 128, 255), pants=(36, 74, 100, 255), boots=(40, 34, 52, 255),
        hat="wizard", robe=True, trim=(120, 200, 220, 255), weapon="staff",
    ),
    "glot": G(
        skin=(238, 188, 148, 255), rosy=True,
        hair=(96, 62, 40, 255), hair_style="short",
        top=(86, 122, 74, 255), sleeve=(86, 122, 74, 255),
        pants=(70, 52, 42, 255), boots=(54, 42, 34, 255),
        belt=(80, 58, 40, 255), belly=True,
        apron=(214, 204, 186, 255), beard="stubble",
    ),
    "zoran": G(
        skin=(222, 172, 132, 255),
        hair=(168, 170, 186, 255), hair_d=(130, 132, 150, 255),
        hair_hi=(210, 212, 226, 255), hair_style="long", flower=False,
        top=(58, 58, 96, 255), sleeve=(58, 58, 96, 255),
        pants=(48, 48, 70, 255), boots=(44, 40, 56, 255),
        beard="full", beard_c=(178, 180, 196, 255),
        trim=(150, 110, 220, 255), weapon="sword",
    ),
}

ROWS = [("idle_down", 6, False), ("idle_side", 6, False), ("idle_up", 6, False),
        ("walk_down", 4, True), ("walk_side", 4, True), ("walk_up", 4, True)]


def build_sheet(cid):
    sheet = Image.new("RGBA", (6 * W, 6 * H), (0, 0, 0, 0))
    for r, (row, n, walking) in enumerate(ROWS):
        dir = row.split("_")[1]
        for f in range(n):
            img = draw_frame(CHARS[cid], dir, f, walking)
            sheet.paste(img, (f * W, r * H))
    return sheet


if __name__ == "__main__":
    import os
    for cid in CHARS:
        save(build_sheet(cid), f"sprites/chars/{cid}.png")
    cells, labels = [], []
    for cid in CHARS:
        for row, n, walking in ROWS:
            cells.append(draw_frame(CHARS[cid], row.split("_")[1], 0, walking))
            labels.append(f"{cid}:{row}")
    save(contact(cells, W, H, cols=6, scale=7, bg=(52, 54, 76, 255), labels=labels), "/tmp/chars_v2.png")
    print("OK")
