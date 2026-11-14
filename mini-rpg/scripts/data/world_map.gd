## Карта мира «Dungeon Loot» (шаг 4): замок + двор + край мира с космосом.
## Сгенерировано скриптом gen_worldmap.py — вручную не править,
## правки вносить в генератор и перегенерировать.
class_name WorldMap
extends RefCounted

const MAP_W := 30
const MAP_H := 56
const RAILING_ROW := 46
const CASTLE_LAST_ROW := 19
const TILE_SIZE := 16
const SOLID_TILES := "#BDFRWkf"
const PLAYER_SPAWN := Vector2(14, 13)

## Символ -> координата в атласе assets/tilesets/world_tiles.png
const TILE_ATLAS := {
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
}

const MAP: Array[String] = [
        "##W#DD#####DD#W##DD#W###DD#W##",
        "#cccccccccccccccccccccccccccc#",
        "#fccccccccccccccccccccccccccf#",
        "#cckcccccccccccccccccccccckcc#",
        "#cccccccccccccccccccccccccccc#",
        "#cccccccccccccccccccccccccccc#",
        "#cccccccccccccccccccccccccccc#",
        "#fccccccccccccccccccccccccccf#",
        "#cckcccccccccccccccccccccckcc#",
        "#cccccccccccccccccccccccccccc#",
        "#cccccccccccccccccccccccccccc#",
        "#fccccccccccccccccccccccccccf#",
        "#cccccccccccccccccccccccccccc#",
        "#cckcccccccccccccccccccccckcc#",
        "#ccccccccccmcmcmcmccccccccccc#",
        "#cccccccccccfcmcmcmfccccccccc#",
        "#ccccccccccmcppppmccccccccccc#",
        "#fccccccccccmppppcmcccccccccf#",
        "#ccccccccccmcppppmccccccccccc#",
        "#############pppp#############",
        "BBB,,,,,,.,,,dddd.,.,,.,,,,BBB",
        "BBB..,..g.,,,dddd,,,,,g,,,,BBB",
        "BBB,gg.,,,,,,dddd..,,,,.,,gBBB",
        "BBB.,,,.g..,.dddddddd,,.,.,BBB",
        "BBB.,.g,,,,.,dddddddd,,.,.gBBB",
        "BBB,,g..,g,,,dddddddd,,,,..BBB",
        "BBB,,g.,,.,,,dddddddd,..,g,BBB",
        "BBBg,,g.,.g,,dddddddd,g,..gBBB",
        "BBB,..,,.,,,,dddd,,...,,,.,BBB",
        "BBB,,,,.,,,,,dddd,,,,,,,,,,BBB",
        "BBB,,,,.,,,,,dddd,,,,.,.,,gBBB",
        "BBB,,,,g.,,..dddd,,,,,,.,,,BBB",
        "BBB,,,,.,,,,,ddddg.,g.,,,,,BBB",
        "BBB,,..,.,,,,dddd..,.,g..,,BBB",
        "FF,,,,,.,..,,dddd..g,,,,g,,.FF",
        "FF,,.g,,g,,,,dddd,,.,,,,.,,,FF",
        "FF,,.,,g.g,,,dddd.,.,..,..,,FF",
        "FF,,,,,..,.,,dddd,,,.g,,.,,,FF",
        "FF,.,,,.,,g,,dddd,,.,g,,.,.gFF",
        "FF,,,..,,.,..dddd.,.g,.,.,..FF",
        "FF,ggg,..,,,,dddd,,.,,,..,.,FF",
        "FF,..,..,g,.gdddd,..,,,.,,,,FF",
        "FF....,,,...,dddd,,..,,,.,,gFF",
        "FF,.,,.g,g..,dddd.,,,,,g,,,,FF",
        "FF.,,,,g,,,,,ddddg,.g,.g,,.,FF",
        "FF,.,,,g,,,,,dddd.,,.g..g..,FF",
        "RRRRRRRRRRRRRRRRRRRRRRRRRRRRRR",
        "2262635V24V6V1V13V6122VV32V4VV",
        "VVV4V54V66V6116V2641653V31VV2V",
        "131V2142664VV543VV32234VV665VV",
        "V13V2VV323V1VV45VV534V1V5V36V2",
        "461VV5VV213V4VV3VV43VVV4VV4266",
        "615VVV65VVVVVVV24252V45VV22263",
        "5V24VV45V3V43VV424VV6312446153",
        "55556324511V46VVV1V6VVV34VV126",
        "VVVVV42VVVV4V251V56V261VV65V22",
]

## NPC: id, имя, роль, тайл, зона, лист спрайтов и портрет.
## goods (шаг 5) — список id товаров для торговли (см. ItemDB.ITEMS);
## NPC без ключа goods — просто собеседник (кнопки «ТОРГОВАТЬ» не будет).
## Шаг 6: в замке добавились Глот (напитки) и Зоран (магическое оружие).
## Шаг 7 (боевая система): у каждого NPC есть hp (ЗАГЛУШКИ — числа уточняются
## с автором): по нему бьёт удар (E) — см. world.gd; NPC, чьё хп упало до 0,
## умирает и до конца сессии не воскресает, остальные NPC это запоминают.
## Шаг 8: Таинственный демон у края улицы. scale — во сколько раз он крупнее
## обычного NPC (кадры 24x32 * scale); demon: true — не спавнится на старте
## мира, а появляется после первого убийства (см. world.gd: _spawn_demon).
## Шаг 12: после 3 ударов демон впадает в ярость и дерётся (см. world.gd).
## Ключа goods у демона нет: его ассортимент — товары убитых торговцев
## (Game.demon_goods), цены со скидкой -10% за каждого убитого NPC
## (Game.demon_price). hp демона — ЗАГЛУШКА.
const NPCS: Array[Dictionary] = [
        {"id": "zlus", "name": "Злус", "role": "Придворный маг", "tile": Vector2(5, 5), "zone": "castle", "sheet": "res://assets/sprites/chars/zlus.png", "portrait": "res://assets/sprites/portraits/zlus.png", "goods": ["hp_potion_small", "hp_potion", "hp_potion_large", "mana_potion_small", "mana_potion", "mana_potion_large"], "hp": 40},
        {"id": "lira", "name": "Лира", "role": "Хозяйка замка", "tile": Vector2(16, 15), "zone": "castle", "sheet": "res://assets/sprites/chars/lira.png", "portrait": "res://assets/sprites/portraits/lira.png", "hp": 30},
        {"id": "glot", "name": "Глот", "role": "Трактирщик", "tile": Vector2(22, 9), "zone": "castle", "sheet": "res://assets/sprites/chars/glot.png", "portrait": "res://assets/sprites/portraits/glot.png", "goods": ["water", "mors", "juice", "beer"], "hp": 50},
        {"id": "zoran", "name": "Зоран", "role": "Оружейный чародей", "tile": Vector2(8, 11), "zone": "castle", "sheet": "res://assets/sprites/chars/zoran.png", "portrait": "res://assets/sprites/portraits/zoran.png", "goods": ["wand_lightning", "blade_frost", "scepter_comet", "robe_faded", "robe_stars", "robe_void"], "hp": 80},
        {"id": "gura", "name": "Гура", "role": "Повар", "tile": Vector2(6, 29), "zone": "street", "sheet": "res://assets/sprites/chars/gura.png", "portrait": "res://assets/sprites/portraits/gura.png", "goods": ["ham"], "hp": 35},
        {"id": "viras", "name": "Вирас", "role": "Кузнец", "tile": Vector2(23, 31), "zone": "street", "sheet": "res://assets/sprites/chars/viras.png", "portrait": "res://assets/sprites/portraits/viras.png", "goods": ["sword", "greatsword", "morgenstern", "armor_leather", "armor_chain", "armor_plate"], "hp": 90},
        {"id": "demon", "name": "Таинственный демон", "role": "поклонник смелости", "tile": Vector2(15, 44), "zone": "street", "sheet": "res://assets/sprites/chars/demon.png", "portrait": "res://assets/sprites/portraits/demon.png", "scale": 3, "demon": true, "hp": 200},
]

const PROPS: Array[Dictionary] = [
        {"name": "arch", "tile": Vector2(13, 19), "w": 4, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/arch.png"},
        {"name": "throne", "tile": Vector2(13, 14), "w": 2, "h": 2, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/throne.png"},
        {"name": "brazier_l", "tile": Vector2(11, 16), "w": 1, "h": 2, "solid": true, "layer": "base", "anim": ["res://assets/sprites/props/brazier", 3, 5.0]},
        {"name": "brazier_r", "tile": Vector2(18, 16), "w": 1, "h": 2, "solid": true, "layer": "base", "anim": ["res://assets/sprites/props/brazier", 3, 5.5]},
        {"name": "stand_zlus", "tile": Vector2(6, 4), "w": 1, "h": 2, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/stand_zlus.png"},
        # шаг 6: лавка Глота (бочка с напитками) и кристаллы Зорана
        {"name": "barrel_glot", "tile": Vector2(23, 9), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/barrel.png"},
        {"name": "crystal_zoran_l", "tile": Vector2(7, 12), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal_violet", 2, 2.0]},
        {"name": "crystal_zoran_r", "tile": Vector2(10, 12), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal_violet", 2, 2.2]},
        {"name": "cart_gura", "tile": Vector2(7, 29), "w": 3, "h": 2, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/cart_gura.png"},
        {"name": "anvil", "tile": Vector2(22, 31), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/anvil.png"},
        {"name": "forge", "tile": Vector2(24, 31), "w": 2, "h": 2, "solid": true, "layer": "base", "anim": ["res://assets/sprites/props/forge", 3, 4.0]},
        {"name": "fountain", "tile": Vector2(17, 24), "w": 2, "h": 2, "solid": true, "layer": "base", "anim": ["res://assets/sprites/props/fountain", 3, 4.0]},
        {"name": "stall_red", "tile": Vector2(6, 33), "w": 3, "h": 2, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/stall_red.png"},
        {"name": "stall_blue", "tile": Vector2(21, 38), "w": 3, "h": 2, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/stall_blue.png"},
        {"name": "barrel_1", "tile": Vector2(4, 21), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/barrel.png"},
        {"name": "barrel_2", "tile": Vector2(26, 30), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/barrel.png"},
        {"name": "crate_1", "tile": Vector2(3, 30), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/crate.png"},
        {"name": "crate_2", "tile": Vector2(25, 22), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/crate.png"},
        {"name": "sacks_1", "tile": Vector2(9, 33), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/sacks.png"},
        {"name": "sacks_2", "tile": Vector2(5, 22), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/sacks.png"},
        {"name": "bench_1", "tile": Vector2(10, 26), "w": 2, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/bench.png"},
        {"name": "bench_2", "tile": Vector2(18, 39), "w": 2, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/bench.png"},
        {"name": "banner_r1", "tile": Vector2(1, 2), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/banner_red.png"},
        {"name": "banner_b1", "tile": Vector2(28, 2), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/banner_blue.png"},
        {"name": "banner_b2", "tile": Vector2(1, 7), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/banner_blue.png"},
        {"name": "banner_r2", "tile": Vector2(28, 7), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/banner_red.png"},
        {"name": "banner_r3", "tile": Vector2(1, 12), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/banner_red.png"},
        {"name": "banner_b3", "tile": Vector2(28, 12), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/banner_blue.png"},
        {"name": "moon", "tile": Vector2(8, 49), "w": 1, "h": 1, "solid": false, "layer": "base", "texture": "res://assets/sprites/props/moon.png"},
        {"name": "planet", "tile": Vector2(7, 49), "w": 3, "h": 3, "solid": false, "layer": "base", "texture": "res://assets/sprites/props/planet.png"},
        {"name": "island_1", "tile": Vector2(21, 50), "w": 3, "h": 2, "solid": false, "layer": "base", "texture": "res://assets/sprites/props/island.png", "bob": Vector2(2.0, 4.0)},
        {"name": "island_2", "tile": Vector2(12, 52), "w": 3, "h": 2, "solid": false, "layer": "base", "texture": "res://assets/sprites/props/island.png", "bob": Vector2(3.0, 5.0)},
        {"name": "asteroid_1", "tile": Vector2(16, 48), "w": 1, "h": 1, "solid": false, "layer": "base", "texture": "res://assets/sprites/props/asteroid_1.png", "bob": Vector2(1.5, 3.0)},
        {"name": "asteroid_2", "tile": Vector2(26, 52), "w": 1, "h": 1, "solid": false, "layer": "base", "texture": "res://assets/sprites/props/asteroid_2.png", "bob": Vector2(2.0, 3.6)},
        {"name": "asteroid_3", "tile": Vector2(3, 53), "w": 1, "h": 1, "solid": false, "layer": "base", "texture": "res://assets/sprites/props/asteroid_1.png", "bob": Vector2(1.5, 3.2)},
        {"name": "torch_0", "tile": Vector2(3, 0), "w": 1, "h": 2, "solid": false, "layer": "over", "anim": ["res://assets/sprites/props/torch", 3, 6.0]},
        {"name": "torch_1", "tile": Vector2(8, 0), "w": 1, "h": 2, "solid": false, "layer": "over", "anim": ["res://assets/sprites/props/torch", 3, 6.0]},
        {"name": "torch_2", "tile": Vector2(15, 0), "w": 1, "h": 2, "solid": false, "layer": "over", "anim": ["res://assets/sprites/props/torch", 3, 6.0]},
        {"name": "torch_3", "tile": Vector2(21, 0), "w": 1, "h": 2, "solid": false, "layer": "over", "anim": ["res://assets/sprites/props/torch", 3, 6.0]},
        {"name": "torch_4", "tile": Vector2(26, 0), "w": 1, "h": 2, "solid": false, "layer": "over", "anim": ["res://assets/sprites/props/torch", 3, 6.0]},
        {"name": "crystal_0", "tile": Vector2(4, 41), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal", 2, 2.0]},
        {"name": "crystal_1", "tile": Vector2(25, 40), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal", 2, 2.0]},
        {"name": "crystal_2", "tile": Vector2(3, 44), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal", 2, 2.0]},
        {"name": "crystal_3", "tile": Vector2(21, 43), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal", 2, 2.0]},
        {"name": "crystal_4", "tile": Vector2(8, 44), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal_violet", 2, 2.0]},
        {"name": "crystal_5", "tile": Vector2(24, 43), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal_violet", 2, 2.0]},
        {"name": "crystal_6", "tile": Vector2(27, 38), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal_violet", 2, 2.0]},
        {"name": "lantern_0", "tile": Vector2(12, 22), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/lantern.png"},
        {"name": "lantern_1", "tile": Vector2(18, 22), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/lantern.png"},
        {"name": "lantern_2", "tile": Vector2(12, 30), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/lantern.png"},
        {"name": "lantern_3", "tile": Vector2(18, 30), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/lantern.png"},
        {"name": "lantern_4", "tile": Vector2(12, 38), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/lantern.png"},
        {"name": "lantern_5", "tile": Vector2(18, 38), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/lantern.png"},
]

const DOORS: Array[Dictionary] = [
        {"id": "dungeon_1", "tiles": [Vector2(4, 0), Vector2(5, 0)]},
        {"id": "dungeon_2", "tiles": [Vector2(11, 0), Vector2(12, 0)]},
        {"id": "dungeon_3", "tiles": [Vector2(17, 0), Vector2(18, 0)]},
        {"id": "dungeon_4", "tiles": [Vector2(24, 0), Vector2(25, 0)]},
]
