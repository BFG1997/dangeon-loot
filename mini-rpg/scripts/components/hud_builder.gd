## HudBuilder — компонент HUD (шаг 28, декомпозиция; шаг 27 — слоты приёмов;
## редизайн консоли под ПК 1920x1080).
## Раньше _build_hud/_show_hint/_bar_style/_style_small_button жили
## почти одинаковыми копиями в world.gd и dungeon.gd (~370 строк дубликата).
## Различия сцен:
##  - в мире строка оружия — член _hud_weapon (обновляется из _cb_level
##    и _cb_equipped), в данже — локальная hud_weapon;
##  - в данже над подсказкой есть строка прогресса этажа _hud_floor;
##  - смещения подсказки разные (мир: 4..46, данж: 22..64);
##  - разный набор колбэков кнопок (w._on_* / d._on_*).
##
## Шаг 27 (слоты приёмов): в консоли три ячейки Q / ПРОБЕЛ / T с иконкой
## приёма, тёмной шторкой кулдауна (сползает сверху) и всплывающей
## подсказкой — раньше кулдауны не были видны вообще.
## Шаг 27 (ПК-консоль): панель героя и кнопки укрупнены под экран 960x540
## (логический размер при stretch x2.0): портрет 36, шрифты 11-13 вместо
## 9-12, полосы 150x9 вместо 74x8, кнопки 100x24 вместо 64x22.
class_name HudBuilder
extends RefCounted

## Геометрия слотов приёмов в нижней консоли (шаг 27).
## Шаг 29: слотов ЧЕТЫРЕ (добавлен приём героя — свой у каждого класса);
## на ПК они сдвинуты левее (панель героя уже), под каждым слотом —
## название приёма; рядом с ними мини-слоты экипировки и индикаторы
## эффектов — пустые места консоли заполнены.
## Шаг 30: клавиши приёмов поменялись местами — приём героя теперь на
## ПРОБЕЛЕ, а бывший пробел (щит/барьер/газ/прыжок) — на CTRL.
const SLOT_SIZE := 52.0
const SLOT_X_TOUCH := 340.0  # праве джойстика тоже (сенсорные)
const SLOT_X_PC := 235.0     # на ПК панель героя уже — слоты левее
const SLOT_Y := 30.0
const SLOT_SEP := 10.0

## Ширина ряда из 4 слотов (для расчёта X экипировки справа).
const SLOT_ROW_W := 4.0 * SLOT_SIZE + 3.0 * SLOT_SEP

## Стиль полосы ХП/маны: рамка 1 px, без внутренних отступов.
static func bar_style(bg: Color, border: Color) -> StyleBoxFlat:
        var sb := StyleBoxFlat.new()
        sb.bg_color = bg
        sb.border_color = border
        sb.set_border_width_all(1)
        sb.content_margin_left = 1.0
        sb.content_margin_right = 1.0
        sb.content_margin_top = 1.0
        sb.content_margin_bottom = 1.0
        return sb

## Кнопка действия в нижней консоли (шаг 11): те же цвета, но компактные
## отступы — иначе Button не даст себе стать ниже 29 px.
static func style_small_button(btn: Button, font_size: int) -> void:
        UiStyle.style_button(btn, font_size)
        for state in ["normal", "hover", "pressed"]:
                var sb := btn.get_theme_stylebox(state)
                if sb is StyleBoxFlat:
                        (sb as StyleBoxFlat).content_margin_top = 3.0
                        (sb as StyleBoxFlat).content_margin_bottom = 3.0
                        (sb as StyleBoxFlat).content_margin_left = 4.0
                        (sb as StyleBoxFlat).content_margin_right = 4.0

## Подсказка у верхнего края экрана ходьбы: текст + затухание через
## seconds. Предыдущий твин гасим, чтобы два твина не мигали в борьбе.
static func show_hint(host, text: String, seconds: float) -> void:
        if host._hud_hint == null:
                return   # шаг 24: HUD ещё не собран — подсказку молча пропускаем
        if host._hint_tween != null and host._hint_tween.is_valid():
                host._hint_tween.kill()
        host._hud_hint.text = text
        host._hud_hint.modulate.a = 1.0
        host._hint_tween = host.create_tween()
        host._hint_tween.tween_interval(seconds)
        host._hint_tween.tween_property(host._hud_hint, "modulate:a", 0.0, 0.6)

## ------------------------------------------------ слоты приёмов (шаг 27)

## Четыре ячейки Q / ПРОБЕЛ / T / CTRL (шаг 30: приём героя — на пробеле,
## бывший пробел — на CTRL): иконка приёма, подпись клавиши, шторка
## кулдауна, цифра секунд и название приёма под ячейкой. Ссылки —
## в host._hud_slots, обновление — update_slots(host) из _physics_process
## сцены (1 строка).
static func build_ability_slots(host, bar: Control) -> void:
        var specs := [
                {"kind": "q", "key": "Q"},
                {"kind": "dash", "key": "ПРОБЕЛ"},
                {"kind": "t", "key": "T"},
                {"kind": "special", "key": "CTRL"},
        ]
        var slot_x: float = SLOT_X_TOUCH if DisplayServer.is_touchscreen_available() \
                else SLOT_X_PC
        host._hud_slots = []
        for i in range(specs.size()):
                var spec: Dictionary = specs[i]
                var panel := Panel.new()
                panel.name = "AbilitySlot%s" % String(spec["key"])
                panel.size = Vector2(SLOT_SIZE, SLOT_SIZE)
                panel.position = Vector2(slot_x + float(i) * (SLOT_SIZE + SLOT_SEP),
                        SLOT_Y)
                var sb := StyleBoxFlat.new()
                sb.bg_color = Color(0.10, 0.10, 0.17)
                sb.border_color = Color(0.5, 0.42, 0.16)
                sb.set_border_width_all(1)
                sb.set_content_margin_all(0)
                panel.add_theme_stylebox_override("panel", sb)
                bar.add_child(panel)
                var icon := TextureRect.new()
                icon.custom_minimum_size = Vector2(32, 32)
                icon.size = Vector2(32, 32)
                icon.position = Vector2(10, 6)
                icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
                icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
                icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
                panel.add_child(icon)
                var shade := ColorRect.new()
                shade.name = "CooldownShade"
                shade.position = Vector2(1, 1)
                shade.size = Vector2(SLOT_SIZE - 2.0, 0.0)
                shade.color = Color(0.0, 0.0, 0.0, 0.62)
                shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
                panel.add_child(shade)
                var key_label := Label.new()
                key_label.text = String(spec["key"])
                key_label.position = Vector2(4, SLOT_SIZE - 15.0)
                key_label.add_theme_font_size_override("font_size", 9)
                key_label.add_theme_color_override("font_color", Color(0.85, 0.7, 0.2))
                key_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
                key_label.add_theme_constant_override("shadow_offset_y", 1)
                panel.add_child(key_label)
                var cd_label := Label.new()
                cd_label.position = Vector2(0, 14)
                cd_label.size = Vector2(SLOT_SIZE, 18)
                cd_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
                cd_label.add_theme_font_size_override("font_size", 14)
                cd_label.add_theme_color_override("font_color", Color(0.95, 0.95, 1.0))
                cd_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
                cd_label.add_theme_constant_override("shadow_offset_y", 1)
                panel.add_child(cd_label)
                var name_label := Label.new()
                name_label.position = Vector2(slot_x + float(i) * (SLOT_SIZE + SLOT_SEP) - 6.0,
                        SLOT_Y + SLOT_SIZE + 2.0)
                name_label.size = Vector2(SLOT_SIZE + 12.0, 12.0)
                name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
                name_label.add_theme_font_size_override("font_size", 8)
                name_label.add_theme_color_override("font_color", Color(0.72, 0.76, 0.86))
                name_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
                name_label.add_theme_constant_override("shadow_offset_y", 1)
                name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
                bar.add_child(name_label)
                host._hud_slots.append({"kind": String(spec["kind"]), "key": String(spec["key"]),
                        "panel": panel, "icon": icon, "shade": shade, "cd_label": cd_label,
                        "name_label": name_label})
        refresh_slot_icons(host)

## Иконки и всплывающие подсказки слотов — по приёмам текущего класса.
## Вызывается при сборке HUD; при смене героя сцена пересобирается целиком.
## Шаг 29: под каждым слотом ещё и название приёма (мелким шрифтом).
## Шаг 31: у приёмов-призывов своя иконка (ключ "icon" в ABILITIES),
## а в подсказке — цена маны (и кулдаун за смерть демона).
static func refresh_slot_icons(host) -> void:
        for rec in host._hud_slots:
                var kind := String(rec["kind"])
                var info := Game.ability_info(kind)
                var icon_kind := String(info.get("icon", info.get("kind", "")))
                var icon_path := "res://assets/sprites/icons/ability_%s.png" % icon_kind
                if icon_kind.is_empty() or not ResourceLoader.exists(icon_path):
                        icon_path = "res://assets/sprites/icons/sword.png"
                (rec["icon"] as TextureRect).texture = load(icon_path)
                var title := String(info.get("title", "Приём"))
                var tooltip := "%s — %s" % [rec["key"], title]
                if info.has("summon"):
                        var respawn := float(Game.DEMON_SUMMONS.get(info["summon"], {}) \
                                .get("respawn_cd", 20.0))
                        tooltip += "\nМана: %d · кулдаун только если демон погибнет (%.0f с)" \
                                % [int(info.get("mana_cost", 0)), respawn]
                elif int(info.get("mana_cost", 0)) > 0:
                        tooltip += "\nМана: %d" % int(info.get("mana_cost", 0))
                        var cd := float(info.get("cd", 0.0))
                        if cd >= 0.5:
                                tooltip += " · Кулдаун: %s" \
                                        % (("%.0f с" % cd) if cd >= 1.5 else ("%.1f с" % cd))
                else:
                        var cd := float(info.get("cd", float(Game.SPELL.get("cooldown", 1.0))))
                        tooltip += "\nКулдаун: %s" % (("%.0f с" % cd) if cd >= 1.5 else ("%.1f с" % cd))
                (rec["panel"] as Panel).tooltip_text = tooltip
                if rec.has("name_label"):
                        var name_label: Label = rec["name_label"]
                        # короткая метка приёма (ТОПОР/ПРЫЖОК/ХМЕЛЬ...) — длинные
                        # названия сливались с соседями; полное имя — в тултипе
                        name_label.text = String(info.get("btn",
                                info.get("title", "Приём")))

## Обновление шторок кулдауна (вызов из _physics_process мира/данжа).
## Q — заклинание (_spell_cd) только у мага (kind "spell"); у остальных —
## приём (_q_cd). Шаг 29/30: четвёртый слот — щит/барьер/газ/прыжок на Ctrl
## (_special_cd); второй слот — приём героя на пробеле (_dash_cd).
## Шаг 31: у призывов шторка — кулдаун за смерть демона (respawn_cd);
## там же обновляются индикаторы эффектов и блок «СПОСОБНОСТИ».
static func update_slots(host) -> void:
        var slots: Array = host.get("_hud_slots")
        if slots == null or slots.is_empty():
                return
        # шаг 32: бомж в форме оборотня — иконки/подписи приёмов другие;
        # смена формы отслеживается по сигнатуре, пересчёт только при смене
        var form_sig := "%s|%s" % [Game.hero_id, str(Game.werewolf_active)]
        if String(host.get("_hud_form_sig")) != form_sig:
                host._hud_form_sig = form_sig
                refresh_slot_icons(host)
        for rec in slots:
                var cd_left := 0.0
                var cd_full := 1.0
                var info := Game.ability_info(String(rec["kind"]))
                if info.has("summon"):
                        # призыв: живой демон — без шторки; погиб — respawn_cd
                        cd_full = maxf(0.1, float(Game.DEMON_SUMMONS.get(info["summon"], {}) \
                                .get("respawn_cd", 20.0)))
                        match String(rec["kind"]):
                                "q":
                                        cd_left = float(host._q_cd)
                                "dash":
                                        cd_left = float(host._dash_cd)
                                "t":
                                        cd_left = float(host._t_cd)
                                _:
                                        cd_left = float(host._special_cd)
                else:
                        match String(rec["kind"]):
                                "q":
                                        if String(info.get("kind", "")) == "spell":
                                                cd_left = float(host._spell_cd)
                                                cd_full = maxf(0.1, float(Game.SPELL.get("cooldown", 1.0)))
                                        else:
                                                cd_left = float(host._q_cd)
                                                cd_full = maxf(0.1, float(info.get("cd", 2.0)))
                                "special":
                                        cd_left = float(host._special_cd)
                                        cd_full = maxf(0.1, float(info.get("cd", 10.0)))
                                "dash":
                                        cd_left = float(host._dash_cd)
                                        cd_full = maxf(0.1, float(info.get("cd", 1.0)))
                                _:
                                        cd_left = float(host._t_cd)
                                        cd_full = maxf(0.1, float(info.get("cd", 20.0)))
                var frac := clampf(cd_left / cd_full, 0.0, 1.0)
                var shade: ColorRect = rec["shade"]
                shade.size = Vector2(SLOT_SIZE - 2.0, (SLOT_SIZE - 2.0) * frac)
                (rec["icon"] as TextureRect).modulate = Color(0.55, 0.55, 0.62) \
                        if cd_left > 0.0 else Color.WHITE
                var cd_label: Label = rec["cd_label"]
                cd_label.text = "%d" % int(ceil(cd_left)) if cd_left > 0.05 else ""
        refresh_buffs(host)
        refresh_abilities_block(host)

## --------------------------------- экипировка и эффекты (шаг 29, пустые места)

## X ряда экипировки: справа от слотов приёмов.
static func equipment_x(host) -> float:
        var slot_x: float = SLOT_X_TOUCH if DisplayServer.is_touchscreen_available() \
                else SLOT_X_PC
        return slot_x + SLOT_ROW_W + 18.0

## Мини-слоты «в руках» и «на теле»: иконка предмета, урон/бонус под ней,
## клик открывает сумку. Заполняют пустую середину консоли.
static func build_equipment_row(host, bar: Control) -> void:
        var box := Control.new()
        box.name = "Equipment"
        box.position = Vector2(equipment_x(host), SLOT_Y)
        bar.add_child(box)
        var weapon := _make_equip_slot(box, 0.0)
        var armor := _make_equip_slot(box, 50.0)
        weapon["panel"].pressed.connect(host._on_bag_pressed)
        armor["panel"].pressed.connect(host._on_bag_pressed)
        host._hud_equip = {"weapon": weapon, "armor": armor}
        refresh_equipment(host)

static func _make_equip_slot(box: Control, dx: float) -> Dictionary:
        var btn := Button.new()
        btn.position = Vector2(dx, 0)
        btn.size = Vector2(44, 44)
        var sb := StyleBoxFlat.new()
        sb.bg_color = Color(0.09, 0.10, 0.16)
        sb.border_color = Color(0.36, 0.30, 0.12)
        sb.set_border_width_all(1)
        btn.add_theme_stylebox_override("normal", sb)
        btn.add_theme_stylebox_override("hover", sb)
        btn.add_theme_stylebox_override("pressed", sb)
        btn.tooltip_text = ""
        box.add_child(btn)
        var icon := TextureRect.new()
        icon.position = Vector2(6, 6)
        icon.size = Vector2(32, 32)
        icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
        icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
        icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
        icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
        btn.add_child(icon)
        var sub := Label.new()
        sub.position = Vector2(dx - 2.0, 46.0)
        sub.size = Vector2(48.0, 12.0)
        sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        sub.add_theme_font_size_override("font_size", 8)
        sub.add_theme_color_override("font_color", Color(0.72, 0.76, 0.86))
        sub.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
        sub.add_theme_constant_override("shadow_offset_y", 1)
        sub.mouse_filter = Control.MOUSE_FILTER_IGNORE
        box.add_child(sub)
        return {"panel": btn, "icon": icon, "sub": sub}

## Перечитать иконки экипировки (при надевании/снятии — из _cb_equipped).
## Шаг 32: у тёмного оружия колдунов и у магического оружия мага
## в тултипе — F-атака (название, урон, цена маны).
static func refresh_equipment(host) -> void:
        var equip: Variant = host.get("_hud_equip")
        if equip == null:
                return
        var weapon: Dictionary = equip["weapon"]
        var armor: Dictionary = equip["armor"]
        var wid := Game.equipped_weapon_id
        if wid.is_empty():
                (weapon["icon"] as TextureRect).texture = null
                weapon["panel"].tooltip_text = "В руках: кулаки · %d ур." % Game.strike_damage()
        else:
                var wpath := ItemDB.icon(wid)
                (weapon["icon"] as TextureRect).texture = load(wpath) if not wpath.is_empty() else null
                weapon["panel"].tooltip_text = "В руках: %s · %d ур." % [ItemDB.title(wid), Game.strike_damage()]
                var f_info := Game.f_attack_info()
                if not f_info.is_empty():
                        weapon["panel"].tooltip_text += "\nF — %s: %d урона, %d маны (кул. %.1f с)" \
                                % [String(f_info.get("title", "атака")), int(f_info.get("damage", 0)),
                                        int(f_info.get("mana", 0)), float(f_info.get("cooldown", 0.5))]
        (weapon["sub"] as Label).text = "%d ур." % Game.strike_damage()
        var aid := Game.equipped_armor_id
        if aid.is_empty():
                (armor["icon"] as TextureRect).texture = null
                armor["panel"].tooltip_text = "На теле: ничего"
                (armor["sub"] as Label).text = "нет"
        else:
                var apath := ItemDB.icon(aid)
                (armor["icon"] as TextureRect).texture = load(apath) if not apath.is_empty() else null
                var hp_bonus := ItemDB.hp_bonus(aid)
                var mana_bonus := ItemDB.mana_bonus(aid)
                armor["panel"].tooltip_text = "На теле: %s" % ItemDB.title(aid)
                (armor["sub"] as Label).text = "+%d маны" % mana_bonus if mana_bonus > 0 \
                        else ("+%d хп" % hp_bonus if hp_bonus > 0 else "-")

## Ряд активных эффектов: щит/барьер, гнев титана, хмель, серия ударов.
## Перестраивается только при смене набора (сигнатура) — каждый кадр дёшево.
static func refresh_buffs(host) -> void:
        var box: Variant = host.get("_hud_buffs_box")
        if box == null:
                return
        var sig := ""
        var buffs: Array = []
        if Game.guard_active:
                buffs.append(["ability_hold_shield", "Щит воина поднят"])
        if Game.hero_immune and not Game.guard_active:
                buffs.append(["ability_hold_barrier", "Барьер мага активен"])
        if Game.titan_active():
                buffs.append(["ability_titan_rage", "Гнев титана"])
        if Game.drink_active():
                buffs.append(["ability_drink", "Хмель: урон не проходит"])
        if float(host._combo_left) > 0.0 and int(host._combo_idx) >= 2:
                buffs.append(["ability_whirl", "Серия ударов: следующий усилен"])
        for b in buffs:
                sig += String(b[0]) + ";"
        var hbox: HBoxContainer = box
        if String(host._hud_buffs_sig) == sig:
                return
        host._hud_buffs_sig = sig
        for child in hbox.get_children():
                hbox.remove_child(child)   # сразу — queue_free отложен на кадр
                child.queue_free()
        for b in buffs:
                var icon := TextureRect.new()
                icon.custom_minimum_size = Vector2(26, 26)
                icon.size = Vector2(26, 26)
                icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
                icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
                icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
                icon.tooltip_text = String(b[1])
                icon.texture = load("res://assets/sprites/icons/%s.png" % String(b[0]))
                hbox.add_child(icon)

static func build_buffs_row(host, bar: Control) -> void:
        var hbox := HBoxContainer.new()
        hbox.name = "Buffs"
        hbox.position = Vector2(equipment_x(host) + 108.0, SLOT_Y + 9.0)
        hbox.add_theme_constant_override("separation", 6)
        bar.add_child(hbox)
        host._hud_buffs_box = hbox
        host._hud_buffs_sig = ""

## ------------------------------------------ блок «СПОСОБНОСТИ» (шаг 30/31)

## Панель под умения героя. У Демоноолога и Некроманта (шаг 31) она ЖИВАЯ:
## показывает состояние призывов (демоны/армия). У остальных классов —
## четыре тёмных слота-заглушки (автор: «пока пустые, заполним их потом»).
## Только на ПК: в сенсорной консоли между экипировкой и кнопками места
## нет — там блок не строится вовсе.
static func build_abilities_block(host, bar: Control) -> void:
        if DisplayServer.is_touchscreen_available():
                return
        var panel := Panel.new()
        panel.name = "AbilitiesBlock"
        panel.set_meta("abilities_block", true)
        var sb := StyleBoxFlat.new()
        sb.bg_color = Color(0.11, 0.12, 0.19)
        sb.border_color = Color(0.5, 0.42, 0.16)
        sb.set_border_width_all(1)
        panel.add_theme_stylebox_override("panel", sb)
        panel.size = Vector2(150.0, float(host.UI_BAR_H) - 16.0)
        panel.position = Vector2(float(host.BAR_BUTTONS_X) - 160.0, 8.0)
        panel.mouse_filter = Control.MOUSE_FILTER_PASS
        bar.add_child(panel)
        var title := Label.new()
        title.text = "СПОСОБНОСТИ"
        title.position = Vector2(0, 6)
        title.size = Vector2(150, 14)
        title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        title.add_theme_font_size_override("font_size", 10)
        title.add_theme_color_override("font_color", Color(0.85, 0.7, 0.2))
        title.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
        title.add_theme_constant_override("shadow_offset_y", 1)
        title.mouse_filter = Control.MOUSE_FILTER_IGNORE
        panel.add_child(title)
        match Game.hero_id:
                "demonologist":
                        # 4 ячейки демонов: иконка + цена маны; состояние
                        # красится в refresh_abilities_block каждый кадр
                        host._hud_summon_cells = []
                        var slots := ["q", "dash", "t", "special"]
                        for i in range(slots.size()):
                                var info := Game.ability_info(String(slots[i]))
                                var cell := Panel.new()
                                cell.position = Vector2(11.0 + float(i) * 32.0, 26.0)
                                cell.size = Vector2(26, 26)
                                cell.mouse_filter = Control.MOUSE_FILTER_PASS
                                panel.add_child(cell)
                                var icon := TextureRect.new()
                                icon.position = Vector2(1, 1)
                                icon.size = Vector2(24, 24)
                                icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
                                icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
                                icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
                                icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
                                cell.add_child(icon)
                                var cost := Label.new()
                                cost.position = Vector2(10.0 + float(i) * 32.0 - 6.0, 53.0)
                                cost.size = Vector2(32.0, 10.0)
                                cost.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
                                cost.add_theme_font_size_override("font_size", 8)
                                cost.add_theme_color_override("font_color",
                                        Color(0.5, 0.7, 0.95))
                                cost.add_theme_color_override("font_shadow_color",
                                        Color(0, 0, 0, 0.8))
                                cost.add_theme_constant_override("shadow_offset_y", 1)
                                cost.mouse_filter = Control.MOUSE_FILTER_IGNORE
                                panel.add_child(cost)
                                host._hud_summon_cells.append({
                                        "summon": String(info.get("summon", "")),
                                        "slot": String(slots[i]),
                                        "cell": cell, "icon": icon, "cost": cost,
                                        "mana_cost": int(info.get("mana_cost", 0)),
                                })
                        refresh_summon_cells(host)
                "necromancer":
                        # армия: счётчик + ряд иконок поднятых врагов
                        var count := Label.new()
                        count.name = "ArmyCount"
                        count.position = Vector2(0, 26)
                        count.size = Vector2(150, 12)
                        count.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
                        count.add_theme_font_size_override("font_size", 10)
                        count.add_theme_color_override("font_color",
                                Color(0.6, 0.85, 0.65))
                        count.add_theme_color_override("font_shadow_color",
                                Color(0, 0, 0, 0.8))
                        count.add_theme_constant_override("shadow_offset_y", 1)
                        count.mouse_filter = Control.MOUSE_FILTER_IGNORE
                        panel.add_child(count)
                        var hbox := HBoxContainer.new()
                        hbox.name = "ArmyIcons"
                        hbox.position = Vector2(11, 44)
                        hbox.size = Vector2(128, 26)
                        hbox.add_theme_constant_override("separation", 4)
                        hbox.alignment = BoxContainer.ALIGNMENT_CENTER
                        hbox.mouse_filter = Control.MOUSE_FILTER_PASS
                        panel.add_child(hbox)
                        var note := Label.new()
                        note.text = "Ctrl — зов босса\n(после 1-й победы)"
                        note.position = Vector2(0, 74)
                        note.size = Vector2(150, 24)
                        note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
                        note.add_theme_font_size_override("font_size", 8)
                        note.add_theme_color_override("font_color",
                                Color(0.6, 0.64, 0.74))
                        note.add_theme_color_override("font_shadow_color",
                                Color(0, 0, 0, 0.8))
                        note.add_theme_constant_override("shadow_offset_y", 1)
                        note.mouse_filter = Control.MOUSE_FILTER_IGNORE
                        panel.add_child(note)
                        host._hud_army_count = count
                        host._hud_army_box = hbox
                        host._hud_army_sig = ""
                        refresh_army_block(host)
                _:
                        # четыре слота-заглушки — под будущие умения героя
                        for i in range(4):
                                var cell := Panel.new()
                                cell.position = Vector2(11.0 + float(i) * 32.0, 34.0)
                                cell.size = Vector2(26, 26)
                                var cell_sb := StyleBoxFlat.new()
                                cell_sb.bg_color = Color(0.08, 0.09, 0.15)
                                cell_sb.border_color = Color(0.36, 0.30, 0.12)
                                cell_sb.set_border_width_all(1)
                                cell.add_theme_stylebox_override("panel", cell_sb)
                                cell.tooltip_text = "Появится позже"
                                cell.mouse_filter = Control.MOUSE_FILTER_PASS
                                panel.add_child(cell)

## Живой блок Демоноолога: 4 ячейки демонов — активен (золотая рамка),
## готов (обычная), на кулдауне (тёмная + цифра), маны не хватает (тусклый).
static func refresh_summon_cells(host) -> void:
        var cells: Variant = host.get("_hud_summon_cells")
        if cells == null:
                return
        for rec in cells:
                var summon_id := String(rec["summon"])
                var cell: Panel = rec["cell"]
                var icon: TextureRect = rec["icon"]
                var active := Game.summons_active.has(summon_id)
                var cd := Game.summon_cd_left(summon_id)
                var path := "res://assets/sprites/icons/ability_%s.png" \
                        % String(Game.ABILITIES.get("demonologist", {}) \
                                .get(String(rec["slot"]), {}).get("icon", "summon"))
                if ResourceLoader.exists(path):
                        icon.texture = load(path)
                var sb := StyleBoxFlat.new()
                sb.set_border_width_all(1)
                if active:
                        sb.bg_color = Color(0.16, 0.13, 0.10)
                        sb.border_color = Color(0.85, 0.7, 0.2)
                        cell.tooltip_text = "%s — с тобой (%d хп)\nПовторное нажатие отпустит" \
                                % [String(Game.DEMON_SUMMONS.get(summon_id, {}).get("title", "")),
                                   int(Game.summons_active.get(summon_id, {}).get("hp", 0))]
                elif cd > 0.0:
                        sb.bg_color = Color(0.06, 0.07, 0.11)
                        sb.border_color = Color(0.3, 0.26, 0.14)
                        cell.tooltip_text = "Кулдаун: %.0f с" % cd
                elif Game.mana < int(rec["mana_cost"]):
                        sb.bg_color = Color(0.08, 0.09, 0.15)
                        sb.border_color = Color(0.36, 0.30, 0.12)
                        cell.tooltip_text = "Не хватает маны: нужно %d" % int(rec["mana_cost"])
                else:
                        sb.bg_color = Color(0.10, 0.11, 0.18)
                        sb.border_color = Color(0.5, 0.42, 0.16)
                        cell.tooltip_text = "%s — готов (мана %d)" \
                                % [String(Game.DEMON_SUMMONS.get(summon_id, {}).get("title", "")),
                                   int(rec["mana_cost"])]
                cell.add_theme_stylebox_override("panel", sb)
                icon.modulate = Color(0.42, 0.42, 0.5) \
                        if (cd > 0.0 or (not active and Game.mana < int(rec["mana_cost"]))) \
                        else Color.WHITE
                (rec["cost"] as Label).text = "%d" % int(rec["mana_cost"])

## Живой блок Некроманта: счётчик армии и ряд иконок поднятых врагов.
static func refresh_army_block(host) -> void:
        var count: Variant = host.get("_hud_army_count")
        var hbox: Variant = host.get("_hud_army_box")
        if count == null or hbox == null:
                return
        var army: Array = Game.necro_army
        (count as Label).text = "Армия: %d/%d" % [army.size(), Game.necro_army_cap()]
        var sig := str(army.size())
        if String(host.get("_hud_army_sig")) == sig:
                return
        host._hud_army_sig = sig
        for child in (hbox as HBoxContainer).get_children():
                (hbox as HBoxContainer).remove_child(child)
                child.queue_free()
        for i in range(mini(army.size(), 4)):
                var icon := TextureRect.new()
                icon.custom_minimum_size = Vector2(24, 24)
                icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
                icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
                icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
                icon.tooltip_text = String((army[i] as Dictionary).get("title", "Мертвец"))
                icon.texture = load("res://assets/sprites/icons/ability_resurrect.png")
                (hbox as HBoxContainer).add_child(icon)

## Общий вход обновления блока (из update_slots каждый кадр — дёшево).
static func refresh_abilities_block(host) -> void:
        if Game.hero_id == "demonologist":
                refresh_summon_cells(host)
        elif Game.hero_id == "necromancer":
                refresh_army_block(host)

## Подвинуть блок «СПОСОБНОСТИ» вслед за кнопкой ИНВЕНТАРЬ при изменении
## размера окна (вызывается из _resize_layout сцены).
static func reposition_abilities_block(host, view_x: float) -> void:
        var panel: Variant = host.get("_hud_bar")
        if panel == null:
                return
        for child in (panel as Control).get_children():
            if child is Control and child.has_meta("abilities_block"):
                (child as Control).position.x = view_x - float(host.BAR_BTN_SIZE.x) \
                        - 14.0 - (child as Control).size.x

## -------------------------------------------------------- HUD мира

## HUD мира (шаги 6/7/10/11/19/20/21/25/27): нижняя консоль, панель героя,
## золото, оружие, полосы хп/опыта/маны, слоты приёмов, кнопки, подсказка.
static func build_world(w) -> void:
        var layer := CanvasLayer.new()
        layer.name = "HUD"
        layer.layer = 20
        w.add_child(layer)

        # --- шаг 10: нижняя консоль UI — непрозрачная полоса вне экрана ходьбы.
        # Панель героя и кнопки кладём прямо в слой HUD (абсолютные координаты
        # в полосе консоли), джойстик — внутрь консоли (см. _build_joystick).
        w._hud_bar = Control.new()
        w._hud_bar.name = "HudBar"
        w._hud_bar.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
        w._hud_bar.offset_top = -w.UI_BAR_H
        layer.add_child(w._hud_bar)
        var bar_bg := Panel.new()
        bar_bg.name = "BarBackground"
        bar_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
        var bar_style := StyleBoxFlat.new()
        bar_style.bg_color = Color(0.07, 0.08, 0.13)
        bar_style.border_color = Color(0.5, 0.42, 0.16)
        bar_style.set_border_width_all(0)
        bar_style.border_width_top = 2
        bar_bg.add_theme_stylebox_override("panel", bar_style)
        w._hud_bar.add_child(bar_bg)
        var bar_top := 0.0   # координаты внутри нижней панели

        # мини-панель героя: портрет + имя + золото (в консоли, шаг 10;
        # шаг 27 — укрупнена под ПК: портрет 36, шрифты 11-13, полосы 150 px)
        var hero_panel := PanelContainer.new()
        # шаг 25: на ПК джойстика нет — панель героя прижата к левому краю консоли
        var hero_x: float = w.BAR_HERO_POS.x if DisplayServer.is_touchscreen_available() else 8.0
        hero_panel.position = Vector2(hero_x, bar_top + 8.0)
        var hero_style := UiStyle.flat_style(Color(0.11, 0.12, 0.19), Color(0.5, 0.42, 0.16))
        hero_style.content_margin_left = 6
        hero_style.content_margin_right = 10
        hero_style.content_margin_top = 5
        hero_style.content_margin_bottom = 5
        hero_panel.add_theme_stylebox_override("panel", hero_style)
        w._hud_bar.add_child(hero_panel)
        var hero_row := HBoxContainer.new()
        hero_row.add_theme_constant_override("separation", 8)
        hero_panel.add_child(hero_row)
        var hero_face := TextureRect.new()
        hero_face.custom_minimum_size = Vector2(36, 36)
        hero_face.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
        hero_face.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
        hero_face.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
        hero_face.texture = load(String(Game.HEROES.get(Game.hero_id, {}).get("portrait", "")))
        hero_row.add_child(hero_face)
        var hero_box := VBoxContainer.new()
        hero_box.add_theme_constant_override("separation", 1)
        hero_row.add_child(hero_box)
        var hero_name := Label.new()
        # шаг 19: рядом с именем — уровень героя
        hero_name.text = "%s · ур. %d" % [Game.hero_title(), Game.level]
        hero_name.add_theme_font_size_override("font_size", 13)
        hero_name.add_theme_color_override("font_color", Color(0.85, 0.88, 0.94))
        hero_box.add_child(hero_name)
        w._hud_gold = Label.new()
        w._hud_gold.add_theme_font_size_override("font_size", 13)
        w._hud_gold.add_theme_color_override("font_color", w.COLOR_GOLD)
        w._hud_gold.text = "Золото: %d" % Game.gold
        hero_box.add_child(w._hud_gold)
        w._cb_gold = func(new_gold: int) -> void:
                if is_instance_valid(w._hud_gold):
                        w._hud_gold.text = "Золото: %d" % new_gold
        Game.gold_changed.connect(w._cb_gold)

        # шаг 7: чем герой бьёт (кулаки или оружие из сумки); шаг 10: автоперенос —
        # длинное название оружия не распирает панель в узкой консоли
        w._hud_weapon = Label.new()
        w._hud_weapon.add_theme_font_size_override("font_size", 11)
        w._hud_weapon.add_theme_color_override("font_color", Color(0.62, 0.66, 0.74))
        w._hud_weapon.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
        w._hud_weapon.custom_minimum_size = Vector2(150, 0)
        w._hud_weapon.text = w._weapon_text()
        hero_box.add_child(w._hud_weapon)
        w._cb_equipped = func(_weapon_id: String) -> void:
                if is_instance_valid(w._hud_weapon):
                        w._hud_weapon.text = w._weapon_text()
                refresh_equipment(w)   # шаг 29: иконки мини-слотов экипировки
        Game.equipped_changed.connect(w._cb_equipped)
        # шаг 30: при надевании брони Game.emit armor_changed (а не
        # equipped_changed) — без этой связи иконка брони в HUD не появлялась.
        w._cb_armor = func(_armor_id: String) -> void:
                refresh_equipment(w)
        Game.armor_changed.connect(w._cb_armor)

        # шаг 6: полоса здоровья героя (видна всем героям)
        w._hud_hp = ProgressBar.new()
        w._hud_hp.custom_minimum_size = Vector2(150, 9)
        w._hud_hp.min_value = 0
        w._hud_hp.max_value = Game.max_hp()
        w._hud_hp.value = Game.hp
        w._hud_hp.show_percentage = false
        w._hud_hp.add_theme_stylebox_override("background",
                bar_style(Color(0.09, 0.08, 0.1), Color(0.45, 0.2, 0.2)))
        w._hud_hp.add_theme_stylebox_override("fill",
                bar_style(Color(0.72, 0.26, 0.26), Color(0.72, 0.26, 0.26)))
        hero_box.add_child(w._hud_hp)
        w._cb_hp = func(hp: int, max_hp: int) -> void:
                if is_instance_valid(w._hud_hp):
                        w._hud_hp.max_value = max_hp
                        w._hud_hp.value = hp
        Game.hp_changed.connect(w._cb_hp)
        # шаг 19: полоса опыта до следующего уровня
        w._hud_xp = ProgressBar.new()
        w._hud_xp.custom_minimum_size = Vector2(150, 6)
        w._hud_xp.min_value = 0
        w._hud_xp.max_value = Game.xp_needed()
        w._hud_xp.value = Game.xp
        w._hud_xp.show_percentage = false
        w._hud_xp.add_theme_stylebox_override("background",
                bar_style(Color(0.08, 0.08, 0.12), Color(0.35, 0.3, 0.16)))
        w._hud_xp.add_theme_stylebox_override("fill",
                bar_style(Color(0.85, 0.7, 0.2), Color(0.85, 0.7, 0.2)))
        hero_box.add_child(w._hud_xp)
        w._cb_xp = func(xp_value: int, xp_need: int) -> void:
                if is_instance_valid(w._hud_xp):
                        w._hud_xp.max_value = xp_need
                        w._hud_xp.value = xp_value
        Game.xp_changed.connect(w._cb_xp)
        w._cb_level = func(new_level: int) -> void:
                if is_instance_valid(hero_name):
                        hero_name.text = "%s · ур. %d" % [Game.hero_title(), new_level]
                # урон в руках вырос вместе с уровнем — обновить строку HUD
                if is_instance_valid(w._hud_weapon):
                        w._hud_weapon.text = w._weapon_text()
        Game.level_up.connect(w._cb_level)

        # шаг 6: полоса маны — только у мага (новый показатель при выборе мага)
        if Game.is_mage():
                w._hud_mana = ProgressBar.new()
                w._hud_mana.custom_minimum_size = Vector2(150, 9)
                w._hud_mana.min_value = 0
                w._hud_mana.max_value = Game.max_mana()
                w._hud_mana.value = Game.mana
                w._hud_mana.show_percentage = false
                w._hud_mana.add_theme_stylebox_override("background",
                        bar_style(Color(0.08, 0.09, 0.13), Color(0.2, 0.3, 0.45)))
                w._hud_mana.add_theme_stylebox_override("fill",
                        bar_style(Color(0.3, 0.6, 0.85), Color(0.3, 0.6, 0.85)))
                hero_box.add_child(w._hud_mana)
                w._cb_mana = func(mana: int, max_mana: int) -> void:
                        if is_instance_valid(w._hud_mana):
                                w._hud_mana.max_value = max_mana
                                w._hud_mana.value = mana
                Game.mana_changed.connect(w._cb_mana)

        # --- шаг 27: слоты приёмов Q / ПРОБЕЛ / T / CTRL с кулдаунами
        # --- шаг 29: мини-слоты экипировки и индикаторы эффектов — без пустых мест
        # --- шаг 30: блок «СПОСОБНОСТИ» — заготовка под будущие умения
        build_ability_slots(w, w._hud_bar)
        build_equipment_row(w, w._hud_bar)
        build_buffs_row(w, w._hud_bar)
        build_abilities_block(w, w._hud_bar)

        # --- шаг 30: в консоли осталась ОДНА кнопка — ИНВЕНТАРЬ (шаг 21:
        # инвентарь одним нажатием). Меню/сохранить/загрузить переехали в
        # паузу на Escape (PauseMenu), столбик из четырёх кнопок распущен.
        var actions: Array = [
                {"text": "ИНВЕНТАРЬ", "cb": w._on_bag_pressed},
        ]
        var total_h: float = float(actions.size()) * w.BAR_BTN_SIZE.y \
                + float(actions.size() - 1) * (w.BAR_BTN_STEP - w.BAR_BTN_SIZE.y)
        var start_y: float = (w.UI_BAR_H - total_h) / 2.0
        for i in range(actions.size()):
                var spec: Dictionary = actions[i]
                var btn := Button.new()
                btn.text = String(spec["text"])
                btn.position = Vector2(w.BAR_BUTTONS_X, bar_top + start_y + float(i) * w.BAR_BTN_STEP)
                style_small_button(btn, 12)
                btn.size = w.BAR_BTN_SIZE
                btn.pressed.connect(spec["cb"] as Callable)
                btn.set_meta("action_button", true)
                w._hud_bar.add_child(btn)

        w._resize_layout.call_deferred()

        w._hud_hint = Label.new()
        # шаг 10: подсказки — у верхнего края экрана ходьбы (временные, гаснут:
        # внизу теперь консоль UI, перекрывать мир они больше не должны)
        w._hud_hint.set_anchors_preset(Control.PRESET_TOP_WIDE)
        w._hud_hint.offset_top = 4.0
        w._hud_hint.offset_bottom = 46.0
        w._hud_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
        w._hud_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        w._hud_hint.add_theme_font_size_override("font_size", 14)
        w._hud_hint.add_theme_color_override("font_color", Color(0.85, 0.88, 0.94))
        w._hud_hint.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
        w._hud_hint.add_theme_constant_override("shadow_offset_y", 1)
        layer.add_child(w._hud_hint)
        Controls.bindings_changed.connect(w._refresh_controls_hint)
        w._refresh_controls_hint()

## HUD данжа (шаги 10/19/20/21/25/27): та же консоль + слоты приёмов
## + строка прогресса «Подземелье · ур. N/4 · врагов: K» над подсказкой.
static func build_dungeon(d) -> void:
        var layer := CanvasLayer.new()
        layer.name = "HUD"
        layer.layer = 20
        d.add_child(layer)
        d._hud_bar = Control.new()
        d._hud_bar.name = "HudBar"
        d._hud_bar.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
        d._hud_bar.offset_top = -d.UI_BAR_H
        layer.add_child(d._hud_bar)
        var bar_bg := Panel.new()
        bar_bg.name = "BarBackground"
        bar_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
        var bar_style := StyleBoxFlat.new()
        bar_style.bg_color = Color(0.07, 0.08, 0.13)
        bar_style.border_color = Color(0.5, 0.42, 0.16)
        bar_style.set_border_width_all(0)
        bar_style.border_width_top = 2
        bar_bg.add_theme_stylebox_override("panel", bar_style)
        d._hud_bar.add_child(bar_bg)
        var bar_top := 0.0
        var hero_panel := PanelContainer.new()
        # шаг 25: на ПК джойстика нет — панель героя у левого края консоли
        var hero_x: float = d.BAR_HERO_POS.x if DisplayServer.is_touchscreen_available() else 8.0
        hero_panel.position = Vector2(hero_x, bar_top + 8.0)
        var hero_style := UiStyle.flat_style(Color(0.11, 0.12, 0.19), Color(0.5, 0.42, 0.16))
        hero_style.content_margin_left = 6
        hero_style.content_margin_right = 10
        hero_style.content_margin_top = 5
        hero_style.content_margin_bottom = 5
        hero_panel.add_theme_stylebox_override("panel", hero_style)
        d._hud_bar.add_child(hero_panel)
        var hero_row := HBoxContainer.new()
        hero_row.add_theme_constant_override("separation", 8)
        hero_panel.add_child(hero_row)
        var hero_face := TextureRect.new()
        hero_face.custom_minimum_size = Vector2(36, 36)
        hero_face.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
        hero_face.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
        hero_face.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
        hero_face.texture = load(String(Game.HEROES.get(Game.hero_id, {}).get("portrait", "")))
        hero_row.add_child(hero_face)
        var hero_box := VBoxContainer.new()
        hero_box.add_theme_constant_override("separation", 1)
        hero_row.add_child(hero_box)
        var hero_name := Label.new()
        # шаг 19: рядом с именем — уровень героя
        hero_name.text = "%s · ур. %d" % [Game.hero_title(), Game.level]
        hero_name.add_theme_font_size_override("font_size", 13)
        hero_name.add_theme_color_override("font_color", Color(0.85, 0.88, 0.94))
        hero_box.add_child(hero_name)
        d._hud_gold = Label.new()
        d._hud_gold.add_theme_font_size_override("font_size", 13)
        d._hud_gold.add_theme_color_override("font_color", d.COLOR_GOLD)
        d._hud_gold.text = "Золото: %d" % Game.gold
        hero_box.add_child(d._hud_gold)
        d._cb_gold = func(new_gold: int) -> void:
                if is_instance_valid(d._hud_gold):
                        d._hud_gold.text = "Золото: %d" % new_gold
        Game.gold_changed.connect(d._cb_gold)
        var hud_weapon := Label.new()
        hud_weapon.add_theme_font_size_override("font_size", 11)
        hud_weapon.add_theme_color_override("font_color", Color(0.62, 0.66, 0.74))
        hud_weapon.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
        hud_weapon.custom_minimum_size = Vector2(150, 0)
        hud_weapon.text = "В руках: %s · %d ур." % [Game.strike_title(),
                Game.strike_damage()]
        hero_box.add_child(hud_weapon)
        d._cb_equipped = func(_weapon_id: String) -> void:
                if is_instance_valid(hud_weapon):
                        hud_weapon.text = "В руках: %s · %d ур." % [Game.strike_title(),
                                Game.strike_damage()]
                refresh_equipment(d)   # шаг 29: иконки мини-слотов экипировки
        Game.equipped_changed.connect(d._cb_equipped)
        # шаг 30: броня — через armor_changed (см. комментарий в build_world)
        d._cb_armor = func(_armor_id: String) -> void:
                refresh_equipment(d)
        Game.armor_changed.connect(d._cb_armor)
        d._hud_hp = ProgressBar.new()
        d._hud_hp.custom_minimum_size = Vector2(150, 9)
        d._hud_hp.min_value = 0
        d._hud_hp.max_value = Game.max_hp()
        d._hud_hp.value = Game.hp
        d._hud_hp.show_percentage = false
        d._hud_hp.add_theme_stylebox_override("background",
                bar_style(Color(0.09, 0.08, 0.1), Color(0.45, 0.2, 0.2)))
        d._hud_hp.add_theme_stylebox_override("fill",
                bar_style(Color(0.72, 0.26, 0.26), Color(0.72, 0.26, 0.26)))
        hero_box.add_child(d._hud_hp)
        d._cb_hp = func(hp: int, max_hp: int) -> void:
                if is_instance_valid(d._hud_hp):
                        d._hud_hp.max_value = max_hp
                        d._hud_hp.value = hp
        Game.hp_changed.connect(d._cb_hp)
        # шаг 19: полоса опыта до следующего уровня
        d._hud_xp = ProgressBar.new()
        d._hud_xp.custom_minimum_size = Vector2(150, 6)
        d._hud_xp.min_value = 0
        d._hud_xp.max_value = Game.xp_needed()
        d._hud_xp.value = Game.xp
        d._hud_xp.show_percentage = false
        d._hud_xp.add_theme_stylebox_override("background",
                bar_style(Color(0.08, 0.08, 0.12), Color(0.35, 0.3, 0.16)))
        d._hud_xp.add_theme_stylebox_override("fill",
                bar_style(Color(0.85, 0.7, 0.2), Color(0.85, 0.7, 0.2)))
        hero_box.add_child(d._hud_xp)
        d._cb_xp = func(xp_value: int, xp_need: int) -> void:
                if is_instance_valid(d._hud_xp):
                        d._hud_xp.max_value = xp_need
                        d._hud_xp.value = xp_value
        Game.xp_changed.connect(d._cb_xp)
        d._cb_level = func(new_level: int) -> void:
                if is_instance_valid(hero_name):
                        hero_name.text = "%s · ур. %d" % [Game.hero_title(), new_level]
                # урон в руках вырос вместе с уровнем — обновить строку HUD
                if is_instance_valid(hud_weapon):
                        hud_weapon.text = "В руках: %s · %d ур." % [Game.strike_title(),
                                Game.strike_damage()]
        Game.level_up.connect(d._cb_level)
        if Game.is_mage():
                d._hud_mana = ProgressBar.new()
                d._hud_mana.custom_minimum_size = Vector2(150, 9)
                d._hud_mana.min_value = 0
                d._hud_mana.max_value = Game.max_mana()
                d._hud_mana.value = Game.mana
                d._hud_mana.show_percentage = false
                d._hud_mana.add_theme_stylebox_override("background",
                        bar_style(Color(0.08, 0.09, 0.13), Color(0.2, 0.3, 0.45)))
                d._hud_mana.add_theme_stylebox_override("fill",
                        bar_style(Color(0.3, 0.6, 0.85), Color(0.3, 0.6, 0.85)))
                hero_box.add_child(d._hud_mana)
                d._cb_mana = func(mana: int, max_mana: int) -> void:
                        if is_instance_valid(d._hud_mana):
                                d._hud_mana.max_value = max_mana
                                d._hud_mana.value = mana
                Game.mana_changed.connect(d._cb_mana)
        # --- шаг 27: слоты приёмов Q / ПРОБЕЛ / T / CTRL с кулдаунами
        # --- шаг 29: мини-слоты экипировки и индикаторы эффектов — без пустых мест
        # --- шаг 30: блок «СПОСОБНОСТИ» — заготовка под будущие умения
        build_ability_slots(d, d._hud_bar)
        build_equipment_row(d, d._hud_bar)
        build_buffs_row(d, d._hud_bar)
        build_abilities_block(d, d._hud_bar)
        # Кнопка действий одна (шаг 30): ИНВЕНТАРЬ у правого края консоли;
        # меню/сохранить/загрузить — в паузе на Escape (PauseMenu).
        var actions: Array = [
                {"text": "ИНВЕНТАРЬ", "cb": d._on_bag_pressed},
        ]
        var total_h: float = float(actions.size()) * d.BAR_BTN_SIZE.y \
                + float(actions.size() - 1) * (d.BAR_BTN_STEP - d.BAR_BTN_SIZE.y)
        var start_y: float = (d.UI_BAR_H - total_h) / 2.0
        for i in range(actions.size()):
                var spec: Dictionary = actions[i]
                var btn := Button.new()
                btn.text = String(spec["text"])
                btn.size = d.BAR_BTN_SIZE
                btn.position = Vector2(d.BAR_BUTTONS_X, bar_top + start_y + float(i) * d.BAR_BTN_STEP)
                style_small_button(btn, 12)
                btn.pressed.connect(spec["cb"] as Callable)
                btn.set_meta("action_button", true)
                d._hud_bar.add_child(btn)
        d._resize_layout.call_deferred()
        # строка прогресса данжа — у верхнего края экрана ходьбы
        d._hud_floor = Label.new()
        d._hud_floor.set_anchors_preset(Control.PRESET_TOP_WIDE)
        d._hud_floor.offset_top = 4.0
        d._hud_floor.offset_bottom = 20.0
        d._hud_floor.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        d._hud_floor.add_theme_font_size_override("font_size", 13)
        d._hud_floor.add_theme_color_override("font_color", Color(0.72, 0.62, 0.9))
        d._hud_floor.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
        d._hud_floor.add_theme_constant_override("shadow_offset_y", 1)
        layer.add_child(d._hud_floor)
        d._hud_hint = Label.new()
        d._hud_hint.set_anchors_preset(Control.PRESET_TOP_WIDE)
        d._hud_hint.offset_top = 22.0
        d._hud_hint.offset_bottom = 64.0
        d._hud_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
        d._hud_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        d._hud_hint.add_theme_font_size_override("font_size", 14)
        d._hud_hint.add_theme_color_override("font_color", Color(0.85, 0.88, 0.94))
        d._hud_hint.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
        d._hud_hint.add_theme_constant_override("shadow_offset_y", 1)
        layer.add_child(d._hud_hint)
        Controls.bindings_changed.connect(d._refresh_controls_hint)
        d._refresh_controls_hint()
