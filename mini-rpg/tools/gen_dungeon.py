# -*- coding: utf-8 -*-
"""Генератор арта 1-го подземелья «Dungeon Loot» (шаг 13).
Тайлы: assets/tilesets/dungeon_tiles.png — атлас 16x16 (8x8 клеток):
  (0,0) стена #, (1,0) колонна o, (0,1) пол ., (1,1) пол , (2,1) пол ;,
  (3,1) кости b, (0,2) лестница вверх <, (1,2) лестница вниз >,
  (2,2) выход в замок X.
Враги: листы 24x32 (те же ряды, что у персонажей): idle_down(6),
idle_side(6), idle_up(6), walk_down(4), walk_side(4), walk_up(4).
Порядок по возрастанию сложности (шаг 13): паук, змея, космический паук,
мертвец бомж, мертвец рыцарь, мертвец колдун, демон мечник, демон колдун."""
import os
import sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from px import *

W, H = 24, 32

def rr(c, x0, y0, x1, y1, col, r=1):
    c.R(x0, y0, x1, y1, col)
    if r >= 1:
        for (x, y) in ((x0, y0), (x1, y0), (x0, y1), (x1, y1)):
            c.P(x, y, (0, 0, 0, 0))


# ---------------------------------------------------------------- тайлы

STONE = C(38, 34, 46)        # стена
STONE_HI = C(52, 47, 62)
STONE_LO = C(26, 23, 34)
FLOOR = C(56, 51, 62)        # пол
FLOOR_HI = C(66, 61, 74)
FLOOR_LO = C(46, 42, 54)
MOSS = C(58, 74, 52)
BONE = C(212, 204, 182)
BONE_SH = C(168, 158, 140)
STAIR = C(96, 88, 104)
STAIR_HI = C(120, 110, 130)
STAIR_LO = C(30, 27, 38)
GLOW = C(146, 92, 196)
GLOW_HI = C(206, 156, 240)


def gen_tiles():
    T = 16
    sheet = Image.new("RGBA", (T * 8, T * 8), (0, 0, 0, 0))

    def stone_base(c, shade_map=None):
        c.R(0, 0, T - 1, T - 1, STONE)
        for (x, y) in ((0, 0), (T - 1, 0), (0, T - 1), (T - 1, T - 1)):
            c.P(x, y, STONE_LO)
        # швы кладки
        c.HLINE(5, 0, T - 1, STONE_LO)
        c.HLINE(11, 0, T - 1, STONE_LO)
        c.VLINE(8, 0, 5, STONE_LO)
        c.VLINE(4, 6, 11, STONE_LO)
        c.VLINE(12, 6, 11, STONE_LO)
        c.VLINE(8, 12, T - 1, STONE_LO)
        # блики на кирпичах
        c.R(1, 1, 6, 3, STONE_HI)
        c.R(10, 7, 11, 9, STONE_HI)
        c.R(2, 13, 6, 14, STONE_HI)

    def wall(c):
        stone_base(c)

    def pillar(c):
        c.R(2, 0, T - 3, T - 1, C(64, 58, 74))
        c.VLINE(2, 0, T - 1, C(44, 40, 54))
        c.VLINE(T - 3, 0, T - 1, C(44, 40, 54))
        c.R(4, 0, T - 5, 2, C(78, 71, 92))
        c.R(4, T - 4, T - 5, T - 1, C(78, 71, 92))
        c.VLINE(6, 3, T - 5, C(76, 69, 88))
        c.VLINE(10, 3, T - 5, C(48, 43, 60))

    def floor(c, speckle=True):
        c.R(0, 0, T - 1, T - 1, FLOOR)
        c.R(0, 0, T - 1, 0, FLOOR_LO)
        c.R(0, T - 1, T - 1, T - 1, FLOOR_LO)
        if speckle:
            for (x, y) in ((3, 4), (9, 2), (13, 7), (5, 10), (11, 12), (7, 14)):
                c.P(x, y, FLOOR_LO)
            for (x, y) in ((2, 12), (12, 4), (6, 6)):
                c.P(x, y, FLOOR_HI)

    def floor_cracked(c):
        floor(c)
        c.VLINE(7, 1, 6, STONE_LO)
        c.P(8, 7, STONE_LO)
        c.VLINE(6, 8, 10, STONE_LO)
        c.HLINE(6, 12, 14, STONE_LO)
        c.P(11, 13, STONE_LO)

    def floor_mossy(c):
        floor(c)
        c.ellipse(4, 12, 3, 2, C(50, 62, 46))
        c.ellipse(11, 5, 2, 1, C(50, 62, 46))
        c.P(5, 11, MOSS)
        c.P(4, 12, MOSS)
        c.P(12, 5, MOSS)
        c.P(11, 6, C(46, 56, 42))

    def floor_bones(c):
        floor(c)
        # череп и рёбра
        rr(c, 3, 8, 7, 12, BONE, r=1)
        c.P(4, 10, STONE_LO)
        c.P(6, 10, STONE_LO)
        c.HLINE(12, 10, 13, BONE_SH)
        c.HLINE(13, 10, 13, BONE)
        c.HLINE(14, 10, 13, BONE_SH)
        c.P(2, 6, BONE)
        c.P(2, 5, BONE_SH)

    def stairs_up(c):
        # светлые ступени, ведущие к свету
        for i, y in enumerate(range(2, 14, 3)):
            c.R(1, y, T - 2, y + 2, C(96 - i * 10, 88 - i * 10, 104 - i * 10))
            c.HLINE(y, 1, T - 2, STAIR_HI if i < 2 else STAIR)
        c.HLINE(14, 1, T - 2, STAIR_LO)

    def stairs_down(c):
        # тёмные ступени, ведущие во тьму
        for i, y in enumerate(range(2, 14, 3)):
            c.R(1, y, T - 2, y + 2, C(52 + i * 8, 48 + i * 8, 60 + i * 8))
            c.HLINE(y + 2, 1, T - 2, C(26, 23, 32))
        c.HLINE(14, 1, T - 2, C(14, 12, 20))

    def exit_hatch(c):
        floor(c)
        rr(c, 2, 2, T - 3, T - 3, C(30, 20, 46), r=1)
        rr(c, 4, 4, T - 5, T - 5, C(52, 32, 78), r=1)
        c.ellipse(8, 8, 3, 3, GLOW)
        c.ellipse(8, 8, 1, 1, GLOW_HI)
        c.HLINE(4, 4, T - 5, C(96, 66, 132))
        c.VLINE(4, 4, T - 5, C(96, 66, 132))

    tiles = [
        (0, 0, wall), (1, 0, pillar),
        (0, 1, floor), (1, 1, floor_cracked), (2, 1, floor_mossy),
        (3, 1, floor_bones),
        (0, 2, stairs_up), (1, 2, stairs_down), (2, 2, exit_hatch),
    ]
    for (cx, cy, painter) in tiles:
        c = Cv(T, T)
        painter(c)
        sheet.paste(c.img, (cx * T, cy * T), c.img)
    save(sheet, "tilesets/dungeon_tiles.png")
    return sheet


# ---------------------------------------------------------------- враги

# --- пауки (паук, космический паук) ---
def spider_frame(c, dir, p, pal, cosmic=False):
    bob = p.get("bob", 0)
    cx, cy = 12, 17 + bob
    leg_swing = p.get("stride", 0)
    # ноги: по 4 с каждой стороны, шаг чередует фронт/тыл
    for side in (-1, 1):
        for i in range(4):
            x0 = cx + side * 4
            y0 = cy - 2 + i * 2
            swing = leg_swing if i % 2 == 0 else -leg_swing
            if dir == "side":
                x0 = cx + side * 5 + (2 if side > 0 else -2)
            knee_x = x0 + side * 5 + swing
            knee_y = y0 - 3
            tip_x = x0 + side * 6 + swing * 2
            tip_y = y0 + 7
            col = pal["leg"]
            for t in range(6):
                lx = int(x0 + (knee_x - x0) * t / 5.0 + (tip_x - knee_x) * max(0, t - 3) / 3.0)
                ly = int(y0 + (knee_y - y0) * t / 5.0 * (1 if t < 4 else 0)
                         + (tip_y - knee_y) * max(0, t - 3) / 3.0)
                c.P(lx, ly, col)
            c.P(knee_x, knee_y, shade(col, 0.15))
    # тело: два отдела
    c.ellipse(cx, cy, 5, 4, pal["body"])
    c.ellipse(cx, cy - 1, 3, 2, pal["body_hi"])
    c.ellipse(cx, cy + 4, 4, 3, pal["body_sh"])
    if cosmic:
        # звёздные точки на панцире
        for (dx, dy) in ((-2, -1), (2, 0), (0, 1), (-1, 2)):
            c.P(cx + dx, cy + dy + (1 if cosmic else 0), pal["spark"])
    # глаза: впереди (вниз) или сбоку
    if dir == "down":
        for dx in (-2, -1, 1, 2):
            c.P(cx + dx, cy - 3, pal["eye"])
            c.P(cx + dx, cy - 2, shade(pal["eye"], -0.4))
    elif dir == "side":
        c.P(cx + 4, cy - 2, pal["eye"])
        c.P(cx + 5, cy - 1, shade(pal["eye"], -0.4))
    if p.get("blink"):
        pass
    # хелицеры вниз
    if dir == "down":
        c.VLINE(cx - 1, cy + 1, cy + 3, pal["body_sh"])
        c.VLINE(cx + 1, cy + 1, cy + 3, pal["body_sh"])


# --- змея ---
def snake_frame(c, dir, p, pal):
    bob = p.get("bob", 0)
    sway = p.get("stride", 0)
    pts = []
    if dir == "side":
        for i in range(8):
            t = i / 7.0
            x = 4 + int(16 * t)
            y = 20 + int(3 * ((1 - t) if i > 5 else t)) + int(2 * ((1 if i % 2 else -1) if sway else 0))
            pts.append((x, y))
        head = (20, 20 - 2 * (1 if sway else 0) + bob)
        hd = 1
    elif dir == "up":
        for i in range(8):
            t = i / 7.0
            x = 12 + int(3 * (1 - t)) + int(2 * ((1 if i % 2 else -1) * (1 if sway else 0)))
            y = 26 - int(16 * t)
            pts.append((x, y))
        head = (pts[-1][0] - 1, pts[-1][1] - 2)
        hd = -1
    else:
        for i in range(8):
            t = i / 7.0
            x = 12 + int(3 * (1 - t)) + int(2 * ((1 if i % 2 else -1) * (1 if sway else 0)))
            y = 10 + int(16 * t)
            pts.append((x, y))
        head = (pts[-1][0] + 1, pts[-1][1] + 2)
        hd = 1
    for i, (x, y) in enumerate(pts):
        r = 3 - int(1 * (i / 7.0) > 0.6)
        c.ellipse(x, y + bob // 2, max(1, r - 1), max(1, r), pal["body"])
        if i % 2 == 0:
            c.P(x, y, pal["body_hi"])
        if i % 3 == 0:
            c.P(x, y + r - 1, pal["body_sh"])
    # голова
    hx, hy = head
    c.ellipse(hx, hy, 2, 3, pal["body"])
    c.ellipse(hx, hy - 1, 1, 1, pal["body_hi"])
    if dir != "up":
        eye_x = hx + (1 if dir == "side" else 0) + hd
        c.P(eye_x, hy - 1, pal["eye"])
        # жала
        c.P(hx + hd * 2, hy + 1, pal["tongue"])
        c.P(hx + hd * 3, hy + 1, pal["tongue"])


# --- гуманоиды (мертвецы и демоны) ---
def humanoid_frame(c, dir, p, pal, opt):
    bob = p.get("bob", 0)
    stride = p.get("stride", 0)
    arm = p.get("arm", 0)
    cx = 12
    top = 6 + bob
    ragged = opt.get("ragged", False)
    # ноги
    leg_top = 22
    for side in (-1, 1):
        x = cx + side * 3
        step = stride * side if dir == "side" else stride
        c.R(x - 2, leg_top, x + 1, 29 - abs(step), pal["leg"])
        c.R(x - 2, 28 - abs(step), x + 1, 29, pal["boot"])
        if side < 0:
            c.VLINE(x - 2, leg_top, 28, shade(pal["leg"], -0.25))
    # торс
    rr(c, cx - 5, top + 10, cx + 5, top + 21, pal["body"], r=1)
    c.VLINE(cx - 5, top + 11, top + 20, shade(pal["body"], -0.25))
    c.VLINE(cx - 1, top + 11, top + 20, shade(pal["body"], 0.12))
    if ragged:
        for (dx0, dy0, dx1, dy1) in ((-3, 14, -2, 16), (2, 17, 3, 19), (-1, 19, 0, 20)):
            c.R(cx + dx0, top + dy0, cx + dx1, top + dy1, pal["rag"])
    if opt.get("armor"):
        # наплечники и нагрудник
        c.R(cx - 6, top + 10, cx - 4, top + 13, pal["armor"])
        c.R(cx + 4, top + 10, cx + 6, top + 13, pal["armor"])
        c.HLINE(top + 13, cx - 4, cx + 4, shade(pal["armor"], -0.3))
        c.P(cx, top + 15, pal["armor_hi"])
    if opt.get("robe"):
        # мантия вместо ног
        rr(c, cx - 5, top + 10, cx + 5, 29, pal["body"], r=1)
        c.VLINE(cx - 5, top + 12, 28, shade(pal["body"], -0.3))
        c.HLINE(26, cx - 4, cx + 4, shade(pal["body"], -0.2))
        c.P(cx - 2, 27, pal["hood_dark"])
    # руки
    for side in (-1, 1):
        ax = cx + side * 6
        swing = arm * side if dir != "side" else arm
        c.R(ax - 1, top + 11, ax + 1, top + 18 + (swing if dir != "side" else 0),
            pal["limb"])
        c.R(ax - 1, top + 18 + swing, ax + 1, top + 20 + swing, pal["skin"])
    # голова
    hy = top
    if opt.get("hood"):
        rr(c, cx - 4, hy, cx + 4, hy + 9, pal["body"], r=1)
        c.R(cx - 2, hy + 2, cx + 2, hy + 8, pal["hood_dark"])
        if dir != "up":
            for dx in (-1, 1):
                c.P(cx + dx, hy + 4, pal["eye"])
    elif opt.get("helm"):
        rr(c, cx - 4, hy, cx + 4, hy + 8, pal["armor"], r=1)
        c.HLINE(hy + 4, cx - 4, cx + 4, shade(pal["armor"], -0.35))
        c.HLINE(hy + 2, cx - 4, cx + 4, pal["armor_hi"])
        if dir == "down":
            c.R(cx - 3, hy + 5, cx + 3, hy + 6, pal["hood_dark"])
            for dx in (-2, 0, 2):
                c.P(cx + dx, hy + 5, pal["eye"])
        elif dir == "side":
            c.P(cx + 2, hy + 5, pal["eye"])
        # гребень шлема
        c.R(cx - 1, hy - 1, cx + 1, hy, pal["armor_hi"])
    else:
        rr(c, cx - 4, hy, cx + 4, hy + 8, pal["skin"], r=1)
        c.VLINE(cx + 3, hy + 1, hy + 7, shade(pal["skin"], -0.25))
        if dir == "down":
            for dx in (-2, 1):
                c.P(cx + dx, hy + 3, pal["eye"])
            c.P(cx + dx + 1, hy + 3, pal["eye"])
            c.HLINE(hy + 6, cx - 2, cx + 2, shade(pal["skin"], -0.4))
            if ragged:
                c.P(cx - 2, hy + 2, shade(pal["skin"], -0.3))
                c.P(cx + 1, hy + 7, shade(pal["skin"], -0.3))
        elif dir == "side":
            c.P(cx + 2, hy + 3, pal["eye"])
            c.HLINE(hy + 6, cx + 1, cx + 3, shade(pal["skin"], -0.4))
    # рога демона
    if opt.get("horns"):
        for dx in (-1, 1):
            bx = cx + dx * 4
            c.R(min(bx, bx + dx * 2), hy - 1, max(bx, bx + dx * 2), hy + 1, pal["horn"])
            c.P(bx + dx * 3, hy - 2, pal["horn"])
    # оружие
    if opt.get("sword"):
        wx = cx + 7
        hy_sword = top + 2
        c.R(wx, hy_sword, wx + 1, top + 16, pal["blade"])
        c.VLINE(wx + 1, hy_sword + 1, top + 16, shade(pal["blade"], -0.3))
        c.R(wx - 1, top + 16, wx + 3, top + 17, pal["hilt"])
        c.R(wx, top + 17, wx + 1, top + 20, pal["hilt"])
    if opt.get("staff"):
        wx = cx + 7
        c.R(wx, top - 1, wx + 1, top + 20, pal["staff"])
        c.ellipse(wx, top - 3, 2, 2, pal["orb"])
        c.P(wx, top - 4, pal["orb_hi"])
    if opt.get("cloak"):
        # рваный плащ сзади (вид сбоку)
        if dir == "side":
            c.R(cx - 6, top + 10, cx - 4, 29, pal["rag"])


def pose(walking, f, dir):
    p = {"bob": 0, "arm": 0, "stride": 0, "blink": False}
    if walking:
        p["stride"] = [2, 0, -2, 0][f]
        p["bob"] = 1 if f % 2 == 1 else 0
        p["arm"] = [1, 0, -1, 0][f]
    else:
        p["bob"] = [0, 1, 1, 0, 1, 1][f % 6]
        p["blink"] = (f % 6 == 5)
    return p


# ---------------------------------------------------------------- палитры

SPIDER_PAL = {
    "body": C(64, 44, 40), "body_hi": C(88, 62, 54), "body_sh": C(44, 30, 28),
    "leg": C(40, 28, 26), "eye": C(226, 84, 60), "spark": C(200, 160, 90),
}
COSMIC_PAL = {
    "body": C(74, 52, 110), "body_hi": C(104, 78, 148), "body_sh": C(52, 36, 82),
    "leg": C(44, 32, 68), "eye": C(240, 210, 120), "spark": C(216, 196, 255),
}
SNAKE_PAL = {
    "body": C(58, 92, 56), "body_hi": C(84, 124, 78), "body_sh": C(40, 66, 42),
    "eye": C(240, 200, 70), "tongue": C(220, 90, 70),
}
BUM_PAL = {
    "skin": C(148, 152, 128), "body": C(78, 72, 62), "rag": C(56, 52, 46),
    "limb": C(70, 64, 56), "leg": C(64, 58, 52), "boot": C(46, 42, 38),
    "eye": C(190, 210, 160), "horn": C(0, 0, 0),
}
KNIGHT_PAL = {
    "skin": C(150, 148, 142), "body": C(88, 88, 98), "rag": C(60, 60, 68),
    "limb": C(78, 78, 88), "leg": C(72, 72, 82), "boot": C(52, 52, 60),
    "armor": C(104, 104, 118), "armor_hi": C(140, 140, 156),
    "hood_dark": C(24, 22, 30), "eye": C(120, 220, 200),
    "blade": C(150, 150, 162), "hilt": C(96, 72, 48), "horn": C(0, 0, 0),
}
SORC_PAL = {
    "skin": C(132, 140, 124), "body": C(52, 66, 58), "rag": C(38, 48, 44),
    "limb": C(46, 58, 52), "leg": C(42, 52, 47), "boot": C(30, 36, 33),
    "armor": C(64, 78, 70), "armor_hi": C(90, 106, 94),
    "hood_dark": C(18, 24, 21), "eye": C(120, 240, 150),
    "staff": C(66, 54, 44), "orb": C(110, 220, 150), "orb_hi": C(190, 255, 210),
    "horn": C(0, 0, 0), "hood": True,
}
DSWORD_PAL = {
    "skin": C(150, 62, 54), "body": C(126, 38, 48), "rag": C(90, 28, 36),
    "limb": C(110, 34, 44), "leg": C(96, 30, 40), "boot": C(60, 20, 28),
    "armor": C(146, 44, 50), "armor_hi": C(180, 70, 66),
    "hood_dark": C(40, 12, 18), "eye": C(255, 186, 64),
    "blade": C(196, 196, 208), "hilt": C(110, 78, 46),
    "horn": C(226, 210, 186),
}
DSORC_PAL = {
    "skin": C(150, 62, 54), "body": C(96, 40, 92), "rag": C(70, 28, 66),
    "limb": C(84, 34, 80), "leg": C(72, 30, 68), "boot": C(48, 20, 46),
    "armor": C(110, 46, 104), "armor_hi": C(146, 64, 138),
    "hood_dark": C(30, 12, 28), "eye": C(255, 170, 90),
    "staff": C(70, 52, 66), "orb": C(190, 110, 230), "orb_hi": C(240, 190, 255),
    "horn": C(226, 210, 186),
}

# id -> (фабрика кадра, опции гуманоида)
FOE_FACTORIES = {
    "spider": lambda c, dir, p: spider_frame(c, dir, p, SPIDER_PAL),
    "snake": lambda c, dir, p: snake_frame(c, dir, p, SNAKE_PAL),
    "cosmic_spider": lambda c, dir, p: spider_frame(c, dir, p, COSMIC_PAL, cosmic=True),
    "undead_bum": lambda c, dir, p: humanoid_frame(c, dir, p, BUM_PAL,
        {"ragged": True}),
    "undead_knight": lambda c, dir, p: humanoid_frame(c, dir, p, KNIGHT_PAL,
        {"armor": True, "helm": True, "sword": True}),
    "undead_sorcerer": lambda c, dir, p: humanoid_frame(c, dir, p, SORC_PAL,
        {"robe": True, "hood": True, "staff": True}),
    "demon_swordsman": lambda c, dir, p: humanoid_frame(c, dir, p, DSWORD_PAL,
        {"horns": True, "sword": True}),
    "demon_sorcerer": lambda c, dir, p: humanoid_frame(c, dir, p, DSORC_PAL,
        {"horns": True, "robe": True, "hood": True, "staff": True}),
}

SHEET_ROWS = [
    ("idle_down", False, "down", 6), ("idle_side", False, "side", 6),
    ("idle_up", False, "up", 6),
    ("walk_down", True, "down", 4), ("walk_side", True, "side", 4),
    ("walk_up", True, "up", 4),
]


def gen_foe_sheets():
    sheets = {}
    for foe_id, factory in FOE_FACTORIES.items():
        sheet = Image.new("RGBA", (W * 6, H * 6), (0, 0, 0, 0))
        for r, (name, walking, dir, count) in enumerate(SHEET_ROWS):
            for f in range(count):
                c = Cv(W, H)
                p = pose(walking, f, dir)
                factory(c, dir, p)
                c.outline()
                sheet.paste(c.img, (f * W, r * H), c.img)
        save(sheet, "sprites/dungeon/%s.png" % foe_id)
        sheets[foe_id] = sheet
    return sheets


def gen_preview(sheets, tiles):
    """Превью врагов и тайлов для быстрой проверки глазами."""
    from PIL import ImageDraw
    scale = 3
    cols = 4
    ids = list(FOE_FACTORIES.keys())
    rows = (len(ids) + cols - 1) // cols + 1
    cell_w, cell_h = W * scale, H * scale
    pv = Image.new("RGBA", (cols * cell_w, rows * cell_h + 64), (30, 28, 42, 255))
    d = ImageDraw.Draw(pv)
    for i, foe_id in enumerate(ids):
        x = (i % cols) * cell_w
        y = (i // cols) * cell_h
        img = sheets[foe_id].crop((0, 0, W * 6 // 4, H))
        img = img.resize((W * scale, H * scale), Image.NEAREST)
        pv.paste(img, (x + 4, y + 4), img)
        d.text((x + 6, y + 2), foe_id, fill=(255, 255, 140, 255))
    # тайлы в ряд
    ty = rows * cell_h + 8
    T = 16
    for i, (cx, cy) in enumerate([(0, 0), (1, 0), (0, 1), (1, 1), (2, 1), (3, 1),
                                  (0, 2), (1, 2), (2, 2)]):
        img = tiles.crop((cx * T, cy * T, (cx + 1) * T, (cy + 1) * T))
        img = img.resize((T * 4, T * 4), Image.NEAREST)
        pv.paste(img, (i * T * 4 + 4, ty + 14), img)
    save(pv, "../dungeon_foes_preview.png")


if __name__ == "__main__":
    print("Генерация арта подземелья (шаг 13):")
    tiles = gen_tiles()
    sheets = gen_foe_sheets()
    gen_preview(sheets, tiles)
    print("Готово.")
