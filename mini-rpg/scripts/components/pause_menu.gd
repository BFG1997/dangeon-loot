## PauseMenu — игровая пауза на Escape (шаг 30).
##
## Открытие: Escape (ui_cancel) в мире или подземелье, если никакое окно
## (диалог/сумка/торговля/смерть/финал) уже не открыто — хост сообщает это
## через _pause_input_blocked(). Дерево ставится на паузу
## (get_tree().paused), поэтому мир и враги замирают; сама панель
## обрабатывает ввод (PROCESS_MODE_ALWAYS).
##
## Пункты: ПРОДОЛЖИТЬ (снять паузу), ЗАГРУЗИТЬ и СОХРАНИТЬ (колбэки хоста
## _on_load_pressed/_on_save_pressed — та же логика, что была у кнопок
## HUD), НАСТРОЙКИ (звук/музыка/управление — как в главном меню) и
## В ГЛАВНОЕ МЕНЮ (колбэк хоста _on_menu_pressed).
class_name PauseMenu
extends CanvasLayer

const CONTROLS_EDITOR_SCENE := "res://scenes/controls/controls_editor.tscn"

const BUTTON_SIZE := Vector2(240, 34)
const BUTTON_GAP := 10

var host: Node = null
var root: Control
var main_panel: PanelContainer
var settings_panel: PanelContainer
var controls_editor: PanelContainer
var sound_check: CheckButton
var music_check: CheckButton

## Сборка и привязка к сцене-хосту (мир/данж). Панель скрыта до паузы.
static func attach(host_node: Node) -> PauseMenu:
    var menu := PauseMenu.new()
    menu.name = "PauseMenu"
    menu.host = host_node
    menu.layer = 30
    # Панель живёт в паузе: и открытие, и закрытие работают, пока дерево
    # заморожено. Мир/данж при этом стоят (PAUSABLE по умолчанию).
    menu.process_mode = Node.PROCESS_MODE_ALWAYS
    host_node.add_child(menu)
    menu._build()
    return menu

func _build() -> void:
    root = Control.new()
    root.name = "Root"
    root.set_anchors_preset(Control.PRESET_FULL_RECT)
    root.visible = false
    add_child(root)
    var dim := ColorRect.new()
    dim.name = "Dim"
    dim.color = Color(0.02, 0.02, 0.05, 0.72)
    dim.set_anchors_preset(Control.PRESET_FULL_RECT)
    root.add_child(dim)

    var center := CenterContainer.new()
    center.name = "Center"
    center.set_anchors_preset(Control.PRESET_FULL_RECT)
    root.add_child(center)

    var main_pair := _make_panel(center)
    main_panel = main_pair[0]
    var vbox: VBoxContainer = main_pair[1]
    var title := Label.new()
    title.text = "ПАУЗА"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 20)
    title.add_theme_color_override("font_color", UiStyle.COLOR_GOLD)
    vbox.add_child(title)
    for spec in [
        {"text": "ПРОДОЛЖИТЬ", "cb": close},
        {"text": "ЗАГРУЗИТЬ", "cb": _on_load_pressed},
        {"text": "СОХРАНИТЬ", "cb": _on_save_pressed},
        {"text": "НАСТРОЙКИ", "cb": _show_settings},
        {"text": "В ГЛАВНОЕ МЕНЮ", "cb": _on_main_menu_pressed},
    ]:
        vbox.add_child(_menu_button(String(spec["text"]), spec["cb"]))

    var settings_pair := _make_panel(center)
    settings_panel = settings_pair[0]
    settings_panel.visible = false
    var sbox: VBoxContainer = settings_pair[1]
    var settings_title := Label.new()
    settings_title.text = "НАСТРОЙКИ"
    settings_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    settings_title.add_theme_font_size_override("font_size", 18)
    settings_title.add_theme_color_override("font_color", UiStyle.COLOR_GOLD)
    sbox.add_child(settings_title)
    sound_check = CheckButton.new()
    sound_check.text = "Звук"
    sound_check.button_pressed = bool(Game.settings.get("sound", true))
    sound_check.toggled.connect(func(pressed: bool) -> void:
        Game.set_setting("sound", pressed))
    sbox.add_child(sound_check)
    music_check = CheckButton.new()
    music_check.text = "Музыка"
    music_check.button_pressed = bool(Game.settings.get("music", true))
    music_check.toggled.connect(func(pressed: bool) -> void:
        Game.set_setting("music", pressed))
    sbox.add_child(music_check)
    sbox.add_child(_menu_button("УПРАВЛЕНИЕ", _show_controls))
    sbox.add_child(_menu_button("НАЗАД", _show_main))

    # Редактор управления — тот же, что в главном меню (шаг 25/26).
    controls_editor = (load(CONTROLS_EDITOR_SCENE) as PackedScene).instantiate()
    controls_editor.visible = false
    center.add_child(controls_editor)
    controls_editor.back_requested.connect(_show_settings)

## Панель в стиле главного меню: тёмный фон, золотая рамка. Возвращает
## [PanelContainer, VBoxContainer] — ссылку на контейнер строк нужно
## держать отдельно, иначе VBox прячется внутри MarginContainer.
func _make_panel(center: CenterContainer) -> Array:
    var panel := PanelContainer.new()
    panel.add_theme_stylebox_override("panel", UiStyle.panel_style())
    var margin := MarginContainer.new()
    margin.add_theme_constant_override("margin_left", 22)
    margin.add_theme_constant_override("margin_right", 22)
    margin.add_theme_constant_override("margin_top", 16)
    margin.add_theme_constant_override("margin_bottom", 18)
    panel.add_child(margin)
    var vbox := VBoxContainer.new()
    vbox.add_theme_constant_override("separation", BUTTON_GAP)
    margin.add_child(vbox)
    center.add_child(panel)
    return [panel, vbox]

func _menu_button(text: String, cb: Callable) -> Button:
    var button := Button.new()
    button.text = text
    button.custom_minimum_size = BUTTON_SIZE
    UiStyle.style_button(button, 14)
    button.pressed.connect(cb)
    return button

# ------------------------------------------------ открытие и закрытие

func open() -> void:
    if root.visible:
        return
    # Диалог/сумка/торговля/смерть/финал уже перехватили экран — Escape
    # достаётся им, а не паузе.
    if is_instance_valid(host) and host.has_method("_pause_input_blocked") \
            and bool(host._pause_input_blocked()):
        return
    _show_main()
    root.visible = true
    get_tree().paused = true

func close() -> void:
    root.visible = false
    get_tree().paused = false

func _show_main() -> void:
    main_panel.visible = true
    settings_panel.visible = false
    controls_editor.visible = false

func _show_settings() -> void:
    main_panel.visible = false
    settings_panel.visible = true
    controls_editor.visible = false

func _show_controls() -> void:
    settings_panel.visible = false
    controls_editor.visible = true

## Сцена покидает дерево — пауза не должна переживать смену сцены
## (например, ЗАГРУЗИТЬ переключает сцену: close() снимает паузу заранее,
## это подстраховка на любой другой путь).
func _exit_tree() -> void:
    if get_tree() != null:
        get_tree().paused = false

# ------------------------------------------------------- пункты меню

## ЗАГРУЗИТЬ: тот же код, что был у кнопки ЗАГРУЗИТЬ (снимаем паузу —
## подсказка «сейв повреждён» должна гаснуть уже в живом мире).
func _on_load_pressed() -> void:
    close()
    if is_instance_valid(host) and host.has_method("_on_load_pressed"):
        host._on_load_pressed()

## СОХРАНИТЬ: как бывшая кнопка — сохранение в текущий слот + подсказка.
func _on_save_pressed() -> void:
    close()
    if is_instance_valid(host) and host.has_method("_on_save_pressed"):
        host._on_save_pressed()

## В ГЛАВНОЕ МЕНЮ: у данжа хост ещё и сбрасывает этаж (Game.dungeon_floor).
func _on_main_menu_pressed() -> void:
    close()
    if is_instance_valid(host) and host.has_method("_on_menu_pressed"):
        host._on_menu_pressed()

# ------------------------------------------------------------ ввод

## Escape открывает/закрывает паузу. Пока редактор управления открыт,
## Escape его не закрывает — как в главном меню.
func _unhandled_input(event: InputEvent) -> void:
    if not event.is_action_pressed("ui_cancel"):
        return
    if controls_editor.visible:
        return
    if get_tree().paused and root.visible:
        close()
        get_viewport().set_input_as_handled()
    elif not get_tree().paused:
        var was_visible := root.visible
        open()
        if root.visible and not was_visible:
            get_viewport().set_input_as_handled()
