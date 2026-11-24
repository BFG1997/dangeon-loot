## Бестиарий и генератор подземелий «Dungeon Loot» (шаги 13–16).
## Данж 1 — «Подземелье замка» (шаг 15): 4 БОЛЬШИХ тематических этажа.
## Шаг 17: коридоры шириной 3 в обеих осях и проход в зал босса шириной 3 —
## в них можно обойти встречного врага и кайтить (герой 95, все враги ниже).
## Карта 64x48, комнат 10–13, врагов на этаж 7–13 (плюс элитные «чемпионы»
## и хранитель сокровищницы).
## Данж 2 — «Скит Пустоты» (шаг 16): открывается после победы над демоном
## в данже 1 (дверь 2 замка). 4 этажа, население — КУЛЬТИСТЫ (5 видов):
## послушник, фанатик, тяжеловес, чтец (колдун), старейшина (колдун).
## Босс 4-го этажа — Великий культист со щупальцами (лист 72x96, как у
## демона данжа 1). Его победа НЕ воскрешает жителей — это умеет только
## демон: он же вершил убийства. Убитый босс данжа 2 мёртв навсегда
## (dungeons_cleared сохраняется в сейве).
## Каждый этаж — своя тема (тайлы стен/полов, декор, акценты, свет):
##   1 «Смрадные катакомбы» — пауки и змеи, паутина, мшистый камень;
##   2 «Пустотные чертоги» — космические пауки и мертвецы, звёздный камень,
##     фиолетовые трещины и кристаллы;
##   3 «Костяная обитель» — мертвецы всех видов, пол в костях, смерть-свечение;
##   4 «Багровое логово» — высшие демоны, угли, ковровая дорожка к трону
##     и обязательный босс: Таинственный демон с юга карты (в диалоге он
##     узнаёт героя, если тот видел его у края мира).
## На этажах 1–3 есть СОКРОВИЩНИЦА: зал из золотой мозаики с парой сундуков,
## кристаллами и элитным хранителем. На 4-м — большой зал босса с колоннами,
## жаровнями и ковровой дорожкой. Сундуков на этаже 5–7 (шаг 19 — больше).
## Шаг 19: лестница вниз открыта сразу — убивать всех не обязательно;
## за врагов дают опыт ("xp"), у героя — уровни (урон и ХП растут вдвое).
## Данж 3 — «Глубины Р'льеха» (шаг 20): открывается после победы над
## Великим культистом (дверь 3 замка). 4 этажа, население — ЛАВКРАФТИАНСКИЕ
## ЧУДОВИЩА (5 видов): Глубинный, Ползун щупалец, Пожиратель снов
## (колдун), Отродье звёзд и Шоггот. Босс 4-го этажа — Большой Ктулху
## (лист 72x96, как у прочих боссов). Арт — tools/gen_dungeon3.py,
## тайлы в свободных клетках атласа (ряды 6–7 и хвост ряда 5).
## Шаг 24: БАЛАНС ПЕРЕСОБРАН — хп/урон/награды данжей 1–3 выровнены
## в плавную кривую (раньше скачки вида «паук 12 хп, потом 75»); данж 4
## «Логово Древних» — космический хоррор: 5 видов тварей с щупальцами
## (арт — tools/gen_dungeon4.py, тайлы в рядах 8–9 атласа) и босс
## Шуб-Ниггурат (лист 96x128, x4 — стреляет спорами, зовёт полчища).
## У боссов данжей 1–3 есть boss_key — ключ следующего подземелья
## (в реестре DUNGEONS), падает с босса и показывается на экране.
## Числа хп/урона/скоростей и награды подтверждены балансным проходом шага 25.
class_name DungeonBestiary
extends RefCounted

const SHEET_DIR := "res://assets/sprites/dungeon/"

## Противники 1-го подземелья, по возрастанию сложности (порядок важен:
## от него зависит, каких врагов какой этаж может заспавнить).
## ranged: true — колдун: держит дистанцию и швыряет болт (болт летит
## со скоростью bolt_speed на дистанцию bolt_range, перезарядка bolt_cd).
## gold — награда за убийство; xp — опыт за победу (шаг 19).
## Шаг 24: баланс — каждый следующий вид заметно крепче предыдущего,
## без «стен» на середине данжа. Награды растут вместе с силой.
const FOES: Array[Dictionary] = [
    {"id": "spider", "name": "Паук", "hp": 10, "damage": 3, "speed": 70.0,
        "sheet": SHEET_DIR + "spider.png", "ranged": false,
        "aggro": 110.0, "attack_range": 22.0, "attack_cd": 1.1,
        "gold": 3, "xp": 4, "bolt_color": [0.55, 0.85, 0.95]},
    {"id": "snake", "name": "Змея", "hp": 14, "damage": 5, "speed": 85.0,
        "sheet": SHEET_DIR + "snake.png", "ranged": false,
        "aggro": 110.0, "attack_range": 22.0, "attack_cd": 1.0,
        "gold": 4, "xp": 6, "bolt_color": [0.5, 0.9, 0.55]},
    {"id": "cosmic_spider", "name": "Космический паук", "hp": 22, "damage": 7,
        "speed": 80.0, "sheet": SHEET_DIR + "cosmic_spider.png", "ranged": false,
        "aggro": 120.0, "attack_range": 24.0, "attack_cd": 1.0,
        "gold": 6, "xp": 10, "bolt_color": [0.72, 0.55, 0.95]},
    {"id": "undead_bum", "name": "Мертвец бомж", "hp": 30, "damage": 8,
        "speed": 52.0, "sheet": SHEET_DIR + "undead_bum.png", "ranged": false,
        "aggro": 120.0, "attack_range": 24.0, "attack_cd": 1.2,
        "gold": 8, "xp": 14, "bolt_color": [0.6, 0.7, 0.5]},
    {"id": "undead_knight", "name": "Мертвец рыцарь", "hp": 48, "damage": 11,
        "speed": 58.0, "sheet": SHEET_DIR + "undead_knight.png", "ranged": false,
        "aggro": 130.0, "attack_range": 26.0, "attack_cd": 1.2,
        "gold": 12, "xp": 22, "bolt_color": [0.75, 0.75, 0.8]},
    {"id": "undead_sorcerer", "name": "Мертвец колдун", "hp": 38, "damage": 9,
        "speed": 44.0, "sheet": SHEET_DIR + "undead_sorcerer.png", "ranged": true,
        "aggro": 150.0, "attack_range": 120.0, "attack_cd": 1.8,
        "gold": 14, "xp": 20, "bolt_color": [0.45, 0.8, 0.6], "bolt_speed": 130.0,
        "bolt_range_px": 190.0, "keep_distance": 90.0},
    {"id": "demon_swordsman", "name": "Демон мечник", "hp": 64, "damage": 14,
        "speed": 72.0, "sheet": SHEET_DIR + "demon_swordsman.png", "ranged": false,
        "aggro": 130.0, "attack_range": 26.0, "attack_cd": 1.0,
        "gold": 18, "xp": 30, "bolt_color": [0.95, 0.5, 0.3]},
    {"id": "demon_sorcerer", "name": "Демон колдун", "hp": 52, "damage": 12,
        "speed": 62.0, "sheet": SHEET_DIR + "demon_sorcerer.png", "ranged": true,
        "aggro": 150.0, "attack_range": 120.0, "attack_cd": 1.6,
        "gold": 22, "xp": 26, "bolt_color": [0.95, 0.45, 0.55], "bolt_speed": 150.0,
        "bolt_range_px": 210.0, "keep_distance": 100.0},
]

## Обязательный босс последнего этажа: тот самый Таинственный демон,
## что появлялся на юге карты. Если мы видели его — он узнаёт героя,
## говорит об этом, и начинается битва. Лист 72x96 — он втрое крупнее
## обычных врагов (как у демона с юга мира). Числа подтверждены (шаг 25).
const BOSS: Dictionary = {
    "id": "boss_demon", "name": "Таинственный демон", "hp": 300, "damage": 12,
    "speed": 58.0, "sheet": "res://assets/sprites/chars/demon.png",
    "portrait": "res://assets/sprites/portraits/demon.png", "scale": 3,
    "aggro": 260.0, "attack_range": 34.0, "attack_cd": 1.0, "gold": 300,
    "xp": 200,
    "knows_hero": true,
    "role_seen": "узнавший тебя",
    "role_new": "хозяин подземелья",
    "lines_seen": [
        "Ты помнишь меня. Я помню тебя: ты шёл к краю мира и говорил со мной, как с лавочником. Как со «смертным».",
        "Каждое убийство кормило меня. Каждая монета в моей лавке прошла через твои руки. Ты думал, я торгую? Я собирал.",
        "Четыре этажа ты спускался к своей могиле. Каждый шаг кормил меня. Я — сама могила. Начнём.",
    ],
    "lines_new": [
        "А вот и ты. Я ждал тебя у края мира, но ты пришёл сюда: из всех дверей замка выбрал мою.",
        "Я — эхо того, что спит под замком. Мой голос слышали все, кто умирал на этих этажах. Теперь он слышит тебя.",
        "Неважно, видел ты меня раньше или нет: ты видишь меня сейчас. Этого достаточно.",
    ],
}

## Противники данжа 2 «Скит Пустоты» (шаг 16), по возрастанию сложности.
## Числа подтверждены (шаг 25). Чтец и старейшина — колдуны:
## держат дистанцию и швыряют болты Пустоты (см. ИИ "ranged" в dungeon.gd).
## Шаг 24: баланс культистов — послушник живёт чуть дольше (шаг 22
## сбрасывал его в 20 хп: умирал от одного взгляда), фанатик бьёт больно,
## тяжеловес — подвижная стена. Скорости по-прежнему ниже 95 (кайт).
const FOES_2: Array[Dictionary] = [
    {"id": "cultist_acolyte", "name": "Культист-послушник", "hp": 28,
        "damage": 9, "speed": 75.0,
        "sheet": SHEET_DIR + "cultist_acolyte.png", "ranged": false,
        "aggro": 120.0, "attack_range": 22.0, "attack_cd": 1.1,
        "gold": 7, "xp": 9, "bolt_color": [0.62, 0.52, 0.9]},
    {"id": "cultist_fanatic", "name": "Культист-фанатик", "hp": 22,
        "damage": 13, "speed": 88.0,   # шаг 17: было 95 — как у героя, кайт невозможен
        "sheet": SHEET_DIR + "cultist_fanatic.png", "ranged": false,
        "aggro": 140.0, "attack_range": 22.0, "attack_cd": 0.9,
        "gold": 9, "xp": 11, "bolt_color": [0.9, 0.4, 0.35]},
    {"id": "cultist_chanter", "name": "Культист-чтец", "hp": 42,
        "damage": 12, "speed": 48.0,
        "sheet": SHEET_DIR + "cultist_chanter.png", "ranged": true,
        "aggro": 150.0, "attack_range": 120.0, "attack_cd": 1.7,
        "gold": 14, "xp": 17, "bolt_color": [0.62, 0.45, 0.92], "bolt_speed": 140.0,
        "bolt_range_px": 200.0, "keep_distance": 95.0},
    {"id": "cultist_guardian", "name": "Культист-тяжеловес", "hp": 78,
        "damage": 15, "speed": 45.0,
        "sheet": SHEET_DIR + "cultist_guardian.png", "ranged": false,
        "aggro": 110.0, "attack_range": 26.0, "attack_cd": 1.4,
        "gold": 16, "xp": 26, "bolt_color": [0.78, 0.66, 0.4]},
    {"id": "cultist_elder", "name": "Культист-старейшина", "hp": 58,
        "damage": 14, "speed": 52.0,
        "sheet": SHEET_DIR + "cultist_elder.png", "ranged": true,
        "aggro": 150.0, "attack_range": 130.0, "attack_cd": 1.5,
        "gold": 20, "xp": 24, "bolt_color": [0.72, 0.55, 0.95], "bolt_speed": 160.0,
        "bolt_range_px": 230.0, "keep_distance": 105.0},
]

## Босс данжа 2 (шаг 16): Великий культист со щупальцами — верховный жрец
## Пустоты, глава скита за второй дверью. Лист 72x96 — втрое крупнее
## обычных врагов (как у демона данжа 1). Героя никогда не встречал,
## но Пустота шептала ему о герое — потому реплики одни (lines_new).
## Числа подтверждены (шаг 25). knows_hero=false: demon_seen на него не влияет.
const BOSS_2: Dictionary = {
    "id": "boss_cultist_overlord", "name": "Великий культист",
    "hp": 420, "damage": 15, "speed": 55.0,
    "sheet": SHEET_DIR + "cultist_overlord.png",
    "portrait": "res://assets/sprites/portraits/cultist_overlord.png",
    "scale": 3, "aggro": 260.0, "attack_range": 36.0, "attack_cd": 1.1,
    "gold": 350, "xp": 250,
    "role_seen": "верховный жрец Пустоты",
    "role_new": "верховный жрец Пустоты",
    "lines_seen": [],
    "lines_new": [
        "Так это ты гремишь в наших кельях. Пустота шептала мне о тебе с первого этажа: «идёт смертный, и клинок его поёт».",
        "Демон? Наш прежний сосед снизу? Он был лишь дверью, а я — то, что за дверью. Он кормился убийствами. Я кормлюсь тишиной.",
        "Пять видов культистов легли под твой клинок. Ляг и ты: у Пустоты хватит места для всех. Начнём обряд.",
    ],
}

## Противники данжа 3 «Глубины Р'льеха» (шаг 20), по возрастанию сложности.
## Числа подтверждены (шаг 25). Пожиратель снов — колдун.
## Скорости ниже 95 (кайт героя, как в данжах 1–2).
## Шаг 24: баланс глубин — Р'льех ощутимо крепче скита: Глубинный
## держит удар, Шоггот почти пробивает героя с двух рук. Награды
## соответствуют риску.
const FOES_3: Array[Dictionary] = [
    {"id": "deep_one", "name": "Глубинный", "hp": 44, "damage": 12,
        "speed": 78.0, "sheet": SHEET_DIR + "deep_one.png", "ranged": false,
        "aggro": 130.0, "attack_range": 24.0, "attack_cd": 1.0,
        "gold": 12, "xp": 14, "bolt_color": [0.5, 0.85, 0.6]},
    {"id": "tentacle_crawler", "name": "Ползун щупалец", "hp": 36,
        "damage": 11, "speed": 86.0,
        "sheet": SHEET_DIR + "tentacle_crawler.png", "ranged": false,
        "aggro": 140.0, "attack_range": 22.0, "attack_cd": 0.9,
        "gold": 13, "xp": 15, "bolt_color": [0.75, 0.55, 0.9]},
    {"id": "dream_eater", "name": "Пожиратель снов", "hp": 58, "damage": 13,
        "speed": 48.0, "sheet": SHEET_DIR + "dream_eater.png", "ranged": true,
        "aggro": 155.0, "attack_range": 125.0, "attack_cd": 1.6,
        "gold": 18, "xp": 22, "bolt_color": [0.6, 0.9, 0.65],
        "bolt_speed": 150.0, "bolt_range_px": 220.0, "keep_distance": 100.0},
    {"id": "star_spawn", "name": "Отродье звёзд", "hp": 78, "damage": 16,
        "speed": 82.0, "sheet": SHEET_DIR + "star_spawn.png", "ranged": false,
        "aggro": 140.0, "attack_range": 26.0, "attack_cd": 1.0,
        "gold": 22, "xp": 28, "bolt_color": [0.5, 0.9, 0.85]},
    {"id": "shoggoth", "name": "Шоггот", "hp": 125, "damage": 20, "speed": 42.0,
        "sheet": SHEET_DIR + "shoggoth.png", "ranged": false,
        "aggro": 110.0, "attack_range": 26.0, "attack_cd": 1.3,
        "gold": 28, "xp": 36, "bolt_color": [0.55, 0.8, 0.5]},
]

## Босс данжа 3 (шаг 20, устрашён в шаге 21): Большой Ктулху — спящий
## под троном Р'льеха. Лист 96x128 — x4, Ктулху нависает над героем как
## башня тьмы (перерисован tools/gen_cthulhu_step21.py: крылья во всю
## ширь, борода щупалец, угли-глаза). Героя не знал никогда; знает все
## имена, включая его. Числа подтверждены (шаг 25).
const BOSS_3: Dictionary = {
    "id": "boss_cthulhu", "name": "Большой Ктулху", "hp": 850, "damage": 26,
    "speed": 54.0, "sheet": SHEET_DIR + "boss_cthulhu.png",
    "portrait": "res://assets/sprites/portraits/boss_cthulhu.png",
    "scale": 4, "aggro": 300.0, "attack_range": 46.0, "attack_cd": 1.2,
    "gold": 650, "xp": 500,
    "role_seen": "спящий в Р'льехе",
    "role_new": "спящий в Р'льехе",
    "lines_seen": [],
    "lines_new": [
        "Морг. Ты моргнул — а я видел каждый твой день наперёд. Твой приход сюда — моя скука, развеянная на один выдох.",
        "Культисты пахли страхом. Демон — пеплом. Ты пахнешь сном: я буду есть тебя в каждом сне, что тебе остался.",
        "Р'льех поднимается, когда кричат звёзды. Умоляй на любом языке — я знаю все. Языки умирают последними.",
    ],
}

## Противники данжа 4 «Логово Древних» (шаг 24), по возрастанию сложности.
## Арт — tools/gen_dungeon4.py (твари с щупальцами, космический хоррор).
## Жрец гулей и Древняя тварь — колдуны (споры). Числа подтверждены (шаг 25).
## Скорости ниже 95 (кайт героя, как в данжах 1–3).
const FOES_4: Array[Dictionary] = [
    {"id": "night_gaunt", "name": "Ночной гонт", "hp": 48,
        "damage": 12, "speed": 90.0,
        "sheet": SHEET_DIR + "night_gaunt.png", "ranged": false,
        "aggro": 140.0, "attack_range": 24.0, "attack_cd": 0.9,
        "gold": 26, "xp": 34, "bolt_color": [0.6, 0.9, 0.85]},
    {"id": "moon_beast", "name": "Лунный зверь", "hp": 62,
        "damage": 14, "speed": 76.0,
        "sheet": SHEET_DIR + "moon_beast.png", "ranged": false,
        "aggro": 130.0, "attack_range": 26.0, "attack_cd": 1.1,
        "gold": 30, "xp": 38, "bolt_color": [0.95, 0.6, 0.5]},
    {"id": "ghoul_priest", "name": "Жрец гулей", "hp": 70,
        "damage": 13, "speed": 46.0,
        "sheet": SHEET_DIR + "ghoul_priest.png", "ranged": true,
        "aggro": 155.0, "attack_range": 130.0, "attack_cd": 1.5,
        "gold": 34, "xp": 36, "bolt_color": [0.7, 0.9, 0.55],
        "bolt_speed": 160.0, "bolt_range_px": 240.0, "keep_distance": 105.0},
    {"id": "elder_thing", "name": "Древняя тварь", "hp": 90,
        "damage": 16, "speed": 40.0,
        "sheet": SHEET_DIR + "elder_thing.png", "ranged": true,
        "aggro": 150.0, "attack_range": 135.0, "attack_cd": 1.6,
        "gold": 40, "xp": 44, "bolt_color": [0.5, 0.9, 0.8],
        "bolt_speed": 170.0, "bolt_range_px": 250.0, "keep_distance": 110.0},
    {"id": "tentacle_abomination", "name": "Абоминация щупалец", "hp": 140,
        "damage": 20, "speed": 38.0,
        "sheet": SHEET_DIR + "tentacle_abomination.png", "ranged": false,
        "aggro": 110.0, "attack_range": 28.0, "attack_cd": 1.3,
        "gold": 46, "xp": 52, "bolt_color": [0.8, 0.6, 0.9]},
]

## Босс данжа 4 (шаг 24): Шуб-Ниггурат, Чёрная Коза Тысячи Младенцев —
## Мать монстров. Лист 96x128 (x4, как у Ктулху). В бою стреляет веером
## спор, на порогах ХП зовёт полчища своих детенышей (см. dungeon.gd).
## Её победа запускает ФИНАЛ: в замке умирают все NPC, кроме Лир.
## Числа подтверждены (шаг 25). knows_hero=false: она не говорила с героем — она
## его растила.
const BOSS_4: Dictionary = {
    "id": "boss_shub", "name": "Шуб-Ниггурат", "hp": 1200, "damage": 24,
    "speed": 50.0, "sheet": SHEET_DIR + "boss_shub.png",
    "portrait": "res://assets/sprites/portraits/boss_shub.png",
    "scale": 4, "aggro": 300.0, "attack_range": 46.0, "attack_cd": 1.2,
    "gold": 900, "xp": 800,
    "role_seen": "Мать монстров",
    "role_new": "Мать монстров",
    "lines_seen": [],
    "lines_new": [
        "Каждый тебе убитый кормил не только демона. Каждый тебе этаж полил мои корни. Ты растил меня, смертный, — и вот я выросла.",
        "Культисты пели мне. Глубинные спали со мной. Ктулху мне снился. Тебя я не видела лишь потому, что ты был занят: ты поднимал мой сад по стебельку.",
        "Мои младенцы уже идут. Стань молоком — или моим последним всадником. Выбери, чем ты пахнешь для них.",
    ],
}

# ------------------------------------------------------- этажи и темы (шаги 15/20)

const FLOORS := 4
const MAP_W := 64
const MAP_H := 48

## Тема этажа: тайлы стен/полов из атласа, цвет «воздуха» (CanvasModulate),
## плотность декора (паутина/кости/кровь/свечение), пул врагов и их число.
## wall/floors/glow — координаты тайлов в assets/tilesets/dungeon_tiles.png.
## hint — реплика при входе на этаж (тон — лавкрафтовский космо-хоррор).
const THEMES: Array[Dictionary] = [
    {
        "id": "catacombs", "name": "Смрадные катакомбы",
        "wall": Vector2i(2, 0),
        "floors": [Vector2i(0, 1), Vector2i(1, 1), Vector2i(4, 1)],
        "glow": Vector2i(5, 2),
        "canvas": Color(0.8, 0.86, 0.79),
        "webs": 26, "bones": 10, "blood": 10, "glow_n": 16,
        "pool": ["spider", "snake"],
        "foes_min": 7, "foes_max": 9,
        "hint": "Смрадные катакомбы. Паутина на каждом шагу, и ползёт что-то бесчисленное. Кости у стен — чьи-то, но не твои. Пока не твои.",
    },
    {
        "id": "void_halls", "name": "Пустотные чертоги",
        "wall": Vector2i(3, 0),
        "floors": [Vector2i(0, 1), Vector2i(5, 1), Vector2i(1, 1)],
        "glow": Vector2i(6, 2),
        "canvas": Color(0.79, 0.76, 0.9),
        "webs": 8, "bones": 8, "blood": 8, "glow_n": 18,
        "pool": ["cosmic_spider", "undead_bum"],
        "foes_min": 8, "foes_max": 10,
        "hint": "Пустотные чертоги. Камни здесь помнят чужие звёзды: фиолетовые трещины светятся в темноте, и в них смотрит что-то безымянное.",
    },
    {
        "id": "ossuary", "name": "Костяная обитель",
        "wall": Vector2i(4, 0),
        "floors": [Vector2i(0, 1), Vector2i(6, 1), Vector2i(1, 1)],
        "glow": Vector2i(7, 2),
        "canvas": Color(0.85, 0.84, 0.8),
        "webs": 4, "bones": 30, "blood": 10, "glow_n": 10,
        "pool": ["undead_bum", "undead_knight", "undead_sorcerer"],
        "foes_min": 9, "foes_max": 12,
        "hint": "Костяная обитель. Пол выстлан костями тех, кто спускался раньше тебя. Мертвецы не любят гостей, а колдуны — тем более.",
    },
    {
        "id": "crimson_lair", "name": "Багровое логово",
        "wall": Vector2i(5, 0),
        "floors": [Vector2i(0, 1), Vector2i(7, 1), Vector2i(1, 1)],
        "glow": Vector2i(0, 3),
        "canvas": Color(0.9, 0.79, 0.75),
        "webs": 0, "bones": 8, "blood": 24, "glow_n": 14,
        "pool": ["demon_swordsman", "demon_sorcerer"],
        "foes_min": 10, "foes_max": 13,
        "hint": "Багровое логово. Воздух дрожит от шёпота, угли трещат в темноте. Дорожка ведёт к трону — и к хозяину подземелья.",
    },
]

## Темы этажей данжа 2 «Скит Пустоты» (шаг 16). Тайлы — из атласа шага 16:
## стены (6,0)/(7,0)/(0,4)/(1,4), полы (2,4)..(5,4), трещины (6,4)/(7,4)/(0,5)/(1,5).
const THEMES_2: Array[Dictionary] = [
    {
        "id": "cult_cells", "name": "Шёпотущие кельи",
        "wall": Vector2i(6, 0),
        "floors": [Vector2i(2, 4), Vector2i(0, 1), Vector2i(1, 1)],
        "glow": Vector2i(6, 4),
        "canvas": Color(0.84, 0.82, 0.87),
        "webs": 6, "bones": 6, "blood": 6, "glow_n": 12,
        "pool": ["cultist_acolyte", "cultist_fanatic"],
        "foes_min": 7, "foes_max": 9,
        "hint": "Шёпотущие кельи. Здесь жили послушники культа — и до сих пор шепчут молитвы во сне. Не прислушивайся: молитвы адресованы тебе.",
    },
    {
        "id": "light_halls", "name": "Зал свечений",
        "wall": Vector2i(7, 0),
        "floors": [Vector2i(3, 4), Vector2i(0, 1), Vector2i(1, 1)],
        "glow": Vector2i(7, 4),
        "canvas": Color(0.81, 0.77, 0.9),
        "webs": 4, "bones": 4, "blood": 8, "glow_n": 20,
        "pool": ["cultist_acolyte", "cultist_fanatic", "cultist_chanter"],
        "foes_min": 8, "foes_max": 10,
        "hint": "Зал свечений. Руны на стенах светятся сами, и свет этот жуткий: он не освещает, а смотрит. Чтецы культа поют в темноте.",
    },
    {
        "id": "sacrarium", "name": "Склеп жертв",
        "wall": Vector2i(0, 4),
        "floors": [Vector2i(4, 4), Vector2i(0, 1), Vector2i(1, 1)],
        "glow": Vector2i(0, 5),
        "canvas": Color(0.86, 0.8, 0.8),
        "webs": 0, "bones": 22, "blood": 16, "glow_n": 10,
        "pool": ["cultist_chanter", "cultist_guardian", "cultist_fanatic"],
        "foes_min": 9, "foes_max": 12,
        "hint": "Склеп жертв. Кости под ногами уложены бережно — их любили. Тяжеловесы стерегут проходы, чтецы поют им колыбельные.",
    },
    {
        "id": "void_sanctum", "name": "Святилище Пустоты",
        "wall": Vector2i(1, 4),
        "floors": [Vector2i(5, 4), Vector2i(0, 1), Vector2i(1, 1)],
        "glow": Vector2i(1, 5),
        "canvas": Color(0.78, 0.74, 0.87),
        "webs": 0, "bones": 6, "blood": 18, "glow_n": 16,
        "pool": ["cultist_guardian", "cultist_elder", "cultist_chanter"],
        "foes_min": 10, "foes_max": 13,
        "hint": "Святилище Пустоты. Финальные швы камней светятся фиолетовым, и за ними что-то дышит в такт твоим шагам. Верховный жрец ждёт.",
    },
]

## Темы этажей данжа 3 «Глубины Р'льеха» (шаг 20). Тайлы — свободные
## клетки атласа: стены (0,6)/(5,6)/(1,7)/(5,7), полы (2,6)..(7,7),
## свечение (4,6)/(0,7)/(4,7)/(2,5) — см. tools/gen_dungeon3.py.
const THEMES_3: Array[Dictionary] = [
    {
        "id": "drowned_grottos", "name": "Затопленные гроты",
        "wall": Vector2i(0, 6),
        "floors": [Vector2i(2, 6), Vector2i(3, 6), Vector2i(0, 1)],
        "glow": Vector2i(4, 6),
        "canvas": Color(0.78, 0.86, 0.8),
        "webs": 4, "bones": 6, "blood": 6, "glow_n": 16,
        "pool": ["deep_one", "tentacle_crawler"],
        "foes_min": 7, "foes_max": 9,
        "hint": "Затопленные гроты. Вода стоит по колено веками, и в ней смотрят глаза. Глубинные не любят гостей — они их едят.",
    },
    {
        "id": "forbidden_library", "name": "Библиотека запретных имён",
        "wall": Vector2i(5, 6),
        "floors": [Vector2i(6, 6), Vector2i(7, 6), Vector2i(0, 1)],
        "glow": Vector2i(0, 7),
        "canvas": Color(0.82, 0.84, 0.82),
        "webs": 10, "bones": 4, "blood": 4, "glow_n": 14,
        "pool": ["dream_eater", "deep_one", "tentacle_crawler"],
        "foes_min": 8, "foes_max": 10,
        "hint": "Библиотека запретных имён. Здесь хранят слова, от которых ломаются языки. Читай тихо: Пожиратели снов слушают.",
    },
    {
        "id": "tentacle_nest", "name": "Гнездо щупалец",
        "wall": Vector2i(1, 7),
        "floors": [Vector2i(2, 7), Vector2i(3, 7), Vector2i(0, 1)],
        "glow": Vector2i(4, 7),
        "canvas": Color(0.86, 0.8, 0.82),
        "webs": 0, "bones": 10, "blood": 22, "glow_n": 12,
        "pool": ["tentacle_crawler", "star_spawn", "shoggoth"],
        "foes_min": 9, "foes_max": 12,
        "hint": "Гнездо щупалец. Пол дышит, стены сокращаются, и по потолку течёт что-то живое. Отродья звёзд стерегут кладку.",
    },
    {
        "id": "rlyeh_throne", "name": "Трон Р'льеха",
        "wall": Vector2i(5, 7),
        "floors": [Vector2i(6, 7), Vector2i(7, 7), Vector2i(0, 1)],
        "glow": Vector2i(2, 5),
        "canvas": Color(0.76, 0.82, 0.78),
        "webs": 0, "bones": 8, "blood": 18, "glow_n": 18,
        "pool": ["star_spawn", "shoggoth", "dream_eater"],
        "foes_min": 10, "foes_max": 13,
        "hint": "Трон Р'льеха. Плиты старше замка, старше мира. Под ними спит Большой Ктулху — и ты разбудил его.",
    },
]

## Темы этажей данжа 4 «Логово Древних» (шаг 24). Тайлы — ряды 8–9
## атласа (см. tools/gen_dungeon4.py): стены (0,8)/(5,8)/(1,9)/(5,9),
## полы (2,8)..(7,9), свечение (4,8)/(0,9)/(4,9)/(7,5).
const THEMES_4: Array[Dictionary] = [
    {
        "id": "blasphemous_grove", "name": "Богохульная роща",
        "wall": Vector2i(0, 8),
        "floors": [Vector2i(2, 8), Vector2i(3, 8), Vector2i(0, 1)],
        "glow": Vector2i(4, 8),
        "canvas": Color(0.76, 0.84, 0.76),
        "webs": 4, "bones": 6, "blood": 8, "glow_n": 16,
        "pool": ["night_gaunt", "moon_beast"],
        "foes_min": 7, "foes_max": 9,
        "hint": "Богохульная роща. Здесь растут глаза вместо цветов, и каждый смотрит только на тебя. Гонты сторожат аллеи.",
    },
    {
        "id": "star_vaults", "name": "Звёздные чертоги",
        "wall": Vector2i(5, 8),
        "floors": [Vector2i(6, 8), Vector2i(7, 8), Vector2i(0, 1)],
        "glow": Vector2i(0, 9),
        "canvas": Color(0.78, 0.8, 0.9),
        "webs": 0, "bones": 8, "blood": 6, "glow_n": 18,
        "pool": ["moon_beast", "ghoul_priest"],
        "foes_min": 8, "foes_max": 10,
        "hint": "Звёздные чертоги. Звёзды вморожены в камень заживо — они ещё светятся. Жрецы гулей собирают их свет в споры.",
    },
    {
        "id": "shub_garden", "name": "Сад Шуб-Ниггурат",
        "wall": Vector2i(1, 9),
        "floors": [Vector2i(2, 9), Vector2i(3, 9), Vector2i(0, 1)],
        "glow": Vector2i(4, 9),
        "canvas": Color(0.82, 0.8, 0.76),
        "webs": 0, "bones": 10, "blood": 20, "glow_n": 14,
        "pool": ["ghoul_priest", "elder_thing", "tentacle_abomination"],
        "foes_min": 9, "foes_max": 12,
        "hint": "Сад Шуб-Ниггурат. Молочные споры светятся в темноте, и по ним ходят её дети. Не наступай на грядки: они наступят в ответ.",
    },
    {
        "id": "black_altar", "name": "Чёрный алтарь",
        "wall": Vector2i(5, 9),
        "floors": [Vector2i(6, 9), Vector2i(7, 9), Vector2i(0, 1)],
        "glow": Vector2i(7, 5),
        "canvas": Color(0.74, 0.72, 0.82),
        "webs": 0, "bones": 24, "blood": 18, "glow_n": 16,
        "pool": ["elder_thing", "tentacle_abomination", "night_gaunt"],
        "foes_min": 10, "foes_max": 13,
        "hint": "Чёрный алтарь. Кости вмурованы в мрамор заживо. На жертвеннике ждёт Коза Тысячи Младенцев — и её вымя полно.",
    },
]

## Реестр подземелий (шаг 16): имя для HUD и реплики-подсказки этажей/босса.
const DUNGEONS: Array[Dictionary] = [
    {
        "id": "dungeon_1", "name": "Подземелье замка",
        "intro_hint": "Подземелье замка. Четыре огромных этажа вниз, и на каждом что-то шевелится. На самом дне ждёт тот, кто уже знает твоё имя.",
        "boss_floor_hint": "Уровень 4 из 4. Воздух дрожит от шёпота. Хозяин подземелья ждёт тебя.",
        "boss_floor_done_hint": "Уровень 4 из 4. Здесь пахнет пеплом: хозяин подземелья уже повержен. Лестница в замок открыта.",
        "boss_hostile_hint": "Демон бросается в бой! Ни лавки, ни милосердия — только когти и тьма.",
        "boss_defeated_hint": "Демон повержен! Убитые тобой жители вернулись в замок и ничего не помнят. Демон больше не вернётся — ни сюда, ни к краю мира.",
        "boss_epic_hint": "Среди пепла демона осталось оружие — %s. Эпическая добыча, она твоя.",
        ## Шаг 24: босс отдаёт ключ следующего подземелья (выводится на экран).
        "boss_key": "key_skit",
    },
    {
        "id": "dungeon_2", "name": "Скит Пустоты",
        "intro_hint": "Скит Пустоты. За второй дверью живут те, кто молится тому, что спит под замком. Четыре этажа вниз — и они знают, что ты идёшь.",
        "boss_floor_hint": "Уровень 4 из 4. Шёпот стих: верховный жрец ждёт в святилище.",
        "boss_floor_done_hint": "Уровень 4 из 4. Святилище опустело: верховный жрец повержен. Лестница в замок открыта.",
        "boss_hostile_hint": "Великий культист начинает обряд! Щупальца Пустоты тянутся к тебе.",
        "boss_defeated_hint": "Верховный жрец повержен! Культ обезглавлен, скит замолчал. Пустота запомнила твой клинок — но подождёт.",
        "boss_epic_hint": "Среди пепла жреца осталось оружие — %s. Эпическая добыча культа, она твоя.",
        ## Шаг 24: босс отдаёт ключ следующего подземелья (выводится на экран).
        "boss_key": "key_depths",
    },
    {
        "id": "dungeon_3", "name": "Глубины Р'льеха",
        "intro_hint": "Глубины Р'льеха. За третьей дверью — город, которого нет на картах: гроты, библиотека запретных имён и трон спящего. Четыре этажа вниз.",
        "boss_floor_hint": "Уровень 4 из 4. Плиты гудят во сне. Большой Ктулху ждёт на троне.",
        "boss_floor_done_hint": "Уровень 4 из 4. Трон пуст: спящий снова спит — теперь надолго. Лестница в замок открыта.",
        "boss_hostile_hint": "Большой Ктулху проснулся! Небо над Р'льехом гаснет, крылья заслоняют свет, и щупальца тянутся к тебе.",
        "boss_defeated_hint": "Большой Ктулху повержен! Р'льех уходит обратно в сон, и глубины замолкают. Твой клинок теперь знает это имя.",
        "boss_epic_hint": "Среди чешуи спящего осталось оружие — %s. Эпическая добыча глубин, она твоя.",
        ## Шаг 21: шёпоты Р'льеха во время битвы (по кругу, каждые ~11 с).
        "boss_whispers": [
            "Шёпот Р'льеха: «Ты умер недели назад. Ты просто ещё не понял.»",
            "Шёпот Р'льеха: «Твоё имя я выплюну, когда наемся.»",
            "Шёпот Р'льеха: «Смотри мне в глаза. Они — двери.»",
            "Шёпот Р'льеха: «Глубина дышит тобой и не замечает.»",
        ],
        ## Шаг 24: босс отдаёт ключ следующего подземелья (выводится на экран).
        "boss_key": "key_ancients",
    },
    {
        "id": "dungeon_4", "name": "Логово Древних",
        "intro_hint": "Логово Древних. За четвёртой дверью — их сад: чёрный базальт, молочные споры и твари, у которых больше щупалец, чем мыслей. Четыре этажа вниз.",
        "boss_floor_hint": "Уровень 4 из 4. Споры стелются к жертвеннику. Шуб-Ниггурат ждёт своих младенцев.",
        "boss_floor_done_hint": "Уровень 4 из 4. Жертвенник пуст: Коза рассыпалась спорами. Что-то изменилось в замке наверху...",
        "boss_hostile_hint": "Шуб-Ниггурат выступила из спор! Её младенцы уже бегут к тебе со всех этажей.",
        "boss_defeated_hint": "Шуб-Ниггурат рассыпалась молочными спорами. Но замок наверху замолчал — и в этой тишине чей-то смех звучит победой.",
        "boss_epic_hint": "В спорах Матери осталось оружие — %s. Эпическая добыча Древних, она твоя.",
        ## Шаг 24: шёпот Козни во время битвы.
        "boss_whispers": [
            "Шёпот Козни: «Мои младенцы пьют твои шаги с первого этажа.»",
            "Шёпот Козни: «Ты выкормил меня корнями своих побед.»",
            "Шёпот Козни: «Стой спокойно. Молоко не сопротивляется.»",
            "Шёпот Козни: «Наверху она ждёт. Она всегда ждала.»",
        ],
        ## У финального босса ключа нет: после его победы открывается ФИНАЛ.
        "boss_key": "",
    },
]

## Определение подземелья по id (первый — на случай неизвестного id).
static func dungeon_meta(dungeon_id: String) -> Dictionary:
    for d in DUNGEONS:
        if String(d.get("id", "")) == dungeon_id:
            return d
    return DUNGEONS[0]

## Короткое имя подземелья для HUD («Подземелье · ур. N/4»).
static func dungeon_name(dungeon_id: String) -> String:
    return String(dungeon_meta(dungeon_id).get("name", "Подземелье"))

## Определение босса по подземелью (шаги 16/20: у данжей 2 и 3 свои боссы).
static func boss_for(dungeon_id: String) -> Dictionary:
    if dungeon_id == "dungeon_2":
        return BOSS_2
    if dungeon_id == "dungeon_3":
        return BOSS_3
    if dungeon_id == "dungeon_4":
        return BOSS_4
    return BOSS

## Тема этажа (с защитой от неверных номеров при загрузке старых сейвов).
static func theme_for_floor(floor_num: int, dungeon_id: String = "dungeon_1") -> Dictionary:
    var themes := THEMES
    if dungeon_id == "dungeon_2":
        themes = THEMES_2
    elif dungeon_id == "dungeon_3":
        themes = THEMES_3
    elif dungeon_id == "dungeon_4":
        themes = THEMES_4
    return themes[clampi(floor_num - 1, 0, themes.size() - 1)]

## Награда за врага: золото растёт с глубиной этажа (подтверждено, шаг 25).
static func foe_gold(def: Dictionary, floor_num: int) -> int:
    return int(def.get("gold", 3)) + floor_num * 3

## Определение врага по id: ищем в обоих бестиариях (пустой — не найден).
static func foe_def(foe_id: String) -> Dictionary:
    for source: Array in [FOES, FOES_2, FOES_3, FOES_4]:
        for def in source:
            if String(def.get("id", "")) == foe_id:
                return def
    return {}

## Пул врагов этажа — по теме этажа (шаг 15: строгая прогрессия видов).
static func pool_for_floor(floor_num: int, dungeon_id: String = "dungeon_1") -> Array:
    return theme_for_floor(floor_num, dungeon_id).get("pool", ["spider"])

## Сколько врагов на этаже: 7–13 по мере глубины (босс последнего — отдельно).
static func foe_count_for_floor(floor_num: int, dungeon_id: String = "dungeon_1") -> int:
    var theme := theme_for_floor(floor_num, dungeon_id)
    return randi_range(int(theme.get("foes_min", 7)),
        int(theme.get("foes_max", 9)))

# --------------------------------------------------------- генерация этажа

## Сундуков на этаж (шаг 15; шаг 19 — больше): 3–5 раскиданы по комнатам,
## ещё 2 — в сокровищнице (этажи 1–3) или в зале босса (этаж 4). Итого 5–7.
const CHESTS_MIN := 3
const CHESTS_MAX := 5
## Факелов на этаж: по стенам комнат и коридоров.
const TORCHES_MIN := 10
const TORCHES_MAX := 14

## Символы сетки: "#" — стена (твёрдая), "o" — колонна (твёрдая),
## "." — каменный пол, "b" — пол с костями, "w" — паутина, "x" — кровь,
## "g" — светящаяся трещина, "p" — ковёр, "m" — золотая мозаика,
## "<" — лестница наверх, ">" — лестница вниз, "X" — выход в замок.
## Все, кроме "#" и "o", проходимы; спавнить врагов/сундуки можно
## только на «чистых полах» (см. _open_floor).
const SOLID := "#o"

## Сгенерировать этаж floor_num (1..4). Возвращает:
## {"grid": Array[String], "spawn": Vector2i, "up": Vector2i,
##  "down": Vector2i (Vector2i(-1,-1) на этаже босса),
##  "foe_spawns": Array[Dictionary] — {"tile": Vector2i, "id": String,
##      "elite": bool} (элитные чемпионы: больше хп/урона/золота),
##  "chest_tiles": Array[Vector2i] (4–5 сундуков),
##  "torch_tiles": Array[Vector2i] (факелы у стен),
##  "prop_tiles": Array[Dictionary] — {"tile": Vector2i, "kind": String}
##      (бочки, ящики, кристаллы, жаровни, трон),
##  "vault_center": Vector2i (центр сокровищницы; Vector2i(-1,-1) на этаже
##      босса — там вместо неё большой зал),
##  "boss_tile": Vector2i (Vector2i(-1,-1), если босса нет — он уже убит
##  навсегда или этаж не последний),
##  "exit_tile": Vector2i (появляется на этаже босса после победы)}
static func generate_floor(floor_num: int, boss_present: bool,
        dungeon_id: String = "dungeon_1") -> Dictionary:
    var is_boss_floor := floor_num >= FLOORS
    var grid: Array[String] = []
    for y in range(MAP_H):
        grid.append("#".repeat(MAP_W))

    # зал босса: большой прямоугольник + прихожая с лестницей наверх;
    # обычные этажи: 10–13 комнат
    var rooms: Array[Rect2i] = []
    var hall := Rect2i(-1, -1, 0, 0)
    var ante := Rect2i(-1, -1, 0, 0)
    if is_boss_floor:
        hall = Rect2i(21, 5, 22, 14)
        _carve_rect(grid, hall)
        ante = Rect2i(30, 20, 4, 5)
        _carve_rect(grid, ante)
        # проход из зала в прихожую шириной 3 (шаг 17: кайт)
        _carve_rect(grid, Rect2i(31, hall.end.y, 3,
            ante.position.y - hall.end.y))
        rooms.append(hall)
        rooms.append(ante)
        rooms.append_array(_carve_rooms(grid, rooms))
    else:
        rooms = _carve_rooms(grid)

    # декор: колонны в больших залах, паутина/кости/кровь/свечение по теме.
    # ДО коридоров: коридоры вырезаются поверх декора, поэтому колонна
    # не может перекрыть единственный путь (шаг 15)
    _sprinkle_decor(grid, rooms, theme_for_floor(floor_num, dungeon_id))
    _connect_rooms(grid, rooms)

    # лестницы: наверх — в стартовой комнате (на этаже босса — в прихожей,
    # чтобы герой входил издалека); вниз — в самой дальней комнате
    var spawn := Vector2i(-1, -1)
    var up: Vector2i = _room_center(rooms[0])
    if is_boss_floor:
        up = _room_center(ante)
    _set_cell(grid, up, "<")
    spawn = up
    var down := Vector2i(-1, -1)
    if not is_boss_floor:
        down = _room_center(rooms[rooms.size() - 1])
        _set_cell(grid, down, ">")

    # босс: на ковровой дорожке зала (этаж последний и он ещё жив)
    var boss_tile := Vector2i(-1, -1)
    if is_boss_floor and boss_present:
        boss_tile = Vector2i(hall.position.x + hall.size.x / 2,
            hall.position.y + 5)
        _set_cell(grid, boss_tile, ".")

    # гарантированный декор зала босса (шаг 15): жаровни по углам и трон
    # за боссом — ДО врагов, чтобы никто не встал на их место;
    # эти клетки «резервируются» для врагов и сундуков
    var reserved: Array[Vector2i] = []
    var hall_props: Array[Dictionary] = []
    if is_boss_floor and hall.size.x > 0:
        _pick_hall_props(grid, hall, boss_tile, spawn, up,
            hall_props, reserved)

    # сокровищница: самая дальняя от входа комната выстлана золотой
    # мозаикой (этажи 1–3; на этаже босса вместо неё — большой зал)
    var vault := Rect2i(-1, -1, 0, 0)
    var vault_center := Vector2i(-1, -1)
    if not is_boss_floor and rooms.size() >= 3:
        vault = _farthest_room(rooms, _room_center(rooms[0]))
        vault_center = _room_center(vault)
        _fill_rect(grid, vault, "m")

    # ковровая дорожка к трону босса: только по чистым полам — лестницы,
    # тайл босса и мозаика не затрагиваются
    if is_boss_floor:
        var cx := hall.position.x + hall.size.x / 2
        for y in range(hall.position.y + 3,
                _room_center(ante).y + 1):
            if String(grid[y][cx]) == ".":
                _set_cell(grid, Vector2i(cx, y), "p")

    # враги: по свободным полам; стартовая комната и прихожая — тихие,
    # сокровищница — территория хранителя, в зале босса — не вплотную
    # к боссу. Элитные чемпионы: хранитель сокровищницы (всегда элита)
    # плюс 0–2 случайных чемпиона.
    var foe_spawns := _pick_foe_spawns(grid, rooms, spawn, down, boss_tile,
        vault, vault_center, floor_num, is_boss_floor, reserved, dungeon_id)

    # сундуки: 2 в сокровищнице (или в зале босса по углам) + 2–3 по этажу
    var chest_tiles := _pick_chest_tiles(grid, rooms, spawn, up, down,
        boss_tile, vault, vault_center, foe_spawns, is_boss_floor, hall,
        reserved)

    # рассыпанный реквизит: бочки/ящики/кристаллы по комнатам и в
    # сокровищнице (жаровни и трон уже стоят). Реквизит ДО факелов:
    # факелы не встанут на занятую клетку (шаг 15)
    var prop_tiles := hall_props
    prop_tiles.append_array(_pick_prop_tiles(grid, rooms, spawn, up, down,
        boss_tile, chest_tiles, foe_spawns, floor_num,
        is_boss_floor, hall, vault, reserved))

    # факелы: полы у стен, вдали от сундуков и друг от друга
    var torch_tiles := _pick_torch_tiles(grid, spawn, up, down, boss_tile,
        chest_tiles, foe_spawns, prop_tiles)

    var exit_tile := Vector2i(-1, -1)
    if is_boss_floor and not boss_present:
        # босс уже повержен навсегда: выход ждёт в прихожей зала,
        # рядом с лестницей наверх
        exit_tile = _room_center(ante) + Vector2i(1, 0)
        if not _open_floor(grid, exit_tile):
            exit_tile = _room_center(ante)

    return {"grid": grid, "spawn": spawn, "up": up, "down": down,
        "foe_spawns": foe_spawns, "chest_tiles": chest_tiles,
        "torch_tiles": torch_tiles, "prop_tiles": prop_tiles,
        "vault_center": vault_center, "boss_tile": boss_tile,
        "exit_tile": exit_tile}

## Проходимый «чистый» пол (можно спавнить врагов, сундуки, декор):
## не стена/колонна и не лестница/выход.
static func _open_floor(grid: Array[String], t: Vector2i) -> bool:
    if t.x < 0 or t.y < 0 or t.x >= MAP_W or t.y >= MAP_H:
        return false
    var ch := String(grid[t.y][t.x])
    return not SOLID.contains(ch) and ch != "<" and ch != ">" and ch != "X"

## Прямоугольная комната, вырезанная в камне.
static func _carve_rect(grid: Array[String], rect: Rect2i) -> void:
    for y in range(rect.position.y, rect.end.y):
        for x in range(rect.position.x, rect.end.x):
            _set_cell(grid, Vector2i(x, y), ".")

## Выложить чистые полы прямоугольника заданным символом (мозаика
## сокровищницы); лестницы и прочие особые тайлы не трогаются.
static func _fill_rect(grid: Array[String], rect: Rect2i, symbol: String) -> void:
    for y in range(rect.position.y, rect.end.y):
        for x in range(rect.position.x, rect.end.x):
            var t := Vector2i(x, y)
            if String(grid[t.y][t.x]) == ".":
                _set_cell(grid, t, symbol)

## Комнаты: 10–13 прямоугольников без пересечений (с зазором 1 тайл);
## avoid — уже занятые залы (зал босса и прихожая на 4-м этаже).
static func _carve_rooms(grid: Array[String], avoid: Array[Rect2i] = []) \
        -> Array[Rect2i]:
    var rooms: Array[Rect2i] = []
    var want := randi_range(10, 13)
    var guard := 0
    while rooms.size() < want and guard < 600:
        guard += 1
        var w := randi_range(6, 13)
        var h := randi_range(5, 9)
        var x := randi_range(1, MAP_W - w - 1)
        var y := randi_range(1, MAP_H - h - 1)
        var room := Rect2i(x, y, w, h)
        var overlaps := false
        for other in avoid:
            # Rect2i.grow (не «grows»): расширение на 1 тайл — зазор
            if room.grow(1).intersects(other.grow(1)):
                overlaps = true
                break
        if not overlaps:
            for other in rooms:
                if room.grow(1).intersects(other.grow(1)):
                    overlaps = true
                    break
        if overlaps:
            continue
        rooms.append(room)
        _carve_rect(grid, room)
    if rooms.is_empty():
        var fallback := Rect2i(2, 2, 9, 6)
        rooms.append(fallback)
        _carve_rect(grid, fallback)
    return rooms

## Самая дальняя от точки комната (для сокровищницы).
static func _farthest_room(rooms: Array[Rect2i], from: Vector2i) -> Rect2i:
    var best := rooms[0]
    var best_d := -1.0
    for i in range(1, rooms.size()):
        var d := float(_room_center(rooms[i]).distance_squared_to(from))
        if d > best_d:
            best_d = d
            best = rooms[i]
    return best

## Соединить комнаты последовательными Г-образными коридорами шириной 3
## (шаг 17: в коридоре 3 тайлов — 48 px в свету — герой, круг ~10 px,
## обходит встречного врага и отступает для кайтинга; ширина 2 не давала
## разойтись) плюс пара случайных петель, чтобы карта не была тупиковой
## цепочкой.
static func _connect_rooms(grid: Array[String], rooms: Array[Rect2i]) -> void:
    for i in range(1, rooms.size()):
        var a := _room_center(rooms[i - 1])
        var b := _room_center(rooms[i])
        _carve_l_corridor(grid, a, b)
    if rooms.size() >= 4:
        var extra := randi_range(2, 4)
        for i in range(extra):
            var a := _room_center(rooms[randi() % rooms.size()])
            var b := _room_center(rooms[randi() % rooms.size()])
            if a != b:
                _carve_l_corridor(grid, a, b)

static func _carve_l_corridor(grid: Array[String], a: Vector2i, b: Vector2i) -> void:
    var x := a.x
    var y := a.y
    # горизонтальный ход: три клетки по вертикали (ширина 3)
    while x != b.x:
        _carve_strip_h(grid, x, y)
        if x < b.x:
            _carve_strip_h(grid, x + 1, y)
        x += 1 if x < b.x else -1
    # вертикальный ход: три клетки по горизонтали (ширина 3 — иначе
    # реквизит или колонна замуруют единственный путь, шаг 15)
    while y != b.y:
        _carve_strip_v(grid, x, y)
        if y < b.y:
            _carve_strip_v(grid, x, y + 1)
        y += 1 if y < b.y else -1
    _carve_strip_v(grid, x, y)

## Клетка горизонтального коридора + две под ней (ширина коридора 3).
## Край карты не трогается: _set_cell сам игнорирует границу, а центры
## комнат всегда отстоят от края минимум на 2 клетки.
static func _carve_strip_h(grid: Array[String], x: int, y: int) -> void:
    _set_cell(grid, Vector2i(x, y), ".")
    _set_cell(grid, Vector2i(x, y + 1), ".")
    _set_cell(grid, Vector2i(x, y + 2), ".")

## Клетка вертикального коридора + две справа (ширина коридора 3).
static func _carve_strip_v(grid: Array[String], x: int, y: int) -> void:
    _set_cell(grid, Vector2i(x, y), ".")
    _set_cell(grid, Vector2i(x + 1, y), ".")
    _set_cell(grid, Vector2i(x + 2, y), ".")

## Декор по теме этажа: колонны по углам больших комнат и рядами в широких
## залах; паутина, кости, кровь и светящиеся трещины на случайных полах.
static func _sprinkle_decor(grid: Array[String], rooms: Array[Rect2i],
        theme: Dictionary) -> void:
    for room in rooms:
        if room.size.x >= 7 and room.size.y >= 5:
            for corner in [Vector2i(1, 1), Vector2i(room.size.x - 2, 1),
                    Vector2i(1, room.size.y - 2),
                    Vector2i(room.size.x - 2, room.size.y - 2)]:
                var t: Vector2i = room.position + corner
                if randi() % 3 != 0 and String(grid[t.y][t.x]) == ".":
                    _set_cell(grid, t, "o")
        # широкие залы: колонны рядами (как в храме)
        if room.size.x >= 11 and room.size.y >= 7:
            var col_x := [room.position.x + 3, room.end.x - 4]
            for yy in range(room.position.y + 2, room.end.y - 2, 3):
                for xx in col_x:
                    var t2 := Vector2i(xx, yy)
                    if String(grid[t2.y][t2.x]) == ".":
                        _set_cell(grid, t2, "o")
    # мягкий декор: только на чистых полах, не на лестницах
    var counts := {"w": int(theme.get("webs", 8)),
        "b": int(theme.get("bones", 8)),
        "x": int(theme.get("blood", 8)),
        "g": int(theme.get("glow_n", 10))}
    for symbol in counts:
        var floors: Array[Vector2i] = []
        for y in range(MAP_H):
            for x in range(MAP_W):
                var t3 := Vector2i(x, y)
                if String(grid[t3.y][t3.x]) == ".":
                    floors.append(t3)
        var want: int = counts[symbol]
        var guard := 0
        var placed := 0
        while placed < want and not floors.is_empty() and guard < 500:
            guard += 1
            var idx := randi() % floors.size()
            var t4 := floors[idx]
            floors.remove_at(idx)
            _set_cell(grid, t4, symbol)
            placed += 1

## Гарантированный декор зала босса: жаровни в двух углах, трон за боссом.
## Заполняет hall_props и резервирует клетки (враги/сундуки их обходят).
static func _pick_hall_props(grid: Array[String], hall: Rect2i,
        boss_tile: Vector2i, spawn: Vector2i, up: Vector2i,
        hall_props: Array[Dictionary], reserved: Array[Vector2i]) -> void:
    var spots: Array[Dictionary] = [
        {"tile": Vector2i(hall.position.x + 2, hall.position.y + 2),
            "kind": "brazier"},
        {"tile": Vector2i(hall.end.x - 3, hall.end.y - 3),
            "kind": "brazier"},
    ]
    if boss_tile.x >= 0:
        spots.append({"tile": boss_tile + Vector2i(0, -3), "kind": "throne"})
    for spec in spots:
        var t: Vector2i = spec["tile"]
        if t == spawn or t == up or not _open_floor(grid, t):
            continue
        if reserved.has(t):
            continue
        hall_props.append(spec)
        reserved.append(t)

## Враги этажа: {"tile": Vector2i, "id": String, "elite": bool}.
## Этаж босса: часть миньонов в самом зале (не вплотную к боссу),
## остальные по обычным комнатам; прихожая всегда тихая.
static func _pick_foe_spawns(grid: Array[String], rooms: Array[Rect2i],
        spawn: Vector2i, _down: Vector2i, boss_tile: Vector2i,
        vault: Rect2i, vault_center: Vector2i, floor_num: int,
        is_boss_floor: bool, reserved: Array[Vector2i],
        dungeon_id: String = "dungeon_1") -> Array[Dictionary]:
    var spawns: Array[Dictionary] = []
    var pool: Array = pool_for_floor(floor_num, dungeon_id)
    var free: Array[Vector2i] = []
    for i in range(rooms.size()):
        var room := rooms[i]
        # прихожая зала босса (rooms[1]) — тихая входная зона
        if is_boss_floor and i == 1:
            continue
        # сокровищница — территория хранителя: случайные враги туда
        # не попадают (и не забивают сундуками каждый угол)
        if not is_boss_floor and vault.size.x > 0 and room == vault:
            continue
        for y in range(room.position.y, room.end.y):
            for x in range(room.position.x, room.end.x):
                var t := Vector2i(x, y)
                if not _open_floor(grid, t) or reserved.has(t):
                    continue
                # в зале босса миньоны не подходят к трону вплотную (7 тайлов)
                if is_boss_floor and i == 0 and boss_tile.x >= 0 \
                        and t.distance_squared_to(boss_tile) <= 49:
                    continue
                free.append(t)
    var want := foe_count_for_floor(floor_num, dungeon_id)
    # стартовая зона: на обычных этажах враги дальше 10 тайлов от входа,
    # на этаже босса — дальше 8 (зал большой, но прихожая должна быть тихой)
    var spawn_dist := 64 if is_boss_floor else 100
    var guard := 0
    while spawns.size() < want and not free.is_empty() and guard < 900:
        guard += 1
        var idx := randi() % free.size()
        var t := free[idx]
        free.remove_at(idx)
        if not _far_enough(grid, _tiles_of(spawns), t):
            continue
        if t.distance_squared_to(spawn) <= spawn_dist:
            continue
        spawns.append({"tile": t,
            "id": String(pool[randi() % pool.size()]), "elite": false})
    # элитные чемпионы: на этаже босса 1–2, на остальных 0–1
    var extra := randi_range(0, 1) if not is_boss_floor \
        else randi_range(1, 2)
    for i in range(mini(extra, spawns.size())):
        var pick := spawns[randi() % spawns.size()]
        pick["elite"] = true
    # хранитель сокровищницы: всегда элита, стоит в самой сокровищнице
    if not is_boss_floor and vault_center.x >= 0 and not spawns.is_empty():
        var best := Vector2i(-1, -1)
        var best_d := -1.0
        for y in range(vault.position.y, vault.end.y):
            for x in range(vault.position.x, vault.end.x):
                var t2 := Vector2i(x, y)
                if not _open_floor(grid, t2):
                    continue
                var d := float(t2.distance_squared_to(_room_center(vault)))
                if d > best_d:
                    best_d = d
                    best = t2
        if best.x >= 0:
            # если на этом тайле уже кто-то стоит — сдвинуть его некуда,
            # поэтому дубликат здесь допустим (враги не сталкиваются)
            var keeper := spawns[randi() % spawns.size()]
            keeper["tile"] = best
            keeper["elite"] = true
    return spawns

## Тайлы всех врагов из списка спавнов (для проверок дистанций).
static func _tiles_of(spawns: Array[Dictionary]) -> Array[Vector2i]:
    var out: Array[Vector2i] = []
    for s in spawns:
        out.append(s["tile"])
    return out

## Сундуки этажа (шаг 15): 2 в сокровищнице (этажи 1–3) или в двух углах
## зала босса (этаж 4), остальные 2–3 — по всем комнатам, вдали от спавна,
## лестниц, врагов (вплотную) и уже выбранных сундуков.
static func _pick_chest_tiles(grid: Array[String], rooms: Array[Rect2i],
        spawn: Vector2i, up: Vector2i, down: Vector2i, boss_tile: Vector2i,
        vault: Rect2i, vault_center: Vector2i,
        foe_spawns: Array[Dictionary], is_boss_floor: bool,
        hall: Rect2i, reserved: Array[Vector2i]) -> Array[Vector2i]:
    var chest_tiles: Array[Vector2i] = []
    var taken := _tiles_of(foe_spawns)
    if not is_boss_floor and vault_center.x >= 0:
        var vault_floors: Array[Vector2i] = []
        for y in range(vault.position.y, vault.end.y):
            for x in range(vault.position.x, vault.end.x):
                var t := Vector2i(x, y)
                if _open_floor(grid, t) and _far_enough(grid, taken, t):
                    vault_floors.append(t)
        for i in range(2):
            if vault_floors.is_empty():
                break
            var idx := randi() % vault_floors.size()
            chest_tiles.append(vault_floors[idx])
            taken.append(vault_floors[idx])
            vault_floors.remove_at(idx)
    if is_boss_floor and hall.size.x > 0:
        var corners: Array[Vector2i] = [
            Vector2i(hall.position.x + 2, hall.end.y - 3),
            Vector2i(hall.end.x - 3, hall.position.y + 2)]
        for t2 in corners:
            # угол зала — «охраняемый» сундук: главное — не на клетке врага,
            # реквизита-резерва или уже занятой позиции
            if not _open_floor(grid, t2) or reserved.has(t2):
                continue
            var on_foe := false
            for ft in _tiles_of(foe_spawns):
                if t2 == ft:
                    on_foe = true
                    break
            if on_foe or taken.has(t2):
                continue
            chest_tiles.append(t2)
            taken.append(t2)
    var floors_all: Array[Vector2i] = []
    for y in range(MAP_H):
        for x in range(MAP_W):
            var t3 := Vector2i(x, y)
            if _open_floor(grid, t3):
                floors_all.append(t3)
    var want := randi_range(CHESTS_MIN, CHESTS_MAX)
    # цель всегда «2 гарантированных + want рассыпанных» = 4–5 сундуков
    var guard := 0
    while chest_tiles.size() < want + 2 and not floors_all.is_empty() \
            and guard < 600:
        guard += 1
        var idx2 := randi() % floors_all.size()
        var t4 := floors_all[idx2]
        floors_all.remove_at(idx2)
        if t4 == spawn or t4 == up or t4 == down or t4 == boss_tile:
            continue
        if reserved.has(t4):
            continue
        if t4.distance_squared_to(spawn) <= 36:
            continue
        var on_foe := false
        for ft in _tiles_of(foe_spawns):
            if t4.distance_squared_to(ft) <= 4:
                on_foe = true
                break
        if on_foe or not _far_enough(grid, taken, t4):
            continue
        chest_tiles.append(t4)
        taken.append(t4)
    return chest_tiles

## Факелы: полы вплотную к стенам (свет «лампы на стене»), не на лестницах,
## сундуках, реквизите, врагах и не друг на друге (минимум 5 тайлов между).
static func _pick_torch_tiles(grid: Array[String], spawn: Vector2i,
        up: Vector2i, down: Vector2i, boss_tile: Vector2i,
        chest_tiles: Array[Vector2i], foe_spawns: Array[Dictionary],
        prop_tiles: Array[Dictionary]) -> Array[Vector2i]:
    var torches: Array[Vector2i] = []
    var walls_near: Array[Vector2i] = []
    var side_offsets: Array[Vector2i] = [Vector2i(0, -1), Vector2i(0, 1),
        Vector2i(-1, 0), Vector2i(1, 0)]
    for y in range(1, MAP_H - 1):
        for x in range(1, MAP_W - 1):
            var t := Vector2i(x, y)
            if not _open_floor(grid, t):
                continue
            var near_wall := false
            for off in side_offsets:
                var n: Vector2i = t + off
                if n.x < 0 or n.y < 0 or n.x >= MAP_W or n.y >= MAP_H:
                    continue
                if String(grid[n.y][n.x]) == "#":
                    near_wall = true
                    break
            if near_wall:
                walls_near.append(t)
    var want := randi_range(TORCHES_MIN, TORCHES_MAX)
    var guard := 0
    while torches.size() < want and not walls_near.is_empty() and guard < 800:
        guard += 1
        var idx := randi() % walls_near.size()
        var t2 := walls_near[idx]
        walls_near.remove_at(idx)
        if t2 == spawn or t2 == up or t2 == down or t2 == boss_tile:
            continue
        if t2.distance_squared_to(spawn) <= 25:
            continue
        var busy := false
        for ft in _tiles_of(foe_spawns):
            if t2 == ft:
                busy = true
                break
        for pt in prop_tiles:
            if t2 == (pt["tile"] as Vector2i):
                busy = true
                break
        for ct in chest_tiles:
            if t2 == ct or t2.distance_squared_to(ct) <= 9:
                busy = true
                break
        if busy:
            continue
        var crowded := false
        for ot in torches:
            if t2.distance_squared_to(ot) < 25:
                crowded = true
                break
        if crowded:
            continue
        torches.append(t2)
    return torches

## Реквизит этажа: {"tile": Vector2i, "kind": String}. Жаровни и трон зала
## босса ставятся отдельно (см. _pick_hall_props), здесь — рассыпанный:
## бочки/ящики/мешки в комнатах, кристаллы в сокровищнице.
static func _pick_prop_tiles(grid: Array[String], rooms: Array[Rect2i],
        spawn: Vector2i, up: Vector2i, down: Vector2i, boss_tile: Vector2i,
        chest_tiles: Array[Vector2i], foe_spawns: Array[Dictionary],
        floor_num: int, is_boss_floor: bool,
        hall: Rect2i, vault: Rect2i,
        reserved: Array[Vector2i]) -> Array[Dictionary]:
    var props: Array[Dictionary] = []
    var taken := _tiles_of(foe_spawns)
    taken.append_array(chest_tiles)
    taken.append(spawn)
    taken.append(up)
    if down.x >= 0:
        taken.append(down)
    if boss_tile.x >= 0:
        taken.append(boss_tile)

    # сокровищница: два кристалла по углам (фиолетовые — на 2-м этаже)
    if vault.size.x > 0:
        var crystal := "crystal" if floor_num != 2 else "crystal_violet"
        # Шаг 24: кристалл сокровищницы — ГАРАНТИРОВАННЫЙ интерактив:
        # жёсткое «минимум 3 тайла от всего» иногда оставляло этаж вовсе
        # без кристалла; берём первую свободную ТОЧНУЮ клетку
        var offs: Array[Vector2i] = [Vector2i(2, 1), Vector2i(-2, -2),
            Vector2i(1, -1), Vector2i(-1, 2), Vector2i(0, 1)]
        for off in offs:
            var ct: Vector2i = _room_center(vault) + off
            if not _open_floor(grid, ct) or reserved.has(ct) \
                    or taken.has(ct):
                continue
            props.append({"tile": ct, "kind": crystal})
            taken.append(ct)
            break
    # рассыпанный реквизит по комнатам (кроме стартовой)
    var kinds: Array = ["barrel", "crate", "sacks"]
    if floor_num == 2:
        kinds = ["crystal_violet", "barrel", "crate"]
    elif floor_num == 3:
        kinds = ["sacks", "barrel", "lantern"]
    var want := randi_range(3, 6)
    var base := props.size()   # уже стоящие: кристаллы сокровищницы
    var guard := 0
    while props.size() < base + want and guard < 400:
        guard += 1
        var room := rooms[randi() % rooms.size()]
        if room == rooms[0]:
            continue
        var t2 := Vector2i(randi_range(room.position.x, room.end.x - 1),
            randi_range(room.position.y, room.end.y - 1))
        if reserved.has(t2):
            continue
        if not _open_floor(grid, t2) or not _far_enough(grid, taken, t2):
            continue
        props.append({"tile": t2, "kind": String(kinds[randi() % kinds.size()])})
        taken.append(t2)
    return props

static func _room_center(room: Rect2i) -> Vector2i:
    return room.position + room.size / 2

## Поставить символ, не трогая стены-границы карты.
static func _set_cell(grid: Array[String], t: Vector2i, symbol: String) -> void:
    if t.x <= 0 or t.y <= 0 or t.x >= MAP_W - 1 or t.y >= MAP_H - 1:
        return
    var row := grid[t.y]
    grid[t.y] = row.substr(0, t.x) + symbol + row.substr(t.x + 1)

## Слишком близко к уже занятым тайлам? (чтобы не кучковались)
static func _far_enough(_grid: Array[String], taken: Array[Vector2i],
        t: Vector2i) -> bool:
    for other in taken:
        if t.distance_squared_to(other) < 9:
            return false
    return true
