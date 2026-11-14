## Интерактивный тест главного меню без ручного ввода:
## эмулирует тапы по сундуку, проверяет вылет кнопок, панель старта,
## слоты, бонус, сброс. Запуск: godot --headless --path . res://tests/menu_test.tscn
extends Node

var failed := 0
var state_before: Dictionary
var slots_before := {}
var meta_before: Dictionary

func check(name: String, condition: bool) -> void:
    if condition:
        print("  [OK] ", name)
    else:
        failed += 1
        print("  [ПРОВАЛ] ", name)

func _tap(menu: Node) -> void:
    var ev := InputEventMouseButton.new()
    ev.button_index = MOUSE_BUTTON_LEFT
    ev.pressed = true
    menu._on_chest_gui_input(ev)

func snapshot() -> void:
    state_before = Game.to_save_data()
    meta_before = Game.meta.duplicate(true)
    for slot in range(1, Game.SLOT_COUNT + 1):
        slots_before[slot] = Platform.load_data(slot)

func restore() -> void:
    Saves.wipe_all_slots()
    for slot in slots_before:
        var data: Dictionary = slots_before[slot]
        if not data.is_empty():
            Platform.save_data(data, slot)
    Game.meta = meta_before.duplicate(true)
    Game.current_slot = 0
    Game.save_meta()
    Game.load_save_data(state_before)
    var last := int(Game.meta.get("last_slot", 0))
    if last >= 1 and Platform.has_slot(last):
        Game.current_slot = last

func _ready() -> void:
    print("MENU TEST: сундук, кнопки, старт, слоты, бонус")
    snapshot()
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.meta["last_bonus_date"] = ""
    Game.meta["pending_gold"] = 0
    Game.meta["pending_items"] = []
    Game.current_slot = 0
    Game.save_meta()

    var menu: Node = (load("res://scenes/main/main.tscn") as PackedScene).instantiate()
    add_child(menu)
    await get_tree().process_frame
    await get_tree().process_frame

    var buttons: Node = menu.get_node("MenuButtons")
    var chest: TextureRect = menu.get_node("Chest")
    check("исходно кнопок нет", buttons.get_child_count() == 0)

    _tap(menu)
    await get_tree().create_timer(0.7).timeout
    check("1-й тап: вылетела «НАЧАТЬ ИГРУ»", buttons.get_child_count() == 1 and (buttons.get_child(0) as Button).text == "НАЧАТЬ ИГРУ")
    check("сундук сменил текстуру на открытую", chest.texture.resource_path == "res://assets/sprites/chest_open.png")

    _tap(menu)
    _tap(menu)
    _tap(menu)
    await get_tree().create_timer(0.7).timeout
    check("после 4 тапов все кнопки на месте", buttons.get_child_count() == 4)
    check("кнопки выстроились сверху вниз", (buttons.get_child(0) as Control).position.y < (buttons.get_child(3) as Control).position.y)
    check("первая кнопка в расчётном слоте", absf((buttons.get_child(0) as Control).position.y - 316.0) < 2.0)

    _tap(menu)
    await get_tree().create_timer(0.3).timeout
    check("лишний тап не добавляет кнопок", buttons.get_child_count() == 4)

    # --- панель старта: Новая игра / Продолжить / Загрузить ---
    menu._on_menu_button("start")
    await get_tree().create_timer(0.3).timeout
    check("панель старта открылась", menu.get_node("PanelLayer").visible \
        and menu.get_node("PanelLayer/Center/StartPanel").visible)
    check("в панели старта три пункта", menu.get_node("PanelLayer/Center/StartPanel/VBox/NewGameButton").text == "НОВАЯ ИГРА" \
        and menu.get_node("PanelLayer/Center/StartPanel/VBox/ContinueButton").text == "ПРОДОЛЖИТЬ" \
        and menu.get_node("PanelLayer/Center/StartPanel/VBox/LoadButton").text == "ЗАГРУЗИТЬ ИГРУ")
    check("«Продолжить» неактивна без сейва", menu.get_node("PanelLayer/Center/StartPanel/VBox/ContinueButton").disabled)

    menu._on_load_pressed()
    await get_tree().process_frame
    check("список слотов открылся", menu.get_node("PanelLayer/Center/StartPanel/SlotsBox").visible)
    check("три слота в списке", menu.get_node("PanelLayer/Center/StartPanel/SlotsBox/SlotsList").get_child_count() == 3)
    check("пустые слоты подписаны", (menu.get_node("PanelLayer/Center/StartPanel/SlotsBox/SlotsList").get_child(0) as Button).text.contains("пусто"))
    menu._on_slots_back_pressed()
    check("«Назад» вернул к пунктам старта", menu.get_node("PanelLayer/Center/StartPanel/VBox").visible)

    menu._close_panel()
    await get_tree().create_timer(0.1).timeout
    check("панель закрылась", not menu.get_node("PanelLayer").visible)

    # --- настройки и сброс (теперь стирает и слоты) ---
    menu._on_menu_button("settings")
    await get_tree().create_timer(0.3).timeout
    check("панель настроек открылась", menu.get_node("PanelLayer/Center/SettingsPanel").visible)

    Platform.save_data({"v": 2, "gold": 42}, 1)
    Game.meta["last_slot"] = 1
    Game.save_meta()
    check("слот 1 создан для проверки сброса", Platform.has_slot(1))

    var gold_before: int = Game.gold
    Game.add_gold(30)
    menu._on_reset_pressed()
    check("первый сброс — только подтверждение", Game.gold == gold_before + 30)
    check("кнопка перешла в режим подтверждения", (menu.get_node("PanelLayer/Center/SettingsPanel/VBox/ResetButton") as Button).text == "ТОЧНО СБРОСИТЬ?")
    menu._on_reset_pressed()
    check("второй сброс обнуляет прогресс", Game.gold == 0)
    check("сброс стёр слоты", not Platform.has_slot(1) and int(Game.meta.get("last_slot", -1)) == 0)

    # --- авторы: пользователь впишет себя сам ---
    menu._on_menu_button("authors")
    await get_tree().create_timer(0.2).timeout
    check("панель авторов открылась", menu.get_node("PanelLayer/Center/AuthorsPanel").visible)
    check("строка авторов ждёт имя автора", (menu.get_node("PanelLayer/Center/AuthorsPanel/VBox/IdeaLabel") as Label).text.contains("впиши себя"))
    menu._close_panel()

    # --- ежедневный бонус: 50-200 золота + фиолетовая добыча ---
    menu._on_menu_button("bonus")
    await get_tree().create_timer(0.2).timeout
    check("панель бонуса открылась", menu.get_node("PanelLayer/Center/BonusPanel").visible)
    check("кнопка подарка видна", menu.get_node("PanelLayer/Center/BonusPanel/VBox/ClaimButton").visible)
    var gold_pre: int = Game.gold
    menu._on_claim_bonus_pressed()
    var reward_text: String = (menu.get_node("PanelLayer/Center/BonusPanel/VBox/ResultLabel") as Label).text
    check("бонус начислил золото 50-200", Game.gold >= gold_pre + 50 and Game.gold <= gold_pre + 200)
    check("в награде упомянута фиолетовая добыча", reward_text.contains("золота") and reward_text.contains("добыча"))
    check("кнопка подарка скрыта после получения", not menu.get_node("PanelLayer/Center/BonusPanel/VBox/ClaimButton").visible)
    check("повторная выдача не происходит", Game.claim_daily_bonus().is_empty())
    menu._close_panel()

    menu._on_menu_button("bonus")
    await get_tree().create_timer(0.2).timeout
    var repeat_text: String = (menu.get_node("PanelLayer/Center/BonusPanel/VBox/ResultLabel") as Label).text
    check("повторное открытие: приходи завтра", repeat_text.contains("завтра"))
    menu._close_panel()

    # Возвращаем исходное состояние, чтобы тест не портил сейвы.
    restore()

    if failed == 0:
        print("MENU TEST: ВСЁ ОК")
        get_tree().quit(0)
    else:
        print("MENU TEST: ПРОВАЛОВ: ", failed)
        get_tree().quit(1)
