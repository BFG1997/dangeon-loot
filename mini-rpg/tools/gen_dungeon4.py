# -*- coding: utf-8 -*-
"""Шаг 24: арт данжа 4 «Логово Древних» (космический хоррор, щупальца).

Дорисовывает в атлас assets/tilesets/dungeon_tiles.png новые тайлы
(атлас расширяется с 8x8 до 8x10 — ряды 8 и 9) и создаёт листы врагов:
  Ночной гонт (night_gaunt), Лунный зверь (moon_beast), Жрец гулей
  (ghoul_priest), Древняя тварь (elder_thing), Абоминация щупалец
  (tentacle_abomination);
босс — Шуб-Ниггурат (boss_shub.png, кадры 96x128, как у Ктулху x4)
и портрет; щупальце из стены (tentacle_wall.png, 32x80); иконки ключей
данжей (key_skit/key_depths/key_ancients, 16x16) и портрет Королевы ночи.

Тайлы (атлас 8x10, 16 px):
  (0,8) стена рощи,  (5,8) стена звёздных чертогов, (1,9) стена сада,
  (5,9) стена чёрного алтаря;
  (2,8)/(3,8) полы рощи, (6,8)/(7,8) полы чертогов,
  (2,9)/(3,9) полы сада, (6,9)/(7,9) полы алтаря;
  (4,8) свечение рощи, (0,9) звёздное свечение, (4,9) споры сада,
  (7,5) свечения алтаря.

Запуск:  python3 tools/gen_dungeon4.py
"""
import math
import os
import sys

from PIL import Image

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from px import Cv, C, shade, save, INK  # noqa: E402
import gen_dungeon as gd  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ATLAS_PATH = os.path.join(ROOT, "assets", "tilesets", "dungeon_tiles.png")

W, H = 24, 32
BOSS_W, BOSS_H = 96, 128   # кадр x4 (как у Ктулху)


def brick(c, pal):
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
    atlas = Image.open(ATLAS_PATH).convert("RGBA")
    T = 16
    if atlas.size[1] < 160:
        grown = Image.new("RGBA", (atlas.size[0], 160), (0, 0, 0, 0))
        grown.paste(atlas, (0, 0))
        atlas = grown

    def put(tx, ty, painter):
        c = Cv(T, T)
        painter(c)
        atlas.paste(c.img, (tx * T, ty * T))

    # --- «Богохульная роща»: чёрный базальт с рунами Древних ---
    def wall_grove(c):
        brick(c, {"stone": C(26, 26, 34), "lo": C(17, 17, 24),
                  "hi": C(40, 40, 52)})
        # резные глаза без век смотрят из кладки
        for (x, y) in ((3, 3), (11, 9)):
            c.ellipse(x, y, 2, 1, C(120, 210, 120))
            c.P(x, y, C(190, 255, 170))
        c.VLINE(14, 0, 15, C(40, 60, 46))

    def floor_grove(c):
        floor_base(c, {"floor": C(34, 38, 44), "lo": C(26, 30, 36),
                       "hi": C(46, 50, 58)})
        # корни через плиты
        c.HLINE(9, 2, 13, C(44, 58, 44))
        c.P(6, 9, C(60, 80, 56))

    def floor_grove2(c):
        floor_base(c, {"floor": C(31, 35, 41), "lo": C(24, 27, 33),
                       "hi": C(43, 47, 55)})
        c.ellipse(11, 5, 2, 1, C(46, 62, 48))

    def glow_grove(c):
        c.R(0, 0, 15, 15, C(22, 24, 30))
        # знак Древних: спираль из трёх витков
        for t in range(40):
            ang = t / 40.0 * 3.0 * math.pi
            r = 1 + t * 0.14
            x = int(8 + math.cos(ang) * r)
            y = int(8 + math.sin(ang) * r)
            c.P(x, y, C(110, 220, 130) if t % 3 else C(170, 250, 170))

    # --- «Звёздные чертоги»: гранит с вмертвыми звёздами ---
    def wall_star(c):
        brick(c, {"stone": C(30, 32, 46), "lo": C(21, 22, 33),
                  "hi": C(44, 47, 64)})
        for (x, y) in ((2, 2), (6, 7), (12, 4), (9, 13), (13, 11)):
            c.P(x, y, C(200, 210, 255))
            c.P(x, y, C(230, 238, 255) if (x + y) % 2 else C(160, 170, 220))

    def floor_star(c):
        floor_base(c, {"floor": C(38, 40, 54), "lo": C(29, 31, 43),
                       "hi": C(50, 53, 68)})
        c.P(4, 11, C(150, 160, 220))
        c.P(11, 6, C(120, 130, 190))

    def floor_star2(c):
        floor_base(c, {"floor": C(35, 37, 50), "lo": C(27, 29, 40),
                       "hi": C(47, 50, 64)})
        c.ellipse(5, 8, 3, 2, C(30, 32, 46))
        c.P(5, 8, C(180, 190, 250))

    def glow_star(c):
        c.R(0, 0, 15, 15, C(24, 26, 38))
        # трещина в никуда: за ней звёзды
        c.HLINE(7, 2, 13, C(20, 22, 34))
        for (x, y) in ((3, 6), (6, 8), (9, 7), (12, 8), (7, 6)):
            c.P(x, y, C(210, 220, 255))
        c.P(6, 8, C(255, 255, 255))

    # --- «Сад Шуб-Ниггурат»: живая чёрная плоть с молочными спорами ---
    def wall_garden(c):
        brick(c, {"stone": C(38, 24, 34), "lo": C(26, 16, 24),
                  "hi": C(56, 38, 50)})
        # млечные наросты-споры в швах
        for (x, y) in ((4, 8), (9, 3), (12, 13), (2, 13)):
            c.ellipse(x, y, 1, 1, C(150, 190, 130))
            c.P(x, y, C(210, 240, 180))

    def floor_garden(c):
        floor_base(c, {"floor": C(42, 32, 40), "lo": C(33, 25, 32),
                       "hi": C(54, 42, 52)})
        # слизистая дорожка спор
        c.ellipse(8, 10, 3, 2, C(70, 90, 60))
        c.P(8, 10, C(130, 170, 110))

    def floor_garden2(c):
        floor_base(c, {"floor": C(38, 29, 37), "lo": C(30, 23, 30),
                       "hi": C(50, 39, 49)})
        for (x, y) in ((3, 5), (12, 12)):
            c.P(x, y, C(160, 200, 130))

    def glow_garden(c):
        c.R(0, 0, 15, 15, C(34, 22, 30))
        # лунка споры, сочащаяся светом
        c.ellipse(8, 8, 5, 4, C(90, 120, 70))
        c.ellipse(8, 8, 3, 2, C(140, 190, 110))
        c.ellipse(8, 8, 1, 1, C(220, 250, 180))
        for (x, y) in ((3, 4), (13, 10)):
            c.P(x, y, C(120, 160, 100))

    # --- «Чёрный алтарь»: кости и чёрный мрамор ---
    def wall_altar(c):
        brick(c, {"stone": C(20, 18, 24), "lo": C(13, 12, 17),
                  "hi": C(34, 31, 42)})
        # вмурованные кости в кладке
        c.R(4, 6, 11, 7, C(120, 112, 96))
        for x in range(5, 11, 2):
            c.VLINE(x, 6, 7, C(80, 74, 64))
        c.P(13, 12, C(140, 130, 110))

    def floor_altar(c):
        floor_base(c, {"floor": C(30, 28, 36), "lo": C(23, 21, 28),
                       "hi": C(42, 39, 50)})
        c.HLINE(12, 4, 11, C(50, 46, 60))

    def floor_altar2(c):
        floor_base(c, {"floor": C(27, 25, 33), "lo": C(21, 19, 26),
                       "hi": C(39, 36, 48)})
        c.ellipse(9, 4, 2, 1, C(46, 44, 58))

    def glow_altar(c):
        c.R(0, 0, 15, 15, C(16, 14, 22))
        # чёрное пламя алтаря: холодный огонь
        c.VLINE(8, 3, 12, C(150, 140, 230))
        c.VLINE(7, 5, 12, C(110, 100, 190))
        c.VLINE(9, 5, 12, C(110, 100, 190))
        c.P(8, 3, C(220, 210, 255))
        c.P(8, 13, C(60, 55, 100))

    put(0, 8, wall_grove); put(5, 8, wall_star)
    put(1, 9, wall_garden); put(5, 9, wall_altar)
    put(2, 8, floor_grove); put(3, 8, floor_grove2)
    put(6, 8, floor_star); put(7, 8, floor_star2)
    put(2, 9, floor_garden); put(3, 9, floor_garden2)
    put(6, 9, floor_altar); put(7, 9, floor_altar2)
    put(4, 8, glow_grove); put(0, 9, glow_star)
    put(4, 9, glow_garden); put(7, 5, glow_altar)
    atlas.save(ATLAS_PATH)
    print("  -> tilesets/dungeon_tiles.png: атлас 8x10, +14 тайлов Древних")
    return atlas


# ------------------------------------------------------------- чудовища

GAUNT_PAL = {
    "skin": C(64, 62, 78), "body": C(30, 28, 44), "rag": C(24, 22, 36),
    "limb": C(36, 34, 52), "leg": C(28, 26, 42), "boot": C(20, 18, 32),
    "armor": C(44, 42, 62), "armor_hi": C(70, 68, 94),
    "hood_dark": C(10, 9, 18), "eye": C(120, 240, 230),
    "wing": C(38, 36, 56), "wing_hi": C(58, 56, 82),
    "horn": C(0, 0, 0),
}
MOON_BEAST_PAL = {
    "skin": C(196, 192, 178), "body": C(150, 146, 136),
    "rag": C(120, 116, 108), "limb": C(160, 156, 146),
    "leg": C(140, 136, 126), "boot": C(108, 104, 96),
    "armor": C(172, 168, 156), "armor_hi": C(214, 210, 196),
    "hood_dark": C(40, 38, 36), "eye": C(250, 120, 90),
    "horn": C(0, 0, 0),
}
GHOUL_PAL = {
    "skin": C(120, 128, 96), "body": C(58, 62, 44), "rag": C(46, 50, 36),
    "limb": C(66, 70, 52), "leg": C(58, 62, 46), "boot": C(44, 48, 36),
    "armor": C(80, 86, 62), "armor_hi": C(120, 128, 90),
    "hood_dark": C(18, 22, 14), "eye": C(230, 240, 140),
    "staff": C(60, 52, 44), "orb": C(170, 210, 120), "orb_hi": C(230, 250, 170),
    "tent": C(110, 130, 80), "tent_hi": C(146, 168, 104),
    "tent_lo": C(84, 100, 60), "sucker": C(200, 220, 150),
    "horn": C(0, 0, 0),
}
ELDER_PAL = {
    "skin": C(140, 120, 100), "body": C(96, 78, 66), "rag": C(80, 64, 54),
    "limb": C(108, 90, 78), "leg": C(96, 80, 68), "boot": C(72, 60, 52),
    "armor": C(120, 100, 84), "armor_hi": C(160, 136, 114),
    "hood_dark": C(30, 24, 20), "eye": C(120, 230, 200),
    "tent": C(130, 108, 88), "tent_hi": C(164, 140, 116),
    "tent_lo": C(98, 80, 66), "sucker": C(220, 200, 170),
    "horn": C(0, 0, 0),
}
ABOMINATION_PAL = {
    "mass": C(84, 44, 72), "mass_hi": C(120, 66, 102),
    "mass_lo": C(60, 32, 54), "eye": C(240, 210, 90),
    "tent": C(104, 56, 88), "tent_hi": C(140, 80, 118),
    "tent_lo": C(76, 40, 64), "sucker": C(210, 170, 200),
}
SHUB_PAL = {
    "skin": C(70, 92, 56), "body": C(52, 72, 44), "rag": C(42, 58, 36),
    "limb": C(58, 80, 48), "leg": C(50, 68, 42), "boot": C(38, 52, 34),
    "mass": C(56, 74, 46), "mass_hi": C(88, 116, 70),
    "mass_lo": C(40, 54, 34), "hood_dark": C(10, 18, 12), "eye": C(230, 240, 140),
    "tent": C(64, 90, 50), "tent_hi": C(96, 130, 74),
    "tent_lo": C(48, 66, 38), "sucker": C(180, 220, 140),
    "spore": C(200, 235, 160), "horn": C(0, 0, 0),
}

def gaunt_frame(c, dir, p, pal):
    """Ночной гонт: чёрное бескрылое НИТО — лицо без глаз, крылья ластами."""
    gd.humanoid_frame(c, dir, p, pal, {"armor": True})
    bob = p.get("bob", 0)
    stride = p.get("stride", 0)
    cx, top = 12, 6 + bob
    flap = (2 if (stride and p.get("f", 0) % 2) else 0)
    # крылья-ласты за спиной
    if dir == "side":
        gd._tentacle(c, [(cx - 4, top + 10), (cx - 9, top + 6 - flap),
                         (cx - 12, top + 2)],
                     {"tent": pal["wing"], "tent_hi": pal["wing_hi"],
                      "tent_lo": shade(pal["wing"], -0.3), "sucker": pal["wing_hi"]},
                     r0=3, r1=1)
    else:
        for side in (-1, 1):
            gd._tentacle(c, [(cx + side * 5, top + 10),
                             (cx + side * 9, top + 6 - flap * side * side),
                             (cx + side * 12, top + 3)],
                         {"tent": pal["wing"], "tent_hi": pal["wing_hi"],
                          "tent_lo": shade(pal["wing"], -0.3),
                          "sucker": pal["wing_hi"]}, r0=3, r1=1)
    # ЛИЦА НЕТ: гладкая чёрная голова (глаза ссаживаем)
    hy = top
    c.R(cx - 4, hy, cx + 4, hy + 8, pal["body"])
    c.VLINE(cx + 3, hy + 1, hy + 7, shade(pal["body"], -0.25))
    if dir == "down":
        # узкая щель-рот
        c.HLINE(hy + 6, cx - 2, cx + 2, shade(pal["body"], -0.4))
    # роговые шипы на плечах
    for side in (-1, 1):
        c.R(cx + side * 6, top + 9, cx + side * 7, top + 11, pal["wing_hi"])


def moon_beast_frame(c, dir, p, pal):
    """Лунный зверь: жабочеловек — светлая шкура, широкая пасть, лапы."""
    gd.humanoid_frame(c, dir, p, pal, {})
    bob = p.get("bob", 0)
    cx, top = 12, 6 + bob
    # широкая жабья голова и пасть
    c.ellipse(cx, top + 4, 6, 5, pal["skin"])
    c.VLINE(cx + 4, top + 1, top + 7, shade(pal["skin"], -0.2))
    if dir == "down":
        c.HLINE(top + 6, cx - 4, cx + 4, shade(pal["skin"], -0.45))
        for dx in (-3, 0, 3):
            c.P(cx + dx, top + 6, shade(pal["skin"], -0.6))
        c.P(cx - 2, top + 2, pal["eye"])
        c.P(cx + 2, top + 2, pal["eye"])
        # бугры-глаза над головой
        c.ellipse(cx - 2, top, 1, 1, shade(pal["skin"], 0.15))
        c.ellipse(cx + 2, top, 1, 1, shade(pal["skin"], 0.15))
    elif dir == "side":
        c.HLINE(top + 6, cx + 1, cx + 4, shade(pal["skin"], -0.45))
        c.P(cx + 3, top + 2, pal["eye"])
    # перепонки между пальцев
    c.R(cx - 5, 28, cx - 3, 29, shade(pal["boot"], 0.1))
    c.R(cx + 3, 28, cx + 5, 29, shade(pal["boot"], 0.1))
    # шкура: светлые пятна
    for (dx, dy) in ((-3, 13), (2, 15), (-1, 18), (3, 20)):
        c.P(cx + dx, top + dy, shade(pal["body"], 0.14))


def ghoul_frame(c, dir, p, pal):
    """Жрец гулей: мантия, череп-капюшон, щупальца-чётки, посох спор."""
    gd.humanoid_frame(c, dir, p, pal, {"robe": True, "hood": True,
                                       "staff": True})
    bob = p.get("bob", 0)
    cx, top = 12, 6 + bob
    sway = [0, 1, 1, 0, -1, -1][p.get("f", 0) % 6] if not p.get("stride") \
        else [1, 0, -1, 0][p.get("f", 0) % 4]
    # щупальца-чётки свисают из рукавов
    if dir != "up":
        gd._tentacle(c, [(cx - 6, top + 14), (cx - 7, top + 18 + sway),
                         (cx - 6, top + 22)], pal, r0=1, r1=1)
        gd._tentacle(c, [(cx + 6, top + 14), (cx + 7, top + 18 - sway),
                         (cx + 6, top + 22)], pal, r0=1, r1=1)
    # молочные споры на подоле
    for (dx, dy) in ((-3, 27), (0, 29), (3, 26)):
        c.P(cx + dx, dy, pal.get("orb_hi", C(230, 250, 170)))


def elder_thing_frame(c, dir, p, pal):
    """Древняя тварь: бочка-тело с веером щупалец и тремя глазами."""
    f = p.get("f", 0) % 6
    breathe = (1, 2, 3, 2, 1, 0)[f if not p.get("stride") else (f % 4)]
    cx = 12
    # бочка на множестве ножек-щупалец
    c.R(cx - 6, 12 - breathe, cx + 6, 26 + breathe, pal["body"])
    c.VLINE(cx - 6, 13, 25, shade(pal["body"], -0.25))
    c.VLINE(cx + 5, 13, 25, shade(pal["body"], 0.1))
    c.HLINE(12 - breathe, cx - 5, cx + 5, shade(pal["body"], 0.12))
    c.HLINE(26 + breathe, cx - 5, cx + 5, shade(pal["body"], -0.3))
    # ножки: пучок щупалец внизу
    for side in (-3, -1, 1, 3):
        gd._tentacle(c, [(cx + side, 26), (cx + side * 2, 30)], pal,
                     r0=2, r1=1)
    # веер щупалец сверху (направление взгляда)
    top = 8
    if dir == "down":
        gd._tentacle(c, [(cx - 4, top), (cx - 7, top + 6)], pal, r0=2, r1=1)
        gd._tentacle(c, [(cx + 4, top), (cx + 7, top + 6)], pal, r0=2, r1=1)
        gd._tentacle(c, [(cx, top - 1), (cx, top + 7)], pal, r0=2, r1=1)
        for dx in (-2, 0, 2):
            c.P(cx + dx, top + 3, pal["eye"])
    elif dir == "side":
        gd._tentacle(c, [(cx + 5, top + 1), (cx + 9, top + 4)], pal, r0=2, r1=1)
        gd._tentacle(c, [(cx + 5, top + 4), (cx + 8, top + 8)], pal, r0=2, r1=1)
        c.P(cx + 4, top + 3, pal["eye"])
    else:
        gd._tentacle(c, [(cx - 4, top), (cx - 7, top - 4)], pal, r0=2, r1=1)
        gd._tentacle(c, [(cx + 4, top), (cx + 7, top - 4)], pal, r0=2, r1=1)
    # крышечки-споры на боку
    for (dx, dy) in ((-4, 16), (3, 20)):
        c.ellipse(cx + dx, dy, 1, 1, shade(pal["armor_hi"], 0.1))


def abomination_frame(c, dir, p, pal):
    """Абоминация щупалец: гора плоти на щупальцах, глаза повсюду."""
    f = p.get("f", 0) % 6
    breathe = (1, 2, 3, 2, 1, 0)[f if not p.get("stride") else (f % 4)]
    cx = 12
    sway = [0, 2, 3, 2, 0, -2][f % 6] if not p.get("stride") else [2, 0, -2, 0][f % 4]
    # гора плоти
    c.ellipse(cx, 18 - breathe, 8, 8 + breathe, pal["mass"])
    c.ellipse(cx - 2, 14, 4, 4, shade(pal["mass"], 0.08))
    c.ellipse(cx + 3, 20, 3, 3, shade(pal["mass"], -0.1))
    # ноги-щупальца
    for side in (-5, -2, 2, 5):
        gd._tentacle(c, [(cx + side, 24), (cx + side * 2, 30 - abs(sway))],
                     pal, r0=3, r1=1)
    # пучок щупалец с макушки (направление)
    top = 8
    if dir == "down":
        gd._tentacle(c, [(cx - 5, top), (cx - 8, top + 5 + sway)], pal, r0=3, r1=1)
        gd._tentacle(c, [(cx + 5, top), (cx + 8, top + 5 - sway)], pal, r0=3, r1=1)
        gd._tentacle(c, [(cx, top - 2), (cx + 1, top + 6)], pal, r0=3, r1=2)
        gd._tentacle(c, [(cx + 2, top), (cx + 4, top + 7 - sway)], pal, r0=2, r1=1)
        c.P(cx - 2, top + 3, pal["eye"])
        c.P(cx + 2, top + 3, pal["eye"])
    elif dir == "side":
        gd._tentacle(c, [(cx + 6, top + 1), (cx + 10, top + 4 + sway)], pal,
                     r0=3, r1=1)
        gd._tentacle(c, [(cx + 5, top + 5), (cx + 9, top + 9)], pal, r0=2, r1=1)
        c.P(cx + 5, top + 3, pal["eye"])
    else:
        gd._tentacle(c, [(cx - 4, top), (cx - 8, top - 3 + sway)], pal, r0=3, r1=1)
        gd._tentacle(c, [(cx + 4, top), (cx + 8, top - 3 - sway)], pal, r0=3, r1=1)
        gd._tentacle(c, [(cx, top - 2), (cx, top - 7)], pal, r0=2, r1=1)
    # глаза на теле
    for (dx, dy) in ((-4, 16), (3, 22), (-1, 20)):
        c.ellipse(cx + dx, dy, 1, 1, pal["eye"])
        c.P(cx + dx, dy, C(255, 245, 190))


def shub_frame(c, dir, p, pal, f=0):
    """Кадр Шуб-Ниггурат 96x128: ЧЁРНАЯ КОЗА БЕЗДНЫ с тысячей щупалец."""
    base = Cv(W, H)
    gd.humanoid_frame(base, dir, p, SHUB_PAL, {"robe": True})
    up = base.img.resize((BOSS_W, BOSS_H), Image.NEAREST)
    for y in range(BOSS_H):
        for x in range(BOSS_W):
            r, g, b, a = up.getpixel((x, y))
            if a > 0:
                c.P(x, y, (r, g, b, a))
    bob = p.get("bob", 0) * 3
    stride = p.get("stride", 0)
    sway = [0, 3, 6, 3, 0, -3][f % 6]
    face_y = 34 + bob
    cx = 48
    # ГИГАНТСКАЯ МАССА ТЕЛА: рогатый силуэт козы
    c.ellipse(cx, 64 + bob, 30, 26, pal["mass"])
    c.ellipse(cx - 10, 52 + bob, 14, 12, shade(pal["mass"], 0.06))
    c.ellipse(cx + 10, 52 + bob, 14, 12, shade(pal["mass"], 0.06))
    # вымя-споры на брюхе
    c.ellipse(cx, 88 + bob, 12, 8, shade(pal["mass_lo"], 0.0))
    for (dx, dy) in ((-8, 84), (8, 84), (0, 94)):
        c.ellipse(cx + dx, dy + bob, 2, 2, pal["spore"])
        c.P(cx + dx, dy - 1 + bob, shade(pal["spore"], 0.2))
    # РОГА: чёрные спирали вверх
    if dir != "up":
        for side in (-1, 1):
            bx = cx + side * 16
            gd._tentacle(c, [(bx, face_y - 2), (bx + side * 8, face_y - 16),
                             (bx + side * 4, face_y - 30)],
                         {"tent": C(24, 20, 30), "tent_hi": C(40, 34, 52),
                          "tent_lo": C(14, 12, 20), "sucker": C(70, 60, 90)},
                         r0=5, r1=2)
    # ЛИЦО-КОЗА: борода щупалец и три глаза
    if dir == "down":
        gd._tentacle(c, [(cx - 8, face_y + 4), (cx - 12, face_y + 18),
                         (cx - 10 + sway // 2, face_y + 30)], pal, r0=6, r1=3)
        gd._tentacle(c, [(cx + 8, face_y + 4), (cx + 12, face_y + 18),
                         (cx + 10 - sway // 2, face_y + 30)], pal, r0=6, r1=3)
        gd._tentacle(c, [(cx, face_y + 6), (cx, face_y + 20 + sway // 2),
                         (cx - 1, face_y + 32)], pal, r0=5, r1=3)
        gd._tentacle(c, [(cx - 4, face_y + 2), (cx - 6, face_y + 14)], pal,
                     r0=4, r1=2)
        gd._tentacle(c, [(cx + 4, face_y + 2), (cx + 6, face_y + 14)], pal,
                     r0=4, r1=2)
        for dx in (-7, 7):
            c.ellipse(cx + dx, face_y - 8, 4, 3, pal["eye"])
            c.P(cx + dx, face_y - 8, C(255, 250, 200))
        c.ellipse(cx, face_y - 4, 3, 3, pal["eye"])   # третий глаз
        c.P(cx, face_y - 4, C(255, 250, 200))
    elif dir == "side":
        gd._tentacle(c, [(cx + 10, face_y + 4), (cx + 20, face_y + 12),
                         (cx + 26, face_y + 16 + sway // 2)], pal, r0=5, r1=3)
        gd._tentacle(c, [(cx + 8, face_y + 10), (cx + 18, face_y + 20)], pal,
                     r0=4, r1=2)
        c.ellipse(cx + 12, face_y - 6, 3, 3, pal["eye"])
        c.P(cx + 12, face_y - 6, C(255, 250, 200))
    else:
        gd._tentacle(c, [(cx - 12, face_y + 8), (cx - 20, face_y + 2 + sway)], pal,
                     r0=4, r1=2)
        gd._tentacle(c, [(cx + 12, face_y + 8), (cx + 20, face_y + 2 - sway)], pal,
                     r0=4, r1=2)
    # ЩУПАЛЬЦА ВОКРУГ ТЕЛА (всегда)
    for side in (-1, 1):
        gd._tentacle(c, [(cx + side * 26, 60 + bob),
                         (cx + side * 34, 68 + sway // 2),
                         (cx + side * 30, 80)], pal, r0=6, r1=3)
        gd._tentacle(c, [(cx + side * 22, 76 + bob),
                         (cx + side * 30, 84 - sway // 2),
                         (cx + side * 26, 94)], pal, r0=5, r1=2)
    # ноги-щупальца вместо копыт
    for side in (-12, 12):
        gd._tentacle(c, [(cx + side, 92 + bob), (cx + side * 2, 108),
                         (cx + side * 2, 120 + (2 if stride else 0))], pal,
                     r0=6, r1=4)
    # молочные споры вокруг
    for (dx, dy) in ((10, 20), (80, 30), (14, 100), (78, 92), (48, 10)):
        c.P(dx, dy + bob // 2, pal["spore"])


def gen_tentacle_wall():
    """Щупальце из стены: вертикальный ствол 32x80 с присосками и жалом."""
    c = Cv(32, 80)
    pal = {
        "tent": C(52, 96, 62), "tent_hi": C(78, 140, 88),
        "tent_lo": C(38, 70, 46), "sucker": C(160, 220, 150),
    }
    # изогнутый ствол снизу вверх (плотная цепь кругов — без разрывов)
    trunk = []
    for i in range(16):
        t = i / 15.0
        x = 16 + math.sin(t * 2.4) * 4.0 * (1.0 - t * 0.3)
        y = 78 - t * 72.0
        trunk.append((int(round(x)), int(round(y))))
    gd._tentacle(c, trunk, pal, r0=10, r1=3)
    # жало-коготь на конце
    c.R(13, 1, 19, 6, C(220, 245, 210))
    c.P(16, 0, C(255, 255, 240))
    c.P(15, 2, C(180, 220, 180))
    # отростки вбок (плотные)
    side1 = [(15, 40), (12, 42), (8, 45), (5, 48), (3, 52)]
    side2 = [(18, 52), (21, 56), (25, 60), (28, 64), (29, 67)]
    gd._tentacle(c, side1, pal, r0=5, r1=2)
    gd._tentacle(c, side2, pal, r0=5, r1=2)
    c.outline()
    save(c.img, "sprites/dungeon/tentacle_wall.png")
    return c.img


def gen_foe_sheets_4():
    sheets = {}
    factories = {
        "night_gaunt": gaunt_frame,
        "moon_beast": moon_beast_frame,
        "ghoul_priest": ghoul_frame,
        "elder_thing": elder_thing_frame,
        "tentacle_abomination": abomination_frame,
    }
    pals = {
        "night_gaunt": GAUNT_PAL, "moon_beast": MOON_BEAST_PAL,
        "ghoul_priest": GHOUL_PAL, "elder_thing": ELDER_PAL,
        "tentacle_abomination": ABOMINATION_PAL,
    }
    for foe_id, factory in factories.items():
        pal = pals[foe_id]
        sheet = Image.new("RGBA", (W * 6, H * 6), (0, 0, 0, 0))
        for r, (name, walking, dir, count) in enumerate(gd.SHEET_ROWS):
            for f in range(count):
                c = Cv(W, H)
                p = gd.pose(walking, f, dir)
                p["f"] = f
                factory(c, dir, p, pal)
                c.outline()
                sheet.paste(c.img, (f * W, r * H), c.img)
        save(sheet, "sprites/dungeon/%s.png" % foe_id)
        sheets[foe_id] = sheet
    return sheets


def gen_boss_shub():
    sheet = Image.new("RGBA", (BOSS_W * 6, BOSS_H * 6), (0, 0, 0, 0))
    for r, (name, walking, dir, count) in enumerate(gd.SHEET_ROWS):
        for f in range(count):
            big = Cv(BOSS_W, BOSS_H)
            p = gd.pose(walking, f, dir)
            shub_frame(big, dir, p, SHUB_PAL, f=f)
            big.outline()
            sheet.paste(big.img, (f * BOSS_W, r * BOSS_H), big.img)
    save(sheet, "sprites/dungeon/boss_shub.png")
    return sheet


def gen_shub_portrait():
    S = 64
    c = Cv(S, S)
    pal = SHUB_PAL
    c.R(0, 0, S - 1, S - 1, C(12, 18, 12))
    for (x, y) in ((8, 10), (54, 8), (12, 52), (50, 54), (30, 4), (58, 30),
                   (5, 34)):
        c.P(x, y, pal["spore"])
    # масса тела
    c.ellipse(32, 46, 26, 18, pal["mass"])
    c.ellipse(20, 36, 12, 10, shade(pal["mass"], 0.06))
    c.ellipse(44, 36, 12, 10, shade(pal["mass"], 0.06))
    # щупальца по бокам
    gd._tentacle(c, [(8, 34), (14, 46), (20, 56)], pal, r0=7, r1=4)
    gd._tentacle(c, [(56, 34), (50, 46), (44, 56)], pal, r0=7, r1=4)
    # козья морда: длинное лицо вниз
    c.ellipse(32, 22, 12, 10, shade(pal["mass"], 0.1))
    c.R(26, 22, 38, 34, shade(pal["mass"], 0.1))
    c.ellipse(32, 34, 6, 6, shade(pal["mass_lo"], 0.05))
    # борода щупалец
    gd._tentacle(c, [(26, 36), (22, 46), (20, 56)], pal, r0=4, r1=2)
    gd._tentacle(c, [(38, 36), (42, 46), (44, 56)], pal, r0=4, r1=2)
    gd._tentacle(c, [(32, 40), (32, 52)], pal, r0=4, r1=3)
    # чёрные рога
    gd._tentacle(c, [(22, 16), (16, 8), (20, 2)],
                 {"tent": C(24, 20, 30), "tent_hi": C(40, 34, 52),
                  "tent_lo": C(14, 12, 20), "sucker": C(70, 60, 90)}, r0=4, r1=2)
    gd._tentacle(c, [(42, 16), (48, 8), (44, 2)],
                 {"tent": C(24, 20, 30), "tent_hi": C(40, 34, 52),
                  "tent_lo": C(14, 12, 20), "sucker": C(70, 60, 90)}, r0=4, r1=2)
    # три глаза
    for dx in (-6, 6):
        c.ellipse(32 + dx, 20, 3, 3, pal["eye"])
        c.P(32 + dx, 20, C(255, 250, 210))
    c.ellipse(32, 26, 2, 2, pal["eye"])
    c.P(32, 26, C(255, 250, 210))
    c.outline()
    save(c.img, "sprites/portraits/boss_shub.png")
    return c.img


def gen_queen_portrait():
    """Портрет Королевы ночи: Лира, принявшая Пустоту."""
    S = 64
    c = Cv(S, S)
    c.R(0, 0, S - 1, S - 1, C(10, 8, 18))
    for (x, y) in ((6, 8), (56, 12), (10, 50), (52, 52), (30, 3)):
        c.P(x, y, C(90, 70, 140))
    # плечи и платье из тьмы
    c.ellipse(32, 60, 24, 14, C(24, 18, 40))
    c.HLINE(61, 10, 54, C(40, 30, 62))
    # звёзды на платье
    for (x, y) in ((16, 56), (30, 60), (44, 56), (22, 62)):
        c.P(x, y, C(200, 190, 255))
    # бледное лицо
    c.ellipse(32, 26, 13, 14, C(222, 214, 224))
    c.VLINE(43, 14, 36, C(180, 172, 186))
    # ЧЁРНАЯ КОРОНА с шипами
    c.R(20, 6, 44, 12, C(16, 12, 26))
    for x in (22, 28, 36, 42):
        c.R(x - 1, 2, x + 1, 8, C(16, 12, 26))
        c.P(x, 1, C(120, 100, 200))
    c.HLINE(12, 20, 44, C(120, 100, 200))
    # волосы-тени по бокам
    gd._tentacle(c, [(20, 24), (14, 38), (12, 52)],
                 {"tent": C(20, 14, 34), "tent_hi": C(34, 26, 54),
                  "tent_lo": C(12, 8, 24), "sucker": C(60, 50, 90)}, r0=5, r1=3)
    gd._tentacle(c, [(44, 24), (50, 38), (52, 52)],
                 {"tent": C(20, 14, 34), "tent_hi": C(34, 26, 54),
                  "tent_lo": C(12, 8, 24), "sucker": C(60, 50, 90)}, r0=5, r1=3)
    # глаза-звёзды и улыбка
    for dx in (-5, 5):
        c.ellipse(32 + dx, 24, 2, 2, C(140, 230, 240))
        c.P(32 + dx, 24, C(230, 250, 255))
    c.HLINE(31, 28, 37, C(120, 60, 90))
    c.P(29, 32, C(120, 60, 90))
    c.P(36, 32, C(120, 60, 90))
    c.outline()
    save(c.img, "sprites/portraits/queen_night.png")
    return c.img


def gen_key_icons():
    """Иконки ключей данжей 16x16: кость с двойной бородкой, свой цвет."""
    palettes = {
        "key_skit": C(150, 120, 210),      # фиолетовый — Скит Пустоты
        "key_depths": C(70, 180, 130),     # зелёный — Глубины Р'льеха
        "key_ancients": C(110, 200, 110),  # ядовитый — Логово Древних
    }
    for key_id, col in palettes.items():
        c = Cv(16, 16)
        metal = shade(col, -0.2)
        hi = shade(col, 0.25)
        # кольцо головки
        c.ellipse(5, 5, 4, 4, metal)
        c.ellipse(5, 5, 2, 2, C(0, 0, 0, 0))
        for (x, y) in ((2, 2), (8, 2), (2, 8), (8, 8)):
            c.P(x, y, metal)
        c.P(5, 2, hi)
        # стержень и бородки
        c.R(8, 7, 14, 8, metal)
        c.HLINE(7, 8, 14, hi)
        c.R(11, 8, 12, 12, metal)
        c.R(14, 8, 15, 11, metal)
        c.P(12, 12, hi)
        # руна Древних на головке
        c.P(5, 5, C(255, 255, 230))
        c.P(4, 6, col)
        c.P(6, 6, col)
        c.outline()
        save(c.img, "sprites/icons/%s.png" % key_id)


def gen_preview_4(sheets, boss_sheet, tiles, tentacle):
    from PIL import ImageDraw
    scale = 3
    cols = 3
    ids = list(sheets.keys())
    rows = (len(ids) + cols - 1) // cols
    cell_w, cell_h = W * scale, H * scale
    pv = Image.new("RGBA", (cols * cell_w + 240,
                            rows * cell_h + cell_h + 120), (18, 24, 22, 255))
    d = ImageDraw.Draw(pv)
    for i, foe_id in enumerate(ids):
        x = (i % cols) * cell_w
        y = (i // cols) * cell_h
        img = sheets[foe_id].crop((0, 0, W, H))
        img = img.resize((W * scale, H * scale), Image.NEAREST)
        pv.paste(img, (x + 4, y + 4), img)
        d.text((x + 6, y + 2), foe_id, fill=(200, 255, 190, 255))
    bx = 8
    by = rows * cell_h
    img = boss_sheet.crop((0, 0, BOSS_W, BOSS_H))
    img = img.resize((BOSS_W * scale, BOSS_H * scale), Image.NEAREST)
    pv.paste(img, (bx + 4, by + 4), img)
    d.text((bx + 6, by + 6), "boss_shub", fill=(255, 210, 140, 255))
    tx = 8 + BOSS_W * scale + 24
    img = tentacle.resize((32 * scale, 80 * scale), Image.NEAREST)
    pv.paste(img, (tx, by + 4), img)
    d.text((tx + 2, by + 6), "tentacle_wall", fill=(200, 255, 190, 255))
    T = 16
    ty = by + 8
    for i, (cx, cy) in enumerate([(0, 8), (2, 8), (4, 8), (5, 8),
                                  (0, 9), (2, 9), (4, 9), (7, 5)]):
        img2 = tiles.crop((cx * T, cy * T, (cx + 1) * T, (cy + 1) * T))
        img2 = img2.resize((T * 3, T * 3), Image.NEAREST)
        pv.paste(img2, (tx + 140 + (i % 2) * T * 3,
                        ty + 100 + (i // 2) * (T * 3 + 6)), img2)
    save(pv, "dungeon4_preview.png")


if __name__ == "__main__":
    print("Генерация арта данжа 4 «Логово Древних» (шаг 24):")
    tiles = gen_tiles()
    sheets = gen_foe_sheets_4()
    boss = gen_boss_shub()
    gen_shub_portrait()
    gen_queen_portrait()
    gen_key_icons()
    tent = gen_tentacle_wall()
    gen_preview_4(sheets, boss, tiles, tent)
    print("Готово.")
