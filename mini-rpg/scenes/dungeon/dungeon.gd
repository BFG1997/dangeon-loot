## Подземелье замка — 1-й данж «Dungeon Loot» (шаг 13).
## 10 этажей, на каждом от 1 до 5 противников; этажи генерируются заново
## (комнаты, коридоры, лестницы — DungeonBestiary.generate_floor).
## Локация — подземелье замка: каменные стены, кости, колонны, факелы.
## Виды противников по возрастанию сложности: паук, змея, космический паук,
## мертвец бомж, мертвец рыцарь, мертвец колдун, демон мечник, демон колдун.
## Колдуны держат дистанцию и швыряют болты; остальные бьются вплотную.
## Лестница вниз открывается тишине: пока на этаже жив хоть один враг,
## путь закрыт. На 10-м этаже — обязательный босс: Таинственный демон
## с юга карты. Если мы видели его (диалог у края мира), он узнаёт героя
## и говорит об этом; битва начинается после реплик. Убив его, герой
## завершает данж: Game.defeat_demon_permanently — убитые NPC оживают
## и забывают убийства, демон больше не возвращается (сейв v6).
## Бой: удар (ЛКМ/УДАР) и магия (Q/МАГИЯ) — общий код с world.gd;
## у врагов хп, полоска, всплывающий урон; награда — золото (и иногда зелье).
## Шаг 14 — сундуки: 1–2 на этаж, открываются кликом или E; внутри золото,
## зелья, питьё, оружие, броня или одеяния (таблицы — Loot.chest_loot).
## Победа над боссом даёт ЭПИЧЕСКОЕ случайное оружие золотого качества
## (Loot.epic_weapon_loot) — сильные клинки и магические посохи.
extends Node2D

const WORLD_SCENE := "res://scenes/world/world.tscn"
const MAIN_SCENE := "res://scenes/main/main.tscn"
const SPEED := 95.0
const COLOR_GOLD := Color(1, 0.84, 0)
const CHAR_W := 24
const CHAR_H := 32

## Шаг 10/11: экран ходьба + консоль UI — та же геометрия, что у мира.
const UI_BAR_H := 112.0
const WALK_H := 640.0 - UI_BAR_H
const BAR_JOY_POS := Vector2(2, 6)
const BAR_HERO_POS := Vector2(110, 6)
const BAR_BUTTONS_X := 292.0
const BAR_BTN_SIZE := Vector2(64, 22)
const BAR_BTN_STEP := 25.0

## Символы сетки -> атлас assets/tilesets/dungeon_tiles.png.
const TILE_ATLAS := {
    "#": Vector2i(0, 0),
    "o": Vector2i(1, 0),
    ".": Vector2i(0, 1),
    ",": Vector2i(1, 1),
    ";": Vector2i(2, 1),
    "b": Vector2i(3, 1),
    "<": Vector2i(0, 2),
    ">": Vector2i(1, 2),
    "X": Vector2i(2, 2),
}

## Параметры удара героя (шаг 7): те же, что в мире.
const STRIKE_RANGE := 28.0
const STRIKE_COOLDOWN := 0.4

## Тексты подземелья (шаг 13): тон — лавкрафтовский космо-хоррор.
const FLOOR_FIRST_HINT := "Подземелье замка. Десять этажей вниз, и на каждом что-то шевелится. На самом дне ждёт тот, кто уже знает твоё имя."
const FLOOR_HINT := "Уровень %d из 10. Врагов в темноте: %d."
const FLOOR_BOSS_HINT := "Уровень 10 из 10. Воздух дрожит от шёпота. Хозяин подземелья ждёт тебя."
const FLOOR_NO_BOSS_HINT := "Уровень 10 из 10. Здесь пахнет пеплом: хозяин подземелья уже повержен. Лестница в замок открыта."
const STAIRS_LOCKED_HINT := "Лестница вниз молчит, пока в зале кто-то дышит. Наступит тишина — и путь откроется."
const STAIRS_DOWN_HINT := "Лестница ведёт глубже. Камни помнят шаги тех, кто не вернулся."
const AGGRO_HINT := "%s заметил тебя. В темноте это плохо."
const FOE_LOOT_GOLD_HINT := "%s рассыпался: +%d золота."
const FOE_LOOT_ITEM_HINT := "%s уронил: %s."
const BOSS_DEFEATED_HINT := "Демон повержен! Убитые тобой жители вернулись в замок и ничего не помнят. Демон больше не вернётся — ни сюда, ни к краю мира."
const EXIT_HINT := "Лестница в замок открыта. Ты можешь уйти с добычей — она твоя."
const STAIRS_UP_NAME := "Лестница наверх"
const STAIRS_DOWN_NAME := "Лестница вниз"
const EXIT_NAME := "Выход в замок"

## Сундуки (шаг 14): спрайты 16×16 (chest_closed/chest_open), открытие —
## клик по сундуку или E рядом. Таблицы добычи — Loot.chest_loot.
const CHEST_CLOSED_TEX := "res://assets/sprites/chest_closed.png"
const CHEST_OPEN_TEX := "res://assets/sprites/chest_open.png"
const CHEST_GOLD_HINT := "В сундуке звенело золото: +%d."
const CHEST_ITEM_HINT := "В сундуке нашлось: %s."
const CHEST_EMPTY_HINT := "Сундук пуст: только пыль и чужие мечты."
## Эпическая награда босса (шаг 14) — отдельно от реплики о победе:
## сначала идёт длинный текст о поверженном демоне, потом — о добыче.
const BOSS_EPIC_HINT := "Среди пепла демона осталось оружие — %s. Эпическая добыча, она твоя."

## Диалог босса (шаг 13): если мы видели его у края мира — он узнаёт героя.
## Битва начинается, когда диалог закроется (обязательный босс).
const BOSS_NAME := "Таинственный демон"
const BOSS_ROLE_SEEN := "узнавший тебя"
const BOSS_ROLE_NEW := "хозяин подземелья"
const BOSS_LINES_SEEN := [
    "Ты помнишь меня. Я помню тебя: ты шёл к краю мира и говорил со мной, как с лавочником. Как со «смертным».",
    "Каждое убийство кормило меня. Каждая монета в моей лавке прошла через твои руки. Ты думал, я торгую? Я собирал.",
    "Десять этажей ты спускался к своей могиле. Я — сама могила. Начнём.",
]
const BOSS_LINES_NEW := [
    "А вот и ты. Я ждал тебя у края мира, но ты пришёл сюда: из всех дверей замка выбрал мою.",
    "Я — эхо того, что спит под замком. Мой голос слышали все, кто умирал на этих этажах. Теперь он слышит тебя.",
    "Неважно, видел ты меня раньше или нет: ты видишь меня сейчас. Этого достаточно.",
]

## Тексты экрана смерти (шаг 12) — те же, что в мире.
const DEATH_TITLE := "ТЫ ПАЛ"
const DEATH_TEXT := "Космос равнодушно смотрел, как твоя тень растворилась между звёзд. Но замок ещё держит тебя в этом сне — и возвращать не собирается."
const DEATH_BUTTON := "ОЧНУТЬСЯ В ЗАМКЕ"
const RESPAWN_HINT := "Ты очнулся в замке. Подземелье обрушилось за твоей спиной и соберётся заново, когда ты вернёшься."

# ---------------------------------------------------------------- состояние

var _world: Node2D = null
var _level_root: Node2D = null       # содержимое этажа (пересоздаётся)
var _fx: Node2D = null               # частицы/цифры урона поверх этажа
var _ground: TileMapLayer = null
var _entities: Node2D = null
var player: CharacterBody2D = null
var _player_sprite: AnimatedSprite2D = null
var _camera: Camera2D = null
var _joystick: Control = null
var _walk_holder: SubViewportContainer = null
var _walk_view: SubViewport = null
var _hud_bar: Control = null
var _hud_gold: Label
var _hud_hp: ProgressBar
var _hud_mana: ProgressBar
var _hud_floor: Label                # «Подземелье · ур. N/10 · врагов: K»
var _hud_hint: Label
var _dialogue: DialogueUI
var _inventory_ui: InventoryUI
var _hint_tween: Tween

var _grid: Array[String] = []        # сетка текущего этажа
var _floor_num := 1                  # текущий этаж (1..10)
var _foes: Array[Dictionary] = []    # противники этажа (включая босса)
var _stairs_up: Dictionary = {}      # {"pos": Vector2, "area": Area2D}
var _stairs_down: Dictionary = {}
var _stairs_exit: Dictionary = {}
var _chests: Array[Dictionary] = []  # сундуки этажа (шаг 14): тайл, спрайт, открыт
var _boss_hostile := false           # босс дерётся после диалога
var _boss_dialog_done := false
var _boss_defeated_here := false     # босс убит на этом этаже (для тестов)

var _bolts: Array[Dictionary] = []       # стрелы героя
var _foe_bolts: Array[Dictionary] = []   # болты колдунов
var _spell_cd := 0.0
var _mana_regen_accum := 0.0
var _strike_cd := 0.0
var _facing := "down"
var _hero_sheet_tex: Texture2D
var _shadow_tex: Texture2D
var _bolt_tex: Texture2D
var _dialogue_closed_at := -10000
var _player_dead := false
var _death_layer: CanvasLayer = null
var _player_flash_tween: Tween

## Лямбды HUD хранятся отдельно: сигналы Game (автозагрузка) переживают
## смену сцены, поэтому в _exit_tree их нужно отвязать — иначе после
## ухода из подземелья мёртвая лямбда падает на первом же изменении золота.
var _cb_gold: Callable
var _cb_equipped: Callable
var _cb_hp: Callable
var _cb_mana: Callable

func _ready() -> void:
    _shadow_tex = load("res://assets/sprites/props/shadow.png")
    _bolt_tex = load("res://assets/sprites/icons/magic_bolt.png")
    _hero_sheet_tex = load(String(Game.HEROES.get(Game.hero_id,
        Game.HEROES[Game.DEFAULT_HERO])["sheet"]))
    get_viewport().size_changed.connect(_resize_layout)
    _build_walk_screen()
    _build_hud()
    _build_joystick()
    _build_death_ui()
    Game.hp_changed.connect(_on_player_hp_changed)
    _dialogue = DialogueUI.new()
    add_child(_dialogue)
    _dialogue.bottom_reserve = UI_BAR_H + 8.0
    _dialogue.closed.connect(_on_dialogue_closed)
    _inventory_ui = InventoryUI.new()
    add_child(_inventory_ui)
    _floor_num = clampi(Game.dungeon_floor if Game.dungeon_floor >= 1 else 1,
        1, DungeonBestiary.FLOORS)
    Game.dungeon_floor = _floor_num
    _load_floor(_floor_num)
    for modal in [_dialogue, _inventory_ui]:
        modal.visibility_changed.connect(_on_modal_visibility_changed)
    Platform.gameplay_start()

func _exit_tree() -> void:
    if Controls.bindings_changed.is_connected(_refresh_controls_hint):
        Controls.bindings_changed.disconnect(_refresh_controls_hint)
    Platform.gameplay_stop()
    if Game.hp_changed.is_connected(_on_player_hp_changed):
        Game.hp_changed.disconnect(_on_player_hp_changed)
    _disconnect_cb(Game.gold_changed, _cb_gold)
    _disconnect_cb(Game.equipped_changed, _cb_equipped)
    _disconnect_cb(Game.hp_changed, _cb_hp)
    _disconnect_cb(Game.mana_changed, _cb_mana)

## Отвязать лямбду HUD от сигнала Game (если была привязана).
func _disconnect_cb(sig: Signal, cb: Callable) -> void:
    if not cb.is_null() and sig.is_connected(cb):
        sig.disconnect(cb)

# ----------------------------------------------------------- экран ходьбы

func _build_walk_screen() -> void:
    var holder := SubViewportContainer.new()
    holder.name = "WalkScreen"
    holder.stretch = true
    holder.position = Vector2.ZERO
    holder.size = get_viewport_rect().size - Vector2(0, UI_BAR_H)
    holder.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
    var walk_view := SubViewport.new()
    walk_view.name = "WalkViewport"
    walk_view.disable_3d = true
    walk_view.canvas_item_default_texture_filter = \
        Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
    walk_view.snap_2d_transforms_to_pixel = true
    walk_view.physics_object_picking = true
    holder.add_child(walk_view)
    add_child(holder)
    _walk_holder = holder
    _walk_view = walk_view
    holder.gui_input.connect(_on_walk_click)
    _world = Node2D.new()
    _world.name = "WorldContent"
    walk_view.add_child(_world)
    _fx = Node2D.new()
    _fx.name = "Fx"
    _fx.z_index = 10
    _world.add_child(_fx)

# ---------------------------------------------------------------- этаж

## Собрать этаж: тёмный фон, тайлы из сетки, сущности, враги, лестницы,
## герой и камера. Вызывается на старте и при переходе между этажами.
func _load_floor(floor_num: int) -> void:
    _floor_num = clampi(floor_num, 1, DungeonBestiary.FLOORS)
    Game.dungeon_floor = _floor_num
    _clear_level()
    var is_boss_floor: bool = _floor_num >= DungeonBestiary.FLOORS
    var boss_present: bool = is_boss_floor and not Game.demon_gone_forever()
    var level := DungeonBestiary.generate_floor(_floor_num, boss_present)
    _grid = level["grid"]

    _level_root = Node2D.new()
    _level_root.name = "Level"
    _world.add_child(_level_root)

    # фон: глухая тьма подземелья (звёзд здесь нет)
    var bg := ColorRect.new()
    # Decorative backdrop must not consume input before Area2D picking.
    bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
    bg.color = Color(0.015, 0.012, 0.022)
    bg.size = Vector2(DungeonBestiary.MAP_W * 16.0 + 400.0,
        DungeonBestiary.MAP_H * 16.0 + 400.0)
    bg.position = Vector2(-200, -200)
    _level_root.add_child(bg)

    _build_tiles()
    _build_entities()

    # лестницы
    _stairs_up = {}
    _stairs_down = {}
    _stairs_exit = {}
    var up: Vector2i = level["up"]
    _register_stairs(_stairs_up, STAIRS_UP_NAME, up, "_use_stairs_up")
    var down: Vector2i = level["down"]
    if down.x >= 0:
        _register_stairs(_stairs_down, STAIRS_DOWN_NAME, down, "_use_stairs_down")

    # враги (на 10-м — только высшие демоны) и босс
    _foes.clear()
    var pool := DungeonBestiary.pool_for_floor(_floor_num)
    for t in level["foe_tiles"]:
        var def: Dictionary = pool[randi() % pool.size()]
        _spawn_foe(def, t)

    # сундуки (шаг 14): спавн ДО выхода, чтобы выход не встал на сундук
    _chests.clear()
    for t in level["chest_tiles"]:
        _spawn_chest(t)

    var boss_tile: Vector2i = level["boss_tile"]
    if boss_tile.x >= 0:
        _spawn_boss(boss_tile)
    elif is_boss_floor:
        # босс уже повержен навсегда: на последнем этаже сразу есть выход
        _place_exit(Vector2i(DungeonBestiary.MAP_W / 2, 10))

    _build_player(level["spawn"])
    _update_progress_label()
    _show_floor_intro(boss_present)

## Убрать содержимое предыдущего этажа (снаряды, враги, тайлы).
func _clear_level() -> void:
    for b in _bolts:
        if is_instance_valid(b["node"]):
            (b["node"] as Node2D).queue_free()
    for b in _foe_bolts:
        if is_instance_valid(b["node"]):
            (b["node"] as Node2D).queue_free()
    _bolts.clear()
    _foe_bolts.clear()
    _foes.clear()
    _boss_hostile = false
    _boss_dialog_done = false
    _boss_defeated_here = false
    _chests.clear()
    _stairs_up = {}
    _stairs_down = {}
    _stairs_exit = {}
    if _level_root != null and is_instance_valid(_level_root):
        _level_root.queue_free()
    _level_root = null
    _ground = null
    _entities = null
    player = null

func _build_tiles() -> void:
    var atlas_tex: Texture2D = load("res://assets/tilesets/dungeon_tiles.png")
    var tileset := TileSet.new()
    tileset.tile_size = Vector2i(16, 16)
    tileset.add_physics_layer()
    tileset.set_physics_layer_collision_layer(0, 1)
    var source := TileSetAtlasSource.new()
    source.texture = atlas_tex
    source.texture_region_size = Vector2i(16, 16)
    var source_id := tileset.add_source(source)
    _tile_source_id = source_id
    var half := 8.0
    var square := PackedVector2Array([
        Vector2(-half, -half), Vector2(half, -half),
        Vector2(half, half), Vector2(-half, half),
    ])
    for symbol in TILE_ATLAS:
        var coords: Vector2i = TILE_ATLAS[symbol]
        source.create_tile(coords)
        if DungeonBestiary.SOLID.contains(symbol):
            var data := source.get_tile_data(coords, 0)
            data.add_collision_polygon(0)
            data.set_collision_polygon_points(0, 0, square)
    _ground = TileMapLayer.new()
    _ground.name = "Ground"
    _ground.tile_set = tileset
    _level_root.add_child(_ground)
    for y in DungeonBestiary.MAP_H:
        for x in DungeonBestiary.MAP_W:
            var symbol: String = _grid[y][x]
            _ground.set_cell(Vector2i(x, y), source_id, TILE_ATLAS[symbol])

var _tile_source_id := 0

func _build_entities() -> void:
    _entities = Node2D.new()
    _entities.name = "Entities"
    _entities.y_sort_enabled = true
    _level_root.add_child(_entities)

func _feet_pos(tile: Vector2) -> Vector2:
    return Vector2(tile.x * 16.0 + 8.0, tile.y * 16.0 + 16.0 - 3.0)

func _add_shadow(parent: Node2D, width_scale: float = 1.0) -> void:
    var sh := Sprite2D.new()
    sh.texture = _shadow_tex
    sh.position = Vector2(0, 2)
    sh.scale = Vector2(width_scale, 1.0)
    parent.add_child(sh)

func _make_frames(tex: Texture2D, fw: int = CHAR_W, fh: int = CHAR_H) -> SpriteFrames:
    var frames := SpriteFrames.new()
    frames.remove_animation("default")
    var rows := [
        ["idle_down", 0, 6, 3.0], ["idle_side", 1, 6, 3.0], ["idle_up", 2, 6, 3.0],
        ["walk_down", 3, 4, 7.0], ["walk_side", 4, 4, 7.0], ["walk_up", 5, 4, 7.0],
    ]
    for r in rows:
        var anim: String = r[0]
        frames.add_animation(anim)
        frames.set_animation_speed(anim, r[3])
        frames.set_animation_loop(anim, true)
        for i in range(int(r[2])):
            var at := AtlasTexture.new()
            at.atlas = tex
            at.region = Rect2(i * fw, int(r[1]) * fh, fw, fh)
            frames.add_frame(anim, at)
    return frames

# ---------------------------------------------------------------- враги

## Противник этажа: спрайт 24x32 (тот же формат листов, что у героев),
## маленькое тело (блокирует героя). Враги не говорят — зоны клика нет.
func _spawn_foe(def: Dictionary, tile: Vector2i) -> Dictionary:
    var pos := _feet_pos(Vector2(tile))
    var node := Node2D.new()
    node.name = "Foe_%s" % String(def["id"])
    node.position = pos
    _add_shadow(node, 0.9)
    var spr := AnimatedSprite2D.new()
    spr.sprite_frames = _make_frames(load(String(def["sheet"])))
    spr.position = Vector2(0, -CHAR_H / 2.0 + 3.0)
    spr.play("idle_down")
    node.add_child(spr)
    var body := StaticBody2D.new()
    body.collision_layer = 1
    body.collision_mask = 0
    var body_shape := CollisionShape2D.new()
    var circle := CircleShape2D.new()
    circle.radius = 5.0
    body_shape.shape = circle
    body_shape.position = Vector2(0, -2)
    body.add_child(body_shape)
    node.add_child(body)
    var hp := maxi(1, int(def["hp"]))
    var hp_bar := _make_hp_bar(hp, 1.0)
    node.add_child(hp_bar)
    _entities.add_child(node)
    var foe := {"id": String(def["id"]), "def": def, "node": node,
        "sprite": spr, "hp": hp, "max_hp": hp, "hp_bar": hp_bar,
        "body": body, "aggro": false, "atk_cd": 0.0,
        "bolt_cd": 0.0, "boss": false, "dead": false,
        "flash_tween": null}
    _foes.append(foe)
    return foe

## Босс 10-го этажа: Таинственный демон — тот же лист 72x96, что у демона
## с юга карты (втрое крупнее врагов). Дерётся только после диалога.
func _spawn_boss(tile: Vector2i) -> void:
    var def: Dictionary = DungeonBestiary.BOSS
    var s := maxi(1, int(def.get("scale", 3)))
    var node := Node2D.new()
    node.name = "Boss"
    node.position = _feet_pos(Vector2(tile))
    _add_shadow(node, 0.9 * s)
    var spr := AnimatedSprite2D.new()
    spr.sprite_frames = _make_frames(load(String(def["sheet"])),
        CHAR_W * s, CHAR_H * s)
    spr.position = Vector2(0, -(CHAR_H * s) / 2.0 + 3.0)
    spr.play("idle_down")
    node.add_child(spr)
    var body := StaticBody2D.new()
    body.collision_layer = 1
    body.collision_mask = 0
    var body_shape := CollisionShape2D.new()
    var circle := CircleShape2D.new()
    circle.radius = 5.0 * s
    body_shape.shape = circle
    body_shape.position = Vector2(0, -2)
    body.add_child(body_shape)
    node.add_child(body)
    var hp := maxi(1, int(def["hp"]))
    var hp_bar := _make_hp_bar(hp, float(s))
    node.add_child(hp_bar)
    _entities.add_child(node)
    var boss := {"id": String(def["id"]), "def": def, "node": node,
        "sprite": spr, "hp": hp, "max_hp": hp, "hp_bar": hp_bar,
        "body": body, "aggro": false, "atk_cd": 0.0, "bolt_cd": 0.0,
        "boss": true, "dead": false, "flash_tween": null}
    _foes.append(boss)

func _make_hp_bar(hp: int, s: float) -> ProgressBar:
    var hp_bar := ProgressBar.new()
    hp_bar.min_value = 0
    hp_bar.max_value = hp
    hp_bar.value = hp
    hp_bar.show_percentage = false
    hp_bar.custom_minimum_size = Vector2(24.0 * s, 4)
    hp_bar.size = Vector2(24.0 * s, 4)
    hp_bar.position = Vector2(-12.0 * s, -float(CHAR_H * int(s)) - 4)
    hp_bar.visible = false
    hp_bar.add_theme_stylebox_override("background",
        _bar_style(Color(0.09, 0.08, 0.1), Color(0.4, 0.18, 0.18)))
    hp_bar.add_theme_stylebox_override("fill",
        _bar_style(Color(0.72, 0.26, 0.26), Color(0.72, 0.26, 0.26)))
    return hp_bar

# ---------------------------------------------------------------- лестницы

## Лестница: тайл на полу + зона клика (Area2D). По E — ближайшая в радиусе.
func _register_stairs(store: Dictionary, title: String, tile: Vector2i,
        method: String) -> void:
    var center := Vector2(tile.x * 16.0 + 8.0, tile.y * 16.0 + 8.0)
    var area := Area2D.new()
    area.input_pickable = true
    area.collision_layer = 4
    area.collision_mask = 0
    var shape := CollisionShape2D.new()
    var rect := RectangleShape2D.new()
    rect.size = Vector2(18, 18)
    shape.shape = rect
    area.add_child(shape)
    area.input_event.connect(_on_stairs_input.bind(method))
    var marker := Node2D.new()
    marker.name = title
    marker.position = center
    marker.add_child(area)
    _level_root.add_child(marker)
    store["pos"] = center
    store["area"] = area

func _on_stairs_input(_viewport: Node, event: InputEvent, _shape_idx: int,
        method: String) -> void:
    if _gameplay_input_blocked():
        return
    if event is InputEventMouseButton and event.pressed \
            and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
        _click_dialog_at = Time.get_ticks_msec()
        _use_stairs(method)

func _use_stairs(method: String) -> void:
    if _player_dead or player == null:
        return
    match method:
        "_use_stairs_up":
            if _floor_num <= 1:
                _leave_dungeon()
            else:
                _goto_floor(_floor_num - 1)
        "_use_stairs_down":
            if not _stairs_open():
                _show_hint(STAIRS_LOCKED_HINT, 3.5)
                return
            _show_hint(STAIRS_DOWN_HINT, 2.5)
            _goto_floor(_floor_num + 1)
        "_use_stairs_exit":
            _leave_dungeon()

## Переход на этаж: этажи генерируются заново — рогалик.
func _goto_floor(floor_num: int) -> void:
    _load_floor(floor_num)
    if _camera != null:
        _camera.reset_smoothing()

## Лестница вниз открыта, только когда на этаже не осталось живых врагов
## (босс не в счёт: он сторожит только свой выход).
func _stairs_open() -> bool:
    for foe in _foes:
        if bool(foe.get("dead", false)) or bool(foe.get("boss", false)):
            continue
        return false
    return true

## Покинуть подземелье: вернуться в замок (прогресс этажей обнуляется).
func _leave_dungeon() -> void:
    Game.dungeon_floor = 0
    Platform.gameplay_stop()
    get_tree().change_scene_to_file(WORLD_SCENE)

## Выход в замок на 10-м этаже, когда босс давно повержен.
## Тайл сдвигается, если на нём стоит сундук (шаг 14).
func _place_exit(tile: Vector2i) -> void:
    tile = _free_exit_tile(tile)
    _set_grid_cell(tile, "X")
    if _ground != null:
        _ground.set_cell(tile, _tile_source_id, TILE_ATLAS["X"])
    _register_stairs(_stairs_exit, EXIT_NAME, tile, "_use_stairs_exit")

## Тайл выхода, свободный от сундуков: если на тайле стоит сундук,
## выход появляется на ближайшем свободном полу рядом (по спирали).
func _free_exit_tile(tile: Vector2i) -> Vector2i:
    var offsets := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(-1, 0),
        Vector2i(0, 1), Vector2i(0, -1), Vector2i(2, 0), Vector2i(-2, 0),
        Vector2i(0, 2), Vector2i(0, -2)]
    for off in offsets:
        var t: Vector2i = tile + off
        if t.x <= 0 or t.y <= 0 or t.x >= DungeonBestiary.MAP_W - 1 \
                or t.y >= DungeonBestiary.MAP_H - 1:
            continue
        if DungeonBestiary.SOLID.contains(_grid[t.y][t.x]):
            continue
        var chest_here := false
        for chest in _chests:
            if (chest["tile"] as Vector2i) == t:
                chest_here = true
                break
        if not chest_here:
            return t
    return tile

# ---------------------------------------------------------------- сундуки (шаг 14)

## Сундук этажа: спрайт 16×16, маленькое тело (блокирует героя),
## зона клика (Area2D). Открывается кликом или E в радиусе 26 px.
func _spawn_chest(tile: Vector2i) -> void:
    var center := Vector2(tile.x * 16.0 + 8.0, tile.y * 16.0 + 8.0)
    var node := Node2D.new()
    node.name = "Chest_%d_%d" % [tile.x, tile.y]
    node.position = center
    var spr := Sprite2D.new()
    spr.texture = load(CHEST_CLOSED_TEX)
    node.add_child(spr)
    var body := StaticBody2D.new()
    body.collision_layer = 1
    body.collision_mask = 0
    var body_shape := CollisionShape2D.new()
    var circle := CircleShape2D.new()
    circle.radius = 6.0
    body_shape.shape = circle
    body.add_child(body_shape)
    node.add_child(body)
    var area := Area2D.new()
    area.input_pickable = true
    area.collision_layer = 4
    area.collision_mask = 0
    var area_shape := CollisionShape2D.new()
    var rect := RectangleShape2D.new()
    rect.size = Vector2(20, 20)
    area_shape.shape = rect
    area.add_child(area_shape)
    node.add_child(area)
    _entities.add_child(node)
    var chest := {"tile": tile, "pos": center, "node": node,
        "sprite": spr, "opened": false}
    area.input_event.connect(_on_chest_input.bind(chest))
    _chests.append(chest)

func _on_chest_input(_viewport: Node, event: InputEvent, _shape_idx: int,
        chest: Dictionary) -> void:
    if _gameplay_input_blocked():
        return
    if event is InputEventMouseButton and event.pressed \
            and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
        _click_dialog_at = Time.get_ticks_msec()   # этот клик — не удар
        _open_chest(chest)

## Открыть сундук (шаг 14): содержимое и качество — Loot.chest_loot;
## сундук всегда не пуст (золото или предмет). Открытый — пуст.
func _open_chest(chest: Dictionary) -> void:
    if _player_dead:
        return
    if bool(chest.get("opened", false)):
        _show_hint(CHEST_EMPTY_HINT, 2.0)
        return
    chest["opened"] = true
    (chest["sprite"] as Sprite2D).texture = load(CHEST_OPEN_TEX)
    var pos: Vector2 = chest["pos"]
    _spell_poof(pos + Vector2(0, -6), COLOR_GOLD)
    var loot := Loot.chest_loot(_floor_num)
    if loot.has("item_id"):
        var item_id := String(loot["item_id"])
        Game.add_item({"item_id": item_id, "title": ItemDB.title(item_id),
            "quality": String(loot.get("quality", "gray"))})
        _show_hint(String(CHEST_ITEM_HINT) % ItemDB.title(item_id), 3.5)
        return
    var amount := maxi(1, int(loot.get("gold", 10)))
    Game.add_gold(amount)
    _show_hint(String(CHEST_GOLD_HINT) % amount, 3.0)

# ---------------------------------------------------------------- игрок

func _build_player(spawn_tile: Vector2i) -> void:
    player = CharacterBody2D.new()
    player.name = "Player"
    player.motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
    player.collision_layer = 2
    player.collision_mask = 1
    player.position = Vector2(spawn_tile) * 16.0 + Vector2(8, 8)
    _entities.add_child(player)
    var shape := CollisionShape2D.new()
    var circle := CircleShape2D.new()
    circle.radius = 5.0
    shape.shape = circle
    shape.position = Vector2(0, 3)
    player.add_child(shape)
    _add_shadow(player, 0.9)
    _player_sprite = AnimatedSprite2D.new()
    _player_sprite.sprite_frames = _make_frames(_hero_sheet_tex)
    _player_sprite.position = Vector2(0, -CHAR_H / 2.0 + 3.0)
    _player_sprite.play("idle_down")
    player.add_child(_player_sprite)
    _camera = Camera2D.new()
    _camera.limit_left = 0
    _camera.limit_top = 0
    _camera.limit_right = DungeonBestiary.MAP_W * 16
    _camera.limit_bottom = DungeonBestiary.MAP_H * 16
    _camera.position_smoothing_enabled = true
    _camera.position_smoothing_speed = 6.0
    player.add_child(_camera)
    _camera.make_current()
    _facing = "down"

func _physics_process(delta: float) -> void:
    if player == null:
        return
    var moving := false
    var dir := Vector2.ZERO
    var blocked := _dialogue.visible or _inventory_ui.visible or _player_dead
    if not blocked:
        if _blocked_movement_inputs.is_empty():
            dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
        var joy_vec := _joystick_output()
        if joy_vec.length() > 0.15:
            dir = (dir + joy_vec).limit_length(1.0)
        moving = dir.length() > 0.05
        player.velocity = dir * SPEED
        player.move_and_slide()
    else:
        player.velocity = Vector2.ZERO
    if _spell_cd > 0.0:
        _spell_cd = maxf(0.0, _spell_cd - delta)
    if Game.is_mage() and Game.mana < Game.max_mana():
        _mana_regen_accum += delta
        if _mana_regen_accum >= 1.0:
            Game.regen_mana(int(Game.SPELL["regen_per_sec"]) * int(_mana_regen_accum))
            _mana_regen_accum = 0.0
    else:
        _mana_regen_accum = 0.0
    if _strike_cd > 0.0:
        _strike_cd = maxf(0.0, _strike_cd - delta)
    _update_bolts(delta)
    _update_foe_bolts(delta)
    _update_walk_anim(delta, moving, dir)
    _update_foes(delta)
    _update_boss_trigger()

func _joystick_output() -> Vector2:
    if _joystick == null or not "output" in _joystick:
        return Vector2.ZERO
    var value: Variant = _joystick.get("output")
    return value if value is Vector2 else Vector2.ZERO

func _update_walk_anim(_delta: float, moving: bool, dir: Vector2 = Vector2.ZERO) -> void:
    var anim := "idle_down"
    if moving:
        if absf(dir.x) >= absf(dir.y) and absf(dir.x) > 0.01:
            anim = "walk_side"
            _player_sprite.flip_h = dir.x < 0.0
            _facing = "side"
        elif dir.y < 0.0:
            anim = "walk_up"
            _facing = "up"
        else:
            anim = "walk_down"
            _facing = "down"
    else:
        match _facing:
            "side":
                anim = "idle_side"
            "up":
                anim = "idle_up"
            _:
                anim = "idle_down"
    if _player_sprite.animation != anim:
        _player_sprite.play(anim)

# ------------------------------------------------- удар по клику (как в мире)

var _click_dialog_at := -10000

## The container supplies local SubViewport coordinates. Do not accept the
## event here: Area2D picking must still receive pointer interactions.
func _on_walk_click(event: InputEvent) -> void:
    if not event is InputEventMouseButton or not event.pressed:
        return
    if _gameplay_input_blocked():
        return
    var position := (event as InputEventMouseButton).position
    var world_pos := _walk_pos_to_world(position)
    if not world_pos.is_finite():
        return
    # Picking may run later than gui_input. Test geometry before any command,
    # including magic/inventory/interact, so LMB objects always have priority.
    if event.button_index == MOUSE_BUTTON_LEFT and _point_on_interactive(world_pos):
        return
    _handle_gameplay_input(event, position)

func _try_click_strike(view_pos: Vector2) -> void:
    if _dialogue.visible or _inventory_ui.visible or _player_dead:
        return
    if player == null:
        return
    if Time.get_ticks_msec() - _click_dialog_at <= 100:
        return
    var world_pos := _walk_pos_to_world(view_pos)
    if not world_pos.is_finite() or _point_on_interactive(world_pos):
        return
    _strike()

func _walk_pos_to_world(view_pos: Vector2) -> Vector2:
    if _walk_view == null:
        return Vector2.INF
    return _walk_view.get_canvas_transform().affine_inverse() * view_pos

## Под точкой клика — лестница или сундук? (враги не «интерактивны», по ним бьют)
func _point_on_interactive(pos: Vector2) -> bool:
    for store in [_stairs_up, _stairs_down, _stairs_exit]:
        if (store as Dictionary).is_empty():
            continue
        var spos: Vector2 = (store as Dictionary)["pos"]
        if absf(pos.x - spos.x) <= 10.0 and absf(pos.y - spos.y) <= 10.0:
            return true
    for chest in _chests:
        var cpos: Vector2 = chest["pos"]
        if absf(pos.x - cpos.x) <= 10.0 and absf(pos.y - cpos.y) <= 10.0:
            return true
    return false

# InputMap remains the movement source. Track press/release origins so input
# held across modal visibility changes stays blocked until a fresh press.
var _blocked_movement_inputs: Dictionary = {}
var _held_movement_inputs: Dictionary = {}

func _input(event: InputEvent) -> void:
    var identity: String
    if event is InputEventMouseButton:
        identity = "mouse:%d" % event.button_index
    elif event is InputEventKey:
        identity = "key:%d" % (event.physical_keycode if event.physical_keycode else event.keycode)
    else:
        return
    if not event.is_pressed():
        _blocked_movement_inputs.erase(identity)
        _held_movement_inputs.erase(identity)
        return
    if event.is_echo():
        return
    for action in ["move_left", "move_right", "move_up", "move_down"]:
        if not event.is_action_pressed(action):
            continue
        _held_movement_inputs[identity] = true
        _blocked_movement_inputs.erase(identity)
        if _gameplay_input_blocked():
            _blocked_movement_inputs[identity] = true
        elif event is InputEventMouseButton:
            var local := _walk_local_position(event.position)
            var hovered := get_viewport().gui_get_hovered_control()
            var over_ui := hovered != null and hovered != _walk_holder \
                and not _walk_holder.is_ancestor_of(hovered)
            if not local.is_finite() or over_ui:
                _blocked_movement_inputs[identity] = true
            elif event.button_index == MOUSE_BUTTON_LEFT \
                    and _point_on_interactive(_walk_pos_to_world(local)):
                _blocked_movement_inputs[identity] = true
        return

func _on_modal_visibility_changed() -> void:
    if _gameplay_input_blocked():
        _blocked_movement_inputs.merge(_held_movement_inputs, true)

func _notification(what: int) -> void:
    if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
        _blocked_movement_inputs.clear()
        _held_movement_inputs.clear()

func _walk_local_position(root_position: Vector2) -> Vector2:
    if _walk_holder == null:
        return Vector2.INF
    var local := _walk_holder.get_global_transform_with_canvas().affine_inverse() * root_position
    return local if Rect2(Vector2.ZERO, _walk_holder.size).has_point(local) else Vector2.INF

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        # Mouse commands inside WalkScreen have exactly one entry: gui_input.
        if _walk_local_position((event as InputEventMouseButton).position).is_finite():
            return
    _handle_gameplay_input(event)

func _gameplay_input_blocked() -> bool:
    return _player_dead or _dialogue.visible or _inventory_ui.visible

func _handle_gameplay_input(event: InputEvent, walk_position: Vector2 = Vector2.INF) -> void:
    if _player_dead:
        return
    if event.is_action_pressed("toggle_inventory"):
        if _inventory_ui.visible:
            _inventory_ui.close()
        elif not _dialogue.visible:
            _inventory_ui.open()
        return
    if event.is_action_pressed("attack") and not _dialogue.visible \
            and not _inventory_ui.visible:
        if walk_position.is_finite():
            _try_click_strike(walk_position)
        else:
            _strike()
        return
    if event.is_action_pressed("cast_spell") and not _dialogue.visible \
            and not _inventory_ui.visible:
        _cast_spell()
        return
    if event.is_action_pressed("interact") and not _dialogue.visible \
            and not _inventory_ui.visible \
            and player != null \
            and Time.get_ticks_msec() - _dialogue_closed_at > 250:
        _use_nearest_stairs()

## Ближайшая интерактивность в радиусе 26 px (E): лестницы и закрытые сундуки.
func _use_nearest_stairs() -> void:
    if player == null or _player_dead:
        return
    var best := 26.0
    var method := ""
    for pair in [[_stairs_up, "_use_stairs_up"],
            [_stairs_down, "_use_stairs_down"],
            [_stairs_exit, "_use_stairs_exit"]]:
        var store: Dictionary = pair[0]
        if store.is_empty():
            continue
        var d: float = player.position.distance_to(store["pos"])
        if d < best:
            best = d
            method = String(pair[1])
    var chest: Dictionary = {}
    for c in _chests:
        if bool(c.get("opened", false)):
            continue
        var d: float = player.position.distance_to(c["pos"])
        if d < best:
            best = d
            method = "_open_chest"
            chest = c
    if method.is_empty():
        return
    if method == "_open_chest":
        _open_chest(chest)
    else:
        _use_stairs(method)

# ------------------------------------------------------- магия (шаги 6/12)

func _cast_spell() -> void:
    if not Game.is_mage():
        _show_hint(Game.non_mage_spell_hint(), 2.0)
        return
    if _spell_cd > 0.0:
        return
    var info := Game.spell_info()
    if not Game.cast_spell():
        _show_hint("Не хватает маны: нужно %d" % int(info["cost"]), 2.0)
        return
    _spell_cd = float(info["cooldown"])
    var dir := _facing_vector()
    var count := maxi(1, int(info.get("count", 1)))
    var spread := deg_to_rad(float(info.get("spread_deg", 0.0)))
    if count == 1:
        _spawn_bolt(dir, info)
    else:
        for i in range(count):
            var offset := (float(i) - float(count - 1) / 2.0) * spread
            _spawn_bolt(dir.rotated(offset), info)

func _facing_vector() -> Vector2:
    match _facing:
        "up":
            return Vector2(0, -1)
        "side":
            return Vector2(-1, 0) if _player_sprite.flip_h else Vector2(1, 0)
        _:
            return Vector2(0, 1)

func _spawn_bolt(dir: Vector2, info: Dictionary = {}) -> void:
    if dir == Vector2.ZERO or _bolt_tex == null:
        return
    if info.is_empty():
        info = Game.spell_info()
        if info.is_empty():
            return
    var bolt := Sprite2D.new()
    bolt.texture = _bolt_tex
    var col: Array = info.get("color", [0.55, 0.85, 0.95])
    bolt.modulate = Color(float(col[0]), float(col[1]), float(col[2]))
    var size := float(info.get("size", 1.0))
    bolt.scale = Vector2(size, size)
    bolt.position = player.position + Vector2(0, -14)
    _fx.add_child(bolt)
    _bolts.append({"node": bolt, "dir": dir.normalized(),
        "left": float(info["range_px"]), "speed": float(info["speed"]),
        "damage": int(info["damage"]), "color": bolt.modulate})

func _update_bolts(delta: float) -> void:
    if _bolts.is_empty():
        return
    for i in range(_bolts.size() - 1, -1, -1):
        var b: Dictionary = _bolts[i]
        var node: Sprite2D = b["node"]
        var step: Vector2 = (b["dir"] as Vector2) * float(b["speed"]) * delta
        node.position += step
        b["left"] = float(b["left"]) - step.length()
        var target := _foe_at_point(node.position)
        if not target.is_empty():
            _spell_poof(node.position, b.get("color", Color(0.55, 0.85, 0.95)))
            node.queue_free()
            _bolts.remove_at(i)
            _hit_foe(target, int(b["damage"]))
            continue
        var faded := float(b["left"]) <= 0.0
        if faded or _tile_is_solid(node.position):
            _spell_poof(node.position, b.get("color", Color(0.55, 0.85, 0.95)))
            node.queue_free()
            _bolts.remove_at(i)

## Живой враг в точке (прямоугольник тела с учётом масштаба босса).
func _foe_at_point(pos: Vector2) -> Dictionary:
    for foe in _foes:
        if bool(foe.get("dead", false)):
            continue
        var node: Node2D = foe["node"]
        var s := maxi(1, int((foe["def"] as Dictionary).get("scale", 1)))
        if pos.x < node.position.x - 10.0 * s or pos.x > node.position.x + 10.0 * s:
            continue
        if pos.y < node.position.y - float(CHAR_H * s) - 6.0 \
                or pos.y > node.position.y + 4.0:
            continue
        return foe
    return {}

# ---------------------------------------------------------------- ИИ врагов

## Ходы противников: спят, пока герой не подойдёт (радиус aggro), потом
## преследуют. Колдуны (ranged) держат дистанцию и швыряют болты,
## остальные бьются вплотную. Босс ждёт диалога — и только потом дерётся.
func _update_foes(delta: float) -> void:
    if player == null:
        return
    for foe in _foes:
        if bool(foe.get("dead", false)):
            continue
        var def: Dictionary = foe["def"]
        var node: Node2D = foe["node"]
        var spr: AnimatedSprite2D = foe["sprite"]
        foe["atk_cd"] = maxf(0.0, float(foe["atk_cd"]) - delta)
        foe["bolt_cd"] = maxf(0.0, float(foe["bolt_cd"]) - delta)
        # босс мирен, пока не прозвучали его реплики
        if bool(foe.get("boss", false)) and not _boss_hostile:
            var to_boss: Vector2 = player.position - node.position
            if absf(to_boss.x) >= absf(to_boss.y):
                spr.play("idle_side")
                spr.flip_h = to_boss.x < 0.0
            else:
                spr.play("idle_down" if to_boss.y > 0.0 else "idle_up")
            continue
        var to := player.position - node.position
        var dist := to.length()
        if not bool(foe["aggro"]):
            if dist < float(def["aggro"]) and Game.hp > 0 and not _player_dead:
                foe["aggro"] = true
                _show_hint(String(AGGRO_HINT) % String(def["name"]), 2.2)
            else:
                spr.play("idle_down")
                continue
        if Game.hp <= 0 or _player_dead:
            spr.play("idle_down")
            continue
        if bool(def.get("ranged", false)):
            # колдун: держит дистанцию, швыряет болты
            var keep := float(def.get("keep_distance", 90.0))
            var moved := false
            if dist > keep + 24.0:
                _move_foe(node, to.normalized(), float(def["speed"]), delta)
                moved = true
            elif dist < keep - 24.0:
                _move_foe(node, -to.normalized(), float(def["speed"]) * 0.7, delta)
                moved = true
            if moved:
                _foe_anim(spr, to)
            elif absf(to.x) >= absf(to.y):
                spr.play("idle_side")
                spr.flip_h = to.x < 0.0
            else:
                spr.play("idle_down" if to.y > 0.0 else "idle_up")
            if dist <= float(def["attack_range"]) and float(foe["bolt_cd"]) <= 0.0:
                foe["bolt_cd"] = float(def.get("attack_cd", 1.8))
                _spawn_foe_bolt(node, def)
        else:
            # ближний бой: догнать и бить
            if dist > float(def["attack_range"]) * 0.8:
                _move_foe(node, to.normalized(), float(def["speed"]), delta)
                _foe_anim(spr, to)
            else:
                spr.play("idle_down")
            if dist <= float(def["attack_range"]) and float(foe["atk_cd"]) <= 0.0:
                foe["atk_cd"] = float(def.get("attack_cd", 1.1))
                _foe_attack(def)

func _foe_anim(spr: AnimatedSprite2D, to: Vector2) -> void:
    if absf(to.x) >= absf(to.y):
        spr.play("walk_side")
        spr.flip_h = to.x < 0.0
    else:
        spr.play("walk_down" if to.y > 0.0 else "walk_up")

## Движение врага по осям с проверкой стен (как ИИ демона в мире).
func _move_foe(node: Node2D, dirv: Vector2, speed: float, delta: float) -> void:
    if dirv == Vector2.ZERO:
        return
    var step := speed * delta
    var nx := node.position + Vector2(dirv.x, 0.0) * step
    if not _tile_is_solid(nx + Vector2(0, -8)):
        node.position.x = nx.x
    var ny := node.position + Vector2(0.0, dirv.y) * step
    if not _tile_is_solid(ny + Vector2(0, -8)):
        node.position.y = ny.y

## Атака вплотную: урон герою, взмах, вспышка (как когти демона в мире).
func _foe_attack(def: Dictionary) -> void:
    var damage := maxi(1, int(def["damage"]))
    Game.damage_hp(damage)
    _spawn_swing(player.position + Vector2(0, -10), Color(0.9, 0.3, 0.25))
    _spawn_damage_label(player.position + Vector2(0, -40), damage)
    _spell_poof(player.position + Vector2(0, -14), Color(0.85, 0.3, 0.25))
    _flash_player()

## Болт колдуна: летит в героя, гаснет у стен.
func _spawn_foe_bolt(from: Node2D, def: Dictionary) -> void:
    var col: Array = def.get("bolt_color", [0.6, 0.8, 0.7])
    var bolt := Sprite2D.new()
    bolt.texture = _bolt_tex
    bolt.modulate = Color(float(col[0]), float(col[1]), float(col[2]))
    bolt.scale = Vector2(0.9, 0.9)
    bolt.position = from.position + Vector2(0, -14)
    _fx.add_child(bolt)
    var dir := (player.position + Vector2(0, -14) - bolt.position).normalized()
    if dir == Vector2.ZERO:
        dir = Vector2(0, 1)   # совпадение точек: болт падает вниз, а не висит
    _foe_bolts.append({"node": bolt, "dir": dir,
        "left": float(def.get("bolt_range_px", 190.0)),
        "speed": float(def.get("bolt_speed", 130.0)),
        "damage": maxi(1, int(def["damage"])),
        "color": bolt.modulate})

func _update_foe_bolts(delta: float) -> void:
    if _foe_bolts.is_empty() or player == null:
        return
    for i in range(_foe_bolts.size() - 1, -1, -1):
        var b: Dictionary = _foe_bolts[i]
        var node: Sprite2D = b["node"]
        var step: Vector2 = (b["dir"] as Vector2) * float(b["speed"]) * delta
        node.position += step
        b["left"] = float(b["left"]) - step.length()
        var hit := absf(node.position.x - player.position.x) <= 9.0 \
            and node.position.y >= player.position.y - 28.0 \
            and node.position.y <= player.position.y + 4.0
        if hit and Game.hp > 0 and not _player_dead:
            _spell_poof(node.position, b.get("color", Color(0.7, 0.8, 0.7)))
            node.queue_free()
            _foe_bolts.remove_at(i)
            Game.damage_hp(int(b["damage"]))
            _spawn_damage_label(player.position + Vector2(0, -40), int(b["damage"]))
            _flash_player()
            continue
        var faded := float(b["left"]) <= 0.0
        if faded or _tile_is_solid(node.position):
            _spell_poof(node.position, b.get("color", Color(0.7, 0.8, 0.7)))
            node.queue_free()
            _foe_bolts.remove_at(i)

# --------------------------------------------------------------- босс (шаг 13)

## Обязательная встреча: герой подошёл близко — демон говорит. Если мы
## видели его у края мира, он узнаёт героя; после диалога начинается бой.
func _update_boss_trigger() -> void:
    if player == null or _player_dead:
        return
    var boss := _boss_record()
    if boss.is_empty() or _boss_hostile or _boss_dialog_done:
        return
    var dist: float = player.position.distance_to((boss["node"] as Node2D).position)
    if dist < 90.0 and not _dialogue.visible:
        _open_boss_dialog()

func _boss_record() -> Dictionary:
    for foe in _foes:
        if bool(foe.get("boss", false)) and not bool(foe.get("dead", false)):
            return foe
    return {}

func _open_boss_dialog() -> void:
    _boss_dialog_done = true
    var seen: bool = Game.demon_seen
    _dialogue.open({
        "name": BOSS_NAME,
        "role": BOSS_ROLE_SEEN if seen else BOSS_ROLE_NEW,
        "portrait": DungeonBestiary.BOSS["portrait"],
        "lines": BOSS_LINES_SEEN if seen else BOSS_LINES_NEW,
    })

func _on_dialogue_closed() -> void:
    _dialogue_closed_at = Time.get_ticks_msec()
    # босс закончил говорить — начинается битва
    var boss := _boss_record()
    if not boss.is_empty() and _boss_dialog_done and not _boss_hostile:
        _boss_hostile = true
        _show_hint("Демон бросается в бой! Ни лавки, ни милосердия — только когти и тьма.", 3.5)

## Босс повержен: данж пройден, демон мёртв навсегда, жертвы оживают,
## из пепла — ЭПИЧЕСКОЕ случайное оружие (шаг 14), на месте босса
## открывается лестница в замок.
func _on_boss_defeated(boss: Dictionary) -> void:
    _boss_defeated_here = true
    Game.defeat_demon_permanently()
    Game.mark_dungeon_cleared("dungeon_1")
    var node: Node2D = boss["node"]
    var epic := Loot.epic_weapon_loot()
    var epic_id := String(epic["item_id"])
    Game.add_item({"item_id": epic_id, "title": ItemDB.title(epic_id),
        "quality": String(epic["quality"])})
    _spell_poof(node.position + Vector2(0, -30), Color(1.0, 0.84, 0.2))
    var tx := clampi(int(floor(node.position.x / 16.0)), 1, DungeonBestiary.MAP_W - 2)
    var ty := clampi(int(floor(node.position.y / 16.0)), 1, DungeonBestiary.MAP_H - 2)
    _place_exit(Vector2i(tx, ty))
    _show_hint(BOSS_DEFEATED_HINT, 6.0)
    # реплика про эпическую добычу — после текста о победе (одна подсказка)
    var epic_hint := String(BOSS_EPIC_HINT) % ItemDB.title(epic_id)
    # IntervalTweener не умеет tween_callback: цепочка строится на самом Tween
    var epic_tween := create_tween()
    epic_tween.tween_interval(6.3)
    epic_tween.tween_callback(func() -> void: _show_hint(epic_hint, 7.0))

func _set_grid_cell(t: Vector2i, symbol: String) -> void:
    if t.x < 0 or t.y < 0 or t.x >= DungeonBestiary.MAP_W \
            or t.y >= DungeonBestiary.MAP_H:
        return
    var row := _grid[t.y]
    _grid[t.y] = row.substr(0, t.x) + symbol + row.substr(t.x + 1)

# ------------------------------------------------------ удары (шаги 7/13)

func _strike() -> void:
    if player == null or _strike_cd > 0.0 or _player_dead:
        return
    _strike_cd = STRIKE_COOLDOWN
    var dir := _facing_vector()
    var target := _living_foe_in_front(dir)
    var weapon_color := Game.strike_swing_color()
    if target.is_empty():
        _spawn_swing(player.position + dir * 14.0 + Vector2(0, -12), weapon_color)
        return
    var foe_node: Node2D = target["node"]
    _spawn_swing((player.position + foe_node.position) * 0.5 + Vector2(0, -12),
        weapon_color)
    _hit_foe(target, Game.strike_damage())
    if Game.strike_is_magic_surge():
        _spell_poof(foe_node.position + Vector2(0, -16), weapon_color)

func _living_foe_in_front(dir: Vector2) -> Dictionary:
    var best: Dictionary = {}
    var best_d := STRIKE_RANGE
    for foe in _foes:
        if bool(foe.get("dead", false)):
            continue
        var node: Node2D = foe["node"]
        var to := node.position - player.position
        var dist := to.length()
        if dist > best_d:
            continue
        if dist > 1.0 and dir.dot(to.normalized()) < 0.2:
            continue
        best_d = dist
        best = foe
    return best

## Урон врагу: число, вспышка, полоска хп; при нуле — смерть и награда.
## Если это босс — данж завершается (см. _on_boss_defeated).
func _hit_foe(foe: Dictionary, damage: int) -> void:
    var foe_node: Node2D = foe["node"]
    var s := maxi(1, int((foe["def"] as Dictionary).get("scale", 1)))
    foe["hp"] = maxi(0, int(foe["hp"]) - damage)
    _spawn_damage_label(foe_node.position + Vector2(0, -float(CHAR_H * s) - 2),
        damage)
    _flash_foe(foe)
    _show_foe_hp_bar(foe)
    if int(foe["hp"]) <= 0:
        _kill_foe(foe)
    elif bool(foe.get("boss", false)) and not _boss_hostile \
            and not _boss_dialog_done:
        # ударили демона раньше, чем он заговорил: он замечает героя
        _open_boss_dialog()

func _kill_foe(foe: Dictionary) -> void:
    foe["dead"] = true
    var def: Dictionary = foe["def"]
    var foe_name := String(def.get("name", "Враг"))
    var spr: AnimatedSprite2D = foe["sprite"]
    var flash: Tween = foe.get("flash_tween")
    if flash != null and flash.is_valid():
        flash.kill()
    spr.stop()
    spr.rotation = PI / 2.0
    spr.modulate = Color(0.5, 0.47, 0.55)
    (foe["hp_bar"] as ProgressBar).visible = false
    var body: StaticBody2D = foe["body"]
    (body.get_child(0) as CollisionShape2D).set_deferred("disabled", true)
    _spell_poof((foe["node"] as Node2D).position + Vector2(0, -12),
        Color(0.6, 0.6, 0.66))
    # награда: золото растёт с глубиной; иногда враг роняет зелье (ЗАГЛУШКА)
    var reward := DungeonBestiary.foe_gold(def, _floor_num)
    Game.add_gold(reward)
    _show_hint(String(FOE_LOOT_GOLD_HINT) % [foe_name, reward], 2.0)
    if randi() % 100 < 15:
        var potion := "hp_potion_small" if _floor_num < 4 else "hp_potion"
        Game.add_item({"item_id": potion, "title": ItemDB.title(potion),
            "quality": "gray"})
        _show_hint(String(FOE_LOOT_ITEM_HINT) % [foe_name, ItemDB.title(potion)],
            2.5)
    if bool(foe.get("boss", false)):
        _on_boss_defeated(foe)
    else:
        _update_progress_label()

func _show_foe_hp_bar(foe: Dictionary) -> void:
    var bar: ProgressBar = foe["hp_bar"]
    bar.max_value = int(foe["max_hp"])
    bar.value = int(foe["hp"])
    bar.visible = true

func _flash_foe(foe: Dictionary) -> void:
    var spr: AnimatedSprite2D = foe["sprite"]
    var old: Tween = foe.get("flash_tween")
    if old != null and old.is_valid():
        old.kill()
    spr.modulate = Color(1.0, 0.35, 0.35)
    var tw := create_tween()
    tw.tween_property(spr, "modulate", Color.WHITE, 0.25)
    foe["flash_tween"] = tw

func _flash_player() -> void:
    if _player_flash_tween != null and _player_flash_tween.is_valid():
        _player_flash_tween.kill()
    _player_sprite.modulate = Color(1.0, 0.35, 0.35)
    _player_flash_tween = create_tween()
    _player_flash_tween.tween_property(_player_sprite, "modulate",
        Color.WHITE, 0.25)

# ------------------------------------------------------------ тайлы/эффекты

func _tile_is_solid(pos: Vector2) -> bool:
    var tx := int(floor(pos.x / 16.0))
    var ty := int(floor(pos.y / 16.0))
    if tx < 0 or ty < 0 or tx >= DungeonBestiary.MAP_W \
            or ty >= DungeonBestiary.MAP_H:
        return true
    return DungeonBestiary.SOLID.contains(_grid[ty][tx])

func _spell_poof(pos: Vector2, color: Color = Color(0.55, 0.85, 0.95)) -> void:
    var poof := CPUParticles2D.new()
    poof.position = pos
    poof.amount = 10
    poof.lifetime = 0.3
    poof.one_shot = true
    poof.explosiveness = 1.0
    poof.direction = Vector2(0, -1)
    poof.spread = 180.0
    poof.initial_velocity_min = 20.0
    poof.initial_velocity_max = 50.0
    poof.scale_amount_min = 1.5
    poof.scale_amount_max = 3.0
    poof.color = color
    poof.emitting = true
    _fx.add_child(poof)
    get_tree().create_timer(0.6).timeout.connect(func() -> void:
        if is_instance_valid(poof):
            poof.queue_free())

func _spawn_swing(pos: Vector2, color: Color) -> void:
    var swing := CPUParticles2D.new()
    swing.position = pos
    swing.amount = 9
    swing.lifetime = 0.22
    swing.one_shot = true
    swing.explosiveness = 1.0
    swing.direction = Vector2(0, -1)
    swing.spread = 110.0
    swing.initial_velocity_min = 40.0
    swing.initial_velocity_max = 90.0
    swing.scale_amount_min = 1.2
    swing.scale_amount_max = 2.6
    swing.color = color
    swing.emitting = true
    _fx.add_child(swing)
    get_tree().create_timer(0.5).timeout.connect(func() -> void:
        if is_instance_valid(swing):
            swing.queue_free())

func _spawn_damage_label(pos: Vector2, damage: int) -> void:
    var label := Label.new()
    label.text = "-%d" % damage
    label.position = pos + Vector2(-14, 0)
    label.size = Vector2(28, 14)
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.add_theme_font_size_override("font_size", 11)
    label.add_theme_color_override("font_color", Color(1.0, 0.42, 0.36))
    label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
    label.add_theme_constant_override("shadow_offset_y", 1)
    _fx.add_child(label)
    var tw := create_tween()
    tw.set_parallel(true)
    tw.tween_property(label, "position:y", label.position.y - 16.0, 0.6) \
        .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    tw.tween_property(label, "modulate:a", 0.0, 0.6).set_delay(0.15)
    tw.chain().tween_callback(label.queue_free)

# ------------------------------------------------- смерть героя (шаги 12/13)

func _build_death_ui() -> void:
    _death_layer = CanvasLayer.new()
    _death_layer.name = "DeathOverlay"
    _death_layer.layer = 30
    _death_layer.visible = false
    add_child(_death_layer)
    var dim := ColorRect.new()
    dim.name = "Dim"
    dim.set_anchors_preset(Control.PRESET_FULL_RECT)
    dim.color = Color(0.02, 0.02, 0.06, 0.82)
    _death_layer.add_child(dim)
    var center := CenterContainer.new()
    center.set_anchors_preset(Control.PRESET_FULL_RECT)
    center.mouse_filter = Control.MOUSE_FILTER_IGNORE
    dim.add_child(center)
    var panel := PanelContainer.new()
    panel.custom_minimum_size = Vector2(300, 0)
    panel.add_theme_stylebox_override("panel", UiStyle.panel_style())
    center.add_child(panel)
    var vbox := VBoxContainer.new()
    vbox.add_theme_constant_override("separation", 10)
    panel.add_child(vbox)
    var title := Label.new()
    title.text = DEATH_TITLE
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 22)
    title.add_theme_color_override("font_color", Color(0.85, 0.3, 0.3))
    vbox.add_child(title)
    var body := Label.new()
    body.text = DEATH_TEXT
    body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    body.add_theme_font_size_override("font_size", 11)
    body.add_theme_color_override("font_color", Color(0.72, 0.75, 0.84))
    vbox.add_child(body)
    var btn := Button.new()
    btn.text = DEATH_BUTTON
    btn.custom_minimum_size = Vector2(0, 38)
    UiStyle.style_button(btn, 13)
    btn.pressed.connect(_respawn_player)
    vbox.add_child(btn)

func _on_player_hp_changed(hp: int, _max_hp: int) -> void:
    if hp <= 0 and not _player_dead:
        _player_dead = true
        if _death_layer != null:
            _death_layer.visible = true

## Смерть в подземелье: пробуждение в замке (этажи соберутся заново).
func _respawn_player() -> void:
    _player_dead = false
    if _death_layer != null:
        _death_layer.visible = false
    Game.reset_demon_rage()
    Game.heal_hp(Game.max_hp() * 2)
    if Game.is_mage():
        Game.restore_mana(Game.max_mana() * 2)
    Game.dungeon_floor = 0
    Platform.gameplay_stop()
    get_tree().change_scene_to_file(WORLD_SCENE)

# ---------------------------------------------------------------- джойстик

func _build_joystick() -> void:
    var script: GDScript = load("res://scripts/ui/virtual_joystick.gd") as GDScript
    if script == null or not script.can_instantiate():
        push_warning("VirtualJoystick недоступен: только клавиатура")
        return
    var joystick: Control = script.new() as Control
    if joystick == null:
        return
    if _hud_bar == null:
        return
    joystick.size = Vector2(100, 100)
    joystick.position = BAR_JOY_POS
    _hud_bar.add_child(joystick)
    _joystick = joystick

# ---------------------------------------------------------------- HUD

func _build_hud() -> void:
    var layer := CanvasLayer.new()
    layer.name = "HUD"
    layer.layer = 20
    add_child(layer)
    _hud_bar = Control.new()
    _hud_bar.name = "HudBar"
    _hud_bar.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
    _hud_bar.offset_top = -UI_BAR_H
    layer.add_child(_hud_bar)
    var bar_bg := Panel.new()
    bar_bg.name = "BarBackground"
    bar_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
    var bar_style := StyleBoxFlat.new()
    bar_style.bg_color = Color(0.07, 0.08, 0.13)
    bar_style.border_color = Color(0.5, 0.42, 0.16)
    bar_style.set_border_width_all(0)
    bar_style.border_width_top = 2
    bar_bg.add_theme_stylebox_override("panel", bar_style)
    _hud_bar.add_child(bar_bg)
    var bar_top := 0.0
    var hero_panel := PanelContainer.new()
    hero_panel.position = Vector2(BAR_HERO_POS.x, bar_top + BAR_HERO_POS.y)
    var hero_style := UiStyle.flat_style(Color(0.11, 0.12, 0.19), Color(0.5, 0.42, 0.16))
    hero_style.content_margin_left = 6
    hero_style.content_margin_right = 10
    hero_style.content_margin_top = 4
    hero_style.content_margin_bottom = 4
    hero_panel.add_theme_stylebox_override("panel", hero_style)
    _hud_bar.add_child(hero_panel)
    var hero_row := HBoxContainer.new()
    hero_row.add_theme_constant_override("separation", 7)
    hero_panel.add_child(hero_row)
    var hero_face := TextureRect.new()
    hero_face.custom_minimum_size = Vector2(28, 28)
    hero_face.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    hero_face.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    hero_face.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
    hero_face.texture = load(String(Game.HEROES.get(Game.hero_id, {}).get("portrait", "")))
    hero_row.add_child(hero_face)
    var hero_box := VBoxContainer.new()
    hero_box.add_theme_constant_override("separation", 0)
    hero_row.add_child(hero_box)
    var hero_name := Label.new()
    hero_name.text = Game.hero_title()
    hero_name.add_theme_font_size_override("font_size", 10)
    hero_name.add_theme_color_override("font_color", Color(0.85, 0.88, 0.94))
    hero_box.add_child(hero_name)
    _hud_gold = Label.new()
    _hud_gold.add_theme_font_size_override("font_size", 12)
    _hud_gold.add_theme_color_override("font_color", COLOR_GOLD)
    _hud_gold.text = "Золото: %d" % Game.gold
    hero_box.add_child(_hud_gold)
    _cb_gold = func(new_gold: int) -> void:
        if is_instance_valid(_hud_gold):
            _hud_gold.text = "Золото: %d" % new_gold
    Game.gold_changed.connect(_cb_gold)
    var hud_weapon := Label.new()
    hud_weapon.add_theme_font_size_override("font_size", 9)
    hud_weapon.add_theme_color_override("font_color", Color(0.62, 0.66, 0.74))
    hud_weapon.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    hud_weapon.text = "В руках: %s · %d ур." % [Game.strike_title(),
        Game.strike_damage()]
    hero_box.add_child(hud_weapon)
    _cb_equipped = func(_weapon_id: String) -> void:
        if is_instance_valid(hud_weapon):
            hud_weapon.text = "В руках: %s · %d ур." % [Game.strike_title(),
                Game.strike_damage()]
    Game.equipped_changed.connect(_cb_equipped)
    _hud_hp = ProgressBar.new()
    _hud_hp.custom_minimum_size = Vector2(74, 8)
    _hud_hp.min_value = 0
    _hud_hp.max_value = Game.max_hp()
    _hud_hp.value = Game.hp
    _hud_hp.show_percentage = false
    _hud_hp.add_theme_stylebox_override("background",
        _bar_style(Color(0.09, 0.08, 0.1), Color(0.45, 0.2, 0.2)))
    _hud_hp.add_theme_stylebox_override("fill",
        _bar_style(Color(0.72, 0.26, 0.26), Color(0.72, 0.26, 0.26)))
    hero_box.add_child(_hud_hp)
    _cb_hp = func(hp: int, max_hp: int) -> void:
        if is_instance_valid(_hud_hp):
            _hud_hp.max_value = max_hp
            _hud_hp.value = hp
    Game.hp_changed.connect(_cb_hp)
    if Game.is_mage():
        _hud_mana = ProgressBar.new()
        _hud_mana.custom_minimum_size = Vector2(74, 8)
        _hud_mana.min_value = 0
        _hud_mana.max_value = Game.max_mana()
        _hud_mana.value = Game.mana
        _hud_mana.show_percentage = false
        _hud_mana.add_theme_stylebox_override("background",
            _bar_style(Color(0.08, 0.09, 0.13), Color(0.2, 0.3, 0.45)))
        _hud_mana.add_theme_stylebox_override("fill",
            _bar_style(Color(0.3, 0.6, 0.85), Color(0.3, 0.6, 0.85)))
        hero_box.add_child(_hud_mana)
        _cb_mana = func(mana: int, max_mana: int) -> void:
            if is_instance_valid(_hud_mana):
                _hud_mana.max_value = max_mana
                _hud_mana.value = mana
        Game.mana_changed.connect(_cb_mana)
    var open_bag := func() -> void:
        if not _dialogue.visible:
            _inventory_ui.open()
    var actions: Array = [
        {"text": "МЕНЮ", "font": 10, "cb": _on_menu_pressed},
        {"text": "СУМКА", "font": 10, "cb": open_bag},
    ]
    if Game.is_mage():
        actions.insert(2, {"text": "МАГИЯ", "font": 10, "cb": _cast_spell})
    actions.append({"text": "УДАР", "font": 10, "cb": _strike})
    var total_h := float(actions.size()) * BAR_BTN_SIZE.y \
        + float(actions.size() - 1) * (BAR_BTN_STEP - BAR_BTN_SIZE.y)
    var start_y := (UI_BAR_H - total_h) / 2.0
    for i in range(actions.size()):
        var spec: Dictionary = actions[i]
        var btn := Button.new()
        btn.text = String(spec["text"])
        btn.position = Vector2(BAR_BUTTONS_X, bar_top + start_y + float(i) * BAR_BTN_STEP)
        _style_small_button(btn, int(spec["font"]))
        btn.size = BAR_BTN_SIZE
        btn.pressed.connect(spec["cb"] as Callable)
        btn.set_meta("action_button", true)
        _hud_bar.add_child(btn)
    _resize_layout.call_deferred()

    # строка прогресса данжа — у верхнего края экрана ходьбы
    _hud_floor = Label.new()
    _hud_floor.set_anchors_preset(Control.PRESET_TOP_WIDE)
    _hud_floor.offset_top = 4.0
    _hud_floor.offset_bottom = 18.0
    _hud_floor.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    _hud_floor.add_theme_font_size_override("font_size", 11)
    _hud_floor.add_theme_color_override("font_color", Color(0.72, 0.62, 0.9))
    _hud_floor.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
    _hud_floor.add_theme_constant_override("shadow_offset_y", 1)
    layer.add_child(_hud_floor)
    _hud_hint = Label.new()
    _hud_hint.set_anchors_preset(Control.PRESET_TOP_WIDE)
    _hud_hint.offset_top = 20.0
    _hud_hint.offset_bottom = 58.0
    _hud_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    _hud_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    _hud_hint.add_theme_font_size_override("font_size", 12)
    _hud_hint.add_theme_color_override("font_color", Color(0.85, 0.88, 0.94))
    _hud_hint.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
    _hud_hint.add_theme_constant_override("shadow_offset_y", 1)
    layer.add_child(_hud_hint)
    Controls.bindings_changed.connect(_refresh_controls_hint)
    _refresh_controls_hint()

## «Подземелье · ур. N/10 · врагов: K» — обновляется на спавне и после убийств.
func _update_progress_label() -> void:
    if _hud_floor == null:
        return
    var alive := 0
    for foe in _foes:
        if not bool(foe.get("dead", false)) and not bool(foe.get("boss", false)):
            alive += 1
    _hud_floor.text = "Подземелье · ур. %d/10 · врагов: %d" % [_floor_num, alive]

func _show_floor_intro(boss_present: bool) -> void:
    if _floor_num <= 1:
        _show_hint(FLOOR_FIRST_HINT, 5.0)
    elif _floor_num >= DungeonBestiary.FLOORS:
        _show_hint(FLOOR_BOSS_HINT if boss_present else FLOOR_NO_BOSS_HINT, 5.0)
    else:
        _show_hint(String(FLOOR_HINT) % [_floor_num, _foes.size()], 4.0)

func _show_hint(text: String, seconds: float) -> void:
    if _hud_hint == null:
        return
    if _hint_tween != null and _hint_tween.is_valid():
        _hint_tween.kill()
    _hud_hint.text = text
    _hud_hint.modulate.a = 1.0
    _hint_tween = create_tween()
    _hint_tween.tween_interval(seconds)
    _hint_tween.tween_property(_hud_hint, "modulate:a", 0.0, 0.6)

func _bar_style(bg: Color, border: Color) -> StyleBoxFlat:
    var sb := StyleBoxFlat.new()
    sb.bg_color = bg
    sb.border_color = border
    sb.set_border_width_all(1)
    sb.content_margin_left = 1.0
    sb.content_margin_right = 1.0
    sb.content_margin_top = 1.0
    sb.content_margin_bottom = 1.0
    return sb

func _style_small_button(btn: Button, font_size: int) -> void:
    UiStyle.style_button(btn, font_size)
    for state in ["normal", "hover", "pressed"]:
        var sb := btn.get_theme_stylebox(state)
        if sb is StyleBoxFlat:
            (sb as StyleBoxFlat).content_margin_top = 3.0
            (sb as StyleBoxFlat).content_margin_bottom = 3.0
            (sb as StyleBoxFlat).content_margin_left = 4.0
            (sb as StyleBoxFlat).content_margin_right = 4.0

func _on_menu_pressed() -> void:
    Game.dungeon_floor = 0
    Platform.gameplay_stop()
    get_tree().change_scene_to_file(MAIN_SCENE)

## Пересчитывается при изменении размера окна и повороте устройства.
func _resize_layout() -> void:
    var view_size := get_viewport_rect().size
    if is_instance_valid(_walk_holder):
        _walk_holder.size = Vector2(view_size.x, view_size.y - UI_BAR_H)
    if is_instance_valid(_hud_bar):
        for child in _hud_bar.get_children():
            if child is Control and child.has_meta("action_button"):
                child.size = BAR_BTN_SIZE
                child.position.x = view_size.x - BAR_BTN_SIZE.x - 4.0


func _refresh_controls_hint() -> void:
    if _hud_hint == null:
        return
    _hud_hint.add_theme_font_size_override("font_size", 10)
    _hud_hint.tooltip_text = ""
    for action in Controls.get_actions():
        _hud_hint.tooltip_text += Controls.get_action_label(action) + ": " + Controls.get_binding_text(action) + "\n"
    _show_hint(Controls.get_hud_hint(Game.is_mage()), 5.0)
