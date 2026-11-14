## Окно торговли «Dungeon Loot» (шаг 5): покупка товаров у NPC и продажа
## своих вещей за половину цены. Открывается из диалога торговца
## (кнопка «ТОРГОВАТЬ», см. dialogue_ui.gd): TradeUI.open(trader).
## trader = {"name", "role", "goods": ["item_id", ...]}.
## Запас у торговцев бесконечный; непродажные уники помечены в ItemDB.
## Шаг 8: лавка демона — trader содержит "demon": true. Ассортимент —
## товары павших торговцев, цены со скидкой Game.demon_discount_pct()
## (-10% за каждого убитого NPC): покупка через Game.buy_from_demon().
class_name TradeUI
extends CanvasLayer

signal closed

const COLOR_GOLD := Color(1, 0.84, 0)
const COLOR_DIM_TEXT := Color(0.62, 0.66, 0.74)
const COLOR_EARN := Color(0.55, 0.85, 0.5)

var _dim: ColorRect
var _center: CenterContainer
var _panel: PanelContainer
var _trader_label: Label
var _gold_label: Label
var _tab_buy: Button
var _tab_sell: Button
var _rows: VBoxContainer
var _scroll: ScrollContainer
var _hint_label: Label
var _trader: Dictionary = {}
var _tab := "buy"   # "buy" | "sell"
var _is_demon := false   # шаг 8: лавка демона (скидочные цены)

func _ready() -> void:
    layer = 27
    visible = false
    _dim = ColorRect.new()
    _dim.set_anchors_preset(Control.PRESET_FULL_RECT)
    _dim.color = Color(0.02, 0.02, 0.06, 0.5)
    _dim.gui_input.connect(_on_dim_input)
    add_child(_dim)

    _center = CenterContainer.new()
    _center.set_anchors_preset(Control.PRESET_FULL_RECT)
    _center.mouse_filter = Control.MOUSE_FILTER_IGNORE
    _dim.add_child(_center)

    _panel = PanelContainer.new()
    _panel.custom_minimum_size = Vector2(340, 0)
    _panel.add_theme_stylebox_override("panel", UiStyle.panel_style())
    _center.add_child(_panel)

    var vbox := VBoxContainer.new()
    vbox.add_theme_constant_override("separation", 8)
    _panel.add_child(vbox)

    # --- шапка: название лавки и кошелёк героя
    var header := HBoxContainer.new()
    header.add_theme_constant_override("separation", 8)
    vbox.add_child(header)
    var title_box := VBoxContainer.new()
    title_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    title_box.add_theme_constant_override("separation", 0)
    header.add_child(title_box)
    var title := Label.new()
    title.text = "ТОРГОВЛЯ"
    title.add_theme_font_size_override("font_size", 16)
    title.add_theme_color_override("font_color", COLOR_GOLD)
    title_box.add_child(title)
    _trader_label = Label.new()
    _trader_label.add_theme_font_size_override("font_size", 11)
    _trader_label.add_theme_color_override("font_color", COLOR_DIM_TEXT)
    _trader_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    title_box.add_child(_trader_label)
    _gold_label = Label.new()
    _gold_label.add_theme_font_size_override("font_size", 13)
    _gold_label.add_theme_color_override("font_color", COLOR_GOLD)
    _gold_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
    header.add_child(_gold_label)

    # --- вкладки: ПОКУПКА / ПРОДАЖА
    var tabs := HBoxContainer.new()
    tabs.add_theme_constant_override("separation", 8)
    vbox.add_child(tabs)
    _tab_buy = Button.new()
    _tab_buy.text = "ПОКУПКА"
    _tab_buy.custom_minimum_size = Vector2(0, 30)
    _tab_buy.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    UiStyle.style_button(_tab_buy, 12)
    _tab_buy.pressed.connect(func() -> void: _switch_tab("buy"))
    tabs.add_child(_tab_buy)
    _tab_sell = Button.new()
    _tab_sell.text = "ПРОДАЖА"
    _tab_sell.custom_minimum_size = Vector2(0, 30)
    _tab_sell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    UiStyle.style_button(_tab_sell, 12)
    _tab_sell.pressed.connect(func() -> void: _switch_tab("sell"))
    tabs.add_child(_tab_sell)

    # --- список товаров / сумки
    _scroll = ScrollContainer.new()
    _scroll.custom_minimum_size = Vector2(0, 330)
    _scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
    vbox.add_child(_scroll)
    _rows = VBoxContainer.new()
    _rows.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    _rows.add_theme_constant_override("separation", 6)
    _scroll.add_child(_rows)

    # --- подсказка и закрытие
    _hint_label = Label.new()
    _hint_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    _hint_label.add_theme_font_size_override("font_size", 10)
    _hint_label.add_theme_color_override("font_color", COLOR_DIM_TEXT)
    vbox.add_child(_hint_label)
    var close_btn := Button.new()
    close_btn.text = "ЗАКРЫТЬ"
    close_btn.custom_minimum_size = Vector2(0, 36)
    UiStyle.style_button(close_btn, 13)
    close_btn.pressed.connect(_on_close_pressed)
    vbox.add_child(close_btn)

    Game.gold_changed.connect(_on_state_changed)
    Game.inventory_changed.connect(_on_state_changed)

func _exit_tree() -> void:
    # Сигналы Game (автозагрузка) переживают смену сцены: не отвязанные
    # обработчики погибшей лавки падают на первом же изменении золота.
    if Game.gold_changed.is_connected(_on_state_changed):
        Game.gold_changed.disconnect(_on_state_changed)
    if Game.inventory_changed.is_connected(_on_state_changed):
        Game.inventory_changed.disconnect(_on_state_changed)

func open(trader: Dictionary) -> void:
    _trader = trader
    _is_demon = bool(trader.get("demon", false))
    _trader_label.text = "%s · %s" % [String(trader.get("name", "???")),
                                      String(trader.get("role", ""))]
    # шаг 11: панель лавки не выше экрана — на маленьких вьюпортах список
    # сжимается, шапка/вкладки/кнопка всегда остаются на виду
    var vp := get_viewport()
    if vp != null:
        var budget := vp.get_visible_rect().size.y - 224.0
        _scroll.custom_minimum_size.y = clampf(330.0, 140.0, maxf(140.0, budget))
    _tab = "buy"
    _refresh()
    visible = true
    await get_tree().process_frame
    _panel.pivot_offset = _panel.size / 2.0
    _panel.scale = Vector2(0.85, 0.85)
    var tw := create_tween()
    tw.tween_property(_panel, "scale", Vector2.ONE, 0.2) \
        .set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func close() -> void:
    visible = false
    closed.emit()

func _switch_tab(tab: String) -> void:
    _tab = tab
    _refresh()

## Перестроить список и обновить кошелёк (вызывается и при смене золота/сумки).
func _refresh() -> void:
    _gold_label.text = "Золото: %d" % Game.gold
    var active_style := UiStyle.flat_style(Color(0.2, 0.16, 0.05), COLOR_GOLD)
    var idle_style := UiStyle.flat_style(Color(0.11, 0.12, 0.19), Color(0.35, 0.38, 0.5))
    _tab_buy.add_theme_stylebox_override("normal", active_style if _tab == "buy" else idle_style)
    _tab_sell.add_theme_stylebox_override("normal", active_style if _tab == "sell" else idle_style)
    # queue_free, а не free: _refresh() вызывается из обработчика нажатия
    # кнопки строки — мгновенный free убил бы кнопку прямо во время
    # испускания сигнала pressed (ошибка «freed while signal is emitted»).
    for child in _rows.get_children():
        _rows.remove_child(child)
        child.queue_free()
    if _tab == "buy":
        if _is_demon:
            _hint_label.text = "Лавка демона: скидка %d%% — минус 10%% за каждого убитого жителя. Товары павших торговцев. Запас бесконечен." % Game.demon_discount_pct()
        else:
            _hint_label.text = "Запас лавки бесконечен. Продажа своих вещей — за половину цены."
        var goods: Array = _trader.get("goods", [])
        if goods.is_empty():
            _rows.add_child(_make_empty_label("У этого NPC нечего покупать."))
        for item_id in goods:
            _rows.add_child(_make_buy_row(String(item_id)))
    else:
        _hint_label.text = "Продать можно вещи с меткой цены. Уники торговцы не берут."
        if Game.inventory.is_empty():
            _rows.add_child(_make_empty_label("Сумка пуста."))
        for i in range(Game.inventory.size()):
            _rows.add_child(_make_sell_row(i))

func _make_empty_label(text: String) -> Label:
    var label := Label.new()
    label.text = text
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.add_theme_font_size_override("font_size", 12)
    label.add_theme_color_override("font_color", COLOR_DIM_TEXT)
    return label

## Строка товара лавки: иконка, название, описание, цена, кнопка КУПИТЬ.
## Шаг 8: у демона цена со скидкой (Game.demon_price), а у обычного товара
## в скобках — старая цена лавки, если скидка есть.
func _make_buy_row(item_id: String) -> Control:
    var row := _row_base()
    _row_icon(row, ItemDB.icon(item_id))
    _row_info(row, ItemDB.title(item_id), ItemDB.desc(item_id))
    var price := Game.demon_price(item_id) if _is_demon else ItemDB.price(item_id)
    var price_label := Label.new()
    if _is_demon and price < ItemDB.price(item_id):
        price_label.text = "%d з. (было %d)" % [price, ItemDB.price(item_id)]
    else:
        price_label.text = "%d з." % price
    price_label.add_theme_font_size_override("font_size", 13)
    price_label.add_theme_color_override("font_color", COLOR_GOLD)
    price_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
    price_label.custom_minimum_size = Vector2(52, 0)
    price_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
    price_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    row.add_child(price_label)
    var buy_btn := Button.new()
    buy_btn.text = "КУПИТЬ"
    buy_btn.custom_minimum_size = Vector2(66, 34)
    UiStyle.style_button(buy_btn, 11)
    buy_btn.disabled = price > Game.gold
    buy_btn.pressed.connect(_on_buy_pressed.bind(item_id))
    row.add_child(buy_btn)
    return row

## Строка вещи из сумки: иконка, название, цвет качества, цена выкупа, ПРОДАТЬ.
func _make_sell_row(index: int) -> Control:
    var item: Dictionary = Game.inventory[index]
    var item_id := String(item.get("item_id", ""))
    var title := String(item.get("title", ItemDB.title(item_id) if item_id != "" else "Добыча"))
    var quality := String(item.get("quality", "gray"))
    var hex := "#9aa0a6"
    for q in Loot.QUALITIES:
        if String(q["id"]) == quality:
            hex = String(q["hex"])
    var earned := ItemDB.sell_price(item_id) if item_id != "" else 0
    var row := _row_base()
    var icon_path := ItemDB.icon(item_id)
    if icon_path == "":
        icon_path = "res://assets/sprites/icons/pouch_%s.png" % quality
        if not ResourceLoader.exists(icon_path):
            icon_path = "res://assets/sprites/icons/pouch_gray.png"
    _row_icon(row, icon_path)
    _row_info(row, title, ItemDB.desc(item_id), hex)
    var price_label := Label.new()
    price_label.text = ("+%d з." % earned) if earned > 0 else "не берут"
    price_label.add_theme_font_size_override("font_size", 12)
    price_label.add_theme_color_override("font_color",
        COLOR_EARN if earned > 0 else COLOR_DIM_TEXT)
    price_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
    price_label.custom_minimum_size = Vector2(52, 0)
    price_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
    price_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    row.add_child(price_label)
    var sell_btn := Button.new()
    sell_btn.text = "ПРОДАТЬ"
    sell_btn.custom_minimum_size = Vector2(66, 34)
    UiStyle.style_button(sell_btn, 11)
    sell_btn.disabled = earned <= 0
    sell_btn.pressed.connect(_on_sell_pressed.bind(index))
    row.add_child(sell_btn)
    return row

# ------------------------------------------------------------- строки (общее)

func _row_base() -> HBoxContainer:
    var row := HBoxContainer.new()
    row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    row.add_theme_constant_override("separation", 8)
    return row

func _row_icon(row: HBoxContainer, icon_path: String) -> void:
    var icon := TextureRect.new()
    icon.custom_minimum_size = Vector2(32, 32)
    icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
    icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
    icon.texture = load(icon_path) if icon_path != "" else null
    row.add_child(icon)

func _row_info(row: HBoxContainer, title: String, desc: String,
        title_hex: String = "#e6e9f0") -> VBoxContainer:
    var info := VBoxContainer.new()
    info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    info.add_theme_constant_override("separation", 1)
    row.add_child(info)
    var name_label := Label.new()
    name_label.text = title
    name_label.add_theme_font_size_override("font_size", 13)
    name_label.add_theme_color_override("font_color", Color(title_hex))
    info.add_child(name_label)
    var desc_label := Label.new()
    desc_label.text = desc if desc != "" else "Описание появится позже."
    desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    desc_label.add_theme_font_size_override("font_size", 9)
    desc_label.add_theme_color_override("font_color", COLOR_DIM_TEXT)
    desc_label.custom_minimum_size = Vector2(0, 0)
    info.add_child(desc_label)
    return info

# ------------------------------------------------------------- действия

func _on_buy_pressed(item_id: String) -> void:
    var ok := Game.buy_from_demon(item_id) if _is_demon else Game.buy_item(item_id)
    if not ok:
        _hint_label.text = "Не хватает золота для этой покупки."
        return
    _refresh()

func _on_sell_pressed(index: int) -> void:
    if not Game.sell_item(index):
        _hint_label.text = "Эту вещь продать не получится."
        return
    _refresh()

func _on_state_changed(_value: int = 0) -> void:
    if visible:
        _refresh()

## gui_input supplies exactly one event; unlike Area2D.input_event.
func _on_dim_input(event: InputEvent) -> void:
    if not visible:
        return
    _dim.accept_event()
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        var pos: Vector2 = (event as InputEventMouseButton).position
        if not _panel.get_global_rect().has_point(pos):
            close()

func _on_close_pressed() -> void:
    get_viewport().set_input_as_handled()
    close()

func _unhandled_input(event: InputEvent) -> void:
    if not visible:
        return
    get_viewport().set_input_as_handled()
    if event.is_action_pressed("ui_cancel"):
        close()
