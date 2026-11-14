## Бестиарий и генератор 1-го подземелья «Dungeon Loot» (шаги 13–14).
## Данж 1 — «Подземелье замка»: 10 этажей, на каждом от 1 до 5 противников
## (этажи генерируются заново при каждом входе — рогалик) и 1–2 сундука
## с добычей (шаг 14). Виды противников по возрастанию сложности: паук,
## змея, космический паук, мертвец бомж, мертвец рыцарь, мертвец колдун,
## демон мечник, демон колдун. На 10-м этаже — обязательный босс:
## Таинственный демон с юга карты.
## Все числа хп/урона/скоростей и награды — ЗАГЛУШКИ (утверждает автор).
class_name DungeonBestiary
extends RefCounted

const SHEET_DIR := "res://assets/sprites/dungeon/"

## Противники 1-го подземелья, по возрастанию сложности (порядок важен:
## от него зависит, каких врагов какой этаж может заспавнить).
## ranged: true — колдун: держит дистанцию и швыряет болт (болт летит
## со скоростью bolt_speed на дистанцию bolt_range, перезарядка bolt_cd).
## gold — награда за убийство (ЗАГЛУШКА), plus — шанс зелья, %.
const FOES: Array[Dictionary] = [
    {"id": "spider", "name": "Паук", "hp": 12, "damage": 4, "speed": 70.0,
        "sheet": SHEET_DIR + "spider.png", "ranged": false,
        "aggro": 110.0, "attack_range": 22.0, "attack_cd": 1.1,
        "gold": 3, "bolt_color": [0.55, 0.85, 0.95]},
    {"id": "snake", "name": "Змея", "hp": 16, "damage": 6, "speed": 85.0,
        "sheet": SHEET_DIR + "snake.png", "ranged": false,
        "aggro": 110.0, "attack_range": 22.0, "attack_cd": 1.0,
        "gold": 4, "bolt_color": [0.5, 0.9, 0.55]},
    {"id": "cosmic_spider", "name": "Космический паук", "hp": 26, "damage": 8,
        "speed": 80.0, "sheet": SHEET_DIR + "cosmic_spider.png", "ranged": false,
        "aggro": 120.0, "attack_range": 24.0, "attack_cd": 1.0,
        "gold": 6, "bolt_color": [0.72, 0.55, 0.95]},
    {"id": "undead_bum", "name": "Мертвец бомж", "hp": 34, "damage": 9,
        "speed": 52.0, "sheet": SHEET_DIR + "undead_bum.png", "ranged": false,
        "aggro": 120.0, "attack_range": 24.0, "attack_cd": 1.2,
        "gold": 8, "bolt_color": [0.6, 0.7, 0.5]},
    {"id": "undead_knight", "name": "Мертвец рыцарь", "hp": 55, "damage": 13,
        "speed": 58.0, "sheet": SHEET_DIR + "undead_knight.png", "ranged": false,
        "aggro": 130.0, "attack_range": 26.0, "attack_cd": 1.2,
        "gold": 12, "bolt_color": [0.75, 0.75, 0.8]},
    {"id": "undead_sorcerer", "name": "Мертвец колдун", "hp": 40, "damage": 11,
        "speed": 44.0, "sheet": SHEET_DIR + "undead_sorcerer.png", "ranged": true,
        "aggro": 150.0, "attack_range": 120.0, "attack_cd": 1.8,
        "gold": 14, "bolt_color": [0.45, 0.8, 0.6], "bolt_speed": 130.0,
        "bolt_range_px": 190.0, "keep_distance": 90.0},
    {"id": "demon_swordsman", "name": "Демон мечник", "hp": 75, "damage": 17,
        "speed": 72.0, "sheet": SHEET_DIR + "demon_swordsman.png", "ranged": false,
        "aggro": 130.0, "attack_range": 26.0, "attack_cd": 1.0,
        "gold": 18, "bolt_color": [0.95, 0.5, 0.3]},
    {"id": "demon_sorcerer", "name": "Демон колдун", "hp": 60, "damage": 15,
        "speed": 62.0, "sheet": SHEET_DIR + "demon_sorcerer.png", "ranged": true,
        "aggro": 150.0, "attack_range": 120.0, "attack_cd": 1.6,
        "gold": 22, "bolt_color": [0.95, 0.45, 0.55], "bolt_speed": 150.0,
        "bolt_range_px": 210.0, "keep_distance": 100.0},
]

## Обязательный босс 1-го подземелья: тот самый Таинственный демон,
## что появлялся на юге карты. Если мы видели его — он узнаёт героя,
## говорит об этом, и начинается битва. Лист 72x96 — он втрое крупнее
## обычных врагов (как у демона с юга мира). Числа — ЗАГЛУШКИ.
const BOSS: Dictionary = {
    "id": "boss_demon", "name": "Таинственный демон", "hp": 300, "damage": 12,
    "speed": 58.0, "sheet": "res://assets/sprites/chars/demon.png",
    "portrait": "res://assets/sprites/portraits/demon.png", "scale": 3,
    "aggro": 260.0, "attack_range": 34.0, "attack_cd": 1.0, "gold": 300,
}

## Награда за врага: золото ЗАГЛУШКА — растёт с глубиной этажа.
static func foe_gold(def: Dictionary, floor_num: int) -> int:
    return int(def.get("gold", 3)) + floor_num * 2

## Определение врага по id (пустой словарь — не найден).
static func foe_def(foe_id: String) -> Dictionary:
    for def in FOES:
        if String(def.get("id", "")) == foe_id:
            return def
    return {}

## Пул врагов этажа: чем глубже, тем страшнее виды. Этаж 1 — пауки и змеи,
## с 7-го — все восемь, на 10-м — только высшие демоны (плюс босс).
static func pool_for_floor(floor_num: int) -> Array[Dictionary]:
    var pool: Array[Dictionary] = []
    if floor_num >= 10:
        for i in range(6, FOES.size()):
            pool.append(FOES[i])
        return pool
    var count := mini(FOES.size(), 1 + floor_num)
    for i in range(count):
        pool.append(FOES[i])
    return pool

## Сколько врагов на этаже: от 1 до 5 (босс 10-го этажа — отдельно).
static func foe_count_for_floor(_floor_num: int) -> int:
    return randi_range(1, 5)

# --------------------------------------------------------- генерация этажа

const MAP_W := 40
const MAP_H := 36
const FLOORS := 10
## Сундуков на этаж (шаг 14): от 1 до 2, стоят на свободных полах.
const CHESTS_MIN := 1
const CHESTS_MAX := 2

## Символы сетки: "#" — стена (твёрдая), "o" — колонна (твёрдая),
## "." / "," / ";" — каменный пол (три оттенка), "b" — пол с костями,
## "<" — лестница наверх, ">" — лестница вниз, "X" — выход в замок.
const SOLID := "#o"

## Сгенерировать этаж floor_num (1..10): комнаты соединены коридорами,
## лестница вверх и вниз, враги, сундуки и (на 10-м) босс. Возвращает:
## {"grid": Array[String], "spawn": Vector2i, "up": Vector2i,
##  "down": Vector2i (Vector2i(-1,-1) на 10-м этаже),
##  "foe_tiles": Array[Vector2i], "chest_tiles": Array[Vector2i] (1–2 сундука),
##  "boss_tile": Vector2i (Vector2i(-1,-1), если босса нет — он уже убит
##  навсегда или этаж не последний),
##  "exit_tile": Vector2i (появляется на 10-м этаже после победы)}
static func generate_floor(floor_num: int, boss_present: bool) -> Dictionary:
    var grid: Array[String] = []
    for y in range(MAP_H):
        grid.append("#".repeat(MAP_W))
    var rooms: Array[Rect2i] = []
    if floor_num >= 10:
        rooms = _carve_boss_hall(grid)
    else:
        rooms = _carve_rooms(grid)
    _connect_rooms(grid, rooms)

    var spawn := Vector2i(-1, -1)
    var down := Vector2i(-1, -1)
    # лестница наверх: в первой комнате; на этаже босса — в прихожей,
    # чтобы герой входил издалека и слышал босса, подходя по залу
    var up: Vector2i
    if floor_num >= 10:
        up = _room_center(rooms[1])
    else:
        up = _room_center(rooms[0])
    _set_cell(grid, up, "<")
    spawn = up
    if floor_num < 10:
        down = _room_center(rooms[rooms.size() - 1])
        _set_cell(grid, down, ">")

    # босс: центр зала (10-й этаж, если он ещё жив)
    var boss_tile := Vector2i(-1, -1)
    if floor_num >= 10 and boss_present:
        boss_tile = Vector2i(MAP_W / 2, rooms[0].position.y + 3)
        _set_cell(grid, boss_tile, ".")

    # декор: кости и колонны в больших залах — ДО врагов, чтобы колонна
    # не появилась на клетке врага (и не замуровала его)
    _sprinkle_decor(grid, rooms)

    # враги: по свободным полам; на обычных этажах — в комнатах кроме
    # стартовой, на этаже босса — в самом зале (не вплотную к боссу).
    # Декор уже стоит: _walkable отсеет колонны.
    var foe_tiles: Array[Vector2i] = []
    var free: Array[Vector2i] = []
    if floor_num >= 10:
        var hall: Rect2i = rooms[0]
        for y in range(hall.position.y, hall.end.y):
            for x in range(hall.position.x, hall.end.x):
                var t := Vector2i(x, y)
                if _walkable(grid, t) and t.distance_squared_to(boss_tile) > 36:
                    free.append(t)
    else:
        for r in range(1, rooms.size()):
            var room: Rect2i = rooms[r]
            for y in range(room.position.y, room.end.y):
                for x in range(room.position.x, room.end.x):
                    var t := Vector2i(x, y)
                    if _walkable(grid, t):
                        free.append(t)
    var want := foe_count_for_floor(floor_num)
    var guard := 0
    while foe_tiles.size() < want and not free.is_empty() and guard < 500:
        guard += 1
        var idx := randi() % free.size()
        var t: Vector2i = free[idx]
        free.remove_at(idx)
        if _far_enough(grid, foe_tiles, t) and t.distance_squared_to(spawn) > 100:
            foe_tiles.append(t)

    # сундуки (шаг 14): 1–2 на этаж, на свободных полах — не на лестницах,
    # не на старте (вплотную к нему), не на клетке врага и не друг на друге
    var chest_tiles := _pick_chest_tiles(grid, spawn, up, down, boss_tile,
        foe_tiles)

    return {"grid": grid, "spawn": spawn, "up": up, "down": down,
        "foe_tiles": foe_tiles, "chest_tiles": chest_tiles,
        "boss_tile": boss_tile, "exit_tile": Vector2i(-1, -1)}

## Выбрать тайлы сундуков: случайные полы вдали от спавна (2 тайла),
## лестниц, врагов (вплотную) и уже выбранных сундуков.
static func _pick_chest_tiles(grid: Array[String], spawn: Vector2i,
        up: Vector2i, down: Vector2i, boss_tile: Vector2i,
        foe_tiles: Array[Vector2i]) -> Array[Vector2i]:
    var chest_tiles: Array[Vector2i] = []
    var floors_all: Array[Vector2i] = []
    for y in range(MAP_H):
        for x in range(MAP_W):
            var t := Vector2i(x, y)
            if _walkable(grid, t):
                floors_all.append(t)
    var want := randi_range(CHESTS_MIN, CHESTS_MAX)
    var guard := 0
    while chest_tiles.size() < want and not floors_all.is_empty() \
            and guard < 400:
        guard += 1
        var idx := randi() % floors_all.size()
        var t: Vector2i = floors_all[idx]
        floors_all.remove_at(idx)
        if t == spawn or t == up or t == down or t == boss_tile:
            continue
        if t.distance_squared_to(spawn) <= 36:
            continue
        var on_foe := false
        for ft in foe_tiles:
            if t.distance_squared_to(ft) <= 4:
                on_foe = true
                break
        if on_foe or not _far_enough(grid, chest_tiles, t):
            continue
        chest_tiles.append(t)
    return chest_tiles

## Проходимый тайл (пол, а не стена и не лестница).
static func _walkable(grid: Array[String], t: Vector2i) -> bool:
    if t.x < 0 or t.y < 0 or t.x >= MAP_W or t.y >= MAP_H:
        return false
    return String(grid[t.y][t.x]) == "." or String(grid[t.y][t.x]) == "," \
        or String(grid[t.y][t.x]) == ";"

## Зал босса: большой прямоугольник + прихожая с лестницей наверх.
static func _carve_boss_hall(grid: Array[String]) -> Array[Rect2i]:
    var hall := Rect2i(9, 5, 22, 13)
    for y in range(hall.position.y, hall.end.y):
        for x in range(hall.position.x, hall.end.x):
            _set_cell(grid, Vector2i(x, y), ".")
    var ante := Rect2i(17, 18, 6, 7)
    for y in range(ante.position.y, ante.end.y):
        for x in range(ante.position.x, ante.end.x):
            _set_cell(grid, Vector2i(x, y), ".")
    # проход из зала в прихожую (двухтайловый)
    for y in range(hall.end.y - 1, ante.position.y):
        _set_cell(grid, Vector2i(19, y), ".")
        _set_cell(grid, Vector2i(20, y), ".")
    return [hall, ante]

## Комнаты: 6-9 прямоугольников без пересечений (с зазором 1 тайл).
static func _carve_rooms(grid: Array[String]) -> Array[Rect2i]:
    var rooms: Array[Rect2i] = []
    var want := randi_range(6, 9)
    var guard := 0
    while rooms.size() < want and guard < 300:
        guard += 1
        var w := randi_range(5, 9)
        var h := randi_range(4, 6)
        var x := randi_range(1, MAP_W - w - 1)
        var y := randi_range(1, MAP_H - h - 1)
        var room := Rect2i(x, y, w, h)
        var overlaps := false
        for other in rooms:
            # Rect2i.grow (не «grows»): расширение на 1 тайл — зазор между комнатами
            if room.grow(1).intersects(other.grow(1)):
                overlaps = true
                break
        if overlaps:
            continue
        rooms.append(room)
        for yy in range(room.position.y, room.end.y):
            for xx in range(room.position.x, room.end.x):
                _set_cell(grid, Vector2i(xx, yy), ".")
    if rooms.is_empty():
        var fallback := Rect2i(2, 2, 8, 6)
        rooms.append(fallback)
        for yy in range(fallback.position.y, fallback.end.y):
            for xx in range(fallback.position.x, fallback.end.x):
                _set_cell(grid, Vector2i(xx, yy), ".")
    return rooms

## Соединить комнаты последовательными Г-образными коридорами шириной 2.
static func _connect_rooms(grid: Array[String], rooms: Array[Rect2i]) -> void:
    for i in range(1, rooms.size()):
        var a := _room_center(rooms[i - 1])
        var b := _room_center(rooms[i])
        _carve_l_corridor(grid, a, b)
    # пара случайных петель, чтобы карта не была тупиковой цепочкой
    if rooms.size() >= 4:
        var extra := randi_range(1, 2)
        for i in range(extra):
            var a := _room_center(rooms[randi() % rooms.size()])
            var b := _room_center(rooms[randi() % rooms.size()])
            if a != b:
                _carve_l_corridor(grid, a, b)

static func _carve_l_corridor(grid: Array[String], a: Vector2i, b: Vector2i) -> void:
    var x := a.x
    var y := a.y
    while x != b.x:
        _carve_corridor_cell(grid, x, y)
        if x < b.x:
            _carve_corridor_cell(grid, x + 1, y)
        x += 1 if x < b.x else -1
    while y != b.y:
        _carve_corridor_cell(grid, x, y)
        if y < b.y:
            _carve_corridor_cell(grid, x, y + 1)
        y += 1 if y < b.y else -1
    _carve_corridor_cell(grid, x, y)

## Клетка коридора и клетка ниже/выше неё (ширина коридора 2 тайла).
static func _carve_corridor_cell(grid: Array[String], x: int, y: int) -> void:
    _set_cell(grid, Vector2i(x, y), ".")
    if y + 1 < MAP_H - 1:
        _set_cell(grid, Vector2i(x, y + 1), ".")

## Кости и мох на случайных полах; колонны по углам больших комнат
## (только на полу — чтобы не перекрыть лестницу или коридор).
static func _sprinkle_decor(grid: Array[String], rooms: Array[Rect2i]) -> void:
    for room in rooms:
        if room.size.x >= 7 and room.size.y >= 5:
            for corner in [Vector2i(1, 1), Vector2i(room.size.x - 2, 1),
                    Vector2i(1, room.size.y - 2),
                    Vector2i(room.size.x - 2, room.size.y - 2)]:
                var t: Vector2i = room.position + corner
                if randi() % 3 != 0 and _walkable(grid, t):
                    _set_cell(grid, t, "o")
    var floors: Array[Vector2i] = []
    for y in range(MAP_H):
        for x in range(MAP_W):
            if String(grid[y][x]) == ".":
                floors.append(Vector2i(x, y))
    for i in range(mini(14, floors.size())):
        var t: Vector2i = floors[randi() % floors.size()]
        _set_cell(grid, t, "b" if randi() % 2 == 0 else ";")

static func _room_center(room: Rect2i) -> Vector2i:
    return room.position + room.size / 2

## Поставить символ, не трогая стены-границы карты.
static func _set_cell(grid: Array[String], t: Vector2i, symbol: String) -> void:
    if t.x <= 0 or t.y <= 0 or t.x >= MAP_W - 1 or t.y >= MAP_H - 1:
        return
    var row := grid[t.y]
    grid[t.y] = row.substr(0, t.x) + symbol + row.substr(t.x + 1)

## Слишком близко к уже выбранным тайлам врагов? (чтобы не кучковались)
static func _far_enough(_grid: Array[String], taken: Array[Vector2i],
        t: Vector2i) -> bool:
    for other in taken:
        if t.distance_squared_to(other) < 9:
            return false
    return true
