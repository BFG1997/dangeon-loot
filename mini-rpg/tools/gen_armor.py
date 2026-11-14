# -*- coding: utf-8 -*-
"""Иконки экипировки «Dungeon Loot» (шаг 12): броня Вираса и одеяния Зорана.
Стиль и палитра — как в gen_world_art.py: 16x16, обводка INK, тени/блики.
Запуск: python3 tools/gen_armor.py
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from px import Cv, C, shade, save  # noqa: E402

# ------------------------------------------------------------- броня (куирасс)

def ic_armor(base, dark, light, trim=None):
    """Кираса: наплечники, грудь, пояс и юбка доспеха.
    base/dark/light — основной цвет металла/кожи и его грани."""
    if trim is None:
        trim = C(196, 152, 66)   # золотая фурнитура по умолчанию
    c = Cv(16, 16)
    # наплечники
    c.R(2, 3, 5, 6, base)
    c.R(10, 3, 13, 6, base)
    c.HLINE(3, 2, 5, light)
    c.HLINE(3, 10, 13, light)
    c.VLINE(2, 4, 6, dark)
    c.VLINE(13, 4, 6, dark)
    # грудь (ворот между наплечниками)
    c.R(5, 4, 10, 12, base)
    c.VLINE(5, 4, 12, light)            # блик слева
    c.VLINE(10, 4, 12, dark)            # тень справа
    c.HLINE(4, 5, 10, light)
    # вертикальный шов посередине
    c.VLINE(8, 6, 12, dark)
    c.P(8, 6, shade(base, 0.25))
    # вырез горловины
    c.R(6, 2, 9, 3, dark)
    c.HLINE(2, 6, 9, shade(dark, -0.25))
    # ремень с пряжкой
    c.R(4, 11, 11, 12, dark)
    c.R(7, 11, 8, 12, trim)
    c.P(7, 11, shade(trim, 0.3))
    # юбка доспеха (сегменты)
    c.R(4, 13, 11, 14, base)
    c.HLINE(13, 4, 11, light)
    c.VLINE(5, 13, 14, dark)
    c.VLINE(10, 13, 14, dark)
    c.P(3, 13, base)
    c.P(12, 13, base)
    c.outline()
    return c.img


def ic_armor_leather():
    # кожа: коричневая, с латунной фурнитурой
    return ic_armor(C(140, 96, 54), C(104, 68, 38), C(172, 124, 74), C(196, 152, 66))


def ic_armor_chain():
    # кольчуга: серые кольца — точки-«кольца» поверх стали
    c = ic_armor(C(150, 156, 170), C(108, 112, 128), C(186, 192, 206), C(120, 124, 140))
    img = c
    # «кольца» рисуем поверх готового силуэта — тёмные точки
    pmap = [(6, 6), (9, 6), (7, 8), (10, 8), (6, 10), (9, 10), (8, 13), (6, 14), (9, 14)]
    from PIL import Image
    for (x, y) in pmap:
        img.putpixel((x, y), C(120, 124, 140))
    return img


def ic_armor_plate():
    # латы: полированная сталь с золотой отделкой
    return ic_armor(C(178, 186, 202), C(126, 134, 152), C(222, 230, 244))


# ------------------------------------------------------------------ одеяния

def ic_robe(cloth, cloth_dark, cloth_light, trim, pattern):
    """Мантия: капюшон с пустой тенью лица, расширяющийся подол,
    золотая кайма и магический узор."""
    c = Cv(16, 16)
    # капюшон
    c.R(5, 1, 10, 5, cloth)
    c.HLINE(1, 5, 10, cloth_light)
    c.VLINE(5, 1, 5, cloth_light)
    c.VLINE(10, 1, 5, cloth_dark)
    # тень лица под капюшоном: внутри ничего не видно
    c.R(6, 3, 9, 5, C(24, 20, 36))
    c.P(7, 4, C(12, 10, 20))
    c.P(9, 3, C(12, 10, 20))
    # плечи и тело
    c.R(4, 5, 11, 9, cloth)
    c.VLINE(4, 5, 9, cloth_light)
    c.VLINE(11, 5, 9, cloth_dark)
    # рукава по бокам
    c.R(2, 6, 3, 10, cloth)
    c.R(12, 6, 13, 10, cloth)
    c.VLINE(2, 6, 10, cloth_light)
    c.VLINE(13, 6, 10, cloth_dark)
    # расширяющийся подол
    c.R(3, 10, 12, 14, cloth)
    c.R(2, 13, 13, 14, cloth_dark)
    c.HLINE(14, 2, 13, trim)            # золотая кайма
    c.HLINE(10, 3, 12, cloth_light)
    # узор на груди и подоле
    c.P(7, 7, pattern)
    c.P(9, 8, pattern)
    c.P(6, 12, pattern)
    c.P(10, 12, pattern)
    c.outline()
    return c.img


def ic_robe_faded():
    # выцветшая мантия: серо-голубая ткань, бледная серебряная кайма
    return ic_robe(C(120, 128, 152), C(88, 94, 118), C(148, 156, 180),
                   C(170, 176, 192), C(190, 200, 224))


def ic_robe_stars():
    # мантия звёздочёта: глубокая синева с золотыми звёздами
    return ic_robe(C(52, 66, 128), C(36, 46, 96), C(74, 90, 160),
                   C(196, 152, 66), C(255, 244, 180))


def ic_robe_void():
    # одеяние Пустоты: фиолетово-чёрная ткань с лиловыми вкраплениями
    return ic_robe(C(64, 44, 96), C(44, 28, 70), C(88, 62, 128),
                   C(186, 130, 255), C(150, 110, 220))


ICONS = {
    "armor_leather": ic_armor_leather,
    "armor_chain": ic_armor_chain,
    "armor_plate": ic_armor_plate,
    "robe_faded": ic_robe_faded,
    "robe_stars": ic_robe_stars,
    "robe_void": ic_robe_void,
}


def px_contact(cells):
    """Превью-лист иконок 16x16 (масштаб 4, подписи не нужны)."""
    from PIL import Image
    sheet = Image.new("RGBA", (len(cells) * 64 + (len(cells) - 1) * 8, 64),
                      (46, 48, 66, 255))
    for i, img in enumerate(cells):
        big = img.resize((64, 64), Image.NEAREST)
        sheet.alpha_composite(big, (i * 72, 0))
    return sheet


if __name__ == "__main__":
    for iid, fn in ICONS.items():
        save(fn(), "sprites/icons/%s.png" % iid)
    # превью для быстрой проверки (в /tmp, в проект не попадает)
    cells = [fn() for fn in ICONS.values()]
    save(px_contact(cells), "/tmp/armor_icons_preview.png")
    print("OK: %d иконок экипировки" % len(ICONS))
