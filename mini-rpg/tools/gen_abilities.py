# -*- coding: utf-8 -*-
"""Шаг 18: генерация арта способностей героев.

Пока это один спрайт — метательный топор варвара (16x16, выбрасывается
способностью Q «Метательный топор»). Остальные визуалы способностей
(вихрь, щит, барьер, пыль, газ) собираются из частиц и glow.png прямо
в сценах — текстуры им не нужны.

Запуск:  python3 tools/gen_abilities.py
Результат: assets/sprites/dungeon/throwing_axe.png
"""
import os
from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

OUTLINE = (24, 26, 34, 255)      # тёмный контур
STEEL = (186, 196, 210, 255)     # сталь
STEEL_LIGHT = (222, 230, 240, 255)
STEEL_DARK = (140, 150, 166, 255)
WOOD = (138, 90, 43, 255)        # рукоять
WOOD_LIGHT = (168, 112, 58, 255)
WRAP = (96, 62, 34, 255)         # обмотка у навершия


def put(px, x, y, color):
    if 0 <= x < 16 and 0 <= y < 16:
        px[x, y] = color


def gen_throwing_axe() -> Image.Image:
    """Метательный топор: двусторонняя стальная голова сверху,
    короткая деревянная рукоять вниз. Читается и в мире, и в данже."""
    img = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    px = img.load()

    # --- голова топора: два симметричных лезвия (ряды 2..7) ---
    blade_rows = {
        2: range(5, 11),
        3: range(3, 13),
        4: range(2, 14),
        5: range(2, 14),
        6: range(3, 13),
        7: range(5, 11),
    }
    for y, xs in blade_rows.items():
        for x in xs:
            put(px, x, y, STEEL)
        # светлая кромка по внешним краям лезвий
        put(px, min(xs), y, STEEL_LIGHT)
        put(px, max(xs), y, STEEL_LIGHT)
        # тень к центру
        put(px, 7, y, STEEL_DARK)
        put(px, 8, y, STEEL_DARK)
    # втулка поверх рукояти
    for y in range(3, 7):
        for x in range(7, 9):
            put(px, x, y, WRAP)

    # --- рукоять (ряды 7..14) ---
    for y in range(7, 15):
        put(px, 7, y, WOOD)
        put(px, 8, y, WOOD_LIGHT)

    # --- контур вокруг силуэта ---
    for y in range(16):
        for x in range(16):
            if px[x, y][3] == 0:
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    nx, ny = x + dx, y + dy
                    if 0 <= nx < 16 and 0 <= ny < 16 and px[nx, ny][3] != 0:
                        put(px, x, y, OUTLINE)
                        break
    return img


def main() -> None:
    out_dir = os.path.join(ROOT, "assets", "sprites", "dungeon")
    os.makedirs(out_dir, exist_ok=True)
    axe = gen_throwing_axe()
    axe_path = os.path.join(out_dir, "throwing_axe.png")
    axe.save(axe_path)
    print("OK", os.path.relpath(axe_path, ROOT))


if __name__ == "__main__":
    main()
