# -*- coding: utf-8 -*-
"""Шаг 20: арт данжа 3 «Глубины Р'льеха» (лавкрафтианские чудовища).

Дорисовывает в СУЩЕСТВУЮЩИЙ атлас assets/tilesets/dungeon_tiles.png новые
тайлы в свободных клетках (ряды 6–7 и хвост ряда 5) и создаёт листы врагов:
  Глубинный (deep_one), Пожиратель снов (dream_eater), Шоггот (shoggoth),
  Отродье звёзд (star_spawn), Ползун щупалец (tentacle_crawler);
босс — Большой Ктулху (лист 72x96, как у прочих боссов) и портрет 64x64.

Тайлы (атлас 8x8, 16 px):
  (0,6) стена гротов,  (5,6) стена библиотеки, (1,7) стена гнезда,
  (5,7) стона трона Р'льеха;
  (2,6)/(3,6) полы гротов, (6,6)/(7,6) полы библиотеки,
  (2,7)/(3,7) полы гнезда, (6,7)/(7,7) полы трона;
  (4,6) трещина гротов, (0,7) руны библиотеки, (4,7) кровавое гнездо,
  (2,5) свечение Р'льеха.

Запуск:  python3 tools/gen_dungeon3.py
"""
import math
import os
import sys

from PIL import Image

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from px import Cv, C, shade, save, INK
import gen_dungeon as gd

ATLAS = os.path.join(gd.px.OUT if False else "", "")
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ATLAS_PATH = os.path.join(ROOT, "assets", "tilesets", "dungeon_tiles.png")
W, H = 24, 32


def brick(c, pal):
    """Кладка 16x16: базовый камень со швами и бликами (как в gen_tiles)."""
    stone = pal["stone"]
    lo = pal["lo"]
    hi = pal["hi"]
    c.R(0, 0, 15, 15, stone)
    for (x, y) in ((0, 0), (15, 0), (0, 15), (15, 15)):
        c.P(x, y, lo)
    c.HLINE(5, 0, 15, lo)
    c.HLINE(11, 0, 15, lo)
    c.VLINE(8, 0, 5, lo)
    c.VLINE(4, 6, 11, lo)
    c.VLINE(12, 6, 11, lo)
    c.VLINE(8, 12, 15, lo)
    c.R(1, 1, 6, 3, hi)
    c.R(10, 7, 11, 9, hi)
    c.R(2, 13, 6, 14, hi)


def floor_base(c, pal):
    base = pal["floor"]
    lo = pal["lo"]
    hi = pal["hi"]
    c.R(0, 0, 15, 15, base)
    c.HLINE(0, 0, 15, lo)
    c.HLINE(15, 0, 15, lo)
    for (x, y) in ((3, 4), (9, 2), (13, 7), (5, 10), (11, 12), (7, 14)):
        c.P(x, y, lo)
    for (x, y) in ((2, 12), (12, 4), (6, 6)):
        c.P(x, y, hi)


# ---------------------------------------------------------------- тайлы

def gen_tiles():
    from PIL import Image
    atlas = Image.open(ATLAS_PATH).convert("RGBA")
    T = 16

    def put(tx, ty, painter):
        c = Cv(T, T)
        painter(c)
        atlas.paste(c.img, (tx * T, ty * T))

    # --- «Затопленные гроты»: зелёный мокрый камень, водоросли ---
    def wall_grot(c):
        brick(c, {"stone": C(38, 50, 44), "lo": C(26, 36, 31),
                  "hi": C(52, 66, 58)})
        # мокрые потёки и водоросли
        c.VLINE(3, 6, 10, C(30, 44, 38))
        c.VLINE(11, 12, 15, C(30, 44, 38))
        c.ellipse(6, 8, 2, 1, C(56, 92, 62))
        c.P(12, 3, C(70, 110, 74))
        c.P(2, 13, C(70, 110, 74))

    def floor_grot(c):
        floor_base(c, {"floor": C(46, 56, 50), "lo": C(36, 46, 41),
                       "hi": C(58, 70, 62)})
        c.ellipse(11, 11, 2, 1, C(54, 84, 58))

    def floor_grot2(c):
        floor_base(c, {"floor": C(42, 52, 47), "lo": C(33, 42, 38),
                       "hi": C(54, 66, 58)})
        # лужа
        c.ellipse(5, 9, 3, 1, C(58, 88, 66))
        c.P(5, 9, C(88, 128, 96))

    def glow_grot(c):
        # светящаяся щель: холодная зелень бездны
        c.R(0, 0, 15, 15, C(30, 40, 36))
        c.HLINE(7, 2, 13, C(96, 190, 120))
        c.HLINE(6, 4, 11, C(150, 230, 160))
        c.HLINE(8, 4, 11, C(64, 140, 90))
        c.P(3, 7, C(190, 245, 190))
        c.P(12, 7, C(190, 245, 190))

    # --- «Библиотека запретных имён»: серо-зелёные плиты и руны ---
    def wall_library(c):
        brick(c, {"stone": C(46, 46, 52), "lo": C(32, 32, 38),
                  "hi": C(62, 62, 70)})
        # пыльные корешки запретных томов в нише
        c.R(5, 7, 10, 10, C(30, 28, 36))
        for (x, col) in ((5, C(96, 74, 52)), (7, C(70, 56, 84)),
                         (9, C(58, 78, 62))):
            c.VLINE(x, 7, 10, col)
        c.P(13, 4, C(150, 190, 140))

    def floor_library(c):
        floor_base(c, {"floor": C(50, 50, 56), "lo": C(40, 40, 46),
                       "hi": C(62, 62, 70)})
        # разбросанные страницы
        c.R(4, 10, 7, 12, C(196, 188, 162))
        c.HLINE(11, 5, 6, C(150, 144, 124))

    def floor_library2(c):
        floor_base(c, {"floor": C(46, 46, 52), "lo": C(37, 37, 43),
                       "hi": C(58, 58, 66)})
        c.ellipse(9, 5, 2, 1, C(40, 40, 48))

    def glow_runes(c):
        c.R(0, 0, 15, 15, C(34, 34, 42))
        # пентагон запретного имени
        pts = []
        for i in range(5):
            ang = -math.pi / 2 + i * 2 * math.pi / 5
            pts.append((8 + int(5 * math.cos(ang)), 8 + int(5 * math.sin(ang))))
        for i in range(5):
            a = pts[i]
            b = pts[(i + 2) % 5]
            steps = 12
            for t in range(steps):
                x = int(a[0] + (b[0] - a[0]) * t / (steps - 1.0))
                y = int(a[1] + (b[1] - a[1]) * t / (steps - 1.0))
                c.P(x, y, C(120, 210, 140))
        c.P(8, 8, C(190, 250, 180))

    # --- «Гнездо щупалец»: тёмная живая плоть ---
    def wall_nest(c):
        brick(c, {"stone": C(44, 34, 46), "lo": C(30, 23, 33),
                  "hi": C(60, 47, 60)})
        # присоски в швах
        for (x, y) in ((4, 8), (9, 3), (13, 13)):
            c.ellipse(x, y, 1, 1, C(120, 88, 116))
            c.P(x, y, C(170, 130, 160))

    def floor_nest(c):
        floor_base(c, {"floor": C(50, 40, 48), "lo": C(40, 31, 39),
                       "hi": C(62, 50, 59)})
        # вены плоти
        c.HLINE(6, 3, 12, C(74, 44, 56))
        c.P(7, 6, C(96, 56, 68))
        c.VLINE(11, 8, 12, C(74, 44, 56))

    def floor_nest2(c):
        floor_base(c, {"floor": C(46, 37, 45), "lo": C(37, 29, 36),
                       "hi": C(58, 47, 56)})
        c.ellipse(4, 4, 2, 1, C(80, 52, 64))

    def glow_nest(c):
        c.R(0, 0, 15, 15, C(38, 28, 36))
        c.ellipse(8, 8, 5, 4, C(130, 60, 90))
        c.ellipse(8, 8, 3, 2, C(180, 90, 120))
        c.ellipse(8, 8, 1, 1, C(230, 150, 170))
        for (x, y) in ((3, 5), (12, 11), (5, 12), (11, 4)):
            c.P(x, y, C(150, 80, 100))

    # --- «Трон Р'льеха»: циклопические плиты с зелёным свечением ---
    def wall_rlyeh(c):
        brick(c, {"stone": C(34, 40, 40), "lo": C(23, 28, 28),
                  "hi": C(46, 54, 54)})
        # иероглифы спящего
        for (x, y) in ((3, 3), (6, 2), (10, 4), (12, 9), (5, 13)):
            c.P(x, y, C(110, 190, 140))
        c.P(6, 2, C(160, 230, 170))

    def floor_rlyeh(c):
        floor_base(c, {"floor": C(38, 44, 44), "lo": C(30, 36, 36),
                       "hi": C(50, 58, 58)})
        c.P(9, 9, C(70, 110, 84))

    def floor_rlyeh2(c):
        floor_base(c, {"floor": C(35, 41, 41), "lo": C(28, 33, 33),
                       "hi": C(47, 55, 55)})
        c.ellipse(11, 4, 2, 1, C(58, 90, 70))

    def glow_rlyeh(c):
        c.R(0, 0, 15, 15, C(26, 32, 32))
        # глаз спящего над троном
        c.ellipse(8, 8, 6, 3, C(40, 70, 60))
        c.ellipse(8, 8, 4, 2, C(90, 190, 120))
        c.ellipse(8, 8, 2, 2, C(40, 60, 48))
        c.P(8, 7, C(200, 255, 200))
        c.P(2, 8, C(60, 110, 80))
        c.P(13, 8, C(60, 110, 80))

    put(0, 6, wall_grot); put(5, 6, wall_library)
    put(1, 7, wall_nest); put(5, 7, wall_rlyeh)
    put(2, 6, floor_grot); put(3, 6, floor_grot2)
    put(6, 6, floor_library); put(7, 6, floor_library2)
    put(2, 7, floor_nest); put(3, 7, floor_nest2)
    put(6, 7, floor_rlyeh); put(7, 7, floor_rlyeh2)
    put(4, 6, glow_grot); put(0, 7, glow_runes)
    put(4, 7, glow_nest); put(2, 5, glow_rlyeh)
    atlas.save(ATLAS_PATH)
    print("  -> tilesets/dungeon_tiles.png: +14 тайлов Р'льеха (ряды 6-7)")
    return atlas


# ------------------------------------------------------------- чудовища

DEEP_ONE_PAL = {
    "skin": C(102, 138, 108), "body": C(72, 96, 78), "rag": C(56, 76, 62),
    "limb": C(64, 86, 70), "leg": C(58, 78, 64), "boot": C(44, 60, 50),
    "armor": C(88, 116, 92), "armor_hi": C(120, 150, 122),
    "hood_dark": C(20, 30, 24), "eye": C(240, 220, 90),
    "fin": C(46, 72, 64), "fin_hi": C(70, 104, 86),
    "horn": C(0, 0, 0),
}
DREAM_EATER_PAL = {
    "skin": C(150, 138, 132), "body": C(62, 44, 92), "rag": C(48, 34, 72),
    "limb": C(54, 40, 80), "leg": C(48, 36, 72), "boot": C(36, 27, 54),
    "armor": C(80, 58, 112), "armor_hi": C(110, 84, 150),
    "hood_dark": C(16, 10, 28), "eye": C(160, 250, 170),
    "staff": C(58, 44, 78), "orb": C(150, 240, 160), "orb_hi": C(210, 255, 200),
    "tent": C(130, 96, 160), "tent_hi": C(164, 128, 196),
    "tent_lo": C(96, 70, 120), "sucker": C(210, 180, 235),
    "horn": C(0, 0, 0),
}
SHOGGOTH_PAL = {
    "mass": C(70, 96, 66), "mass_hi": C(104, 136, 92),
    "mass_lo": C(50, 70, 48), "eye": C(240, 230, 130),
    "pseud": C(56, 78, 54), "spark": C(180, 230, 150),
}
STAR_SPAWN_PAL = {
    "skin": C(110, 96, 158), "body": C(84, 72, 128), "rag": C(66, 56, 104),
    "limb": C(76, 66, 116), "leg": C(70, 60, 108), "boot": C(52, 45, 82),
    "armor": C(100, 88, 146), "armor_hi": C(136, 120, 182),
    "hood_dark": C(22, 18, 38), "eye": C(120, 240, 230),
    "wing": C(48, 40, 76), "wing_hi": C(72, 62, 108),
    "horn": C(220, 210, 160),
}
CRAWLER_PAL = {
    "mass": C(64, 56, 92), "mass_hi": C(92, 82, 126), "mass_lo": C(46, 40, 68),
    "tent": C(84, 72, 118), "tent_hi": C(112, 100, 152),
    "tent_lo": C(62, 54, 90), "sucker": C(180, 165, 215),
    "eye": C(230, 120, 110),
}
CTHULHU_PAL = {
    "skin": C(64, 108, 78), "body": C(52, 90, 68), "rag": C(40, 72, 54),
    "limb": C(46, 80, 60), "leg": C(42, 72, 55), "boot": C(32, 56, 42),
    "armor": C(60, 100, 74), "armor_hi": C(160, 140, 70),
    "hood_dark": C(10, 24, 16), "eye": C(240, 110, 60),
    "wing": C(26, 44, 46), "wing_hi": C(40, 66, 66),
    "tent": C(56, 110, 72), "tent_hi": C(78, 142, 92),
    "tent_lo": C(40, 82, 54), "sucker": C(130, 190, 130),
    "horn": C(0, 0, 0),
}


def deep_one_frame(c, dir, p, pal):
    """Глубинный: рыбощуп — плавники по рукам и голове, жабры, когти."""
    gd.humanoid_frame(c, dir, p, pal, {"armor": True})
    bob = p.get("bob", 0)
    cx, top = 12, 6 + bob
    # гребень-плавник на голове
    for (dx, dy) in ((0, -2), (-1, -3), (1, -3), (0, -4)):
        c.P(cx + dx, top + dy, pal["fin_hi"])
    c.P(cx, top - 1, pal["fin"])
    # жабры на щеках
    if dir != "up":
        c.VLINE(cx - 3, top + 3, top + 5, shade(pal["skin"], -0.3))
        c.VLINE(cx + 3, top + 3, top + 5, shade(pal["skin"], -0.3))
    # плавники на локтях
    for side in (-1, 1):
        ax = cx + side * 6
        c.P(ax + side, top + 14, pal["fin"])
        c.P(ax + side, top + 15, pal["fin_hi"])
        c.P(ax + side * 2, top + 15, pal["fin"])
    # перепонки на ногах
    c.R(cx - 4, 29, cx - 3, 29, pal["fin"])
    c.R(cx + 3, 29, cx + 4, 29, pal["fin"])
    # чешуйчатые блики на теле
    for (dx, dy) in ((-2, 14), (1, 16), (-1, 19), (3, 15)):
        c.P(cx + dx, top + dy, shade(pal["body"], 0.15))


def dream_eater_frame(c, dir, p, pal):
    """Пожиратель снов: мантия, капюшон и ПУЧОК ЩУПАЛЕЦ вместо лица."""
    gd.humanoid_frame(c, dir, p, pal, {"robe": True, "hood": True,
                                       "staff": True})
    bob = p.get("bob", 0)
    cx, top = 12, 6 + bob
    sway = [0, 1, 1, 0, -1, -1][p.get("f", 0) % 6] if not p.get("stride") \
        else [1, 0, -1, 0][p.get("f", 0) % 4]
    # щупальца из тени капюшона (вниз/вбок; вверх — спрятаны за капюшоном)
    if dir != "up":
        gd._tentacle(c, [(cx - 2, top + 4), (cx - 4, top + 7 + sway),
                         (cx - 6, top + 10 - sway)], pal, r0=2, r1=1)
        gd._tentacle(c, [(cx + 2, top + 4), (cx + 4, top + 8 - sway),
                         (cx + 6, top + 11 + sway)], pal, r0=2, r1=1)
        gd._tentacle(c, [(cx, top + 6), (cx + 1, top + 9 + sway),
                         (cx - 1, top + 12)], pal, r0=2, r1=1)
        # горящий глаз сквозь щупальца
        c.P(cx, top + 4, pal["eye"])
    else:
        # сзади видно только капюшон и пару щупалец над плечами
        gd._tentacle(c, [(cx - 3, top + 3), (cx - 5, top - 1 + sway)], pal,
                     r0=2, r1=1)
        gd._tentacle(c, [(cx + 3, top + 3), (cx + 5, top - 1 - sway)], pal,
                     r0=2, r1=1)


def shoggoth_frame(c, dir, p, pal):
    """Шоггот: бесформенный блоб, пульсирует, глаза повсюду, лже-ноги."""
    f = p.get("f", 0) % 6
    breathe = (1, 2, 3, 2, 1, 0)[f if not p.get("stride") else (f % 4)]
    cx = 12
    cy = 20 - breathe // 2
    rx = 7 + (1 if breathe >= 2 else 0)
    ry = 6 + breathe // 2
    c.ellipse(cx, cy, rx, ry, pal["mass"])
    c.ellipse(cx - 2, cy - 2, rx - 3, ry - 3, pal["mass_hi"])
    c.ellipse(cx + 2, cy + 2, rx - 3, max(1, ry - 3), pal["mass_lo"])
    # бугры-псевдоподы по краю
    for (dx, dy) in ((-6, -1), (6, -2), (-5, 3), (5, 4), (0, -6)):
        c.ellipse(cx + dx, cy + dy + breathe, 2, 1, pal["pseud"])
    # капли наверх
    c.ellipse(cx - 3, cy - ry - 1, 1, 2, pal["mass"])
    c.ellipse(cx + 4, cy - ry, 1, 1, pal["mass_hi"])
    # глаза: смотрят по dir
    eyes = [(-3, -2), (0, -3), (3, -1), (-1, 1), (2, 2)]
    for (dx, dy) in eyes:
        ex, ey = cx + dx, cy + dy
        if dir == "up":
            continue
        if dir == "down" or dy < 0 or abs(dx) <= 1:
            c.ellipse(ex, ey, 1, 1, pal["eye"])
            if (dx, dy) in ((0, -3), (-3, -2)):
                c.P(ex + (0 if dir == "down" else 1), ey, C(255, 255, 220))
    # «рот»-щель снизу при взгляде вниз
    if dir == "down":
        c.HLINE(cy + 4, cx - 2, cx + 2, C(20, 30, 18))
        for dx in (-1, 0, 1):
            c.P(cx + dx, cy + 5, shade(pal["mass_lo"], -0.3))


def star_spawn_frame(c, dir, p, pal):
    """Отродье звёзд: крылья за спиной, рога, звёздные искры на коже."""
    gd.humanoid_frame(c, dir, p, pal, {"horns": True})
    bob = p.get("bob", 0)
    cx, top = 12, 6 + bob
    flap = 1 if p.get("stride") and p.get("f", 0) % 2 else 0
    # крылья: перепонка за плечами
    if dir == "side":
        wx = cx - 7
        c.R(wx, top + 9 - flap, wx + 4, top + 18, pal["wing"])
        c.HLINE(top + 12 - flap, wx, wx + 3, pal["wing_hi"])
        c.HLINE(top + 15 - flap, wx + 1, wx + 4, pal["wing_hi"])
    else:
        for side in (-1, 1):
            x0 = cx + side * 6
            c.R(x0 - (2 if side > 0 else 0), top + 8 - flap, x0 + side * 3,
                top + 17, pal["wing"])
            c.HLINE(top + 11 - flap, x0, x0 + side * 3, pal["wing_hi"])
            c.HLINE(top + 14 - flap, x0 + side, x0 + side * 3, pal["wing_hi"])
    # звёздные искры на теле
    for (dx, dy) in ((-3, 13), (2, 15), (-1, 18), (3, 12)):
        c.P(cx + dx, top + dy, pal["armor_hi"])
    c.P(cx - 2, top + 16, C(255, 250, 200))
    # второй глаз (третий — во лбу)
    if dir == "down":
        c.P(cx, top + 2, pal["eye"])


def crawler_frame(c, dir, p, pal):
    """Ползун щупалец: центральная масса и 6 щупалец-ног."""
    f = p.get("f", 0)
    bob = p.get("bob", 0)
    cx, cy = 12, 18 + bob
    c.ellipse(cx, cy, 5, 4, pal["mass"])
    c.ellipse(cx, cy - 2, 3, 2, pal["mass_hi"])
    c.ellipse(cx, cy + 2, 4, 2, pal["mass_lo"])
    stride = p.get("stride", 0)
    # щупальца-ноги: по 3 с каждой стороны, шаг чередует фазы
    for side in (-1, 1):
        for i in range(3):
            swing = (stride if (i % 2 == 0) else -stride) * side
            if dir == "side":
                swing = (stride if (i % 2 == 0) else -stride)
            x0 = cx + side * 4
            y0 = cy - 1 + i * 2
            pts = [(x0, y0), (x0 + side * 4, y0 + 2), (x0 + side * 6 + swing,
                   y0 + 7)]
            gd._tentacle(c, pts, pal, r0=2, r1=1)
    # вперёд смотрят два злых глаза + присоски на макушке
    if dir == "down":
        for dx in (-2, 1):
            c.P(cx + dx, cy - 3, pal["eye"])
            c.P(cx + dx, cy - 2, shade(pal["eye"], -0.4))
    elif dir == "side":
        c.P(cx + 4, cy - 3, pal["eye"])
    for (dx, dy) in ((-2, -4), (0, -5), (2, -4)):
        c.P(cx + dx, cy + dy, pal["sucker"])


FOE_FACTORIES_3 = {
    "deep_one": deep_one_frame,
    "dream_eater": dream_eater_frame,
    "shoggoth": shoggoth_frame,
    "star_spawn": star_spawn_frame,
    "tentacle_crawler": crawler_frame,
}
FOE_PALS_3 = {
    "deep_one": DEEP_ONE_PAL,
    "dream_eater": DREAM_EATER_PAL,
    "shoggoth": SHOGGOTH_PAL,
    "star_spawn": STAR_SPAWN_PAL,
    "tentacle_crawler": CRAWLER_PAL,
}


def _pass_f(pal, foe_id):
    """Фабрика кадра: dict позы дополняется f (номер кадра) для анимаций."""
    def factory(c, dir, p):
        p = dict(p)
        p["f"] = p.pop("frame", 0)
        FOE_FACTORIES_3[foe_id](c, dir, p, pal)
    return factory


def gen_foe_sheets_3():
    from PIL import Image
    sheets = {}
    for foe_id, pal in FOE_PALS_3.items():
        sheet = Image.new("RGBA", (W * 6, H * 6), (0, 0, 0, 0))
        for r, (name, walking, dir, count) in enumerate(gd.SHEET_ROWS):
            for f in range(count):
                c = Cv(W, H)
                p = gd.pose(walking, f, dir)
                p["frame"] = f
                _pass_f(pal, foe_id)(c, dir, p)
                c.outline()
                sheet.paste(c.img, (f * W, r * H), c.img)
        save(sheet, "sprites/dungeon/%s.png" % foe_id)
        sheets[foe_id] = sheet
    return sheets


# ---------------------------------------------------------------- ктулху

def cthulhu_frame(c, dir, p, pal, f=0):
    """Кадр Ктулху 72x96: база гуманоида x3 + КРЫЛЬЯ и ЩУПАЛЬЦА лица."""
    W2, H2 = 72, 96
    base = Cv(W, H)
    gd.humanoid_frame(base, dir, p, CTHULHU_PAL, {"armor": True})
    up = base.img.resize((W2, H2), Image.NEAREST)
    for y in range(H2):
        for x in range(W2):
            r, g, b, a = up.getpixel((x, y))
            if a > 0:
                c.P(x, y, (r, g, b, a))
    bob = p.get("bob", 0) * 3
    stride = p.get("stride", 0)
    flap = (1 if (stride and f % 2) else 0) * 3
    sway = [0, 2, 4, 2, 0, -2][f % 6]
    # КРЫЛЬЯ: большие перепонки за спиной, машут при ходьбе
    if dir == "side":
        wx, wy = 4, 30 - flap
        for (pts_) in ([(wx, wy + 8), (wx - 2, wy + 18), (wx + 2, wy + 30)],
                       [(wx + 2, wy + 6), (wx, wy + 16), (wx + 4, wy + 28)]):
            gd._tentacle(c, [(pts_[0][0], pts_[0][1]), pts_[1], pts_[2]],
                         {"tent": pal["wing"], "tent_hi": pal["wing_hi"],
                          "tent_lo": shade(pal["wing"], -0.3),
                          "sucker": pal["wing_hi"]}, r0=7, r1=4)
    else:
        for side in (-1, 1):
            x0 = 36 + side * 22
            pts_w = [(x0, 32 - flap), (x0 + side * 9, 44 - flap),
                     (x0 + side * 13, 62 - flap)]
            gd._tentacle(c, pts_w,
                         {"tent": pal["wing"], "tent_hi": pal["wing_hi"],
                          "tent_lo": shade(pal["wing"], -0.3),
                          "sucker": pal["wing_hi"]}, r0=8, r1=4)
    # ЩУПАЛЬЦА ЛИЦА: борода из плоти (вниз — длинные, вбок — вбок)
    face_y = 24 + bob
    if dir == "down":
        gd._tentacle(c, [(30, face_y), (28, face_y + 12), (26, face_y + 22),
                         (28 + sway // 2, face_y + 30)], pal, r0=6, r1=3)
        gd._tentacle(c, [(42, face_y), (44, face_y + 12), (46, face_y + 22),
                         (44 - sway // 2, face_y + 30)], pal, r0=6, r1=3)
        gd._tentacle(c, [(36, face_y + 4), (36, face_y + 16 + sway // 2),
                         (35, face_y + 26)], pal, r0=5, r1=3)
        # глаза-угли
        for dx in (-8, 8):
            c.ellipse(36 + dx, face_y - 6, 3, 2, pal["eye"])
            c.P(36 + dx, face_y - 6, C(255, 200, 140))
    elif dir == "side":
        gd._tentacle(c, [(44, face_y + 2), (52, face_y + 8),
                         (60, face_y + 10 + sway // 2)], pal, r0=5, r1=3)
        gd._tentacle(c, [(42, face_y + 8), (50, face_y + 16),
                         (58, face_y + 20 - sway // 2)], pal, r0=4, r1=2)
        c.ellipse(48, face_y - 4, 2, 2, pal["eye"])
        c.P(48, face_y - 4, C(255, 200, 140))
    else:
        # сзади: крылья и затылок, пара щупалец выглядывает вбок
        gd._tentacle(c, [(26, face_y + 6), (18, face_y + 2 + sway)], pal,
                     r0=4, r1=2)
        gd._tentacle(c, [(46, face_y + 6), (54, face_y + 2 - sway)], pal,
                     r0=4, r1=2)
    # когти на руках
    for side in (-1, 1):
        ax = 36 + side * 18
        for i in range(3):
            c.P(ax + side * 2, 62 + i * 2 + bob // 2, pal["armor_hi"])
    # зелёное свечение вокруг
    for (dx, dy) in ((6, 10), (66, 14), (10, 84), (64, 80)):
        c.P(dx, dy, shade(pal["tent_hi"], 0.25))


def gen_boss_cthulhu():
    from PIL import Image
    sheet = Image.new("RGBA", (W * 3 * 6, H * 3 * 6), (0, 0, 0, 0))
    for r, (name, walking, dir, count) in enumerate(gd.SHEET_ROWS):
        for f in range(count):
            big = Cv(W * 3, H * 3)
            p = gd.pose(walking, f, dir)
            cthulhu_frame(big, dir, p, CTHULHU_PAL, f=f)
            big.outline()
            sheet.paste(big.img, (f * W * 3, r * H * 3), big.img)
    save(sheet, "sprites/dungeon/boss_cthulhu.png")
    return sheet


def gen_cthulhu_portrait():
    S = 64
    c = Cv(S, S)
    pal = CTHULHU_PAL
    c.R(0, 0, S - 1, S - 1, C(14, 26, 22))
    for (x, y) in ((8, 10), (52, 6), (14, 50), (48, 52), (30, 4), (58, 28),
                   (6, 32)):
        c.P(x, y, C(70, 130, 90))
    # плечи и грудь
    c.ellipse(32, 60, 24, 12, pal["body"])
    c.HLINE(61, 12, 52, shade(pal["body"], 0.2))
    # крылья по углам
    gd._tentacle(c, [(8, 34), (14, 44), (22, 54)], 
                 {"tent": pal["wing"], "tent_hi": pal["wing_hi"],
                  "tent_lo": shade(pal["wing"], -0.3), "sucker": pal["wing_hi"]},
                 r0=7, r1=4)
    gd._tentacle(c, [(56, 32), (50, 44), (42, 54)],
                 {"tent": pal["wing"], "tent_hi": pal["wing_hi"],
                  "tent_lo": shade(pal["wing"], -0.3), "sucker": pal["wing_hi"]},
                 r0=7, r1=4)
    # голова: высокая, сужается к макушке
    c.ellipse(32, 26, 15, 15, pal["skin"])
    c.R(26, 6, 38, 16, pal["skin"])
    c.ellipse(32, 24, 11, 11, shade(pal["skin"], 0.08))
    c.ellipse(32, 28, 9, 10, shade(pal["skin"], -0.12))
    # борода щупалец
    gd._tentacle(c, [(22, 34), (18, 44), (16, 54), (20, 60)], pal, r0=5, r1=3)
    gd._tentacle(c, [(42, 34), (46, 44), (48, 54), (44, 60)], pal, r0=5, r1=3)
    gd._tentacle(c, [(32, 38), (32, 48), (30, 58)], pal, r0=4, r1=3)
    # глаза-угли
    for dx in (-8, 8):
        c.ellipse(32 + dx, 22, 4, 3, pal["eye"])
        c.P(32 + dx, 22, C(255, 210, 150))
        c.P(32 + dx - 1, 23, shade(pal["eye"], -0.35))
    # зелёные искры
    for (x, y) in ((10, 18), (54, 16), (24, 8), (40, 10)):
        c.P(x, y, shade(pal["tent_hi"], 0.3))
    c.outline()
    save(c.img, "sprites/portraits/boss_cthulhu.png")
    return c.img


def gen_preview_3(sheets, boss_sheet, tiles):
    from PIL import ImageDraw
    scale = 3
    cols = 3
    ids = list(sheets.keys())
    rows = (len(ids) + cols - 1) // cols
    cell_w, cell_h = W * scale, H * scale
    pv = Image.new("RGBA", (cols * cell_w, rows * cell_h + cell_h + 40),
                   (22, 30, 28, 255))
    d = ImageDraw.Draw(pv)
    for i, foe_id in enumerate(ids):
        x = (i % cols) * cell_w
        y = (i // cols) * cell_h
        img = sheets[foe_id].crop((0, 0, W, H))
        img = img.resize((W * scale, H * scale), Image.NEAREST)
        pv.paste(img, (x + 4, y + 4), img)
        d.text((x + 6, y + 2), foe_id, fill=(200, 255, 190, 255))
    bx = cell_w
    img = boss_sheet.crop((0, 0, W * 3, H * 3))
    img = img.resize((W * scale, H * scale), Image.NEAREST)
    pv.paste(img, (bx + 4, rows * cell_h + 4), img)
    d.text((bx + 6, rows * cell_h + 6), "boss_cthulhu", fill=(255, 210, 140, 255))
    T = 16
    tx = bx + cell_w + 8
    ty = rows * cell_h + 8
    for i, (cx, cy) in enumerate([(0, 6), (2, 6), (4, 6), (5, 6), (6, 6),
                                  (0, 7), (2, 7), (4, 7), (2, 5)]):
        img = tiles.crop((cx * T, cy * T, (cx + 1) * T, (cy + 1) * T))
        img = img.resize((T * 3, T * 3), Image.NEAREST)
        pv.paste(img, (tx + (i % 3) * T * 3, ty + (i // 3) * (T * 3 + 6)), img)
    save(pv, "dungeon3_preview.png")


if __name__ == "__main__":
    print("Генерация арта данжа 3 «Глубины Р'льеха» (шаг 20):")
    tiles = gen_tiles()
    sheets = gen_foe_sheets_3()
    boss = gen_boss_cthulhu()
    gen_cthulhu_portrait()
    gen_preview_3(sheets, boss, tiles)
    print("Готово.")
