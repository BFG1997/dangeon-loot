# -*- coding: utf-8 -*-
"""Мини-библиотека пиксель-арта для «Dungeon Loot».
Рисование по пикселям, автообводка, палитры, сохранение листов."""
from PIL import Image

OUT = "/home/z/my-project/work/mini-rpg/assets"

# ---------------------------------------------------------------- палитра
INK = (20, 16, 28, 255)          # общая обводка (тёмно-фиолетовый, не чёрный)
INK_SOFT = (34, 28, 46, 255)

def C(r, g, b, a=255):
    return (r, g, b, a)

SKIN = C(236, 179, 134)
SKIN_SH = C(206, 138, 98)
SKIN_HI = C(249, 208, 172)

def shade(c, k):
    """Затемнить/осветлить цвет: k>0 светлее, k<0 темнее."""
    r, g, b, a = c
    if k >= 0:
        return C(min(255, int(r + (255 - r) * k)), min(255, int(g + (255 - g) * k)),
                 min(255, int(b + (255 - b) * k)), a)
    return C(int(r * (1 + k)), int(g * (1 + k)), int(b * (1 + k)), a)


class Cv:
    """Холст с пиксельными примитивами (координаты включительные)."""

    def __init__(self, w, h):
        self.w, self.h = w, h
        self.img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
        self.px_map = {}

    def P(self, x, y, c):
        if 0 <= x < self.w and 0 <= y < self.h:
            self.img.putpixel((x, y), c)
            self.px_map[(x, y)] = c

    def R(self, x0, y0, x1, y1, c):
        for y in range(y0, y1 + 1):
            for x in range(x0, x1 + 1):
                self.P(x, y, c)

    def HLINE(self, y, x0, x1, c):
        self.R(x0, y, x1, y, c)

    def VLINE(self, x, y0, y1, c):
        self.R(x, y0, x, y1, c)

    def has(self, x, y):
        return self.px_map.get((x, y), (0, 0, 0, 0))[3] > 0

    def outline(self, color=INK, inside=False):
        """Обводка силуэта: снаружи (inside=False) или по краю изнутри."""
        edges = []
        for (x, y), c in self.px_map.items():
            if inside:
                if any(not self.has(x + dx, y + dy) for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))):
                    edges.append((x, y))
            else:
                if any(self.has(x + dx, y + dy) for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))) \
                        and not self.has(x, y):
                    edges.append((x, y))
        for (x, y) in edges:
            self.P(x, y, color)

    def ellipse(self, cx, cy, rx, ry, c):
        for y in range(cy - ry, cy + ry + 1):
            for x in range(cx - rx, cx + rx + 1):
                if ((x - cx) / max(rx, 0.001)) ** 2 + ((y - cy) / max(ry, 0.001)) ** 2 <= 1.0:
                    self.P(x, y, c)

    def img_scaled(self, k, nearest=True):
        return self.img.resize((self.w * k, self.h * k), Image.NEAREST if nearest else Image.BILINEAR)


def save(img, rel):
    import os
    path = os.path.join(OUT, rel)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    img.save(path)
    print("  ->", rel, img.size)


def contact(cells, cell_w, cell_h, cols, scale=3, bg=(40, 40, 60, 255), labels=None):
    """Собрать превью-простыню из списка изображений."""
    from PIL import ImageDraw
    rows = (len(cells) + cols - 1) // cols
    sheet = Image.new("RGBA", (cols * cell_w * scale, rows * cell_h * scale), bg)
    d = ImageDraw.Draw(sheet)
    for i, img in enumerate(cells):
        x = (i % cols) * cell_w * scale
        y = (i // cols) * cell_h * scale
        if img.size != (cell_w, cell_h):
            k = max(1, min(cell_w // img.width, cell_h // img.height))
            img = img.resize((img.width * k, img.height * k), Image.NEAREST)
        else:
            img = img.resize((cell_w * scale, cell_h * scale), Image.NEAREST)
        sheet.paste(img, (x + 2, y + 2), img)
        if labels:
            d.text((x + 4, y + 4), labels[i], fill=(255, 255, 120, 255))
    return sheet
