## Диалоговое окно «Dungeon Loot»: крупный детализированный портрет NPC
## рядом с текстом, имя, роль, эффект печатной машинки.
## Открытие: DialogueUI.open({...}) из world.gd; закрытие — клик/E/F/Esc после строк.
## Торговля (шаг 5): если в словаре есть непустой "goods", в диалоге
## появляется кнопка «ТОРГОВАТЬ» — сигнал trade_requested (ловит world.gd).
## Шаг 6 (фиксы мигания): подсказка «тап / E» пульсирует плавно, а клавиши
## помечаются обработанными — закрытие диалога не переоткрывает его же.
## Шаг 7: раньше E била в мире — теперь (шаг 11) листание реплик на E/F
## (действие "interact"), а удар уехал на ЛКМ. Открытое окно приоритетнее.
## Шаг 10 (фикс выхода за экран у демона): имя и роль теперь в две строки
## с автопереносом (имя «Таинственный демон · поклонник смелости» больше
## не вылезает за панель по ширине), а высота панели подгоняется под
## контент и растёт ВВЕРХ — низ панели закреплён над нижней консолью HUD.
## Шаг 11 (гарантия «не уезжает никогда»): резерв консоли world.gd передаёт
## через bottom_reserve (UI_BAR_H + зазор), а максимальная высота панели
## считается от реального размера вьюпорта — даже на нестандартном экране
## панель не выйдет ни вверх, ни вниз. Листание реплик: E/F, Enter и клик
## по затемнению (удар ЛКМ в мире больше не листает диалог).
class_name DialogueUI
extends CanvasLayer

signal closed
signal trade_requested

const COLOR_GOLD := Color(1, 0.84, 0)
const CHARS_PER_SEC := 40.0

## Шаг 11: геометрия панели. Низ закреплён на bottom_reserve (задаёт
## world.gd: UI_BAR_H + зазор 8; значение по умолчанию — как в шаге 10),
## высота — по контенту в диапазоне [PANEL_MIN_H; эффективный максимум],
## избыток растёт вверх. Эффективный максимум — не больше, чем влезает
## между консолью и верхним краем экрана.
const PANEL_MIN_H := 176.0
const PANEL_MAX_H := 460.0
var bottom_reserve := 156.0

var _dim: ColorRect
var _panel: PanelContainer
var _portrait: TextureRect
var _name_label: Label
var _role_label: Label
var _text_label: Label
var _more_label: Label
var _trade_button: Button
var _lines: Array = []
var _line_idx := 0
var _reveal := 0.0
var _active := false

func _ready() -> void:
    layer = 25
    visible = false
    _dim = ColorRect.new()
    _dim.set_anchors_preset(Control.PRESET_FULL_RECT)
    _dim.color = Color(0.02, 0.02, 0.06, 0.45)
    _dim.gui_input.connect(_on_dim_input)
    _dim.mouse_filter = Control.MOUSE_FILTER_STOP
    add_child(_dim)

    _panel = PanelContainer.new()
    _panel.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
    _panel.offset_left = 10
    _panel.offset_right = -10
    _panel.offset_top = -(bottom_reserve + PANEL_MIN_H)
    _panel.offset_bottom = -bottom_reserve
    _panel.add_theme_stylebox_override("panel", UiStyle.panel_style())
    # шаг 11: клик по самому телу диалога тоже листает реплики (как тап
    # по затемнению); кнопка ТОРГОВАТЬ перехватывает свой клик сама
    _panel.gui_input.connect(_on_panel_input)
    _dim.add_child(_panel)

    var hbox := HBoxContainer.new()
    hbox.add_theme_constant_override("separation", 12)
    _panel.add_child(hbox)

    # --- портрет в золотой рамке
    var frame := PanelContainer.new()
    frame.mouse_filter = Control.MOUSE_FILTER_PASS
    var frame_style := UiStyle.flat_style(Color(0.05, 0.05, 0.1), COLOR_GOLD)
    frame_style.set_border_width_all(3)
    frame_style.content_margin_left = 4
    frame_style.content_margin_right = 4
    frame_style.content_margin_top = 4
    frame_style.content_margin_bottom = 4
    frame.add_theme_stylebox_override("panel", frame_style)
    frame.size_flags_vertical = Control.SIZE_SHRINK_CENTER
    hbox.add_child(frame)

    _portrait = TextureRect.new()
    _portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
    _portrait.custom_minimum_size = Vector2(128, 128)
    _portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    _portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    _portrait.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
    frame.add_child(_portrait)

    # --- текстовая часть
    var vbox := VBoxContainer.new()
    vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    vbox.add_theme_constant_override("separation", 4)
    hbox.add_child(vbox)

    # шаг 10: имя и роль — двумя строками с автопереносом: у демона было
    # «Таинственный демон» + «поклонник смелости» в одну строку, и она
    # вылезала за панель по ширине. Стопкой — помещается любой диалог.
    _name_label = Label.new()
    _name_label.add_theme_font_size_override("font_size", 15)
    _name_label.add_theme_color_override("font_color", COLOR_GOLD)
    _name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    vbox.add_child(_name_label)

    _role_label = Label.new()
    _role_label.add_theme_font_size_override("font_size", 10)
    _role_label.add_theme_color_override("font_color", Color(0.62, 0.66, 0.74))
    _role_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    vbox.add_child(_role_label)

    _text_label = Label.new()
    _text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    _text_label.add_theme_font_size_override("font_size", 13)
    _text_label.add_theme_color_override("font_color", Color(0.9, 0.92, 0.96))
    _text_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
    vbox.add_child(_text_label)

    # нижний ряд: подсказка «тап / E» и (у торговцев) кнопка торговли
    var bottom_row := HBoxContainer.new()
    bottom_row.add_theme_constant_override("separation", 8)
    vbox.add_child(bottom_row)

    _more_label = Label.new()
    _more_label.text = "▼ тап / E"
    _more_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
    _more_label.add_theme_font_size_override("font_size", 10)
    _more_label.add_theme_color_override("font_color", COLOR_GOLD)
    _more_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    _more_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
    bottom_row.add_child(_more_label)

    _trade_button = Button.new()
    _trade_button.text = "ТОРГОВАТЬ"
    _trade_button.custom_minimum_size = Vector2(104, 30)
    UiStyle.style_button(_trade_button, 12)
    _trade_button.visible = false
    _trade_button.pressed.connect(_on_trade_pressed)
    bottom_row.add_child(_trade_button)

## Открыть диалог: npc = {"name", "role", "portrait", "lines", "goods"}
## goods — непустой список id товаров, если NPC торгует (показываем «ТОРГОВАТЬ»).
func open(npc: Dictionary) -> void:
    _lines = npc.get("lines", ["..."])
    _line_idx = 0
    _name_label.text = String(npc.get("name", "???"))
    _role_label.text = String(npc.get("role", ""))
    var tex_path := String(npc.get("portrait", ""))
    _portrait.texture = load(tex_path) if tex_path != "" else null
    var goods: Array = npc.get("goods", [])
    _trade_button.visible = not goods.is_empty()
    _active = true
    visible = true
    _start_line()
    # шаг 10: высота по контенту — до анимации появления, чтобы всплывание
    # ехало от уже правильной позиции
    _fit_panel()
    # появление: панель всплывает, портрет слегка пружинит
    _panel.modulate.a = 0.0
    _panel.position.y += 14
    var tw := create_tween()
    tw.set_parallel(true)
    tw.tween_property(_panel, "modulate:a", 1.0, 0.16)
    tw.tween_property(_panel, "position:y", _panel.position.y - 14.0, 0.2) \
        .set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
    _portrait.pivot_offset = _portrait.size / 2.0
    _portrait.scale = Vector2(0.7, 0.7)
    var tw2 := create_tween()
    tw2.tween_property(_portrait, "scale", Vector2.ONE, 0.28) \
        .set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _start_line() -> void:
    _text_label.text = String(_lines[_line_idx])
    _text_label.visible_characters = 0
    _reveal = 0.0
    _more_label.visible = false
    _fit_panel()

## Шаг 10/11: высота панели — по контенту, растёт вверх (низ закреплён над
## консолью HUD). Текстовая метка с автопереносом считает высоту по своей
## ширине, а ширина панели неизменна (340 px, задана якорями), поэтому
## get_combined_minimum_size() даёт точную оценку сразу после смены текста.
## Шаг 11: потолок высоты — реальный размер вьюпорта минус резерв консоли
## и зазор 8 px сверху: панель гарантированно не выйдет за экран ни при
## каком контенте (хоть на телефоне, хоть на нестандартном окне).
func _fit_panel() -> void:
    var view_h := 640.0
    var vp := get_viewport()
    if vp != null:
        view_h = vp.get_visible_rect().size.y
    var max_h := maxf(PANEL_MIN_H, minf(PANEL_MAX_H, view_h - bottom_reserve - 8.0))
    var min_h := _panel.get_combined_minimum_size().y
    var target := clampf(min_h + 2.0, PANEL_MIN_H, max_h)
    _panel.offset_top = -(bottom_reserve + target)

func _process(delta: float) -> void:
    if not _active:
        return
    if _text_label.visible_characters < _text_label.text.length():
        _reveal += delta * CHARS_PER_SEC
        _text_label.visible_characters = int(_reveal)
        _more_label.visible = _text_label.visible_characters >= _text_label.text.length()
        _more_label.modulate.a = 1.0
    else:
        # Шаг 6 (фикс мигания): плавная пульсация яркости вместо
        # резкого включения/выключения видимости.
        _more_label.visible = true
        _more_label.modulate.a = 0.55 + 0.45 * sin(Time.get_ticks_msec() / 1000.0 * 5.0)

func _on_dim_input(event: InputEvent) -> void:
    if not _active:
        return
    _dim.accept_event()
    if _is_advance_click(event):
        _advance()

func _on_panel_input(event: InputEvent) -> void:
    if not _active:
        return
    _panel.accept_event()
    if _is_advance_click(event):
        _advance()

func _is_advance_click(event: InputEvent) -> bool:
    return event is InputEventMouseButton and event.pressed and \
        (event.button_index == MOUSE_BUTTON_LEFT or event.is_action_pressed("interact"))

func _input(event: InputEvent) -> void:
    # Non-primary mapped buttons would otherwise be swallowed by GUI controls.
    # LMB goes through GUI so the trade button retains priority over advancing.
    if _active and event is InputEventMouseButton \
            and event.button_index != MOUSE_BUTTON_LEFT and event.is_action_pressed("interact"):
        get_viewport().set_input_as_handled()
        _advance()

func _unhandled_input(event: InputEvent) -> void:
    if not _active:
        return
    # Mark handled BEFORE _advance/_close can hide the modal or emit signals.
    get_viewport().set_input_as_handled()
    if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
        _advance()
    elif event.is_action_pressed("ui_cancel"):
        _close()

func _on_trade_pressed() -> void:
    get_viewport().set_input_as_handled()
    trade_requested.emit()

func _advance() -> void:
    if _text_label.visible_characters < _text_label.text.length():
        _text_label.visible_characters = _text_label.text.length()
        _reveal = float(_text_label.text.length())
        return
    _line_idx += 1
    if _line_idx >= _lines.size():
        _close()
    else:
        _start_line()

func _close() -> void:
    _active = false
    visible = false
    closed.emit()

## Публичное закрытие (world.gd закрывает диалог перед открытием лавки).
func close() -> void:
    _close()
