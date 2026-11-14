# -*- coding: utf-8 -*-
"""Генератор Таинственного демона «Dungeon Loot» (шаг 8).
Демон втрое крупнее обычных NPC: кадры 72x96 (лист 432x576).
Ряды как у персонажей 24x32: idle_down(6), idle_side(6), idle_up(6),
walk_down(4), walk_side(4), walk_up(4).
Демон парит над землёй: вместо ног — хвост с огоньком, «ходьба» — полёт.
Портрет 64x64 для диалогов: assets/sprites/portraits/demon.png."""
import os
import sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from px import *

FW, FH = 72, 96

# ---------------------------------------------------------------- палитра
BODY = C(126, 38, 48)        # багровая кожа
BODY_SH = C(94, 26, 38)
BODY_HI = C(168, 62, 66)
BODY_DK = C(74, 20, 32)
WING = C(58, 38, 82)         # тёмно-фиолетовые крылья
WING_HI = C(84, 54, 116)
HORN = C(226, 210, 186)      # костяные рога
HORN_SH = C(172, 152, 136)
EYE_GLOW = C(255, 186, 64)   # горящие янтарные глаза
EYE_CORE = C(255, 238, 152)
FANG = C(236, 232, 218)
MOUTH = C(46, 14, 22)
FLAME = C(255, 128, 44)      # огонёк на хвосте
FLAME_HI = C(255, 198, 96)
AURA = C(96, 60, 140)        # лиловая аура

def pose(walking, f, dir):
    """Параметры кадра демона."""
    p = {"bob": 0, "arm": 0, "tail": 0, "glow": False, "blink": False}
    if walking:
        p["bob"] = [-3, 0, 1, 0][f]
        p["arm"] = [2, 0, -2, 0][f]
        p["tail"] = [3, 0, -3, 0][f]
        p["glow"] = True
    else:
        p["bob"] = [0, 1, 1, 0, 1, 1][f % 6]
        p["arm"] = 0
        p["tail"] = [0, 1, 2, 0, -1, -2][f % 6]
        p["glow"] = (f % 6) in (3, 4)
        p["blink"] = (f % 6 == 5)
    return p


def rr(c, x0, y0, x1, y1, col, r=1):
    """Прямоугольник со срезанными угловыми пикселями."""
    c.R(x0, y0, x1, y1, col)
    if r >= 1:
        for (x, y) in ((x0, y0), (x1, y0), (x0, y1), (x1, y1)):
            c.P(x, y, (0, 0, 0, 0))


# ---------------------------------------------------------------- крылья
def draw_wings(c, dir, p):
    """Крылья за спиной; со спины (up) раскрыты шире."""
    cx = 36
    top = 40 + p["bob"]
    if dir == "up":
        # раскрытые крылья: широкие перепонки по обе стороны
        c.ellipse(cx - 24, top + 14, 13, 16, WING)
        c.ellipse(cx + 24, top + 14, 13, 16, WING)
        c.ellipse(cx - 20, top + 12, 8, 10, WING_HI)
        c.ellipse(cx + 20, top + 12, 8, 10, WING_HI)
        # костяные опоры перепонок
        for dy in (0, 10, 20):
            c.HLINE(cx - 34 + dy // 2, top + dy + 2, cx - 16, WING_HI if dy == 0 else WING)
            c.HLINE(cx + 16, top + dy + 2, cx + 34 - dy // 2, WING_HI if dy == 0 else WING)
        for dx in (-1, 1):
            x = cx + dx * 30
            c.VLINE(x, top - 2, top + 14, HORN_SH)
            c.P(x, top - 3, HORN)
    else:
        # сложенные за спиной: видны по бокам торса
        c.ellipse(cx - 21, top + 14, 8, 15, WING)
        c.ellipse(cx + 21, top + 14, 8, 15, WING)
        c.ellipse(cx - 21, top + 12, 5, 9, WING_HI)
        c.ellipse(cx + 21, top + 12, 5, 9, WING_HI)
        # костяные отростки крыльев
        for dx in (-1, 1):
            x = cx + dx * 25
            c.VLINE(x, top - 2, top + 16, HORN_SH)
            c.P(x, top - 3, HORN)
            c.P(x + dx, top - 2, HORN_SH)


# ---------------------------------------------------------------- хвост
def draw_tail(c, dir, p):
    """Хвост вместо ног: изгиб вниз с огоньком на кончике."""
    cx = 36
    base_y = 72 + p["bob"]
    sway = p["tail"]
    if dir == "side":
        sway -= 5   # волочится позади
    pts = []
    for i in range(7):
        t = i / 6.0
        x = cx + int(8 * (1 - t) * (1 if dir != "up" else 0)) + int(sway * (t * t)) \
            + int(sway * 0.4 * t)
        y = base_y + int(t * 16)
        pts.append((x, y))
    for (x, y) in pts:
        c.R(x - 3, y, x + 3, y + 3, BODY_SH)
        c.R(x - 2, y, x + 2, y + 2, BODY)
        c.P(x, y, BODY_HI)
    # кончик-огонёк
    tip = pts[-1]
    c.ellipse(tip[0], tip[1] + 4, 3, 4, FLAME)
    c.ellipse(tip[0], tip[1] + 4, 1, 2, FLAME_HI)
    c.P(tip[0], tip[1] + 3, FLAME_HI)


# ---------------------------------------------------------------- торс
def draw_torso(c, dir, p):
    cx = 36
    top = 46 + p["bob"]
    rr(c, cx - 18, top, cx + 18, top + 28, BODY, r=2)
    # объём: тени по бокам, блик по центру груди
    c.VLINE(cx - 18, top + 4, top + 25, BODY_SH)
    c.VLINE(cx + 18, top + 4, top + 25, BODY_SH)
    c.VLINE(cx - 17, top + 4, top + 25, BODY_DK)
    c.VLINE(cx + 17, top + 4, top + 25, BODY_DK)
    c.R(cx - 9, top + 3, cx - 2, top + 12, BODY_HI)
    c.R(cx + 3, top + 3, cx + 10, top + 12, BODY_HI)
    c.HLINE(top + 13, cx - 9, cx + 10, BODY_SH)        # под грудными
    c.R(cx - 6, top + 18, cx + 6, top + 19, BODY_SH)   # пресс
    c.R(cx - 3, top + 22, cx + 3, top + 23, BODY_DK)
    # низ уходит в тень (хвост)
    c.R(cx - 11, top + 26, cx + 11, top + 28, BODY_SH)
    if dir == "side":
        # профиль: плечо ближе к зрителю
        c.VLINE(cx + 14, top, top + 20, BODY_HI)


# ---------------------------------------------------------------- руки
def draw_arms(c, dir, p):
    cx = 36
    top = 46 + p["bob"]
    arm = p["arm"]
    for dx in (-1, 1):
        ax = cx + dx * 19
        swing = arm * dx if dir != "side" else arm
        sh_y = top + 2
        elbow_y = sh_y + 12
        hand_y = elbow_y + 10 + (swing if dir != "side" else 0)
        c.R(ax - 3, sh_y, ax + 3, elbow_y, BODY)
        c.VLINE(ax + dx * 3, sh_y + 2, elbow_y, BODY_SH)
        c.VLINE(ax - dx * 2, sh_y + 1, elbow_y, BODY_HI)
        c.R(ax - 4, elbow_y, ax + 4, hand_y, BODY)
        c.VLINE(ax + dx * 4, elbow_y + 2, hand_y - 1, BODY_SH)
        # большие когти
        for k in (-2, 0, 2):
            c.R(ax + k, hand_y + 1, ax + k + 1, hand_y + 5, HORN)
            c.P(ax + k + (1 if k < 0 else 0), hand_y + 6, HORN_SH)
            c.P(ax + k + 1, hand_y, HORN_SH)


# ---------------------------------------------------------------- голова
def draw_head(c, dir, p):
    cx = 36
    top = 46 + p["bob"]
    hy = top - 36             # верх черепа (y≈10)
    blink = p["blink"]
    glow = p["glow"]
    if dir == "side":
        # профиль вправо
        hx = cx + 5
        rr(c, hx - 17, hy, hx + 17, hy + 34, BODY, r=2)
        c.VLINE(hx + 17, hy + 5, hy + 29, BODY_SH)
        c.VLINE(hx + 16, hy + 5, hy + 29, BODY_DK)
        # морда выступает
        c.R(hx + 10, hy + 16, hx + 18, hy + 24, BODY)
        c.R(hx + 12, hy + 18, hx + 18, hy + 24, BODY_SH)
        c.HLINE(hy + 8, hx - 14, hx + 12, BODY_HI)
        # рога: пара, уходят вверх-назад
        for (dx, dy, ln) in ((-12, -6, 8), (-5, -10, 9)):
            c.R(hx + dx, hy + dy, hx + dx + 4, hy + dy + ln, HORN)
            c.VLINE(hx + dx + 4, hy + dy + 1, hy + dy + ln, HORN_SH)
            c.P(hx + dx + 2, hy + dy - 1, HORN)
            c.P(hx + dx + 3, hy + dy - 2, HORN)
        # глаз
        if not blink:
            ex = hx + 4
            c.R(ex, hy + 18, ex + 7, hy + 22, EYE_GLOW)
            c.R(ex + 2, hy + 19, ex + 7, hy + 22, EYE_CORE)
            c.P(ex + 4, hy + 20, EYE_CORE)
        else:
            c.HLINE(hy + 20, hx + 4, hx + 11, BODY_DK)
        # бровь
        c.HLINE(hy + 16, hx + 3, hx + 12, BODY_DK)
        # ухмылка
        c.R(hx + 8, hy + 28, hx + 18, hy + 32, MOUTH)
        for fx in (hx + 9, hx + 13):
            c.VLINE(fx, hy + 28, hy + 31, FANG)
            c.P(fx, hy + 32, FANG)
        return
    # вид спереди или сзади
    rr(c, cx - 17, hy, cx + 17, hy + 34, BODY, r=2)
    c.VLINE(cx + 17, hy + 6, hy + 28, BODY_SH)
    c.VLINE(cx + 16, hy + 6, hy + 28, BODY_DK)
    c.R(cx - 12, hy + 2, cx + 12, hy + 5, BODY_HI)
    c.P(cx - 13, hy + 3, BODY_HI)
    if dir == "up":
        # затылок: без лица, рога вперёд не видны, кожа и тень
        c.R(cx - 10, hy + 12, cx + 10, hy + 28, BODY_SH)
        c.HLINE(hy + 30, cx - 14, cx + 14, BODY_DK)
        # рога торчат вверх
        for dx in (-1, 1):
            bx = cx + dx * 12
            c.R(bx - 1, hy - 8, bx + 2, hy - 2, HORN)
            c.P(bx + (2 if dx > 0 else -1), hy - 9, HORN)
        return
    # лицо: рога — большие, изогнутые наружу
    for dx in (-1, 1):
        bx = cx + dx * 14
        seg = [(bx, hy - 6), (bx + dx * 4, hy - 11), (bx + dx * 7, hy - 15)]
        for (sx, sy) in seg:
            c.R(min(sx, sx + dx * 3), sy, max(sx, sx + dx * 3) + dx * 2, sy + 4, HORN)
        c.P(bx + dx * 2, hy - 5, HORN_SH)
        c.P(bx + dx * 5, hy - 9, HORN_SH)
        tip_x = bx + dx * 9
        c.P(tip_x, hy - 16, HORN)
        c.P(tip_x - dx, hy - 16, HORN)
        c.P(tip_x, hy - 17, HORN)
    # уши острые
    for dx in (-1, 1):
        ex = cx + dx * 18
        c.R(ex, hy + 16, ex + dx * 3, hy + 22, BODY)
        c.P(ex + dx * 3, hy + 15, BODY_SH)
        c.P(ex + dx * 3, hy + 16, BODY_DK)
    # глаза: горящие щели
    if not blink:
        for dx in (-1, 1):
            ex = cx + dx * 9 - (5 if dx < 0 else 0)
            c.R(ex, hy + 16, ex + 6, hy + 21, EYE_GLOW)
            c.R(ex + 1, hy + 17, ex + 6, hy + 21, EYE_CORE)
            c.P(ex + 3, hy + 19, EYE_CORE)
        if glow:
            for dx in (-1, 1):
                ex = cx + dx * 9 - (5 if dx < 0 else 0)
                c.P(ex - 1, hy + 16, AURA)
                c.P(ex + 7, hy + 21, AURA)
    else:
        c.HLINE(hy + 19, cx - 13, cx - 4, BODY_DK)
        c.HLINE(hy + 19, cx + 4, cx + 13, BODY_DK)
    # нахмуренные брови
    c.HLINE(hy + 13, cx - 13, cx - 5, BODY_DK)
    c.P(cx - 4, hy + 14, BODY_DK)
    c.HLINE(hy + 13, cx + 5, cx + 13, BODY_DK)
    c.P(cx + 4, hy + 14, BODY_DK)
    # широкая ухмылка с клыками
    c.R(cx - 12, hy + 26, cx + 12, hy + 30, MOUTH)
    c.P(cx - 12, hy + 31, MOUTH)
    c.P(cx + 12, hy + 31, MOUTH)
    for fx in (cx - 9, cx - 3, cx + 3, cx + 8):
        c.R(fx, hy + 26, fx + 1, hy + 29, FANG)
        c.P(fx, hy + 30, FANG)


# ---------------------------------------------------------------- кадр

def frame(walking, f, dir):
    c = Cv(FW, FH)
    p = pose(walking, f, dir)
    draw_wings(c, dir, p)
    draw_tail(c, dir, p)
    draw_torso(c, dir, p)
    draw_arms(c, dir, p)
    draw_head(c, dir, p)
    c.outline()
    return c


def gen_sheet():
    rows = [
        ("idle_down", False, "down", 6), ("idle_side", False, "side", 6),
        ("idle_up", False, "up", 6),
        ("walk_down", True, "down", 4), ("walk_side", True, "side", 4),
        ("walk_up", True, "up", 4),
    ]
    sheet = Image.new("RGBA", (FW * 6, FH * len(rows)), (0, 0, 0, 0))
    for r, (name, walking, dir, count) in enumerate(rows):
        for f in range(count):
            c = frame(walking, f, dir)
            sheet.paste(c.img, (f * FW, r * FH), c.img)
    save(sheet, "sprites/chars/demon.png")
    return sheet


# ---------------------------------------------------------------- портрет

def gen_portrait():
    S = 64
    c = Cv(S, S)
    # фон: космос + лиловое свечение
    for y in range(S):
        k = y / (S - 1)
        c.HLINE(y, 0, S - 1, C(int(16 + 10 * k), int(12 + 8 * k), int(28 + 16 * k)))
    cx, cy, rad = 32, 32, 30
    for y in range(S):
        for x in range(S):
            d = ((x - cx) ** 2 + (y - cy) ** 2) ** 0.5
            if d < rad:
                a = int(90 * (1 - d / rad) ** 2)
                base = c.px_map.get((x, y), (16, 12, 28, 255))
                c.P(x, y, C(base[0] + 60 * a // 255, base[1] + 20 * a // 255,
                            base[2] + 90 * a // 255))
    for (x, y, b) in ((6, 10, 200), (57, 8, 160), (10, 49, 140), (54, 46, 190),
                      (15, 15, 120), (49, 54, 130), (60, 22, 150), (4, 29, 130)):
        c.P(x, y, C(b, b, min(255, b + 40)))
    # рога: большие, от краёв макушки вверх
    for dx in (-1, 1):
        bx = 32 + dx * 17
        seg = [(bx, 8), (bx + dx * 3, 5), (bx + dx * 5, 2)]
        for i, (sx, sy) in enumerate(seg):
            c.R(min(sx, sx + dx * 2), sy, max(sx, sx + dx * 2) + dx, sy + 8 - i * 2, HORN)
        c.P(bx + dx * 6, 1, HORN)
        c.P(bx + dx * 6, 0, HORN)
        c.P(bx + dx * 2, 9, HORN_SH)
    # голова
    c.R(13, 12, 50, 48, BODY)
    c.R(15, 10, 48, 12, BODY)
    c.R(17, 48, 46, 52, BODY)
    c.VLINE(50, 16, 46, BODY_SH)
    c.VLINE(49, 16, 46, BODY_DK)
    c.R(46, 44, 50, 48, BODY_SH)
    c.R(16, 12, 34, 16, BODY_HI)
    c.P(14, 13, BODY_HI)
    # уши острые
    for dx in (-1, 1):
        ex = 32 + dx * 20
        c.R(ex, 28, ex + dx * 4, 36, BODY)
        c.P(ex + dx * 4, 27, BODY_SH)
        c.P(ex + dx * 4, 28, BODY_DK)
    # глаза: горящие щели
    for dx in (-1, 1):
        ex = 32 + dx * 10 - (6 if dx < 0 else 0)
        c.R(ex, 28, ex + 8, 34, EYE_GLOW)
        c.R(ex + 2, 30, ex + 8, 34, EYE_CORE)
        c.P(ex + 4, 32, EYE_CORE)
        c.P(ex - 1, 28, AURA)
        c.P(ex + 9, 34, AURA)
        # брови-рогалки
        c.HLINE(27, ex, ex + 8, BODY_DK)
        c.P(ex + (8 if dx > 0 else 0), 25, BODY_DK)
        c.P(ex + (8 if dx > 0 else 0), 26, BODY_DK)
    # широкая ухмылка с клыками
    c.R(18, 42, 45, 48, MOUTH)
    c.R(19, 48, 44, 49, BODY_SH)
    for fx in (21, 26, 36, 41):
        c.R(fx, 42, fx + 1, 45, FANG)
        c.P(fx, 46, FANG)
    c.HLINE(44, 18, 45, BODY_DK)
    # воротник-плащ
    c.R(4, 54, 59, 63, WING)
    c.R(0, 58, 63, 63, WING)
    c.VLINE(59, 54, 63, shade(WING, -0.3))
    c.VLINE(63, 58, 63, shade(WING, -0.3))
    c.HLINE(54, 6, 57, WING_HI)
    c.R(28, 52, 35, 54, BODY_DK)   # горло
    c.outline()
    save(c.img, "sprites/portraits/demon.png")


if __name__ == "__main__":
    print("Генерация Таинственного демона (шаг 8):")
    gen_sheet()
    gen_portrait()
    print("Готово.")
