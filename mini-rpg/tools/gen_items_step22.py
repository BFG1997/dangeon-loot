# -*- coding: utf-8 -*-
"""Шаг 22: генерация арта 38 новых предметов (видов оружия и брони втрое
больше). Иконки 16x16 в том же стиле, что и старые: тёмный контур по
силуэту, сталь/дерево/магия, из tools/px.py (Cv + автообводка).

Сталь (12):   bone_chopper, guard_spear, great_axe, broadsword, glaive,
              flail, claymore, espadon, guisarme, executioner_axe,
              dragon_fang, royal_greatsword
Магия (12):   spark_wand, storm_eye, frost_needles, flame_rod, thorn_staff,
              marsh_orb, flame_blade, thunder_scepter, mist_crystal,
              starfall_staff, sun_scepter, polaris_wand
Броня (6):    quilted_jacket, leather_cuirass, scale_armor, brigandine,
              bachterez, dragon_scale
Мантии (6):   robe_apprentice, robe_runes, robe_mist, robe_lunar,
              robe_comet, robe_dawn
Уники (2):    comet_wreath, void_carapace

Запуск:  python3 tools/gen_items_step22.py
Результат: assets/sprites/icons/<38 иконок>.png
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from px import Cv, INK, C, shade, save  # noqa: E402

OUT_ICONS = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                         "assets", "sprites", "icons")

STEEL = C(186, 196, 210)
STEEL_HI = C(226, 233, 242)
STEEL_DK = C(138, 148, 164)
WOOD = C(138, 90, 43)
WOOD_HI = C(170, 116, 62)
GOLD = C(222, 178, 60)
GOLD_HI = C(246, 214, 120)
LEATHER = C(150, 96, 56)
LEATHER_DK = C(112, 68, 40)
ROPE = C(96, 62, 34)


def v_sword(cv, x, y_top, y_bot, w, body, hi, dk, tip=True):
    """Вертикальный клинок шириной w, с бликом слева и тенью справа."""
    for y in range(y_top, y_bot + 1):
        for dx in range(w):
            cv.P(x + dx, y, body)
        cv.P(x, y, hi)
        cv.P(x + w - 1, y, dk)
    if tip:
        cv.P(x + w // 2, y_top - 1, hi)


def hilt(cv, cx, y_guard, guard=GOLD, handle=ROPE, handle_h=3):
    """Навершие: гарда и рукоять под клинком."""
    cv.HLINE(y_guard, cx - 3, cx + 3, guard)
    cv.P(cx - 3, y_guard + 1, shade(guard, -0.3))
    cv.P(cx + 3, y_guard + 1, shade(guard, -0.3))
    for i in range(handle_h):
        cv.VLINE(cx, y_guard + 1 + i, y_guard + 1 + i, handle)
    cv.P(cx, y_guard + 1 + handle_h, GOLD)


def gen_steel_sword(item, blade, hi, dk, w=2, top=2, bot=9, ornate=False):
    cv = Cv(16, 16)
    v_sword(cv, 8 - w // 2, top, bot, w, blade, hi, dk)
    hilt(cv, 7 if w <= 2 else 8, 10)
    if ornate:
        cv.P(5, 10, GOLD_HI)
        cv.P(11, 10, GOLD_HI)
        cv.P(7, 15, GOLD_HI)
    cv.outline()
    return cv.img


def gen_steel_axe(item, head, hi, dk, double=False, big=False):
    cv = Cv(16, 16)
    cv.VLINE(7, 1, 14, WOOD)
    cv.P(7, 1, WOOD_HI)
    top, bot = (1, 8) if big else (2, 8)
    for y in range(top, bot + 1):
        span = 4 if y < top + 2 or y > bot - 2 else 5
        cv.R(8, y, 8 + span - 1, y, head)
        cv.P(8, y, hi)
        cv.P(8 + span - 1, y, dk)
    if double:
        for y in range(top, bot + 1):
            span = 4 if y < top + 2 or y > bot - 2 else 5
            cv.R(7 - span + 1, y, 6, y, head)
            cv.P(6, y, hi)
            cv.P(7 - span + 1, y, dk)
    cv.R(6, 13, 8, 14, ROPE)
    cv.outline()
    return cv.img


def gen_polearm(item, head, hi, dk, hook=False, spear=False):
    cv = Cv(16, 16)
    cv.VLINE(7, 4, 15, WOOD)
    cv.P(7, 4, WOOD_HI)
    if spear:
        for i, y in enumerate(range(1, 5)):
            cv.R(6 - (2 - min(i, 2)), y, 8 + (2 - min(i, 2)), y, head if y > 1 else hi)
        cv.P(7, 0, hi)
    else:
        for y in range(1, 7):
            cv.R(5, y, 9, y, head)
        cv.P(5, 1, hi)
        cv.P(6, 0, hi)
        cv.P(9, 1, dk)
        if hook:
            cv.P(10, 4, head)
            cv.P(10, 3, hi)
            cv.P(9, 2, dk)
    cv.R(6, 13, 8, 14, ROPE)
    cv.outline()
    return cv.img


def gen_orb(item, body, hi, dk, spark=True):
    cv = Cv(16, 16)
    cv.ellipse(8, 6, 4, 4, body)
    cv.P(6, 4, hi)
    cv.P(7, 3, hi)
    cv.P(9, 8, dk)
    cv.P(10, 7, dk)
    cv.VLINE(7, 10, 13, WOOD)
    cv.P(7, 10, WOOD_HI)
    cv.R(6, 14, 8, 14, GOLD)
    if spark:
        cv.P(12, 2, hi)
        cv.P(13, 3, body)
        cv.P(2, 10, hi)
    cv.outline()
    return cv.img


def gen_staff(item, top_body, top_hi, top_dk, shape="gem"):
    cv = Cv(16, 16)
    cv.VLINE(7, 4, 14, WOOD)
    cv.P(7, 4, WOOD_HI)
    cv.R(6, 13, 8, 14, ROPE)
    if shape == "gem":
        cv.R(5, 1, 9, 3, top_body)
        cv.R(6, 0, 8, 0, top_body)
        cv.P(6, 1, top_hi)
        cv.P(7, 0, top_hi)
        cv.P(8, 3, top_dk)
    elif shape == "star":
        cv.P(7, 0, top_hi)
        cv.P(6, 1, top_body)
        cv.P(8, 1, top_body)
        cv.P(5, 2, top_body)
        cv.P(9, 2, top_body)
        cv.P(6, 3, top_dk)
        cv.P(8, 3, top_dk)
        cv.P(7, 2, top_hi)
    elif shape == "flame":
        cv.P(7, 0, top_hi)
        cv.P(6, 1, top_body)
        cv.P(8, 1, top_body)
        cv.P(7, 1, top_hi)
        cv.P(6, 2, top_body)
        cv.P(8, 2, top_dk)
        cv.P(7, 3, top_dk)
    elif shape == "thorn":
        cv.R(6, 1, 8, 3, top_body)
        cv.P(5, 0, top_body)
        cv.P(9, 0, top_dk)
        cv.P(5, 3, top_dk)
        cv.P(9, 3, top_hi)
    cv.outline()
    return cv.img


def gen_armor(item, main, hi, dk, pattern="plain"):
    cv = Cv(16, 16)
    cv.R(5, 2, 10, 4, main)          # плечи
    cv.R(4, 5, 11, 12, main)         # корпус
    cv.P(5, 2, hi)
    cv.P(6, 2, hi)
    cv.P(10, 4, dk)
    cv.P(11, 12, dk)
    cv.P(4, 12, dk)
    cv.VLINE(4, 5, 11, hi)
    cv.VLINE(11, 5, 12, dk)
    cv.R(7, 6, 8, 11, dk)            # застёжка
    cv.P(7, 6, GOLD)
    cv.P(8, 6, GOLD)
    if pattern == "scale":
        for y in range(6, 12, 2):
            for x in range(5, 11, 2):
                cv.P(x, y, dk)
                cv.P(x, y + 1, hi)
    elif pattern == "quilt":
        for y in range(6, 12, 2):
            cv.HLINE(y, 5, 10, dk)
    elif pattern == "bands":
        for y in (6, 9):
            cv.HLINE(y, 5, 10, dk)
            cv.HLINE(y + 1, 5, 10, hi)
    elif pattern == "dragon":
        for y in range(5, 12, 3):
            for x in range(5, 11, 3):
                cv.P(x, y, hi)
                cv.P(x + 1, y + 1, dk)
    cv.outline()
    return cv.img


def gen_robe(item, body, hi, trim):
    cv = Cv(16, 16)
    cv.R(6, 2, 9, 3, body)           # капюшон
    cv.R(5, 4, 10, 7, body)
    cv.R(4, 8, 11, 13, body)         # юбка вширь
    cv.P(6, 2, hi)
    cv.P(7, 2, hi)
    cv.R(7, 5, 8, 12, trim)          # разрез с каймой
    cv.HLINE(13, 4, 11, trim)
    cv.P(4, 8, hi)
    cv.P(11, 13, shade(body, -0.35))
    cv.outline()
    return cv.img


def main() -> None:
    icons = {}

    # ------------------------------------------------ сталь (12)
    icons["bone_chopper"] = gen_steel_sword("bone_chopper", C(206, 196, 182),
        C(234, 228, 214), C(158, 148, 132), w=3, top=3, bot=9)
    icons["guard_spear"] = gen_polearm("guard_spear", STEEL, STEEL_HI, STEEL_DK,
        spear=True)
    icons["great_axe"] = gen_steel_axe("great_axe", STEEL, STEEL_HI, STEEL_DK,
        double=True, big=True)
    icons["broadsword"] = gen_steel_sword("broadsword", STEEL, STEEL_HI, STEEL_DK,
        w=3, top=1, bot=9)
    icons["glaive"] = gen_polearm("glaive", STEEL, STEEL_HI, STEEL_DK)
    icons["flail"] = None      # особый
    icons["claymore"] = gen_steel_sword("claymore", STEEL, STEEL_HI, STEEL_DK,
        w=2, top=0, bot=9, ornate=True)
    icons["espadon"] = gen_steel_sword("espadon", C(196, 204, 216),
        C(232, 238, 246), C(146, 154, 170), w=3, top=0, bot=10)
    icons["guisarme"] = gen_polearm("guisarme", STEEL, STEEL_HI, STEEL_DK, hook=True)
    icons["executioner_axe"] = gen_steel_axe("executioner_axe", C(172, 178, 190),
        C(216, 222, 232), C(128, 132, 146), big=True)
    icons["dragon_fang"] = gen_steel_sword("dragon_fang", C(226, 216, 196),
        C(248, 240, 222), C(176, 164, 142), w=2, top=1, bot=10)
    icons["royal_greatsword"] = gen_steel_sword("royal_greatsword",
        GOLD, GOLD_HI, C(178, 136, 44), w=2, top=0, bot=9, ornate=True)

    # особый: боевой цеп (шар на цепи)
    cv = Cv(16, 16)
    cv.R(3, 1, 6, 2, WOOD)               # рукоять
    cv.P(3, 1, WOOD_HI)
    chain = [(7, 3), (8, 4), (9, 5), (9, 6), (10, 7), (10, 8)]
    for cx, cy in chain:
        cv.P(cx, cy, STEEL_DK)
    cv.ellipse(10, 11, 2, 2, STEEL)
    cv.P(9, 10, STEEL_HI)
    cv.P(11, 12, STEEL_DK)
    cv.P(10, 8, STEEL_DK)
    cv.outline()
    icons["flail"] = cv.img

    # ------------------------------------------------ магия (12)
    icons["spark_wand"] = gen_staff("spark_wand", C(255, 216, 110),
        C(255, 238, 170), C(200, 150, 60), shape="gem")
    icons["storm_eye"] = gen_orb("storm_eye", C(86, 128, 208),
        C(150, 190, 255), C(52, 80, 148))
    cv = Cv(16, 16)
    for i, (x, y) in enumerate([(4, 2), (7, 5), (10, 8)]):
        col = C(196, 232, 255) if i % 2 == 0 else C(150, 205, 240)
        cv.R(x, y, x, y + 5, col)
        cv.P(x, y, C(240, 250, 255))
    cv.P(4, 8, C(120, 180, 220))
    cv.P(7, 11, C(120, 180, 220))
    cv.P(10, 14, C(120, 180, 220))
    cv.outline()
    icons["frost_needles"] = cv.img
    icons["flame_rod"] = gen_staff("flame_rod", C(255, 120, 56),
        C(255, 180, 90), C(196, 74, 26), shape="flame")
    icons["thorn_staff"] = gen_staff("thorn_staff", C(74, 128, 58),
        C(120, 176, 96), C(44, 86, 36), shape="thorn")
    icons["marsh_orb"] = gen_orb("marsh_orb", C(88, 132, 74),
        C(140, 186, 120), C(52, 84, 44), spark=False)
    icons["flame_blade"] = gen_steel_sword("flame_blade", C(238, 120, 64),
        C(255, 180, 100), C(190, 70, 30), w=2, top=1, bot=9)
    icons["thunder_scepter"] = gen_staff("thunder_scepter", C(255, 232, 96),
        C(255, 248, 160), C(200, 168, 44), shape="star")
    cv = Cv(16, 16)
    cv.R(6, 1, 9, 2, C(218, 234, 240))   # кристалл
    cv.R(5, 3, 10, 7, C(198, 220, 232))
    cv.R(6, 8, 9, 8, C(170, 196, 212))
    cv.P(6, 2, C(244, 252, 255))
    cv.P(5, 4, C(244, 252, 255))
    cv.P(10, 6, C(150, 176, 194))
    cv.VLINE(7, 9, 13, WOOD)
    cv.R(6, 14, 8, 14, GOLD)
    cv.outline()
    icons["mist_crystal"] = cv.img
    icons["starfall_staff"] = gen_staff("starfall_staff", C(232, 206, 130),
        C(252, 238, 170), C(178, 148, 70), shape="star")
    icons["sun_scepter"] = gen_staff("sun_scepter", C(255, 226, 120),
        C(255, 244, 180), C(206, 164, 52), shape="flame")
    icons["polaris_wand"] = gen_staff("polaris_wand", C(226, 238, 255),
        C(250, 254, 255), C(168, 190, 224), shape="star")

    # ------------------------------------------------ броня (6)
    icons["quilted_jacket"] = gen_armor("quilted_jacket", C(178, 148, 108),
        C(206, 180, 140), C(140, 114, 80), pattern="quilt")
    icons["leather_cuirass"] = gen_armor("leather_cuirass", LEATHER,
        C(182, 128, 84), LEATHER_DK)
    icons["scale_armor"] = gen_armor("scale_armor", C(150, 158, 172),
        C(190, 198, 210), C(112, 118, 132), pattern="scale")
    icons["brigandine"] = gen_armor("brigandine", C(120, 88, 116),
        C(154, 118, 148), C(88, 62, 86), pattern="bands")
    icons["bachterez"] = gen_armor("bachterez", C(134, 142, 158),
        C(174, 182, 196), C(100, 106, 120), pattern="scale")
    icons["dragon_scale"] = gen_armor("dragon_scale", C(94, 150, 92),
        C(146, 200, 132), C(62, 104, 60), pattern="dragon")

    # ------------------------------------------------ мантии (6)
    icons["robe_apprentice"] = gen_robe("robe_apprentice", C(108, 130, 178),
        C(146, 168, 212), C(200, 190, 150))
    icons["robe_runes"] = gen_robe("robe_runes", C(86, 108, 150),
        C(122, 146, 190), C(180, 170, 220))
    icons["robe_mist"] = gen_robe("robe_mist", C(158, 176, 196),
        C(196, 212, 228), C(120, 138, 160))
    icons["robe_lunar"] = gen_robe("robe_lunar", C(122, 138, 190),
        C(168, 186, 232), C(222, 226, 246))
    icons["robe_comet"] = gen_robe("robe_comet", C(96, 84, 158),
        C(140, 126, 200), C(232, 200, 130))
    icons["robe_dawn"] = gen_robe("robe_dawn", C(196, 132, 96),
        C(232, 172, 130), C(255, 222, 150))

    # ------------------------------------------------ уники (2)
    cv = Cv(16, 16)
    cv.ellipse(8, 8, 5, 5, (0, 0, 0, 0))
    ring = [(4, 6), (5, 4), (8, 3), (11, 4), (12, 7), (12, 10), (9, 12),
        (6, 12), (4, 10)]
    for i, (x, y) in enumerate(ring):
        cv.P(x, y, C(150, 178, 236))
        cv.P(x + 1, y + 1, C(210, 226, 255))
    cv.ellipse(8, 8, 2, 2, C(236, 244, 255))
    cv.P(7, 7, C(255, 255, 255))
    cv.outline()
    icons["comet_wreath"] = cv.img

    cv = Cv(16, 16)
    cv.R(5, 1, 10, 3, C(56, 44, 92))
    cv.R(4, 4, 11, 12, C(74, 58, 118))
    cv.P(5, 1, C(96, 78, 150))
    cv.P(6, 1, C(96, 78, 150))
    cv.VLINE(4, 4, 12, C(96, 78, 150))
    cv.VLINE(11, 4, 12, C(46, 34, 76))
    for y in range(5, 12, 3):
        for x in range(5, 11, 3):
            cv.P(x, y, C(120, 98, 176))
    cv.R(7, 6, 8, 11, C(36, 26, 62))
    cv.P(7, 6, C(150, 92, 220))
    cv.P(8, 6, C(150, 92, 220))
    cv.outline()
    icons["void_carapace"] = cv.img

    os.makedirs(OUT_ICONS, exist_ok=True)
    for item_id, img in icons.items():
        if img is None:
            continue
        path = os.path.join(OUT_ICONS, item_id + ".png")
        img.save(path)
        print("OK", item_id)
    print("Иконок сгенерировано:", len(icons))


if __name__ == "__main__":
    main()
