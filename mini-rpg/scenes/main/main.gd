## Главное меню. Тап по сундуку «выбрасывает» из него пункты меню
## один за другим: Начать игру, Настройки, Авторы, Бонус.
## «Начать игру» открывает выбор: Новая игра / Продолжить / Загрузить.
extends Control

const MENU_ITEMS: Array[Dictionary] = [
    {"id": "start", "text": "НАЧАТЬ ИГРУ"},
    {"id": "settings", "text": "НАСТРОЙКИ"},
    {"id": "authors", "text": "АВТОРЫ"},
    {"id": "bonus", "text": "БОНУС"},
]

const BUTTON_SIZE := Vector2(240, 46)
const BUTTON_GAP := 12
const FIRST_SLOT_Y := 316.0
const CHEST_OPEN_TEXTURE := preload("res://assets/sprites/chest_open.png")
const COLOR_VIOLET := Color(0.702, 0.533, 1.0)
const CHARACTER_SELECT_SCENE := "res://scenes/character_select/character_select.tscn"
const WORLD_SCENE := "res://scenes/world/world.tscn"

var revealed_count := 0
var reset_armed := false

@onready var title_label: Label = $TitleLabel
@onready var subtitle_label: Label = $SubtitleLabel
@onready var chest: TextureRect = $Chest
@onready var sparkles: CPUParticles2D = $Sparkles
@onready var hint_label: Label = $HintLabel
@onready var stats_label: Label = $StatsLabel
@onready var buttons_layer: Control = $MenuButtons
@onready var panel_layer: Control = $PanelLayer
@onready var settings_panel: PanelContainer = $PanelLayer/Center/SettingsPanel
@onready var authors_panel: PanelContainer = $PanelLayer/Center/AuthorsPanel
@onready var bonus_panel: PanelContainer = $PanelLayer/Center/BonusPanel
@onready var start_panel: PanelContainer = $PanelLayer/Center/StartPanel
@onready var start_vbox: VBoxContainer = $PanelLayer/Center/StartPanel/VBox
@onready var slots_box: VBoxContainer = $PanelLayer/Center/StartPanel/SlotsBox
@onready var slots_list: VBoxContainer = $PanelLayer/Center/StartPanel/SlotsBox/SlotsList
@onready var continue_button: Button = $PanelLayer/Center/StartPanel/VBox/ContinueButton
@onready var start_hint: Label = $PanelLayer/Center/StartPanel/VBox/StartHint
@onready var claim_button: Button = $PanelLayer/Center/BonusPanel/VBox/ClaimButton
@onready var bonus_result: Label = $PanelLayer/Center/BonusPanel/VBox/ResultLabel
@onready var sound_check: CheckButton = $PanelLayer/Center/SettingsPanel/VBox/SoundCheck
@onready var music_check: CheckButton = $PanelLayer/Center/SettingsPanel/VBox/MusicCheck
@onready var reset_button: Button = $PanelLayer/Center/SettingsPanel/VBox/ResetButton

func _ready() -> void:
    resized.connect(_resize_layout)
    chest.pivot_offset = chest.size / 2.0
    sparkles.position = chest.position + chest.size / 2.0
    Game.gold_changed.connect(_on_gold_changed)
    Game.inventory_changed.connect(_refresh_stats)
    _refresh_stats()
    sound_check.set_pressed_no_signal(bool(Game.settings.get("sound", true)))
    music_check.set_pressed_no_signal(bool(Game.settings.get("music", true)))
    UiStyle.style_button(reset_button, 13)
    for button in [
        $PanelLayer/Center/SettingsPanel/VBox/CloseButton,
        $PanelLayer/Center/AuthorsPanel/VBox/CloseButton,
        $PanelLayer/Center/BonusPanel/VBox/CloseButton,
        $PanelLayer/Center/BonusPanel/VBox/ClaimButton,
        $PanelLayer/Center/StartPanel/VBox/NewGameButton,
        $PanelLayer/Center/StartPanel/VBox/ContinueButton,
        $PanelLayer/Center/StartPanel/VBox/LoadButton,
        $PanelLayer/Center/StartPanel/VBox/StartCloseButton,
        $PanelLayer/Center/StartPanel/SlotsBox/SlotsBackButton,
    ]:
        UiStyle.style_button(button, 14)
    _play_entrance()
    Platform.notify_ready()
    Platform.gameplay_stop()

func _exit_tree() -> void:
    # Сигналы Game (автозагрузка) переживают смену сцены: не отвязанные
    # обработчики погибшего меню падают на первом же изменении золота в мире.
    if Game.gold_changed.is_connected(_on_gold_changed):
        Game.gold_changed.disconnect(_on_gold_changed)
    if Game.inventory_changed.is_connected(_refresh_stats):
        Game.inventory_changed.disconnect(_refresh_stats)

func _unhandled_input(event: InputEvent) -> void:
    if panel_layer.visible and event.is_action_pressed("ui_cancel"):
        _close_panel()

# --- Появление сцены ---

func _play_entrance() -> void:
    title_label.modulate.a = 0.0
    subtitle_label.modulate.a = 0.0
    chest.modulate.a = 0.0
    chest.scale = Vector2(0.4, 0.4)
    var tween := create_tween()
    tween.set_parallel(true)
    tween.tween_property(title_label, "modulate:a", 1.0, 0.4)
    tween.tween_property(subtitle_label, "modulate:a", 1.0, 0.4).set_delay(0.15)
    tween.tween_property(chest, "modulate:a", 1.0, 0.3)
    tween.tween_property(chest, "scale", Vector2.ONE, 0.45).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

# --- Тапы по сундуку ---

func _on_chest_gui_input(event: InputEvent) -> void:
    if not (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
        return
    if revealed_count == 0:
        _play_open_animation()
    if revealed_count < MENU_ITEMS.size():
        _reveal_next_item()
    else:
        _chest_bounce()

func _play_open_animation() -> void:
    var tween := create_tween()
    tween.tween_property(chest, "scale", Vector2(1.25, 0.75), 0.07)
    tween.tween_callback(func() -> void: chest.texture = CHEST_OPEN_TEXTURE)
    tween.tween_property(chest, "scale", Vector2(0.9, 1.12), 0.08)
    tween.tween_property(chest, "scale", Vector2.ONE, 0.1)

func _chest_bounce() -> void:
    var tween := create_tween()
    tween.tween_property(chest, "scale", Vector2(1.15, 0.9), 0.06)
    tween.tween_property(chest, "scale", Vector2.ONE, 0.1)

func _reveal_next_item() -> void:
    var item: Dictionary = MENU_ITEMS[revealed_count]
    var button := _make_menu_button(item)
    buttons_layer.add_child(button)
    button.size = BUTTON_SIZE
    button.pivot_offset = BUTTON_SIZE / 2.0
    var chest_center: Vector2 = chest.position + chest.size / 2.0
    button.position = chest_center - BUTTON_SIZE / 2.0
    button.scale = Vector2(0.15, 0.15)
    button.rotation = -0.3
    button.modulate.a = 0.0
    var target := _slot_position(revealed_count)
    var tween := button.create_tween()
    tween.set_parallel(true)
    tween.tween_property(button, "position", target, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
    tween.tween_property(button, "scale", Vector2.ONE, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
    tween.tween_property(button, "rotation", 0.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
    tween.tween_property(button, "modulate:a", 1.0, 0.2)
    sparkles.restart()
    revealed_count += 1
    _update_hint()

func _slot_position(index: int) -> Vector2:
    var viewport_size := get_viewport_rect().size
    var x := (viewport_size.x - BUTTON_SIZE.x) / 2.0
    var y := FIRST_SLOT_Y + (size.y - 640.0) / 2.0 + index * (BUTTON_SIZE.y + BUTTON_GAP)
    return Vector2(x, y)

func _make_menu_button(item: Dictionary) -> Button:
    var button := Button.new()
    button.text = item["text"]
    button.custom_minimum_size = BUTTON_SIZE
    UiStyle.style_button(button, 17)
    button.pressed.connect(_on_menu_button.bind(item["id"]))
    return button

func _update_hint() -> void:
    match revealed_count:
        0:
            hint_label.text = "Тапни по сундуку!"
        1:
            hint_label.text = "Тапни ещё — будут настройки"
        2:
            hint_label.text = "Ещё раз — авторы!"
        3:
            hint_label.text = "Последний тап — бонус!"
        _:
            hint_label.text = "Приятной игры!"

# --- Действия меню ---

func _on_menu_button(id: String) -> void:
    match id:
        "start":
            _show_panel(start_panel)
        "settings":
            _show_panel(settings_panel)
        "authors":
            _show_panel(authors_panel)
        "bonus":
            _show_panel(bonus_panel)

# --- Панель старта: Новая игра / Продолжить / Загрузить ---

func _show_start_menu_view() -> void:
    start_vbox.visible = true
    slots_box.visible = false
    var can_continue: bool = int(Game.meta.get("last_slot", 0)) >= 1 \
        and Platform.has_slot(int(Game.meta.get("last_slot", 0)))
    continue_button.disabled = not can_continue
    continue_button.modulate.a = 1.0 if can_continue else 0.45
    start_hint.text = "Последняя игра: слот %d" % int(Game.meta.get("last_slot", 0)) if can_continue else "Сохранений пока нет"

func _on_new_game_pressed() -> void:
    get_tree().change_scene_to_file(CHARACTER_SELECT_SCENE)

func _on_continue_pressed() -> void:
    var slot := int(Game.meta.get("last_slot", 0))
    if slot >= 1 and Game.continue_run(slot):
        get_tree().change_scene_to_file(WORLD_SCENE)

func _on_load_pressed() -> void:
    start_vbox.visible = false
    slots_box.visible = true
    _rebuild_slots_list()

func _on_slots_back_pressed() -> void:
    _show_start_menu_view()

func _rebuild_slots_list() -> void:
    for child in slots_list.get_children():
        child.queue_free()
    for slot in range(1, Game.SLOT_COUNT + 1):
        var info := Saves.get_slot_info(slot)
        var button := Button.new()
        UiStyle.style_button(button, 13)
        button.custom_minimum_size = Vector2(238, 42)
        if bool(info.get("exists", false)):
            button.text = "Слот %d · %s · %d з." % [slot, info.get("hero", "?"), info.get("gold", 0)]
            button.pressed.connect(_on_slot_chosen.bind(slot))
        else:
            button.text = "Слот %d · пусто" % slot
            button.disabled = true
            button.modulate.a = 0.45
        slots_list.add_child(button)

func _on_slot_chosen(slot: int) -> void:
    if Game.continue_run(slot):
        get_tree().change_scene_to_file(WORLD_SCENE)

# --- Ежедневный бонус ---

func _refresh_bonus_panel() -> void:
    var can_claim := Game.can_claim_bonus()
    claim_button.visible = can_claim
    if can_claim:
        bonus_result.text = "Подарок ждёт!"
        bonus_result.add_theme_color_override("font_color", Color(0.85, 0.87, 0.9))
    else:
        bonus_result.text = "Награда на сегодня получена.\nВозвращайся завтра!"
        bonus_result.add_theme_color_override("font_color", Color(0.55, 0.6, 0.67))

func _on_claim_bonus_pressed() -> void:
    var reward := Game.claim_daily_bonus()
    if reward.is_empty():
        _refresh_bonus_panel()
        return
    var item_title: String = ItemDB.title(String(reward["item_id"]))
    bonus_result.text = "+%d золота!\nФиолетовая добыча: %s" % [reward["gold"], item_title]
    bonus_result.add_theme_color_override("font_color", COLOR_VIOLET)
    claim_button.visible = false
    sparkles.restart()
    _refresh_stats()

# --- Панели ---

func _show_panel(panel: PanelContainer) -> void:
    for other in [settings_panel, authors_panel, bonus_panel, start_panel]:
        other.visible = other == panel
    if panel == start_panel:
        _show_start_menu_view()
    elif panel == bonus_panel:
        _refresh_bonus_panel()
    panel_layer.visible = true
    panel_layer.modulate.a = 0.0
    await get_tree().process_frame
    panel.pivot_offset = panel.size / 2.0
    panel.scale = Vector2(0.85, 0.85)
    var tween := create_tween()
    tween.set_parallel(true)
    tween.tween_property(panel_layer, "modulate:a", 1.0, 0.18)
    tween.tween_property(panel, "scale", Vector2.ONE, 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _close_panel() -> void:
    panel_layer.visible = false
    for other in [settings_panel, authors_panel, bonus_panel, start_panel]:
        other.visible = false

func _on_sound_toggled(pressed: bool) -> void:
    Game.set_setting("sound", pressed)

func _on_music_toggled(pressed: bool) -> void:
    Game.set_setting("music", pressed)

func _on_reset_pressed() -> void:
    if not reset_armed:
        reset_armed = true
        reset_button.text = "ТОЧНО СБРОСИТЬ?"
        reset_button.add_theme_color_override("font_color", Color(0.95, 0.35, 0.35))
        get_tree().create_timer(2.5).timeout.connect(_disarm_reset)
    else:
        Game.reset_progress()
        _disarm_reset()
        _close_panel()

func _disarm_reset() -> void:
    reset_armed = false
    reset_button.text = "СБРОСИТЬ ПРОГРЕСС"
    reset_button.add_theme_color_override("font_color", Color(0.9, 0.92, 0.96))

# --- Статистика ---

func _on_gold_changed(_new_gold: int) -> void:
    _refresh_stats()

func _refresh_stats() -> void:
    stats_label.text = "Золото: %d · Добыча: %d" % [Game.gold, Game.inventory.size()]

func _resize_layout() -> void:
    sparkles.position = chest.position + chest.size / 2.0
    for i in buttons_layer.get_child_count():
        var button := buttons_layer.get_child(i) as Control
        button.position = _slot_position(i)
