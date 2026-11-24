## Подземелье замка — 1-й данж «Dungeon Loot» (шаги 13–15).
## Теперь 4 БОЛЬШИХ ТЕМАТИЧЕСКИХ этажа (вместо десяти тесных), карта
## 64x48, комнат 10–13, врагов на этаж 7–13 плюс элитные «чемпионы».
## Каждый этаж — своя тема: «Смрадные катакомбы» (пауки, паутина),
## «Пустотные чертоги» (космические пауки, звёздный камень), «Костяная
## обитель» (мертвецы, кости) и «Багровое логово» (демоны, ковёр, трон).
## На этажах 1–3 — сокровищница из золотой мозаики с хранителем-элитой,
## на 4-м — большой зал босса с колоннами, жаровнями и ковровой дорожкой.
## Факелы у стен и мягкий свет вокруг героя оживляют темноту (CanvasModulate).
## Лестница вниз открывается тишине: пока на этаже жив хоть один враг,
## путь закрыт. На 4-м этаже — обязательный босс: Таинственный демон
## с юга карты. Если мы видели его (диалог у края мира), он узнаёт героя
## и говорит об этом; битва начинается после реплик. Убив его, герой
## завершает данж: Game.defeat_demon_permanently — убитые NPC оживают
## и забывают убийства, демон больше не возвращается (сейв v6).
## Бой: удар (ЛКМ/УДАР) и магия (Q/МАГИЯ) — общий код с world.gd;
## у врагов хп, полоска, всплывающий урон; награда — золото (и иногда зелье).
## Шаг 18: способности героев — у каждого класса приём на Q и приём на
## пробел (таблица Game.ABILITIES): вихрь/щит воина, топор/бросок варвара,
## пыль/газ бомжа, магия/барьер мага; враги слепнут, оглушаются, летят.
## Сундуки: 4–5 на этаж (2 в сокровищнице/зале босса), внутри золото,
## зелья, питьё, оружие, броня или одеяния (таблицы — Loot.chest_loot).
## Победа над боссом даёт ЭПИЧЕСКОЕ случайное оружие золотого качества
## (Loot.epic_weapon_loot) — сильные клинки и магические посохи.
## Шаг 19: добыча сундука показывается иконкой в центре экрана на пару
## секунд; враги и NPC чуть крупнее; удар — с видимым оружием и дугой,
## снаряды со свечением и следом; появились звук эффектов (Sfx) и жуткий
## эмбиент в духе Silent Hill; сундуков на этаже 5–7; лестница вниз
## открыта сразу — убивать всех не обязательно; за врагов дают опыт,
## у героя — уровни: урон и максимум ХП +35% за уровень (шаг 25; HUD:
## полоса опыта, большая надпись «УРОВЕНЬ N!» с золотым взрывом).
## Шаг 20 (полировка): звук мягче, эмбиент мелодичнее; кулдауны приёмов
## снижены; эффекты способностей выразительнее (кольца, пульс щита/барьера,
## тряска камеры); боевка сочнее: отброс врага от удара, тряска на
## попаданиях, крупные золотые цифры урона; в HUD четыре кнопки МЕНЮ/
## СУМКА/СОХРАНИТЬ/ЗАГРУЗИТЬ (шаг 21: сумка вернулась в кнопки); бег на
## Shift (RUN_MULT); у каждого класса ТРЕТИЙ приём на T (special2):
## маг — «Выплеск магии» (вся мана, 20×уровень всем врагам карты),
## бомж — «Передышка» (полное лечение), рыцарь — «Град мечей»
## (каждое попадание — урон актуального удара). Шаг 22: у варвара на
## пробеле «Смертельный прыжок» (переехал с T), на T — новая ульта
## «Гнев титана»: 4 секунды герой огромен, урон не проходит, бьёт x4.
## Данж 3 «Глубины Р'льеха» работает без изменений кода: бестиарий
## отдаёт свои врагов и босса. Данж 4 «Логово Древних» — тоже (шаг 24).
## Шаг 24 (портал, ключи, лестницы, интерактив, щупальца, Шуб-Ниггурат):
## - на месте убитого босса открывается ПОРТАЛ В ЗАМОК (анимированный);
##   тот же портал ждёт и на этаже уже пройденного данжа;
## - босс отдаёт КЛЮЧ следующего подземелья (boss_key в DUNGEONS) —
##   иконка в центре экрана + подсказка; у финального босса ключа нет;
## - лестницы стали заметнее: свет, восходящие искры, крупный спрайт и
##   подпись; зона клика шире (шаг 24, п.5);
## - интерактивный реквизит: бочки/ящики разбиваются (золото), мешки
##   развязываются, кристаллы делятся силой, фонарь вспыхивает (п.6);
## - в данжах 3 и 4 из стен вырываются НЕУЯЗВИМЫЕ щупальца (п.7):
##   предупреждение-круг, мокрый удар, отступление; не бьются и не
##   блокируют путь — только страх и урон;
## - босс данжа 4 Шуб-Ниггурат (п.10): веер спор, полчища детенышей на
##   порогах ХП, фаза 2 «сад гаснет».
extends Node2D

const WORLD_SCENE := "res://scenes/world/world.tscn"
const MAIN_SCENE := "res://scenes/main/main.tscn"
const SPEED := 95.0
## Шаг 20: бег на Shift — быстрее в мире и в данже.
const RUN_MULT := 1.55
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
const BAR_BTN_STEP := 22.0   # шаг 21: кнопок четыре (МЕНЮ/СУМКА/СОХРАНИТЬ/ЗАГРУЗИТЬ)

## Общие тайлы атласа assets/tilesets/dungeon_tiles.png (шаг 15):
## стены/полы/свечение берутся из темы этажа, остальное — фикс. координаты.
const TILE_COLUMN := Vector2i(1, 0)
const TILE_BONES := Vector2i(3, 1)
const TILE_WEB := Vector2i(3, 2)
const TILE_BLOOD := Vector2i(4, 2)
const TILE_CARPET := Vector2i(1, 3)
const TILE_MOSAIC := Vector2i(2, 3)
const TILE_UP := Vector2i(0, 2)
const TILE_DOWN := Vector2i(1, 2)
const TILE_EXIT := Vector2i(2, 2)

## Параметры удара героя (шаг 7): те же, что в мире.
const STRIKE_RANGE := 28.0
const STRIKE_COOLDOWN := 0.4
## Шаг 19: визуал удара — белая дуга (tint по цвету оружия); сам объект
## удара — иконка оружия в руках (Game.strike_weapon_icon).
const SLASH_TEX_PATH := "res://assets/sprites/fx/slash_arc.png"
## Шаг 19: враги чуть крупнее (только визуал: хитбоксы и физика прежние,
## кайтинг в коридорах шириной 3 не страдает).
const FOE_SIZE_MULT := 1.18
const ELITE_SIZE_MULT := 1.48   # элита: рост 1.25 поверх общего увеличения
const BOSS_SIZE_MULT := 1.08
## Шаг 19: жуткий эмбиент подземелья (Silent Hill, бесшовный луп).
const AMBIENT_DB := -6.0

## Тексты подземелья (шаг 13): тон — лавкрафтовский космо-хоррор.
## Шаг 19: лестница вниз открыта сразу (см. _stairs_open) — реплика
## «запертой лестницы» больше не нужна.
const STAIRS_DOWN_HINT := "Лестница ведёт глубже. Камни помнят шаги тех, кто не вернулся."
const AGGRO_HINT := "%s заметил тебя. В темноте это плохо."
# Шаг 18: способности героев (параметры — в Game.ABILITIES).
const AXE_TEX_PATH := "res://assets/sprites/dungeon/throwing_axe.png"
const DUST_HINT := "Горсть пыли в глаза: тебя не видно!"
const GAS_HINT := "Гнилой газ заполняет воздух."
const LEAP_HINT := "Смертельный прыжок!"
## Шаг 22: «Гнев титана» варвара — форма с ростом спрайта.
const TITAN_HINT := "ГНЕВ ТИТАНА: урон не проходит, бьёшь в 4 раза сильнее!"
const TITAN_FADED_HINT := "Гнев титана угас."
## Элитный чемпион (шаг 15): крупнее, злее, богаче. Имя — с приставкой.
const ELITE_PREFIX := "Элитный "
const FOE_LOOT_GOLD_HINT := "%s рассыпался: +%d золота."
const FOE_LOOT_ITEM_HINT := "%s уронил: %s."
const EXIT_HINT := "Лестница в замок открыта. Ты можешь уйти с добычей — она твоя."
const STAIRS_UP_NAME := "Лестница наверх"
const STAIRS_DOWN_NAME := "Лестница вниз"
const EXIT_NAME := "Выход в замок"

## Шаг 24 (п.1): ключ следующего данжа с босса — на экране (иконка+текст).
const KEY_HINT := "Получен ключ: %s. Дверь следующего подземелья ждёт его."
## Шаг 24 (п.1): портал в замок на месте убитого босса.
const PORTAL_NAME := "Портал в замок"
const PORTAL_COLOR_A := Color(0.45, 0.85, 0.6, 0.6)
const PORTAL_COLOR_B := Color(1.0, 0.84, 0.2, 0.5)
## Шаг 24 (п.6): интерактивный реквизит этажей.
const PROP_BREAK_GOLD_HINT := "Бочка разлетелась щепками: +%d золота."
const PROP_BREAK_EMPTY_HINT := "Бочка пуста: только пыль и сквозняк."
const PROP_SACKS_HINT := "Мешок развязался: +%d золота."
const CRYSTAL_MANA_HINT := "Кристалл отдал свою силу: +%d маны."
const CRYSTAL_HP_HINT := "Кристалл обжог ладони: +%d хп."
const CRYSTAL_USED_HINT := "Кристалл потух: сила забрана."
const LANTERN_HINT := "Фонарь вспыхнул ярче — тень на миг отступила."
const LANTERN_USED_HINT := "Фонарь снова притих."
## Шаг 24 (п.7): щупальца из стен — данжи 3 и 4, неуязвимые предвестники.
const TENTACLE_TEX_PATH := "res://assets/sprites/dungeon/tentacle_wall.png"
const TENTACLE_HINT_FIRST := "Из стены вырывается щупальце! Предвестник того, что растёт в четвёртом подземелье."
const TENTACLE_HINT := "Из стены вырывается щупальце!"
const TENTACLE_MIN_INTERVAL := 9.0     # сек между вылазками (данж 4: чаще)
const TENTACLE_MAX_INTERVAL := 15.0
const TENTACLE_MIN_INTERVAL_4 := 6.5
const TENTACLE_MAX_INTERVAL_4 := 11.0
const TENTACLE_LIFE := 4.2             # сколько секунд щупальце торчит
const TENTACLE_TELL := 0.8             # сек между предупреждением и ударом
const TENTACLE_RADIUS := 30.0          # радиус удара (px)
const TENTACLE_DMG := 14               # урон удара (шаг 25: подтверждено, 12 -> 14)
## Шаг 24 (п.10): Шуб-Ниггурат — споры, полчища, фаза 2.
const SHUB_VOLLEY_CD := 4.2            # период веера спор (с)
const SHUB_VOLLEY_N := 7               # спор в веере
const SHUB_VOLLEY_SPREAD := 34.0       # полуширина веера (градусы)
const SHUB_SUMMON_HP := [0.75, 0.5, 0.25]   # пороги ХП призыва (по разу)
const SHUB_SUMMON_IDS := ["night_gaunt", "moon_beast",
    "tentacle_abomination"]            # полчища детенышей (пары по порогу)
const SHUB_PHASE2_HP := 0.4            # доля ХП для фазы 2 «сад гаснет»
const SHUB_PHASE2_CD := 0.9            # кулдаун когтей в фазе 2 (с)
const SHUB_PHASE2_SPEED := 58.0        # скорость в фазе 2 (px/с, < 95)
const SHUB_WHISPER_CD := 12.0          # период шёпота Козни (с)
const SHUB_SUMMON_COUNT := 2           # детенышей на порог

## Сундуки (шаг 14): спрайты 16×16 (chest_closed/chest_open), открытие —
## клик по сундуку или E рядом. Таблицы добычи — Loot.chest_loot.
const CHEST_CLOSED_TEX := "res://assets/sprites/chest_closed.png"
const CHEST_OPEN_TEX := "res://assets/sprites/chest_open.png"
const CHEST_GOLD_HINT := "В сундуке звенело золото: +%d."
const CHEST_ITEM_HINT := "В сундуке нашлось: %s."
const CHEST_EMPTY_HINT := "Сундук пуст: только пыль и чужие мечты."
## Эпическая награда босса (шаги 14/16): реплика о добыче живёт в реестре
## DungeonBestiary.DUNGEONS (boss_epic_hint) — у каждого данжа своя.

## Реквизит этажей (шаг 15): факелы у стен, жаровни и трон в зале босса,
## бочки/ящики/мешки в комнатах, кристаллы в сокровищнице и чертогах.
const PROP_TEX := {
    "barrel": "res://assets/sprites/props/barrel.png",
    "crate": "res://assets/sprites/props/crate.png",
    "sacks": "res://assets/sprites/props/sacks.png",
    "lantern": "res://assets/sprites/props/lantern.png",
    "throne": "res://assets/sprites/props/throne.png",
}
## Многокадровые пропы (анимированные).
const PROP_ANIM := {
    "torch": ["res://assets/sprites/props/torch_0.png",
        "res://assets/sprites/props/torch_1.png",
        "res://assets/sprites/props/torch_2.png"],
    "brazier": ["res://assets/sprites/props/brazier_0.png",
        "res://assets/sprites/props/brazier_1.png",
        "res://assets/sprites/props/brazier_2.png"],
    "crystal": ["res://assets/sprites/props/crystal_0.png",
        "res://assets/sprites/props/crystal_1.png"],
    "crystal_violet": ["res://assets/sprites/props/crystal_violet_0.png",
        "res://assets/sprites/props/crystal_violet_1.png"],
}
## Мягкий радиальный свет (glow.png, аддитивное смешение): факелы,
## жаровни, кристаллы и сам герой — чтобы темнота жила.
const GLOW_TEX_PATH := "res://assets/sprites/props/glow.png"
const TORCH_LIGHT_COLOR := Color(1.0, 0.62, 0.24, 0.5)
const PLAYER_LIGHT_COLOR := Color(1.0, 0.9, 0.72, 0.38)

## Диалог босса (шаг 13): если мы видели его у края мира — он узнаёт героя.
## Битва начинается, когда диалог закроется (обязательный босс). Шаг 16:
## реплики и роли боссов живут в определениях боссов бестиария, а тексты
## этажей и побед — в реестре DungeonBestiary.DUNGEONS.

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
var _hud_xp: ProgressBar                # полоса опыта (шаг 19)
var _hud_floor: Label                # «Подземелье · ур. N/4 · врагов: K»
var _hud_hint: Label
var _dialogue: DialogueUI
var _inventory_ui: InventoryUI
var _hint_tween: Tween

var _grid: Array[String] = []        # сетка текущего этажа
var _theme: Dictionary = {}          # тема текущего этажа (шаг 15)
var _dungeon_id := "dungeon_1"       # какое подземелье открыто (шаг 16)
var _floor_num := 1                  # текущий этаж (1..4)
var _foes: Array[Dictionary] = []    # противники этажа (включая босса)
var _stairs_up: Dictionary = {}      # {"pos": Vector2, "area": Area2D}
var _stairs_down: Dictionary = {}
var _stairs_exit: Dictionary = {}
var _chests: Array[Dictionary] = []  # сундуки этажа (шаг 14): тайл, спрайт, открыт
var _boss_hostile := false           # босс дерётся после диалога
var _boss_dialog_done := false
var _boss_defeated_here := false     # босс убит на этом этаже (для тестов)
# шаг 21: «воздух» этажа — Ктулху в фазе 2 гасит его до победы над собой
var _air: CanvasModulate = null
var _air_base := Color(1, 1, 1)
var _cthulhu_whisper_idx := 0        # шёпоты Р'льеха идут по кругу

var _bolts: Array[Dictionary] = []       # стрелы героя
var _foe_bolts: Array[Dictionary] = []   # болты колдунов
var _spell_cd := 0.0
var _mana_regen_accum := 0.0
var _strike_cd := 0.0
# Шаг 18: способности героев.
var _q_cd := 0.0                        # кулдаун приёма Q (не-маги)
var _special_cd := 0.0                  # кулдаун приёма на пробеле
var _t_cd := 0.0                        # кулдаун приёма T (шаг 20)
var _special_held := false              # приём-удержание активен (пробел зажат)
var _special_hold_left := 0.0           # сколько секунд удержания осталось
var _special_drain_accum := 0.0         # накопитель расхода маны барьера
var _hold_visual: Sprite2D = null       # круг барьера/щита (glow.png)
var _gas_clouds: Array[Dictionary] = []  # облака газа бомжа
var _titan_big := false                  # шаг 22: спрайт вырос (гнев титана)
var _titan_base_scale := Vector2.ONE     # шаг 22: обычный размер спрайта
## Шаг 24: интерактивный реквизит, щупальца из стен.
var _interactives: Array[Dictionary] = []   # бочки/кристаллы/фонари этажа
var _wall_tentacles: Array[Dictionary] = [] # живые щупальца из стен
var _tentacle_timer := 5.0                  # до следующей вылазки щупалец
var _tentacle_hint_shown := false
var _ability_axe_tex: Texture2D = null
var _facing := "down"
var _hero_sheet_tex: Texture2D
var _shadow_tex: Texture2D
var _bolt_tex: Texture2D
var _glow_tex: Texture2D
var _glow_mat: CanvasItemMaterial
var _dialogue_closed_at := -10000
var _player_dead := false
var _death_layer: CanvasLayer = null
var _player_flash_tween: Tween
## Шаг 19: звук, следы снарядов, попап добычи и празднование уровня.
var _weapon_tex_cache := {}          # иконки оружия для видимого взмаха
var _slash_tex: Texture2D = null
var _loot_popup_layer: CanvasLayer = null
var _loot_popup_box: VBoxContainer = null
var _loot_popup_icon: TextureRect = null
var _loot_popup_label: Label = null
var _loot_popup_tween: Tween
var _level_layer: CanvasLayer = null
## Шаг 20: град мечей, тряска камеры и прыжок варвара (приём T).
var _sword_rain: Array[Dictionary] = []   # падающие мечи рыцаря
var _shake_left := 0.0                    # сколько секунд ещё трясётся камера
var _shake_strength := 0.0                # амплитуда тряски, px
var _leap_flight: Dictionary = {}         # полёт варвара на врага (T)

## Лямбды HUD хранятся отдельно: сигналы Game (автозагрузка) переживают
## смену сцены, поэтому в _exit_tree их нужно отвязать — иначе после
## ухода из подземелья мёртвая лямбда падает на первом же изменении золота.
var _cb_gold: Callable
var _cb_equipped: Callable
var _cb_hp: Callable
var _cb_mana: Callable
var _cb_xp: Callable                 # полоса опыта (шаг 19)
var _cb_level: Callable              # строка «имя · ур. N» (шаг 19)

func _ready() -> void:
    _shadow_tex = load("res://assets/sprites/props/shadow.png")
    _bolt_tex = load("res://assets/sprites/icons/magic_bolt.png")
    _glow_tex = load(GLOW_TEX_PATH)
    _glow_mat = CanvasItemMaterial.new()
    _glow_mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
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
    # шаг 16: какое подземелье открыто (дверь 1 — замок, дверь 2 — скит)
    _dungeon_id = String(Game.current_dungeon)
    if DungeonBestiary.dungeon_meta(_dungeon_id).get("id", "") != _dungeon_id:
        _dungeon_id = "dungeon_1"
    Game.current_dungeon = _dungeon_id
    _floor_num = clampi(Game.dungeon_floor if Game.dungeon_floor >= 1 else 1,
        1, DungeonBestiary.FLOORS)
    Game.dungeon_floor = _floor_num
    _load_floor(_floor_num)
    # шаг 19: дуга удара, эмбиент подземелья и опыт героя
    _slash_tex = load(SLASH_TEX_PATH)
    Sfx.start_ambient(self, AMBIENT_DB)
    Game.level_up.connect(_on_level_up)
    Game.xp_changed.connect(_on_xp_changed)
    Platform.gameplay_start()

func _exit_tree() -> void:
    # шаг 18: неуязвимость/щит не переживают смену сцены
    Game.hero_immune = false
    Game.guard_active = false
    # шаг 19: эмбиент и сигналы опыта не переживают смену сцены
    Sfx.stop_ambient()
    if Game.level_up.is_connected(_on_level_up):
        Game.level_up.disconnect(_on_level_up)
    if Game.xp_changed.is_connected(_on_xp_changed):
        Game.xp_changed.disconnect(_on_xp_changed)
    if Controls.bindings_changed.is_connected(_refresh_controls_hint):
        Controls.bindings_changed.disconnect(_refresh_controls_hint)
    Platform.gameplay_stop()
    if Game.hp_changed.is_connected(_on_player_hp_changed):
        Game.hp_changed.disconnect(_on_player_hp_changed)
    _disconnect_cb(Game.gold_changed, _cb_gold)
    _disconnect_cb(Game.equipped_changed, _cb_equipped)
    _disconnect_cb(Game.hp_changed, _cb_hp)
    _disconnect_cb(Game.mana_changed, _cb_mana)
    # Шаг 23: полоса опыта и строка уровня ТОЖЕ лямбды на сигналах Game —
    # без отвязки они переживали free() сцены и сыпали «Lambda capture
    # ... was freed» при каждом изменении опыта/уровня.
    _disconnect_cb(Game.xp_changed, _cb_xp)
    _disconnect_cb(Game.level_up, _cb_level)

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
    # шаг 25: ПК-раскладка — экран ходьбы во всю ширину окна минус консоль
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

## Собрать этаж: тёмный фон, тайлы из сетки (по теме этажа), факелы,
## реквизит, сущности, враги, лестницы, герой и камера. Вызывается
## на старте и при переходе между этажами.
func _load_floor(floor_num: int) -> void:
    _floor_num = clampi(floor_num, 1, DungeonBestiary.FLOORS)
    Game.dungeon_floor = _floor_num
    _clear_level()
    _interactives.clear()   # шаг 24: реквизит нового этажа пересобирается
    var is_boss_floor: bool = _floor_num >= DungeonBestiary.FLOORS
    # шаг 16: босс данжа 1 мёртв навсегда через demon_defeated, босс данжа 2 —
    # через пройденность данжа (dungeons_cleared сохраняется в сейве)
    var boss_present := false
    if is_boss_floor:
        if _dungeon_id == "dungeon_1":
            boss_present = not Game.demon_gone_forever()
        else:
            boss_present = not Game.dungeons_cleared.has(_dungeon_id)
    var level := DungeonBestiary.generate_floor(_floor_num, boss_present,
        _dungeon_id)
    _grid = level["grid"]
    _theme = DungeonBestiary.theme_for_floor(_floor_num, _dungeon_id)

    _level_root = Node2D.new()
    _level_root.name = "Level"
    _world.add_child(_level_root)

    # фон: глухая тьма подземелья (звёзд здесь нет)
    var bg := ColorRect.new()
    bg.color = Color(0.015, 0.012, 0.022)
    bg.size = Vector2(DungeonBestiary.MAP_W * 16.0 + 400.0,
        DungeonBestiary.MAP_H * 16.0 + 400.0)
    bg.position = Vector2(-200, -200)
    _level_root.add_child(bg)

    # приглушённый «воздух» этажа (шаг 15): темнота, которую оживляют
    # факелы, жаровни, кристаллы и мягкий свет вокруг героя
    var air := CanvasModulate.new()
    air.name = "Air"
    air.color = _theme.get("canvas", Color(0.85, 0.85, 0.85))
    _level_root.add_child(air)
    _air = air                        # шаг 21: для фазы 2 Ктулху
    _air_base = air.color
    _cthulhu_whisper_idx = 0

    _build_tiles()
    _build_entities()
    _spawn_props(level)   # факелы, жаровни, кристаллы, бочки, трон

    # лестницы
    _stairs_up = {}
    _stairs_down = {}
    _stairs_exit = {}
    var up: Vector2i = level["up"]
    _register_stairs(_stairs_up, STAIRS_UP_NAME, up, "_use_stairs_up", TILE_UP)
    var down: Vector2i = level["down"]
    if down.x >= 0:
        _register_stairs(_stairs_down, STAIRS_DOWN_NAME, down,
            "_use_stairs_down", TILE_DOWN)

    # враги (шаг 15): у каждого спавна свой вид и флаг «элитного чемпиона»
    _foes.clear()
    for spawn in level["foe_spawns"]:
        var def: Dictionary = DungeonBestiary.foe_def(String(spawn["id"]))
        _spawn_foe(def, spawn["tile"], bool(spawn.get("elite", false)))

    # сундуки (шаг 14): спавн ДО выхода, чтобы выход не встал на сундук
    _chests.clear()
    for t in level["chest_tiles"]:
        _spawn_chest(t)

    var boss_tile: Vector2i = level["boss_tile"]
    if boss_tile.x >= 0:
        _spawn_boss(boss_tile)
    elif is_boss_floor:
        # босс уже повержен навсегда: на последнем этаже сразу есть выход
        var exit_tile: Vector2i = level["exit_tile"]
        _place_exit(exit_tile if exit_tile.x >= 0
            else Vector2i(DungeonBestiary.MAP_W / 2, 10))

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
    _interactives.clear()
    _wall_tentacles.clear()
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
    _ground = TileMapLayer.new()
    _ground.name = "Ground"
    _ground.tile_set = tileset
    _level_root.add_child(_ground)
    # тайлы создаются по мере встречи в сетке (шаг 15: стены/полы — из темы)
    var created := {}
    for y in DungeonBestiary.MAP_H:
        for x in DungeonBestiary.MAP_W:
            var symbol: String = _grid[y][x]
            var coords := _tile_coord(symbol, x, y)
            if not created.has(coords):
                source.create_tile(coords)
                if DungeonBestiary.SOLID.contains(symbol):
                    var data := source.get_tile_data(coords, 0)
                    data.add_collision_polygon(0)
                    data.set_collision_polygon_points(0, 0, square)
                created[coords] = true
            _ground.set_cell(Vector2i(x, y), source_id, coords)

## Символ сетки -> координаты атласа (шаг 15). Стены/полы/свечение — из
## темы этажа; полы таскаются по хэшу клетки, чтобы кладка не монотонила.
func _tile_coord(symbol: String, x: int, y: int) -> Vector2i:
    match symbol:
        "#":
            var wall: Vector2i = _theme.get("wall", Vector2i(0, 0))
            return wall
        ".":
            var variants: Array = _theme.get("floors", [Vector2i(0, 1)])
            var tile: Vector2i = variants[(x * 7 + y * 13) % variants.size()]
            return tile
        "g":
            var glow: Vector2i = _theme.get("glow", Vector2i(5, 2))
            return glow
        "o":
            return TILE_COLUMN
        "b":
            return TILE_BONES
        "w":
            return TILE_WEB
        "x":
            return TILE_BLOOD
        "p":
            return TILE_CARPET
        "m":
            return TILE_MOSAIC
        "<":
            return TILE_UP
        ">":
            return TILE_DOWN
        "X":
            return TILE_EXIT
    return Vector2i(0, 1)

var _tile_source_id := 0

func _build_entities() -> void:
    _entities = Node2D.new()
    _entities.name = "Entities"
    _entities.y_sort_enabled = true
    _level_root.add_child(_entities)

# ------------------------------------------------ факелы и реквизит (шаг 15)

## Многокадровый спрайт пропа (факел, жаровня, кристалл) из списка текстур.
func _make_prop_frames(paths: Array, fps: float) -> SpriteFrames:
    var frames := SpriteFrames.new()
    frames.remove_animation("default")
    frames.add_animation("idle")
    frames.set_animation_speed("idle", fps)
    frames.set_animation_loop("idle", true)
    for p in paths:
        frames.add_frame("idle", load(String(p)))
    return frames

## Факелы у стен (свет + мерцание) и реквизит этажа: блокирующие бочки,
## ящики, кристаллы, жаровни с огнём, трон за боссом.
func _spawn_props(level: Dictionary) -> void:
    for tile in level["torch_tiles"]:
        _spawn_torch(tile)
    for spec in level["prop_tiles"]:
        _spawn_prop(String(spec["kind"]), spec["tile"])

func _spawn_torch(tile: Vector2i) -> void:
    var center := Vector2(tile.x * 16.0 + 8.0, tile.y * 16.0 + 8.0)
    var node := Node2D.new()
    node.name = "Torch_%d_%d" % [tile.x, tile.y]
    node.position = center
    var glow := Sprite2D.new()
    glow.texture = _glow_tex
    glow.material = _glow_mat
    glow.scale = Vector2(2.6, 2.6)
    glow.modulate = TORCH_LIGHT_COLOR
    glow.position = Vector2(0, -12)
    node.add_child(glow)
    var spr := AnimatedSprite2D.new()
    spr.sprite_frames = _make_prop_frames(PROP_ANIM["torch"], 7.0)
    spr.position = Vector2(0, -8)
    spr.play("idle")
    node.add_child(spr)
    # мерцание света: два случайных полутакта в цикле
    var tw := node.create_tween().set_loops()
    tw.tween_property(glow, "modulate:a",
        randf_range(0.3, 0.42), randf_range(0.3, 0.55))
    tw.tween_property(glow, "modulate:a", 0.5, randf_range(0.3, 0.55))
    _entities.add_child(node)

func _spawn_prop(kind: String, tile: Vector2i) -> void:
    var center := Vector2(tile.x * 16.0 + 8.0, tile.y * 16.0 + 8.0)
    var node := Node2D.new()
    node.name = "Prop_%s_%d_%d" % [kind, tile.x, tile.y]
    node.position = center
    _add_shadow(node, 0.9)
    var body := StaticBody2D.new()
    body.collision_layer = 1
    body.collision_mask = 0
    var body_shape := CollisionShape2D.new()
    var circle := CircleShape2D.new()
    circle.radius = 5.5
    body_shape.shape = circle
    body_shape.position = Vector2(0, -2)
    body.add_child(body_shape)
    node.add_child(body)
    # Шаг 24 (п.6): реквизит ИНТЕРАКТИВЕН — клик по нему не бьёт мечом,
    # а использует (E тоже). Трон и жаровни зала босса остаются декором.
    if kind != "throne" and kind != "brazier":
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
        var rec := {"kind": kind, "tile": tile, "pos": center,
            "node": node, "sprite": node.get_child(node.get_child_count() - 1),
            "body": body, "used": false}
        area.input_event.connect(_on_prop_input.bind(rec))
        _interactives.append(rec)
    if PROP_ANIM.has(kind):
        var spr := AnimatedSprite2D.new()
        spr.sprite_frames = _make_prop_frames(PROP_ANIM[kind], 5.0)
        spr.position = Vector2(0, -4)
        spr.play("idle")
        node.add_child(spr)
    else:
        var spr2 := Sprite2D.new()
        spr2.texture = load(String(PROP_TEX.get(kind, PROP_TEX["barrel"])))
        spr2.position = Vector2(0, -2)
        node.add_child(spr2)
    # Шаг 24: визуальный узел пропа — последний добавленный ребёнок
    if not _interactives.is_empty() \
            and (_interactives.back() as Dictionary)["node"] == node:
        (_interactives.back() as Dictionary)["sprite"] = \
            node.get_child(node.get_child_count() - 1)
    # цветной свет пропа (жаровни/кристаллы/фонарь)
    match kind:
        "brazier":
            _add_prop_glow(node, Color(1.0, 0.5, 0.2, 0.45), Vector2(0, -10), 2.2)
        "crystal":
            _add_prop_glow(node, Color(0.4, 0.75, 0.9, 0.35), Vector2(0, -8), 1.8)
        "crystal_violet":
            _add_prop_glow(node, Color(0.7, 0.5, 1.0, 0.35), Vector2(0, -8), 1.8)
        "lantern":
            _add_prop_glow(node, Color(1.0, 0.8, 0.5, 0.4), Vector2(0, -10), 1.9)
    _entities.add_child(node)

func _add_prop_glow(node: Node2D, color: Color, pos: Vector2,
        scale_f: float) -> void:
    var glow := Sprite2D.new()
    glow.texture = _glow_tex
    glow.material = _glow_mat
    glow.scale = Vector2(scale_f, scale_f)
    glow.modulate = color
    glow.position = pos
    node.add_child(glow)

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
## elite (шаг 15): «элитный чемпион» — крупнее (1.25x), вдвое жилистей,
## больнее и втрое богаче; имя — с приставкой «Элитный ».
func _spawn_foe(def: Dictionary, tile: Vector2i, elite: bool = false) -> Dictionary:
    var pos := _feet_pos(Vector2(tile))
    var node := Node2D.new()
    node.name = "Foe_%s" % String(def["id"])
    node.position = pos
    _add_shadow(node, 1.1 if elite else 0.9)
    var spr := AnimatedSprite2D.new()
    spr.sprite_frames = _make_frames(load(String(def["sheet"])))
    spr.position = Vector2(0, -CHAR_H / 2.0 + 3.0)
    # шаг 19: враги чуть крупнее, элита — заметно крупнее
    spr.scale = Vector2(ELITE_SIZE_MULT, ELITE_SIZE_MULT) if elite \
        else Vector2(FOE_SIZE_MULT, FOE_SIZE_MULT)
    spr.play("idle_down")
    node.add_child(spr)
    var body := StaticBody2D.new()
    body.collision_layer = 1
    body.collision_mask = 0
    var body_shape := CollisionShape2D.new()
    var circle := CircleShape2D.new()
    circle.radius = 6.0 if elite else 5.0
    body_shape.shape = circle
    body_shape.position = Vector2(0, -2)
    body.add_child(body_shape)
    node.add_child(body)
    var hp := maxi(1, int(def["hp"]))
    var dmg := maxi(1, int(def["damage"]))
    if elite:
        hp = maxi(2, int(round(float(hp) * 1.9)))
        dmg = maxi(1, int(round(float(dmg) * 1.5)))
    var hp_bar := _make_hp_bar(hp, 1.25 if elite else 1.0)
    node.add_child(hp_bar)
    _entities.add_child(node)
    var title := String(def.get("name", "Враг"))
    if elite:
        title = ELITE_PREFIX + title
    var foe := {"id": String(def["id"]), "def": def, "node": node,
        "sprite": spr, "hp": hp, "max_hp": hp, "hp_bar": hp_bar,
        "body": body, "aggro": false, "atk_cd": 0.0,
        "bolt_cd": 0.0, "boss": false, "dead": false,
        "elite": elite, "dmg": dmg, "title": title,
        "gold_mult": 3 if elite else 1, "flash_tween": null}
    _foes.append(foe)
    return foe

## Босс последнего этажа: Таинственный демон — тот же лист 72x96, что у
## демона с юга карты (втрое крупнее врагов). Дерётся только после диалога.
func _spawn_boss(tile: Vector2i) -> void:
    var def: Dictionary = DungeonBestiary.boss_for(_dungeon_id)
    var s := maxi(1, int(def.get("scale", 3)))
    var node := Node2D.new()
    node.name = "Boss"
    node.position = _feet_pos(Vector2(tile))
    _add_shadow(node, 0.9 * s)
    var spr := AnimatedSprite2D.new()
    spr.sprite_frames = _make_frames(load(String(def["sheet"])),
        CHAR_W * s, CHAR_H * s)
    spr.position = Vector2(0, -(CHAR_H * s) / 2.0 + 3.0)
    spr.scale = Vector2(BOSS_SIZE_MULT, BOSS_SIZE_MULT)   # шаг 19
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
    if String(def["id"]) == "boss_cthulhu":
        _decorate_cthulhu(boss)       # шаг 21: глаза-угли, аура, дыхание
    elif String(def["id"]) == "boss_shub":
        _decorate_shub(boss)          # шаг 24: три глаза, аура спор, дыхание
    _foes.append(boss)

func _make_hp_bar(hp: int, s: float) -> ProgressBar:
    var hp_bar := ProgressBar.new()
    hp_bar.min_value = 0
    hp_bar.max_value = hp
    hp_bar.value = hp
    hp_bar.show_percentage = false
    hp_bar.custom_minimum_size = Vector2(24.0 * s, 4)
    hp_bar.size = Vector2(24.0 * s, 4)
    hp_bar.position = Vector2(-12.0 * s, -float(CHAR_H) * s - 4)
    hp_bar.visible = false
    hp_bar.add_theme_stylebox_override("background",
        _bar_style(Color(0.09, 0.08, 0.1), Color(0.4, 0.18, 0.18)))
    hp_bar.add_theme_stylebox_override("fill",
        _bar_style(Color(0.72, 0.26, 0.26), Color(0.72, 0.26, 0.26)))
    return hp_bar

# ---------------------------------------------------------------- лестницы

## Лестница (шаг 24, п.5): тайл на полу + зона клика (Area2D), а также
## СВЕТ, восходящие искры, крупный спрайт ступеней и подпись — лестницы
## теперь видно издалека и хочется подойти. По E — ближайшая в радиусе.
func _register_stairs(store: Dictionary, title: String, tile: Vector2i,
        method: String, tile_coord: Vector2i = Vector2i(0, 2)) -> void:
    var center := Vector2(tile.x * 16.0 + 8.0, tile.y * 16.0 + 8.0)
    var area := Area2D.new()
    area.input_pickable = true
    area.collision_layer = 4
    area.collision_mask = 0
    var shape := CollisionShape2D.new()
    var rect := RectangleShape2D.new()
    rect.size = Vector2(24, 24)   # шаг 24: зона клика шире
    shape.shape = rect
    area.add_child(shape)
    area.input_event.connect(_on_stairs_input.bind(method))
    var marker := Node2D.new()
    marker.name = title
    marker.position = center
    marker.add_child(area)
    # --- шаг 24: крупный спрайт ступеней (2x2 из атласа, «чанки»)
    var atlas: Texture2D = load("res://assets/tilesets/dungeon_tiles.png")
    var big := AtlasTexture.new()
    big.atlas = atlas
    big.region = Rect2(tile_coord.x * 16.0, tile_coord.y * 16.0, 16.0, 16.0)
    var spr := Sprite2D.new()
    spr.texture = big
    spr.scale = Vector2(1.9, 1.9)
    spr.position = Vector2(0, -6)
    marker.add_child(spr)
    # --- мягкий свет: у лестницы свой оттенок (вверх — синий, вниз —
    # фиолет, выход/портал — золото)
    var color := Color(0.6, 0.75, 1.0, 0.4)
    if method == "_use_stairs_down":
        color = Color(0.7, 0.5, 1.0, 0.42)
    elif method == "_use_stairs_exit":
        color = PORTAL_COLOR_A
    var glow := Sprite2D.new()
    glow.texture = _glow_tex
    glow.material = _glow_mat
    glow.scale = Vector2(2.2, 2.2)
    glow.modulate = color
    glow.position = Vector2(0, -8)
    marker.add_child(glow)
    var pulse := glow.create_tween().set_loops()
    pulse.tween_property(glow, "modulate:a", color.a * 0.55, 0.9) \
        .set_trans(Tween.TRANS_SINE)
    pulse.tween_property(glow, "modulate:a", color.a, 0.9) \
        .set_trans(Tween.TRANS_SINE)
    # --- восходящие искры (вниз — опадающие): лестница «дышит»
    var sparks := CPUParticles2D.new()
    sparks.amount = 7
    sparks.lifetime = 1.1
    sparks.position = Vector2(0, -2)
    sparks.direction = Vector2(0, -1) if method != "_use_stairs_down" \
        else Vector2(0, 1)
    sparks.spread = 16.0
    sparks.initial_velocity_min = 6.0
    sparks.initial_velocity_max = 16.0
    sparks.scale_amount_min = 1.0
    sparks.scale_amount_max = 2.0
    sparks.color = Color(color.r, color.g, color.b, 0.75)
    sparks.emitting = true
    marker.add_child(sparks)
    # --- подпись: имя лестницы над ней (как у NPC)
    var label := Label.new()
    label.text = title
    label.position = Vector2(-56, -float(CHAR_H) * 2 - 6)
    label.size = Vector2(112, 12)
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.add_theme_font_size_override("font_size", 8)
    label.add_theme_color_override("font_color", COLOR_GOLD)
    label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.7))
    label.add_theme_constant_override("shadow_offset_y", 1)
    marker.add_child(label)
    _level_root.add_child(marker)
    store["pos"] = center
    store["area"] = area

func _on_stairs_input(_viewport: Node, event: InputEvent, _shape_idx: int,
        method: String) -> void:
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
            # шаг 19: убивать всех не обязательно — лестница открыта сразу
            Sfx.play("stairs")
            _show_hint(STAIRS_DOWN_HINT, 2.5)
            _goto_floor(_floor_num + 1)
        "_use_stairs_exit":
            _leave_dungeon()

## Переход на этаж: этажи генерируются заново — рогалик.
func _goto_floor(floor_num: int) -> void:
    _load_floor(floor_num)
    if _camera != null:
        _camera.reset_smoothing()

## Шаг 19: лестница вниз открыта сразу — убивать всех не обязательно.
## Враги стали необязательными (с них опыт и золото), босс всё так же
## сторожит только свой выход на последнем этаже.
func _stairs_open() -> bool:
    return true

## Покинуть подземелье: вернуться в замок (прогресс этажей обнуляется).
func _leave_dungeon() -> void:
    Game.dungeon_floor = 0
    Platform.gameplay_stop()
    get_tree().change_scene_to_file(WORLD_SCENE)

## Выход в замок на этаже босса, когда босс давно повержен.
## Тайл сдвигается, если на нём стоит сундук (шаг 14).
func _place_exit(tile: Vector2i) -> void:
    tile = _free_exit_tile(tile)
    _set_grid_cell(tile, "X")
    if _ground != null:
        _ground.set_cell(tile, _tile_source_id, TILE_EXIT)
    _register_stairs(_stairs_exit, EXIT_NAME, tile, "_use_stairs_exit", TILE_EXIT)
    _spawn_portal(_stairs_exit["pos"])

## Портал в замок (шаг 24, п.1): анимированный выход из данжа — два
## вращающихся кольца света, восходящие искры и подпись. Клик по нему
## работает как по лестнице-выходу (зона 28 px), E — тоже.
func _spawn_portal(pos: Vector2) -> void:
    var node := Node2D.new()
    node.name = "Portal"
    node.add_to_group("portal")
    node.position = pos
    var ring_a := Sprite2D.new()
    ring_a.texture = _glow_tex
    ring_a.material = _glow_mat
    ring_a.scale = Vector2(1.7, 1.7)
    ring_a.modulate = PORTAL_COLOR_A
    node.add_child(ring_a)
    var ring_b := Sprite2D.new()
    ring_b.texture = _glow_tex
    ring_b.material = _glow_mat
    ring_b.scale = Vector2(1.1, 1.1)
    ring_b.modulate = PORTAL_COLOR_B
    node.add_child(ring_b)
    # вращение колец в противофазе — портал «живой»
    var ta := ring_a.create_tween().set_loops()
    ta.tween_property(ring_a, "rotation", TAU, 3.2).from(0.0)
    ta.parallel().tween_property(ring_a, "scale", Vector2(1.9, 1.9), 1.2) \
        .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    ta.chain().tween_property(ring_a, "scale", Vector2(1.6, 1.6), 1.2) \
        .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    var tb := ring_b.create_tween().set_loops()
    tb.tween_property(ring_b, "rotation", -TAU, 2.4).from(0.0)
    tb.parallel().tween_property(ring_b, "modulate:a",
        PORTAL_COLOR_B.a * 0.55, 0.7).set_trans(Tween.TRANS_SINE)
    tb.tween_property(ring_b, "modulate:a", PORTAL_COLOR_B.a, 0.7) \
        .set_trans(Tween.TRANS_SINE)
    # столб восходящих искр
    var sparks := CPUParticles2D.new()
    sparks.amount = 12
    sparks.lifetime = 1.3
    sparks.position = Vector2(0, -4)
    sparks.direction = Vector2(0, -1)
    sparks.spread = 14.0
    sparks.initial_velocity_min = 10.0
    sparks.initial_velocity_max = 26.0
    sparks.scale_amount_min = 1.0
    sparks.scale_amount_max = 2.2
    sparks.color = Color(0.5, 0.9, 0.65, 0.8)
    sparks.emitting = true
    node.add_child(sparks)
    var label := Label.new()
    label.text = PORTAL_NAME
    label.position = Vector2(-56, -52)
    label.size = Vector2(112, 12)
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.add_theme_font_size_override("font_size", 8)
    label.add_theme_color_override("font_color", Color(0.55, 0.95, 0.65))
    label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.7))
    label.add_theme_constant_override("shadow_offset_y", 1)
    node.add_child(label)
    # собственная зона клика 28 px: клик = выход в замок
    var area := Area2D.new()
    area.input_pickable = true
    area.collision_layer = 4
    area.collision_mask = 0
    var shape := CollisionShape2D.new()
    var rect := RectangleShape2D.new()
    rect.size = Vector2(28, 28)
    shape.shape = rect
    area.add_child(shape)
    area.input_event.connect(_on_portal_input)
    node.add_child(area)
    _level_root.add_child(node)

func _on_portal_input(_viewport: Node, event: InputEvent,
        _shape_idx: int) -> void:
    if event is InputEventMouseButton and event.pressed \
            and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
        _click_dialog_at = Time.get_ticks_msec()
        _use_stairs("_use_stairs_exit")

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
    Sfx.play("chest")
    var loot := Loot.chest_loot(_floor_num)
    if loot.has("item_id"):
        var item_id := String(loot["item_id"])
        var quality := String(loot.get("quality", "gray"))
        Game.add_item({"item_id": item_id, "title": ItemDB.title(item_id),
            "quality": quality})
        _show_hint(String(CHEST_ITEM_HINT) % ItemDB.title(item_id), 3.5)
        # шаг 19: добыча — иконкой в центре экрана на пару секунд
        _show_loot_popup(ItemDB.title(item_id), ItemDB.icon(item_id), quality)
        return
    var amount := maxi(1, int(loot.get("gold", 10)))
    Game.add_gold(amount)
    _show_hint(String(CHEST_GOLD_HINT) % amount, 3.0)
    _show_loot_popup("+%d золота" % amount,
        "res://assets/sprites/icons/pouch_gold.png", "gold")
    Sfx.play("coin")

# ----------------------------------- интерактивный реквизит (шаг 24, п.6)

func _on_prop_input(_viewport: Node, event: InputEvent, _shape_idx: int,
        rec: Dictionary) -> void:
    if event is InputEventMouseButton and event.pressed \
            and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
        _click_dialog_at = Time.get_ticks_msec()   # этот клик — не удар
        _use_interactive(rec)

## Использовать интерактивный объект (шаг 24, п.6):
## бочка/ящик — разбить (золото или пусто), мешок — развязать,
## кристалл — разделиться силой (мана магу, хп остальным), фонарь — вспышка.
func _use_interactive(rec: Dictionary) -> void:
    if _player_dead or player == null:
        return
    if bool(rec.get("used", false)):
        return
    rec["used"] = true
    var kind := String(rec["kind"])
    var pos: Vector2 = rec["pos"]
    match kind:
        "barrel", "crate":
            (rec["sprite"] as Node2D).visible = false
            (rec["body"] as StaticBody2D).get_child(0).call_deferred(
                "set_disabled", true)
            _spawn_hit_impact(pos + Vector2(0, -6), Color(0.72, 0.55, 0.35))
            _spell_poof(pos + Vector2(0, -8), Color(0.68, 0.5, 0.3))
            Sfx.play("chest", -4.0)
            if randi() % 100 < 45:
                var amount := randi_range(4, 12)
                Game.add_gold(amount)
                Sfx.play("coin")
                _show_hint(String(PROP_BREAK_GOLD_HINT) % amount, 2.2)
                _show_loot_popup("+%d золота" % amount,
                    "res://assets/sprites/icons/pouch_gold.png", "gold")
            else:
                _show_hint(PROP_BREAK_EMPTY_HINT, 2.0)
        "sacks":
            (rec["sprite"] as Node2D).visible = false
            _spell_poof(pos + Vector2(0, -8), Color(0.62, 0.58, 0.44))
            var amount2 := randi_range(2, 8)
            Game.add_gold(amount2)
            Sfx.play("coin")
            _show_hint(String(PROP_SACKS_HINT) % amount2, 2.2)
            _show_loot_popup("+%d золота" % amount2,
                "res://assets/sprites/icons/pouch_gold.png", "gold")
        "crystal", "crystal_violet":
            var tint := Color(0.4, 0.75, 0.9) if kind == "crystal" \
                else Color(0.7, 0.5, 1.0)
            _spell_poof(pos + Vector2(0, -10), tint)
            _spawn_ring(pos + Vector2(0, -8), tint, 1.6)
            Sfx.play("heal", -4.0)
            if Game.is_mage():
                var restored := Game.restore_mana(15)
                _show_hint(String(CRYSTAL_MANA_HINT) % restored, 2.4)
            else:
                var healed := Game.heal_hp(5)
                _show_hint(String(CRYSTAL_HP_HINT) % healed, 2.4)
            var spr_node: Node2D = rec["sprite"]
            spr_node.modulate = Color(0.55, 0.55, 0.6)
        "lantern":
            _spell_poof(pos + Vector2(0, -12), Color(1.0, 0.85, 0.5))
            _spawn_ring(pos + Vector2(0, -10), Color(1.0, 0.8, 0.45, 0.6), 2.4)
            Sfx.play("stairs", -6.0)
            _show_hint(LANTERN_HINT, 2.2)
            (rec["sprite"] as Node2D).modulate = Color(1.15, 1.1, 0.95)
        _:
            rec["used"] = false

# ----------------------------------- щупальца из стен (шаг 24, п.7)

## Вылазка щупальца: НЕУЯЗВИМЫЙ и незаблокирующий хазард — не в _foes,
## кликом не выделяется, бьёт с предупреждением и прячется обратно.
func _update_wall_tentacles(delta: float) -> void:
    if player == null or _player_dead:
        return
    # спавн по таймеру: только в данжах 3 и 4 (в 4-м — чаще: они «дома»)
    if _dungeon_id != "dungeon_3" and _dungeon_id != "dungeon_4":
        return
    _tentacle_timer -= delta
    if _tentacle_timer <= 0.0:
        _spawn_wall_tentacle()
        _tentacle_timer = randf_range(TENTACLE_MIN_INTERVAL_4, TENTACLE_MAX_INTERVAL_4) \
            if _dungeon_id == "dungeon_4" \
            else randf_range(TENTACLE_MIN_INTERVAL, TENTACLE_MAX_INTERVAL)
    # жизнь активных щупалец: предупреждение -> удар -> отступление
    var now_ms := Time.get_ticks_msec()
    for i in range(_wall_tentacles.size() - 1, -1, -1):
        var rec: Dictionary = _wall_tentacles[i]
        var node: Node2D = rec["node"]
        var t := float(now_ms - int(rec["born"])) / 1000.0
        # выдвижение: рост из стены
        var grow := clampf(t / 0.5, 0.0, 1.0)
        (node.get_child(1) as Sprite2D).scale = \
            (rec["base_scale"] as Vector2) * grow
        if t >= float(rec["slam_in"]) and not bool(rec["slammed"]):
            rec["slammed"] = true
            _wall_tentacle_slam(rec)
        if t >= TENTACLE_LIFE:
            # отступление: щупальце уходит обратно в камень
            var tw := create_tween()
            tw.tween_property(node, "scale", Vector2(0.05, 0.05), 0.45) \
                .set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
            tw.tween_callback(func() -> void:
                if is_instance_valid(node):
                    node.queue_free())
            _wall_tentacles.remove_at(i)

## Спавн щупальца у стены рядом с героем (2..8 тайлов, из стены в пол).
func _spawn_wall_tentacle() -> void:
    var ptile := Vector2i(int(floor(player.position.x / 16.0)),
        int(floor(player.position.y / 16.0)))
    var best := Vector2i(-1, -1)
    var wall_t := Vector2i(-1, -1)
    for attempt in range(40):
        var dx := randi_range(-8, 8)
        var dy := randi_range(-8, 8)
        var t := ptile + Vector2i(dx, dy)
        var d := float(Vector2(t - ptile).length())
        if d < 2.5 or d > 8.0:
            continue
        if t.x < 1 or t.y < 1 or t.x >= DungeonBestiary.MAP_W - 1 \
                or t.y >= DungeonBestiary.MAP_H - 1:
            continue
        if _tile_is_solid(Vector2(t.x * 16.0 + 8.0, t.y * 16.0 + 8.0)):
            continue
        # ищем стену-соседа: щупальце лезет ИЗ стены
        for off in [Vector2i(0, -1), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(1, 0)]:
            var n: Vector2i = t + off
            if n.x < 0 or n.y < 0 or n.x >= DungeonBestiary.MAP_W \
                    or n.y >= DungeonBestiary.MAP_H:
                continue
            if String(_grid[n.y][n.x]) == "#":
                best = t
                wall_t = n
                break
        if best.x >= 0:
            break
    if best.x < 0:
        return
    var center := Vector2(best.x * 16.0 + 8.0, best.y * 16.0 + 8.0)
    var node := Node2D.new()
    node.name = "WallTentacle_%d_%d" % [best.x, best.y]
    node.position = center
    node.z_index = 9
    var spr := Sprite2D.new()
    spr.texture = load(TENTACLE_TEX_PATH)
    # ориентация: жало торчит ОТ стены в пол
    var toward := Vector2(best - wall_t)
    spr.rotation = Vector2(0, -1).angle_to(Vector2(toward))
    spr.position = Vector2(0, -10)
    spr.modulate = Color(0.85, 0.95, 0.8)
    node.add_child(spr)
    var glow := Sprite2D.new()
    glow.texture = _glow_tex
    glow.material = _glow_mat
    glow.scale = Vector2(1.4, 1.4)
    glow.modulate = Color(0.35, 0.7, 0.4, 0.4)
    node.add_child(glow)
    node.move_child(glow, 0)
    node.scale = Vector2(0.05, 0.05)
    _level_root.add_child(node)
    var warn := Sprite2D.new()
    warn.texture = _glow_tex
    warn.material = _glow_mat
    warn.position = center
    warn.scale = Vector2(0.6, 0.6)
    warn.modulate = Color(0.85, 0.3, 0.12, 0.35)
    warn.z_index = 8
    _fx.add_child(warn)
    var wt := warn.create_tween().set_loops()
    wt.tween_property(warn, "modulate:a", 0.75, 0.2)
    wt.tween_property(warn, "modulate:a", 0.3, 0.2)
    _wall_tentacles.append({"node": node, "pos": center, "born": Time.get_ticks_msec(),
        "slam_in": TENTACLE_TELL + 0.4, "slammed": false, "warn": warn,
        "base_scale": Vector2(1.5, 1.5)})
    if not _tentacle_hint_shown:
        _tentacle_hint_shown = true
        _show_hint(TENTACLE_HINT_FIRST, 4.5)
    else:
        _show_hint(TENTACLE_HINT, 2.0)
    Sfx.play("slam", -10.0)

## Удар щупальца: мокрый звук, тряска, урон в радиусе круга.
func _wall_tentacle_slam(rec: Dictionary) -> void:
    if rec.has("warn") and is_instance_valid(rec["warn"]):
        (rec["warn"] as Sprite2D).queue_free()
    var pos: Vector2 = rec["pos"]
    Sfx.play("slam", -4.0)
    _shake_camera(4.0, 0.3)
    _spawn_ring(pos, Color(0.35, 0.6, 0.4), 2.0)
    for k in range(5):
        var ang := TAU * float(k) / 5.0
        _spell_poof(pos + Vector2(cos(ang), sin(ang)) * 10.0,
            Color(0.3, 0.52, 0.38))
    if Game.hp > 0 and not _player_dead \
            and player.position.distance_to(pos) <= TENTACLE_RADIUS + 6.0:
        Game.damage_hp(TENTACLE_DMG)
        Sfx.play("hurt")
        _flash_player()
        _spawn_hit_impact(player.position + Vector2(0, -14),
            Color(0.5, 0.75, 0.55))
        _spawn_damage_label(player.position + Vector2(0, -40), TENTACLE_DMG)

# ------------------------------------------------ добыча на экране (шаг 19)

## Добыча сундука: иконка + название в центре экрана на пару секунд,
## с цветом качества из Loot.QUALITIES (золото — свой оттенок).
func _show_loot_popup(title: String, icon_path: String, quality: String) -> void:
    if _loot_popup_layer == null:
        _loot_popup_layer = CanvasLayer.new()
        _loot_popup_layer.name = "LootPopup"
        _loot_popup_layer.layer = 24
        add_child(_loot_popup_layer)
        # CenterContainer держит попап ровно в центре экрана ходьбы
        var holder := CenterContainer.new()
        holder.set_anchors_preset(Control.PRESET_FULL_RECT)
        holder.offset_bottom = -UI_BAR_H
        holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
        _loot_popup_layer.add_child(holder)
        _loot_popup_box = VBoxContainer.new()
        _loot_popup_box.add_theme_constant_override("separation", 6)
        _loot_popup_box.alignment = BoxContainer.ALIGNMENT_CENTER
        _loot_popup_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
        holder.add_child(_loot_popup_box)
        _loot_popup_icon = TextureRect.new()
        _loot_popup_icon.custom_minimum_size = Vector2(48, 48)
        _loot_popup_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
        _loot_popup_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
        _loot_popup_icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
        _loot_popup_box.add_child(_loot_popup_icon)
        _loot_popup_label = Label.new()
        _loot_popup_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        _loot_popup_label.add_theme_font_size_override("font_size", 13)
        _loot_popup_label.add_theme_color_override("font_shadow_color",
            Color(0, 0, 0, 0.85))
        _loot_popup_label.add_theme_constant_override("shadow_offset_y", 1)
        _loot_popup_box.add_child(_loot_popup_label)
    var hex := "#9aa0a6"
    for q in Loot.QUALITIES:
        if String((q as Dictionary).get("id", "")) == quality:
            hex = String((q as Dictionary).get("hex", hex))
            break
    if quality == "gold" or title.begins_with("+"):
        hex = "#ffd700"
    var color := Color.from_string(hex, COLOR_GOLD)
    if not icon_path.is_empty() and ResourceLoader.exists(icon_path):
        _loot_popup_icon.texture = load(icon_path)
        _loot_popup_icon.visible = true
    else:
        _loot_popup_icon.texture = null
        _loot_popup_icon.visible = false
    _loot_popup_label.text = title
    _loot_popup_label.add_theme_color_override("font_color", color)
    _loot_popup_box.modulate = Color(1, 1, 1, 1)
    # масштаб-поп вокруг центра: pivot известен только после разметки.
    # Шаг 23: отложенный вызов МЕТОДА узла — Godot сам отменяет
    # call_deferred свободного объекта. Лямбда с захватом пережидала
    # free() сцены в очереди сообщений и сыпала «Lambda capture ...
    # was freed» в консоль.
    call_deferred("_fit_loot_popup_pivot")
    if _loot_popup_tween != null and _loot_popup_tween.is_valid():
        _loot_popup_tween.kill()
    _loot_popup_box.scale = Vector2(0.6, 0.6)
    _loot_popup_tween = create_tween()
    _loot_popup_tween.tween_property(_loot_popup_box, "scale",
        Vector2(1.0, 1.0), 0.18).set_trans(Tween.TRANS_BACK) \
        .set_ease(Tween.EASE_OUT)
    _loot_popup_tween.tween_interval(1.9)
    _loot_popup_tween.tween_property(_loot_popup_box, "modulate:a", 0.0, 0.45)

## Pivot поп-апа добычи — после разметки кадра (шаг 23: метод узла,
## а не лямбда с захватом — см. _show_loot_popup).
func _fit_loot_popup_pivot() -> void:
    if is_instance_valid(_loot_popup_box):
        _loot_popup_box.pivot_offset = _loot_popup_box.size / 2.0

## Всплывающий опыт над убитым врагом: золотое «+N опыта».
func _spawn_xp_label(pos: Vector2, amount: int) -> void:
    var label := Label.new()
    label.text = "+%d опыта" % amount
    label.position = pos + Vector2(-24, 0)
    label.size = Vector2(48, 14)
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.add_theme_font_size_override("font_size", 10)
    label.add_theme_color_override("font_color", Color(1.0, 0.84, 0.2))
    label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
    label.add_theme_constant_override("shadow_offset_y", 1)
    _fx.add_child(label)
    var tw := create_tween()
    tw.set_parallel(true)
    tw.tween_property(label, "position:y", label.position.y - 18.0, 0.8) \
        .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    tw.tween_property(label, "modulate:a", 0.0, 0.8).set_delay(0.25)
    tw.chain().tween_callback(label.queue_free)

# ------------------------------------------------- уровни героя (шаг 19)

## Повышение уровня — красиво: фанфары, золотой взрыв вокруг героя и
## большая надпись «УРОВЕНЬ N!» в центре экрана.
func _on_level_up(new_level: int) -> void:
    Sfx.play("levelup")
    if player != null:
        for i in range(3):
            _spell_poof(player.position + Vector2(0, -8 - i * 9),
                Color(1.0, 0.84, 0.2))
        _spawn_slash_arc(player.position + Vector2(0, -12),
            Color(1.0, 0.84, 0.2))
    if _level_layer == null:
        _level_layer = CanvasLayer.new()
        _level_layer.name = "LevelUp"
        _level_layer.layer = 25
        add_child(_level_layer)
    var center := CenterContainer.new()
    center.set_anchors_preset(Control.PRESET_FULL_RECT)
    center.mouse_filter = Control.MOUSE_FILTER_IGNORE
    center.offset_bottom = -UI_BAR_H
    _level_layer.add_child(center)
    var label := Label.new()
    label.text = "УРОВЕНЬ %d!" % new_level
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.add_theme_font_size_override("font_size", 30)
    label.add_theme_color_override("font_color", Color(1.0, 0.84, 0.2))
    label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
    label.add_theme_constant_override("shadow_offset_y", 2)
    label.modulate.a = 0.0
    center.add_child(label)
    var tw := create_tween()
    tw.tween_property(label, "modulate:a", 1.0, 0.2)
    tw.tween_interval(1.4)
    tw.tween_property(label, "modulate:a", 0.0, 0.5)
    tw.tween_callback(func() -> void: center.queue_free())
    _show_hint("Уровень %d: урон и ХП выросли на 35%%!" % new_level, 3.0)

## Полоса опыта в HUD — по сигналу Game.xp_changed.
func _on_xp_changed(xp_value: int, xp_need: int) -> void:
    if _hud_xp != null and is_instance_valid(_hud_xp):
        _hud_xp.max_value = xp_need
        _hud_xp.value = xp_value

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
    # мягкий свет вокруг героя (шаг 15): тьма этажа + факелы + герой
    var light := Sprite2D.new()
    light.texture = _glow_tex
    light.material = _glow_mat
    light.scale = Vector2(4.6, 4.6)
    light.modulate = PLAYER_LIGHT_COLOR
    light.position = Vector2(0, -8)
    player.add_child(light)
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
    var blocked := _dialogue.visible or _inventory_ui.visible or _player_dead \
        or not _leap_flight.is_empty()
    if not blocked:
        dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
        var joy_vec := _joystick_output()
        if joy_vec.length() > 0.15:
            dir = (dir + joy_vec).limit_length(1.0)
        moving = dir.length() > 0.05
        # шаг 18: щит воина замедляет шаг; шаг 20: Shift — бег
        # (бег не отменяет штраф щита: под щитом бегать нельзя)
        var move_speed := SPEED
        if Game.guard_active:
            move_speed *= float(Game.ability_info("special").get("speed_mult", 0.5))
        elif Input.is_action_pressed("run"):
            move_speed *= RUN_MULT
        player.velocity = dir * move_speed
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
    if _q_cd > 0.0:
        _q_cd = maxf(0.0, _q_cd - delta)
    if _special_cd > 0.0:
        _special_cd = maxf(0.0, _special_cd - delta)
    if _t_cd > 0.0:
        _t_cd = maxf(0.0, _t_cd - delta)
    _update_special_hold(delta)
    _update_sword_rain(delta)
    _update_leap_flight(delta)
    _update_camera_shake(delta)
    _update_bolts(delta)
    _update_foe_bolts(delta)
    _update_gas(delta)
    _update_titan(delta)
    _update_walk_anim(delta, moving, dir)
    _update_foes(delta)
    _update_wall_tentacles(delta)
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

func _on_walk_click(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed \
            and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
        _try_click_strike((event as InputEventMouseButton).position)

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

## Под точкой клика — лестница, сундук или интерактивный реквизит?
## (враги и щупальца не «интерактивны»: по ним бьют; щупальца не бьются)
func _point_on_interactive(pos: Vector2) -> bool:
    for store in [_stairs_up, _stairs_down, _stairs_exit]:
        if (store as Dictionary).is_empty():
            continue
        var spos: Vector2 = (store as Dictionary)["pos"]
        if absf(pos.x - spos.x) <= 12.0 and absf(pos.y - spos.y) <= 12.0:
            return true
    for chest in _chests:
        var cpos: Vector2 = chest["pos"]
        if absf(pos.x - cpos.x) <= 10.0 and absf(pos.y - cpos.y) <= 10.0:
            return true
    for rec in _interactives:
        if bool(rec.get("used", false)):
            continue
        var rpos: Vector2 = rec["pos"]
        if absf(pos.x - rpos.x) <= 10.0 and absf(pos.y - rpos.y) <= 10.0:
            return true
    return false

func _unhandled_input(event: InputEvent) -> void:
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
        if event is InputEventMouseButton and _walk_holder != null \
                and (_walk_holder.get_global_rect() as Rect2) \
                    .has_point((event as InputEventMouseButton).position):
            return
        _strike()
        return
    if event.is_action_pressed("cast_spell") and not _dialogue.visible \
            and not _inventory_ui.visible:
        _on_q_pressed()
        return
    if event.is_action_pressed("special") and not event.is_echo() \
            and not _dialogue.visible and not _inventory_ui.visible:
        _on_special_pressed()
        return
    if event.is_action_released("special"):
        _on_special_released()
        return
    if event.is_action_pressed("special2") and not _dialogue.visible \
            and not _inventory_ui.visible:
        _on_t_pressed()
        return
    if event.is_action_pressed("interact") and not _dialogue.visible \
            and not _inventory_ui.visible \
            and player != null \
            and Time.get_ticks_msec() - _dialogue_closed_at > 250:
        _use_nearest_stairs()

## Ближайшая интерактивность в радиусе 26 px (E): лестницы, закрытые
## сундуки и живой интерактивный реквизит (шаг 24, п.6).
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
    var prop: Dictionary = {}
    for rec in _interactives:
        if bool(rec.get("used", false)):
            continue
        var d: float = player.position.distance_to(rec["pos"])
        if d < best:
            best = d
            method = "_use_interactive"
            prop = rec
    if method.is_empty():
        return
    if method == "_open_chest":
        _open_chest(chest)
    elif method == "_use_interactive":
        _use_interactive(prop)
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
    Sfx.play("bolt")
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
    # шаг 19: снаряды светятся и оставляют тающий след
    var glow := Sprite2D.new()
    glow.texture = _glow_tex
    glow.material = _glow_mat
    glow.scale = Vector2(1.1, 1.1)
    glow.modulate = Color(float(col[0]), float(col[1]), float(col[2]), 0.7)
    bolt.add_child(glow)
    _fx.add_child(bolt)
    _bolts.append({"node": bolt, "dir": dir.normalized(),
        "left": float(info["range_px"]), "speed": float(info["speed"]),
        "damage": int(info["damage"]), "color": bolt.modulate, "trail": 0.0})

func _update_bolts(delta: float) -> void:
    if _bolts.is_empty():
        return
    for i in range(_bolts.size() - 1, -1, -1):
        var b: Dictionary = _bolts[i]
        var node: Sprite2D = b["node"]
        var step: Vector2 = (b["dir"] as Vector2) * float(b["speed"]) * delta
        node.position += step
        if bool(b.get("spin", false)):
            node.rotation += 10.0 * delta   # метательный топор крутится (шаг 18)
        b["left"] = float(b["left"]) - step.length()
        # шаг 19: след из тающих искр за снарядом (и за топором)
        b["trail"] = float(b.get("trail", 0.0)) + delta
        if float(b["trail"]) >= 0.05:
            b["trail"] = 0.0
            _spawn_trail_dot(node.position, b.get("color",
                Color(0.55, 0.85, 0.95)))
        var target := _foe_at_point(node.position)
        if not target.is_empty():
            _spawn_hit_impact(node.position, b.get("color",
                Color(0.55, 0.85, 0.95)))
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
        if bool(foe.get("thrown", false)):
            continue   # варвар кинул врага — им управляет полёт (шаг 18)
        var def: Dictionary = foe["def"]
        var node: Node2D = foe["node"]
        var spr: AnimatedSprite2D = foe["sprite"]
        var now_ms := Time.get_ticks_msec()
        if int(foe.get("stun_until", 0)) > now_ms:
            spr.play("idle_down")
            continue   # оглушён броском варвара (шаг 18)
        if int(foe.get("blind_until", 0)) > now_ms:
            foe["aggro"] = false
            spr.play("idle_down")
            continue   # ослеплён пылью бомжа: не видит и не бьёт (шаг 18)
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
        if String(foe.get("id", "")) == "boss_cthulhu":
            _update_cthulhu(foe, def, delta)   # шаг 21: тактика Ктулху
        elif String(foe.get("id", "")) == "boss_shub":
            _update_shub(foe, def, delta)      # шаг 24: тактика Шуб-Ниггурат
        var to := player.position - node.position
        var dist := to.length()
        if not bool(foe["aggro"]):
            if dist < float(def["aggro"]) and Game.hp > 0 and not _player_dead:
                foe["aggro"] = true
                _show_hint(String(AGGRO_HINT) % String(foe.get("title",
                    def.get("name", "Враг"))), 2.2)
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
                _spawn_foe_bolt(foe, def)
        else:
            # ближний бой: догнать и бить
            if dist > float(def["attack_range"]) * 0.8:
                _move_foe(node, to.normalized(),
                    float(foe.get("speed_override", float(def["speed"]))), delta)
                _foe_anim(spr, to)
            else:
                spr.play("idle_down")
            if dist <= float(def["attack_range"]) and float(foe["atk_cd"]) <= 0.0:
                foe["atk_cd"] = float(foe.get("attack_cd_override",
                    def.get("attack_cd", 1.1)))
                _foe_attack(foe)

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
## Урон берётся из записи врага: у элиты он усилен (шаг 15).
func _foe_attack(foe: Dictionary) -> void:
    var damage := maxi(1, int(foe.get("dmg", 1)))
    Game.damage_hp(damage)
    Sfx.play("hurt")
    _spawn_swing(player.position + Vector2(0, -10), Color(0.9, 0.3, 0.25))
    _spawn_damage_label(player.position + Vector2(0, -40), damage)
    _spell_poof(player.position + Vector2(0, -14), Color(0.85, 0.3, 0.25))
    _spawn_hit_impact(player.position + Vector2(0, -14), Color(0.9, 0.35, 0.3))
    _flash_player()

## Болт колдуна: летит в героя, гаснет у стен. Урон — из записи врага.
## Шаг 21: spread_deg — угол веера (для залпов безумия Ктулху),
## color_override — чужой цвет болта (a > 0 — использовать его).
func _spawn_foe_bolt(foe: Dictionary, def: Dictionary,
        spread_deg: float = 0.0, color_override: Color = Color(0, 0, 0, 0)) -> void:
    var col: Array = def.get("bolt_color", [0.6, 0.8, 0.7])
    if color_override.a > 0.0:
        col = [color_override.r, color_override.g, color_override.b]
    var bolt := Sprite2D.new()
    bolt.texture = _bolt_tex
    bolt.modulate = Color(float(col[0]), float(col[1]), float(col[2]))
    bolt.scale = Vector2(0.9, 0.9)
    var from: Node2D = foe["node"]
    bolt.position = from.position + Vector2(0, -14)
    # шаг 19: болты колдунов тоже светятся
    var glow := Sprite2D.new()
    glow.texture = _glow_tex
    glow.material = _glow_mat
    glow.scale = Vector2(1.0, 1.0)
    glow.modulate = Color(float(col[0]), float(col[1]), float(col[2]), 0.65)
    bolt.add_child(glow)
    _fx.add_child(bolt)
    Sfx.play("bolt", -6.0)
    var dir := (player.position + Vector2(0, -14) - bolt.position).normalized()
    if dir == Vector2.ZERO:
        dir = Vector2(0, 1)   # совпадение точек: болт падает вниз, а не висит
    if spread_deg != 0.0:
        dir = dir.rotated(deg_to_rad(spread_deg))
    _foe_bolts.append({"node": bolt, "dir": dir,
        "left": float(def.get("bolt_range_px", 190.0)),
        "speed": float(def.get("bolt_speed", 130.0)),
        "damage": maxi(1, int(foe.get("dmg", 1))),
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
            Sfx.play("hurt")
            _spawn_hit_impact(node.position, Color(0.8, 0.85, 0.8))
            _spawn_damage_label(player.position + Vector2(0, -40), int(b["damage"]))
            _flash_player()
            continue
        var faded := float(b["left"]) <= 0.0
        if faded or _tile_is_solid(node.position):
            _spell_poof(node.position, b.get("color", Color(0.7, 0.8, 0.7)))
            node.queue_free()
            _foe_bolts.remove_at(i)

# ------------------------------------------ способности героев (шаг 18)

## Нажатие Q (действие cast_spell): у мага — магия (шаги 6/12), у остальных
## героев — свой приём из Game.ABILITIES с кулдауном.
func _on_q_pressed() -> void:
    if player == null or _player_dead:
        return
    if _dialogue.visible or _inventory_ui.visible:
        return
    var info := Game.ability_info("q")
    if info.is_empty():
        return
    match String(info["kind"]):
        "spell":
            if _barrier_blocks_cast():
                return
            _cast_spell()
        "whirl":
            if _barrier_blocks_cast() or _q_cd > 0.0:
                if _q_cd > 0.0:
                    _show_hint("Вихрь ещё не готов (%.0f с)" % _q_cd, 1.2)
                return
            _q_cd = float(info["cd"])
            _do_whirl(info)
        "axe":
            if _barrier_blocks_cast() or _q_cd > 0.0:
                if _q_cd > 0.0:
                    _show_hint("Топор ещё не готов (%.0f с)" % _q_cd, 1.2)
                return
            _q_cd = float(info["cd"])
            _throw_axe(info)
        "dust":
            if _barrier_blocks_cast() or _q_cd > 0.0:
                if _q_cd > 0.0:
                    _show_hint("Пыль ещё не готова (%.0f с)" % _q_cd, 1.2)
                return
            _q_cd = float(info["cd"])
            _throw_dust(info)
        _:
            pass

## Пока барьер мага держится, другие приёмы недоступны.
func _barrier_blocks_cast() -> bool:
    if Game.hero_immune and not Game.guard_active:
        _show_hint("Барьер поглощает всё внимание", 1.6)
        return true
    return false

## Вихрь клинка воина: урон оружием всем живым врагам вокруг героя.
func _do_whirl(info: Dictionary) -> void:
    var dmg := Game.strike_damage()
    var radius := float(info["radius"])
    var color := Game.strike_swing_color()
    for i in range(8):
        var ang := TAU * float(i) / 8.0
        _spawn_swing(player.position + Vector2(cos(ang), sin(ang)) * 16.0 + Vector2(0, -10), color)
    _spell_poof(player.position + Vector2(0, -10), color)
    # шаг 19: вихрь — с дугой и звуком; шаг 20: ударное кольцо и тряска
    _spawn_slash_arc(player.position + Vector2(0, -10), color)
    _spawn_ring(player.position + Vector2(0, -10), color, 2.2)
    _shake_camera(3.0, 0.25)
    Sfx.play("swing", 2.0)
    var hits := 0
    for foe in _foes:
        if bool(foe.get("dead", false)) or bool(foe.get("thrown", false)):
            continue
        var node: Node2D = foe["node"]
        if node.position.distance_to(player.position) > radius:
            continue
        _hit_foe(foe, dmg)
        hits += 1
    if hits == 0:
        _show_hint("Вихрь рассёк воздух", 1.2)

## Метательный топор варвара: летит вперёд, крутится, первый враг на пути
## получает урон из Game.ABILITIES (100 — задано автором шага 18).
func _throw_axe(info: Dictionary) -> void:
    if _ability_axe_tex == null:
        _ability_axe_tex = load(AXE_TEX_PATH)
    var axe := Sprite2D.new()
    axe.texture = _ability_axe_tex
    axe.position = player.position + Vector2(0, -14)
    axe.z_index = 10
    # шаг 19: топор несётся со свечением и свистом
    var axe_glow := Sprite2D.new()
    axe_glow.texture = _glow_tex
    axe_glow.material = _glow_mat
    axe_glow.scale = Vector2(1.3, 1.3)   # шаг 20: топор видно и злее
    axe_glow.modulate = Color(0.85, 0.9, 1.0, 0.75)
    axe.add_child(axe_glow)
    _fx.add_child(axe)
    Sfx.play("throw")
    _bolts.append({"node": axe, "dir": _facing_vector().normalized(),
        "left": float(info["range_px"]), "speed": float(info["speed"]),
        "damage": maxi(1, int(round(float(info["damage"])
            * Game.titan_damage_mult()))),
        "color": Color(0.85, 0.9, 1.0), "spin": true})

## Горсть пыли бомжа: все враги вокруг (radius) слепнут на blind_sec —
## не видят и не атакуют героя, агрессия сбрасывается. Босс тоже слепнет.
func _throw_dust(info: Dictionary) -> void:
    var radius := float(info["radius"])
    var blind_ms := int(round(float(info["blind_sec"]) * 1000.0))
    var now_ms := Time.get_ticks_msec()
    _spell_poof(player.position + Vector2(0, -12), Color(0.76, 0.62, 0.42))
    _spell_poof(player.position + Vector2(0, -24), Color(0.62, 0.5, 0.34))
    _spawn_ring(player.position + Vector2(0, -12), Color(0.78, 0.64, 0.44), 3.4)
    Sfx.play("dust")
    var hits := 0
    for foe in _foes:
        if bool(foe.get("dead", false)) or bool(foe.get("thrown", false)):
            continue
        var node: Node2D = foe["node"]
        if node.position.distance_to(player.position) > radius:
            continue
        foe["blind_until"] = now_ms + blind_ms
        foe["aggro"] = false
        _spell_poof(node.position + Vector2(0, -18), Color(0.7, 0.58, 0.4))
        hits += 1
    _show_hint(DUST_HINT if hits > 0 else "Пыль осела — рядом никого", 1.6)

## Гнилой газ бомжа: облако там, где герой его выпустил. Все враги в
## радиусе (48 px = 3 клетки) получают tick_damage: первый тик сразу,
## всего ticks тиков раз в tick_interval секунд. Задано автором шага 18.
func _cast_gas(info: Dictionary) -> void:
    var cloud := CPUParticles2D.new()
    cloud.amount = 26
    cloud.lifetime = 1.1
    cloud.position = player.position + Vector2(0, -10)
    cloud.direction = Vector2(0, -1)
    cloud.spread = 180.0
    cloud.initial_velocity_min = 8.0
    cloud.initial_velocity_max = 22.0
    cloud.scale_amount_min = 2.0
    cloud.scale_amount_max = 4.5
    cloud.color = Color(0.45, 0.72, 0.35, 0.55)
    cloud.emitting = true
    _fx.add_child(cloud)
    # шаг 20: тающее зелёное свечение — газ видно, пока он жив
    var haze := Sprite2D.new()
    haze.texture = _glow_tex
    haze.material = _glow_mat
    haze.scale = Vector2(2.4, 2.4)
    haze.modulate = Color(0.45, 0.72, 0.35, 0.4)
    haze.position = cloud.position
    _fx.add_child(haze)
    var haze_tw := create_tween()
    haze_tw.tween_property(haze, "modulate:a", 0.0, 3.4)
    haze_tw.tween_callback(haze.queue_free)
    Sfx.play("gas")
    _gas_clouds.append({"pos": cloud.position, "ticks_left": int(info["ticks"]),
        "tick_accum": 0.0, "interval": float(info["tick_interval"]),
        "radius": float(info["radius"]), "damage": int(info["tick_damage"]),
        "node": cloud})
    _tick_gas_clouds()
    _show_hint(GAS_HINT, 1.6)

## Один тик всех живых облаков газа.
func _tick_gas_clouds() -> void:
    for cloud in _gas_clouds:
        if int(cloud["ticks_left"]) <= 0:
            continue
        cloud["ticks_left"] = int(cloud["ticks_left"]) - 1
        for foe in _foes:
            if bool(foe.get("dead", false)) or bool(foe.get("thrown", false)):
                continue
            var node: Node2D = foe["node"]
            if node.position.distance_to(cloud["pos"]) > float(cloud["radius"]):
                continue
            # газ не отбрасывает: иначе облако выталкивало бы врагов
            # из своего же радиуса между тиками
            _hit_foe(foe, int(cloud["damage"]), false)

## Жизнь облаков: тики по интервалу, гашение после последнего тика.
func _update_gas(delta: float) -> void:
    if _gas_clouds.is_empty():
        return
    for i in range(_gas_clouds.size() - 1, -1, -1):
        var cloud: Dictionary = _gas_clouds[i]
        if int(cloud["ticks_left"]) > 0:
            cloud["tick_accum"] = float(cloud["tick_accum"]) + delta
            if float(cloud["tick_accum"]) >= float(cloud["interval"]):
                cloud["tick_accum"] = 0.0
                _tick_gas_clouds()
        if int(cloud["ticks_left"]) <= 0:
            var node: CPUParticles2D = cloud["node"]
            node.emitting = false
            var tw := create_tween()   # шаг 23: твин умирает вместе со сценой
            tw.tween_interval(1.2)
            tw.tween_callback(func() -> void:
                if is_instance_valid(node):
                    node.queue_free())
            _gas_clouds.remove_at(i)

## Пробел (действие special): у мага барьер, у воина щит, у бомжа газ,
## у варвара бросок. Удержания живут, пока клавиша зажата (или пока не
## кончатся max_hold/мана); кнопка HUD держит приём до max_hold сама.
func _on_special_pressed() -> void:
    if player == null or _player_dead:
        return
    if _dialogue.visible or _inventory_ui.visible:
        return
    var info := Game.ability_info("special")
    if info.is_empty():
        return
    match String(info["kind"]):
        "hold_barrier":
            if _special_held:
                return
            if Game.mana <= 0:
                _show_hint("Мана на барьер уже иссякла", 1.6)
                return
            _start_hold(info)
            Game.hero_immune = true
            _spawn_hold_visual(Color(0.58, 0.42, 0.95, 0.55), 4.6)
            Sfx.play("barrier")
            _show_hint("Барьер: неуязвим, но бить нельзя", 1.8)
        "hold_shield":
            if _special_held:
                return
            if _special_cd > 0.0:
                _show_hint("Щит ещё не готов (%.0f с)" % _special_cd, 1.5)
                return
            _start_hold(info)
            Game.hero_immune = true
            Game.guard_active = true
            _spawn_hold_visual(Color(0.62, 0.74, 0.95, 0.5), 3.4)
            Sfx.play("shield")
            _show_hint("Щит поднят: урон не проходит, но ты медленнее и слабее", 2.0)
        "gas":
            if _special_cd > 0.0:
                _show_hint("Газ ещё не готов (%.0f с)" % _special_cd, 1.5)
                return
            _special_cd = float(info["cd"])
            _cast_gas(info)
        "death_leap":
            # шаг 22: прыжок переехал с T на пробел (у варвара)
            if _special_cd > 0.0:
                _show_hint("Прыжок ещё не готов (%.0f с)" % _special_cd, 1.5)
                return
            if not _try_death_leap(info):
                return   # фальстарт: кулдаун не тратится
            _special_cd = float(info["cd"])
        _:
            pass

func _on_special_released() -> void:
    if _special_held:
        _end_hold("")

func _start_hold(info: Dictionary) -> void:
    _special_held = true
    _special_hold_left = float(info["max_hold"])
    _special_drain_accum = 0.0

## Завершить удержание: снять неуязвимость, потушить визуал, у щита —
## запустить кулдаун.
func _end_hold(end_hint: String) -> void:
    var was_shield := Game.guard_active
    _special_held = false
    _special_hold_left = 0.0
    _special_drain_accum = 0.0
    Game.hero_immune = false
    Game.guard_active = false
    _clear_hold_visual()
    if was_shield:
        _special_cd = float(Game.ability_info("special").get("cd", 10.0))
        _show_hint("Щит опущен", 1.4)
    elif not end_hint.is_empty():
        _show_hint(end_hint, 1.6)

## Тик удержания: время, расход маны барьера, смерть героя.
func _update_special_hold(delta: float) -> void:
    if not _special_held:
        return
    if player == null or Game.hp <= 0 or _player_dead:
        _end_hold("")
        return
    var info := Game.ability_info("special")
    _special_hold_left -= delta
    if String(info["kind"]) == "hold_barrier":
        _special_drain_accum += delta * float(info["mana_per_sec"])
        var whole := int(_special_drain_accum)
        if whole > 0:
            _special_drain_accum -= float(whole)
            if Game.mana >= whole:
                Game.spend_mana(whole)
            else:
                if Game.mana > 0:
                    Game.spend_mana(Game.mana)
                _end_hold("Мана иссякла — барьер угас")
                return
    if _special_hold_left <= 0.0:
        _end_hold("")

## Круг барьера/щита: мягкое свечение glow.png вокруг героя.
func _spawn_hold_visual(color: Color, scale_f: float) -> void:
    _clear_hold_visual()
    var glow := Sprite2D.new()
    glow.texture = load("res://assets/sprites/props/glow.png")
    var mat := CanvasItemMaterial.new()
    mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
    glow.material = mat
    glow.scale = Vector2(scale_f, scale_f)
    glow.modulate = color
    glow.position = Vector2(0, -10)
    glow.z_index = 6
    player.add_child(glow)
    # шаг 20: барьер/щит пульсируют, пока держатся
    var pulse := glow.create_tween().set_loops()
    pulse.tween_property(glow, "scale",
        Vector2(scale_f * 1.12, scale_f * 1.12), 0.5) \
        .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    pulse.tween_property(glow, "scale", Vector2(scale_f, scale_f), 0.5) \
        .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    _hold_visual = glow

func _clear_hold_visual() -> void:
    if _hold_visual != null and is_instance_valid(_hold_visual):
        _hold_visual.queue_free()
    _hold_visual = null

## Гнев титана варвара (шаг 22): форма на 4 секунды — герой вырастает,
## урон по нему не проходит (Game.damage_hp), а удары и приёмы бьют
## в 4 раза сильнее (Game.strike_damage и множитель в топоре). Рёв,
## тряска камеры и красное кольцо по активации; гаснет само по таймеру.
func _do_titan_rage(info: Dictionary) -> void:
    Game.start_titan_rage(float(info["duration"]), float(info["damage_mult"]))
    var scale_to := float(info.get("scale", 1.55))
    Sfx.play("roar")
    _shake_camera(4.0, 0.4)
    _spawn_ring(player.position + Vector2(0, -8), Color(0.85, 0.25, 0.2), 2.8)
    _spawn_hit_impact(player.position + Vector2(0, -12),
        Color(1.0, 0.45, 0.3))
    _show_hint(TITAN_HINT, float(info["duration"]) * 0.6)
    if not _titan_big:
        _titan_big = true
        _titan_base_scale = _player_sprite.scale
        var tw := create_tween()
        tw.tween_property(_player_sprite, "scale",
            _titan_base_scale * scale_to, 0.25) \
            .set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

## Синхронизация формы титана со состоянием Game: растёт по активации
## (в том числе если сцена сменилась в середине формы), гаснет по таймеру.
func _update_titan(delta: float) -> void:
    if Game.titan_active() and not _titan_big:
        _titan_big = true
        _titan_base_scale = _player_sprite.scale
        var tw := create_tween()
        tw.tween_property(_player_sprite, "scale",
            _titan_base_scale * float(Game.ability_info("t").get("scale", 1.55)),
            0.25)
        return
    if not Game.titan_active() and _titan_big:
        _titan_big = false
        var tw := create_tween()
        tw.tween_property(_player_sprite, "scale", _titan_base_scale, 0.25)
        _show_hint(TITAN_FADED_HINT, 1.4)

# --------------------------------------------- третий приём T (шаг 20)

## T (действие "special2"): третий приём каждого класса.
## Маг — «Выплеск магии»: тратит ВСЮ ману, наносит 20 × уровень ВСЕМ
## противникам на карте (боссам тоже, так задано автором). Бомж —
## «Передышка»: полностью восстанавливает ХП. Рыцарь — «Град
## мечей»: мечи падают вокруг героя, каждое попадание наносит урон
## актуального удара. Шаг 22: у варвара на T — «Гнев титана» (прыжок
## переехал на пробел): 4 секунды герой огромен, урон не проходит,
## бьёт в 4 раза сильнее. Кулдауны — в Game.ABILITIES, слот "t".
func _on_t_pressed() -> void:
    if player == null or _player_dead:
        return
    if _dialogue.visible or _inventory_ui.visible:
        return
    var info := Game.ability_info("t")
    if info.is_empty():
        return
    if _t_cd > 0.0:
        _show_hint("%s ещё не готов (%.0f с)" % [String(info["title"]), _t_cd], 1.5)
        return
    match String(info["kind"]):
        "mana_burst":
            if _barrier_blocks_cast():
                return
            if Game.mana <= 0:
                _show_hint("Мана иссякла — выплеску нечем разгореться", 1.8)
                return
            _t_cd = float(info["cd"])
            _do_mana_burst(info)
        "second_wind":
            _t_cd = float(info["cd"])
            _do_second_wind()
        "titan_rage":
            if _barrier_blocks_cast():
                return
            _t_cd = float(info["cd"])
            _do_titan_rage(info)
        "sword_rain":
            if _barrier_blocks_cast():
                return
            _t_cd = float(info["cd"])
            _do_sword_rain(info)
        _:
            pass

## Выплеск магии: вся мана — в волну, бьющую всех врагов этажа
## (20 урона × уровень героя; урон линейный — не растёт с hero_level_mult).
func _do_mana_burst(info: Dictionary) -> void:
    var spent := Game.mana
    Game.spend_mana(Game.mana)
    var damage := int(info["damage_per_level"]) * Game.level
    var color := Color(0.62, 0.42, 0.95)
    _spawn_ring(player.position + Vector2(0, -10), color, 2.0)
    _spawn_ring(player.position + Vector2(0, -10), Color(0.8, 0.65, 1.0), 3.6)
    _shake_camera(4.0, 0.4)
    Sfx.play("surge")
    var hits := 0
    for foe in _foes:
        if bool(foe.get("dead", false)) or bool(foe.get("thrown", false)):
            continue
        var node: Node2D = foe["node"]
        _spell_poof(node.position + Vector2(0, -14), color)
        _spawn_hit_impact(node.position + Vector2(0, -14), color)
        _hit_foe(foe, damage)
        hits += 1
    _show_hint("Выплеск магии: -%d маны, волна на %d урона (%d цели)"
        % [spent, damage, hits], 2.4)

## Передышка бомжа: полное лечение (кулдаун минута — задал автор).
func _do_second_wind() -> void:
    var healed := Game.heal_hp(Game.max_hp())
    _spawn_ring(player.position + Vector2(0, -10), Color(0.45, 0.85, 0.45), 2.6)
    for i in range(3):
        _spell_poof(player.position + Vector2(-10 + i * 10, -14 - i * 8),
            Color(0.55, 0.9, 0.5))
    Sfx.play("heal")
    _show_hint("Передышка: восстановлено %d хп" % healed, 2.2)

## Смертельный прыжок варвара: цель — ближайший живой враг в leap_range.
## Не-босс умирает с одного удара; боссу (и в мире — демону) 200 урона
## плюс урон актуального удара. Полёт — дугой, приземление — с тряской.
func _try_death_leap(info: Dictionary) -> bool:
    var target: Dictionary = {}
    var best := float(info["leap_range"])
    for foe in _foes:
        if bool(foe.get("dead", false)) or bool(foe.get("thrown", false)):
            continue
        var d: float = (foe["node"] as Node2D).position.distance_to(player.position)
        if d < best:
            best = d
            target = foe
    if target.is_empty():
        _show_hint("Рядом некого топтать: прыжок не сработал", 1.8)
        return false
    var boss := bool(target.get("boss", false))
    target["thrown"] = true   # цель не двигается под прыжком
    _leap_flight = {"foe": target, "t": 0.0, "from": player.position,
        "to": (target["node"] as Node2D).position + Vector2(0, 6),
        "boss": boss, "boss_damage": int(info["boss_damage"])}
    Sfx.play("leap")
    return true

## Полёт прыжка: дуга над землёй; приземление — удар и тряска.
func _update_leap_flight(delta: float) -> void:
    if _leap_flight.is_empty() or player == null:
        return
    var rec: Dictionary = _leap_flight
    rec["t"] = minf(1.0, float(rec["t"]) + delta / 0.38)
    var t := float(rec["t"])
    var to: Vector2 = rec["to"]
    player.position = (rec["from"] as Vector2).lerp(to, t) \
        + Vector2(0, -sin(t * PI) * 26.0)
    if t >= 1.0:
        var foe: Dictionary = rec["foe"]
        var boss := bool(rec["boss"])
        var damage := 0
        if boss:
            damage = int(rec["boss_damage"]) + Game.strike_damage()
        else:
            damage = maxi(1, int(foe["hp"]))   # убийство с одного прыжка
        _shake_camera(5.0, 0.35)
        _spell_poof(player.position + Vector2(0, -8), Color(0.85, 0.75, 0.5))
        _spawn_hit_impact(player.position + Vector2(0, -12),
            Color(1.0, 0.9, 0.6))
        foe["thrown"] = false
        _leap_flight = {}
        if not bool(foe.get("dead", false)):
            _hit_foe(foe, damage)
        if boss:
            _show_hint("Прыжок тряхнул босса: %d урона" % damage, 1.8)
        else:
            _show_hint("Смертельный прыжок: противник раздавлен", 1.8)

## Град мечей рыцаря: swords клинков падают в радиусе вокруг героя,
## каждое попадание наносит урон актуального удара (Game.strike_damage).
func _do_sword_rain(info: Dictionary) -> void:
    var radius := float(info["radius"])
    var count := int(info["swords"])
    var damage := Game.strike_damage()
    var color := Game.strike_swing_color()
    Sfx.play("rain")
    _show_hint("Град мечей: %d клинков на %d урона" % [count, damage], 2.2)
    var tex: Texture2D = load("res://assets/sprites/icons/sword.png")
    for i in range(count):
        var ang := TAU * float(i) / float(count) + randf_range(-0.2, 0.2)
        var r := radius * sqrt(randf_range(0.35, 1.0))
        var target := player.position + Vector2(cos(ang) * r, sin(ang) * r * 0.7)
        if _tile_is_solid(target):
            target = player.position
        var sword := Sprite2D.new()
        sword.texture = tex
        sword.position = target + Vector2(0, -46)
        sword.rotation = PI * 0.75
        sword.scale = Vector2(1.5, 1.5)
        sword.z_index = 11
        sword.modulate = Color(color.r, color.g, color.b, 0.0)
        _fx.add_child(sword)
        _sword_rain.append({"node": sword, "target": target,
            "delay": 0.06 * i, "fall": 0.0, "damage": damage,
            "hit_radius": float(info["hit_radius"])})

## Падение мечей: задержка, полёт, удар по врагам в точке падения.
func _update_sword_rain(delta: float) -> void:
    if _sword_rain.is_empty():
        return
    for i in range(_sword_rain.size() - 1, -1, -1):
        var rec: Dictionary = _sword_rain[i]
        var node: Sprite2D = rec["node"]
        if float(rec["delay"]) > 0.0:
            rec["delay"] = float(rec["delay"]) - delta
            continue
        node.modulate.a = minf(1.0, node.modulate.a + delta * 8.0)
        rec["fall"] = minf(1.0, float(rec["fall"]) + delta / 0.22)
        var target: Vector2 = rec["target"]
        node.position = target + Vector2(0, -46.0 * (1.0 - float(rec["fall"])))
        if float(rec["fall"]) >= 1.0:
            _spawn_hit_impact(target + Vector2(0, -10), Color(0.9, 0.92, 1.0))
            _spawn_swing(target + Vector2(0, -10), Color(0.85, 0.9, 1.0))
            for foe in _foes:
                if bool(foe.get("dead", false)) or bool(foe.get("thrown", false)):
                    continue
                var fnode: Node2D = foe["node"]
                if fnode.position.distance_to(target) <= float(rec["hit_radius"]):
                    _hit_foe(foe, int(rec["damage"]))
            node.queue_free()
            _sword_rain.remove_at(i)

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
    var def: Dictionary = DungeonBestiary.boss_for(_dungeon_id)
    # демон данжа 1 узнаёт героя, если видели его у края мира (шаг 13);
    # босс данжа 2 с героем не говорил — Пустота лишь шептала (шаг 16)
    var seen: bool = bool(def.get("knows_hero", false)) and Game.demon_seen
    var lines: Array = def.get("lines_seen", []) if seen \
        else def.get("lines_new", [])
    if lines.is_empty():
        lines = def.get("lines_new", [])
    _dialogue.open({
        "name": String(def.get("name", "Хозяин подземелья")),
        "role": String(def.get("role_seen", "")) if seen \
            else String(def.get("role_new", "")),
        "portrait": String(def.get("portrait", "")),
        "lines": lines,
    })

func _on_dialogue_closed() -> void:
    _dialogue_closed_at = Time.get_ticks_msec()
    # босс закончил говорить — начинается битва
    var boss := _boss_record()
    if not boss.is_empty() and _boss_dialog_done and not _boss_hostile:
        _boss_hostile = true
        _show_hint(String(DungeonBestiary.dungeon_meta(_dungeon_id)
            .get("boss_hostile_hint", "")), 3.5)
        # шаг 21: пробуждение Ктулху — рёв на весь этаж
        if String(boss["id"]) == "boss_cthulhu":
            Sfx.play("roar")
            _shake_camera(6.0, 0.8)
            _spawn_ring((boss["node"] as Node2D).position + Vector2(0, -30),
                Color(0.45, 0.8, 0.6), 3.0)

# ------------------------------------ Ктулху (шаг 21): УСТРАШЕНИЕ

## Параметры «страшного» Ктулху (баланс шага 24, утверждено в шаге 25).
const CTHULHU_SLAM_CD := 7.0        # период удара щупалец (с)
const CTHULHU_SLAM_TELL := 0.85     # секунд между предупреждением и ударом
const CTHULHU_SLAM_RADIUS := 34.0   # радиус удара щупалец (px)
const CTHULHU_SLAM_DMG := 30        # урон удара щупалец
const CTHULHU_VOLLEY_CD := 4.5      # период веера болтов безумия (с)
const CTHULHU_VOLLEY_N := 5         # болтов в веере
const CTHULHU_VOLLEY_SPREAD := 24.0  # полуширина веера (градусы)
const CTHULHU_WHISPER_CD := 11.0    # период шёпотов Р'льеха (с)
const CTHULHU_PHASE2_HP := 0.45     # доля ХП для фазы 2 («небо гаснет»)
const CTHULHU_PHASE2_CD := 0.85     # кулдаун когтей в фазе 2 (с)
const CTHULHU_PHASE2_SPEED := 62.0  # скорость в фазе 2 (px/с, всё ещё < 95)
const CTHULHU_SUMMON_HP := [0.7, 0.35]  # пороги ХП призыва отродий

## Ужас вокруг босса: пульсирующие угли-глаза, тёмная аура у ног,
## медленное «дыхание» тела. Вызывается один раз при спавне.
func _decorate_cthulhu(boss: Dictionary) -> void:
    var node: Node2D = boss["node"]
    var spr: AnimatedSprite2D = boss["sprite"]
    var eyes: Array = []
    for dx: float in [-9.0, 9.0]:
        var eye := Sprite2D.new()
        eye.texture = _glow_tex
        eye.material = _glow_mat
        eye.position = Vector2(dx, -99.0)   # лицо листа 96x128 (x4)
        eye.modulate = Color(1.0, 0.3, 0.1, 0.55)
        eye.scale = Vector2(0.55, 0.55)
        node.add_child(eye)
        var tw := eye.create_tween().set_loops()
        tw.tween_property(eye, "modulate:a", 0.95, 1.1)
        tw.tween_property(eye, "modulate:a", 0.5, 1.1)
        eyes.append(eye)
    var aura := Sprite2D.new()
    aura.texture = _glow_tex
    aura.material = _glow_mat
    aura.position = Vector2(0, -10)
    aura.modulate = Color(0.14, 0.3, 0.18, 0.42)
    aura.scale = Vector2(1.8, 1.3)
    node.add_child(aura)
    node.move_child(aura, 0)                 # аура — под спрайтом
    var breathe := node.create_tween().set_loops()
    breathe.tween_property(spr, "scale",
        Vector2(BOSS_SIZE_MULT * 1.045, BOSS_SIZE_MULT * 1.045), 1.6)         .set_trans(Tween.TRANS_SINE)
    breathe.tween_property(spr, "scale", Vector2(BOSS_SIZE_MULT,
        BOSS_SIZE_MULT), 1.6).set_trans(Tween.TRANS_SINE)
    boss["eyes"] = eyes
    boss["slam_cd"] = 4.0
    boss["volley_cd"] = 3.0
    boss["whisper_cd"] = 6.0

## Тактика Ктулху в бою (из _update_foes): веер болтов безумия, удар
## щупалец с предупреждением, шёпоты, призывы отродий, фаза 2.
func _update_cthulhu(foe: Dictionary, def: Dictionary, delta: float) -> void:
    if not bool(foe["aggro"]):
        return   # тактика только в бою (после диалога и при агрессии)
    var node: Node2D = foe["node"]
    var hp_frac := float(foe["hp"]) / maxf(1.0, float(foe["max_hp"]))
    # --- фаза 2: небо гаснет, глаза разгораются, когти быстрее
    if not bool(foe.get("phase2", false)) and hp_frac <= CTHULHU_PHASE2_HP:
        foe["phase2"] = true
        foe["attack_cd_override"] = CTHULHU_PHASE2_CD
        foe["speed_override"] = CTHULHU_PHASE2_SPEED
        if _air != null:
            _air.color = Color(_air_base.r * 0.5, _air_base.g * 0.45,
                _air_base.b * 0.6)
        for eye in foe.get("eyes", []):
            (eye as Sprite2D).modulate = Color(1.0, 0.18, 0.05, 1.0)
        _shake_camera(7.0, 0.9)
        Sfx.play("roar")
        _spawn_ring(node.position + Vector2(0, -24), Color(0.7, 0.22, 0.12), 3.4)
        _show_hint("Небо над Р'льехом гаснет. Ктулху больше не играет.", 3.0)
        return
    # --- призыв Отродий звёзд на порогах ХП (по одному разу на порог)
    for i in range(CTHULHU_SUMMON_HP.size()):
        var key := "summon_%d" % i
        if not bool(foe.get(key, false))                 and hp_frac <= float(CTHULHU_SUMMON_HP[i]):
            foe[key] = true
            _cthulhu_summon(node)
    # --- шёпоты Р'льеха
    foe["whisper_cd"] = maxf(0.0, float(foe.get("whisper_cd", 6.0)) - delta)
    if float(foe["whisper_cd"]) <= 0.0:
        foe["whisper_cd"] = CTHULHU_WHISPER_CD
        _cthulhu_whisper()
    # --- веер болтов безумия
    foe["volley_cd"] = maxf(0.0, float(foe.get("volley_cd", 3.0)) - delta)
    if float(foe["volley_cd"]) <= 0.0 and Game.hp > 0 and not _player_dead:
        foe["volley_cd"] = CTHULHU_VOLLEY_CD
        for k in range(CTHULHU_VOLLEY_N):
            var spread := -CTHULHU_VOLLEY_SPREAD                 + 2.0 * CTHULHU_VOLLEY_SPREAD * float(k)                 / float(CTHULHU_VOLLEY_N - 1)
            _spawn_foe_bolt(foe, def, spread, Color(0.45, 0.85, 0.6))
    # --- удар щупалец: круг-предупреждение, затем мокрый удар
    var now_ms := Time.get_ticks_msec()
    if foe.has("slam_at"):
        if now_ms >= int(foe["slam_at"]):
            var mark: Vector2 = foe["slam_pos"]
            foe.erase("slam_at")
            _cthulhu_slam_hit(foe, mark)
    else:
        foe["slam_cd"] = maxf(0.0, float(foe.get("slam_cd", 4.0)) - delta)
        if float(foe["slam_cd"]) <= 0.0 and Game.hp > 0 and not _player_dead:
            foe["slam_cd"] = CTHULHU_SLAM_CD
            var target := player.position + Vector2(0, -6)
            foe["slam_pos"] = target
            foe["slam_at"] = now_ms + int(CTHULHU_SLAM_TELL * 1000.0)
            _cthulhu_slam_tell(foe, target)

## Круг-предупреждение на полу: щупальца вот-вот ударят в это место.
func _cthulhu_slam_tell(foe: Dictionary, pos: Vector2) -> void:
    if _glow_tex == null:
        return
    var warn := Sprite2D.new()
    warn.texture = _glow_tex
    warn.material = _glow_mat
    warn.position = pos
    warn.scale = Vector2(0.62, 0.62)
    warn.modulate = Color(0.85, 0.3, 0.12, 0.35)
    warn.z_index = 8
    _fx.add_child(warn)
    foe["slam_mark"] = warn
    var tw := warn.create_tween().set_loops()
    tw.tween_property(warn, "modulate:a", 0.75, 0.2)
    tw.tween_property(warn, "modulate:a", 0.3, 0.2)

## Удар щупалец: мокрый звук, тряска, урон в радиусе круга.
func _cthulhu_slam_hit(foe: Dictionary, pos: Vector2) -> void:
    if foe.has("slam_mark") and is_instance_valid(foe["slam_mark"]):
        (foe["slam_mark"] as Sprite2D).queue_free()
        foe.erase("slam_mark")
    Sfx.play("slam")
    _shake_camera(6.0, 0.5)
    _spawn_ring(pos, Color(0.35, 0.6, 0.4), 2.2)
    for k in range(5):
        var ang := TAU * float(k) / 5.0
        _spell_poof(pos + Vector2(cos(ang), sin(ang)) * 12.0,
            Color(0.3, 0.52, 0.38))
    if Game.hp > 0 and not _player_dead             and player.position.distance_to(pos) <= CTHULHU_SLAM_RADIUS + 6.0:
        Game.damage_hp(CTHULHU_SLAM_DMG)
        Sfx.play("hurt")
        _flash_player()
        _spawn_hit_impact(player.position + Vector2(0, -14),
            Color(0.5, 0.75, 0.55))
        _spawn_damage_label(player.position + Vector2(0, -40),
            CTHULHU_SLAM_DMG)

## Из тени крыльев — Отродья звёзд: двое на свободных плитах рядом.
func _cthulhu_summon(boss_node: Node2D) -> void:
    var def := DungeonBestiary.foe_def("star_spawn")
    if def.is_empty():
        return
    var placed := 0
    for off: Vector2 in [Vector2(-26, -22), Vector2(26, -22),
            Vector2(-22, 26), Vector2(22, 26)]:
        if placed >= 2:
            break
        var pos := boss_node.position + off
        var tile := Vector2i(int(floor(pos.x / 16.0)),
            int(floor((pos.y - 8.0) / 16.0)))
        if tile.x < 1 or tile.y < 1                 or tile.x >= DungeonBestiary.MAP_W - 1                 or tile.y >= DungeonBestiary.MAP_H - 1:
            continue
        if _tile_is_solid(Vector2(pos.x, pos.y - 8.0)):
            continue
        _spawn_foe(def, tile)
        _spell_poof(_feet_pos(Vector2(tile)) + Vector2(0, -16),
            Color(0.5, 0.85, 0.8))
        placed += 1
    if placed > 0:
        Sfx.play("bolt", -4.0)
        _spawn_ring(boss_node.position + Vector2(0, -24),
            Color(0.5, 0.85, 0.8), 2.6)
        _show_hint("Из тени крыльев выплывают Отродья звёзд!", 2.6)

## Шёпоты Р'льеха: по кругу, одна реплика за раз (boss_whispers данжа).
func _cthulhu_whisper() -> void:
    var whispers: Array = DungeonBestiary.dungeon_meta(_dungeon_id)         .get("boss_whispers", [])
    if whispers.is_empty():
        return
    _cthulhu_whisper_idx = (_cthulhu_whisper_idx + 1) % whispers.size()
    _show_hint(String(whispers[_cthulhu_whisper_idx]), 3.4)

## -------------------------------- Шуб-Ниггурат (шаг 24, п.10)

## Декор Шуб-Ниггурат: третий глаз, аура спор, дыхание массой, пороги.
func _decorate_shub(boss: Dictionary) -> void:
    var node: Node2D = boss["node"]
    var spr: AnimatedSprite2D = boss["sprite"]
    var eyes: Array = []
    for eye_pos: Vector2 in [Vector2(-12, -96), Vector2(12, -96),
            Vector2(0, -84)]:
        var eye := Sprite2D.new()
        eye.texture = _glow_tex
        eye.material = _glow_mat
        eye.position = eye_pos
        eye.modulate = Color(0.85, 0.95, 0.3, 0.55)
        eye.scale = Vector2(0.5, 0.5)
        node.add_child(eye)
        var tw := eye.create_tween().set_loops()
        tw.tween_property(eye, "modulate:a", 0.95, 1.0)
        tw.tween_property(eye, "modulate:a", 0.4, 1.0)
        eyes.append(eye)
    var aura := Sprite2D.new()
    aura.texture = _glow_tex
    aura.material = _glow_mat
    aura.position = Vector2(0, -16)
    aura.modulate = Color(0.2, 0.34, 0.12, 0.45)
    aura.scale = Vector2(2.0, 1.5)
    node.add_child(aura)
    node.move_child(aura, 0)
    var breathe := node.create_tween().set_loops()
    breathe.tween_property(spr, "scale",
        Vector2(BOSS_SIZE_MULT * 1.05, BOSS_SIZE_MULT * 1.05), 1.7) \
        .set_trans(Tween.TRANS_SINE)
    breathe.tween_property(spr, "scale", Vector2(BOSS_SIZE_MULT,
        BOSS_SIZE_MULT), 1.7).set_trans(Tween.TRANS_SINE)
    boss["eyes"] = eyes
    boss["volley_cd"] = 3.0
    boss["whisper_cd"] = 5.0

## Тактика Шуб-Ниггурат: веер спор, полчища детенышей на порогах ХП,
## шёпот Козни, фаза 2 «сад гаснет» (воздух темнеет, когти быстрее).
func _update_shub(foe: Dictionary, def: Dictionary, delta: float) -> void:
    if not bool(foe["aggro"]):
        return
    var node: Node2D = foe["node"]
    var hp_frac := float(foe["hp"]) / maxf(1.0, float(foe["max_hp"]))
    # --- фаза 2: сад гаснет
    if not bool(foe.get("phase2", false)) and hp_frac <= SHUB_PHASE2_HP:
        foe["phase2"] = true
        foe["attack_cd_override"] = SHUB_PHASE2_CD
        foe["speed_override"] = SHUB_PHASE2_SPEED
        if _air != null:
            _air.color = Color(_air_base.r * 0.45, _air_base.g * 0.5,
                _air_base.b * 0.5)
        for eye in foe.get("eyes", []):
            (eye as Sprite2D).modulate = Color(0.95, 0.2, 0.1, 1.0)
        _shake_camera(7.0, 0.9)
        Sfx.play("roar")
        _spawn_ring(node.position + Vector2(0, -26), Color(0.55, 0.75, 0.3), 3.4)
        _show_hint("Сад Шуб-Ниггурат гаснет. Её молоко больше не для тебя.", 3.0)
        return
    # --- полчища детенышей на порогах ХП
    for i in range(SHUB_SUMMON_HP.size()):
        var key := "summon_%d" % i
        if not bool(foe.get(key, false)) and hp_frac <= float(SHUB_SUMMON_HP[i]):
            foe[key] = true
            _shub_summon(node, i)
    # --- шёпот Козни
    foe["whisper_cd"] = maxf(0.0, float(foe.get("whisper_cd", 5.0)) - delta)
    if float(foe["whisper_cd"]) <= 0.0:
        foe["whisper_cd"] = SHUB_WHISPER_CD
        _cthulhu_whisper()   # общий механизм шёпота: текст берётся из данжа
    # --- веер спор
    foe["volley_cd"] = maxf(0.0, float(foe.get("volley_cd", 3.0)) - delta)
    if float(foe["volley_cd"]) <= 0.0 and Game.hp > 0 and not _player_dead:
        foe["volley_cd"] = SHUB_VOLLEY_CD
        for k in range(SHUB_VOLLEY_N):
            var spread := -SHUB_VOLLEY_SPREAD \
                + 2.0 * SHUB_VOLLEY_SPREAD * float(k) \
                / float(SHUB_VOLLEY_N - 1)
            _spawn_foe_bolt(foe, def, spread, Color(0.75, 0.9, 0.5))

## Полчище детенышей (шаг 24): пара тварей из бестиария данжа 4 вокруг Матери.
func _shub_summon(boss_node: Node2D, threshold_idx: int) -> void:
    var placed := 0
    var offs: Array[Vector2] = [Vector2(-30, -20), Vector2(30, -20),
        Vector2(0, 30)]
    for k in range(SHUB_SUMMON_COUNT):
        var foe_id := String(SHUB_SUMMON_IDS[(threshold_idx * SHUB_SUMMON_COUNT + k)
            % SHUB_SUMMON_IDS.size()])
        var def := DungeonBestiary.foe_def(foe_id)
        if def.is_empty():
            continue
        if k >= offs.size():
            break
        var pos := boss_node.position + offs[k]
        var tile := Vector2i(int(floor(pos.x / 16.0)),
            int(floor((pos.y - 8.0) / 16.0)))
        if tile.x < 1 or tile.y < 1 \
                or tile.x >= DungeonBestiary.MAP_W - 1 \
                or tile.y >= DungeonBestiary.MAP_H - 1:
            continue
        if _tile_is_solid(Vector2(pos.x, pos.y - 8.0)):
            continue
        _spawn_foe(def, tile)
        _spell_poof(_feet_pos(Vector2(tile)) + Vector2(0, -16),
            Color(0.75, 0.9, 0.5))
        placed += 1
    if placed > 0:
        Sfx.play("bolt", -4.0)
        _spawn_ring(boss_node.position + Vector2(0, -24),
            Color(0.75, 0.9, 0.5), 2.8)
        _show_hint("Из спор Шуб-Ниггурат выходят её младенцы!", 2.6)

## Босс повержен: данж пройден, демон мёртв навсегда, жертвы оживают,
## из пепла — ЭПИЧЕСКОЕ случайное оружие (шаг 14), на месте босса
## открывается портал в замок, у боссов 1–3 — ключ следующего данжа.
func _on_boss_defeated(boss: Dictionary) -> void:
    _boss_defeated_here = true
    # шаг 21: Ктулху уснул — небо возвращается, круг-предупреждение гаснет
    if _air != null:
        _air.color = _air_base
    if boss.has("slam_mark") and is_instance_valid(boss["slam_mark"]):
        (boss["slam_mark"] as Sprite2D).queue_free()
    boss.erase("slam_at")
    if _dungeon_id == "dungeon_1":
        # только демон вершил убийства жителей — его смерть воскрешает их
        # (шаги 13/16); босс данжа 2 отвечает только за свой данж
        Game.defeat_demon_permanently()
    Game.mark_dungeon_cleared(_dungeon_id)
    var node: Node2D = boss["node"]
    var epic := Loot.epic_weapon_loot()
    var epic_id := String(epic["item_id"])
    Game.add_item({"item_id": epic_id, "title": ItemDB.title(epic_id),
        "quality": String(epic["quality"])})
    # шаг 19: эпическая добыча — иконкой в центре экрана
    _show_loot_popup(ItemDB.title(epic_id), ItemDB.icon(epic_id), "gold")
    Sfx.play("coin")
    _spell_poof(node.position + Vector2(0, -30), Color(1.0, 0.84, 0.2))
    # Шаг 24 (п.1): КЛЮЧ следующего подземелья — на экран (иконка+текст).
    var key_id := String(DungeonBestiary.dungeon_meta(_dungeon_id)
        .get("boss_key", ""))
    if not key_id.is_empty():
        Game.add_item({"item_id": key_id, "title": ItemDB.title(key_id),
            "quality": "gold"})
        Sfx.play("coin")
        var key_popup := create_tween()
        key_popup.tween_interval(2.2)
        key_popup.tween_callback(func() -> void:
            _show_loot_popup(ItemDB.title(key_id), ItemDB.icon(key_id), "gold")
            _show_hint(String(KEY_HINT) % ItemDB.title(key_id), 6.0))
    var tx := clampi(int(floor(node.position.x / 16.0)), 1, DungeonBestiary.MAP_W - 2)
    var ty := clampi(int(floor(node.position.y / 16.0)), 1, DungeonBestiary.MAP_H - 2)
    _place_exit(Vector2i(tx, ty))
    var dmeta := DungeonBestiary.dungeon_meta(_dungeon_id)
    _show_hint(String(dmeta.get("boss_defeated_hint", "")), 6.0)
    # реплика про эпическую добычу — после текста о победе (одна подсказка)
    var epic_hint := String(dmeta.get("boss_epic_hint", "")) \
        % ItemDB.title(epic_id)
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
    if Game.hero_immune and not Game.guard_active:
        _show_hint("Барьер поглощает всё внимание — бить нельзя", 1.6)
        return
    _strike_cd = STRIKE_COOLDOWN
    if Game.guard_active:
        _strike_cd *= float(Game.ability_info("special").get("strike_cd_mult", 2.0))
    var dir := _facing_vector()
    var target := _living_foe_in_front(dir)
    var weapon_color := Game.strike_swing_color()
    # шаг 19: оружие видно в замахе, свист — в ушах
    _spawn_weapon_swing(dir, weapon_color)
    Sfx.play("swing")
    if target.is_empty():
        _spawn_swing(player.position + dir * 14.0 + Vector2(0, -12), weapon_color)
        return
    var foe_node: Node2D = target["node"]
    _spawn_swing((player.position + foe_node.position) * 0.5 + Vector2(0, -12),
        weapon_color)
    _spawn_slash_arc(foe_node.position + Vector2(0, -12), weapon_color)
    _hit_foe(target, Game.strike_damage())
    Sfx.play("hit")
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
func _hit_foe(foe: Dictionary, damage: int, do_knockback: bool = true) -> void:
    var foe_node: Node2D = foe["node"]
    var s := maxi(1, int((foe["def"] as Dictionary).get("scale", 1)))
    foe["hp"] = maxi(0, int(foe["hp"]) - damage)
    _spawn_damage_label(foe_node.position + Vector2(0, -float(CHAR_H * s) - 2),
        damage)
    # шаг 19: яркая вспышка в точке попадания; шаг 20: боевка сочнее —
    # враг отлетает от удара, камера вздрагивает на ощутимом уроне
    _spawn_hit_impact(foe_node.position + Vector2(0, -12),
        Color(1.0, 0.85, 0.6))
    if do_knockback:
        _knockback_foe(foe, 4.0)
    if damage >= 15:
        _shake_camera(2.0, 0.18)
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
    _shake_camera(2.5, 0.22)
    Sfx.play("die")
    # награда: золото растёт с глубиной, у элиты — тройная;
    # иногда враг роняет зелье
    var reward := DungeonBestiary.foe_gold(def, _floor_num) \
        * int(foe.get("gold_mult", 1))
    Game.add_gold(reward)
    # шаг 19: опыт за победу (у элиты — втрое, как и золото)
    var foe_scale := maxi(1, int(def.get("scale", 1)))
    var xp_reward := maxi(0, int(def.get("xp", 0))) \
        * int(foe.get("gold_mult", 1))
    if xp_reward > 0:
        Game.add_xp(xp_reward)
        _spawn_xp_label((foe["node"] as Node2D).position
            + Vector2(0, -float(CHAR_H * foe_scale) - 2), xp_reward)
    _show_hint(String(FOE_LOOT_GOLD_HINT) % [String(foe.get("title",
        def.get("name", "Враг"))), reward], 2.0)
    if randi() % 100 < 15:
        var potion := "hp_potion_small" if _floor_num < DungeonBestiary.FLOORS \
            else "hp_potion"
        Game.add_item({"item_id": potion, "title": ItemDB.title(potion),
            "quality": "gray"})
        _show_hint(String(FOE_LOOT_ITEM_HINT) % [String(foe.get("title",
            def.get("name", "Враг"))), ItemDB.title(potion)], 2.5)
    elif randi() % 100 < int(Loot.FOE_GEAR_CHANCE):
        # шаг 22: изредка с врага падает оружие или броня
        var gear := Loot.foe_gear_drop(_floor_num)
        if gear.has("item_id"):
            var gear_id := String(gear["item_id"])
            Game.add_item({"item_id": gear_id, "title": ItemDB.title(gear_id),
                "quality": String(gear.get("quality", "gray"))})
            _show_hint(String(FOE_LOOT_ITEM_HINT) % [String(foe.get("title",
                def.get("name", "Враг"))), ItemDB.title(gear_id)], 2.5)
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

## Тряска камеры (шаг 20): короткий сочный сдвиг взгляда.
func _shake_camera(strength: float, time: float) -> void:
    _shake_strength = maxf(_shake_strength, strength)
    _shake_left = maxf(_shake_left, time)

func _update_camera_shake(delta: float) -> void:
    if _camera == null:
        return
    if _shake_left > 0.0:
        _shake_left = maxf(0.0, _shake_left - delta)
        var falloff := clampf(_shake_left / 0.4, 0.25, 1.0)
        var s := _shake_strength * falloff
        _camera.offset = Vector2(randf_range(-s, s), randf_range(-s, s))
    elif _camera.offset != Vector2.ZERO:
        _camera.offset = Vector2.ZERO
        _shake_strength = 0.0

## Расширяющееся кольцо (шаг 20): свечение, растущее и тающее.
func _spawn_ring(pos: Vector2, color: Color, scale_to: float) -> void:
    if _glow_tex == null:
        return
    var ring := Sprite2D.new()
    ring.texture = _glow_tex
    ring.material = _glow_mat
    ring.position = pos
    ring.scale = Vector2(0.5, 0.5)
    ring.modulate = Color(color.r, color.g, color.b, 0.65)
    ring.z_index = 9
    _fx.add_child(ring)
    var tw := create_tween()
    tw.set_parallel(true)
    tw.tween_property(ring, "scale", Vector2(scale_to, scale_to), 0.32) \
        .set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
    tw.tween_property(ring, "modulate:a", 0.0, 0.34)
    tw.chain().tween_callback(ring.queue_free)

## Отброс врага от удара (шаг 20): на пару пикселей от героя, сквозь
## стены не проходит; боссов и летящих врагов не трогает.
func _knockback_foe(foe: Dictionary, distance: float) -> void:
    if bool(foe.get("boss", false)) or bool(foe.get("thrown", false)):
        return
    var node: Node2D = foe["node"]
    var away := (node.position - player.position).normalized()
    if away == Vector2.ZERO:
        away = Vector2(0, 1)
    var back := node.position + away * distance
    if not _tile_is_solid(back):
        node.position = back

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
    var tw := create_tween()   # шаг 23: твин умирает вместе со сценой
    tw.tween_interval(0.6)
    tw.tween_callback(func() -> void:
        if is_instance_valid(poof):
            poof.queue_free())

func _spawn_swing(pos: Vector2, color: Color) -> void:
    var swing := CPUParticles2D.new()
    swing.position = pos
    swing.amount = 14                       # шаг 19: сочнее
    swing.lifetime = 0.24
    swing.one_shot = true
    swing.explosiveness = 1.0
    swing.direction = Vector2(0, -1)
    swing.spread = 120.0
    swing.initial_velocity_min = 60.0
    swing.initial_velocity_max = 130.0
    swing.scale_amount_min = 1.6
    swing.scale_amount_max = 3.2
    swing.color = color
    swing.emitting = true
    _fx.add_child(swing)
    var tw := create_tween()   # шаг 23: твин умирает вместе со сценой
    tw.tween_interval(0.5)
    tw.tween_callback(func() -> void:
        if is_instance_valid(swing):
            swing.queue_free())

## Видимое оружие (шаг 19): иконка того, что в руках, проносится дугой
## в направлении взгляда и тает. Кулаки — без иконки (искры и дуга).
func _spawn_weapon_swing(dir: Vector2, color: Color) -> void:
    var icon_path := Game.strike_weapon_icon()
    if icon_path.is_empty() or not ResourceLoader.exists(icon_path):
        return
    if not _weapon_tex_cache.has(icon_path):
        _weapon_tex_cache[icon_path] = load(icon_path)
    var tex: Texture2D = _weapon_tex_cache[icon_path]
    var base := atan2(dir.y, dir.x)
    var weapon := Sprite2D.new()
    weapon.texture = tex
    weapon.position = player.position + dir * 13.0 + Vector2(0, -12)
    weapon.rotation = base - PI / 2.0 - 1.1
    weapon.scale = Vector2(1.5, 1.5)
    weapon.z_index = 11
    _fx.add_child(weapon)
    var tw := create_tween()
    tw.set_parallel(true)
    tw.tween_property(weapon, "rotation", base - PI / 2.0 + 1.1, 0.14) \
        .set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
    tw.tween_property(weapon, "scale", Vector2(1.15, 1.15), 0.14)
    tw.tween_property(weapon, "modulate:a", 0.0, 0.12).set_delay(0.1)
    tw.chain().tween_callback(weapon.queue_free)

## Дуга удара (шаг 19): белая дуга slash_arc.png в цвет оружия/заклинания.
func _spawn_slash_arc(pos: Vector2, color: Color) -> void:
    if _slash_tex == null:
        return
    var arc := Sprite2D.new()
    arc.texture = _slash_tex
    arc.position = pos
    arc.modulate = Color(color.r, color.g, color.b, 0.9)
    var mat := CanvasItemMaterial.new()
    mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
    arc.material = mat
    arc.rotation = randf_range(-0.5, 0.5)
    arc.scale = Vector2(0.55, 0.55)   # шаг 20: дуга заметнее
    arc.z_index = 11
    _fx.add_child(arc)
    var tw := create_tween()
    tw.set_parallel(true)
    tw.tween_property(arc, "scale", Vector2(1.1, 1.1), 0.16) \
        .set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
    tw.tween_property(arc, "modulate:a", 0.0, 0.2).set_delay(0.08)
    tw.chain().tween_callback(arc.queue_free)

## Импакт попадания (шаг 19): яркая вспышка искр из точки удара.
func _spawn_hit_impact(pos: Vector2, color: Color) -> void:
    var impact := CPUParticles2D.new()
    impact.position = pos
    impact.amount = 14
    impact.lifetime = 0.18
    impact.one_shot = true
    impact.explosiveness = 1.0
    impact.direction = Vector2(0, -1)
    impact.spread = 180.0
    impact.initial_velocity_min = 60.0
    impact.initial_velocity_max = 140.0
    impact.scale_amount_min = 1.0
    impact.scale_amount_max = 2.4
    impact.color = color
    impact.emitting = true
    _fx.add_child(impact)
    var tw := create_tween()   # шаг 23: твин умирает вместе со сценой
    tw.tween_interval(0.5)
    tw.tween_callback(func() -> void:
        if is_instance_valid(impact):
            impact.queue_free())

## След снаряда (шаг 19): одна тающая искра.
func _spawn_trail_dot(pos: Vector2, color: Color) -> void:
    var dot := CPUParticles2D.new()
    dot.position = pos
    dot.amount = 1
    dot.lifetime = 0.28
    dot.one_shot = true
    dot.explosiveness = 1.0
    dot.direction = Vector2.ZERO
    dot.spread = 0.0
    dot.initial_velocity_min = 0.0
    dot.initial_velocity_max = 0.0
    dot.scale_amount_min = 1.4
    dot.scale_amount_max = 2.2
    dot.color = Color(color.r, color.g, color.b, 0.65)
    dot.emitting = true
    _fx.add_child(dot)
    var tw := create_tween()   # шаг 23: твин умирает вместе со сценой
    tw.tween_interval(0.4)
    tw.tween_callback(func() -> void:
        if is_instance_valid(dot):
            dot.queue_free())

func _spawn_damage_label(pos: Vector2, damage: int) -> void:
    var label := Label.new()
    label.text = "-%d" % damage
    label.position = pos + Vector2(-14, 0)
    label.size = Vector2(28, 14)
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    # шаг 20: крупный урон — крупная золотая цифра (почувствуй удар)
    var big := damage >= 30
    label.add_theme_font_size_override("font_size", 14 if big else 11)
    label.add_theme_color_override("font_color",
        Color(1.0, 0.84, 0.3) if big else Color(1.0, 0.42, 0.36))
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
    # шаг 25: на ПК экранный джойстик не нужен — только сенсорные экраны
    if not DisplayServer.is_touchscreen_available():
        return
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
    # шаг 25: на ПК джойстика нет — панель героя у левого края консоли
    var hero_x := BAR_HERO_POS.x if DisplayServer.is_touchscreen_available() else 8.0
    hero_panel.position = Vector2(hero_x, bar_top + BAR_HERO_POS.y)
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
    # шаг 19: рядом с именем — уровень героя
    hero_name.text = "%s · ур. %d" % [Game.hero_title(), Game.level]
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
    # шаг 19: полоса опыта до следующего уровня
    _hud_xp = ProgressBar.new()
    _hud_xp.custom_minimum_size = Vector2(74, 5)
    _hud_xp.min_value = 0
    _hud_xp.max_value = Game.xp_needed()
    _hud_xp.value = Game.xp
    _hud_xp.show_percentage = false
    _hud_xp.add_theme_stylebox_override("background",
        _bar_style(Color(0.08, 0.08, 0.12), Color(0.35, 0.3, 0.16)))
    _hud_xp.add_theme_stylebox_override("fill",
        _bar_style(Color(0.85, 0.7, 0.2), Color(0.85, 0.7, 0.2)))
    hero_box.add_child(_hud_xp)
    _cb_xp = func(xp_value: int, xp_need: int) -> void:
        if is_instance_valid(_hud_xp):
            _hud_xp.max_value = xp_need
            _hud_xp.value = xp_value
    Game.xp_changed.connect(_cb_xp)
    _cb_level = func(new_level: int) -> void:
        if is_instance_valid(hero_name):
            hero_name.text = "%s · ур. %d" % [Game.hero_title(), new_level]
        # урон в руках вырос вместе с уровнем — обновить строку HUD
        if is_instance_valid(hud_weapon):
            hud_weapon.text = "В руках: %s · %d ур." % [Game.strike_title(),
                Game.strike_damage()]
    Game.level_up.connect(_cb_level)
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
    # Шаг 20: приёмы и удар живут на клавишах (подсказка у края экрана).
    # Шаг 21 (автор): СУМКА вернулась в кнопки — инвентарь открывается
    # одним нажатием, как и в мире.
    var actions: Array = [
        {"text": "МЕНЮ", "font": 10, "cb": _on_menu_pressed},
        {"text": "СУМКА", "font": 9, "cb": _on_bag_pressed},
        {"text": "СОХРАНИТЬ", "font": 9, "cb": _on_save_pressed},
        {"text": "ЗАГРУЗИТЬ", "font": 9, "cb": _on_load_pressed},
    ]
    var total_h := float(actions.size()) * BAR_BTN_SIZE.y \
        + float(actions.size() - 1) * (BAR_BTN_STEP - BAR_BTN_SIZE.y)
    var start_y := (UI_BAR_H - total_h) / 2.0
    for i in range(actions.size()):
        var spec: Dictionary = actions[i]
        var btn := Button.new()
        btn.text = String(spec["text"])
        btn.size = BAR_BTN_SIZE
        btn.position = Vector2(BAR_BUTTONS_X, bar_top + start_y + float(i) * BAR_BTN_STEP)
        _style_small_button(btn, int(spec["font"]))
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

## «Подземелье · ур. N/4 · врагов: K» — обновляется на спавне и после убийств.
func _update_progress_label() -> void:
    if _hud_floor == null:
        return
    var alive := 0
    for foe in _foes:
        if not bool(foe.get("dead", false)) and not bool(foe.get("boss", false)):
            alive += 1
    _hud_floor.text = "%s · ур. %d/%d · врагов: %d" % [
        DungeonBestiary.dungeon_name(_dungeon_id), _floor_num,
        DungeonBestiary.FLOORS, alive]

func _show_floor_intro(boss_present: bool) -> void:
    var dmeta := DungeonBestiary.dungeon_meta(_dungeon_id)
    if _floor_num <= 1:
        _show_hint(String(dmeta.get("intro_hint", "")), 5.5)
    elif _floor_num >= DungeonBestiary.FLOORS:
        _show_hint(String(dmeta.get("boss_floor_hint", "")) if boss_present
            else String(dmeta.get("boss_floor_done_hint", "")), 5.5)
    else:
        _show_hint(String(_theme.get("hint", "")), 5.0)

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

## Подсказка управления — из автозагрузки Controls (переназначаемые клавиши).
func _refresh_controls_hint() -> void:
    if _hud_hint == null:
        return
    _hud_hint.add_theme_font_size_override("font_size", 10)
    _hud_hint.tooltip_text = ""
    for action in Controls.get_actions():
        _hud_hint.tooltip_text += Controls.get_action_label(action) + ": " \
            + Controls.get_binding_text(action) + "\n"
    _show_hint(Controls.get_hud_hint(Game.is_mage(),
        String(Game.ability_info("q").get("hint", "")),
        String(Game.ability_info("special").get("hint", "")),
        String(Game.ability_info("t").get("hint", ""))), 5.0)

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

## Кнопка СУМКА (шаг 21): инвентарь вернулся в кнопки HUD данжа.
func _on_bag_pressed() -> void:
    if _inventory_ui.visible:
        _inventory_ui.close()
    else:
        _inventory_ui.open()

## Кнопка СОХРАНИТЬ (шаг 20): быстрое сохранение в текущий слот.
func _on_save_pressed() -> void:
    if Game.current_slot < 1:
        _show_hint("Сохранение недоступно: слот не выбран", 2.0)
        return
    Saves.request_save()
    _show_hint("Игра сохранена в слот %d" % Game.current_slot, 2.0)

## Кнопка ЗАГРУЗИТЬ (шаг 20): перечитать текущий слот и вернуться в замок
## (этажи подземелья собираются заново — они живут только в сессии).
func _on_load_pressed() -> void:
    if Game.current_slot < 1 or not Platform.has_slot(Game.current_slot):
        _show_hint("Загрузить нечего: слот пуст", 2.0)
        return
    if not Game.continue_run(Game.current_slot):
        _show_hint("Сейв повреждён: загрузить не вышло", 2.0)
        return
    Platform.gameplay_stop()
    get_tree().change_scene_to_file(WORLD_SCENE)
