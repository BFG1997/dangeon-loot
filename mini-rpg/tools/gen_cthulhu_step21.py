# -*- coding: utf-8 -*-
"""Шаг 21: Ктулху стал УСТРАШАЮЩИМ.

Перерисовывает босса данжа 3 «Глубины Р'льеха» целиком (tools/gen_cthulhu_step21.py):
  - лист assets/sprites/dungeon/boss_cthulhu.png теперь 576x768 — кадры 96x128
    (масштаб x4 вместо x3, чтобы Ктулху нависал над героем, как башня тьмы);
  - новый силуэт: тощее тело на костяных ногах, гигантские перепончатые
    крылья почти во всю ширину кадра, борода из щупалец, угли-глаза,
    костяные шипы на плечах и макушке, когти;
  - портрет assets/sprites/portraits/boss_cthulhu.png — крупнее и страшнее.

Запуск:  python3 tools/gen_cthulhu_step21.py
"""
import math
import os
import sys

from PIL import Image, ImageDraw

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from px import Cv, C, shade, save, INK
import gen_dungeon as gd

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FW, FH = 96, 128          # кадр x4 (герой 24x32, обычные враги x1..x1.5)

# ------------------------------------------------------------- палитра
P = {
    "skin":    C(44, 60, 50),     # тощая плоть бездны (видимая)
    "skin_hi": C(66, 86, 70),
    "skin_lo": C(28, 40, 33),
    "ribs":    C(84, 106, 88),
    "glow":    C(96, 156, 104),   # болотное свечение
    "ember":   C(255, 84, 32),    # угли-глаза
    "ember_hi": C(255, 196, 92),
    "wing":    C(26, 32, 42),     # перепонка крыла
    "wing_hi": C(58, 66, 84),
    "bone":    C(206, 212, 196),  # когти и шипы
    "tent":    C(64, 88, 86),
    "tent_hi": C(98, 128, 120),
    "tent_lo": C(38, 58, 54),
    "sucker":  C(182, 212, 196),
}
TENT_PAL = {"tent": P["tent"], "tent_hi": P["tent_hi"],
            "tent_lo": P["tent_lo"], "sucker": P["sucker"]}
WING_PAL = {"tent": P["wing"], "tent_hi": P["wing_hi"],
            "tent_lo": shade(P["wing"], -0.3), "sucker": P["wing_hi"]}


def poly(c, pts, col):
    """Заливка полигона прямо в PIL-изображение (перепонки крыльев)."""
    d = ImageDraw.Draw(c.img)
    d.polygon(pts, fill=col)


def line_chain(c, pts, col):
    """Костяная линия: точки по отрезкам (для костей крыла)."""
    for i in range(len(pts) - 1):
        x0, y0 = pts[i]
        x1, y1 = pts[i + 1]
        steps = max(abs(x1 - x0), abs(y1 - y0))
        for s in range(steps + 1):
            t = s / max(1, steps)
            c.P(int(round(x0 + (x1 - x0) * t)),
                int(round(y0 + (y1 - y0) * t)), col)


def limb(c, pts, base, hi, r0=4, r1=2):
    """Рука/нога: НЕПРЕРЫВНАЯ конечность — круги вдоль всего отрезка."""
    n = len(pts)
    for i in range(n - 1):
        x0, y0 = pts[i]
        x1, y1 = pts[i + 1]
        ra = r0 + (r1 - r0) * i / max(1, n - 1)
        rb = r0 + (r1 - r0) * (i + 1) / max(1, n - 1)
        steps = max(abs(x1 - x0), abs(y1 - y0), 1)
        for s in range(steps + 1):
            t = s / steps
            x = x0 + (x1 - x0) * t
            y = y0 + (y1 - y0) * t
            r = max(1, int(round(ra + (rb - ra) * t)))
            c.ellipse(int(round(x)), int(round(y)), r, r, base)
    # блики сверху по узлам
    for i, (x, y) in enumerate(pts):
        r = max(1, int(round(r0 + (r1 - r0) * i / max(1, n - 1))))
        if r >= 3:
            c.ellipse(x, y - r + 1, max(1, r - 2), 1, hi)


CLAW = C(168, 176, 162)   # когти: костяные, но не светящиеся

def claws(c, x, y, dx, dy, root=None):
    """Кисть: три КОРОТКИХ когтя (4 px) веером из конца конечности."""
    if root:
        line_chain(c, [root, (x, y)], CLAW)
    for k in (-1, 0, 1):
        ex = x + dx * 4 + dy * k * 2
        ey = y + dy * 4 + dx * k * 2
        line_chain(c, [(x, y), (ex, ey)], CLAW)


def register(c):
    """После PIL-полигонов: синхронизируем px_map, чтобы outline() видел всё."""
    px = c.img.load()
    for y in range(c.h):
        for x in range(c.w):
            if px[x, y][3] > 0 and (x, y) not in c.px_map:
                c.px_map[(x, y)] = px[x, y]


def wings(c, bob, flap, back=False):
    """Крылья: перепонка во всю ширину кадра + кости. back — вид сзади."""
    lift = flap * 6
    if back:
        # сзади крылья видны с обеих сторон целиком
        for side, ax in ((-1, 34), (1, 62)):
            tips = [(ax + side * 34, 22 - lift), (ax + side * 42, 44 - lift),
                    (ax + side * 38, 70 - lift // 2)]
            poly(c, [(ax, 46 + bob), tips[0], tips[1], tips[2],
                     (ax + side * 6, 74 + bob)], P["wing"])
            for t in tips:
                line_chain(c, [(ax, 46 + bob), t], shade(P["wing"], 0.22))
            register(c)
        return
    # вид спереди: крылья за плечами
    for side, ax in ((-1, 30), (1, 66)):
        tips = [(ax + side * 32, 22 - lift), (ax + side * 42, 44 - lift),
                (ax + side * 38, 68 - lift // 2)]
        poly(c, [(ax, 48 + bob), tips[0], tips[1], tips[2],
                 (ax + side * 5, 74 + bob)], P["wing"])
        for t in tips:
            line_chain(c, [(ax, 48 + bob), t], shade(P["wing"], 0.22))
        register(c)


def torso(c, bob, blink, sway):
    """Тощий торс: широкие плечи, впалая грудь, узкая талия."""
    # торс: от плеч (y 48, ширина 34) к талии (y 84, ширина 14) — сплошной
    for i, y in enumerate(range(48 + bob, 86 + bob, 3)):
        t = i / 12.0
        w = int(round(17 - 10 * t))
        c.R(48 - w, y, 48 + w, y + 2, P["skin"])
    # впалая грудь: тень-столб по центру, слабые рёбра по краям
    c.R(45, 52 + bob, 51, 78 + bob, shade(P["skin_lo"], -0.4))
    for yy in (56, 62, 68, 74):
        c.P(36, yy + bob, P["ribs"])
        c.P(60, yy + bob, P["ribs"])
        c.P(37, yy - 1 + bob, shade(P["skin_hi"], -0.1))
        c.P(59, yy - 1 + bob, shade(P["skin_hi"], -0.1))
    # плечевые наплывы и костяные шипы вверх
    for ax in (31, 65):
        c.ellipse(ax, 50 + bob, 7, 6, P["skin_hi"])
        c.ellipse(ax, 50 + bob, 4, 3, P["skin"])
        line_chain(c, [(ax, 45 + bob), (ax, 38 + bob),
                       (ax + (3 if ax < 48 else -3), 33 + bob)], P["bone"])
    # шея
    c.R(44, 40 + bob, 52, 47 + bob, P["skin_lo"])
    # голова: вытянутый череп с гребнем
    c.ellipse(48, 30 + bob, 14, 16, P["skin"])
    c.ellipse(48, 28 + bob, 10, 12, P["skin_hi"])
    c.R(46, 12 + bob, 50, 19 + bob, P["skin"])
    line_chain(c, [(48, 14 + bob), (48, 24 + bob)], shade(P["skin_hi"], 0.25))
    for hx in (42, 54):
        line_chain(c, [(hx, 20 + bob), (hx - 2 if hx < 48 else hx + 2, 12 + bob),
                       (hx - 3 if hx < 48 else hx + 3, 8 + bob)], P["bone"])
    # надбровная тень
    c.HLINE(26 + bob, 36, 60, P["skin_lo"])
    c.HLINE(27 + bob, 38, 58, shade(P["skin_lo"], -0.4))
    # глаза-угли (blink — мигание в idle)
    eye = shade(P["ember"], -0.55) if blink else P["ember"]
    for dx in (-7, 7):
        c.ellipse(48 + dx, 29 + bob, 3, 2, eye)
        if not blink:
            c.P(48 + dx, 29 + bob, P["ember_hi"])
            c.P(48 + dx, 27 + bob, shade(P["ember"], -0.4))
            c.P(48 + dx - 1, 29 + bob, shade(P["ember"], -0.25))
            c.P(48 + dx + 1, 29 + bob, shade(P["ember"], -0.25))


def tentacle_beard(c, bob, sway):
    """Борода из щупалец: семь мясистых конечностей ниже пояса."""
    gd._tentacle(c, [(36, 40 + bob), (30, 52 + bob), (26, 64 + bob),
                     (28 + sway, 78 + bob)], TENT_PAL, r0=7, r1=3)
    gd._tentacle(c, [(60, 40 + bob), (66, 52 + bob), (70, 64 + bob),
                     (68 - sway, 78 + bob)], TENT_PAL, r0=7, r1=3)
    gd._tentacle(c, [(42, 44 + bob), (38, 58 + bob), (40 + sway, 74 + bob)],
                 TENT_PAL, r0=5, r1=3)
    gd._tentacle(c, [(54, 44 + bob), (58, 58 + bob), (56 - sway, 74 + bob)],
                 TENT_PAL, r0=5, r1=3)
    gd._tentacle(c, [(46, 46 + bob), (44, 60 + bob), (46 + sway // 2, 82 + bob)],
                 TENT_PAL, r0=4, r1=2)
    gd._tentacle(c, [(50, 46 + bob), (52, 60 + bob), (50 - sway // 2, 82 + bob)],
                 TENT_PAL, r0=4, r1=2)
    gd._tentacle(c, [(48, 48 + bob), (48, 64 + bob), (48 + sway // 2, 88 + bob)],
                 TENT_PAL, r0=3, r1=2)


def legs_arms(c, bob, stride, up=False):
    """Костяные ноги (шаг — stride) и руки с когтями."""
    if up:
        # со спины: чуть уже, когти в стороны
        limb(c, [(40, 86 + bob), (38, 102 + bob), (36 + stride, 118 + bob)],
             P["skin"], P["skin_hi"], r0=6, r1=4)
        limb(c, [(56, 86 + bob), (58, 102 + bob), (60 - stride, 118 + bob)],
             P["skin"], P["skin_hi"], r0=6, r1=4)
        claws(c, 34 + stride, 122 + bob, -1, 1, root=(36 + stride, 118 + bob))
        claws(c, 62 - stride, 122 + bob, 1, 1, root=(60 - stride, 118 + bob))
        limb(c, [(30, 54 + bob), (20, 68 + bob), (12, 80 + bob)],
             P["skin_lo"], P["skin"], r0=5, r1=3)
        limb(c, [(66, 54 + bob), (76, 68 + bob), (84, 80 + bob)],
             P["skin_lo"], P["skin"], r0=5, r1=3)
        claws(c, 9, 83 + bob, -1, 1, root=(12, 80 + bob))
        claws(c, 87, 83 + bob, 1, 1, root=(84, 80 + bob))
        return
    limb(c, [(42, 86 + bob), (40, 102 + bob), (37 + stride, 118 + bob)],
         P["skin"], P["skin_hi"], r0=6, r1=4)
    limb(c, [(54, 86 + bob), (56, 102 + bob), (59 - stride, 118 + bob)],
         P["skin"], P["skin_hi"], r0=6, r1=4)
    claws(c, 35 + stride, 122 + bob, -1, 1, root=(37 + stride, 118 + bob))
    claws(c, 61 - stride, 122 + bob, 1, 1, root=(59 - stride, 118 + bob))
    limb(c, [(33, 52 + bob), (23, 66 + bob), (14, 80 + bob)],
         P["skin"], P["skin_hi"], r0=6, r1=4)
    limb(c, [(63, 52 + bob), (73, 66 + bob), (82, 80 + bob)],
         P["skin"], P["skin_hi"], r0=6, r1=4)
    claws(c, 11, 83 + bob, -1, 1, root=(14, 80 + bob))
    claws(c, 85, 83 + bob, 1, 1, root=(82, 80 + bob))


def wisps(c, bob, f):
    """Зелёные искры бездны вокруг (мерцают по кадрам)."""
    pts = [(12, 34), (84, 30), (16, 92), (80, 96), (10, 60), (86, 64)]
    for i, (x, y) in enumerate(pts):
        if (f + i) % 3 != 2:
            c.P(x, y + bob, shade(P["glow"], -0.15))
            c.P(x, y + 1 + bob, shade(P["glow"], -0.5))


def cthulhu_frame_4x(c, dir, p, f=0):
    """Кадр Ктулху 96x128 (масштаб x4): всё рисуется с нуля."""
    bob = p.get("bob", 0) * 3
    stride = p.get("stride", 0) * 2
    blink = bool(p.get("blink", False))
    sway = [0, 2, 4, 2, 0, -2][f % 6]
    flap = 1 if (p.get("stride", 0) and f % 2) else 0
    if dir == "down":
        wings(c, bob, flap)
        legs_arms(c, bob, stride)
        torso(c, bob, blink, sway)
        tentacle_beard(c, bob, sway)
    elif dir == "side":
        # крыло сзади (одно полотно уходит назад)
        poly(c, [(40, 48 + bob), (10, 22 - flap * 6), (4, 48 - flap * 3),
                 (10, 72 - flap), (34, 72 + bob)], P["wing"])
        line_chain(c, [(40, 48 + bob), (10, 22 - flap * 6)], shade(P["wing"], 0.22))
        line_chain(c, [(40, 48 + bob), (4, 48 - flap * 3)], shade(P["wing"], 0.22))
        register(c)
        # ноги и руки в профиль (лицом вправо)
        limb(c, [(44, 86 + bob), (42, 102 + bob), (40 + stride, 118 + bob)],
             P["skin"], P["skin_hi"], r0=6, r1=4)
        limb(c, [(54, 86 + bob), (58, 102 + bob), (62 - stride, 118 + bob)],
             P["skin"], P["skin_hi"], r0=6, r1=4)
        claws(c, 38 + stride, 122 + bob, -1, 1, root=(40 + stride, 118 + bob))
        claws(c, 64 - stride, 122 + bob, 1, 1, root=(62 - stride, 118 + bob))
        limb(c, [(62, 54 + bob), (74, 68 + bob), (84, 78 + bob)],
             P["skin"], P["skin_hi"], r0=6, r1=4)
        claws(c, 86, 80 + bob, 1, 1, root=(84, 78 + bob))
        limb(c, [(42, 54 + bob), (34, 70 + bob), (30, 80 + bob)],
             P["skin_lo"], P["skin"], r0=5, r1=3)
        claws(c, 28, 83 + bob, -1, 1, root=(30, 80 + bob))
        # торс в профиль
        c.R(42, 50 + bob, 62, 84 + bob, P["skin"])
        c.R(53, 54 + bob, 62, 80 + bob, P["skin_hi"])
        for yy in (58, 66, 74):
            c.HLINE(yy + bob, 44, 50, shade(P["skin_lo"], -0.3))
        # голова в профиль: череп с клювом
        c.ellipse(56, 30 + bob, 12, 14, P["skin"])
        c.ellipse(56, 28 + bob, 9, 11, P["skin_hi"])
        line_chain(c, [(62, 24 + bob), (68, 30 + bob), (64, 34 + bob)], P["skin_lo"])
        c.HLINE(27 + bob, 48, 64, P["skin_lo"])
        eye = shade(P["ember"], -0.55) if blink else P["ember"]
        c.ellipse(60, 29 + bob, 3, 2, eye)
        c.P(60, 29 + bob, P["ember_hi"] if not blink else eye)
        # борода щупалец вбок и назад
        gd._tentacle(c, [(52, 42 + bob), (44, 52 + bob), (38, 62 + bob),
                         (34 + sway, 70 + bob)], TENT_PAL, r0=5, r1=2)
        gd._tentacle(c, [(58, 44 + bob), (52, 56 + bob), (48 + sway, 66 + bob)],
                     TENT_PAL, r0=4, r1=2)
        gd._tentacle(c, [(46, 38 + bob), (38, 40 + bob), (30, 44 + sway + bob)],
                     TENT_PAL, r0=4, r1=2)
        # гребень на макушке
        line_chain(c, [(54, 16 + bob), (56, 10 + bob), (58, 6 + bob)], P["bone"])
    else:  # up — спина: крылья во всю ширь, хребет, пара щупалец
        wings(c, bob, flap, back=True)
        legs_arms(c, bob, stride, up=True)
        c.R(40, 50 + bob, 56, 84 + bob, P["skin"])
        line_chain(c, [(48, 52 + bob), (48, 84 + bob)], P["skin_hi"])
        for yy in (58, 66, 74):
            c.P(48, yy + bob, P["ribs"])
            c.P(47, yy + bob, P["skin_lo"])
            c.P(49, yy + bob, P["skin_lo"])
        c.ellipse(48, 30 + bob, 12, 14, P["skin"])
        line_chain(c, [(48, 16 + bob), (48, 40 + bob)], shade(P["skin_hi"], 0.15))
        for hx in (40, 56):
            line_chain(c, [(hx, 22 + bob), (hx - 1, 14 + bob), (hx - 2, 10 + bob)], P["bone"])
        gd._tentacle(c, [(38, 36 + bob), (30, 32 + bob), (24, 28 + sway + bob)],
                     TENT_PAL, r0=4, r1=2)
        gd._tentacle(c, [(58, 36 + bob), (66, 32 + bob), (72, 28 - sway + bob)],
                     TENT_PAL, r0=4, r1=2)
    wisps(c, bob, f)


def gen_sheet():
    sheet = Image.new("RGBA", (FW * 6, FH * 6), (0, 0, 0, 0))
    for r, (name, walking, dir, count) in enumerate(gd.SHEET_ROWS):
        for f in range(count):
            big = Cv(FW, FH)
            p = gd.pose(walking, f, dir)
            cthulhu_frame_4x(big, dir, p, f=f)
            big.outline()
            sheet.paste(big.img, (f * FW, r * FH), big.img)
    save(sheet, "sprites/dungeon/boss_cthulhu.png")
    return sheet


def gen_portrait(sheet):
    """Портрет 64x64: лицо idle_down кадра 0 — крупно, с углями и щупальцами."""
    face = sheet.crop((14, 0, 78, 64)).resize((64, 64), Image.NEAREST)
    save(face, "sprites/portraits/boss_cthulhu.png")
    return face


if __name__ == "__main__":
    print("Шаг 21: страшный Ктулху (кадры 96x128, x4)")
    sheet = gen_sheet()
    gen_portrait(sheet)
    # локальное превью для проверки (в проект не пишем)
    prev = sheet.crop((0, 0, FW * 2, FH * 6))
    prev.save("/tmp/cthulhu_preview.png")
    print("  -> /tmp/cthulhu_preview.png")
