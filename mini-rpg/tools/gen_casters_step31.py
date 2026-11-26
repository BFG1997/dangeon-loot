# -*- coding: utf-8 -*-
"""Шаг 31: спрайты новых героев — Демонолог и Некромант — и Суккуба.

Листы 24x32 (6 рядов: idle_down/side/up по 6, walk_down/side/up по 4) —
тот же формат, что у остальных персонажей и врагов. Переиспользует
помощники gen_chars (голова, мантия, оружие) и px (холст, обводка).
Портреты 64x64 для диалогов — через помощники gen_portraits.

Запуск:  python3 tools/gen_casters_step31.py
Результат:
  assets/sprites/chars/demonologist.png   (24x32 лист)
  assets/sprites/chars/necromancer.png    (24x32 лист)
  assets/sprites/dungeon/succubus.png     (24x32 лист врага — призыв)
  assets/sprites/portraits/demonologist.png / necromancer.png (64x64)
"""
import os
import sys

TOOLS = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, TOOLS)
sys.path.insert(0, "/home/z/my-project/game/mini-rpg/tools")

from px import Cv, C, shade  # noqa: E402
import gen_chars as gc  # noqa: E402
import gen_portraits as gp  # noqa: E402

GAME = os.path.dirname(TOOLS)
OUT_CHARS = os.path.join(GAME, "assets", "sprites", "chars")
OUT_DUNGEON = os.path.join(GAME, "assets", "sprites", "dungeon")
OUT_PORTRAITS = os.path.join(GAME, "assets", "sprites", "portraits")

W, H = gc.W, gc.H
ROWS = gc.ROWS


def save(img, path):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    img.save(path)
    print("  ->", os.path.relpath(path, GAME), img.size)


# ---------------------------------------------------------------- палитры
BONE = C(216, 202, 176)
BONE_D = C(172, 156, 134)
DEMON_ROBE = C(96, 38, 62)
DEMON_TRIM = C(196, 148, 76)
DEMON_EYE = C(255, 166, 74)
DEMON_ORB = C(230, 92, 130)

NECRO_ROBE = C(56, 74, 60)
NECRO_TRIM = C(146, 146, 104)
NECRO_EYE = C(118, 226, 132)
NECRO_ORB = C(216, 214, 196)

SUCC_ROBE = C(142, 34, 52)
SUCC_TRIM = C(226, 158, 130)
SUCC_SKIN = C(232, 168, 150)
SUCC_SKIN_SH = C(198, 130, 116)
SUCC_EYE = C(255, 120, 130)
WING_C = C(74, 36, 88)
WING_HI = C(108, 56, 124)
HORN_C = C(206, 186, 158)


def draw_horns(c, dir, hy, color=BONE, dark=BONE_D):
    """Небольшие рога по бокам макушки (видны со всех сторон)."""
    if dir == "up":
        return   # сзади рога не видны за головой
    if dir == "side":
        c.R(9, 1 + hy, 10, 3 + hy, dark)
        c.P(9, hy, color)
        c.P(10, 3 + hy, color)
        return
    c.R(5, 2 + hy, 6, 4 + hy, color)          # левый рог
    c.P(5, 1 + hy, color)
    c.P(6, 4 + hy, dark)
    c.R(17, 2 + hy, 18, 4 + hy, color)        # правый рог
    c.P(18, 1 + hy, color)
    c.P(17, 4 + hy, dark)


def draw_dark_staff(c, ty, orb, orb_hi, wood=C(70, 48, 44)):
    """Посох с тёмной рукоятью и светящимся навершием (справа)."""
    c.VLINE(20, ty - 5, ty + 13, wood)
    c.VLINE(21, ty - 5, ty + 13, shade(wood, -0.3))
    c.R(19, ty - 8, 21, ty - 6, orb)
    c.P(20, ty - 8, orb_hi)
    c.P(19, ty - 6, shade(orb, -0.3))
    c.P(20, ty - 5, shade(wood, -0.3))


def draw_bone_staff(c, ty):
    """Костяной посох с черепом-навершием (справа)."""
    c.VLINE(20, ty - 5, ty + 13, C(150, 138, 112))
    c.VLINE(21, ty - 5, ty + 13, C(116, 106, 86))
    # череп
    c.R(19, ty - 9, 22, ty - 6, NECRO_ORB)
    c.P(19, ty - 9, C(240, 238, 226))
    c.P(20, ty - 8, C(30, 34, 30))            # глазницы
    c.P(22, ty - 8, C(30, 34, 30))
    c.P(21, ty - 6, shade(NECRO_ORB, -0.35))
    c.R(20, ty - 5, 22, ty - 5, shade(NECRO_ORB, -0.2))


def draw_succ_wings(c, dir, p):
    """Крылья суккуба за спиной; со спины раскрыты шире."""
    ty = 13 + p["bob"]
    if dir == "up":
        c.ellipse(4, ty + 3, 3, 6, WING_C)
        c.ellipse(19, ty + 3, 3, 6, WING_C)
        c.VLINE(4, ty - 2, ty + 7, WING_HI)
        c.VLINE(19, ty - 2, ty + 7, WING_HI)
        return
    c.ellipse(3, ty + 3, 2, 5, WING_C)
    c.ellipse(20, ty + 3, 2, 5, WING_C)
    c.P(3, ty - 1, WING_HI)
    c.P(20, ty - 1, WING_HI)


def draw_succ_tail(c, dir, p):
    """Хвост с сердечком-наконечником (сбоку виден всегда)."""
    ty = 13 + p["bob"]
    x0 = 21 if dir != "up" else 12
    c.VLINE(x0, ty + 4, ty + 9, SUCC_ROBE)
    c.P(x0, ty + 10, SUCC_ROBE)
    c.P(x0, ty + 11, SUCC_TRIM)


def sheet_for(draw_one):
    from PIL import Image
    sheet = Image.new("RGBA", (6 * W, 6 * H), (0, 0, 0, 0))
    for r, (row, n, walking) in enumerate(ROWS):
        dir = row.split("_")[1]
        for f in range(n):
            img = draw_one(dir, f, walking)
            sheet.paste(img, (f * W, r * H))
    return sheet


# ---------------------------------------------------------------- демоноолог
def demonologist_frame(dir, f, walking):
    g = gc.G(
        skin=(208, 186, 196, 255), skin_sh=(174, 148, 162, 255),
        skin_hi=(236, 218, 226, 255), rosy=False,
        eye=DEMON_EYE,
        hair=(74, 32, 48, 255), hair_style="short",
        top=DEMON_ROBE, robe=True, trim=DEMON_TRIM,
        boots=(44, 28, 38, 255),
    )
    c = Cv(W, H)
    p = gc.pose(walking, f, dir)
    hy = p["bob"]
    ty = 13 + hy
    gc.robe(c, g, dir, p)
    gc.draw_head(c, g, dir, p)
    gc.hair_short(c, g, dir, hy)
    draw_horns(c, dir, hy)
    gc.draw_face_overlay(c, g, dir, p, hy)
    draw_dark_staff(c, ty, DEMON_ORB, C(255, 176, 200))
    c.outline()
    return c.img


# ---------------------------------------------------------------- некромант
def necromancer_frame(dir, f, walking):
    g = gc.G(
        skin=(210, 206, 194, 255), skin_sh=(176, 172, 160, 255),
        skin_hi=(238, 234, 222, 255), rosy=False,
        eye=NECRO_EYE,
        hair=(44, 42, 52, 255), hair_d=(32, 30, 40, 255),
        hair_hi=(72, 70, 84, 255), hair_style="long", flower=False,
        top=NECRO_ROBE, robe=True, trim=NECRO_TRIM,
        boots=(38, 34, 44, 255),
    )
    c = Cv(W, H)
    p = gc.pose(walking, f, dir)
    hy = p["bob"]
    ty = 13 + hy
    gc.robe(c, g, dir, p)
    gc.draw_head(c, g, dir, p)
    gc.hair_long(c, g, dir, hy, flower=False)
    gc.draw_face_overlay(c, g, dir, p, hy)
    draw_bone_staff(c, ty)
    c.outline()
    return c.img


# ---------------------------------------------------------------- суккуб
def succubus_frame(dir, f, walking):
    g = gc.G(
        skin=SUCC_SKIN, skin_sh=SUCC_SKIN_SH, skin_hi=(248, 196, 180, 255),
        rosy=True, eye=SUCC_EYE, mouth=(150, 44, 56, 255),
        hair=(50, 22, 34, 255), hair_style="long", flower=False,
        top=SUCC_ROBE, dress=True, trim=SUCC_TRIM,
        boots=(60, 24, 34, 255),
    )
    c = Cv(W, H)
    p = gc.pose(walking, f, dir)
    hy = p["bob"]
    ty = 13 + hy
    draw_succ_wings(c, dir, p)
    gc.dress(c, g, dir, p)
    gc.draw_head(c, g, dir, p)
    gc.hair_long(c, g, dir, hy, flower=False)
    draw_horns(c, dir, hy, color=C(178, 142, 120), dark=C(132, 102, 88))
    gc.draw_face_overlay(c, g, dir, p, hy)
    draw_succ_tail(c, dir, p)
    c.outline()
    return c.img


# ---------------------------------------------------------------- портреты
def portrait_demonologist():
    g = {"skin": (216, 196, 206, 255), "skin_sh": (178, 154, 168, 255),
         "skin_hi": (242, 226, 234, 255), "cloth": (70, 28, 48, 255),
         "brow": (56, 24, 38, 255)}
    c = Cv(gp.S, gp.S)
    gp.bg(c, (150, 66, 96))
    gp.bust(c, g)
    gp.eyes(c, g, (255, 158, 66), thick_brow=True)
    gp.nose_mouth(c, g, smile=False)
    # волосы + рога + мантия
    c.R(18, 4, 45, 10, C(74, 32, 48))
    c.R(16, 6, 19, 24, C(74, 32, 48))
    c.R(44, 6, 47, 24, C(60, 24, 38))
    c.R(20, 2, 26, 5, BONE)
    c.P(19, 1, BONE)
    c.R(37, 2, 43, 5, BONE)
    c.P(44, 1, BONE)
    c.R(18, 4, 26, 5, shade(BONE, 0.2))
    # воротник мантии и золото
    c.R(14, 45, 49, 49, C(116, 46, 66))
    c.HLINE(49, 14, 49, DEMON_TRIM)
    c.R(28, 50, 35, 56, DEMON_TRIM)
    c.P(31, 52, C(255, 214, 120))
    return c.img


def portrait_necromancer():
    g = {"skin": (222, 218, 206, 255), "skin_sh": (182, 178, 164, 255),
         "skin_hi": (246, 242, 230, 255), "cloth": (44, 58, 48, 255),
         "brow": (40, 38, 46, 255)}
    c = Cv(gp.S, gp.S)
    gp.bg(c, (66, 130, 96))
    gp.bust(c, g)
    gp.eyes(c, g, (110, 226, 120), thick_brow=False)
    gp.nose_mouth(c, g, smile=False)
    # длинные тёмные волосы
    c.R(18, 4, 45, 10, C(44, 42, 52))
    c.R(15, 6, 20, 34, C(44, 42, 52))
    c.R(43, 6, 48, 34, C(34, 32, 42))
    c.HLINE(6, 20, 43, C(72, 70, 84))
    # костяной воротник и череп-брошь
    c.R(14, 45, 49, 49, C(56, 70, 58))
    c.HLINE(49, 14, 49, NECRO_TRIM)
    c.R(28, 50, 35, 57, NECRO_ORB)
    c.P(30, 52, C(30, 34, 30))
    c.P(33, 52, C(30, 34, 30))
    c.P(31, 55, shade(NECRO_ORB, -0.3))
    return c.img


def main() -> None:
    print("Шаг 31: спрайты Демоноолога, Некроманта и Суккуба")
    save(sheet_for(demonologist_frame),
         os.path.join(OUT_CHARS, "demonologist.png"))
    save(sheet_for(necromancer_frame),
         os.path.join(OUT_CHARS, "necromancer.png"))
    save(sheet_for(succubus_frame),
         os.path.join(OUT_DUNGEON, "succubus.png"))
    save(portrait_demonologist(),
         os.path.join(OUT_PORTRAITS, "demonologist.png"))
    save(portrait_necromancer(),
         os.path.join(OUT_PORTRAITS, "necromancer.png"))
    print("OK")


if __name__ == "__main__":
    main()
