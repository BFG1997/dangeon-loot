# -*- coding: utf-8 -*-
"""Тайлсет 128x128 (8x8 тайлов 16px), пропы, иконки предметов для «Dungeon Loot»."""
import sys, random
sys.path.insert(0, "/home/z/my-project/scripts")
from px import *

T = 16
random.seed(4)


def tile(fn):
    c = Cv(T, T)
    fn(c)
    return c.img


# ---------------------------------------------------------------- тайлы
def t_wall(c):
    """Кладка стены замка."""
    c.R(0, 0, 15, 15, C(52, 50, 70))                    # раствор
    bricks = [(0, 0, 7, 4), (8, 0, 15, 4), (0, 5, 3, 9), (4, 5, 11, 9), (12, 5, 15, 9),
              (0, 10, 7, 14), (8, 10, 15, 14), (0, 15, 3, 15), (4, 15, 11, 15), (12, 15, 15, 15)]
    for (x0, y0, x1, y1) in bricks:
        c.R(x0, y0, x1, y1, C(96, 94, 116))
        c.HLINE(y0, x0, x1, C(118, 116, 138))
        c.VLINE(x1, y0, y1, C(76, 74, 94))
        c.P(x0, y1, C(76, 74, 94))


def t_wall_v(c):
    t_wall(c)
    c.R(4, 6, 6, 9, C(66, 64, 84))                      # трещина
    c.P(7, 10, C(66, 64, 84))


def t_window(c):
    t_wall(c)
    c.R(3, 2, 12, 13, C(40, 38, 58))                    # арка: рама
    c.R(4, 1, 11, 12, C(30, 28, 48))
    c.HLINE(1, 5, 10, C(30, 28, 48))
    c.R(5, 2, 10, 11, C(12, 10, 24))                    # космос в окне
    c.P(6, 4, C(210, 220, 255)); c.P(9, 7, C(160, 180, 240)); c.P(7, 9, C(240, 240, 250))
    c.VLINE(7, 2, 11, C(40, 38, 58)); c.HLINE(7, 5, 10, C(40, 38, 58))  # переплёт
    c.HLINE(0, 3, 12, C(118, 116, 138)); c.HLINE(13, 4, 11, C(118, 116, 138))
    c.P(4, 1, C(118, 116, 138)); c.P(11, 1, C(118, 116, 138))


def t_door(c):
    t_wall(c)
    c.R(2, 0, 13, 15, C(64, 60, 80))                    # каменная рама
    c.R(3, 1, 12, 15, C(92, 62, 38))                    # дерево
    for x in (5, 8, 11):
        c.VLINE(x, 1, 15, C(72, 48, 30))
    c.HLINE(1, 3, 12, C(72, 48, 30))
    for y in (4, 11):                                   # железные полосы
        c.R(3, y, 12, y + 1, C(116, 122, 136))
        c.HLINE(y, 3, 12, C(146, 152, 166))
    c.R(6, 7, 9, 9, C(150, 156, 170))                   # ригель
    c.P(7, 8, C(190, 196, 210))


def t_pillar(c):
    c.R(0, 0, 15, 15, C(172, 172, 188))
    c.R(4, 0, 11, 12, C(150, 150, 168))
    c.VLINE(4, 0, 12, C(126, 126, 144)); c.VLINE(11, 0, 12, C(190, 190, 204))
    c.VLINE(6, 0, 12, C(136, 136, 154)); c.VLINE(9, 0, 12, C(182, 182, 196))
    c.R(2, 12, 13, 15, C(140, 140, 158))                # база
    c.HLINE(12, 3, 12, C(196, 196, 210))
    c.HLINE(15, 2, 13, C(112, 112, 130))
    c.HLINE(0, 0, 15, C(196, 196, 210))


def t_outer(c):
    """Внешняя стена замка: крупные блоки."""
    c.R(0, 0, 15, 15, C(56, 54, 74))
    for (x0, y0, x1, y1) in [(0, 0, 15, 6), (0, 7, 15, 15)]:
        c.R(x0, y0, x1, y1, C(118, 116, 134))
        c.HLINE(y0, x0, x1, C(140, 138, 156))
        c.HLINE(y1, x0, x1, C(96, 94, 112))
    c.VLINE(7, 0, 6, C(100, 98, 116)); c.VLINE(4, 7, 15, C(100, 98, 116))
    c.P(12, 2, C(140, 138, 156)); c.P(3, 10, C(140, 138, 156))


def t_fence(c):
    c.R(0, 0, 15, 15, (0, 0, 0, 0))
    c.R(2, 2, 6, 15, C(122, 92, 56))                    # доска
    c.R(9, 2, 13, 15, C(122, 92, 56))
    c.P(2, 1, C(122, 92, 56)); c.P(9, 1, C(122, 92, 56))
    c.P(4, 1, C(122, 92, 56)); c.P(11, 1, C(122, 92, 56))
    c.P(4, 0, C(140, 108, 68)); c.P(11, 0, C(140, 108, 68))
    c.VLINE(6, 2, 15, C(94, 70, 42)); c.VLINE(13, 2, 15, C(94, 70, 42))
    c.R(0, 5, 15, 7, C(108, 80, 48))                    # перекладина
    c.HLINE(5, 0, 15, C(134, 102, 62))


def t_railing(c):
    c.R(0, 0, 15, 15, (0, 0, 0, 0))
    c.R(0, 2, 15, 4, C(212, 164, 62))                   # поручень
    c.HLINE(2, 0, 15, C(244, 204, 110))
    c.HLINE(4, 0, 15, C(160, 120, 44))
    for x in (2, 7, 12):                                # стойки
        c.R(x, 5, x + 1, 13, C(180, 136, 52))
        c.VLINE(x, 5, 13, C(244, 204, 110))
    c.R(0, 13, 15, 15, C(150, 114, 46))
    c.HLINE(13, 0, 15, C(190, 148, 56))


def marble(c, light=True):
    base = C(178, 178, 194) if light else C(128, 128, 148)
    line = C(150, 150, 168) if light else C(104, 104, 124)
    c.R(0, 0, 15, 15, base)
    c.HLINE(0, 0, 15, line); c.VLINE(0, 0, 15, line)
    c.HLINE(15, 0, 15, shade(base, -0.08)); c.VLINE(15, 0, 15, shade(base, -0.08))
    for _ in range(5):
        x, y = random.randrange(1, 15), random.randrange(1, 15)
        c.P(x, y, shade(base, 0.12 if random.random() > 0.5 else -0.12))


def t_carpet(c):
    c.R(0, 0, 15, 15, C(172, 44, 58))
    c.HLINE(0, 0, 15, C(212, 92, 84)); c.VLINE(0, 0, 15, C(212, 92, 84))
    c.HLINE(15, 0, 15, C(128, 28, 40)); c.VLINE(15, 0, 15, C(128, 28, 40))
    # ромб-узор
    c.P(7, 5, C(238, 196, 96)); c.P(8, 5, C(238, 196, 96))
    c.P(6, 6, C(238, 196, 96)); c.P(9, 6, C(238, 196, 96))
    c.P(7, 7, C(238, 196, 96)); c.P(8, 7, C(238, 196, 96))
    c.P(5, 12, C(198, 60, 72)); c.P(10, 12, C(198, 60, 72))


def t_path(c):
    """Брусчатка двора."""
    c.R(0, 0, 15, 15, C(96, 94, 110))
    stones = [(0, 0, 6, 6), (7, 0, 15, 4), (7, 5, 12, 9), (13, 5, 15, 9),
              (0, 7, 5, 12), (6, 10, 11, 15), (12, 10, 15, 15), (0, 13, 5, 15)]
    for (x0, y0, x1, y1) in stones:
        c.R(x0, y0, x1, y1, C(138, 134, 152))
        c.HLINE(y0, x0, x1, C(160, 156, 174))
        c.VLINE(x1, y0, y1, C(114, 110, 128))


def t_dirt(c):
    c.R(0, 0, 15, 15, C(134, 108, 76))
    for _ in range(14):
        x, y = random.randrange(16), random.randrange(16)
        c.P(x, y, C(114, 90, 62) if random.random() > 0.5 else C(150, 124, 88))
    c.HLINE(0, 0, 15, C(122, 98, 68))


def t_grass(c, flowers=False):
    c.R(0, 0, 15, 15, C(94, 146, 78))
    for _ in range(10):
        x, y = random.randrange(16), random.randrange(16)
        c.VLINE(x, y, y + 1, C(74, 122, 62))
    for _ in range(4):
        x, y = random.randrange(16), random.randrange(16)
        c.P(x, y, C(116, 166, 96))
    if flowers:
        for (fx, fy, fc) in [(3, 4, C(244, 240, 190)), (11, 3, C(238, 160, 180)),
                             (7, 10, C(244, 240, 190)), (13, 12, C(240, 220, 250))]:
            c.P(fx, fy, fc); c.P(fx + 1, fy, fc)
            c.P(fx, fy + 1, C(210, 200, 140))


def t_void(c, seed=0):
    c.R(0, 0, 15, 15, C(10, 8, 22))
    rnd = random.Random(seed)
    for _ in range(7):
        x, y = rnd.randrange(16), rnd.randrange(16)
        b = rnd.choice([C(200, 210, 240), C(150, 160, 210), C(240, 240, 250), C(120, 110, 180)])
        c.P(x, y, b)


def t_pot(c):
    marble(c)
    c.R(4, 8, 11, 14, C(178, 108, 66))                  # горшок
    c.R(5, 7, 10, 8, C(198, 126, 78))
    c.HLINE(14, 4, 11, C(140, 82, 48))
    c.VLINE(4, 8, 13, C(150, 88, 52))
    c.R(5, 3, 10, 7, C(88, 150, 84))                    # растение
    c.P(6, 2, C(108, 172, 100)); c.P(9, 2, C(108, 172, 100))
    c.P(7, 4, C(108, 172, 100)); c.P(8, 4, C(108, 172, 100))
    c.P(7, 2, C(250, 224, 234)); c.P(8, 3, C(250, 224, 234))  # цветок
    c.P(5, 5, C(74, 128, 72))


def t_slab(c):
    """Плита с звёздной мозаикой (тронная)."""
    marble(c)
    c.P(6, 6, C(110, 130, 200)); c.P(9, 6, C(110, 130, 200))
    c.P(7, 7, C(150, 170, 230)); c.P(8, 7, C(150, 170, 230))
    c.P(6, 8, C(110, 130, 200)); c.P(9, 8, C(110, 130, 200))


# ---------------------------------------------------------------- сборка тайлсета
def build_tiles():
    sheet = Image.new("RGBA", (128, 128), (0, 0, 0, 0))
    grid = {
        (0, 0): t_wall, (1, 0): t_wall_v, (2, 0): t_window, (3, 0): t_door,
        (4, 0): t_pillar, (5, 0): t_outer, (6, 0): t_fence, (7, 0): t_railing,
        (0, 1): lambda c: marble(c, True), (1, 1): lambda c: marble(c, False),
        (2, 1): t_carpet, (3, 1): t_path, (4, 1): t_dirt,
        (5, 1): t_grass, (6, 1): lambda c: t_grass(c, True), (7, 1): lambda c: t_void(c, 1),
        (0, 2): t_pot, (1, 2): t_slab, (2, 2): lambda c: t_void(c, 2),
        (3, 2): lambda c: t_void(c, 3), (4, 2): lambda c: t_void(c, 4),
        (5, 2): lambda c: t_void(c, 5), (6, 2): lambda c: t_void(c, 6),
        (7, 2): lambda c: t_void(c, 7),
    }
    for (cx, cy), fn in grid.items():
        sheet.paste(tile(fn), (cx * T, cy * T))
    return sheet


# ---------------------------------------------------------------- пропы
def p_arch():
    """Ворота замка 64x26."""
    c = Cv(64, 26)
    stone, stone_d, stone_hi = C(120, 118, 136), C(88, 86, 104), C(148, 146, 164)
    # боковые башни
    for x0 in (0, 56):
        c.R(x0, 2, x0 + 7, 25, stone)
        c.R(x0, 0, x0 + 7, 2, stone_hi)
        for bx in range(x0, x0 + 8, 4):
            c.P(bx, 0, stone); c.P(bx + 1, 0, stone_d)
        c.VLINE(x0 + 7, 2, 25, stone_d)
    # арка
    c.R(8, 10, 55, 25, stone)
    c.R(10, 4, 53, 10, stone)
    for (x, y) in [(10, 4), (53, 4), (10, 5), (53, 5), (11, 4), (52, 4)]:
        c.P(x, y, (0, 0, 0, 0))
    c.R(14, 8, 49, 25, (0, 0, 0, 0))                    # проём
    c.R(12, 6, 51, 7, (0, 0, 0, 0))
    c.HLINE(6, 12, 51, stone_hi)
    c.VLINE(8, 10, 25, stone_d); c.VLINE(55, 10, 25, stone_d)
    c.VLINE(13, 8, 25, stone_hi); c.VLINE(50, 8, 25, stone_d)
    # открытые створки
    wd, wd_d = C(104, 72, 44), C(80, 54, 34)
    c.R(14, 12, 20, 25, wd); c.R(43, 12, 49, 25, wd)
    c.VLINE(20, 12, 25, wd_d); c.VLINE(43, 12, 25, wd_d)
    c.P(17, 15, C(212, 164, 62)); c.P(46, 15, C(212, 164, 62))
    # зубцы сверху
    for bx in range(9, 56, 6):
        c.R(bx, 2, bx + 3, 4, stone)
        c.HLINE(2, bx, bx + 3, stone_hi)
    c.outline()
    return c.img


def p_throne():
    """Трон 32x32."""
    c = Cv(32, 32)
    gold, gold_d, gold_hi = C(212, 168, 62), C(160, 122, 44), C(246, 208, 110)
    red, red_d = C(168, 40, 54), C(126, 28, 40)
    c.R(4, 2, 27, 31, gold)                             # спинка
    c.R(6, 4, 25, 31, red)
    c.R(8, 6, 23, 28, red_d)
    c.R(10, 8, 21, 26, red)                             # подушка
    c.HLINE(4, 6, 25, gold_hi)
    c.VLINE(27, 2, 31, gold_d)
    for (x, y) in [(4, 2), (27, 2)]:
        c.P(x, y, (0, 0, 0, 0))
    c.R(2, 0, 5, 3, gold); c.R(26, 0, 29, 3, gold)      # шпили
    c.P(3, 0, gold_hi); c.P(27, 0, gold_hi)
    c.P(15, 12, gold); c.P(16, 12, gold)                # узор
    c.P(14, 13, gold); c.P(17, 13, gold)
    c.P(15, 14, gold); c.P(16, 14, gold)
    c.R(4, 28, 27, 31, gold_d)                          # основание
    c.HLINE(28, 4, 27, gold_hi)
    c.outline()
    return c.img


def p_fountain(frame=0):
    """Фонтан 32x32, 3 кадра воды."""
    c = Cv(32, 32)
    stone, stone_d, stone_hi = C(150, 148, 164), C(112, 110, 128), C(184, 182, 196)
    water, water_hi = C(96, 168, 220), C(170, 220, 246)
    c.R(2, 20, 29, 29, stone)                           # чаша
    c.HLINE(20, 2, 29, stone_hi)
    c.R(2, 18, 29, 19, stone_hi)
    c.VLINE(29, 20, 29, stone_d)
    c.R(4, 22, 27, 26, water)                           # вода в чаше
    for i, x in enumerate(range(5, 27, 2)):
        dy = (frame + i) % 3
        c.P(x, 22 + dy, water_hi)
    c.R(13, 10, 18, 20, stone)                          # колонна
    c.VLINE(18, 10, 20, stone_d)
    c.HLINE(10, 13, 18, stone_hi)
    c.R(12, 8, 19, 9, stone)                            # верхняя чаша
    c.HLINE(8, 12, 19, stone_hi)
    c.R(13, 6, 18, 7, water)
    c.P(14 + frame % 2, 5, water_hi); c.P(16, 4 + frame % 2, water_hi)
    # струи
    for i in range(4):
        x = 11 + i * 3
        h = 3 + ((frame + i) % 3)
        c.VLINE(x, 11 - h, 10, water_hi)
    c.R(6, 26, 25, 29, stone_d)
    c.outline()
    return c.img


def p_torch(frame=0):
    """Настенный факел 16x24."""
    c = Cv(16, 24)
    c.R(6, 10, 9, 20, C(94, 66, 44))                    # держатель
    c.VLINE(9, 10, 20, C(70, 48, 32))
    c.R(4, 8, 11, 10, C(120, 124, 138))                 # обод
    c.R(5, 6, 10, 8, C(60, 56, 76))                     # угли
    f = [(5, 2, 9, 7), (6, 1, 8, 5), (7, 0, 8, 3)][frame % 3]
    c.R(f[0], f[1], f[2], f[3], C(248, 168, 62))        # пламя
    c.R(f[0] + 1, f[1] + 1, f[2] - 1, f[3] - 1, C(252, 216, 110))
    c.P(7, 4 + frame % 2, C(255, 246, 190))
    c.outline()
    return c.img


def p_brazier(frame=0):
    """Жаровня 16x22."""
    c = Cv(16, 22)
    c.R(7, 14, 8, 18, C(100, 98, 116))                  # ножка
    c.R(5, 18, 10, 20, C(120, 118, 136))
    c.R(3, 6, 12, 13, C(140, 138, 154))                 # чаша
    c.HLINE(6, 3, 12, C(172, 170, 186))
    c.VLINE(12, 6, 13, C(104, 102, 120))
    c.R(4, 4, 11, 6, C(200, 110, 40))                   # угли
    c.P(5, 5, C(252, 190, 70)); c.P(9, 4, C(252, 190, 70))
    if frame != 1:
        c.P(6, 2, C(252, 216, 110)); c.P(9, 1 + frame % 2, C(252, 190, 70))
    if frame == 2:
        c.P(7, 0, C(252, 240, 160))
    c.outline()
    return c.img


def p_forge(frame=0):
    """Горн Вираса 32x24."""
    c = Cv(32, 24)
    stone, stone_d = C(108, 104, 122), C(84, 80, 98)
    c.R(0, 8, 31, 23, stone)
    c.HLINE(8, 0, 31, C(132, 128, 146))
    c.VLINE(31, 8, 23, stone_d)
    c.R(4, 4, 20, 8, stone_d)                           # дымоход
    c.VLINE(4, 4, 8, C(132, 128, 146))
    c.R(6, 14, 22, 19, C(40, 36, 52))                   # топка
    glow = [C(200, 90, 40), C(240, 140, 50), C(252, 190, 70)][frame % 3]
    c.R(8, 16, 20, 19, glow)
    c.R(10, 15, 18, 16, C(252, 216, 110) if frame == 2 else glow)
    c.P(12, 14, C(252, 240, 160))
    c.R(24, 12, 30, 15, C(120, 124, 138))               # наковальня-упор
    c.outline()
    return c.img


def p_cart():
    """Тележка Гуры 48x26."""
    c = Cv(48, 26)
    wd, wd_d = C(148, 104, 60), C(112, 76, 44)
    c.R(4, 10, 43, 19, wd)                              # корпус
    c.HLINE(10, 4, 43, C(172, 126, 76))
    c.VLINE(43, 10, 19, wd_d)
    c.R(0, 12, 4, 14, wd_d)                             # ручка
    c.R(6, 5, 41, 10, C(238, 238, 244))                 # навес-тент
    for i, x in enumerate(range(6, 41, 6)):
        c.R(x, 5, x + 2, 10, C(216, 84, 84) if i % 2 == 0 else C(238, 238, 244))
    c.HLINE(5, 6, 41, C(180, 60, 60))
    c.P(14, 3, C(210, 180, 90)); c.P(15, 2, C(230, 200, 110))  # флажок
    c.R(15, 4, 15, 5, C(120, 90, 60))
    c.R(10, 0, 18, 4, (0, 0, 0, 0))
    # кастрюля и окорок на прилавке
    c.R(12, 6, 20, 10, C(140, 146, 160))
    c.R(13, 5, 19, 6, C(170, 176, 190))
    c.R(28, 7, 36, 10, C(198, 120, 84))                 # окорок
    c.P(34, 8, C(232, 168, 130))
    c.R(8, 20, 14, 25, C(70, 64, 58))                   # колесо
    c.R(10, 22, 12, 24, C(46, 42, 40))
    c.R(32, 20, 38, 25, C(70, 64, 58))
    c.R(34, 22, 36, 24, C(46, 42, 40))
    c.outline()
    return c.img


def p_stand_zlus():
    """Стойка зелий Злуса 16x26."""
    c = Cv(16, 26)
    wd, wd_d = C(110, 78, 52), C(84, 58, 40)
    c.R(2, 10, 13, 14, wd)                              # полка
    c.HLINE(10, 2, 13, C(136, 98, 66))
    c.R(3, 14, 4, 24, wd_d); c.R(11, 14, 12, 24, wd_d)
    c.R(2, 24, 13, 25, wd)
    c.R(3, 4, 6, 10, C(126, 224, 242))                  # зелья
    c.P(4, 3, C(90, 60, 40)); c.P(5, 3, C(90, 60, 40))
    c.R(8, 5, 10, 10, C(226, 120, 200))
    c.P(9, 4, C(90, 60, 40))
    c.R(5, 16, 6, 20, C(180, 120, 230))                 # зелья внизу
    c.R(9, 17, 10, 20, C(120, 220, 160))
    c.P(12, 1, C(170, 130, 250)); c.P(13, 2, C(200, 160, 255))  # искра
    c.outline()
    return c.img


def p_stall(color="red"):
    """Рыночный прилавок 48x24."""
    c = Cv(48, 24)
    aw = C(216, 84, 84) if color == "red" else C(84, 130, 208)
    aw2 = C(238, 238, 244)
    wd = C(122, 92, 56)
    for i, x in enumerate(range(0, 48, 8)):             # тент
        c.R(x, 0, x + 3, 6, aw)
        c.R(x + 4, 0, x + 7, 6, aw2)
    c.HLINE(6, 0, 47, shade(aw, -0.3))
    c.R(2, 6, 3, 18, wd); c.R(44, 6, 45, 18, wd)        # стойки
    c.R(1, 12, 46, 19, wd)                              # прилавок
    c.HLINE(12, 1, 46, C(150, 114, 70))
    c.R(2, 20, 45, 23, C(96, 72, 46))
    c.R(8, 7, 14, 11, C(198, 120, 84))                  # товар
    c.R(24, 7, 30, 11, C(126, 224, 242))
    c.R(36, 8, 42, 11, C(198, 168, 90))
    c.outline()
    return c.img


def p_anvil():
    """Наковальня Вираса 16x14."""
    c = Cv(16, 14)
    met, met_d, met_hi = C(126, 132, 148), C(88, 94, 110), C(172, 178, 192)
    c.R(2, 2, 13, 5, met)                               # рог-верх
    c.R(1, 3, 14, 4, met)
    c.P(0, 4, met)
    c.HLINE(2, 2, 13, met_hi)
    c.R(4, 6, 11, 8, met_d)                             # шейка
    c.R(3, 9, 12, 11, met)                              # основание
    c.HLINE(9, 3, 12, met_hi)
    c.R(2, 12, 13, 13, met_d)
    c.P(12, 3, met_d)
    c.outline()
    return c.img


def p_barrel():
    c = Cv(16, 16)
    c.R(2, 2, 13, 15, C(134, 96, 58))
    c.HLINE(2, 2, 13, C(160, 118, 72))
    c.VLINE(2, 2, 15, C(106, 74, 44)); c.VLINE(13, 2, 15, C(106, 74, 44))
    for y in (4, 10):
        c.R(1, y, 14, y + 1, C(96, 98, 112))
        c.HLINE(y, 1, 14, C(126, 128, 142))
    c.P(7, 6, C(106, 74, 44)); c.P(8, 7, C(106, 74, 44))
    c.outline()
    return c.img


def p_crate():
    c = Cv(16, 16)
    c.R(1, 2, 14, 15, C(142, 104, 62))
    c.HLINE(2, 1, 14, C(168, 128, 78))
    c.VLINE(14, 2, 15, C(110, 80, 48))
    c.HLINE(7, 1, 14, C(110, 80, 48)); c.VLINE(7, 2, 15, C(110, 80, 48))
    c.P(2, 2, C(168, 128, 78)); c.P(13, 2, C(168, 128, 78))
    c.outline()
    return c.img


def p_sacks():
    c = Cv(16, 12)
    c.ellipse(5, 8, 4, 3, C(168, 138, 88))
    c.ellipse(11, 9, 4, 2, C(150, 122, 76))
    c.P(5, 4, C(120, 96, 58)); c.P(6, 4, C(120, 96, 58))
    c.P(4, 5, C(120, 96, 58))
    c.outline()
    return c.img


def p_bench():
    c = Cv(32, 16)
    wd, wd_d = C(134, 98, 60), C(102, 74, 46)
    c.R(1, 5, 30, 9, wd)
    c.HLINE(5, 1, 30, C(160, 122, 76))
    c.R(3, 10, 5, 15, wd_d); c.R(26, 10, 28, 15, wd_d)
    c.outline()
    return c.img


def p_lantern():
    """Фонарь на столбе 16x32."""
    c = Cv(16, 32)
    c.R(7, 12, 8, 30, C(70, 68, 84))                    # столб
    c.R(5, 30, 10, 31, C(96, 94, 110))
    c.R(4, 4, 11, 12, C(110, 106, 124))                 # корпус
    c.R(5, 5, 10, 11, C(252, 216, 120))                 # стекло
    c.P(6, 6, C(255, 244, 190)); c.P(9, 8, C(255, 244, 190))
    c.R(3, 3, 12, 4, C(140, 136, 152))                  # крышка
    c.P(7, 1, C(140, 136, 152)); c.P(8, 1, C(140, 136, 152))
    c.R(4, 12, 11, 13, C(140, 136, 152))
    # тёплое сияние
    for y in range(0, 24):
        for x in range(0, 16):
            d = ((x - 7.5) ** 2 + (y - 8) ** 2) ** 0.5
            if d < 9 and not c.has(x, y):
                a = int(60 * max(0, 1 - d / 9.0) ** 2)
                c.P(x, y, C(255, 214, 130, a))
    c.outline()
    return c.img


def p_crystal(violet=False, frame=0):
    """Кристалл 16x22, 2 кадра пульса."""
    c = Cv(16, 22)
    base = C(150, 110, 226) if violet else C(96, 190, 226)
    hi = C(216, 196, 255) if violet else C(190, 240, 252)
    dk = C(104, 74, 168) if violet else C(58, 136, 172)
    c.R(5, 6, 10, 18, base)
    c.R(6, 3, 9, 6, base)
    c.P(7, 1, base); c.P(8, 1, base)
    c.VLINE(10, 6, 18, dk); c.VLINE(5, 8, 18, dk)
    c.VLINE(7, 4, 12, hi)
    c.R(2, 16, 5, 20, dk); c.R(11, 14, 14, 19, dk)      # осколки
    c.P(3, 14, dk); c.P(12, 12, dk)
    if frame == 1:
        c.P(4, 5, hi); c.P(12, 8, hi)
        c.P(7, 0, hi)
    c.outline()
    return c.img


def p_planet():
    """Планета с кольцом 64x64."""
    c = Cv(64, 64)
    body, body_d, body_hi = C(96, 130, 200), C(64, 92, 156), C(140, 176, 232)
    band = C(200, 160, 90)
    c.ellipse(32, 34, 20, 19, body)
    for y in range(15, 54):                             # полосы и пятна
        for x in range(12, 52):
            if c.has(x, y):
                t = (y + x) % 7
                if t == 0:
                    c.P(x, y, body_d)
                elif t == 3 and (x - 32) ** 2 + (y - 34) ** 2 < 300:
                    c.P(x, y, body_hi)
    c.ellipse(24, 28, 4, 3, C(120, 200, 180))           # материки
    c.ellipse(40, 40, 5, 3, C(120, 200, 180))
    c.ellipse(38, 24, 3, 2, C(120, 200, 180))
    c.P(26, 27, C(160, 226, 200)); c.P(39, 39, C(160, 226, 200))
    # кольцо (эллипс, передняя дуга поверх планеты, задняя скрыта)
    import math
    for i in range(180):
        th = i * math.pi / 90.0
        x = int(32 + 29 * math.cos(th))
        y = int(36 + 9 * math.sin(th))
        if not (0 <= x < 64 and 0 <= y < 64):
            continue
        behind = math.sin(th) < 0  # верхняя половина за планетой
        if behind:
            if ((x - 32) / 21.0) ** 2 + ((y - 34) / 20.0) ** 2 <= 1.0:
                continue                      # скрыто планетой
        col = band if (i // 6) % 2 == 0 else C(230, 196, 120)
        c.P(x, y, col)
        if not behind:
            c.P(x, y + 1, shade(col, -0.25))
    c.outline()
    return c.img


def p_moon():
    c = Cv(12, 12)
    c.ellipse(6, 6, 5, 5, C(202, 200, 214))
    c.ellipse(5, 5, 4, 4, C(226, 224, 236))
    c.ellipse(7, 8, 1, 1, C(170, 168, 186)); c.ellipse(4, 4, 1, 1, C(170, 168, 186))
    return c.img


def p_asteroid(seed=0):
    rnd = random.Random(seed)
    c = Cv(14, 12)
    c.ellipse(7, 6, 6, 5, C(118, 112, 132))
    c.ellipse(6, 5, 4, 3, C(146, 140, 160))
    for _ in range(4):
        x, y = 4 + rnd.randrange(6), 3 + rnd.randrange(5)
        c.P(x, y, C(92, 88, 106))
    return c.img


def p_island():
    """Парящий остров 48x30."""
    c = Cv(48, 30)
    c.R(8, 8, 39, 14, C(94, 146, 78))                   # трава
    c.HLINE(8, 10, 37, C(116, 168, 96))
    c.R(6, 14, 41, 18, C(118, 112, 132))                # земля
    c.R(12, 18, 35, 22, C(96, 90, 110))
    c.R(18, 22, 29, 25, C(78, 72, 92))                  # остов
    c.P(22, 25, C(78, 72, 92)); c.P(26, 25, C(78, 72, 92))
    c.P(20, 4, C(108, 172, 100))                        # кустик
    c.R(19, 6, 21, 8, C(94, 146, 78))
    c.P(30, 5, C(250, 224, 234)); c.P(29, 6, C(250, 224, 234))
    c.outline()
    return c.img


def p_banner(color="red"):
    """Знамя 16x30."""
    c = Cv(16, 30)
    main = C(196, 44, 60) if color == "red" else C(70, 96, 180)
    c.R(4, 2, 11, 26, main)
    c.HLINE(2, 4, 11, C(150, 150, 166))                 # крепление
    c.P(4, 24, main); c.P(11, 24, main)                 # хвосты
    c.P(3, 25, main); c.P(12, 25, main)
    c.P(5, 10, C(238, 196, 96)); c.P(10, 10, C(238, 196, 96))
    c.P(6, 11, C(238, 196, 96)); c.P(9, 11, C(238, 196, 96))
    c.P(7, 12, C(238, 196, 96)); c.P(8, 12, C(238, 196, 96))  # эмблема-ромб
    c.VLINE(4, 3, 25, shade(main, -0.28))
    c.outline()
    return c.img


def p_shadow():
    c = Cv(24, 10)
    c.ellipse(12, 5, 10, 4, (0, 0, 0, 70))
    c.ellipse(12, 5, 7, 3, (0, 0, 0, 60))
    return c.img


def p_pointer():
    """Золотой указатель над NPC 10x8."""
    c = Cv(10, 8)
    c.R(2, 0, 7, 3, C(246, 208, 110))
    c.R(3, 4, 6, 4, C(246, 208, 110))
    c.P(4, 5, C(246, 208, 110)); c.P(5, 5, C(246, 208, 110))
    c.P(4, 6, C(212, 168, 62))
    c.P(3, 1, C(255, 240, 170))
    c.outline()
    return c.img


# ---------------------------------------------------------------- иконки
def ic_ham():
    c = Cv(16, 16)
    c.ellipse(8, 9, 6, 5, C(198, 120, 84))
    c.ellipse(8, 9, 4, 3, C(232, 168, 130))
    c.ellipse(8, 9, 2, 2, C(244, 210, 180))
    c.R(11, 3, 13, 5, C(236, 226, 210))                 # косточка
    c.P(10, 5, C(236, 226, 210))
    c.outline()
    return c.img


def ic_beer():
    c = Cv(16, 16)
    c.R(4, 5, 11, 14, C(214, 148, 52))
    c.HLINE(5, 4, 11, C(238, 176, 84))
    c.R(3, 2, 12, 5, C(252, 232, 160))                  # пена
    c.P(2, 4, C(252, 232, 160)); c.P(13, 4, C(252, 232, 160))
    c.P(5, 1, C(252, 232, 160)); c.P(10, 1, C(252, 232, 160))
    c.R(12, 7, 14, 12, C(196, 130, 44))                 # ручка
    c.VLINE(14, 7, 12, C(160, 104, 36))
    c.outline()
    return c.img


# --- шаг 6: напитки Глота (ряд растёт: цена и хп) + магическое оружие Зорана ---
def ic_drink_cv(liquid, liquid_hi):
    """Заготовка стакана напитка: стекло, жидкость, блик. Без обводки."""
    c = Cv(16, 16)
    c.R(4, 3, 11, 14, C(178, 206, 226, 200))            # стекло
    c.R(5, 5, 10, 13, liquid)
    c.HLINE(6, 5, 10, liquid_hi)
    c.P(5, 5, shade(liquid_hi, 0.25))
    c.R(3, 14, 12, 15, C(140, 146, 164))                # дно
    c.VLINE(11, 6, 13, shade(liquid, -0.25))
    return c


def ic_water():
    c = ic_drink_cv(C(120, 170, 228), C(160, 208, 246))
    c.outline()
    return c.img


def ic_mors():
    c = ic_drink_cv(C(198, 74, 92), C(232, 118, 130))
    c.P(6, 2, C(140, 40, 60)); c.P(9, 1, C(140, 40, 60))     # ягодка на ободке
    c.P(7, 1, C(60, 130, 70))
    c.outline()
    return c.img


def ic_juice():
    c = ic_drink_cv(C(232, 148, 52), C(250, 190, 96))
    c.outline()
    return c.img


def ic_wand_lightning():
    c = Cv(16, 16)
    c.VLINE(8, 7, 15, C(96, 66, 44))                    # рукоять
    c.R(6, 5, 10, 7, C(150, 110, 220))                  # головка
    c.P(7, 5, C(222, 200, 255)); c.P(9, 6, C(222, 200, 255))
    # молния из головки
    c.P(8, 2, C(250, 230, 120)); c.P(7, 3, C(250, 230, 120))
    c.P(9, 3, C(250, 230, 120)); c.P(8, 4, C(250, 230, 120))
    c.P(6, 1, C(250, 230, 120)); c.P(11, 2, C(250, 230, 120))
    c.P(5, 4, C(200, 170, 90)); c.P(12, 5, C(200, 170, 90))
    c.outline()
    return c.img


def ic_blade_frost():
    c = Cv(16, 16)
    met, met_hi = C(150, 214, 236), C(210, 244, 252)
    c.VLINE(8, 0, 8, met)
    c.VLINE(9, 1, 8, C(106, 168, 196))
    c.P(7, 1, met_hi); c.P(8, 0, met_hi)
    c.P(6, 3, met_hi); c.P(11, 4, met_hi)               # иней на клинке
    c.P(7, 6, C(236, 252, 255))
    c.R(6, 9, 11, 10, C(120, 180, 210))                 # гарда
    c.R(8, 11, 9, 14, C(96, 130, 160))                  # рукоять
    c.P(8, 15, C(180, 226, 240)); c.P(9, 15, C(180, 226, 240))
    c.outline()
    return c.img


def ic_scepter_comet():
    c = Cv(16, 16)
    c.VLINE(8, 8, 15, C(226, 182, 78))                  # золотое древко
    c.R(5, 4, 11, 7, C(150, 110, 220))                  # аметистовый набалдашник
    c.P(6, 4, C(222, 200, 255)); c.P(9, 5, C(96, 60, 160))
    # хвост кометы
    c.P(3, 2, C(250, 230, 120)); c.P(4, 3, C(250, 230, 120))
    c.P(5, 2, C(250, 230, 120)); c.P(2, 4, C(200, 170, 90))
    c.P(8, 1, C(250, 230, 120)); c.P(11, 3, C(250, 230, 120))
    c.outline()
    return c.img


def ic_magic_bolt():
    """Снаряд «Магической стрелы» (использует мир как спрайт заклинания)."""
    c = Cv(16, 16)
    c.ellipse(8, 8, 6, 6, C(70, 150, 180, 170))
    c.ellipse(8, 8, 4, 4, C(120, 210, 230))
    c.ellipse(8, 8, 2, 2, C(232, 252, 255))
    c.P(4, 5, C(200, 244, 252)); c.P(11, 10, C(140, 220, 240))
    c.outline(C(30, 68, 92))
    return c.img


def ic_sword(big=False):
    c = Cv(16, 16)
    met, met_hi = C(198, 208, 222), C(236, 242, 250)
    c.VLINE(8, 0, 8, met)
    c.VLINE(9, 1, 8, C(150, 160, 178))
    c.P(7, 1, met_hi)
    c.P(8, 0, met_hi)
    c.R(6, 9, 11, 10, C(226, 182, 78))                  # гарда
    c.R(8, 11, 9, 14, C(120, 82, 44))                   # рукоять
    c.P(8, 15, C(226, 182, 78)); c.P(9, 15, C(226, 182, 78))
    c.outline()
    return c.img


def ic_greatsword():
    c = Cv(16, 16)
    met, met_hi = C(168, 178, 196), C(224, 232, 244)
    c.R(6, 0, 8, 8, met)
    c.VLINE(9, 1, 8, C(126, 136, 156))
    c.VLINE(6, 0, 8, met_hi)
    c.R(4, 9, 11, 11, C(196, 152, 66))
    c.R(7, 12, 9, 14, C(104, 70, 40))
    c.R(7, 15, 9, 15, C(196, 152, 66))
    c.outline()
    return c.img


def ic_morgenstern():
    c = Cv(16, 16)
    ball = C(140, 148, 164)
    c.ellipse(8, 6, 4, 4, ball)
    c.ellipse(7, 5, 2, 2, C(186, 194, 208))
    for (x, y) in [(8, 1), (4, 4), (12, 4), (5, 9), (11, 9), (8, 10)]:
        c.R(x - 1, y - 1, x + 1, y + 1, C(196, 204, 218))
        c.P(x, y, C(230, 236, 246))
    c.R(7, 10, 8, 14, C(104, 70, 40))                   # рукоять
    c.P(7, 15, C(226, 182, 78)); c.P(8, 15, C(226, 182, 78))
    c.outline()
    return c.img


def ic_potion(violet=False, size="mid", liquid_color=None):
    """Флакон зелья (шаг 7): size "small"/"mid"/"large" — размер растёт
    вместе с ценой и эффектом; liquid_color — цвет жидкости (мана — синяя)."""
    c = Cv(16, 16)
    glass = C(150, 190, 220, 160)
    if violet:
        liquid = C(180, 100, 236)
    elif liquid_color is not None:
        liquid = liquid_color
    else:
        liquid = C(226, 90, 90)
    if size == "small":                    # маленький флакончик
        c.R(6, 2, 9, 5, glass)             # горлышко
        c.R(5, 6, 10, 12, glass)
        c.R(6, 8, 9, 11, liquid)
        c.HLINE(8, 6, 9, shade(liquid, 0.3))
        c.P(6, 8, shade(liquid, 0.45))
        c.R(4, 12, 11, 13, C(120, 124, 140))
    elif size == "large":                  # большая фляга
        c.R(6, 2, 9, 4, glass)             # горлышко
        c.R(3, 4, 12, 13, glass)
        c.R(4, 6, 11, 12, liquid)
        c.HLINE(6, 4, 11, shade(liquid, 0.3))
        c.P(4, 6, shade(liquid, 0.45))
        c.R(2, 13, 13, 14, C(120, 124, 140))
    else:                                  # классика (средняя)
        c.R(6, 2, 9, 4, glass)             # горлышко
        c.R(4, 5, 11, 13, glass)
        c.R(5, 7, 10, 12, liquid)
        c.HLINE(7, 5, 10, shade(liquid, 0.3))
        c.P(5, 7, shade(liquid, 0.45))
        c.R(3, 13, 12, 14, C(120, 124, 140))
    c.P(6, 1, C(196, 152, 66)); c.P(9, 1, C(196, 152, 66))  # пробка
    c.R(6, 0, 9, 1, C(150, 114, 48))
    c.outline()
    return c.img


def ic_star_blade():
    c = Cv(16, 16)
    met = C(186, 170, 246)
    c.VLINE(8, 0, 8, met)
    c.VLINE(9, 1, 8, C(140, 120, 210))
    c.P(8, 0, C(240, 232, 255)); c.P(6, 3, C(240, 232, 255))
    c.R(6, 9, 11, 10, C(226, 182, 78))
    c.R(8, 11, 9, 14, C(110, 80, 160))
    c.P(4, 2, C(255, 250, 200)); c.P(12, 6, C(255, 250, 200))  # звёздочки
    c.outline()
    return c.img


def ic_cloak():
    c = Cv(16, 16)
    c.R(3, 3, 12, 14, C(84, 62, 148))
    c.R(5, 1, 10, 3, C(84, 62, 148))
    c.VLINE(3, 5, 14, C(60, 44, 116))
    c.VLINE(12, 5, 14, C(108, 82, 180))
    c.HLINE(14, 4, 11, C(60, 44, 116))
    c.P(7, 6, C(226, 182, 78)); c.P(8, 6, C(226, 182, 78))  # застёжка
    c.P(5, 10, C(120, 100, 200)); c.P(10, 11, C(120, 100, 200))  # узор
    c.outline()
    return c.img


def ic_elixir():
    return ic_potion(violet=True)


def ic_pouch(tint=None):
    c = Cv(16, 16)
    col = tint or C(150, 150, 160)
    c.ellipse(8, 10, 5, 4, col)
    c.R(5, 5, 10, 8, col)
    c.P(6, 4, shade(col, -0.2)); c.P(9, 4, shade(col, -0.2))
    c.HLINE(8, 5, 10, shade(col, -0.35))                # завязка
    c.P(7, 13, shade(col, -0.25)); c.P(9, 12, shade(col, 0.2))
    c.outline()
    return c.img


ICONS = {
    "ham": ic_ham, "beer": ic_beer, "sword": ic_sword, "greatsword": ic_greatsword,
    "morgenstern": ic_morgenstern, "hp_potion": ic_potion,
    "star_blade": ic_star_blade, "abyss_cloak": ic_cloak, "comet_elixir": ic_elixir,
    # шаг 6: напитки и магическое оружие
    "water": ic_water, "mors": ic_mors, "juice": ic_juice,
    "wand_lightning": ic_wand_lightning, "blade_frost": ic_blade_frost,
    "scepter_comet": ic_scepter_comet, "magic_bolt": ic_magic_bolt,
}

## Шаг 7: зелья Злуса — три размера лечения и три размера маны.
MANA_LIQUID = C(90, 150, 236)
ICONS_STEP7 = {
    "hp_potion_small": lambda: ic_potion(size="small"),
    "hp_potion_large": lambda: ic_potion(size="large"),
    "mana_potion_small": lambda: ic_potion(size="small", liquid_color=MANA_LIQUID),
    "mana_potion": lambda: ic_potion(liquid_color=MANA_LIQUID),
    "mana_potion_large": lambda: ic_potion(size="large", liquid_color=MANA_LIQUID),
}


if __name__ == "__main__":
    import os
    build_tiles() and save(build_tiles(), "tilesets/world_tiles.png")
    os.makedirs(OUT + "/sprites/props", exist_ok=True)
    os.makedirs(OUT + "/sprites/icons", exist_ok=True)
    save(p_arch(), "sprites/props/arch.png")
    save(p_throne(), "sprites/props/throne.png")
    for f in range(3):
        save(p_fountain(f), f"sprites/props/fountain_{f}.png")
    for f in range(3):
        save(p_torch(f), f"sprites/props/torch_{f}.png")
    for f in range(3):
        save(p_brazier(f), f"sprites/props/brazier_{f}.png")
    for f in range(3):
        save(p_forge(f), f"sprites/props/forge_{f}.png")
    save(p_cart(), "sprites/props/cart_gura.png")
    save(p_anvil(), "sprites/props/anvil.png")
    save(p_stand_zlus(), "sprites/props/stand_zlus.png")
    save(p_stall("red"), "sprites/props/stall_red.png")
    save(p_stall("blue"), "sprites/props/stall_blue.png")
    save(p_barrel(), "sprites/props/barrel.png")
    save(p_crate(), "sprites/props/crate.png")
    save(p_sacks(), "sprites/props/sacks.png")
    save(p_bench(), "sprites/props/bench.png")
    save(p_lantern(), "sprites/props/lantern.png")
    for f in range(2):
        save(p_crystal(False, f), f"sprites/props/crystal_{f}.png")
        save(p_crystal(True, f), f"sprites/props/crystal_violet_{f}.png")
    save(p_planet(), "sprites/props/planet.png")
    save(p_moon(), "sprites/props/moon.png")
    save(p_asteroid(1), "sprites/props/asteroid_1.png")
    save(p_asteroid(2), "sprites/props/asteroid_2.png")
    save(p_island(), "sprites/props/island.png")
    save(p_banner("red"), "sprites/props/banner_red.png")
    save(p_banner("blue"), "sprites/props/banner_blue.png")
    save(p_shadow(), "sprites/props/shadow.png")
    save(p_pointer(), "sprites/props/pointer.png")
    for iid, fn in ICONS.items():
        save(fn(), f"sprites/icons/{iid}.png")
    for iid, fn in ICONS_STEP7.items():
        save(fn(), f"sprites/icons/{iid}.png")   # шаг 7: зелья размеров и маны
    # мешочки добычи по цвету качества
    save(ic_pouch(C(150, 150, 160)), "sprites/icons/pouch_gray.png")
    save(ic_pouch(C(96, 186, 110)), "sprites/icons/pouch_green.png")
    save(ic_pouch(C(240, 200, 90)), "sprites/icons/pouch_gold.png")
    save(ic_pouch(C(186, 130, 255)), "sprites/icons/pouch_violet.png")
    # превью
    cells, labels = [], []
    import glob
    for f in sorted(glob.glob(OUT + "/sprites/props/*.png")) + sorted(glob.glob(OUT + "/sprites/icons/*.png")):
        cells.append(Image.open(f).convert("RGBA"))
        labels.append(os.path.basename(f)[:-4])
    save(contact(cells, 64, 64, cols=8, scale=2, bg=(46, 48, 66, 255), labels=labels), "/tmp/props_preview.png")
    ts = build_tiles()
    save(ts.resize((512, 512), Image.NEAREST), "/tmp/tiles_preview.png")
    print("OK")
