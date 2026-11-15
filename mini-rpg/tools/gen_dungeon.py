# -*- coding: utf-8 -*-
"""Генератор арта подземелий «Dungeon Loot» (шаги 13/15/16).
Тайлы: assets/tilesets/dungeon_tiles.png — атлас 16x16 (8x8 клеток):
  (0,0) стена #, (1,0) колонна o,
  (2,0) стена «Смрадных катакомб», (3,0) «Пустотных чертогов»,
  (4,0) «Костяной обители», (5,0) «Багрового логова» (и данжа 2);
  (0,1) пол ., (1,1) пол ,, (2,1) пол ;,
  (4,1) пол катакомб, (5,1) чертогов, (6,1) обители, (7,1) логова;
  (3,1) кости b, (3,2) паутина w, (4,2) кровь x,
  (5,2)/(6,2)/(7,2)/(0,3) светящиеся трещины g (по темам),
  (1,3) ковёр p, (2,3) золотая мозаика m,
  (0,2) лестница вверх <, (1,2) лестница вниз >, (2,2) выход в замок X.
Свет: assets/sprites/props/glow.png — мягкое радиальное свечение
(аддитивное смешение в dungeon.gd).
Враги: листы 24x32 (те же ряды, что у персонажей): idle_down(6),
idle_side(6), idle_up(6), walk_down(4), walk_side(4), walk_up(4).
Данж 1: паук, змея, космический паук, мертвец бомж, мертвец рыцарь,
мертвец колдун, демон мечник, демон колдун.
Данж 2 «Скит Пустоты» (шаг 16): культисты — послушник, фанатик,
тяжеловес, чтец, старейшина; босс — Великий культист со щупальцами."""
import math
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

    def stone_base(c, pal=None):
        """Кладка из кирпичей: цвета можно подменить под тему этажа."""
        p = pal or {}
        stone = p.get("stone", STONE)
        stone_lo = p.get("stone_lo", STONE_LO)
        stone_hi = p.get("stone_hi", STONE_HI)
        c.R(0, 0, T - 1, T - 1, stone)
        for (x, y) in ((0, 0), (T - 1, 0), (0, T - 1), (T - 1, T - 1)):
            c.P(x, y, stone_lo)
        # швы кладки
        c.HLINE(5, 0, T - 1, stone_lo)
        c.HLINE(11, 0, T - 1, stone_lo)
        c.VLINE(8, 0, 5, stone_lo)
        c.VLINE(4, 6, 11, stone_lo)
        c.VLINE(12, 6, 11, stone_lo)
        c.VLINE(8, 12, T - 1, stone_lo)
        # блики на кирпичах
        c.R(1, 1, 6, 3, stone_hi)
        c.R(10, 7, 11, 9, stone_hi)
        c.R(2, 13, 6, 14, stone_hi)

    def wall(c):
        stone_base(c)

    # --- стены четырёх тем (шаг 15): камень + фирменный акцент ---
    def wall_catacombs(c):
        stone_base(c, {"stone": C(40, 44, 38), "stone_lo": C(28, 32, 27),
                       "stone_hi": C(54, 60, 50)})
        # мшистые проплешины
        c.ellipse(5, 8, 2, 1, C(58, 74, 52))
        c.ellipse(12, 3, 2, 1, C(50, 64, 46))
        c.P(6, 13, C(66, 84, 58))

    def wall_void(c):
        stone_base(c, {"stone": C(40, 36, 56), "stone_lo": C(28, 25, 42),
                       "stone_hi": C(56, 50, 76)})
        # звёздная пыль: светящиеся точки
        for (x, y) in ((3, 3), (11, 2), (7, 8), (13, 12), (5, 14)):
            c.P(x, y, C(196, 178, 236))
        c.P(11, 9, C(140, 120, 190))

    def wall_ossuary(c):
        stone_base(c, {"stone": C(58, 54, 50), "stone_lo": C(42, 39, 36),
                       "stone_hi": C(76, 71, 66)})
        # замурованные кости
        c.HLINE(7, 5, 8, BONE)
        c.P(10, 12, BONE)
        c.P(3, 14, BONE_SH)

    def wall_crimson(c):
        stone_base(c, {"stone": C(52, 30, 32), "stone_lo": C(37, 21, 24),
                       "stone_hi": C(70, 40, 42)})
        # тлеющие угли в швах
        for (x, y) in ((4, 5), (9, 11), (13, 6)):
            c.P(x, y, C(206, 92, 48))
        c.P(9, 11, C(240, 140, 70))

    # --- стены четырёх тем данжа 2 «Скит Пустоты» (шаг 16) ---
    def wall_cells(c):
        stone_base(c, {"stone": C(50, 48, 60), "stone_lo": C(36, 34, 44),
                       "stone_hi": C(64, 62, 76)})
        # копоть от свечей у ниш
        c.VLINE(3, 8, 12, C(34, 30, 40))
        c.VLINE(4, 6, 11, C(40, 36, 48))
        c.P(11, 14, C(40, 36, 48))

    def wall_light(c):
        stone_base(c, {"stone": C(44, 38, 58), "stone_lo": C(31, 27, 42),
                       "stone_hi": C(58, 51, 74)})
        # светящиеся руны культа
        for (x, y) in ((4, 4), (5, 5), (6, 6), (10, 8), (11, 9), (12, 10)):
            c.P(x, y, C(168, 128, 232))
        c.P(5, 4, C(214, 180, 255))
        c.P(11, 8, C(214, 180, 255))

    def wall_sacrarium(c):
        stone_base(c, {"stone": C(58, 52, 52), "stone_lo": C(42, 38, 38),
                       "stone_hi": C(74, 67, 66)})
        # багровые потёки жертв
        c.VLINE(5, 2, 6, C(120, 44, 48))
        c.P(5, 7, C(96, 34, 38))
        c.VLINE(11, 9, 13, C(120, 44, 48))
        c.P(11, 14, C(96, 34, 38))

    def wall_sanctum(c):
        stone_base(c, {"stone": C(30, 26, 40), "stone_lo": C(21, 18, 30),
                       "stone_hi": C(42, 36, 56)})
        # фиолетовые швы Пустоты
        for (x, y) in ((2, 3), (8, 2), (13, 5), (5, 9), (10, 13), (3, 14)):
            c.P(x, y, C(130, 100, 190))
        c.P(8, 2, C(180, 140, 240))

    def pillar(c):
        c.R(2, 0, T - 3, T - 1, C(64, 58, 74))
        c.VLINE(2, 0, T - 1, C(44, 40, 54))
        c.VLINE(T - 3, 0, T - 1, C(44, 40, 54))
        c.R(4, 0, T - 5, 2, C(78, 71, 92))
        c.R(4, T - 4, T - 5, T - 1, C(78, 71, 92))
        c.VLINE(6, 3, T - 5, C(76, 69, 88))
        c.VLINE(10, 3, T - 5, C(48, 43, 60))

    def floor(c, pal=None, speckle=True):
        p = pal or {}
        base = p.get("floor", FLOOR)
        lo = p.get("floor_lo", FLOOR_LO)
        hi = p.get("floor_hi", FLOOR_HI)
        c.R(0, 0, T - 1, T - 1, base)
        c.R(0, 0, T - 1, 0, lo)
        c.R(0, T - 1, T - 1, T - 1, lo)
        if speckle:
            for (x, y) in ((3, 4), (9, 2), (13, 7), (5, 10), (11, 12), (7, 14)):
                c.P(x, y, lo)
            for (x, y) in ((2, 12), (12, 4), (6, 6)):
                c.P(x, y, hi)

    # --- полы четырёх тем ---
    def floor_catacombs(c):
        floor(c, {"floor": C(52, 58, 48), "floor_lo": C(42, 48, 39),
                  "floor_hi": C(62, 70, 57)})
        c.ellipse(12, 11, 2, 1, C(58, 74, 52))

    def floor_void(c):
        floor(c, {"floor": C(48, 44, 62), "floor_lo": C(38, 35, 50),
                  "floor_hi": C(60, 55, 78)})
        c.P(4, 9, C(150, 132, 196))
        c.P(12, 3, C(150, 132, 196))

    def floor_ossuary(c):
        floor(c, {"floor": C(64, 60, 54), "floor_lo": C(52, 49, 44),
                  "floor_hi": C(76, 72, 65)})
        c.P(6, 5, BONE_SH)
        c.P(11, 13, BONE_SH)

    def floor_crimson(c):
        floor(c, {"floor": C(56, 40, 40), "floor_lo": C(44, 31, 32),
                  "floor_hi": C(68, 50, 50)})
        c.P(5, 12, C(190, 86, 44))
        c.P(10, 4, C(160, 70, 40))

    # --- полы четырёх тем данжа 2 (шаг 16) ---
    def floor_cells(c):
        floor(c, {"floor": C(50, 48, 58), "floor_lo": C(40, 38, 47),
                  "floor_hi": C(60, 58, 70)})
        c.P(4, 6, C(70, 62, 92))

    def floor_light(c):
        floor(c, {"floor": C(46, 42, 60), "floor_lo": C(37, 34, 48),
                  "floor_hi": C(57, 52, 72)})
        c.P(6, 10, C(160, 124, 216))
        c.P(12, 5, C(120, 94, 176))

    def floor_sacrarium(c):
        floor(c, {"floor": C(58, 53, 52), "floor_lo": C(47, 43, 42),
                  "floor_hi": C(69, 64, 62)})
        c.P(6, 5, BONE_SH)
        c.P(11, 13, BONE_SH)
        c.ellipse(9, 8, 1, 1, C(110, 42, 46))

    def floor_sanctum(c):
        floor(c, {"floor": C(36, 32, 46), "floor_lo": C(28, 25, 37),
                  "floor_hi": C(46, 41, 57)})
        c.P(5, 12, C(140, 108, 200))
        c.P(10, 4, C(140, 108, 200))

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

    # --- декор-тайлы (шаг 15): паутина, кровь, светящиеся трещины ---
    def tile_web(c):
        floor(c)
        wc = C(196, 192, 206)
        wc_sh = C(140, 138, 152)
        # паутина в углу: радиальные нити + дуги
        for k in range(4):
            x = 1 + k * 4
            y = 1
            for t in range(1, 5):
                c.P(x + t, y + t, wc if t % 2 else wc_sh)
            c.P(x + 5, y + 4, wc_sh)
        c.HLINE(1, 1, 8, wc_sh)
        c.VLINE(1, 1, 8, wc_sh)
        for (x, y) in ((4, 2), (2, 4), (6, 3), (3, 6)):
            c.P(x, y, wc)

    def tile_blood(c):
        floor(c)
        bc = C(122, 30, 34)
        bc_hi = C(156, 44, 46)
        c.ellipse(7, 8, 4, 3, bc)
        c.ellipse(6, 7, 2, 1, bc_hi)
        for (x, y) in ((3, 12), (11, 4), (13, 11), (2, 4)):
            c.P(x, y, bc)
        c.P(11, 5, bc_hi)

    def glow_crack(col, col_hi):
        def painter(c):
            floor(c)
            # зигзаг светящейся трещины по диагонали
            pts = [(2, 13), (3, 12), (4, 12), (5, 11), (6, 11), (7, 10),
                   (8, 9), (9, 8), (9, 7), (10, 6), (11, 6), (12, 5), (13, 4)]
            for (x, y) in pts:
                c.P(x, y, col)
            for (x, y) in pts[1::3]:
                c.P(x, y, col_hi)
            c.P(2, 12, shade(col, -0.35))
            c.P(13, 5, shade(col, -0.35))
        return painter

    # --- ковёр и золотая мозаика (шаг 15) ---
    def tile_carpet(c):
        floor(c)
        red = C(122, 34, 38)
        red_hi = C(150, 46, 50)
        red_lo = C(92, 24, 28)
        c.R(0, 0, T - 1, T - 1, red)
        c.HLINE(0, 0, T - 1, red_lo)
        c.HLINE(15, 0, T - 1, red_lo)
        c.HLINE(3, 1, T - 2, red_hi)
        c.HLINE(12, 1, T - 2, red_hi)
        # золотые узоры
        for x in (2, 6, 10, 14):
            c.P(x, 7, C(206, 164, 74))
            c.P(x, 8, C(206, 164, 74))

    def tile_mosaic(c):
        # золотая мозаика сокровищницы: шахматная плитка
        gold = C(178, 140, 62)
        gold_hi = C(214, 176, 92)
        gold_lo = C(140, 106, 44)
        dark = C(60, 52, 42)
        for y in range(T):
            for x in range(T):
                if (x // 2 + y // 2) % 2 == 0:
                    col = gold
                    if (x + y) % 4 == 0:
                        col = gold_hi
                else:
                    col = dark
                c.P(x, y, col)
        c.HLINE(0, 0, T - 1, gold_lo)
        c.HLINE(15, 0, T - 1, gold_lo)
        c.VLINE(0, 0, T - 1, gold_lo)
        c.VLINE(15, 0, T - 1, gold_lo)

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
        (2, 0, wall_catacombs), (3, 0, wall_void),
        (4, 0, wall_ossuary), (5, 0, wall_crimson),
        (6, 0, wall_cells), (7, 0, wall_light),
        (0, 1, floor), (1, 1, floor_cracked), (2, 1, floor_mossy),
        (3, 1, floor_bones),
        (4, 1, floor_catacombs), (5, 1, floor_void),
        (6, 1, floor_ossuary), (7, 1, floor_crimson),
        (0, 2, stairs_up), (1, 2, stairs_down), (2, 2, exit_hatch),
        (3, 2, tile_web), (4, 2, tile_blood),
        (5, 2, glow_crack(C(96, 220, 120), C(170, 250, 180))),
        (6, 2, glow_crack(C(150, 110, 230), C(216, 180, 255))),
        (7, 2, glow_crack(C(190, 186, 160), C(236, 232, 210))),
        (0, 3, glow_crack(C(220, 108, 52), C(255, 170, 90))),
        (1, 3, tile_carpet), (2, 3, tile_mosaic),
        # данж 2 «Скит Пустоты» (шаг 16): свои стены/полы/свечение
        (0, 4, wall_sacrarium), (1, 4, wall_sanctum),
        (2, 4, floor_cells), (3, 4, floor_light),
        (4, 4, floor_sacrarium), (5, 4, floor_sanctum),
        (6, 4, glow_crack(C(176, 148, 224), C(222, 200, 255))),
        (7, 4, glow_crack(C(150, 110, 230), C(214, 180, 255))),
        (0, 5, glow_crack(C(190, 96, 120), C(238, 160, 180))),
        (1, 5, glow_crack(C(120, 92, 190), C(180, 146, 240))),
    ]
    for (cx, cy, painter) in tiles:
        c = Cv(T, T)
        painter(c)
        sheet.paste(c.img, (cx * T, cy * T), c.img)
    save(sheet, "tilesets/dungeon_tiles.png")
    return sheet


def gen_glow():
    """Мягкое радиальное свечение (шаг 15): белое ядро -> прозрачный край.
    В dungeon.gd рисуется с аддитивным смешением, цвет задаёт modulate."""
    S = 128
    img = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    cx, cy = (S - 1) / 2.0, (S - 1) / 2.0
    max_r = S / 2.0
    px = img.load()
    for y in range(S):
        for x in range(S):
            d = ((x - cx) ** 2 + (y - cy) ** 2) ** 0.5 / max_r
            if d >= 1.0:
                continue
            # плавное затухание: яркое ядро, мягкий хвост
            a = int(255 * (1.0 - d) ** 2.2)
            v = int(255 * (1.0 - d * 0.55))
            px[x, y] = (v, v, v, a)
    save(img, "sprites/props/glow.png")
    return img


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
    if opt.get("dagger"):
        # короткий нож (шаг 16: культисты) — короче меча, ниже рукоять
        wx = cx + 7
        c.R(wx, top + 8, wx + 1, top + 14, pal["blade"])
        c.P(wx + 1, top + 9, shade(pal["blade"], -0.3))
        c.R(wx - 1, top + 14, wx + 1, top + 15, pal["hilt"])
        c.P(wx, top + 16, pal["hilt"])
    if opt.get("maul"):
        # двуручная дубина: толстое древко и железная голова
        wx = cx + 8
        c.R(wx, top + 4, wx + 1, top + 20, pal["staff"])
        c.R(wx - 1, top - 2, wx + 3, top + 5, pal["armor"])
        c.HLINE(top - 2, wx - 1, wx + 3, pal["armor_hi"])
        c.HLINE(top + 5, wx - 1, wx + 3, shade(pal["armor"], -0.35))
    if opt.get("staff"):
        wx = cx + 7
        c.R(wx, top - 1, wx + 1, top + 20, pal["staff"])
        c.ellipse(wx, top - 3, 2, 2, pal["orb"])
        c.P(wx, top - 4, pal["orb_hi"])
    if opt.get("trim"):
        # золотая кайма по подолу и капюшону (шаг 16: старейшины культа)
        gold = pal.get("armor_hi", C(186, 152, 86))
        c.HLINE(top + 10, cx - 5, cx + 5, gold)
        c.HLINE(29, cx - 5, cx + 5, gold)
        c.P(cx - 4, hy + 1, gold)
        c.P(cx + 4, hy + 1, gold)
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


# --- босс данжа 2: Великий культист со щупальцами (шаг 16) ---

def _tentacle(c, pts, pal, r0=5, r1=2):
    """Щупальце: цепь кругов по точкам, с присосками (светлые точки)."""
    n = len(pts)
    for i, (x, y) in enumerate(pts):
        r = max(r1, int(round(r0 + (r1 - r0) * i / max(1, n - 1))))
        col = pal["tent"] if i % 2 == 0 else pal["tent_hi"]
        c.ellipse(x, y, r, max(1, r - 1), col)
        if i % 3 == 1 and r >= 2:
            c.P(x, y - r + 1, pal["sucker"])
    # тёмный контур снизу
    for i, (x, y) in enumerate(pts):
        if i % 2 == 1:
            c.P(x + 1, y + 2, pal["tent_lo"])


def cultist_boss_frame(c, dir, p, pal, f=0):
    """Кадр босса 72x96: база культиста 24x32 (x3) + щупальца из-под мантии,
    плавающие руны у посоха. c — холст 72x96; p — обычная поза; f — номер кадра."""
    W2, H2 = 72, 96
    base = Cv(W, H)
    humanoid_frame(base, dir, p, pal,
                   {"robe": True, "hood": True, "staff": True, "trim": True})
    up = base.img.resize((W2, H2), Image.NEAREST)
    for y in range(H2):
        for x in range(W2):
            r, g, b, a = up.getpixel((x, y))
            if a > 0:
                c.P(x, y, (r, g, b, a))
    # фаза движения щупалец: чередуем кадры (idle 0..5, walk 0..3)
    ph = (f * 2) % 6
    sway = [0, 1, 2, 1, 0, -1][ph]
    bob2 = p.get("bob", 0) * 3
    # левое щупальце: из-под мантии вбок и вниз
    pts_l = [(18, 62 + bob2), (13, 68 + bob2), (9, 76 + bob2),
             (7, 84 + bob2 + sway), (8, 91 + bob2 - sway)]
    _tentacle(c, pts_l, pal, r0=6, r1=3)
    # правое щупальце: повыше и активнее
    pts_r = [(54, 58 + bob2), (60, 66 + bob2), (64, 74 + bob2),
             (65, 83 + bob2 - sway), (62, 90 + bob2 + sway)]
    _tentacle(c, pts_r, pal, r0=6, r1=3)
    # верхнее щупальце: выглядывает из-за плеча и тянется вверх
    pts_t = [(40 + sway, 20 + bob2), (46 + sway, 12 + bob2),
             (52 + sway * 2, 6 + bob2), (58 + sway, 2 + bob2)]
    _tentacle(c, pts_t, pal, r0=4, r1=2)
    # плавающие руны Пустоты у посоха (орб около (12*3, top*3))
    orb_x, orb_y = 12 * 3, (6 + p.get("bob", 0)) * 3 - 9
    rune_cols = [pal["orb"], pal["orb_hi"], pal["tent_hi"]]
    for i in range(4):
        ang = (f * 1.1 + i * 1.57) % 6.28
        rx = int(orb_x + 12 * (1 if i % 2 else -1) * (0.5 + 0.5 * abs(math.cos(ang))))
        ry = int(orb_y + 10 * math.sin(ang))
        c.P(rx, ry, rune_cols[i % 3])
        c.P(rx, ry - 1, shade(rune_cols[i % 3], -0.3))


def gen_boss_cultist():
    """Лист босса данжа 2: 432x596 — сетка 6x6 кадров 72x96 (как у демона)."""
    sheet = Image.new("RGBA", (W * 3 * 6, H * 3 * 6), (0, 0, 0, 0))
    for r, (name, walking, dir, count) in enumerate(SHEET_ROWS):
        for f in range(count):
            big = Cv(W * 3, H * 3)
            p = pose(walking, f, dir)
            cultist_boss_frame(big, dir, p, OVERLORD_PAL, f=f)
            big.outline()
            sheet.paste(big.img, (f * W * 3, r * H * 3), big.img)
    save(sheet, "sprites/dungeon/cultist_overlord.png")
    return sheet


def gen_boss_cultist_portrait():
    """Портрет Великого культиста (64x64, как у прочих NPC): капюшон
    на плечах, светящиеся глаза Пустоты, щупальца в нижних углах."""
    S = 64
    c = Cv(S, S)
    pal = OVERLORD_PAL
    # фон: глубина Пустоты
    c.R(0, 0, S - 1, S - 1, C(26, 20, 40))
    for (x, y) in ((10, 8), (50, 14), (18, 52), (46, 44), (30, 6), (56, 30)):
        c.P(x, y, C(120, 100, 160))
    # щупальца по нижним углам — толще, с присосками
    _tentacle(c, [(4, 40), (9, 48), (15, 55), (23, 59), (30, 61)], pal,
        r0=6, r1=3)
    _tentacle(c, [(60, 38), (55, 47), (48, 54), (41, 59), (34, 61)], pal,
        r0=6, r1=3)
    # плечи и мантия внизу кадра
    c.ellipse(32, 60, 24, 10, pal["body"])
    c.HLINE(61, 12, 52, pal["armor_hi"])
    # капюшон: острый верх, широкая нижняя кромка
    hood = pal["body"]
    c.ellipse(32, 28, 17, 17, hood)
    c.R(28, 6, 36, 16, hood)
    c.ellipse(32, 30, 13, 14, shade(hood, 0.10))
    c.ellipse(32, 32, 10, 12, pal["hood_dark"])
    # золотая кайма по краю капюшона
    for (x, y) in ((15, 30), (15, 24), (17, 17), (21, 11), (27, 7),
                   (37, 7), (43, 11), (47, 17), (49, 24), (49, 30)):
        c.P(x, y, pal["armor_hi"])
    # глаза Пустоты: чуть ниже центра тени
    for dx in (-5, 5):
        c.ellipse(32 + dx, 33, 3, 2, pal["eye"])
        c.P(32 + dx, 33, C(255, 244, 255))
        c.P(32 + dx - 1, 34, shade(pal["eye"], -0.35))
    # посох с орбом у плеча
    c.VLINE(55, 22, 58, pal["staff"])
    c.ellipse(55, 18, 5, 5, pal["orb"])
    c.ellipse(54, 17, 2, 2, pal["orb_hi"])
    c.P(51, 14, pal["orb_hi"])
    c.outline()
    save(c.img, "sprites/portraits/cultist_overlord.png")
    return c.img


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

# --- культисты (шаг 16, данж 2 «Скит Пустоты») ---
# Все — слуги Пустоты: серо-фиолетовые мантии, светящиеся глаза под капюшоном.
ACOLYTE_PAL = {
    "skin": C(176, 168, 158), "body": C(64, 60, 76), "rag": C(48, 45, 58),
    "limb": C(56, 52, 66), "leg": C(52, 48, 62), "boot": C(38, 35, 48),
    "armor": C(78, 72, 92), "armor_hi": C(104, 96, 122),
    "hood_dark": C(22, 18, 32), "eye": C(160, 130, 230),
    "blade": C(184, 184, 196), "hilt": C(96, 72, 48), "horn": C(0, 0, 0),
}
FANATIC_PAL = {
    "skin": C(162, 148, 128), "body": C(84, 44, 46), "rag": C(60, 30, 32),
    "limb": C(72, 38, 40), "leg": C(64, 34, 36), "boot": C(46, 24, 26),
    "armor": C(104, 54, 56), "armor_hi": C(134, 72, 72),
    "hood_dark": C(30, 14, 16), "eye": C(235, 90, 70),
    "blade": C(196, 196, 206), "hilt": C(90, 60, 40), "horn": C(0, 0, 0),
}
GUARDIAN_PAL = {
    "skin": C(170, 162, 150), "body": C(56, 56, 68), "rag": C(44, 44, 54),
    "limb": C(50, 50, 62), "leg": C(46, 46, 56), "boot": C(36, 36, 44),
    "armor": C(98, 96, 110), "armor_hi": C(130, 128, 144),
    "hood_dark": C(18, 16, 26), "eye": C(200, 170, 90),
    "staff": C(96, 72, 48), "orb": C(120, 110, 100), "orb_hi": C(160, 150, 136),
    "horn": C(0, 0, 0),
}
CHANTER_PAL = {
    "skin": C(168, 158, 150), "body": C(70, 52, 96), "rag": C(54, 40, 74),
    "limb": C(60, 46, 84), "leg": C(54, 42, 76), "boot": C(40, 30, 56),
    "armor": C(86, 66, 118), "armor_hi": C(114, 90, 150),
    "hood_dark": C(18, 12, 30), "eye": C(190, 150, 255),
    "staff": C(66, 54, 80), "orb": C(150, 110, 230), "orb_hi": C(214, 180, 255),
    "horn": C(0, 0, 0),
}
ELDER_PAL = {
    "skin": C(160, 150, 140), "body": C(46, 38, 60), "rag": C(36, 30, 48),
    "limb": C(42, 36, 56), "leg": C(40, 34, 52), "boot": C(30, 26, 42),
    "armor": C(66, 56, 88), "armor_hi": C(180, 150, 80),
    "hood_dark": C(14, 10, 24), "eye": C(214, 170, 255),
    "staff": C(60, 48, 74), "orb": C(190, 140, 255), "orb_hi": C(236, 206, 255),
    "horn": C(0, 0, 0),
}
# Босс данжа 2 — Великий культист со щупальцами.
OVERLORD_PAL = {
    "skin": C(150, 138, 128), "body": C(60, 46, 88), "rag": C(44, 34, 66),
    "limb": C(50, 40, 74), "leg": C(46, 38, 68), "boot": C(34, 28, 50),
    "armor": C(80, 62, 116), "armor_hi": C(186, 152, 86),
    "hood_dark": C(14, 8, 26), "eye": C(226, 186, 255),
    "staff": C(58, 44, 72), "orb": C(186, 132, 255), "orb_hi": C(240, 208, 255),
    "tent": C(96, 70, 140), "tent_hi": C(126, 96, 178),
    "tent_lo": C(72, 52, 108), "sucker": C(168, 138, 214),
    "horn": C(0, 0, 0),
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
    # --- культисты (шаг 16, данж 2 «Скит Пустоты») ---
    "cultist_acolyte": lambda c, dir, p: humanoid_frame(c, dir, p, ACOLYTE_PAL,
        {"robe": True, "hood": True, "dagger": True}),
    "cultist_fanatic": lambda c, dir, p: humanoid_frame(c, dir, p, FANATIC_PAL,
        {"robe": True, "hood": True, "ragged": True, "dagger": True}),
    "cultist_guardian": lambda c, dir, p: humanoid_frame(c, dir, p, GUARDIAN_PAL,
        {"robe": True, "hood": True, "armor": True, "maul": True}),
    "cultist_chanter": lambda c, dir, p: humanoid_frame(c, dir, p, CHANTER_PAL,
        {"robe": True, "hood": True, "staff": True}),
    "cultist_elder": lambda c, dir, p: humanoid_frame(c, dir, p, ELDER_PAL,
        {"robe": True, "hood": True, "staff": True, "trim": True}),
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
    print("Генерация арта подземелий (шаги 13/15/16):")
    tiles = gen_tiles()
    gen_glow()
    sheets = gen_foe_sheets()
    gen_boss_cultist()
    gen_boss_cultist_portrait()
    gen_preview(sheets, tiles)
    print("Готово.")
