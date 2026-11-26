## Карта мира «Dungeon Loot» (шаг 4; расширение хаба 2026-11-26):
## остров замок+улица по центру, космос снизу и по бокам (единый).
## Сгенерировано скриптом gen_worldmap.py и расширено скриптом
## widen_worldmap.py (60x56); NPC/пропы/двери сдвинуты на +15 по X.
class_name WorldMap
extends RefCounted

const MAP_W := 60
const MAP_H := 56
const RAILING_ROW := 46
## Остров мира (замок+улица) стоит по центру карты: колонки 15..44;
## колонки 0..14 и 45..59 — космос (как южные ряды за оградой).
const ISLAND_X0 := 15
const ISLAND_X1 := 44
const CASTLE_LAST_ROW := 19
const TILE_SIZE := 16
const SOLID_TILES := "#BDFRWkfV123456"
const PLAYER_SPAWN := Vector2(29, 13)

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
        "346VV5VV5V61V62##W#DD#####DD#W##DD#W###DD#W##V54436V63V3V342",
        "VVV4642V4V6V6V4#cccccccccccccccccccccccccccc#V21V15VV4VV22V4",
        "1VVVVVV23V1226V#fccccccccccccccccccccccccccf#4253VV4V3V211V5",
        "543VV5VV5V6V5VV#cckcccccccccccccccccccccckcc#15V25V1V151VV5V",
        "4636V33V1VV1V6V#cccccccccccccccccccccccccccc#24V662253V6V224",
        "V3V3VV24661V224#cccccccccccccccccccccccccccc#V4V56213V356446",
        "VV6VV464V4V236V#cccccccccccccccccccccccccccc#VVVV1VV5V1VV546",
        "V4V4213V25346V4#fccccccccccccccccccccccccccf#62V3V44V2141VVV",
        "VV35V2136V21V16#cckcccccccccccccccccccccckcc#4VVV11V16V36VV1",
        "VVV344VV64V4VV6#cccccccccccccccccccccccccccc#511626V3V46V351",
        "V1322VVV4V23114#cccccccccccccccccccccccccccc#2V4665V2V5V25V4",
        "611V6V44V663111#fccccccccccccccccccccccccccf#36VV23365V126VV",
        "V431135V2V41634#cccccccccccccccccccccccccccc#14VV21252331433",
        "531V561224244V4#cckcccccccccccccccccccccckcc#4366V155VVV6V54",
        "1V16V14VV2136V4#ccccccccccmcmcmcmccccccccccc#VV3442VV4V3V24V",
        "V615V34246V3453#cccccccccccfcmcmcmfccccccccc#34VVVVVV3VV2VVV",
        "52VVV64VV5V1V16#ccccccccccmcppppmccccccccccc#3616451V5V21644",
        "VV3646526V2V52V#fccccccccccmppppcmcccccccccf#6V62562V35VVV14",
        "6V125VVVVVV6V5V#ccccccccccmcppppmccccccccccc#VV562433636V312",
        "V42441V62V2VVV3#############pppp#############V3VV5V1V15253VV",
        "54V6351413222V1BBB,,,,,,.,,,dddd.,.,,.,,,,BBBVVVV15VV656421V",
        "42214432V36VV5VBBB..,..g.,,,dddd,,,,,g,,,,BBB16VV4235115V1V4",
        "1V26VVV5V141V5VBBB,gg.,,,,,,dddd..,,,,.,,gBBB2132656V6V4V455",
        "5V432V421V1V512BBB.,,,.g..,.dddddddd,,.,.,BBB4V6VV4V436VV5V5",
        "V53VVV6VVVV4634BBB.,.g,,,,.,dddddddd,,.,.gBBB5VV632536V523V3",
        "541V46V44VV23VVBBB,,g..,g,,,dddddddd,,,,..BBB635V53446V52112",
        "VV11V66136VV614BBB,,g.,,.,,,dddddddd,..,g,BBB114V1VVV3V44VV2",
        "V43V25VV3315VVVBBBg,,g.,.g,,dddddddd,g,..gBBBV5V63631V645146",
        "3VV16VV1V364V15BBB,..,,.,,,,dddd,,...,,,.,BBB1V45656V14561VV",
        "36VVVVV26163V4VBBB,,,,.,,,,,dddd,,,,,,,,,,BBBVV5126V5VV5VV45",
        "5VVV56VVV3V1355BBB,,,,.,,,,,dddd,,,,.,.,,gBBB613151VVV4VVVV5",
        "364V6245V4V45V1BBB,,,,g.,,..dddd,,,,,,.,,,BBB255VVVVVV2363VV",
        "5V5652136V3411VBBB,,,,.,,,,,ddddg.,g.,,,,,BBB6V4V1V5662113V3",
        "VV46VV34V13351VBBB,,..,.,,,,dddd..,.,g..,,BBBV1454VV113V635V",
        "VV45411V44325VVFF,,,,,.,..,,dddd..g,,,,g,,.FF5V4VVVVVV463553",
        "V64V5VVVV236331FF,,.g,,g,,,,dddd,,.,,,,.,,,FF6V3V166VVVVVV52",
        "V11VV66VVVV1VVVFF,,.,,g.g,,,dddd.,.,..,..,,FFV5V2323V1V22V65",
        "V214333VV25152VFF,,,,,..,.,,dddd,,,.g,,.,,,FF2VV14VV6V126VV3",
        "VV44V14413VVVVVFF,.,,,.,,g,,dddd,,.,g,,.,.gFFV43V6V5VV425V43",
        "2V551V12566V226FF,,,..,,.,..dddd.,.g,.,.,..FF1246VVVV1V3VV52",
        "2154V614V461V32FF,ggg,..,,,,dddd,,.,,,..,.,FF322V25VV3VV435V",
        "V1V233334V2VVV1FF,..,..,g,.gdddd,..,,,.,,,,FFV415V64V15V4234",
        "5V62345V2VV15VVFF....,,,...,dddd,,..,,,.,,gFF4412V5661V13VVV",
        "116552231V6VV3VFF,.,,.g,g..,dddd.,,,,,g,,,,FF6561V61V45VV6VV",
        "5V5V5565VVV2V35FF.,,,,g,,,,,ddddg,.g,.g,,.,FFV54V534363VV3V3",
        "411VVV3VVV35VV3FF,.,,,g,,,,,dddd.,,.g..g..,FF1535V3256V5VV4V",
        "53635VV65V23V4VRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR1VV1544VV315V1V",
        "5VVVV6226464V122262635V24V6V1V13V6122VV32V4VV31V1432V4644545",
        "4V66VVVV1V1V364VVV4V54V66V6116V2641653V31VV2VV116V4VV6VVVV2V",
        "6152V431V2364V6131V2142664VV543VV32234VV665VVVVV5431V4445VVV",
        "VVV3V43232V6616V13V2VV323V1VV45VV534V1V5V36V25VVVV62641VVVV2",
        "VVV242V23V11116461VV5VV213V4VV3VV43VVV4VV4266V13311VV33VVVV2",
        "V56645V51VVVV5V615VVV65VVVVVVV24252V45VV22263VV15V61VV1VV43V",
        "V6V54VV5V642VV55V24VV45V3V43VV424VV63124461531VV25V446VV6521",
        "24V1VVVVV5VV12155556324511V46VVV1V6VVV34VV1264V2VVVVV5513333",
        "V54V66165342V3VVVVVV42VVVV4V251V56V261VV65V22V4V3225VV226212",
]

## NPC: id, имя, роль, тайл, зона, лист спрайтов и портрет.
## goods (шаг 5) — список id товаров для торговли (см. ItemDB.ITEMS);
## NPC без ключа goods — просто собеседник (кнопки «ТОРГОВАТЬ» не будет).
## Шаг 6: в замке добавились Глот (напитки) и Зоран (магическое оружие).
## Шаг 7 (боевая система): у каждого NPC есть hp (числа подтверждены,
## шаг 25): по нему бьёт удар (E) — см. world.gd; NPC, чьё хп упало до 0,
## умирает и до конца сессии не воскресает, остальные NPC это запоминают.
## Шаг 8: Таинственный демон у края улицы. scale — во сколько раз он крупнее
## обычного NPC (кадры 24x32 * scale); demon: true — не спавнится на старте
## мира, а появляется после первого убийства (см. world.gd: _spawn_demon).
## Шаг 12: после 3 ударов демон впадает в ярость и дерётся (см. world.gd).
## Ключа goods у демона нет: его ассортимент — товары убитых торговцев
## (Game.demon_goods), цены со скидкой -10% за каждого убитого NPC
## (Game.demon_price). hp демона — 260 (шаг 25: усилен с 200).
const NPCS: Array[Dictionary] = [
        {"id": "zlus", "name": "Злус", "role": "Придворный маг", "tile": Vector2(20, 5), "zone": "castle", "sheet": "res://assets/sprites/chars/zlus.png", "portrait": "res://assets/sprites/portraits/zlus.png", "goods": ["hp_potion_small", "hp_potion", "hp_potion_large", "mana_potion_small", "mana_potion", "mana_potion_large"], "hp": 40},
        {"id": "lira", "name": "Лира", "role": "Хозяйка замка", "tile": Vector2(31, 15), "zone": "castle", "sheet": "res://assets/sprites/chars/lira.png", "portrait": "res://assets/sprites/portraits/lira.png", "hp": 30},
        {"id": "glot", "name": "Глот", "role": "Трактирщик", "tile": Vector2(37, 9), "zone": "castle", "sheet": "res://assets/sprites/chars/glot.png", "portrait": "res://assets/sprites/portraits/glot.png", "goods": ["water", "mors", "juice", "beer"], "hp": 50},
        {"id": "zoran", "name": "Зоран", "role": "Оружейный чародей", "tile": Vector2(23, 11), "zone": "castle", "sheet": "res://assets/sprites/chars/zoran.png", "portrait": "res://assets/sprites/portraits/zoran.png", "goods": ["wand_lightning", "blade_frost", "scepter_comet", "robe_faded", "robe_stars", "robe_void"], "hp": 80},
        {"id": "gura", "name": "Гура", "role": "Повар", "tile": Vector2(21, 29), "zone": "street", "sheet": "res://assets/sprites/chars/gura.png", "portrait": "res://assets/sprites/portraits/gura.png", "goods": ["ham"], "hp": 35},
        {"id": "viras", "name": "Вирас", "role": "Кузнец", "tile": Vector2(38, 31), "zone": "street", "sheet": "res://assets/sprites/chars/viras.png", "portrait": "res://assets/sprites/portraits/viras.png", "goods": ["sword", "greatsword", "morgenstern", "armor_leather", "armor_chain", "armor_plate"], "hp": 90},
        {"id": "demon", "name": "Таинственный демон", "role": "поклонник смелости", "tile": Vector2(30, 44), "zone": "street", "sheet": "res://assets/sprites/chars/demon.png", "portrait": "res://assets/sprites/portraits/demon.png", "scale": 3, "demon": true, "hp": 260},
]

const PROPS: Array[Dictionary] = [
        {"name": "arch", "tile": Vector2(28, 19), "w": 4, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/arch.png"},
        {"name": "throne", "tile": Vector2(28, 14), "w": 2, "h": 2, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/throne.png"},
        {"name": "brazier_l", "tile": Vector2(26, 16), "w": 1, "h": 2, "solid": true, "layer": "base", "anim": ["res://assets/sprites/props/brazier", 3, 5.0]},
        {"name": "brazier_r", "tile": Vector2(33, 16), "w": 1, "h": 2, "solid": true, "layer": "base", "anim": ["res://assets/sprites/props/brazier", 3, 5.5]},
        {"name": "stand_zlus", "tile": Vector2(21, 4), "w": 1, "h": 2, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/stand_zlus.png"},
        # шаг 6: лавка Глота (бочка с напитками) и кристаллы Зорана
        {"name": "barrel_glot", "tile": Vector2(38, 9), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/barrel.png"},
        {"name": "crystal_zoran_l", "tile": Vector2(22, 12), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal_violet", 2, 2.0]},
        {"name": "crystal_zoran_r", "tile": Vector2(25, 12), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal_violet", 2, 2.2]},
        {"name": "cart_gura", "tile": Vector2(22, 29), "w": 3, "h": 2, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/cart_gura.png"},
        {"name": "anvil", "tile": Vector2(37, 31), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/anvil.png"},
        {"name": "forge", "tile": Vector2(39, 31), "w": 2, "h": 2, "solid": true, "layer": "base", "anim": ["res://assets/sprites/props/forge", 3, 4.0]},
        {"name": "fountain", "tile": Vector2(32, 24), "w": 2, "h": 2, "solid": true, "layer": "base", "anim": ["res://assets/sprites/props/fountain", 3, 4.0]},
        {"name": "stall_red", "tile": Vector2(21, 33), "w": 3, "h": 2, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/stall_red.png"},
        {"name": "stall_blue", "tile": Vector2(36, 38), "w": 3, "h": 2, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/stall_blue.png"},
        {"name": "barrel_1", "tile": Vector2(19, 21), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/barrel.png"},
        {"name": "barrel_2", "tile": Vector2(41, 30), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/barrel.png"},
        {"name": "crate_1", "tile": Vector2(18, 30), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/crate.png"},
        {"name": "crate_2", "tile": Vector2(40, 22), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/crate.png"},
        {"name": "sacks_1", "tile": Vector2(24, 33), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/sacks.png"},
        {"name": "sacks_2", "tile": Vector2(20, 22), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/sacks.png"},
        {"name": "bench_1", "tile": Vector2(25, 26), "w": 2, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/bench.png"},
        {"name": "bench_2", "tile": Vector2(33, 39), "w": 2, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/bench.png"},
        {"name": "banner_r1", "tile": Vector2(16, 2), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/banner_red.png"},
        {"name": "banner_b1", "tile": Vector2(43, 2), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/banner_blue.png"},
        {"name": "banner_b2", "tile": Vector2(16, 7), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/banner_blue.png"},
        {"name": "banner_r2", "tile": Vector2(43, 7), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/banner_red.png"},
        {"name": "banner_r3", "tile": Vector2(16, 12), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/banner_red.png"},
        {"name": "banner_b3", "tile": Vector2(43, 12), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/banner_blue.png"},
        {"name": "moon", "tile": Vector2(23, 49), "w": 1, "h": 1, "solid": false, "layer": "base", "texture": "res://assets/sprites/props/moon.png"},
        {"name": "planet", "tile": Vector2(22, 49), "w": 3, "h": 3, "solid": false, "layer": "base", "texture": "res://assets/sprites/props/planet.png"},
        {"name": "island_1", "tile": Vector2(36, 50), "w": 3, "h": 2, "solid": false, "layer": "base", "texture": "res://assets/sprites/props/island.png", "bob": Vector2(2.0, 4.0)},
        {"name": "island_2", "tile": Vector2(27, 52), "w": 3, "h": 2, "solid": false, "layer": "base", "texture": "res://assets/sprites/props/island.png", "bob": Vector2(3.0, 5.0)},
        {"name": "asteroid_1", "tile": Vector2(31, 48), "w": 1, "h": 1, "solid": false, "layer": "base", "texture": "res://assets/sprites/props/asteroid_1.png", "bob": Vector2(1.5, 3.0)},
        {"name": "asteroid_2", "tile": Vector2(41, 52), "w": 1, "h": 1, "solid": false, "layer": "base", "texture": "res://assets/sprites/props/asteroid_2.png", "bob": Vector2(2.0, 3.6)},
        {"name": "asteroid_3", "tile": Vector2(18, 53), "w": 1, "h": 1, "solid": false, "layer": "base", "texture": "res://assets/sprites/props/asteroid_1.png", "bob": Vector2(1.5, 3.2)},
        {"name": "torch_0", "tile": Vector2(18, 0), "w": 1, "h": 2, "solid": false, "layer": "over", "anim": ["res://assets/sprites/props/torch", 3, 6.0]},
        {"name": "torch_1", "tile": Vector2(23, 0), "w": 1, "h": 2, "solid": false, "layer": "over", "anim": ["res://assets/sprites/props/torch", 3, 6.0]},
        {"name": "torch_2", "tile": Vector2(30, 0), "w": 1, "h": 2, "solid": false, "layer": "over", "anim": ["res://assets/sprites/props/torch", 3, 6.0]},
        {"name": "torch_3", "tile": Vector2(36, 0), "w": 1, "h": 2, "solid": false, "layer": "over", "anim": ["res://assets/sprites/props/torch", 3, 6.0]},
        {"name": "torch_4", "tile": Vector2(41, 0), "w": 1, "h": 2, "solid": false, "layer": "over", "anim": ["res://assets/sprites/props/torch", 3, 6.0]},
        {"name": "crystal_0", "tile": Vector2(19, 41), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal", 2, 2.0]},
        {"name": "crystal_1", "tile": Vector2(40, 40), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal", 2, 2.0]},
        {"name": "crystal_2", "tile": Vector2(18, 44), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal", 2, 2.0]},
        {"name": "crystal_3", "tile": Vector2(36, 43), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal", 2, 2.0]},
        {"name": "crystal_4", "tile": Vector2(23, 44), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal_violet", 2, 2.0]},
        {"name": "crystal_5", "tile": Vector2(39, 43), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal_violet", 2, 2.0]},
        {"name": "crystal_6", "tile": Vector2(42, 38), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal_violet", 2, 2.0]},
        {"name": "lantern_0", "tile": Vector2(27, 22), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/lantern.png"},
        {"name": "lantern_1", "tile": Vector2(33, 22), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/lantern.png"},
        {"name": "lantern_2", "tile": Vector2(27, 30), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/lantern.png"},
        {"name": "lantern_3", "tile": Vector2(33, 30), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/lantern.png"},
        {"name": "lantern_4", "tile": Vector2(27, 38), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/lantern.png"},
        {"name": "lantern_5", "tile": Vector2(33, 38), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/lantern.png"},
]

const DOORS: Array[Dictionary] = [
        {"id": "dungeon_1", "tiles": [Vector2(19, 0), Vector2(20, 0)]},
        {"id": "dungeon_2", "tiles": [Vector2(26, 0), Vector2(27, 0)]},
        {"id": "dungeon_3", "tiles": [Vector2(32, 0), Vector2(33, 0)]},
        {"id": "dungeon_4", "tiles": [Vector2(39, 0), Vector2(40, 0)]},
]

## Шаг 33: свободна ли точка мира (пиксели) — для восстановления позиции
## героя из сейва. Проверяем тайл карты (SOLID_TILES), твёрдые пропы
## и тайлы, где стоят NPC. Космос за островом — свободен (герой там ходит).
static func is_pos_free(pos: Vector2) -> bool:
    var tx := int(floor(pos.x / float(TILE_SIZE)))
    var ty := int(floor(pos.y / float(TILE_SIZE)))
    if tx < 0 or ty < 0 or tx >= MAP_W or ty >= MAP_H:
        return false
    var row := MAP[ty] if ty < MAP.size() else ""
    var ch := row[tx] if tx < row.length() else "#"
    if SOLID_TILES.contains(ch):
        return false
    for prop in PROPS:
        if not bool(prop.get("solid", false)):
            continue
        var t: Vector2 = prop["tile"]
        if tx >= int(t.x) and tx < int(t.x) + int(prop["w"]) \
                and ty >= int(t.y) and ty < int(t.y) + int(prop["h"]):
            return false
    for npc in NPCS:
        if npc["tile"] == Vector2(tx, ty):
            return false
    return true
