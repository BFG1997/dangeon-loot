# -*- coding: utf-8 -*-
"""Генератор scripts/data/world_map.gd «Dungeon Loot» (шаг 4).
Замок + двор + край мира; символы: m/s (мрамор), d (брусчатка), 1-6 (космос).
Расширение хаба (2026-11-26): остров 30 колонок по центру карты 60 колонок,
слева и справа — 15 колонок космоса (V/1-6, твёрдые), ограда — только под
островом. ВНИМАНИЕ: файл world_map.gd после шагов 5-12 правился руками
(goods/hp NPC, Глот, Зоран, демон) — регенерация их сотрёт; сверять!
"""
import random

random.seed(11)

W, H = 30, 56
PAD = 15                        # космос по бокам острова
FULL_W = W + 2 * PAD            # 60
GATE_L, GATE_R = 13, 16          # колонны ворот/ковра
DOORS = [(4, 5), (11, 12), (17, 18), (24, 25)]
WINDOWS = [2, 14, 20, 27]
TORCHES = [3, 8, 15, 21, 26]

rows = []

# --- ряд 0: стена с дверями, окнами
row = ["#"] * W
for a, b in DOORS:
    row[a] = row[b] = "D"
for x in WINDOWS:
    row[x] = "W"
rows.append("".join(row))

# --- ряды 1..18: замок
def castle_floor(x, y):
    # мраморный шахматный зал у трона
    if 11 <= x <= 18 and 14 <= y <= 18:
        return "c" if (x + y) % 2 == 0 else "m"
    return "c"

pillars = {(3, 3), (26, 3), (3, 8), (26, 8), (3, 13), (26, 13)}
pots = {(1, 2), (28, 2), (1, 7), (28, 7), (1, 11), (28, 11), (1, 17), (28, 17),
        (12, 15), (19, 15)}

for y in range(1, 19):
    row = []
    for x in range(W):
        if x == 0 or x == W - 1:
            row.append("#")
        elif (x, y) in pillars:
            row.append("k")
        elif (x, y) in pots:
            row.append("f")
        elif 13 <= x <= 16 and y >= 16:
            row.append("p")                       # ковёр к трону
        else:
            row.append(castle_floor(x, y))
    rows.append("".join(row))

# --- ряд 19: стена фасада с проёмом ворот
row = ["#"] * W
for x in range(GATE_L, GATE_R + 1):
    row[x] = "p"
rows.append("".join(row))

# --- ряды 20..33: двор вдоль стен замка (B), 34..45: луг (F)
def ground_tile(x, y):
    if GATE_L <= x <= GATE_R:
        return "d"                                # брусчатка к воротам
    if 17 <= x <= 20 and 23 <= y <= 27:
        return "d"                                # площадка фонтана
    r = random.random()
    if y >= 34:
        if r < 0.34:
            return "."
        if r < 0.46:
            return "g"
        return ","
    if r < 0.22:
        return "."
    if r < 0.30:
        return "g"
    return ","

for y in range(20, 46):
    row = []
    for x in range(W):
        if y <= 33 and (x <= 2 or x >= 27):
            row.append("B")
        elif y >= 34 and (x <= 1 or x >= 28):
            row.append("F")
        else:
            row.append(ground_tile(x, y))
    rows.append("".join(row))

# --- ряд 46: ограда края (только под островом; по бокам космос)
rows.append("R" * W)

# --- ряды 47..55: космос
void_syms = ["V", "1", "2", "3", "4", "5", "6"]
for _y in range(47, H):
    row = [random.choices(void_syms, weights=[40, 10, 10, 10, 10, 10, 10])[0] for _ in range(W)]
    rows.append("".join(row))

# --- расширение хаба: космос по бокам всех рядов (остров в центре)
def void_pad():
    return "".join(random.choices(void_syms, weights=[40, 10, 10, 10, 10, 10, 10])[0]
                   for _ in range(PAD))

padded = []
for row in rows:
    padded.append(void_pad() + row + void_pad())
rows = padded

# ---------------------------------------------------------------- GDScript
MAP_LINES = "\n".join(f'\t"{r}",' for r in rows)

def v2(x, y):
    return f"Vector2({x}, {y})"

def prop(name, tile, w, h, solid, layer, texture=None, anim=None, bob=None):
    tile = (tile[0] + PAD, tile[1])      # остров сдвинут в центр карты
    parts = [f'"name": "{name}"', f'"tile": {v2(*tile)}', f'"w": {w}', f'"h": {h}',
             f'"solid": {"true" if solid else "false"}', f'"layer": "{layer}"']
    if texture:
        parts.append(f'"texture": "{texture}"')
    if anim:
        base, frames, fps = anim
        parts.append(f'"anim": ["{base}", {frames}, {fps}]')
    if bob:
        parts.append(f'"bob": Vector2({bob[0]}, {bob[1]})')
    return "{" + ", ".join(parts) + "}"

PROPS = [
    prop("arch", (13, 19), 4, 2, False, "over", texture="res://assets/sprites/props/arch.png"),
    prop("throne", (13, 14), 2, 2, True, "base", texture="res://assets/sprites/props/throne.png"),
    prop("brazier_l", (11, 16), 1, 2, True, "base", anim=["res://assets/sprites/props/brazier", 3, 5.0]),
    prop("brazier_r", (18, 16), 1, 2, True, "base", anim=["res://assets/sprites/props/brazier", 3, 5.5]),
    prop("stand_zlus", (6, 4), 1, 2, True, "base", texture="res://assets/sprites/props/stand_zlus.png"),
    prop("cart_gura", (7, 29), 3, 2, True, "base", texture="res://assets/sprites/props/cart_gura.png"),
    prop("anvil", (22, 31), 1, 1, True, "base", texture="res://assets/sprites/props/anvil.png"),
    prop("forge", (24, 31), 2, 2, True, "base", anim=["res://assets/sprites/props/forge", 3, 4.0]),
    prop("fountain", (17, 24), 2, 2, True, "base", anim=["res://assets/sprites/props/fountain", 3, 4.0]),
    prop("stall_red", (6, 33), 3, 2, True, "base", texture="res://assets/sprites/props/stall_red.png"),
    prop("stall_blue", (21, 38), 3, 2, True, "base", texture="res://assets/sprites/props/stall_blue.png"),
    prop("barrel_1", (4, 21), 1, 1, True, "base", texture="res://assets/sprites/props/barrel.png"),
    prop("barrel_2", (26, 30), 1, 1, True, "base", texture="res://assets/sprites/props/barrel.png"),
    prop("crate_1", (3, 30), 1, 1, True, "base", texture="res://assets/sprites/props/crate.png"),
    prop("crate_2", (25, 22), 1, 1, True, "base", texture="res://assets/sprites/props/crate.png"),
    prop("sacks_1", (9, 33), 1, 1, True, "base", texture="res://assets/sprites/props/sacks.png"),
    prop("sacks_2", (5, 22), 1, 1, True, "base", texture="res://assets/sprites/props/sacks.png"),
    prop("bench_1", (10, 26), 2, 1, True, "base", texture="res://assets/sprites/props/bench.png"),
    prop("bench_2", (18, 39), 2, 1, True, "base", texture="res://assets/sprites/props/bench.png"),
    prop("banner_r1", (1, 2), 1, 2, False, "over", texture="res://assets/sprites/props/banner_red.png"),
    prop("banner_b1", (28, 2), 1, 2, False, "over", texture="res://assets/sprites/props/banner_blue.png"),
    prop("banner_b2", (1, 7), 1, 2, False, "over", texture="res://assets/sprites/props/banner_blue.png"),
    prop("banner_r2", (28, 7), 1, 2, False, "over", texture="res://assets/sprites/props/banner_red.png"),
    prop("banner_r3", (1, 12), 1, 2, False, "over", texture="res://assets/sprites/props/banner_red.png"),
    prop("banner_b3", (28, 12), 1, 2, False, "over", texture="res://assets/sprites/props/banner_blue.png"),
    prop("moon", (8, 49), 1, 1, False, "base", texture="res://assets/sprites/props/moon.png",
         bob=None),
    prop("planet", (7, 49), 3, 3, False, "base", texture="res://assets/sprites/props/planet.png"),
    prop("island_1", (21, 50), 3, 2, False, "base", texture="res://assets/sprites/props/island.png",
         bob=[2.0, 4.0]),
    prop("island_2", (12, 52), 3, 2, False, "base", texture="res://assets/sprites/props/island.png",
         bob=[3.0, 5.0]),
    prop("asteroid_1", (16, 48), 1, 1, False, "base", texture="res://assets/sprites/props/asteroid_1.png",
         bob=[1.5, 3.0]),
    prop("asteroid_2", (26, 52), 1, 1, False, "base", texture="res://assets/sprites/props/asteroid_2.png",
         bob=[2.0, 3.6]),
    prop("asteroid_3", (3, 53), 1, 1, False, "base", texture="res://assets/sprites/props/asteroid_1.png",
         bob=[1.5, 3.2]),
]
for i, tx in enumerate(TORCHES):
    PROPS.append(prop(f"torch_{i}", (tx, 0), 1, 2, False, "over",
                      anim=["res://assets/sprites/props/torch", 3, 6.0]))
CRYSTALS = [((4, 41), False), ((25, 40), False), ((3, 44), False), ((21, 43), False),
            ((8, 44), True), ((24, 43), True), ((27, 38), True)]
for i, (tile, violet) in enumerate(CRYSTALS):
    base = "crystal_violet" if violet else "crystal"
    PROPS.append(prop(f"crystal_{i}", tile, 1, 2, False, "base",
                      anim=[f"res://assets/sprites/props/{base}", 2, 2.0]))
LANTERNS = [(12, 22), (18, 22), (12, 30), (18, 30), (12, 38), (18, 38)]
for i, tile in enumerate(LANTERNS):
    PROPS.append(prop(f"lantern_{i}", tile, 1, 2, False, "over",
                      texture="res://assets/sprites/props/lantern.png"))

PROPS_GD = ",\n".join(f"\t{p}" for p in PROPS)

NPCS = [
    ("zlus", "Злус", "Придворный маг", (5, 5), "castle"),
    ("lira", "Лира", "Хозяйка замка", (16, 15), "castle"),
    ("gura", "Гура", "Повар", (6, 29), "street"),
    ("viras", "Вирас", "Кузнец", (23, 31), "street"),
]
NPCS_GD = ",\n".join(
    f'\t{{"id": "{i}", "name": "{n}", "role": "{r}", "tile": {v2(t[0] + PAD, t[1])}, "zone": "{z}", '
    f'"sheet": "res://assets/sprites/chars/{i}.png", '
    f'"portrait": "res://assets/sprites/portraits/{i}.png"}}'
    for (i, n, r, t, z) in NPCS)

DOORS_GD = ",\n".join(
    f'\t{{"id": "dungeon_{k}", "tiles": [{v2(a + PAD, 0)}, {v2(b + PAD, 0)}]}}'
    for k, (a, b) in enumerate(DOORS, 1))

GD = f'''## Карта мира «Dungeon Loot» (шаг 4; расширение хаба 2026-11-26):
## остров замок+улица по центру, космос снизу и по бокам (единый).
## Сгенерировано скриптом gen_worldmap.py — вручную не править,
## правки вносить в генератор и перегенерировать.
class_name WorldMap
extends RefCounted

const MAP_W := {FULL_W}
const MAP_H := {H}
const RAILING_ROW := 46
## Остров мира (замок+улица) стоит по центру карты: колонки {PAD}..{PAD+W-1};
## колонки 0..{PAD-1} и {PAD+W}..{FULL_W-1} — космос (как южные ряды за оградой).
const ISLAND_X0 := {PAD}
const ISLAND_X1 := {PAD + W - 1}
const CASTLE_LAST_ROW := 19
const TILE_SIZE := 16
const SOLID_TILES := "#BDFRWkfV123456"
const PLAYER_SPAWN := Vector2({14 + PAD}, 13)

## Символ -> координата в атласе assets/tilesets/world_tiles.png
const TILE_ATLAS := {{
    "#": Vector2i(0, 0),
    "W": Vector2i(2, 0),
    "D": Vector2i(3, 0),
    "k": Vector2i(4, 0),
    "B": Vector2i(5, 0),
    "F": Vector2i(6, 0),
    "R": Vector2i(7, 0),
    "c": Vector2i(0, 1),
    "m": Vector2i(1, 1),
    "p": Vector2i(2, 1),
    "d": Vector2i(3, 1),
    ",": Vector2i(4, 1),
    ".": Vector2i(5, 1),
    "g": Vector2i(6, 1),
    "V": Vector2i(7, 1),
    "f": Vector2i(0, 2),
    "s": Vector2i(1, 2),
    "1": Vector2i(2, 2),
    "2": Vector2i(3, 2),
    "3": Vector2i(4, 2),
    "4": Vector2i(5, 2),
    "5": Vector2i(6, 2),
    "6": Vector2i(7, 2),
}}

const MAP: Array[String] = [
{MAP_LINES}
]

## NPC: id, имя, роль, тайл, зона, лист спрайтов и портрет (тайлы острова
## сдвинуты на +{PAD} колонок при расширении хаба).
const NPCS: Array[Dictionary] = [
{NPCS_GD},
]

const PROPS: Array[Dictionary] = [
{PROPS_GD},
]

const DOORS: Array[Dictionary] = [
{DOORS_GD},
]
'''

with open("/home/z/my-project/game/mini-rpg/scripts/data/world_map.gd", "w") as f:
    f.write(GD)

# быстрая самопроверка
assert all(len(r) == FULL_W for r in rows), "ширина строк!"
assert rows[46][PAD:PAD + W] == "R" * W
assert rows[0][PAD + 4] == "D" and rows[0][PAD + 25] == "D"
print("world_map.gd записан:", len(rows), "рядов по", FULL_W, "колонок")
print("остров: колонки", PAD, "..", PAD + W - 1)
print("NPC:", [n[0] for n in NPCS])
print("пропов:", len(PROPS))
