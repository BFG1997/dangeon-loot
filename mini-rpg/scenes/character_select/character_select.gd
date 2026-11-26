## Экран выбора героя: Воин / Варвар / Бомж / Маг / Демоноолог / Некромант
## (шаги 3 и 6; шаг 31 — два новых колдуна).
## Выбор влияет на внешность, стартовое золото (шаг 5) и хп/ману (шаг 6):
## Воин — 100 з., Варвар — 50 з., Бомж — 1 з., Маг — 60 з.,
## Демоноолог — 45 з., Некромант — 55 з. (шаг 31).
## ФИКС ПК (шаг 26): сетка героев зависит от ширины экрана — на широких
## окнах (ПК, 1920x1080 и т.п.) герои идут В ОДИН РЯД: прежняя сетка 2x2
## была рассчитана на мобильные 360x640, и на ПК её содержимое не влезало
## по высоте — кнопка «В ПУТЬ» уезжала за нижний край экрана (это и есть
## «улетевший интерфейс»). Узкие окна (телефон) по-прежнему показывают 2 колонки.
## Шаг 31: героев ШЕСТЬ — карточки ужаты до 140 px и зазор до 8 px,
## чтобы ряд из шести влезал в логические 960 px (6*140+5*8+24 = 904).
extends Control

const MAIN_SCENE := "res://scenes/main/main.tscn"
const WORLD_SCENE := "res://scenes/world/world.tscn"
## Карточка героя: с шага 31 героев шестеро; на ПК — ряд из 6, в узком окне — 2 колонки.
const CARD_SIZE := Vector2(140, 0)
const GRID_COLS_NARROW := 2
const GRID_COLS_WIDE := 6
## Ширина логического вьюпорта, начиная с которой герои помещаются в один ряд:
## 6 карточек по 140 + 5 зазоров по 8 = 880 px, плюс поля 12x2 = 904.
const WIDE_MIN_WIDTH := 910.0
const COLOR_VIOLET := Color(0.702, 0.533, 1.0)
const COLOR_MANA := Color(0.45, 0.7, 0.95)

var selected_hero := ""
var card_styles := {}   # hero_id -> StyleBoxFlat

var title_label: Label
var cards_box: GridContainer
var play_button: Button
var slot_label: Label

func _ready() -> void:
    _build_background()
    _build_ui()
    _refresh_slot_label()
    # ФИКС ПК (шаг 26): число колонок пересчитывается при изменении окна.
    get_viewport().size_changed.connect(_update_grid_columns)
    _update_grid_columns()
    Platform.notify_ready()
    Platform.gameplay_stop()

## Число колонок сетки героев: широкий экран — один ряд из 4, узкий — 2x2.
func _update_grid_columns() -> void:
    if cards_box == null:
        return
    var width := get_viewport_rect().size.x
    cards_box.columns = GRID_COLS_WIDE if width >= WIDE_MIN_WIDTH \
        else GRID_COLS_NARROW

func _build_background() -> void:
    var bg := ColorRect.new()
    bg.set_anchors_preset(Control.PRESET_FULL_RECT)
    bg.color = Color(0.045, 0.05, 0.09)
    add_child(bg)
    var stars := TextureRect.new()
    stars.set_anchors_preset(Control.PRESET_FULL_RECT)
    stars.texture = load("res://assets/backgrounds/stars_far.png")
    stars.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    stars.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
    stars.modulate.a = 0.55
    add_child(stars)

func _build_ui() -> void:
    var back_button := Button.new()
    back_button.text = "НАЗАД"
    back_button.position = Vector2(12, 12)
    back_button.size = Vector2(88, 34)
    UiStyle.style_button(back_button, 13)
    back_button.pressed.connect(func() -> void:
        get_tree().change_scene_to_file(MAIN_SCENE))
    add_child(back_button)

    var vbox := VBoxContainer.new()
    vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
    vbox.offset_left = 12
    vbox.offset_right = -12
    vbox.offset_top = 58
    vbox.offset_bottom = -18
    vbox.add_theme_constant_override("separation", 10)
    vbox.alignment = BoxContainer.ALIGNMENT_CENTER
    add_child(vbox)

    title_label = Label.new()
    title_label.text = "ВЫБЕРИ ГЕРОЯ"
    title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title_label.add_theme_color_override("font_color", UiStyle.COLOR_GOLD)
    title_label.add_theme_font_size_override("font_size", 22)
    vbox.add_child(title_label)

    var center := CenterContainer.new()
    vbox.add_child(center)
    # ФИКС ПК (шаг 26): героев четверо — на широком окне ряд из 4 карточек,
    # в узком (телефон) — сетка 2x2; колонки пересчитывает _update_grid_columns().
    cards_box = GridContainer.new()
    cards_box.columns = GRID_COLS_WIDE
    cards_box.add_theme_constant_override("h_separation", 8)
    cards_box.add_theme_constant_override("v_separation", 8)
    center.add_child(cards_box)

    for hero_id in Game.HEROES:
        cards_box.add_child(_make_hero_card(hero_id))

    slot_label = Label.new()
    slot_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    slot_label.add_theme_color_override("font_color", Color(0.55, 0.6, 0.67))
    slot_label.add_theme_font_size_override("font_size", 12)
    vbox.add_child(slot_label)

    var play_center := CenterContainer.new()
    vbox.add_child(play_center)
    play_button = Button.new()
    play_button.text = "В ПУТЬ"
    play_button.custom_minimum_size = Vector2(200, 46)
    UiStyle.style_button(play_button, 17)
    play_button.disabled = true
    play_button.modulate.a = 0.45
    play_button.pressed.connect(_on_play_pressed)
    play_center.add_child(play_button)

func _make_hero_card(hero_id: String) -> PanelContainer:
    var card := PanelContainer.new()
    card.custom_minimum_size = CARD_SIZE
    card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    card.mouse_filter = Control.MOUSE_FILTER_STOP
    var style := UiStyle.flat_style(Color(0.09, 0.1, 0.16), Color(0.35, 0.38, 0.5))
    card.add_theme_stylebox_override("panel", style)
    card_styles[hero_id] = style
    card.gui_input.connect(_on_card_gui_input.bind(hero_id))

    var vbox := VBoxContainer.new()
    vbox.add_theme_constant_override("separation", 5)
    vbox.alignment = BoxContainer.ALIGNMENT_CENTER
    card.add_child(vbox)

    var portrait := TextureRect.new()
    portrait.texture = load(String(Game.HEROES[hero_id]["portrait"]))
    portrait.custom_minimum_size = Vector2(64, 64)
    portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    portrait.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
    portrait.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    vbox.add_child(portrait)

    # лёгкое «дыхание» портрета на карточке
    var tw := portrait.create_tween().set_loops()
    tw.tween_property(portrait, "custom_minimum_size:y", 68.0, 1.4) \
        .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    tw.tween_property(portrait, "custom_minimum_size:y", 64.0, 1.4) \
        .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

    var name_label := Label.new()
    name_label.text = String(Game.HEROES[hero_id]["title"])
    name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    name_label.add_theme_color_override("font_color", UiStyle.COLOR_GOLD)
    name_label.add_theme_font_size_override("font_size", 14)
    vbox.add_child(name_label)

    var flavor := Label.new()
    flavor.text = String(Game.HEROES[hero_id]["flavor"])
    flavor.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    flavor.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    flavor.add_theme_color_override("font_color", Color(0.72, 0.76, 0.83))
    flavor.add_theme_font_size_override("font_size", 9)
    flavor.custom_minimum_size = Vector2(120, 0)
    vbox.add_child(flavor)

    # шаг 6: хп и мана героя (мана — новый показатель мага); шаг 31:
    # у колдунов мана тоже есть (растёт с уровнем — на карточке базовое)
    var hp: int = Game.hero_max_hp(hero_id)
    var mana: int = Game.hero_max_mana(hero_id)
    var stats := Label.new()
    if mana > 0:
        stats.text = "ХП %d · Мана %d" % [hp, mana]
        stats.add_theme_color_override("font_color", COLOR_MANA)
    else:
        stats.text = "ХП %d" % hp
        stats.add_theme_color_override("font_color", Color(0.85, 0.62, 0.58))
    stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    stats.add_theme_font_size_override("font_size", 10)
    vbox.add_child(stats)

    # стартовый кошелёк героя (шаг 5)
    var start_gold := Label.new()
    start_gold.text = "%d з. на старте" % Game.hero_start_gold(hero_id)
    start_gold.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    start_gold.add_theme_color_override("font_color", UiStyle.COLOR_GOLD)
    start_gold.add_theme_font_size_override("font_size", 10)
    vbox.add_child(start_gold)
    return card

func _on_card_gui_input(event: InputEvent, hero_id: String) -> void:
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        _select_hero(hero_id)

func _select_hero(hero_id: String) -> void:
    selected_hero = hero_id
    for other_id in card_styles:
        var style: StyleBoxFlat = card_styles[other_id]
        if other_id == hero_id:
            style.set_border_width_all(3)
            style.border_color = UiStyle.COLOR_GOLD
        else:
            style.set_border_width_all(2)
            style.border_color = Color(0.35, 0.38, 0.5)
    play_button.disabled = false
    play_button.modulate.a = 1.0
    _refresh_slot_label()

func _refresh_slot_label() -> void:
    var slot := Game.pick_new_slot()
    var occupied := Platform.has_slot(slot)
    slot_label.text = "Игра запишется в слот %d%s" % [slot, " (перезапишет старую)" if occupied else ""]

func _on_play_pressed() -> void:
    if selected_hero.is_empty():
        return
    Game.new_run(Game.pick_new_slot(), selected_hero)
    get_tree().change_scene_to_file(WORLD_SCENE)
