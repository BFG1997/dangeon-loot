## Инвентарь «Dungeon Loot» (шаг 4): сетка 5x4, предметы из бонуса и от торговцев.
## Открывается кнопкой СУМКА на HUD или клавишей I. Тап по предмету — описание.
## Шаг 6: еда/питьё/зелья можно использовать (кнопка ИСПОЛЬЗОВАТЬ);
## в шапке — здоровье и мана героя (мана — только у мага).
## Шаг 7 (боевая система): оружие можно взять в руки (ВЗЯТЬ В РУКИ /
## УБРАТЬ ИЗ РУК) — удары ЛКМ идут оружием; в шапке видно, чем бьёт герой;
## зелья маны пьют только маги (остальным отказ, зелье не тратится).
## Шаг 12 (экипировка): над сеткой — две ячейки ОРУЖИЕ и БРОНЯ: иконка
## надетого предмета, клик по ячейке снимает его; броню/одеяния можно
## надеть кнопкой ОДЕТЬ (одеяния — только магу, варвару отказ); в шапке
## видно бонус надетой брони (+ХП, +мана).
class_name InventoryUI
extends CanvasLayer

signal closed

const COLOR_GOLD := Color(1, 0.84, 0)
const SLOTS := 20
const GRID_COLS := 5

var _dim: ColorRect
var _center: CenterContainer
var _panel: PanelContainer
var _grid: GridContainer
var _hero_portrait: TextureRect
var _hero_label: Label
var _gold_label: Label
var _stats_label: Label
var _desc_label: RichTextLabel
var _use_button: Button
var _equip_button: Button
var _selected_index := -1
# --- шаг 12: ячейки экипировки (оружие + броня/одеяние) ---
var _weapon_cell: PanelContainer = null
var _armor_cell: PanelContainer = null
var _weapon_icon: TextureRect = null
var _armor_icon: TextureRect = null

func _ready() -> void:
    layer = 26
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

    # --- шапка: портрет героя, имя, золото
    var header := HBoxContainer.new()
    header.add_theme_constant_override("separation", 10)
    vbox.add_child(header)

    var frame := PanelContainer.new()
    var frame_style := UiStyle.flat_style(Color(0.05, 0.05, 0.1), COLOR_GOLD)
    frame_style.set_border_width_all(2)
    frame_style.content_margin_left = 3
    frame_style.content_margin_right = 3
    frame_style.content_margin_top = 3
    frame_style.content_margin_bottom = 3
    frame.add_theme_stylebox_override("panel", frame_style)
    header.add_child(frame)
    _hero_portrait = TextureRect.new()
    _hero_portrait.custom_minimum_size = Vector2(44, 44)
    _hero_portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    _hero_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    _hero_portrait.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
    frame.add_child(_hero_portrait)

    var title_box := VBoxContainer.new()
    title_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    title_box.add_theme_constant_override("separation", 0)
    header.add_child(title_box)
    var title := Label.new()
    title.text = "ИНВЕНТАРЬ"
    title.add_theme_font_size_override("font_size", 16)
    title.add_theme_color_override("font_color", COLOR_GOLD)
    title_box.add_child(title)
    _hero_label = Label.new()
    _hero_label.add_theme_font_size_override("font_size", 11)
    _hero_label.add_theme_color_override("font_color", Color(0.62, 0.66, 0.74))
    title_box.add_child(_hero_label)

    _gold_label = Label.new()
    _gold_label.add_theme_font_size_override("font_size", 13)
    _gold_label.add_theme_color_override("font_color", COLOR_GOLD)
    _gold_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
    header.add_child(_gold_label)

    # шаг 6: хп и мана героя (мана показывается только магу)
    _stats_label = Label.new()
    _stats_label.add_theme_font_size_override("font_size", 10)
    _stats_label.add_theme_color_override("font_color", Color(0.62, 0.66, 0.74))
    vbox.add_child(_stats_label)

    # шаг 12: две ячейки экипировки — ОРУЖИЕ и БРОНЯ (в броне живёт и
    # одеяние мага). Клик по заполненной ячейке снимает предмет.
    var equip_row := HBoxContainer.new()
    equip_row.add_theme_constant_override("separation", 10)
    vbox.add_child(equip_row)
    _weapon_cell = _make_equip_cell(true)
    equip_row.add_child(_weapon_cell)
    _armor_cell = _make_equip_cell(false)
    equip_row.add_child(_armor_cell)
    var equip_hint := Label.new()
    equip_hint.text = "Экипировка —\nклик по ячейке снимает"
    equip_hint.add_theme_font_size_override("font_size", 9)
    equip_hint.add_theme_color_override("font_color", Color(0.5, 0.54, 0.64))
    equip_hint.size_flags_vertical = Control.SIZE_SHRINK_CENTER
    equip_row.add_child(equip_hint)

    # --- сетка слотов
    _grid = GridContainer.new()
    _grid.columns = GRID_COLS
    _grid.add_theme_constant_override("h_separation", 6)
    _grid.add_theme_constant_override("v_separation", 6)
    var center := CenterContainer.new()
    center.add_child(_grid)
    vbox.add_child(center)

    # --- описание выбранного предмета
    _desc_label = RichTextLabel.new()
    _desc_label.custom_minimum_size = Vector2(0, 40)
    _desc_label.bbcode_enabled = true
    _desc_label.fit_content = false
    _desc_label.add_theme_font_size_override("normal_font_size", 11)
    _desc_label.add_theme_color_override("default_color", Color(0.8, 0.83, 0.9))
    _desc_label.text = "Сумка пока почти пуста. Загляни к торговцам!"
    vbox.add_child(_desc_label)

    # шаг 6: использовать еду/питьё/зелье (видна, если выбран такой предмет)
    _use_button = Button.new()
    _use_button.text = "ИСПОЛЬЗОВАТЬ"
    _use_button.custom_minimum_size = Vector2(0, 34)
    UiStyle.style_button(_use_button, 12)
    _use_button.visible = false
    _use_button.pressed.connect(_on_use_pressed)
    vbox.add_child(_use_button)

    # шаг 7: взять оружие в руки / убрать из рук (удары E идут оружием)
    _equip_button = Button.new()
    _equip_button.custom_minimum_size = Vector2(0, 34)
    UiStyle.style_button(_equip_button, 12)
    _equip_button.visible = false
    _equip_button.pressed.connect(_on_equip_pressed)
    vbox.add_child(_equip_button)

    var close_btn := Button.new()
    close_btn.text = "ЗАКРЫТЬ (I)"
    close_btn.custom_minimum_size = Vector2(0, 38)
    UiStyle.style_button(close_btn, 13)
    close_btn.pressed.connect(_on_close_pressed)
    vbox.add_child(close_btn)

func open() -> void:
    _hero_portrait.texture = load(String(Game.HEROES.get(Game.hero_id, {}).get("portrait", "")))
    _hero_label.text = "Герой: %s" % Game.hero_title()
    _gold_label.text = "%d з." % Game.gold
    _stats_label.text = _hero_stats_text()
    _selected_index = -1
    _use_button.visible = false
    _equip_button.visible = false
    _rebuild_grid()
    _refresh_equip_cells()
    visible = true
    await get_tree().process_frame
    _panel.pivot_offset = _panel.size / 2.0
    _panel.scale = Vector2(0.85, 0.85)
    var tw := create_tween()
    tw.tween_property(_panel, "scale", Vector2.ONE, 0.2) \
        .set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

## Строка «ХП 30/55 · Мана 70/90 · В руках: Кулаки · 5 ур.» + строка
## надетой брони/одеяния (шаг 12). Мана — только у мага.
func _hero_stats_text() -> String:
    var text := "ХП %d/%d" % [Game.hp, Game.max_hp()]
    if Game.is_mage():
        text += "  ·  Мана %d/%d" % [Game.mana, Game.max_mana()]
    text += "\nВ руках: %s · %d ур." % [Game.strike_title(), Game.strike_damage()]
    if Game.has_armor():
        var armor_id := Game.equipped_armor_id
        var bonus := "+%d ХП" % ItemDB.hp_bonus(armor_id)
        var mana_up := ItemDB.mana_bonus(armor_id)
        if mana_up > 0:
            bonus += " · +%d маны" % mana_up
        text += "\nНадето: %s · %s" % [ItemDB.title(armor_id), bonus]
    return text

func close() -> void:
    visible = false
    closed.emit()

func _rebuild_grid() -> void:
    for child in _grid.get_children():
        _grid.remove_child(child)
        child.free()
    for i in range(SLOTS):
        _grid.add_child(_make_slot(i))

## Ячейка экипировки (шаг 12): ОРУЖИЕ или БРОНЯ. Пустая — тёмная рамка,
## заполненная — золотая рамка и иконка предмета. Клик по заполненной
## ячейке снимает предмет (оружие — в кулаки, броня — срезает бонус ХП).
func _make_equip_cell(is_weapon: bool) -> PanelContainer:
    var cell := PanelContainer.new()
    cell.custom_minimum_size = Vector2(48, 48)
    cell.mouse_filter = Control.MOUSE_FILTER_STOP
    var box := VBoxContainer.new()
    box.add_theme_constant_override("separation", 1)
    cell.add_child(box)
    var icon_holder := CenterContainer.new()
    box.add_child(icon_holder)
    var icon := TextureRect.new()
    icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
    icon.custom_minimum_size = Vector2(28, 28)
    icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
    icon_holder.add_child(icon)
    var caption := Label.new()
    caption.text = "ОРУЖИЕ" if is_weapon else "БРОНЯ"
    caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    caption.add_theme_font_size_override("font_size", 8)
    caption.add_theme_color_override("font_color", Color(0.55, 0.58, 0.68))
    box.add_child(caption)
    if is_weapon:
        _weapon_icon = icon
        cell.gui_input.connect(_on_equip_cell_input.bind(true))
    else:
        _armor_icon = icon
        cell.gui_input.connect(_on_equip_cell_input.bind(false))
    return cell

## Обновить иконки и рамки ячеек экипировки (после любого открытия
## инвентаря и любой экипировки/снятия).
func _refresh_equip_cells() -> void:
    var weapon_id := Game.equipped_weapon_id
    var armor_id := Game.equipped_armor_id
    _style_equip_cell(_weapon_cell, weapon_id != "")
    _style_equip_cell(_armor_cell, armor_id != "")
    if _weapon_icon != null:
        _weapon_icon.texture = _load_item_icon(weapon_id) if weapon_id != "" else null
    if _armor_icon != null:
        _armor_icon.texture = _load_item_icon(armor_id) if armor_id != "" else null

## Иконка предмета (или мешочек качества для безымянной добычи).
func _load_item_icon(item_id: String) -> Texture2D:
    var path := ItemDB.icon(item_id)
    if path == "":
        path = "res://assets/sprites/icons/pouch_gray.png"
    return load(path) if ResourceLoader.exists(path) else null

## Рамка ячейки: пустая — тусклая, заполненная — золотая и пожирнее.
func _style_equip_cell(cell: PanelContainer, filled: bool) -> void:
    if cell == null:
        return
    var style := UiStyle.flat_style(
        Color(0.13, 0.14, 0.22) if filled else Color(0.07, 0.08, 0.13),
        COLOR_GOLD if filled else Color(0.25, 0.28, 0.4))
    style.set_border_width_all(3 if filled else 2)
    style.content_margin_left = 4
    style.content_margin_right = 4
    style.content_margin_top = 3
    style.content_margin_bottom = 3
    cell.add_theme_stylebox_override("panel", style)

## Клик по ячейке экипировки: снимает надетое (шаг 12).
func _on_equip_cell_input(event: InputEvent, is_weapon: bool) -> void:
    if not (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
        return
    if is_weapon:
        if Game.has_weapon():
            var title := Game.strike_title()
            Game.unequip_weapon()
            _desc_label.text = "[color=#9aa0a6]%s убрано — удары идут кулаками (%d ур.).[/color]" \
                % [title, Game.strike_damage()]
        else:
            _desc_label.text = "[color=#9aa0a6]Руки пусты. Выбери оружие в сумке и нажми ВЗЯТЬ В РУКИ.[/color]"
    else:
        if Game.has_armor():
            var armor_title := ItemDB.title(Game.equipped_armor_id)
            Game.unequip_armor()
            _desc_label.text = "[color=#9aa0a6]%s снято — максимум ХП/маны вернулся к обычному.[/color]" % armor_title
        else:
            _desc_label.text = "[color=#9aa0a6]Ничего не надето. Выбери броню в сумке и нажми ОДЕТЬ.[/color]"
    _stats_label.text = _hero_stats_text()
    _refresh_equip_cells()
    _rebuild_grid()

func _make_slot(index: int) -> Control:
    var slot := PanelContainer.new()
    slot.custom_minimum_size = Vector2(56, 56)
    var filled := index < Game.inventory.size()
    var item: Dictionary = Game.inventory[index] if filled else {}
    var equipped := filled and not String(item.get("item_id", "")).is_empty() \
        and String(item.get("item_id", "")) == Game.equipped_weapon_id
    var style := UiStyle.flat_style(
        Color(0.13, 0.14, 0.22) if filled else Color(0.07, 0.08, 0.13),
        COLOR_GOLD if equipped else (Color(0.5, 0.42, 0.16) if filled else Color(0.22, 0.25, 0.36)))
    style.set_border_width_all(3 if equipped else 2)   # в руках — золотая рамка
    slot.add_theme_stylebox_override("panel", style)
    if not filled:
        return slot
    var icon_box := CenterContainer.new()
    slot.add_child(icon_box)
    var icon := TextureRect.new()
    icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
    icon.custom_minimum_size = Vector2(40, 40)
    icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
    var item_id := String(item.get("item_id", ""))
    var icon_path := ItemDB.icon(item_id)
    if icon_path == "":
        icon_path = "res://assets/sprites/icons/pouch_%s.png" % String(item.get("quality", "gray"))
        if not ResourceLoader.exists(icon_path):
            icon_path = "res://assets/sprites/icons/pouch_gray.png"
    icon.texture = load(icon_path)
    icon_box.add_child(icon)
    slot.mouse_filter = Control.MOUSE_FILTER_STOP
    slot.gui_input.connect(_on_slot_input.bind(index))
    return slot

func _on_slot_input(event: InputEvent, index: int) -> void:
    if not (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
        return
    _selected_index = index
    if index >= Game.inventory.size():
        _use_button.visible = false
        _equip_button.visible = false
        return
    var item: Dictionary = Game.inventory[index]
    var item_id := String(item.get("item_id", ""))
    var title := String(item.get("title", ItemDB.title(item_id) if item_id != "" else "Добыча"))
    var quality := String(item.get("quality", "gray"))
    var hex := "#9aa0a6"
    for q in Loot.QUALITIES:
        if String(q["id"]) == quality:
            hex = String(q["hex"])
    var desc := ItemDB.desc(item_id)
    if desc == "":
        desc = "Найденная добыча. Продавцы пока молчат о её цене."
    # шаг 7/12: оружие — строка про урон, броня/одеяния — строка про бонусы
    var item_type := String(ItemDB.get_item(item_id).get("type", ""))
    if item_type == "weapon" and ItemDB.damage(item_id) > 0:
        desc += "\nУрон: %d." % ItemDB.damage(item_id)
        if ItemDB.is_magic(item_id):
            desc += " Магическое оружие: магу — залп на Q, варвару — отказ."
        if item_id == Game.equipped_weapon_id:
            desc += " Сейчас в руках."
    elif item_type == "armor" or item_type == "robe":
        var bonus := ItemDB.hp_bonus(item_id)
        var mana_up := ItemDB.mana_bonus(item_id)
        if bonus > 0:
            desc += "\n+%d к максимуму ХП." % bonus
        if mana_up > 0:
            desc += " +%d к максимуму маны." % mana_up
        if item_type == "robe":
            desc += " Только для Мага."
        if item_id == Game.equipped_armor_id:
            desc += " Сейчас надето."
    _desc_label.text = "[color=%s][b]%s[/b][/color]\n%s" % [hex, title, desc]
    # шаг 6: еду/питьё/зелья можно использовать прямо из сумки
    _use_button.visible = item_type in ItemDB.USABLE_TYPES
    if _use_button.visible:
        _use_button.text = "ВЫПИТЬ" if item_type != "food" else "СЪЕСТЬ"
    # шаг 7: оружие — ВЗЯТЬ В РУКИ / УБРАТЬ ИЗ РУК;
    # шаг 12: броня/одеяние — ОДЕТЬ / СНЯТЬ
    if item_type == "weapon":
        _equip_button.visible = true
        _equip_button.text = "УБРАТЬ ИЗ РУК" if item_id == Game.equipped_weapon_id \
            else "ВЗЯТЬ В РУКИ"
    elif item_type == "armor" or item_type == "robe":
        _equip_button.visible = true
        _equip_button.text = "СНЯТЬ" if item_id == Game.equipped_armor_id else "ОДЕТЬ"
    else:
        _equip_button.visible = false

## Кнопка под описанием: ВЗЯТЬ В РУКИ / УБРАТЬ ИЗ РУК (оружие),
## ОДЕТЬ / СНЯТЬ (броня и одеяния, шаг 12).
func _on_equip_pressed() -> void:
    if _selected_index < 0 or _selected_index >= Game.inventory.size():
        return
    var item: Dictionary = Game.inventory[_selected_index]
    var item_id := String(item.get("item_id", ""))
    var item_type := String(ItemDB.get_item(item_id).get("type", ""))
    if item_type == "armor" or item_type == "robe":
        _apply_armor_action(item, item_id)
    else:
        _apply_weapon_action(item, item_id)
    _stats_label.text = _hero_stats_text()
    _selected_index = -1
    _use_button.visible = false
    _equip_button.visible = false
    _rebuild_grid()
    _refresh_equip_cells()

## Надеть/снять оружие (шаг 7; шаг 12 — отказ варвару от магического).
func _apply_weapon_action(item: Dictionary, item_id: String) -> void:
    if item_id == Game.equipped_weapon_id:
        Game.unequip_weapon()
        _desc_label.text = "[color=#9aa0a6]%s убрано — удары идут кулаками (%d ур.).[/color]" \
            % [String(item.get("title", "Оружие")), Game.strike_damage()]
        return
    var result := Game.try_equip_weapon(item_id)
    if bool(result.get("ok", false)):
        _desc_label.text = "[color=#ffd700]%s в руках — удары наносят %d урона.[/color]" \
            % [String(item.get("title", "Оружие")), Game.strike_damage()]
    elif String(result.get("reason", "")) == "barbarian_rejected":
        _desc_label.text = "[color=#e88a8a]Магическое оружие отвергает варвара: чужая воля жжёт руки.[/color]"
    else:
        _desc_label.text = "[color=#9aa0a6]Это не годится для боя.[/color]"

## Надеть/снять броню или одеяние (шаг 12; одеяние — только магу).
func _apply_armor_action(item: Dictionary, item_id: String) -> void:
    if item_id == Game.equipped_armor_id:
        var taken_title := String(item.get("title", ItemDB.title(item_id)))
        Game.unequip_armor()
        _desc_label.text = "[color=#9aa0a6]%s снято — максимум ХП/маны вернулся к обычному.[/color]" % taken_title
        return
    var result := Game.equip_armor(item_id)
    if bool(result.get("ok", false)):
        var bonus := "+%d ХП" % ItemDB.hp_bonus(item_id)
        var mana_up := ItemDB.mana_bonus(item_id)
        if mana_up > 0:
            bonus += " и +%d маны" % mana_up
        _desc_label.text = "[color=#ffd700]%s надето: %s. Теперь ХП %d/%d.[/color]" \
            % [String(item.get("title", "")), bonus, Game.hp, Game.max_hp()]
    elif String(result.get("reason", "")) == "robe_not_mage":
        _desc_label.text = "[color=#e88a8a]Одеяние слушается только того, в ком живёт мана. Ты не Маг.[/color]"
    else:
        _desc_label.text = "[color=#9aa0a6]Это нельзя надеть.[/color]"

## Использовать выбранный предмет (выпить/съесть).
func _on_use_pressed() -> void:
    if _selected_index < 0 or _selected_index >= Game.inventory.size():
        return
    var item: Dictionary = Game.inventory[_selected_index]
    var title := String(item.get("title", ItemDB.title(String(item.get("item_id", "")))))
    var result := Game.use_consumable(_selected_index)
    _rebuild_grid()
    _selected_index = -1
    _use_button.visible = false
    _equip_button.visible = false
    if bool(result.get("ok", false)):
        _stats_label.text = _hero_stats_text()
        var healed: int = int(result.get("healed", 0))
        var restored: int = int(result.get("restored", 0))
        var parts: Array[String] = []
        if healed > 0:
            parts.append("+%d ХП" % healed)
        if restored > 0:
            parts.append("+%d маны" % restored)
        _desc_label.text = "[color=#7fd27f]%s: %s.[/color]" % [title, ", ".join(parts)]
    elif String(result.get("blocked", "")) == "not_mage":
        _desc_label.text = "[color=#e88a8a]Мана нужна только Магу — %s выпить не получится.[/color]" % title
    elif bool(result.get("full", false)):
        _desc_label.text = "[color=#9aa0a6]ХП и мана уже полные — %s не нужен.[/color]" % title

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

# Capture the modal shortcut before a focused Button can consume Enter/Space,
# and before STOP controls swallow non-primary mouse buttons. Primary LMB
# keeps its normal selection/button behavior within the inventory.
func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        return
    _handle_close_input(event)

func _handle_close_input(event: InputEvent) -> bool:
    if not visible:
        return false
    if not event.is_action("toggle_inventory") and not event.is_action("ui_cancel"):
        return false
    get_viewport().set_input_as_handled()
    if event.is_action_pressed("toggle_inventory") or event.is_action_pressed("ui_cancel"):
        close()
    return true

func _unhandled_input(event: InputEvent) -> void:
    if not visible:
        return
    if not _handle_close_input(event):
        # Consume other unhandled input while modal, including key echoes.
        get_viewport().set_input_as_handled()
