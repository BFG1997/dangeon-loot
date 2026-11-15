# -*- coding: utf-8 -*-
"""Шаг 19: генерация арта новых оружий и эффектов удара.

Видов оружия стало вдвое больше (7 -> 14). Новые иконки 16x16 — в том же
стиле, что и старые (тёмный контур + сталь/дерево/магия):
  rusty_dagger  — Ржавый кинжал (обычное, 12 урона)
  axe_war       — Ратная секира (обычное, 40)
  warhammer     — Боевой молот (обычное, 70)
  staff_embers  — Посох углей (магическое, 45, залп углей)
  orb_abyss     — Сфера бездны (магическое, 80, сглаз бездны)
  chakram_moon  — Лунный чакрам (магическое, 65, лунный веер)
  moon_reaper   — Серп полумесяца (фиолетовый уник, 130)
Плюс эффект шага 19 — белая дуга взмаха slash_arc.png 32x32 (красится
modulate под цвет оружия в сцене).

Запуск:  python3 tools/gen_weapons_step19.py
Результат: assets/sprites/icons/<7 иконок>.png, assets/sprites/fx/slash_arc.png
"""
import os
from PIL import Image
import math

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

OUTLINE = (24, 26, 34, 255)
STEEL = (186, 196, 210, 255)
STEEL_LIGHT = (222, 230, 240, 255)
STEEL_DARK = (140, 150, 166, 255)
RUST = (168, 110, 74, 255)
RUST_DARK = (120, 76, 52, 255)
WOOD = (138, 90, 43, 255)
WOOD_LIGHT = (168, 112, 58, 255)
EMBER = (255, 138, 44, 255)
EMBER_LIGHT = (255, 190, 90, 255)
EMBER_DARK = (196, 74, 26, 255)
ABYSS = (150, 92, 220, 255)
ABYSS_LIGHT = (196, 150, 255, 255)
ABYSS_DARK = (86, 44, 140, 255)
MOON = (208, 224, 246, 255)
MOON_LIGHT = (238, 246, 255, 255)
MOON_DARK = (140, 158, 190, 255)
WRAP = (96, 62, 34, 255)         # обмотка у навершия
RUST_LIGHT = (206, 152, 110, 255)  # блик ржавой стали
VOID_CORE = (30, 16, 52, 255)      # зев бездны


def put(px, x, y, color, w=16, h=16):
    if 0 <= x < w and 0 <= y < h:
        px[x, y] = color


def outline(img):
    """Контур по границе силуэта (как в gen_abilities.py)."""
    w, h = img.size
    px = img.load()
    snapshot = {(x, y): px[x, y] for x in range(w) for y in range(h)}
    for y in range(h):
        for x in range(w):
            if snapshot[(x, y)][3] == 0:
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    nx, ny = x + dx, y + dy
                    if 0 <= nx < w and 0 <= ny < h \
                            and snapshot[(nx, ny)][3] != 0:
                        put(px, x, y, OUTLINE, w, h)
                        break
    return img


def gen_rusty_dagger() -> Image.Image:
    """Ржавый кинжал: короткое ржавое лезвие, деревянная рукоять."""
    img = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    px = img.load()
    for y in range(2, 8):           # лезвие
        for x in range(6, 10):
            put(px, x, y, RUST)
        put(px, 6, y, RUST_DARK)
    put(px, 7, 2, RUST_LIGHT)
    put(px, 8, 2, RUST_LIGHT)
    for y in range(2, 6):           # остриё
        put(px, 7, y, RUST)
        put(px, 8, y, RUST)
    put(px, 7, 1, RUST_DARK)
    for x in range(5, 11):          # гарда
        put(px, x, 8, WOOD_LIGHT)
    for y in range(9, 14):          # рукоять
        put(px, 7, y, WOOD)
        put(px, 8, y, WOOD_LIGHT)
    put(px, 7, 14, WRAP)
    put(px, 8, 14, WRAP)
    return outline(img)


def gen_axe_war() -> Image.Image:
    """Ратная секира: широкое лезвие слева, длинная рукоять по диагонали."""
    img = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    px = img.load()
    # рукоять — диагональ из нижнего правого угла к верхнему левому
    for i in range(9):
        put(px, 10 - i, 13 - i, WOOD)
        put(px, 11 - i, 13 - i, WOOD_LIGHT)
    # лезвие — полумесяц слева от верхнего конца рукояти
    blade = {
        1: range(3, 8), 2: range(1, 9), 3: range(1, 10), 4: range(2, 9),
        5: range(3, 8), 6: range(4, 7),
    }
    for y, xs in blade.items():
        for x in xs:
            put(px, x, y, STEEL)
        put(px, min(xs), y, STEEL_LIGHT)
        put(px, max(xs), y, STEEL_DARK)
    put(px, 5, 3, STEEL_DARK)
    put(px, 4, 4, STEEL_DARK)
    put(px, 9, 3, WRAP)
    put(px, 9, 4, WRAP)
    return outline(img)


def gen_warhammer() -> Image.Image:
    """Боевой молот: тяжёлый стальной блок на вертикальной рукояти."""
    img = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    px = img.load()
    for y in range(1, 7):           # боёк
        for x in range(3, 13):
            put(px, x, y, STEEL)
    for x in range(3, 13):          # светлая грань сверху, тень снизу
        put(px, x, 1, STEEL_LIGHT)
        put(px, x, 6, STEEL_DARK)
    put(px, 3, 1, STEEL_LIGHT)
    put(px, 12, 6, STEEL_DARK)
    for x in range(7, 9):           # шипы-клинья на бойке
        put(px, x, 0, STEEL_DARK)
    for y in range(7, 15):          # рукоять
        put(px, 7, y, WOOD)
        put(px, 8, y, WOOD_LIGHT)
    put(px, 7, 7, WRAP)
    put(px, 8, 7, WRAP)
    return outline(img)


def gen_staff_embers() -> Image.Image:
    """Посох углей: тёмное древко, наверху тлеющая оранжевая сфера."""
    img = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    px = img.load()
    for y in range(6, 15):          # древко
        put(px, 7, y, WOOD)
        put(px, 8, y, WOOD_LIGHT)
    orb = {1: range(6, 10), 2: range(5, 11), 3: range(4, 12),
           4: range(4, 12), 5: range(5, 11), 6: range(6, 10)}
    for y, xs in orb.items():
        for x in xs:
            put(px, x, y, EMBER)
    for y, xs in orb.items():
        put(px, min(xs), y, EMBER_DARK)
        put(px, max(xs), y, EMBER_DARK)
    put(px, 7, 2, EMBER_LIGHT)
    put(px, 8, 3, EMBER_LIGHT)
    put(px, 7, 3, EMBER_LIGHT)
    put(px, 6, 7, EMBER_LIGHT)      # искры
    put(px, 10, 6, EMBER_LIGHT)
    return outline(img)


def gen_orb_abyss() -> Image.Image:
    """Сфера бездны: фиолетовый шар с тёмным зевом внутри."""
    img = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    px = img.load()
    orb = {2: range(6, 10), 3: range(4, 12), 4: range(3, 13),
           5: range(3, 13), 6: range(2, 14), 7: range(2, 14),
           8: range(2, 14), 9: range(3, 13), 10: range(3, 13),
           11: range(4, 12), 12: range(6, 10)}
    for y, xs in orb.items():
        for x in xs:
            put(px, x, y, ABYSS)
    for y, xs in orb.items():
        put(px, min(xs), y, ABYSS_DARK)
        put(px, max(xs), y, ABYSS_LIGHT)
    # зев бездны — тёмный центр
    core = {5: range(6, 10), 6: range(5, 11), 7: range(5, 11),
            8: range(5, 11), 9: range(6, 10)}
    for y, xs in core.items():
        for x in xs:
            put(px, x, y, ABYSS_DARK)
    put(px, 7, 6, VOID_CORE)
    put(px, 8, 6, VOID_CORE)
    put(px, 7, 7, VOID_CORE)
    put(px, 8, 7, VOID_CORE)
    put(px, 4, 3, ABYSS_LIGHT)      # блик
    put(px, 5, 3, ABYSS_LIGHT)
    return outline(img)


def gen_chakram_moon() -> Image.Image:
    """Лунный чакрам: серебристое кольцо с лунным вырезом."""
    img = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    px = img.load()
    cx, cy, r_out, r_in = 7.5, 7.5, 6.4, 3.6
    for y in range(16):
        for x in range(16):
            d = math.hypot(x - cx, y - cy)
            if r_in <= d <= r_out:
                ang = math.degrees(math.atan2(y - cy, x - cx))
                # вырез-полумесяц справа: -50..50 градусов пустой
                if not (-48.0 < ang < 48.0):
                    put(px, x, y, MOON)
    for y in range(16):
        for x in range(16):
            d = math.hypot(x - cx, y - cy)
            if 4.4 <= d <= 5.6:
                ang = math.degrees(math.atan2(y - cy, x - cx))
                if not (-48.0 < ang < 48.0):
                    put(px, x, y, MOON_DARK)
    # светлые блики на внешней кромке
    for ang_deg in (150, 190, 230, 270, 310):
        a = math.radians(ang_deg)
        put(px, int(round(cx + math.cos(a) * 6.0)),
            int(round(cy + math.sin(a) * 6.0)), MOON_LIGHT)
        put(px, int(round(cx + math.cos(a) * 5.0)),
            int(round(cy + math.sin(a) * 5.0)), MOON_LIGHT)
    return outline(img)


def gen_moon_reaper() -> Image.Image:
    """Серп полумесяца: изогнутое лезвие-полумесяц, фиолетовая рукоять."""
    img = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    px = img.load()
    # лезвие — дуга от правого нижнего к левому верхнему
    cx, cy = 5.0, 9.5
    for t in range(0, 19):
        ang = math.radians(-150 + t * 9)
        r = 7.0
        x = cx + math.cos(ang) * r
        y = cy + math.sin(ang) * r
        put(px, int(round(x)), int(round(y)), MOON)
        put(px, int(round(x - math.cos(ang))), int(round(y - math.sin(ang))),
            MOON_LIGHT)
        put(px, int(round(x + math.cos(ang) * 0.6)),
            int(round(y + math.sin(ang) * 0.6)), MOON_DARK)
    # рукоять — из центра дуги вниз
    for i in range(6):
        put(px, 5, 8 + i, ABYSS_DARK)
        put(px, 6, 8 + i, ABYSS)
    put(px, 5, 14, VOID_CORE)
    put(px, 6, 14, VOID_CORE)
    put(px, 6, 7, ABYSS_LIGHT)
    return outline(img)


def gen_slash_arc() -> Image.Image:
    """Белая дуга взмаха 32x32 (для модуляции под цвет оружия).
    Толстая у середины, тонет на концах — читается как росчерк."""
    img = Image.new("RGBA", (32, 32), (0, 0, 0, 0))
    px = img.load()
    cx, cy = 16.0, 22.0
    for i in range(64):
        ang = math.radians(-215 + i * 4.4)     # сектор дуги ~280 градусов
        for r_frac in range(10):
            r = 8.0 + r_frac * 0.9
            x = cx + math.cos(ang) * r
            y = cy + math.sin(ang) * r
            # затухание к концам дуги
            t = i / 63.0
            fade = min(1.0, math.sin(t * math.pi) * 1.6 + 0.08)
            alpha = int(255 * max(0.15, fade))
            width = 3 if 0.25 < t < 0.75 else 2
            for w in range(width):
                put(px, int(round(x)) - w, int(round(y)),
                    (255, 255, 255, alpha), 32, 32)
    return img


def main() -> None:
    icons = {
        "rusty_dagger": gen_rusty_dagger,
        "axe_war": gen_axe_war,
        "warhammer": gen_warhammer,
        "staff_embers": gen_staff_embers,
        "orb_abyss": gen_orb_abyss,
        "chakram_moon": gen_chakram_moon,
        "moon_reaper": gen_moon_reaper,
    }
    out_dir = os.path.join(ROOT, "assets", "sprites", "icons")
    os.makedirs(out_dir, exist_ok=True)
    for name, gen in icons.items():
        path = os.path.join(out_dir, name + ".png")
        gen().save(path)
        print("OK", os.path.relpath(path, ROOT))
    fx_dir = os.path.join(ROOT, "assets", "sprites", "fx")
    os.makedirs(fx_dir, exist_ok=True)
    arc_path = os.path.join(fx_dir, "slash_arc.png")
    gen_slash_arc().save(arc_path)
    print("OK", os.path.relpath(arc_path, ROOT))


if __name__ == "__main__":
    main()
