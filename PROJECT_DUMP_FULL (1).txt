# ПОЛНЫЙ ДАМП ПРОЕКТА «DUNGEON LOOT» (Godot 4.7.2)
Дата: 2026-11-14 · состояние: шаги 1–15 · файлов: 303 (текст 193 + PNG 110) · объём: 973760 байт.

Этот файл — человекочитаемый листинг ВСЕГО исходного кода проекта.
Парный к нему — `make_dungeon_loot.py`: одна команда
`python3 make_dungeon_loot.py` разворачивает проект байт-в-байт
(включая PNG и служебные .uid/.import — их содержимое здесь
не дублируется, это машинные файлы).

Контекст и архитектура: см. `PROJECT_DUMP.md` (раздел «передача дел»)
и `docs/DESIGN.md` — они включены ниже целиком.

---

## 1. Инвентарь

### Текстовые файлы (полное содержимое ниже)
- `.gitignore` — 301 байт
- `PROJECT_DUMP.md` — 42936 байт
- `assets/audio/music/.gitkeep` — 0 байт (пустой)
- `assets/audio/sfx/.gitkeep` — 0 байт (пустой)
- `assets/backgrounds/stars_far.png.import` — 780 байт
- `assets/backgrounds/stars_near.png.import` — 782 байт
- `assets/data/.gitkeep` — 0 байт (пустой)
- `assets/fonts/.gitkeep` — 0 байт (пустой)
- `assets/sprites/chars/barbarian.png.import` — 781 байт
- `assets/sprites/chars/bum.png.import` — 764 байт
- `assets/sprites/chars/demon.png.import` — 770 байт
- `assets/sprites/chars/glot.png.import` — 767 байт
- `assets/sprites/chars/gura.png.import` — 766 байт
- `assets/sprites/chars/lira.png.import` — 767 байт
- `assets/sprites/chars/mage.png.import` — 767 байт
- `assets/sprites/chars/viras.png.import` — 770 байт
- `assets/sprites/chars/warrior.png.import` — 776 байт
- `assets/sprites/chars/zlus.png.import` — 766 байт
- `assets/sprites/chars/zoran.png.import` — 770 байт
- `assets/sprites/chest_closed.png.import` — 785 байт
- `assets/sprites/chest_open.png.import` — 778 байт
- `assets/sprites/dungeon/cosmic_spider.png.import` — 796 байт
- `assets/sprites/dungeon/demon_sorcerer.png.import` — 799 байт
- `assets/sprites/dungeon/demon_swordsman.png.import` — 802 байт
- `assets/sprites/dungeon/snake.png.import` — 772 байт
- `assets/sprites/dungeon/spider.png.import` — 775 байт
- `assets/sprites/dungeon/undead_bum.png.import` — 786 байт
- `assets/sprites/dungeon/undead_knight.png.import` — 795 байт
- `assets/sprites/dungeon/undead_sorcerer.png.import` — 802 байт
- `assets/sprites/gift.png.import` — 761 байт
- `assets/sprites/icons/abyss_cloak.png.import` — 787 байт
- `assets/sprites/icons/armor_chain.png.import` — 788 байт
- `assets/sprites/icons/armor_leather.png.import` — 794 байт
- `assets/sprites/icons/armor_plate.png.import` — 788 байт
- `assets/sprites/icons/beer.png.import` — 766 байт
- `assets/sprites/icons/blade_frost.png.import` — 788 байт
- `assets/sprites/icons/comet_elixir.png.import` — 790 байт
- `assets/sprites/icons/greatsword.png.import` — 785 байт
- `assets/sprites/icons/ham.png.import` — 763 байт
- `assets/sprites/icons/hp_potion.png.import` — 782 байт
- `assets/sprites/icons/hp_potion_large.png.import` — 800 байт
- `assets/sprites/icons/hp_potion_small.png.import` — 800 байт
- `assets/sprites/icons/juice.png.import` — 770 байт
- `assets/sprites/icons/magic_bolt.png.import` — 784 байт
- `assets/sprites/icons/mana_potion.png.import` — 787 байт
- `assets/sprites/icons/mana_potion_large.png.import` — 806 байт
- `assets/sprites/icons/mana_potion_small.png.import` — 806 байт
- `assets/sprites/icons/morgenstern.png.import` — 787 байт
- `assets/sprites/icons/mors.png.import` — 766 байт
- `assets/sprites/icons/pouch_gold.png.import` — 785 байт
- `assets/sprites/icons/pouch_gray.png.import` — 785 байт
- `assets/sprites/icons/pouch_green.png.import` — 788 байт
- `assets/sprites/icons/pouch_violet.png.import` — 791 байт
- `assets/sprites/icons/robe_faded.png.import` — 785 байт
- `assets/sprites/icons/robe_stars.png.import` — 785 байт
- `assets/sprites/icons/robe_void.png.import` — 781 байт
- `assets/sprites/icons/scepter_comet.png.import` — 794 байт
- `assets/sprites/icons/star_blade.png.import` — 785 байт
- `assets/sprites/icons/sword.png.import` — 770 байт
- `assets/sprites/icons/wand_lightning.png.import` — 796 байт
- `assets/sprites/icons/water.png.import` — 770 байт
- `assets/sprites/portraits/barbarian.png.import` — 786 байт
- `assets/sprites/portraits/bum.png.import` — 768 байт
- `assets/sprites/portraits/demon.png.import` — 774 байт
- `assets/sprites/portraits/door.png.import` — 770 байт
- `assets/sprites/portraits/glot.png.import` — 770 байт
- `assets/sprites/portraits/gura.png.import` — 770 байт
- `assets/sprites/portraits/lira.png.import` — 771 байт
- `assets/sprites/portraits/mage.png.import` — 771 байт
- `assets/sprites/portraits/viras.png.import` — 773 байт
- `assets/sprites/portraits/warrior.png.import` — 780 байт
- `assets/sprites/portraits/zlus.png.import` — 771 байт
- `assets/sprites/portraits/zoran.png.import` — 774 байт
- `assets/sprites/props/anvil.png.import` — 770 байт
- `assets/sprites/props/arch.png.import` — 766 байт
- `assets/sprites/props/asteroid_1.png.import` — 784 байт
- `assets/sprites/props/asteroid_2.png.import` — 785 байт
- `assets/sprites/props/banner_blue.png.import` — 788 байт
- `assets/sprites/props/banner_red.png.import` — 785 байт
- `assets/sprites/props/barrel.png.import` — 773 байт
- `assets/sprites/props/bench.png.import` — 769 байт
- `assets/sprites/props/brazier_0.png.import` — 781 байт
- `assets/sprites/props/brazier_1.png.import` — 781 байт
- `assets/sprites/props/brazier_2.png.import` — 781 байт
- `assets/sprites/props/cart_gura.png.import` — 782 байт
- `assets/sprites/props/crate.png.import` — 770 байт
- `assets/sprites/props/crystal_0.png.import` — 782 байт
- `assets/sprites/props/crystal_1.png.import` — 780 байт
- `assets/sprites/props/crystal_violet_0.png.import` — 802 байт
- `assets/sprites/props/crystal_violet_1.png.import` — 802 байт
- `assets/sprites/props/door_dungeon.png.import` — 791 байт
- `assets/sprites/props/forge_0.png.import` — 776 байт
- `assets/sprites/props/forge_1.png.import` — 775 байт
- `assets/sprites/props/forge_2.png.import` — 775 байт
- `assets/sprites/props/fountain_0.png.import` — 784 байт
- `assets/sprites/props/fountain_1.png.import` — 785 байт
- `assets/sprites/props/fountain_2.png.import` — 785 байт
- `assets/sprites/props/island.png.import` — 773 байт
- `assets/sprites/props/lantern.png.import` — 776 байт
- `assets/sprites/props/moon.png.import` — 767 байт
- `assets/sprites/props/planet.png.import` — 773 байт
- `assets/sprites/props/pointer.png.import` — 776 байт
- `assets/sprites/props/sacks.png.import` — 770 байт
- `assets/sprites/props/shadow.png.import` — 773 байт
- `assets/sprites/props/stall_blue.png.import` — 785 байт
- `assets/sprites/props/stall_red.png.import` — 781 байт
- `assets/sprites/props/stand_zlus.png.import` — 785 байт
- `assets/sprites/props/throne.png.import` — 773 байт
- `assets/sprites/props/torch_0.png.import` — 776 байт
- `assets/sprites/props/torch_1.png.import` — 776 байт
- `assets/sprites/props/torch_2.png.import` — 776 байт
- `assets/tilesets/.gitkeep` — 0 байт (пустой)
- `assets/tilesets/dungeon_tiles.png.import` — 789 байт
- `assets/tilesets/world_tiles.png.import` — 783 байт
- `assets/ui/.gitkeep` — 0 байт (пустой)
- `docs/DESIGN.md` — 55721 байт
- `dungeon_foes_preview.png.import` — 794 байт
- `icon.png.import` — 746 байт
- `locales/.gitkeep` — 0 байт (пустой)
- `project.godot` — 5385 байт
- `scenes/battle/.gitkeep` — 0 байт (пустой)
- `scenes/character_select/character_select.gd` — 8187 байт
- `scenes/character_select/character_select.gd.uid` — 20 байт
- `scenes/character_select/character_select.tscn` — 326 байт
- `scenes/dungeon/dungeon.gd` — 79145 байт
- `scenes/dungeon/dungeon.gd.uid` — 19 байт
- `scenes/dungeon/dungeon.tscn` — 188 байт
- `scenes/main/main.gd` — 12953 байт
- `scenes/main/main.gd.uid` — 20 байт
- `scenes/main/main.tscn` — 12600 байт
- `scenes/ui/.gitkeep` — 0 байт (пустой)
- `scenes/world/.gitkeep` — 0 байт (пустой)
- `scenes/world/dialogue_ui.gd` — 13359 байт
- `scenes/world/dialogue_ui.gd.uid` — 19 байт
- `scenes/world/inventory_ui.gd` — 23535 байт
- `scenes/world/inventory_ui.gd.uid` — 20 байт
- `scenes/world/trade_ui.gd` — 15341 байт
- `scenes/world/trade_ui.gd.uid` — 19 байт
- `scenes/world/world.gd` — 93156 байт
- `scenes/world/world.gd.uid` — 20 байт
- `scenes/world/world.tscn` — 178 байт
- `scripts/autoload/game_state.gd` — 42155 байт
- `scripts/autoload/game_state.gd.uid` — 20 байт
- `scripts/autoload/platform.gd` — 4134 байт
- `scripts/autoload/platform.gd.uid` — 19 байт
- `scripts/autoload/save_manager.gd` — 2535 байт
- `scripts/autoload/save_manager.gd.uid` — 20 байт
- `scripts/data/dungeon_bestiary.gd` — 40762 байт
- `scripts/data/dungeon_bestiary.gd.uid` — 20 байт
- `scripts/data/items.gd` — 14702 байт
- `scripts/data/items.gd.uid` — 20 байт
- `scripts/data/world_map.gd` — 16284 байт
- `scripts/data/world_map.gd.uid` — 20 байт
- `scripts/loot.gd` — 6673 байт
- `scripts/loot.gd.uid` — 19 байт
- `scripts/ui/virtual_joystick.gd` — 2935 байт
- `scripts/ui/virtual_joystick.gd.uid` — 20 байт
- `scripts/ui_style.gd` — 1950 байт
- `scripts/ui_style.gd.uid` — 20 байт
- `tests/demon_test.gd` — 16333 байт
- `tests/demon_test.gd.uid` — 19 байт
- `tests/demon_test.tscn` — 178 байт
- `tests/dungeon_test.gd` — 15017 байт
- `tests/dungeon_test.gd.uid` — 20 байт
- `tests/dungeon_test.tscn` — 196 байт
- `tests/menu_test.gd` — 8338 байт
- `tests/menu_test.gd.uid` — 20 байт
- `tests/menu_test.tscn` — 184 байт
- `tests/screenshot.gd` — 5160 байт
- `tests/screenshot.gd.uid` — 19 байт
- `tests/screenshot.tscn` — 177 байт
- `tests/shot_demon.gd` — 2367 байт
- `tests/shot_demon.gd.uid` — 20 байт
- `tests/shot_demon.tscn` — 166 байт
- `tests/smoke_test.gd` — 29611 байт
- `tests/smoke_test.gd.uid` — 20 байт
- `tests/smoke_test.tscn` — 178 байт
- `tests/trade_test.gd` — 12605 байт
- `tests/trade_test.gd.uid` — 20 байт
- `tests/trade_test.tscn` — 178 байт
- `tests/world_test.gd` — 27950 байт
- `tests/world_test.gd.uid` — 19 байт
- `tests/world_test.tscn` — 188 байт
- `tools/check_map.py` — 1410 байт
- `tools/gen_armor.py` — 6028 байт
- `tools/gen_chars.py` — 27688 байт
- `tools/gen_demon.py` — 14630 байт
- `tools/gen_doors.py` — 3174 байт
- `tools/gen_dungeon.py` — 19020 байт
- `tools/gen_portraits.py` — 28443 байт
- `tools/gen_world_art.py` — 35692 байт
- `tools/gen_worldmap.py` — 10441 байт
- `tools/px.py` — 3980 байт

### PNG-ассеты (вшиты в сборщик base64, 110 шт.)

- **(корень)**: `dungeon_foes_preview.png` (8513 Б), `icon.png` (1172 Б)
- **assets/backgrounds**: `stars_far.png` (3590 Б), `stars_near.png` (1529 Б)
- **assets/sprites**: `chest_closed.png` (284 Б), `chest_open.png` (219 Б), `gift.png` (188 Б)
- **assets/sprites/chars**: `barbarian.png` (4016 Б), `bum.png` (3471 Б), `demon.png` (14828 Б), `glot.png` (3492 Б), `gura.png` (3412 Б), `lira.png` (3477 Б), `mage.png` (2962 Б), `viras.png` (3255 Б), `warrior.png` (3753 Б), `zlus.png` (3151 Б), `zoran.png` (3755 Б)
- **assets/sprites/dungeon**: `cosmic_spider.png` (2824 Б), `demon_sorcerer.png` (1640 Б), `demon_swordsman.png` (1855 Б), `snake.png` (1944 Б), `spider.png` (2654 Б), `undead_bum.png` (1793 Б), `undead_knight.png` (1982 Б), `undead_sorcerer.png` (1607 Б)
- **assets/sprites/icons**: `abyss_cloak.png` (164 Б), `armor_chain.png` (312 Б), `armor_leather.png` (277 Б), `armor_plate.png` (266 Б), `beer.png` (163 Б), `blade_frost.png` (177 Б), `comet_elixir.png` (175 Б), `greatsword.png` (156 Б), `ham.png` (213 Б), `hp_potion.png` (176 Б), `hp_potion_large.png` (171 Б), `hp_potion_small.png` (168 Б), `juice.png` (156 Б), `magic_bolt.png` (216 Б), `mana_potion.png` (176 Б), `mana_potion_large.png` (171 Б), `mana_potion_small.png` (167 Б), `morgenstern.png` (255 Б), `mors.png` (173 Б), `pouch_gold.png` (177 Б), `pouch_gray.png` (177 Б), `pouch_green.png` (177 Б), `pouch_violet.png` (175 Б), `robe_faded.png` (247 Б), `robe_stars.png` (246 Б), `robe_void.png` (247 Б), `scepter_comet.png` (158 Б), `star_blade.png` (166 Б), `sword.png` (152 Б), `wand_lightning.png` (150 Б), `water.png` (156 Б)
- **assets/sprites/portraits**: `barbarian.png` (1546 Б), `bum.png` (1602 Б), `demon.png` (1122 Б), `door.png` (834 Б), `glot.png` (1735 Б), `gura.png` (1737 Б), `lira.png` (1549 Б), `mage.png` (1780 Б), `viras.png` (1498 Б), `warrior.png` (1610 Б), `zlus.png` (1672 Б), `zoran.png` (1561 Б)
- **assets/sprites/props**: `anvil.png` (179 Б), `arch.png` (410 Б), `asteroid_1.png` (189 Б), `asteroid_2.png` (185 Б), `banner_blue.png` (172 Б), `banner_red.png` (172 Б), `barrel.png` (181 Б), `bench.png` (139 Б), `brazier_0.png` (202 Б), `brazier_1.png` (190 Б), `brazier_2.png` (211 Б), `cart_gura.png` (349 Б), `crate.png` (154 Б), `crystal_0.png` (191 Б), `crystal_1.png` (221 Б), `crystal_violet_0.png` (191 Б), `crystal_violet_1.png` (222 Б), `door_dungeon.png` (438 Б), `forge_0.png` (238 Б), `forge_1.png` (237 Б), `forge_2.png` (244 Б), `fountain_0.png` (337 Б), `fountain_1.png` (369 Б), `fountain_2.png` (362 Б), `glow.png` (2792 Б), `island.png` (277 Б), `lantern.png` (428 Б), `moon.png` (190 Б), `planet.png` (975 Б), `pointer.png` (127 Б), `sacks.png` (156 Б), `shadow.png` (141 Б), `stall_blue.png` (266 Б), `stall_red.png` (264 Б), `stand_zlus.png` (271 Б), `throne.png` (288 Б), `torch_0.png` (199 Б), `torch_1.png` (168 Б), `torch_2.png` (164 Б)
- **assets/tilesets**: `dungeon_tiles.png` (3228 Б), `world_tiles.png` (2195 Б)

---

## 2. Полное содержимое текстовых файлов

### Конфиг и корень

#### `project.godot`

````ini
; Engine configuration file.
; Лучше править через редактор: Проект -> Настройки проекта.

config_version=5

[application]

config/name="Dungeon Loot"
run/main_scene="res://scenes/main/main.tscn"
config/features=PackedStringArray("4.7", "GL Compatibility")
config/icon="res://icon.png"

[autoload]

Platform="*res://scripts/autoload/platform.gd"
Game="*res://scripts/autoload/game_state.gd"
Saves="*res://scripts/autoload/save_manager.gd"

[display]

window/size/viewport_width=360
window/size/viewport_height=640
window/size/window_width_override=720
window/size/window_height_override=1280
window/stretch/mode="canvas_items"
window/stretch/aspect="keep"
window/handheld/orientation=1

[input]

move_left={
"deadzone": 0.2,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":4194319,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":65,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
]
}
move_right={
"deadzone": 0.2,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":4194321,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":68,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
]
}
move_up={
"deadzone": 0.2,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":4194320,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":87,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
]
}
move_down={
"deadzone": 0.2,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":4194322,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":83,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
]
}
interact={
"deadzone": 0.2,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":69,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":70,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
]
}
attack={
"deadzone": 0.2,
"events": [Object(InputEventMouseButton,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"button_mask":0,"position":Vector2(0, 0),"global_position":Vector2(0, 0),"factor":1.0,"button_index":1,"canceled":false,"pressed":false,"double_click":false,"script":null)
]
}
toggle_inventory={
"deadzone": 0.2,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":73,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
]
}
cast_spell={
"deadzone": 0.2,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":81,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
]
}

[input_devices]

pointing/emulate_mouse_from_touch=true

[rendering]

renderer/rendering_method="gl_compatibility"
renderer/rendering_method.mobile="gl_compatibility"
textures/canvas_textures/default_texture_filter=0
textures/vram_compression/import_etc2_astc=true
2d/snap/snap_2d_transforms_to_pixel=true

````

#### `.gitignore`

````
# Кэш импорта Godot (генерируется редактором)
.godot/

# Скомпилированные переводы
*.translation

# Служебное ОС
.DS_Store
Thumbs.db

# Экспортные сборки, если сложим их внутрь проекта
/build/

````

#### `PROJECT_DUMP.md`

````markdown
# ДАМП ПРОЕКТА «DUNGEON LOOT» — контекст для нового чата

Дата дампа: 2026-11-14. Состояние: рабочее, выполнены шаги 1–15, синтаксис чист.
Этот файл — «передача дел»: читается вместе с `docs/DESIGN.md` (подробный дизайн-док,
разделы 5д/5е — шаг 12, 5ж — шаг 13, 5з — шаг 14, 5и — шаг 15) и `project.godot`.
Сборка проекта с нуля на любой машине — `python3 make_dungeon_loot.py` (скрипт
содержит ВСЕ файлы проекта и PNG в base64: текст, сцены, доки, арт).

---

## 1. Что это за проект

- Godot 4.7 (проверялось на движке 4.7.2), чистый GDScript, без плагинов.
- Вертикальная мини-RPG (рогалик) 360×640 (окно 720×1280), пиксель-арт,
  сетка тайлов 16×16, фильтр nearest.
- Сеттинг «космо-фэнтези» с уклоном в космо-хоррор: фэнтезийный замок,
  парящий в космосе; из замка можно выйти на улицу, у края улицы — ограда,
  за ней безграничный космос (жители замка давно поняли, что «что-то не так»).
- Язык игры — русский. Весь арт генерируется Python-скриптами (Pillow) из `tools/`,
  он воспроизводим.
- Целевые платформы релиза 2026: Яндекс Игры (HTML5) и RuStore (Android).
- Рабочее название: **Dungeon Loot** (помечено в меню как «рабочее название»).

## 2. Состояние на момент дампа (проверено сегодня)

Выполнены шаги 1–15. Прогресс по шагам:

1. Проект, автозагрузки, лут — готово.
2. Главное меню с сундуком — готово.
3. Мир и движение (тайлмап замок+улица+край космоса, камера, NPC, 4 двери данжей,
   3 слота сейвов, выбор героя, ежедневный бонус) — готово.
4. Арт-полировка (анимации 24×32, Лира, диалог с портретом, инвентарь 20 слотов,
   новый тайлсет, y-sort, тени, указатель) — готово.
5. Деньги и торговля (стартовое золото героев, лавка TradeUI, покупка/продажа) — готово.
6. ХП/мана, предметы-расходники, «Магическая стрела» у мага, напитки Глота,
   магическое оружие Зорана — готово.
7. Боевая система: удары, оружие в руках, хп NPC, трупы без воскрешения в сессии,
   реакция NPC на убийство, зелья трёх размеров — готово.
8. Демон у края мира + ужесточение памяти NPC — готово (см. раздел 7).
9. Урон магии, явные запертые двери, хтонические реплики, фикс 4.7.2 джойстика — готово.
10. Фикс диалога демона, выходящего за экран (панель растёт вверх, низ закреплён) — готово.
11. Переназначение клавиш (диалог на E/F, удар на ЛКМ), сжатие консоли UI,
    гарантия «диалог никогда не выйдет за экран» — готово.
12. **Боевая система на демоне: броня и одеяния (2 ячейки экипировки),
    классовые множители оружия, магические залпы на Q, ярость демона после
    3 ударов (он дерётся), смерть героя («ТЫ ПАЛ»), реплики переписаны под
    лавкрафтовский космо-хоррор («добряки» → «жители»)** — готово (см. разделы 6–8).
13. **1-й данж «Подземелье замка» и вечная смерть демона** — готово (см. раздел 9):
    - подписи «Данж N» убраны с дверей; дверь 1 открыта — ведёт в данж;
    - 10 этажей, на каждом 1–5 врагов, этажи генерируются заново при входе;
    - 8 видов врагов по возрастанию сложности + обязательный босс;
    - ярость демона гаснет при возрождении героя;
    - убитый демон (на карте или как босс) повержен НАВСЕГДА: жертвы
      оживают и забывают, демон не возвращается (сейв v6).
14. **Сундуки подземелья и эпическая награда босса** — готово (см. раздел 9
    и DESIGN.md 5з):
    - 1–2 сундука на этаже: клик или E — открытие, внутри золото, зелья,
      питьё/еда, оружие, броня или одеяния (таблицы `Loot.chest_loot`,
      состав растёт с глубиной этажа; веса — ЗАГЛУШКИ);
    - за босса выпадает ЭПИЧЕСКОЕ случайное оружие золотого качества
      (`Loot.epic_weapon_loot`);
    - выход на 10-м этаже не встаёт на сундук (`_free_exit_tile`);
    - фиксы parse-ошибок шага 13: `Rect2i.grow` (не «grows») и явный тип
      при Variant-арифметике (ловушки №2/№5).
15. **4 больших тематических этажа вместо 10** («получше, больше, красивее,
    интереснее» — по просьбе автора) — готово (см. раздел 9 и DESIGN.md 5и):
    карта 64×48 (было 40×36, ×2.4 площади), 10–13 комнат, врагов 7–13
    вместо 1–5, элитные чемпионы и хранитель сокровищницы; 4 темы этажей
    («Смрадные катакомбы» → «Багровое логово»): свои тайлы стен/полов,
    «воздух» (CanvasModulate), мягкий свет у героя, 10–14 мерцающих факелов,
    реквизит (жаровни/трон/кристаллы/бочки), декор-тайлы (паутина, кровь,
    светящиеся трещины); сокровищница с золотой мозаикой на этажах 1–3,
    зал босса 22×14 с колоннами, жаровнями, троном и ковровой дорожкой
    на 4-м; сундуков 4–5 на этаж (2 в сокровищнице/углах зала); атлас
    тайлов расширен до 25, добавлен `props/glow.png`.

Проверка 2026-11-14: в песочнице появился Godot 4.4.1 headless (скачан с
официального сайта) — движок впервые прогнал ВСЕ 6 тестов
(`smoke/menu/trade/demon/world/dungeon`) — все «ВСЁ ОК», SCRIPT ERROR: 0;
чистый `--import` проекта тоже без ошибок. Это сильнее gdparse: валидируй
правки именно движком (см. раздел 15).

Фиксы этого прогона (шаг 14 и тесты):
- `Loot.chest_loot`: пул строк обрабатывался `_weighted_pick` как таблица
  весов — parse-ошибка `String(Dictionary)` блокировала компиляцию данжа,
  лавки, инвентаря и обоих тестов. Пулы выбираются новым `_pick_id`.
- `dungeon.gd`: `IntervalTweener.tween_callback` не существует — цепочка
  эпической подсказки строится на самом Tween (`tween_interval` +
  `tween_callback` двумя вызовами).
- Утечки сигналов Game (автозагрузка переживает смену сцены): лямбды/методы
  HUD в `world.gd`, `dungeon.gd`, меню и лавке отвязываются в `_exit_tree` —
  иначе после ухода из сцены мёртвый обработчик падал на первом же
  изменении золота/хп (в реальной игре, не только в тестах).
- `TradeUI._refresh`: строки списка теперь `queue_free`, а не мгновенный
  `free` — раньше убивал кнопку прямо во время испускания `pressed`
  («freed while signal is emitted» при каждой покупке).
- Тесты: `world_test` искал Ground/дверь прямыми детьми мира (после шага
  10/11 они в SubViewport) — пути исправлены; `dungeon_test` требовал
  «герой выжил под боссом 2.5 с» — воин 50 хп под боссом и миньонами может
  честно погибнуть, проверяется только урон; `demon_test` требовал
  `is_npc_dead("demon")` — но `defeat_demon_permanently` чистит
  `dead_npcs` (труп демона — не «жертва»), проверка переписана.

## 3. Структура файлов (строки кода — без .uid/.import)

```
project.godot            — конфиг: автозагрузки Platform/Game/Saves, input map, 360×640, gl_compatibility
docs/DESIGN.md           — дизайн-документ по шагам (главный источник решений,
                           шаг 12 — 5д/5е, шаг 13 — 5ж, шаг 14 — 5з)
scenes/main/             — main.gd (300): главное меню, сундук, слоты, настройки, авторы, бонус
scenes/character_select/ — character_select.gd (196): выбор героя, хп/мана/золото на карточке
scenes/world/world.gd    — (~1650) уличная сцена: тайлы, пропы, NPC, демон (ИИ ярости + сброс),
                           игрок (включая экран смерти), физика в SubViewport, удары/магия/залпы,
                           HUD, джойстик, реплики NPC (лавкрафт-хоррор), дверь 1 — вход в данж
scenes/dungeon/dungeon.gd— (~1790, шаги 13–15) Подземелье замка: 4 больших тематических
                           этажа (рандом-генерация: комнаты, коридоры, свет, факелы,
                           реквизит), враги с ИИ (погоня/болты/элита), лестницы
                           (вниз — после тишины), босс-диалог и битва, победа = вечная
                           смерть демона + ожившие NPC + ЭПИЧЕСКОЕ оружие, сундуки
                           (4–5 на этаж, открытие клик/E), HUD прогресса,
                           смерть героя — выход в замок
scenes/world/dialogue_ui.gd  — (258) диалоговое окно с портретом, машинка, ТОРГОВАТЬ, clamp высоты
scenes/world/trade_ui.gd     — (322) лавка: вкладки ПОКУПКА/ПРОДАЖА, иконки, цены
scenes/world/inventory_ui.gd — (~470) сумка 20 слотов, СЪЕСТЬ/ВЫПИТЬ, ВЗЯТЬ В РУКИ,
                           ОДЕТЬ/СНЯТЬ, 2 ячейки экипировки ОРУЖИЕ/БРОНЯ (клик — снять)
scripts/autoload/game_state.gd — (~830) автозагрузка Game: герои, золото, инвентарь, хп/мана,
                           удар/заклинания (залпы), броня/одеяния, удар/смерть NPC,
                           демон (скидка, ярость после 3 ударов, сброс при возрождении,
                           вечная смерть demon_defeated, demon_seen, dungeon_floor), сейв-данные v6
scripts/autoload/save_manager.gd — (51) автозагрузка Saves: 3 слота user://save_slot_N.json, request_save
scripts/autoload/platform.gd     — (101) автозагрузка Platform: платформенные мелочи
scripts/data/items.gd    — (~270) ItemDB: все предметы, цены, эффекты, броня/одеяния,
                           флаг magic + volley у магического оружия, VIOLET_UNIQUES, USABLE_TYPES
scripts/data/world_map.gd— (187) WorldMap: карта 30×56, PROPS, NPCS (товары, хп, реплики), RAILING_ROW
scripts/data/dungeon_bestiary.gd — (~770, шаги 13–15) DungeonBestiary: 8 врагов + босс (хп/урон/
                           скорость/дистанции — ЗАГЛУШКИ), THEMES — 4 темы этажей (тайлы,
                           «воздух»/CanvasModulate, свет, декор, реплика входа), генератор
                           этажа (комнаты+коридоры+сокровищница/зал босса, декор до врагов,
                           MAP 64×48, FLOORS 4, сундуки 4–5 — _pick_chest_tiles, факелы
                           10–14 — _pick_torch_tiles, реквизит — _pick_prop_tiles)
scripts/ui/virtual_joystick.gd — (60) джойстик БЕЗ class_name (фикс 4.7.2, грузится по пути)
scripts/loot.gd          — (133) Loot: качества добычи, таблицы сундуков
                           (CHEST_TABLES/CHEST_POOLS по глубине, chest_loot) и эпическое
                           оружие босса (epic_weapon_loot, EPIC_WEAPONS — ЗАГЛУШКИ);
scripts/ui_style.gd      — стили UI
tests/                   — smoke/menu/world/trade/demon/dungeon_test (.tscn + .gd), screenshot.gd, shot_demon.gd
tools/                   — генераторы арта (PIL): gen_chars/gen_portraits/gen_world_art/
                           gen_worldmap/gen_demon/gen_doors/gen_armor (иконки экипировки),
                           gen_dungeon (шаг 13: 9 базовых тайлов + 8 врагов; расширение
                           атласа до 25 тайлов и glow.png шага 15 — разовым скриптом,
                           в tools/ не сохранён; актуальные PNG переносит сборщик),
                           check_map.py, px.py
assets/                  — сгенерированные png (sprites/chars, sprites/dungeon, portraits, icons,
                           props, tilesets, backgrounds)
locales/, assets/audio/  — пустые заготовки (звука и локализации пока нет)
```

## 4. Автозагрузки и входные действия

- Автозагрузки: `Platform`, `Game` (game_state.gd), `Saves` (save_manager.gd).
- Input map (project.godot): `move_*` — WASD+стрелки; `interact` — **E и F** (диалог/листание
  реплик); `attack` — **левая кнопка мыши**; `toggle_inventory` — I; `cast_spell` — Q.
  Клавиша E удар больше не бьёт (шаг 11); мобильная адаптация отложена автору
  («под телефон потом»), но джойстик и emulate_mouse_from_touch уже готовы.

## 5. Ключевые API `Game` (scripts/autoload/game_state.gd)

- Сигналы: `gold_changed, inventory_changed, hp_changed, mana_changed,
  equipped_changed, armor_changed, npc_killed, demon_enraged_changed,
  npcs_revived`.
- Деньги/сумка: `add_gold/spend_gold/buy_item/sell_item/add_item/use_consumable`
  (продажа надетого оружия/брони снимает его).
- Герой: `is_mage` (по врождённой мане, экипировка магом не делает),
  `max_hp/max_mana` (с бонусом брони/одеяния), `heal_hp/damage_hp,
  spend_mana/regen_mana/restore_mana`, `cast_spell`, `spell_info` (что вылетит на Q),
  `non_mage_spell_hint`, `equip_weapon/try_equip_weapon/unequip_weapon/has_weapon,
  equip_armor/unequip_armor/has_armor`, `strike_damage` (с классовыми множителями),
  `strike_is_magic_surge`, `strike_swing_color`, `strike_title`.
- Классы: `CLASS_STRIKE_MULT {mage: 0.5, barbarian: 2.0}`, `MAGIC_SURGE_FACTOR 0.25`
  (магический эффект магического оружия у воина/бомжа), варвару магическое оружие
  не даётся (`try_equip_weapon` → `barbarian_rejected`).
- Смерть NPC и демон: `is_npc_dead, kill_npc, demon_kill_count, demon_discount_pct,
  npc_def, demon_goods, demon_price, buy_from_demon` (скидка −10% за убитого NPC, max 90%),
  `register_demon_hit` + `demon_hits/demon_enraged/DEMON_RAGE_HITS=3` (ярость, шаг 12);
  шаг 13: `reset_demon_rage` (возрождение героя гасит ярость), `mark_demon_seen`,
  `demon_gone_forever`, `revive_all_npcs`, `defeat_demon_permanently`, `dungeon_floor`.
- Прогресс: `mark_dungeon_cleared, set_setting, reset_progress, pick_new_slot,
  new_run, continue_run, claim_daily_bonus, can_claim_bonus, to_save_data, load_save_data`.
- Состояние сессии, НЕ попадающее в сейв: `dead_npcs`, демон (жив/мёртв), скидка,
  `demon_hits/demon_enraged`, `demon_seen`, `dungeon_floor`. Новая игра/загрузка слота
  воскрешает мир и гасит ярость. В сейв (v6) пишется только `demon_defeated` —
  демон, поверженный навсегда, не возвращается и после загрузки.

## 6. Герои, удар, заклинания (шаги 7/12)

| Герой | Золото | ХП | Мана | Обычное оружие |
|---|---|---|---|---|
| Воин | 100 | 50 (ЗАГЛУШКА) | — | ×1 |
| Варвар | 50 | 60 (ЗАГЛУШКА) | — | ×2 (магическое — нельзя) |
| Бомж | 1 | 20 (ЗАГЛУШКА) | — | ×1 |
| Маг | 60 | 30 (автор) | 70 (автор) | ×0.5 |

- Удар (ЛКМ/УДАР): без оружия кулак 5 урона (ЗАГЛУШКА), с оружием — урон из ItemDB
  × классовый множитель (меч: маг 15, воин 30, варвар 60). Магическое оружие:
  маг — полная сила, воин/бомж — урон +25% («магический эффект», вспышка цвета),
  варвар — взять нельзя. Дистанция 28 px, кулдаун 0.4 с.
- **Q у мага** (`Game.spell_info`): без магического оружия — «Магическая стрела»
  (12 маны, 15 урона, 240 px/с, 150 px, кд 0.35; реген маны 2/с); с магическим —
  **залп оружия** (веер снарядов, параметры из `ItemDB.volley`):
  жезл молний — «Залп молний» 3×10 за 15 маны; клинок инея — «Залп инея» 3×12 за 16;
  скипетр кометы — «Кометный залп» 1×40 (крупный снаряд) за 25;
  звёздный клинок (уник) — «Звёздный залп» 5×14 за 22. Не-магу Q — отказ по классу.
- Хп NPC (ЗАГЛУШКИ): Злус 40, Лира 30, Глот 50, Зоран 80, Гура 35, Вирас 90, демон 200.
- Товары: Гура — окорок; Глот — вода/морс/сок/пиво; Зоран — магическое оружие
  **+ одеяния** (robe_faded/robe_stars/robe_void: +мана и +ХП, только магу);
  Вирас — меч/большой меч/моргенштерн **+ броня** (armor_leather/armor_chain/armor_plate:
  +10/+20/+35 ХП, носят все); Злус — 6 зелий. Цены брони/одеяний и параметры залпов —
  ЗАГЛУШКИ (см. DESIGN.md 5д). Продажа — за половину цены, уники не продаются.

## 7. Демон и последствия убийств (шаги 8/12)

- Все NPC — жители замка. Убийство любого NPC — событие на сессию: старые диалоги
  живых NPC больше не появляются (только реплика про убийство, `NPC_MURDER_REACTIONS`),
  торговать с ними нельзя до конца сессии.
- **Демон появляется строго после первого убийства** NPC (`Game.demon_kill_count() > 0`).
- Демон: тайл (15, 44), масштаб ×3, хп 200 (ЗАГЛУШКА). До ярости — дружелюбен:
  радуется убийству, перечисляет жертв, лавка с товарами павших торговцев со скидкой
  −10% за каждого убитого NPC (max 90%).
- **Ярость (шаг 12): после 3 ударов** (`Game.register_demon_hit`, удары по живому демону)
  демон впадает в ярость: красная аура, реплики-угрозы (`DEMON_RAGE_LINES`,
  роль «разбуженная ярость»), **лавка закрыта**, ИИ в `world.gd:_update_demon` —
  парит к герою (55 px/с, стены держат), в 30 px бьёт когтями раз в 1 с на 8 урона
  (ЗАГЛУШКИ). Ярость не снимается до конца сессии (сброс — новая игра/загрузка слота).
- Демон смертен (и в ярости): труп молчит, лавка закрыта навсегда, скидка за него не
  растёт; живые NPC помнят и убийство демона. Убийство демона счёт ярости не трогает.
- **Смерть героя (шаг 12)**: при ХП 0 — экран «ТЫ ПАЛ» (`world.gd:_build_death_ui`),
  кнопка «ОЧНУТЬСЯ В ЗАМКЕ» — полные ХП/мана, герой у спавна замка, демон продолжает
  охоту (кулдаун атаки 2 с на пробуждение). Штрафов нет (ЗАГЛУШКА).

## 8. UI: диалоги, HUD, инвентарь (шаги 10–12)

- **Диалоги — лавкрафтовский космо-хоррор**: замок плывёт по Пустоте тысячу лет,
  звёзды «стоят неправильно», за запертыми дверями что-то спит, ножи Гуры всё
  запомнили. Слово «добряк» из всех текстов убрано («жители», «смертные»).
- **Диалоговое окно никогда не выходит за экран**: панель закреплена низом над
  консолью HUD (`bottom_reserve = UI_BAR_H + 8`), высота под контент
  (`PANEL_MIN_H 176 / PANEL_MAX_H 460`), потолок от реального вьюпорта,
  избыток растёт ВВЕРХ. Имя и роль — в две строки с автопереносом.
- Листание реплик: E, F, Enter и клик; ЛКМ в мире — удар, по NPC/двери — диалог.
- Консоль UI 112 px: кнопки 64×22, джойстик 100 px, экран ходьбы 360×528.
- **Инвентарь (шаг 12)**: над сеткой 5×4 две ячейки экипировки — ОРУЖИЕ и БРОНЯ
  (в броне живёт и одеяние); заполненная ячейка — золотая рамка + иконка,
  клик снимает предмет. Кнопки: ВЗЯТЬ В РУКИ / ОДЕТЬ / СНЯТЬ; отказы:
  «Магическое оружие отвергает варвара», «Одеяние слушается только Мага».
  В шапке — ХП/мана с бонусом экипировки и строка «Надето: … · +N ХП».
- Подсказка в HUD: «WASD/джойстик — идти, E — говорить, ЛКМ — удар, I — сумка»
  (+ «Q — магия» у мага).

## 9. Двери и 1-й данж «Подземелье замка» (шаги 9/13)

- 4 прохода в верхней стене замка: спрайт `props/door_dungeon.png`.
  Шаг 13: **подписи «Данж 1..4» убраны** — двери говорят сами за себя.
- Двери 2–4 заперты: клик или E рядом — диалог **«Подземелье пока недоступно»**
  (реплики дверей — хоррор). `Game.dungeons_cleared` только копит id.
- **Дверь 1 открыта** (`world.gd:_begin_dungeon_transition`): `Game.dungeon_floor = 1`
  и смена сцены на `scenes/dungeon/dungeon.tscn`.

### Данж 1 (dungeon.gd + dungeon_bestiary.gd)

- Локация — подземелье замка: каменные стены/полы (3 оттенка), кости, колонны,
  тьма вместо космоса; тайлы — `assets/tilesets/dungeon_tiles.png` (генератор
  `tools/gen_dungeon.py`), враги — `assets/sprites/dungeon/*.png` (листы 24×32,
  те же 6 рядов анимаций, что у героев).
- **4 больших тематических этажа, на каждом 7–13 врагов** (шаг 15; было
  10 этажей по 1–5): карта 64×48 — в 2.4 раза больше старой 40×36,
  10–13 комнат (6–13×5–9) + Г-коридоры шириной 2 в обеих осях
  (вертикальные тоже двухтайловые — реквизит не замуровывает путь),
  2–4 петли связности; декор ставится ДО коридоров — коридоры вырезаются
  поверх колонн; этаж генерируется ЗАНОВО при каждом входе/переходе.
- **Тема этажа** (`DungeonBestiary.THEMES`): свои тайлы стен/полов
  (перекраска атласа), цвет «воздуха» (CanvasModulate), плотность декора,
  свечение трещин, пул врагов и их число, реплика при входе. Темы:
  «Смрадные катакомбы» (пауки/змеи, паутина), «Пустотные чертоги»
  (космические пауки/мертвецы, звёздный камень, кристаллы),
  «Костяная обитель» (мертвецы, кости), «Багровое логово» (демоны, угли).
- **Свет и реквизит (шаг 15)**: мягкое свечение вокруг героя (glow.png,
  аддитивное смешение), 10–14 мерцающих факелов на этаж, жаровни и трон
  в зале босса, кристаллы в сокровищнице (на 2-м этаже — фиолетовые),
  бочки/ящики/мешки/фонари в комнатах — блокируют движение.
- **Сокровищница (этажи 1–3)**: самая дальняя комната выстлана золотой
  мозаикой «m», внутри 2 сундука, 2 кристалла и элитный ХРАНИТЕЛЬ
  (всегда элита); случайные враги в сокровищницу не заходят.
- **Зал босса (этаж 4)**: зал 22×14 с прихожей, рядами колонн, жаровнями
  в углах, троном за боссом и ковровой дорожкой от лестницы до трона.
- **Элитные чемпионы (шаг 15)**: 1–2 на этаже (на этаже босса) и хранитель
  сокровищницы — крупнее (×1.25), хп ×1.9, урон ×1.5, золото ×3, имя
  с приставкой «Элитный ».
- Виды по возрастанию сложности: паук, змея, космический паук, мертвец бомж,
  мертвец рыцарь, мертвец колдун, демон мечник, демон колдун. С шага 15 —
  строгий пул ТЕМЫ: этаж 1 — паук/змея; 2 — космический паук/мертвец бомж;
  3 — бомж/рыцарь/колдун; 4 — демон мечник/демон колдун. Колдуны
  (мертвец колдун, демон колдун) держат дистанцию и швыряют
  болты, остальные бьются вплотную. Враг спит до подхода (aggro-радиус)
  и оживает подсказкой «%s заметил тебя».
- Лестница `<` наверх: на 1-м этаже — выход в замок, глубже — этаж назад.
  Лестница `>` вниз **заперта, пока на этаже жив хоть один враг**
  («тишина открывает путь»). HUD сверху: «Подземелье · ур. N/4 · врагов: K».
- Награда (ЗАГЛУШКИ): золото за врага (база + этаж×3, у элиты ×3) + шанс
  15% зелья лечения.
- **Обязательный босс на 4-м этаже — Таинственный демон с юга карты**
  (лист 72×96, хп 300 — ЗАГЛУШКА). Подход ближе 90 px открывает диалог:
  если мы видели его у края мира (`Game.demon_seen`) — он УЗНАЁТ героя
  («Ты помнишь меня…»), иначе представляется. После диалога — бой.
- **Победа над боссом** = `Game.defeat_demon_permanently()`: все убитые NPC
  оживают и забывают убийства, демон повержен НАВСЕГДА — ни у края мира,
  ни в подземелье (даже после новых убийств; `demon_defeated` в сейве v6).
  Данж засчитан (`dungeon_1` в `dungeons_cleared`), на месте босса — выход `X`
  в замок. Повторный вход в данж: враги на месте, босса нет — выход открыт сразу.
- **Сундуки (шаги 14–15)**: 4–5 на этаже — 2 гарантированных в сокровищнице
  (этажи 1–3) или по углам зала босса (этаж 4), остальные 2–3 по комнатам
  (`_pick_chest_tiles` — не на лестницах, не у старта, не на врагах),
  открытие кликом или E (ближайшая интерактивность 26 px); спрайт меняется
  на открытый, открытый пуст («пыль и чужие мечты»). Добыча —
  `Loot.chest_loot(floor)`: золото 30% / зелья 22% / питьё и еда 14% /
  оружие 14% / броня 12% / одеяния 8% (ЗАГЛУШКИ), пулы по глубине
  (early 1 / mid 2–3 / late 4);
  качество экипировки из сундуков щедрее падений (40/30/20/10). Выход `X`
  не встаёт на сундук (`_free_exit_tile`).
- **Эпическая награда босса (шаг 14)**: за победу выпадает случайное сильное
  оружие золотого («эпического») качества — большой меч, моргенштерн,
  жезл молний, клинок инея или скипетр кометы (без стартового меча;
  состав — ЗАГЛУШКА). Реплика о добыче идёт после текста о победе.
- Смерть в подземелье — тот же экран «ТЫ ПАЛ»: пробуждение в замке,
  этажи соберутся заново при следующем входе.

## 10. Карта мира

`scripts/data/world_map.gd`: карта 30×56. Ряды 0–19 — замок; 20–45 — улица;
46 — непроходимая ограда (`RAILING_ROW`); ниже — космос. Физика мира живёт в
SubViewport экрана ходьбы (пространство через `walker.get_world_2d().direct_space_state`).

## 11. Ловушки Godot 4.7.2, уже отработанные в проекте

1. **`class_name VirtualJoystick` → «hides a native class»**: скрипт грузится по пути,
   инстанс через `GDScript.new()`.
2. **`:=` и Variant**: у правой части Variant нужен явный тип (`var space: PhysicsDirectSpaceState2D = ...`).
   В шаге 12 так же: `var col: Array = info.get("color", ...)`,
   `var demon_dist_before: float = ...`.
3. **ClassDB не видит скриптовые классы** — грузить скрипт по пути, не по имени класса.
4. Мигания диалога: клавиша, открывшая диалог, помечается `set_input_as_handled()`.
5. **API Rect2i/Rect2**: метод называется `grow(amount)` — «grows()» не существует
   (parse-ошибка шага 13); для проверки пересечения с зазором —
   `room.grow(1).intersects(other.grow(1))`.
6. **`String(...)` принимает Variant, но не Dictionary/Array**:
   `String(dict.get("id", ""))` — ок; `String(словарь)` — parse-ошибка
   «No constructor of String matches the signature String(Dictionary)»
   (шаг 14: пулы строк выбираются `_pick_id`, не `_weighted_pick`).
7. **Цепочки твинов**: `tween_interval()` возвращает `IntervalTweener`, у
   которого нет `tween_callback` — последовательность строится двумя
   вызовами на самом `Tween` (шаг 14: подсказка об эпической добыче).
8. **Сигналы автозагрузок переживают смену сцены**: каждый подключённый к
   `Game.*` обработчик (метод или лямбда) должен отвязываться в
   `_exit_tree` своей сцены/панели, иначе после освобождения сцены он
   падает на первом же сигнале (шаг 14: HUD мира/данжа, меню, лавка).
9. **`free()` во время сигнала**: если обработчик перестраивает список
   строк с кнопками, из-под которых пришёл `pressed` — мгновенный `free`
   даёт «freed while signal is emitted»; нужен `queue_free` (лавка, шаг 14).

## 12. Сейвы

3 слота `user://save_slot_N.json` (**v6** — добавлен `demon_defeated`) +
глобальный `user://meta.json`. Миграции: v1–v6 (без хп/маны → полный запас;
без оружия → пустые руки; без брони → пустой слот брони; магическое оружие
у варвара из старого сейва снимается; **без demon_defeated → демон жив**).
`demon_hits/demon_enraged/demon_seen/dungeon_floor` в сейв не пишутся (сессия).
Запрос сохранения — `Saves.request_save()`.

## 13. Автотесты (запускает автор: `godot --headless --path . res://tests/<имя>.tscn`)

- `smoke_test.tscn` — слоты, meta, герои, бонус, предметы, торговля, лут,
  **броня/одеяния, экипировка и сейв, классовые множители, залпы, ярость демона**.
- `menu_test.tscn` — сундук, кнопки, панель старта, слоты, бонус, сброс.
- `world_test.tscn` — тайлы, движение, коллизии, NPC, диалоги, лавка,
  инвентарь (20 слотов + **2 ячейки экипировки**), двери (**без подписей**;
  дверь 1 — маршрут в данж), HUD, удары, **залп жезла в мире (3 снаряда)**.
- `trade_test.tscn` — золото героев, товары NPC (**включая броню Вираса и
  одеяния Зорана**), покупка/продажа, **надевание брони и сейв**.
- `demon_test.tscn` — спавн демона после убийства, скидки, запрет старых диалогов,
  **ярость после 3 ударов (счёт вслух, угрозы, преследование, удары по герою),
  СБРОС ЯРОСТИ при возрождении, вечная смерть демона: жертвы оживают и забывают,
  демон не возвращается даже после новых убийств, сейв v6**.
- `dungeon_test.tscn` — генерация этажей (сетка 64×48, 7–13 врагов, темы/пулы,
  элита и хранитель),
  запертая лестница, переход этажей, босс: диалог (узнаёт, если видели), бой,
  победа: demon_defeated + ожившие NPC + выход в замок + босса больше нет;
  **сундуки (шаг 15): 4–5 на этаже, стоят на полу закрытыми, открытие даёт
  золото или предмет, повторное открытие пусто; за босса — эпическое оружие
  золотого качества; выход не встал на сундук**.
- `screenshot.tscn`, `shot_demon.tscn` — съёмка скриншотов (нужен X/GL: `xvfb-run`).

## 14. Дорожная карта (что осталось, по DESIGN.md)

1. **Пошаговые бои**: шанс попадания, дебафф пива (−50 к попаданию на 2 хода).
   Реалтайм-удар «дугой взгляда» уже есть (шаг 7/12), демон уже дерётся.
2. Система характеристик героев (классы пока влияют на внешность, кошелёк,
   хп/ману и множители оружия шага 12).
3. Данжи 2–4 и лут (двери пока заперты с заглушкой-диалогом; данж 1 готов — шаг 13,
   сундуки и эпическая награда — шаг 14; при переносе таблиц подумать о
   `Loot.chest_loot` как образце: тот же каркас — категория по весам + пул по глубине).
4. Звук (`assets/audio` пуст) и локализация (если понадобится).
5. Экспорт HTML5 + Yandex SDK; AAB + RuStore.
6. Мобильная адаптация управления — отложена автором («под телефон потом»).
7. Мелочи: строка «Идея и гейм-дизайн» ждёт имя автора (`main.tscn`, узел
   `AuthorsPanel/VBox/IdeaLabel`); `Loot.roll_quality` (обычное падение с
   весами 70/20/7/3) пока не подключена к добыче врагов — враги дают золото
   и фиксированное малое зелье (шанс 15%).

Числа с пометкой **ЗАГЛУШКА** (хп героев/NPC/демона/врагов данжа, урон кулака,
урон когтей демона, штраф смерти, цены и бонусы брони/одеяний, параметры залпов,
статы врагов и награды данжа) — временные, автор их утверждает отдельно;
не «улучшать» без запроса.

## 15. Как продолжить работу в новом чате

- Приложить архив `mini-rpg-dump.zip` (это тот же проект + данный файл) и сказать задачу.
- Собрать проект заново на любой машине (Mac/Windows/Linux): `python3
  make_dungeon_loot.py [куда]` — самодостаточный скрипт (текст файлов +
  PNG в base64) разворачивает папку `mini-rpg` целиком; дальше — открыть
  в Godot 4.7.2 (первый импорт ассетов займёт минуту).
- Контекст читать так: этот файл → `docs/DESIGN.md` (для шага 12 — разделы 5д/5е) →
  нужные скрипты.
- Правки валидировать движком: Godot 4.4.1 headless в песочнице
  (`/tmp/Godot_v4.4.1-stable_linux.x86_64 --headless --import --quit` —
  собрать .godot и увидеть parse/compile ошибки; затем
  `--headless --path . res://tests/<имя>.tscn` — прогнать тесты;
  бинарник при пересборке песочницы качается заново с сайта Godot).
- После правок обновлять этот дамп и `docs/DESIGN.md`, пересобирать архив в `download/`.

````

#### `docs/DESIGN.md`

````markdown
# Dungeon Loot — дизайн-документ (шаг 14)

Рабочее название: **Dungeon Loot** (помечено в меню как «рабочее название»).
Движок: Godot 4.7 (чистый GDScript). Ориентация вертикальная, 360×640, пиксель-арт (сетка 16×16).
Платформы релиза 2026: Яндекс Игры (HTML5) и RuStore (Android).
Весь арт рисуется Python-скриптами (Pillow). Язык игры — русский.

## 1. Сеттинг (решено на шаге 3)

Космо-фэнтези по решению автора: **фэнтезийный замок, из которого можно выйти
на улицу; если подойти к краю улицы — там безграничный космос** (звёзды,
планета, ограда края). Замок «парит» в космосе.

Мир (карта 30×56 тайлов, `scripts/data/world_map.gd`, генератор `scripts/gen_world_map.py`):
- Ряды 0–19 — **замок**: зал с колоннами, окнами со звёздами, ковровой дорожкой
  и жаровнями. В верхней стене — **4 прохода в данжи** (пока заперты).
- Ряды 20–45 — **улица**: брусчатка, дома, заборы, лавка Гуры и кузница Вираса,
  земляная дорожка к краю мира.
- Ряд 46 — ограда края (непроходима), ниже — космос со звёздами и планетой.

## 2. Главное меню (флоу по решению автора)

Тапы по сундуку выбрасывают кнопки: НАЧАТЬ ИГРУ → НАСТРОЙКИ → АВТОРЫ → БОНУС.
При нажатии «НАЧАТЬ ИГРУ» открывается новое меню:
- **НОВАЯ ИГРА** → экран выбора героя;
- **ПРОДОЛЖИТЬ** → загрузка последнего слота (активна, если сейв есть);
- **ЗАГРУЗИТЬ ИГРУ** → список из 3 слотов с героем и золотом.

Сейвы: 3 слота (`user://save_slot_N.json`), глобальная meta (`user://meta.json`):
настройки, последний слот, дата бонуса, отложенные награды. Новая игра пишется
в первый свободный слот; если все заняты — в последний игравшийся.
Сейвы шагов 1–2 автоматически мигрируют в слот 1.

## 3. Герои (выбор при новой игре)

| Герой | Флейвор | Стартовое золото | ХП | Мана |
|---|---|---|---|---|
| Воин | Сталь, дисциплина и верный меч | 100 з. | 50 (ЗАГЛУШКА) | — |
| Варвар | Бьёт первым. Вопросов не задаёт | 50 з. | 60 (ЗАГЛУШКА) | — |
| Бомж | Живёт у стен замка. Терять нечего | 1 з. | 20 (ЗАГЛУШКА) | — |
| Маг (шаг 6) | Хрупкий, но повелевает маной | 60 з. (ЗАГЛУШКА) | **30 (автор)** | **70 (автор)** |

ХП и мана хранятся в `Game.HEROES[*].hp/mana`, текущие значения — в `Game.hp/mana`,
сейв v3. Система характеристик в остальном пока не придумана — выбор пока влияет
на внешность, кошелёк и (для мага) доступ к заклинаниям.

## 4. NPC-торговцы (расстановка автора: 2 на улице, 4 в замке)

| NPC | Роль | Место | Товар |
|---|---|---|---|
| Гура | Повар | Улица, у тележки | Еда (окорок) |
| Вирас | Кузнец | Улица, у наковальни и горна | Оружие |
| Злус | Придворный маг | Замок, у стола с зельями | Зелья |
| Глот | Трактирщик (шаг 6) | Замок, у бочки | Напитки: вода, морс, сок, пиво |
| Зоран | Оружейный чародей (шаг 6) | Замок, между фиолетовыми кристаллами | Магическое оружие |
| Лира | Хозяйка замка | Замок, у трона | Не торгует (только разговоры) |

Торговля сделана на шаге 5 (см. раздел 5а).

## 5. Товары (числа из дизайн-документа, `scripts/data/items.gd`)

| Предмет | Эффект | Цена покупки | Продажа (шаг 5) |
|---|---|---|---|
| Окорок | +50 хп | 10 з. | 5 з. |
| Вода (шаг 6) | +20 хп | 5 з. | 2 з. |
| Морс (шаг 6) | +40 хп | 10 з. | 5 з. |
| Сок (шаг 6) | +60 хп | 15 з. | 7 з. |
| Пиво | +100 хп, −50 к шансу попасть по цели в следующие 2 хода | 25 з. | 12 з. |
| Меч | 30 урона | 1000 з. | 500 з. |
| Большой меч | 50 урона | 2000 з. | 1000 з. |
| Моргенштерн | 100 урона | 5000 з. | 2500 з. |
| Жезл молний (шаг 6, маг.) | 35 урона, залп молний на Q | 1200 з. (ЗАГЛУШКА) | 600 з. |
| Клинок инея (шаг 6, маг.) | 55 урона, залп инея на Q | 2500 з. (ЗАГЛУШКА) | 1250 з. |
| Скипетр кометы (шаг 6, маг.) | 110 урона, кометный залп на Q | 6000 з. (ЗАГЛУШКА) | 3000 з. |
| Кожаный доспех (шаг 12) | +10 к максимуму ХП | 40 з. (ЗАГЛУШКА) | 20 з. |
| Кольчуга (шаг 12) | +20 к максимуму ХП | 90 з. (ЗАГЛУШКА) | 45 з. |
| Латный доспех (шаг 12) | +35 к максимуму ХП | 180 з. (ЗАГЛУШКА) | 90 з. |
| Выцветшая мантия (шаг 12) | +10 маны, +3 ХП, только магу | 35 з. (ЗАГЛУШКА) | 17 з. |
| Мантия звёздочёта (шаг 12) | +20 маны, +6 ХП, только магу | 90 з. (ЗАГЛУШКА) | 45 з. |
| Одеяние Пустоты (шаг 12) | +35 маны, +10 ХП, только магу | 170 з. (ЗАГЛУШКА) | 85 з. |
| Зелье лечения | +80 хп | 50 з. | 25 з. |
| Малое зелье лечения (шаг 7) | +40 хп | 25 з. | 12 з. |
| Большое зелье лечения (шаг 7) | +160 хп | 100 з. | 50 з. |
| Малое зелье маны (шаг 7) | +30 маны, только магу | 30 з. | 15 з. |
| Зелье маны (шаг 7) | +60 маны, только магу | 60 з. | 30 з. |
| Большое зелье маны (шаг 7) | +120 маны, только магу | 120 з. | 60 з. |
| Фиолетовые уники | уникальные бонусы | не продаются (price = −1) | не берут |

**Ряд напитков Глота** (задал автор в шаге 6): цена и количество
восстанавливаемого хп растут вместе: вода (5 з. / +20) → морс (10 / +40) →
сок (15 / +60) → пиво (25 / +100).

**Ряд зелий Злуса** (шаг 7): три размера лечения (малое 25 з. / +40 →
среднее 50 / +80 → большое 100 / +160) и три размера маны (30 з. / +30 →
60 / +60 → 120 / +120): цена и эффект растут вместе с размером флакона.
Мана-зелья годятся только магу: остальным героям зелье не тратится.

## 5а. Торговля и деньги (решено на шаге 5)

- Стартовое золото новой игры зависит от героя: **Воин — 100, Варвар — 50,
  Бомж — 1, Маг — 60 (ЗАГЛУШКА)** (`Game.hero_start_gold`, поле `start_gold`
  в `Game.HEROES`).
- Товары торговцев заданы в `WorldMap.NPCS` (поле `goods`):
  Гура — `ham`; Глот — `water`, `mors`, `juice`, `beer`; Зоран — `wand_lightning`,
  `blade_frost`, `scepter_comet` и одеяния `robe_faded`, `robe_stars`,
  `robe_void` (шаг 12); Вирас — `sword`, `greatsword`, `morgenstern`
  и броня `armor_leather`, `armor_chain`, `armor_plate` (шаг 12);
  Злус — `hp_potion`, `hp_potion_small`, `hp_potion_large`,
  `mana_potion_small`, `mana_potion`, `mana_potion_large` (шаг 7).
  Запас лавки бесконечный.
  (Шаг 6: пиво переехало от Гуры к Глоту — Гура и раньше говорил,
  что пиво варить не будет.)
- Покупка: диалог торговца → кнопка **«ТОРГОВАТЬ»** → окно лавки
  `TradeUI` (вкладки ПОКУПКА/ПРОДАЖА). Кнопка КУПИТЬ неактивна,
  если не хватает золота.
- Продажа своих вещей — за половину цены покупки (`ItemDB.SELL_FACTOR = 0.5`,
  минимум 1 золото). Фиолетовые уники и безымянная добыча (без `item_id`)
  не продаются — в лавке помечены «не берут».
- Логика денег — `Game.buy_item(id)` / `Game.sell_item(index)`; сумма и сумка
  сразу сохраняются в слот сейва, HUD и лавка обновляются по сигналам
  `gold_changed` / `inventory_changed`.
- На экране выбора героя под описанием показаны хп/мана и стартовый кошелёк.
- Старые сейвы (шаги 1–5) мигрируют без потерь: без поля `hp/mana` герой
  получает полный запас.

## 5б. Здоровье, мана и заклинание мага (шаг 6)

- У каждого героя есть **ХП** (`Game.hp`, полоса в HUD и инвентаре).
- Только у **Мага** есть **мана** (`Game.mana`, 70 на старте — авторское число):
  голубая полоса в HUD, строка «Мана 70/70» в инвентаре и на карточке выбора.
- **Использование предметов**: еда/питьё/зелья (`ItemDB.USABLE_TYPES`) можно
  применить из сумки — кнопка СЪЕСТЬ/ВЫПИТЬ лечит ХП (лишнее срезается;
  при полных ХП предмет не тратится). Дебафф пива сработает в боях.
- **«Магическая стрела»** (`Game.SPELL`): только маг, кнопка МАГИЯ или Q.
  Цена — 12 маны, урон 15 (пригодится в боях), скорость 240 px/с,
  дистанция 150 px, кулдаун 0.35 с. Мана регенерирует 2/с.
  Не-магу Q показывает подсказку «Колдовать умеет только Маг».

## 5в. Боевая система: удары и смерть NPC (шаг 7)

- **Удар (ЛКМ + кнопка УДАР)** — у всех героев, включая мага (у мага своя
  кнопка МАГИЯ на Q продолжает работать). Цель — живой NPC в дуге взгляда
  (дистанция 28 px, кулдаун 0.4 с).
- **Чем бьёт герой**: нет оружия в руках — удар рукой
  (`Game.HAND_DAMAGE = 5`, ЗАГЛУШКА); есть оружие в руках — удар оружием
  (урон из `ItemDB` с классовыми множителями — см. 5д), всплывающее число
  урона цветом оружия.
- **Оружие в руках** (`Game.equipped_weapon_id`): выбирается в сумке
  (ВЗЯТЬ В РУКИ / УБРАТЬ ИЗ РУК), помечается золотой рамкой; в HUD строка
  «В руках: Меч · 30 ур.»; сейв v4 (старые сейвы мигрируют: без оружия).
  Продажа оружия из рук снимает его.
- **У всех NPC есть ХП** (ЗАГЛУШКИ: Злус 40, Лира 30, Глот 50, Зоран 80,
  Гура 35, Вирас 90 — поле `hp` в `WorldMap.NPCS`); после первого удара
  над NPC видна полоска, всплывает число урона, спрайт вспыхивает красным.
- **Смерть NPC**: при хп 0 NPC падает на бок, сероет, сквозь него можно
  пройти; труп молчит, не торгует и не бьётся. **В этой сессии NPC больше
  не воскресает** — список убитых `Game.dead_npcs` живёт только в памяти
  сессии и не пишется в сейв (новая игра/загрузка слота воскресает мир).
- **Остальные NPC запоминают убийство** в этой сессии: первая реплика —
  про убитого (имя в винительном падеже, `NPC_MURDER_REACTIONS`),
  а торговцы отказываются торговать с убийцей — кнопки «ТОРГОВАТЬ» нет.
- Управление (шаг 11): диалог — на E или F (клик по NPC работает как
  раньше), удар — на левую кнопку мыши (ЛКМ); в открытом диалоге реплики
  листают E, F, Enter и клик по затемнению. Консоль UI сжата до 112 px
  (кнопки 64x22, джойстик 100 px) — экран ходьбы вырос до 360x528;
  клик ЛКМ по пустому месту экрана ходьбы тоже бьёт, по NPC/двери —
  открывает диалог/сообщение.

## 5д. Экипировка: броня, одеяния, классы оружия и залпы (шаг 12)

- **Второй слот экипировки — броня/одеяние** (`Game.equipped_armor_id`, сейв v5):
  в инвентаре появились две ячейки — ОРУЖИЕ и БРОНЯ (иконки надетого;
  клик по ячейке снимает предмет). Кнопки в сумке: ВЗЯТЬ В РУКИ / ОДЕТЬ.
- **Броня** (тип `armor`, продаёт Вирас): носит любой герой, даёт
  `+hp_bonus` к максимуму ХП (`Game.max_hp()` считается с бонусом).
  Ряд растёт вместе с ценой: кожа +10 (40 з.) → кольчуга +20 (90 з.) →
  латы +35 (180 з.). Текущие ХП от надевания не растут — растёт потолок;
  снятие срезает ХП/ману под новый максимум.
- **Магические одеяния** (тип `robe`, продаёт Зоран): слушаются только мага
  (остальным — отказ «в ком живёт мана»), дают `+mana_bonus` к максимуму
  маны и немного `+hp_bonus`: мантия 10/3 (35 з.) → звёздочёта 20/6 (90 з.) →
  Пустоты 35/10 (170 з.). Уник «Плащ бездны» — броня +25 ХП и +15 маны.
- **Классы и обычное оружие** (`Game.CLASS_STRIKE_MULT`): все носят всё,
  но обычную сталь классы ведут по-разному: маг — ×0.5 (меч бьёт 15),
  варвар — ×2 (меч 60, моргенштерн 200; у мага относительно варвара — в 4
  раза слабее), воин и бомж — ×1.
- **Магическое оружие** (`ItemDB.is_magic`): жезл молний, клинок инея,
  скипетр кометы, звёздный клинок.
  — **маг**: полная сила урона + залп на Q (`Game.spell_info()` читает
  `volley` предмета): жезл — «Залп молний» 3×10 за 15 маны, клинок инея —
  «Залп инея» 3×12 за 16, скипетр — «Кометный залп» 1×40 (большой снаряд)
  за 25, звёздный клинок — «Звёздный залп» 5×14 за 22.
  — **воин и бомж**: полная сила + магический эффект (+25% урона,
  `Game.MAGIC_SURGE_FACTOR`, вспышка цвета оружия), но залп на Q недоступен
  (подсказка «Оружие шепчет на своём языке…»).
  — **варвар**: магическое оружие взять нельзя — отказ («Магическое оружие
  отвергает варвара»), `Game.try_equip_weapon` вернёт `barbarian_rejected`.
- **Q без магического оружия**: у мага — классическая «Магическая стрела»
  (12 маны, 15 урона), она же с обычной сталью в руках. Не-магам Q отвечает
  отказом по классу (`Game.non_mage_spell_hint()`).
- Продажа надетой брони снимает её; старые сейвы (v4 и ниже) мигрируют
  с пустым слотом брони.

## 5е. Ярость демона и смерть героя (шаг 12)

- **Демон терпит ровно 3 удара** (`Game.DEMON_RAGE_HITS`): каждый удар
  по живому демону регистрируется (`Game.register_demon_hit`, счёт —
  `Game.demon_hits`, состояние сессии, в сейв не пишется). Демон считает
  вслух: подсказки «Демон шепчет: „Один…“», «…„Два… ДВА!“».
- **После третьего удара — ярость** (`Game.demon_enraged`, сигнал
  `demon_enraged_changed`): аура красным (`DEMON_RAGE_TINT`), вспышка
  частиц, реплики меняются на угрозы (`DEMON_RAGE_LINES`), роль в диалоге —
  «разбуженная ярость», **лавка закрывается до конца сессии** (товары павших
  не пропадают, но торговать нельзя, пока он жив).
- **ИИ ярости** (`world.gd:_update_demon`): демон парит к герою со скоростью
  55 px/с (герой 95 — убежать можно), стены и ограда его держат (проверка
  тайлов по осям), в дистанции когтей 30 px бьёт раз в 1.0 с на 8 урона
  (ЗАГЛУШКИ `DEMON_SPEED/DEMON_DAMAGE/DEMON_ATTACK_RANGE/DEMON_ATTACK_CD`):
  всплывающее число, взмах, вспышка у героя.
- **Смерть героя**: при ХП 0 мир показывает затемнение «ТЫ ПАЛ» с текстом
  и кнопкой «ОЧНУТЬСЯ В ЗАМКЕ» (`world.gd:_build_death_ui`); ввод мира
  блокируется. Пробуждение — полные ХП/мана, герой у спавна замка
  (`PLAYER_SPAWN`), демон остаётся в ярости и продолжает охоту
  (кулдаун атаки 2 с на пробуждение). Штрафов за смерть нет (ЗАГЛУШКА,
  автор утвердит отдельно).
- Убитый демон не встаёт из мёртвых до конца сессии (как и раньше, шаг 8).
- Реплики NPC, демона и подсказки переписаны под лавкрафтовский космо-
  хоррор; слово «добряк» заменено на «житель»/«смертный».

## 5ж. 1-й данж «Подземелье замка» и вечная смерть демона (шаг 13; пересборка — шаг 15)

- **Двери без подписей**: «Данж N» убраны со всех 4 дверей — двери говорят сами
  за себя. Дверь 1 открыта: клик/E — вход в данж (сцена `dungeon.tscn`),
  двери 2–4 заперты (хоррор-диалог остался).
- **Ярость демона гаснет при возрождении** (`Game.reset_demon_rage`): после
  «ОЧНУТЬСЯ В ЗАМКЕ» демон снова мирен, счёт ударов обнулён, красная аура
  снята, он возвращается на своё место у края улицы, лавка снова открыта.
- **Данж 1 — «Подземелье замка»** (`scenes/dungeon/dungeon.gd` +
  `scripts/data/dungeon_bestiary.gd`): с шага 15 — **4 больших тематических
  этажа вместо 10 тесных**: карта 64×48 (было 40×36), 10–13 комнат на этаж,
  **7–13 врагов** плюс элитные чемпионы. Этажи генерируются заново при
  каждом входе/переходе: комнаты 6–13×5–9 + коридоры шириной 2 в ОБЕИХ
  осях (вертикальные тоже двухтайловые — реквизит не замуровывает путь),
  2–4 петли связности; декор (колонны/кости/паутина/кровь/свечение)
  ставится ДО коридоров — коридоры вырезаются поверх колонн.
- **Тема этажа** (`DungeonBestiary.THEMES`): свои тайлы стен/полов
  (перекраска базового атласа), цвет «воздуха» (CanvasModulate),
  плотность декора, свечение трещин, пул врагов и их число, реплика
  при входе. Темы: «Смрадные катакомбы» (пауки/змеи, паутина),
  «Пустотные чертоги» (космические пауки/мертвецы, звёздный камень,
  кристаллы), «Костяная обитель» (мертвецы, кости), «Багровое логово»
  (демоны, угли, ковёр к трону).
- **Сокровищница (этажи 1–3)**: самая дальняя комната выстлана золотой
  мозаикой «m», внутри 2 сундука, 2 кристалла и элитный ХРАНИТЕЛЬ
  (всегда элита); случайные враги в сокровищницу не заходят.
- **Зал босса (этаж 4)**: зал 22×14 с прихожей, колоннами рядами,
  жаровнями в углах, троном за боссом и ковровой дорожкой от лестницы
  до трона (тайл «p» — только по чистым полам, лестницы не трогаются).
- **Виды противников по возрастанию сложности** (строгий пул темы:
  этаж 1 — паук/змея; 2 — космический паук/мертвец бомж; 3 — бомж/
  рыцарь/колдун; 4 — демон мечник/демон колдун): колдуны держат
  дистанцию (keep_distance) и швыряют болты, остальные бьются вплотную;
  враг спит до подхода (aggro-радиус) и оживает подсказкой
  «%s заметил тебя».
- **Элитные чемпионы (шаг 15)**: 1–2 на этаже (на этаже босса) и хранитель
  сокровищницы — крупнее (×1.25 спрайт), хп ×1.9, урон ×1.5, золото ×3,
  имя с приставкой «Элитный », полоска хп шире, тело радиусом 6.
- **Лестница вниз заперта, пока враги живы** («тишина открывает путь»);
  лестница вверх: на 1-м этаже — выход в замок, глубже — этаж назад
  (этаж генерируется заново — рогалик). HUD сверху:
  «Подземелье · ур. N/4 · врагов: K».
- **Награды (ЗАГЛУШКИ)**: золото за каждого врага (база + этаж×3,
  у элиты ×3), шанс 15% зелья лечения.
- **Босс 4-го этажа — обязательный: Таинственный демон с юга карты**
  (тот же лист 72×96, хп 300 — ЗАГЛУШКА). Подход ближе 90 px открывает диалог:
  если мы видели его у края мира (`Game.demon_seen`, ставится при разговоре
  с демоном) — он УЗНАЁТ героя и говорит об этом («Ты помнишь меня…»),
  иначе представляется; после диалога начинается бой (погоня + когти).
  Удар по боссу до диалога тоже открывает реплики.
- **Победа над боссом** = `Game.defeat_demon_permanently()`: все убитые NPC
  оживают и забывают убийства (сигнал `npcs_revived`; в мире трупы встают),
  демон повержен НАВСЕГДА — не вернётся ни у края мира, ни в подземелье,
  даже если снова убить жителя (`demon_defeated`, сейв v6). Данж засчитан
  (`dungeon_1` в `dungeons_cleared`), на месте босса — выход `X` в замок.
  Убийство демона на КАРТЕ (не в данже) — те же последствия.
  Повторный вход в данж: враги на месте, босса нет, выход открыт сразу.
- **Смерть в подземелье** — тот же экран «ТЫ ПАЛ»: пробуждение в замке,
  этажи соберутся заново при следующем входе.
- Арт (шаг 13): `tools/gen_dungeon.py` — тайлы подземелья
  (`tilesets/dungeon_tiles.png`: стены, 3 пола, кости, колонна, лестницы,
  выход с фиолетовым зевом) и 8 листов врагов 24×32
  (`sprites/dungeon/*.png`) в том же формате, что герои.
- Арт шага 15: атлас расширен до 25 тайлов 16×16 (темы стен/полов
  четырёх этажей, паутина, кровь, 4 свечения, ковёр, золотая мозаика),
  плюс `props/glow.png` — мягкий радиальный градиент для света
  (перекраска базовых пикселей шага 13 делалась разовым скриптом,
  в `tools/` он НЕ сохранён — актуальные PNG лежат в `assets/` и
  переносятся сборщиком `make_dungeon_loot.py` байт-в-байт).

## 5з. Сундуки подземелья и эпическая награда босса (шаг 14)

- **Сундуки — 4–5 на каждом этаже** данжа 1 с шага 15 (спрайты 16×16
  `chest_closed.png`/`chest_open.png`): 2 гарантированных в сокровищнице
  (этажи 1–3) или по углам зала босса (этаж 4), остальные 2–3 — по всем
  комнатам (`DungeonBestiary._pick_chest_tiles`) — не на лестницах,
  не вплотную к старту (2 тайла), не на клетке врага и не друг
  на друге. Тело блокирует героя (радиус 6), зона клика 20×20.
- **Открытие**: клик по сундуку или E рядом (ближайшая интерактивность в
  радиусе 26 px — лестницы и закрытые сундуки; открытый сундук говорит
  «Сундук пуст: только пыль и чужие мечты»). Клик по сундуку не считается
  ударом (`_point_on_interactive`). Спрайт меняется на открытый, золотой
  всплеск частиц.
- **Добыча сундука — `Loot.chest_loot(floor)`** (все веса — ЗАГЛУШКИ,
  утверждает автор): золото 30% (10 + этаж×6 + 0–14), зелья 22%, питьё/еда
  14%, оружие 14%, броня 12%, одеяния 8%. Пулы по глубине (шаг 15,
  четыре этажа): 1 «early» (меч, жезл молний, кожаный доспех, малые
  зелья, вода/морс), 2–3 «mid» (жезл/большой меч/клинок инея, кольчуга,
  средние зелья, пиво/сок), 4 «late» (клинок инея/скипетр кометы/
  моргенштерн, латный доспех, большие зелья + редкий эликсир кометы).
  Качество экипировки из сундуков щедрее падений: серое 40 / зелёное 30 /
  золотое 20 / фиолетовое 10 (вместо 70/20/7/3 у обычной добычи).
- **Выход не конфликтует с сундуком**: `_place_exit` сдвигает выход на
  ближайший свободный пол, если на тайле стоит сундук (`_free_exit_tile`).
- **Эпическая награда босса (шаг 14)**: за победу над Таинственным демоном
  выпадает **случайное сильное оружие золотого («эпического») качества** —
  `Loot.epic_weapon_loot()`: большой меч, моргенштерн, жезл молний,
  клинок инея или скипетр кометы (стартовый «Меч» в пул не входит;
  состав — ЗАГЛУШКА). Реплика о добыче идёт после текста о победе
  («Среди пепла демона осталось оружие — …»).
- Тесты `dungeon_test` дополнены: 1–2 сундука на этаже, спавн на полу,
  открытие и добыча, пустой повтор открытия, эпическое оружие за босса,
  выход не на сундуке; плюс проверка таблиц (150 открытий на этаж: только
  золото или существующий в ItemDB предмет) и существования всего
  эпического пула.
- Прогон движком (2026-11-14, Godot 4.4.1 headless): все 6 тестов —
  «ВСЁ ОК», 0 SCRIPT ERROR. Фиксы: `Loot.chest_loot` берёт предмет из пула
  строк через `Loot._pick_id` (раньше `_weighted_pick` пытался кастовать
  строку к Dictionary — parse-ошибка валила компиляцию данжа, лавки,
  инвентаря и тестов); реплика об эпической добыче — обычной цепочкой
  Tween (у `IntervalTweener` нет `tween_callback`); обработчики HUD/лавки
  отвязываются в `_exit_tree` (сигналы Game переживают смену сцены).

## 5и. Большие тематические этажи: свет, факелы, реквизит (шаг 15)

- **4 этажа вместо 10** (по просьбе автора: «больше, красивее,
  интереснее»): каждый этаж в 2.4 раза больше, врагов 7–13 вместо 1–5,
  сундуков 4–5 вместо 1–2.
- **Темы этажей** (`THEMES`): перекрашенные стены/полы из атласа
  (мшистые/фиолетовые/костяные/багровые), «воздух» этажа —
  `CanvasModulate` своего оттенка; мягкий свет вокруг героя
  (glow.png, аддитивное смешение).
- **Факелы (10–14 на этаж)**: анимированные (3 кадра), стоят на полах
  у стен, светят (цветной glow), мерцают случайным твином; не встанут
  на сундук/врага/реквизит и не кучкуются (5 тайлов между).
- **Реквизит**: жаровни (анимированные, светят) и трон в зале босса
  (ставятся ДО врагов, клетки резервируются), кристаллы в сокровищнице
  (на 2-м этаже — фиолетовые), бочки/ящики/мешки/фонари в комнатах —
  блокируют движение (тело радиус 5.5).
- **Декор-тайлы**: паутина «w», кости «b», кровь «x», светящиеся
  трещины «g» (цвет по теме), ковёр «p», мозаика «m» — всё проходимо,
  спавн врагов/сундуков разрешён на них.
- **Гарантии генератора** (проверены автопревью 600 этажей):
  связность от спавна до лестниц/сундуков/врагов/сокровищницы с учётом
  блокирующего реквизита, 4–5 сундуков, элита на каждом этаже,
  жаровни/трон/ковёр на этаже босса, мозаика сокровищницы на этажах 1–3.

## 5г. Таинственный демон у края мира (шаг 8)

- **Все NPC добрые**: убийство любого из них — событие с последствиями.
- **Реакция жителей ужесточилась** (шаг 8): старые диалоги больше не
  появятся — у живых NPC остаётся только реплика про убийство, и торговать
  с ними больше нельзя (кнопка «ТОРГОВАТЬ» скрыта до конца сессии).
- **Таинственный демон** появляется после первого убийства — у края улицы,
  на земляной дорожке перед оградой (тайл 15, 44). Втрое крупнее обычного
  NPC (кадры 72x96, `scale: 3` в `WorldMap.NPCS`), парит над землёй на
  хвосте с огоньком. Арт: `tools/gen_demon.py` (лист 432x576 + портрет).
- **Демон радуется убийству**: хвалит героя, перечисляет жертв
  (в винительном падеже) и зовёт убивать ещё: за каждого убитого NPC
  его лавка дешевит ещё на **10%** (скидка на всё, максимум 90%; сам
  демон в счёте не участвует).
- **Лавка демона**: товары убитых торговцев переезжают к нему
  (`Game.demon_goods`, без повторов, в порядке убийств). Цены со скидкой
  (`Game.demon_price`), минимум 1 золото; покупка через
  `Game.buy_from_demon()`, окно лавки показывает «новая цена (было …)».
- Демон тоже смертен (хп 200, ЗАГЛУШКА): убитый демон молчит, его лавка
  закрыта навсегда, но скидка за него не растёт. Живые NPC помнят и
  убийство демона («Ты убил демона…»).
- Состояние демона — как и убитые NPC — живёт только в текущей сессии:
  в сейв не пишется, новая игра/загрузка слота воскрешает всех.

## 6. Ежедневный бонус (решено на шаге 3)

Раз в календарный день кнопка «БОНУС» даёт **50–200 золота + фиолетовую добычу**
(случайный уник из списка `ItemDB.VIOLET_UNIQUES`). Награда сразу попадает в
состояние игры; если игра ещё не начата — откладывается в meta и выдаётся при
старте/загрузке. Сброс прогресса не обнуляет дату бонуса (нельзя «фармить»).

Фиолетовые уники — временные заглушки, состав позже:
Звёздный клинок, Плащ бездны, Эликсир кометы.

## 7. Авторы

Строка «Идея и гейм-дизайн» ждёт имя автора — **автор впишет сам**
(`scenes/main/main.tscn`, узел `AuthorsPanel/VBox/IdeaLabel`).

## 8. Статус по шагам

- Шаг 1 (проект, автозагрузки, лут) — готов.
- Шаг 2 (главное меню с сундуком) — готов.
- Шаг 3 (мир и движение) — готов: тайлмап замок+улица+край космоса,
  движение (стрелки/WASD + VirtualJoystick), камера, NPC на местах,
  4 двери данжей, 3 слота сейвов, экран выбора героя, ежедневный бонус.
- Шаг 4 (арт-полировка) — готов:
  - персонажи 24x32 (вместо 16x16) с покадровыми анимациями: idle 6 кадров
    (дыхание + моргание) и ходьба 4 кадра в 4 направлениях (вниз/вверх/бок);
  - 4-й NPC — **Лира, хозяйка замка в красном платье** (у трона на ковре);
  - диалоговое окно с крупным детализированным портретом (64x64, рамка,
    имя, роль, эффект печатной машинки; кнопка/клавиша E);
  - инвентарь на 20 слотов: кнопка «СУМКА» или клавиша I, иконки предметов,
    цвета качества, описания (пока пуст — предметы приходят из бонуса);
  - новый тайлсет: мраморный пол с шахматным узором, ковёр с золотом,
    окна с космосом, брусчатка, знамёна, горшки; двор с фонтаном (анимация),
    рыночными палатками, фонарями, жаровнями (анимация), кристаллами;
    край мира: планета с кольцом и орбитальной луной, парящие острова
    и астероиды (покачивание);
  - y-sort глубины, тени под персонажами, золотой указатель над ближайшим NPC,
    мини-панель героя (портрет + золото) в HUD.
- Шаг 5 (деньги и торговля) — готов:
  - стартовое золото героев: Воин 100, Варвар 50, Бомж 1
    (`start_gold` в `Game.HEROES`, показывается на экране выбора героя);
  - товары торговцев (`goods` в `WorldMap.NPCS`): Гура — окорок и пиво,
    Вирас — меч, большой меч и моргенштерн, Злус — зелье лечения;
  - окно лавки `scenes/world/trade_ui.gd`: вкладки ПОКУПКА и ПРОДАЖА,
    иконки, цены, описания, неактивные кнопки при нехватке золота;
  - кнопка «ТОРГОВАТЬ» в диалоге торговца (у Лиры её нет);
  - API денег: `Game.buy_item()` / `Game.sell_item()`, продажа за половину
    цены, уники не продаются, всё сразу пишется в сейв;
  - новый автотест `tests/trade_test.tscn` (36 проверок) — зелёный;
  - скриншот-тест дополнен кадрами диалога с «ТОРГОВАТЬ», лавок Гуры
    и Вираса и вкладки ПРОДАЖА.
- Дальше: пошаговые бои (есть HP, урон оружия, шанс попадания;
  пиво — дебафф); система характеристик героев; 4 данжа и лут; звук;
  экспорт HTML5 + Yandex SDK; AAB + RuStore.
- Шаг 7 (боевая система, смерть NPC, зелья размеров) — готов:
  - удар E + кнопка УДАР у всех героев (маг тоже бьёт); без оружия —
    рукой (5 урона, ЗАГЛУШКА), с оружием — оружием (урон из ItemDB);
  - оружие в руках: ВЗЯТЬ В РУКИ/УБРАТЬ ИЗ РУК в сумке, золотая рамка
    слота, строка «В руках: …» в HUD, сейв v4;
  - у NPC есть хп (ЗАГЛУШКИ), полоска над головой, всплывающий урон,
    вспышка; смерть — труп на всю сессию без воскрешения;
  - остальные NPC помнят убийство (реплика + отказ торговать);
  - у Злуса 6 зелий: лечение 25/50/100 з. (+40/80/160 хп), мана
    30/60/120 з. (+30/60/120, только магу); новые иконки флаконов
    (размер растёт с ценой).
- Шаг 8 (демон у края мира, ужесточение памяти NPC) — готов:
  - после первого убийства у края улицы появляется Таинственный демон
    (scale 3, хп 200 — ЗАГЛУШКА), радуется убийству и зовёт убивать ещё;
  - старые диалоги живых NPC пропадают: только реплика про убийство,
    торговать с жителями больше нельзя;
  - товары убитых торговцев — в лавке демона, цены со скидкой -10%
    за каждого убитого NPC (max 90%); демон в подсчёте не участвует;
  - демон смертен: труп, лавка закрыта навсегда, скидка за него не растёт;
  - фикс: VirtualJoystick восстановлен (ClassDB не видит скриптовые
    классы — джойстик не спавнился; теперь скрипт `scripts/ui/virtual_joystick.gd`
    грузится напрямую);
  - новый автотест `tests/demon_test.tscn`.
- Шаг 9 (урон магии, явные двери, хтонические реплики, фикс 4.7.2) — готов:
  - «Магическая стрела» (Q) наносит урон первому живому NPC на пути —
    урон из `Game.SPELL["damage"]` (15), общий код с ударом — `world.gd:
    _hit_npc` (число урона, вспышка, полоска хп, смерть);
  - двери данжей стали явными: новый спрайт `props/door_dungeon.png`
    (генератор `gen_doors.py` — каменные створки, фиолетовый зев),
    подписи «Данж 1..4»; клик или E рядом — диалог
    «Подземелье пока недоступно» (торговать с дверью нельзя);
  - демон появляется строго после первой жертвы жителя
    (`Game.demon_kill_count() > 0` в `world.gd:_ready` и в `_on_npc_killed`);
  - реплики NPC, реакция на убийства, сообщения дверей и подсказки
    переписаны под хтонический космический хоррор (странная фраза Злуса
    «варю только планы» заменена на понятную жуткую);
  - фикс Godot 4.7.2: у `scripts/ui/virtual_joystick.gd` удалён
    `class_name VirtualJoystick` — он конфликтовал с нативным классом
    («hides a native class»); скрипт грузится по пути, имя не нужно;
  - мир-тест дополнен: видимый спрайт/подпись/сообщение двери,
    урон магической стрелы по Злусу.
- Шаг 12 (боевая система на демоне: экипировка, классы, ярость) — готов:
  - броня и одеяния: 3 брони у Вираса (+10/+20/+35 ХП) и 3 одеяния
    у Зорана (+мана и +ХП, только магу); в инвентаре две ячейки
    экипировки ОРУЖИЕ и БРОНЯ (клик снимает), сейв v5;
  - классовые множители обычного оружия: маг ×0.5, варвар ×2, воин/бомж ×1;
    магическое оружие: маг — полная сила + залп на Q (веер снарядов из
    `ItemDB.volley`), воин/бомж — урон +25% (магический эффект),
    варвар — отказ («оружие отвергает»);
  - демон после 3 ударов впадает в ярость: красная аура, преследование,
    удары когтями (8 урона раз в секунду — ЗАГЛУШКИ), лавка в ярости
    закрыта, реплики — угрозы; счёт ударов живёт в сессии;
  - смерть героя: экран «ТЫ ПАЛ», пробуждение в замке с полными
    хп/маной без штрафов (ЗАГЛУШКА);
  - реплики NPC/демона переписаны под лавкрафтовский хоррор,
    «добряки» заменены на «жителей»;
  - новые иконки брони/одеяний: генератор `tools/gen_armor.py`;
  - тесты расширены: smoke (броня/одеяния/множители/залп/ярость),
    world (залп жезла в мире, ячейки экипировки),
    trade (ассортимент брони и одеяний, надевание, сейв),
    demon (ярость, преследование, удары по герою, смерть в ярости).
- Шаг 13 (1-й данж «Подземелье замка» + вечная смерть демона) — готов:
  - подписи «Данж N» убраны с дверей; дверь 1 открыта — вход в данж;
  - 10 этажей по 1–5 врагов, рандом-генерация (комнаты+коридоры),
    локация — подземелье замка (новый тайлсет и 8 листов врагов);
  - виды по возрастанию сложности: паук, змея, космический паук,
    мертвец бомж, мертвец рыцарь, мертвец колдун, демон мечник,
    демон колдун; колдуны стреляют болтами с дистанции;
  - лестница вниз открывается только после убийства всех врагов этажа;
  - босс 10-го этажа — демон с юга карты: диалог (узнаёт, если видели),
    после реплик — бой; победа: все NPC оживают и забывают, демон больше
    не возвращается (сейв v6), данж засчитан, выход в замок;
  - ярость демона гаснет при возрождении героя (шаг 12-фикс);
  - тесты: world (двери без подписей, маршрут двери 1), demon (сброс
    ярости, вечная смерть, ожившие жертвы), новый dungeon_test
    (генерация, пулы, запертая лестница, босс, победа).
- Шаг 14 (сундуки и эпическая награда босса) — готов:
  - 1–2 сундука на каждом этаже данжа: клик или E — открытие, спрайт
    меняется на открытый; сундук пуст при повторном открытии;
  - таблицы добычи `Loot.chest_loot`: золото/зелья/питьё/оружие/броня/
    одеяния с ростом качества и состава по глубине этажа (все веса —
    ЗАГЛУШКИ); качество экипировки из сундуков щедрее обычных падений;
  - за босса — эпическое случайное оружие золотого качества
    (`Loot.epic_weapon_loot`); реплика о добыче после текста о победе;
  - выход на последнем этаже не встаёт на сундук (`_free_exit_tile`);
  - фиксы parse-ошибок: `Rect2i.grow` (не «grows») и явный тип
    `var t: Vector2i` при Variant-цикле (ловушка №2);
  - dungeon_test расширен: сундуки (спавн/открытие/добыча/пустота),
    эпическая награда, выход не на сундуке.
- Шаг 15 (4 больших тематических этажа вместо 10) — готов:
  - карта 64×48, комнат 10–13, врагов 7–13 на этаж, сундуков 4–5;
  - темы этажей: перекрашенные тайлы (атлас расширен до 25),
    CanvasModulate-воздух, свой пул врагов и декор на каждом этаже;
  - сокровищница из мозаики с хранителем-элитой (этажи 1–3); зал босса
    с колоннами, жаровнями, троном и ковровой дорожкой (этаж 4);
  - элитные чемпионы: ×1.9 хп, ×1.5 урон, ×3 золото, ×1.25 спрайт;
  - факелы с мерцающим светом, кристаллы, бочки/ящики/мешки/фонари,
    трон; glow.png + CanvasModulate — атмосфера темноты со светом;
  - коридоры 2-тайловые в обеих осях; декор ДО коридоров; резерв
    клеток жаровен/трона; враги не спавнятся в сокровищнице —
    автопроверка 600 этажей: связность, счётчики, элиты, босс-зал;
  - тексты обновлены под 4 этажа (HUD, реплики босса, дверь данжа);
  - пулы лута привязаны к 4 этажам (1 early, 2–3 mid, 4 late);
  - dungeon_test обновлен: 4 этажа, темы, элита, сундуки 4–5, факелы,
    реквизит, мозаика, ковёр, босс на 4-м этаже.

## 9. Автотесты (запуск headless)

- `tests/smoke_test.tscn` — слоты, meta, герои, бонус, предметы, торговля,
  лут, броня/одеяния, множители урона, залпы, ярость демона (шаг 12).
- `tests/menu_test.tscn` — сундук, кнопки, панель старта, слоты, бонус, сброс.
- `tests/world_test.tscn` — тайлы, движение, коллизии края и стен, NPC,
  диалоги и кнопка «ТОРГОВАТЬ», лавка, инвентарь с ячейками экипировки,
  двери (без подписей; дверь 1 — маршрут в данж), HUD, удары, залп жезла.
- `tests/trade_test.tscn` — стартовое золото героев, товары NPC (включая
  броню Вираса и одеяния Зорана), покупка/продажа через `Game` и через
  UI лавки, надевание брони, сейв после покупок.
- `tests/demon_test.tscn` — спавн демона после убийства, товары/цены павших
  торговцев со скидкой, реплики, запрет старых диалогов, ярость после
  трёх ударов, сброс ярости при возрождении, вечная смерть демона
  (ожившие жертвы, демон не возвращается, сейв v6).
- `tests/dungeon_test.tscn` — генерация этажей, пулы врагов по глубине,
  запертая лестница, переходы, босс (диалог/узнавание/бой/победа),
  demon_defeated и выход в замок (шаг 13); сундуки 4–5 на этаже: спавн
  на полу, открытие, добыча, пустой повтор, эпическое оружие за босса,
  выход не на сундуке (шаг 14); темы этажей, элитные чемпионы,
  сокровищница/мозаика, факелы и реквизит, ковёр зала босса (шаг 15).
- `tests/screenshot.tscn` — съёмка скриншотов (нужен X/GL: xvfb-run).

Запуск: `godot --headless --path . res://tests/<имя>.tscn`.

## 10. Генерация арта

Весь пиксель-арт генерируется Python-скриптами (PIL) и воспроизводим:
`gen_chars.py` (листы 24x32, 6 рядов), `gen_portraits.py` (портреты 64x64),
`gen_world_art.py` (тайлсет 128x128, пропы, иконки), `gen_worldmap.py`
(карта мира), `gen_demon.py` (шаг 8: лист демона 72x96 и его портрет),
`gen_doors.py` (шаг 9: спрайт запертой двери данжа 32x16),
`gen_armor.py` (шаг 12: иконки брони и одеяний 16x16),
`gen_dungeon.py` (шаг 13: тайлы подземелья + 8 листов врагов 24x32 + превью).
Скрипты лежат рядом с проектом в репозитории инструментов.

````

### Сцены

#### `scenes/character_select/character_select.gd`

````gdscript
## Экран выбора героя: Воин / Варвар / Бомж / Маг (шаги 3 и 6).
## Выбор влияет на внешность, стартовое золото (шаг 5) и хп/ману (шаг 6):
## Воин — 100 з., Варвар — 50 з., Бомж — 1 з., Маг — 60 з. (ЗАГЛУШКА),
## у Мага — хп 30 и мана 70 (задал автор).
extends Control

const MAIN_SCENE := "res://scenes/main/main.tscn"
const WORLD_SCENE := "res://scenes/world/world.tscn"
## Карточка героя: с шага 6 героев четверо — сетка 2x2 вместо ряда.
const CARD_SIZE := Vector2(150, 0)
const GRID_COLS := 2
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
    Platform.notify_ready()
    Platform.gameplay_stop()

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
    vbox.add_theme_constant_override("separation", 16)
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
    # шаг 6: героев четверо — карточки в сетке 2x2 (ряд не помещается в 360px)
    cards_box = GridContainer.new()
    cards_box.columns = GRID_COLS
    cards_box.add_theme_constant_override("h_separation", 10)
    cards_box.add_theme_constant_override("v_separation", 10)
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
    flavor.custom_minimum_size = Vector2(128, 0)
    vbox.add_child(flavor)

    # шаг 6: хп и мана героя (мана — новый показатель мага)
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

````

#### `scenes/character_select/character_select.tscn`

````ini
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scenes/character_select/character_select.gd" id="1_select"]

[node name="CharacterSelect" type="Control"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
script = ExtResource("1_select")

````

#### `scenes/dungeon/dungeon.gd`

````gdscript
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
## Сундуки: 4–5 на этаж (2 в сокровищнице/зале босса), внутри золото,
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

## Тексты подземелья (шаг 13): тон — лавкрафтовский космо-хоррор.
const FLOOR_FIRST_HINT := "Подземелье замка. Четыре огромных этажа вниз, и на каждом что-то шевелится. На самом дне ждёт тот, кто уже знает твоё имя."
const FLOOR_BOSS_HINT := "Уровень 4 из 4. Воздух дрожит от шёпота. Хозяин подземелья ждёт тебя."
const FLOOR_NO_BOSS_HINT := "Уровень 4 из 4. Здесь пахнет пеплом: хозяин подземелья уже повержен. Лестница в замок открыта."
const STAIRS_LOCKED_HINT := "Лестница вниз молчит, пока в зале кто-то дышит. Наступит тишина — и путь откроется."
const STAIRS_DOWN_HINT := "Лестница ведёт глубже. Камни помнят шаги тех, кто не вернулся."
const AGGRO_HINT := "%s заметил тебя. В темноте это плохо."
## Элитный чемпион (шаг 15): крупнее, злее, богаче. Имя — с приставкой.
const ELITE_PREFIX := "Элитный "
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
## Битва начинается, когда диалог закроется (обязательный босс).
const BOSS_NAME := "Таинственный демон"
const BOSS_ROLE_SEEN := "узнавший тебя"
const BOSS_ROLE_NEW := "хозяин подземелья"
const BOSS_LINES_SEEN := [
    "Ты помнишь меня. Я помню тебя: ты шёл к краю мира и говорил со мной, как с лавочником. Как со «смертным».",
    "Каждое убийство кормило меня. Каждая монета в моей лавке прошла через твои руки. Ты думал, я торгую? Я собирал.",
    "Четыре этажа ты спускался к своей могиле. Каждый шаг кормил меня. Я — сама могила. Начнём.",
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
var _hud_floor: Label                # «Подземелье · ур. N/4 · врагов: K»
var _hud_hint: Label
var _dialogue: DialogueUI
var _inventory_ui: InventoryUI
var _hint_tween: Tween

var _grid: Array[String] = []        # сетка текущего этажа
var _theme: Dictionary = {}          # тема текущего этажа (шаг 15)
var _floor_num := 1                  # текущий этаж (1..4)
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
var _glow_tex: Texture2D
var _glow_mat: CanvasItemMaterial
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
    _glow_tex = load(GLOW_TEX_PATH)
    _glow_mat = CanvasItemMaterial.new()
    _glow_mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
    _hero_sheet_tex = load(String(Game.HEROES.get(Game.hero_id,
        Game.HEROES[Game.DEFAULT_HERO])["sheet"]))
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
    Platform.gameplay_start()

func _exit_tree() -> void:
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
    holder.size = Vector2(360.0, WALK_H)
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
    var is_boss_floor: bool = _floor_num >= DungeonBestiary.FLOORS
    var boss_present: bool = is_boss_floor and not Game.demon_gone_forever()
    var level := DungeonBestiary.generate_floor(_floor_num, boss_present)
    _grid = level["grid"]
    _theme = DungeonBestiary.theme_for_floor(_floor_num)

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

    _build_tiles()
    _build_entities()
    _spawn_props(level)   # факелы, жаровни, кристаллы, бочки, трон

    # лестницы
    _stairs_up = {}
    _stairs_down = {}
    _stairs_exit = {}
    var up: Vector2i = level["up"]
    _register_stairs(_stairs_up, STAIRS_UP_NAME, up, "_use_stairs_up")
    var down: Vector2i = level["down"]
    if down.x >= 0:
        _register_stairs(_stairs_down, STAIRS_DOWN_NAME, down, "_use_stairs_down")

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
    if elite:
        spr.scale = Vector2(1.25, 1.25)
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
    hp_bar.position = Vector2(-12.0 * s, -float(CHAR_H) * s - 4)
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

## Выход в замок на этаже босса, когда босс давно повержен.
## Тайл сдвигается, если на нём стоит сундук (шаг 14).
func _place_exit(tile: Vector2i) -> void:
    tile = _free_exit_tile(tile)
    _set_grid_cell(tile, "X")
    if _ground != null:
        _ground.set_cell(tile, _tile_source_id, TILE_EXIT)
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
    var blocked := _dialogue.visible or _inventory_ui.visible or _player_dead
    if not blocked:
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
                _move_foe(node, to.normalized(), float(def["speed"]), delta)
                _foe_anim(spr, to)
            else:
                spr.play("idle_down")
            if dist <= float(def["attack_range"]) and float(foe["atk_cd"]) <= 0.0:
                foe["atk_cd"] = float(def.get("attack_cd", 1.1))
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
    _spawn_swing(player.position + Vector2(0, -10), Color(0.9, 0.3, 0.25))
    _spawn_damage_label(player.position + Vector2(0, -40), damage)
    _spell_poof(player.position + Vector2(0, -14), Color(0.85, 0.3, 0.25))
    _flash_player()

## Болт колдуна: летит в героя, гаснет у стен. Урон — из записи врага.
func _spawn_foe_bolt(foe: Dictionary, def: Dictionary) -> void:
    var col: Array = def.get("bolt_color", [0.6, 0.8, 0.7])
    var bolt := Sprite2D.new()
    bolt.texture = _bolt_tex
    bolt.modulate = Color(float(col[0]), float(col[1]), float(col[2]))
    bolt.scale = Vector2(0.9, 0.9)
    var from: Node2D = foe["node"]
    bolt.position = from.position + Vector2(0, -14)
    _fx.add_child(bolt)
    var dir := (player.position + Vector2(0, -14) - bolt.position).normalized()
    if dir == Vector2.ZERO:
        dir = Vector2(0, 1)   # совпадение точек: болт падает вниз, а не висит
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
    # награда: золото растёт с глубиной, у элиты — тройная (ЗАГЛУШКА);
    # иногда враг роняет зелье
    var reward := DungeonBestiary.foe_gold(def, _floor_num) \
        * int(foe.get("gold_mult", 1))
    Game.add_gold(reward)
    _show_hint(String(FOE_LOOT_GOLD_HINT) % [String(foe.get("title",
        def.get("name", "Враг"))), reward], 2.0)
    if randi() % 100 < 15:
        var potion := "hp_potion_small" if _floor_num < DungeonBestiary.FLOORS \
            else "hp_potion"
        Game.add_item({"item_id": potion, "title": ItemDB.title(potion),
            "quality": "gray"})
        _show_hint(String(FOE_LOOT_ITEM_HINT) % [String(foe.get("title",
            def.get("name", "Враг"))), ItemDB.title(potion)], 2.5)
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
    var bar_top := 640.0 - UI_BAR_H
    var hero_panel := PanelContainer.new()
    hero_panel.position = Vector2(BAR_HERO_POS.x, bar_top + BAR_HERO_POS.y)
    var hero_style := UiStyle.flat_style(Color(0.11, 0.12, 0.19), Color(0.5, 0.42, 0.16))
    hero_style.content_margin_left = 6
    hero_style.content_margin_right = 10
    hero_style.content_margin_top = 4
    hero_style.content_margin_bottom = 4
    hero_panel.add_theme_stylebox_override("panel", hero_style)
    layer.add_child(hero_panel)
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
        btn.size = BAR_BTN_SIZE
        btn.position = Vector2(BAR_BUTTONS_X, bar_top + start_y + float(i) * BAR_BTN_STEP)
        _style_small_button(btn, int(spec["font"]))
        btn.pressed.connect(spec["cb"] as Callable)
        layer.add_child(btn)
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
    _show_hint("WASD/джойстик — идти, ЛКМ — удар, I — сумка"
        + (", Q — магия" if Game.is_mage() else ""), 5.0)

## «Подземелье · ур. N/4 · врагов: K» — обновляется на спавне и после убийств.
func _update_progress_label() -> void:
    if _hud_floor == null:
        return
    var alive := 0
    for foe in _foes:
        if not bool(foe.get("dead", false)) and not bool(foe.get("boss", false)):
            alive += 1
    _hud_floor.text = "Подземелье · ур. %d/%d · врагов: %d" % [_floor_num,
        DungeonBestiary.FLOORS, alive]

func _show_floor_intro(boss_present: bool) -> void:
    if _floor_num <= 1:
        _show_hint(FLOOR_FIRST_HINT, 5.5)
    elif _floor_num >= DungeonBestiary.FLOORS:
        _show_hint(FLOOR_BOSS_HINT if boss_present else FLOOR_NO_BOSS_HINT, 5.5)
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

````

#### `scenes/dungeon/dungeon.tscn`

````ini
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scenes/dungeon/dungeon.gd" id="1_dungeon"]

[node name="Dungeon" type="Node2D"]
script = ExtResource("1_dungeon")

````

#### `scenes/main/main.gd`

````gdscript
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
    var y := FIRST_SLOT_Y + index * (BUTTON_SIZE.y + BUTTON_GAP)
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

````

#### `scenes/main/main.tscn`

````ini
[gd_scene load_steps=7 format=3]

[ext_resource type="Script" path="res://scenes/main/main.gd" id="1_main"]
[ext_resource type="Texture2D" path="res://assets/sprites/chest_closed.png" id="2_chest"]
[ext_resource type="Texture2D" path="res://assets/sprites/gift.png" id="3_gift"]

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_panel"]
bg_color = Color(0.086, 0.094, 0.149, 1)
border_width_left = 2
border_width_top = 2
border_width_right = 2
border_width_bottom = 2
border_color = Color(0.85, 0.65, 0.13, 1)
content_margin_left = 18.0
content_margin_top = 16.0
content_margin_right = 18.0
content_margin_bottom = 16.0

[sub_resource type="Gradient" id="Gradient_spark"]
offsets = PackedFloat32Array(0, 0.7)
colors = PackedColorArray(1, 0.84, 0, 1, 1, 0.84, 0, 0)

[sub_resource type="GradientTexture1D" id="GradientTexture1D_spark"]
gradient = SubResource("Gradient_spark")

[node name="MainMenu" type="Control"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
script = ExtResource("1_main")

[node name="Background" type="ColorRect" parent="."]
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
color = Color(0.05, 0.05, 0.08, 1)

[node name="TitleLabel" type="Label" parent="."]
layout_mode = 1
anchors_preset = 5
anchor_left = 0.5
anchor_right = 0.5
offset_left = -160.0
offset_right = 160.0
offset_top = 130.0
offset_bottom = 166.0
grow_horizontal = 2
theme_override_colors/font_color = Color(1, 0.84, 0, 1)
theme_override_font_sizes/font_size = 24
horizontal_alignment = 1
vertical_alignment = 1
text = "DUNGEON LOOT"

[node name="SubtitleLabel" type="Label" parent="."]
layout_mode = 1
anchors_preset = 5
anchor_left = 0.5
anchor_right = 0.5
offset_left = -160.0
offset_right = 160.0
offset_top = 172.0
offset_bottom = 190.0
grow_horizontal = 2
theme_override_colors/font_color = Color(0.55, 0.6, 0.67, 1)
theme_override_font_sizes/font_size = 12
horizontal_alignment = 1
text = "рабочее название · главное меню"

[node name="Chest" type="TextureRect" parent="."]
layout_mode = 1
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
offset_left = -32.0
offset_top = -124.0
offset_right = 32.0
offset_bottom = -60.0
grow_horizontal = 2
grow_vertical = 2
mouse_filter = 0
texture = ExtResource("2_chest")
stretch_mode = 0

[node name="Sparkles" type="CPUParticles2D" parent="."]
position = Vector2(180, 228)
emitting = false
amount = 14
lifetime = 0.55
one_shot = true
explosiveness = 1.0
direction = Vector2(0, -1)
spread = 180.0
gravity = Vector2(0, 340)
initial_velocity_min = 70.0
initial_velocity_max = 140.0
scale_amount_min = 2.0
scale_amount_max = 3.5
color_ramp = SubResource("GradientTexture1D_spark")

[node name="HintLabel" type="Label" parent="."]
layout_mode = 1
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
offset_left = -160.0
offset_top = -48.0
offset_right = 160.0
offset_bottom = -20.0
grow_horizontal = 2
theme_override_colors/font_color = Color(0.81, 0.85, 0.89, 1)
theme_override_font_sizes/font_size = 14
horizontal_alignment = 1
text = "Тапни по сундуку!"

[node name="StatsLabel" type="Label" parent="."]
layout_mode = 1
anchors_preset = 7
anchor_left = 0.5
anchor_top = 1.0
anchor_right = 0.5
anchor_bottom = 1.0
offset_left = -160.0
offset_top = -90.0
offset_right = 160.0
offset_bottom = -50.0
grow_horizontal = 2
theme_override_colors/font_color = Color(0.91, 0.91, 0.94, 1)
theme_override_font_sizes/font_size = 16
horizontal_alignment = 1
text = "Золото: 0 · Добыча: 0"

[node name="MenuButtons" type="Control" parent="."]
layout_mode = 1
mouse_filter = 2

[node name="PanelLayer" type="Control" parent="."]
visible = false
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
mouse_filter = 2

[node name="Dim" type="ColorRect" parent="PanelLayer"]
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
mouse_filter = 0
color = Color(0, 0, 0, 0.55)

[node name="Center" type="CenterContainer" parent="PanelLayer"]
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2

[node name="SettingsPanel" type="PanelContainer" parent="PanelLayer/Center"]
custom_minimum_size = Vector2(280, 0)
theme_override_styles/panel = SubResource("StyleBoxFlat_panel")

[node name="VBox" type="VBoxContainer" parent="PanelLayer/Center/SettingsPanel"]
layout_mode = 2
theme_override_constants/separation = 14

[node name="TitleLabel" type="Label" parent="PanelLayer/Center/SettingsPanel/VBox"]
layout_mode = 2
theme_override_colors/font_color = Color(1, 0.84, 0, 1)
theme_override_font_sizes/font_size = 18
horizontal_alignment = 1
text = "НАСТРОЙКИ"

[node name="SoundCheck" type="CheckButton" parent="PanelLayer/Center/SettingsPanel/VBox"]
layout_mode = 2
theme_override_font_sizes/font_size = 14
text = "Звук"

[node name="MusicCheck" type="CheckButton" parent="PanelLayer/Center/SettingsPanel/VBox"]
layout_mode = 2
theme_override_font_sizes/font_size = 14
text = "Музыка"

[node name="ResetButton" type="Button" parent="PanelLayer/Center/SettingsPanel/VBox"]
layout_mode = 2
text = "СБРОСИТЬ ПРОГРЕСС"

[node name="CloseButton" type="Button" parent="PanelLayer/Center/SettingsPanel/VBox"]
layout_mode = 2
text = "ЗАКРЫТЬ"

[node name="AuthorsPanel" type="PanelContainer" parent="PanelLayer/Center"]
visible = false
custom_minimum_size = Vector2(280, 0)
theme_override_styles/panel = SubResource("StyleBoxFlat_panel")

[node name="VBox" type="VBoxContainer" parent="PanelLayer/Center/AuthorsPanel"]
layout_mode = 2
theme_override_constants/separation = 12

[node name="TitleLabel" type="Label" parent="PanelLayer/Center/AuthorsPanel/VBox"]
layout_mode = 2
theme_override_colors/font_color = Color(1, 0.84, 0, 1)
theme_override_font_sizes/font_size = 18
horizontal_alignment = 1
text = "АВТОРЫ"

[node name="IdeaLabel" type="Label" parent="PanelLayer/Center/AuthorsPanel/VBox"]
layout_mode = 2
theme_override_font_sizes/font_size = 13
theme_override_colors/font_color = Color(0.85, 0.87, 0.9, 1)
autowrap_mode = 3
horizontal_alignment = 1
text = "Идея и гейм-дизайн: <впиши себя>"

[node name="CodeLabel" type="Label" parent="PanelLayer/Center/AuthorsPanel/VBox"]
layout_mode = 2
theme_override_font_sizes/font_size = 13
theme_override_colors/font_color = Color(0.85, 0.87, 0.9, 1)
autowrap_mode = 3
horizontal_alignment = 1
text = "Код и пиксель-арты: Z.ai (GLM)"

[node name="EngineLabel" type="Label" parent="PanelLayer/Center/AuthorsPanel/VBox"]
layout_mode = 2
theme_override_font_sizes/font_size = 13
theme_override_colors/font_color = Color(0.85, 0.87, 0.9, 1)
autowrap_mode = 3
horizontal_alignment = 1
text = "Движок: Godot 4.7"

[node name="ThanksLabel" type="Label" parent="PanelLayer/Center/AuthorsPanel/VBox"]
layout_mode = 2
theme_override_font_sizes/font_size = 13
theme_override_colors/font_color = Color(1, 0.84, 0, 1)
autowrap_mode = 3
horizontal_alignment = 1
text = "Спасибо, что тапаете по сундукам!"

[node name="CloseButton" type="Button" parent="PanelLayer/Center/AuthorsPanel/VBox"]
layout_mode = 2
text = "ЗАКРЫТЬ"

[node name="StartPanel" type="PanelContainer" parent="PanelLayer/Center"]
visible = false
custom_minimum_size = Vector2(280, 0)
theme_override_styles/panel = SubResource("StyleBoxFlat_panel")

[node name="VBox" type="VBoxContainer" parent="PanelLayer/Center/StartPanel"]
layout_mode = 2
theme_override_constants/separation = 10

[node name="TitleLabel" type="Label" parent="PanelLayer/Center/StartPanel/VBox"]
layout_mode = 2
theme_override_colors/font_color = Color(1, 0.84, 0, 1)
theme_override_font_sizes/font_size = 18
horizontal_alignment = 1
text = "ИГРА"

[node name="NewGameButton" type="Button" parent="PanelLayer/Center/StartPanel/VBox"]
layout_mode = 2
text = "НОВАЯ ИГРА"

[node name="ContinueButton" type="Button" parent="PanelLayer/Center/StartPanel/VBox"]
layout_mode = 2
text = "ПРОДОЛЖИТЬ"

[node name="LoadButton" type="Button" parent="PanelLayer/Center/StartPanel/VBox"]
layout_mode = 2
text = "ЗАГРУЗИТЬ ИГРУ"

[node name="StartHint" type="Label" parent="PanelLayer/Center/StartPanel/VBox"]
layout_mode = 2
theme_override_colors/font_color = Color(0.55, 0.6, 0.67, 1)
theme_override_font_sizes/font_size = 11
horizontal_alignment = 1
text = ""

[node name="StartCloseButton" type="Button" parent="PanelLayer/Center/StartPanel/VBox"]
layout_mode = 2
text = "ЗАКРЫТЬ"

[node name="SlotsBox" type="VBoxContainer" parent="PanelLayer/Center/StartPanel"]
visible = false
layout_mode = 2
theme_override_constants/separation = 10

[node name="SlotsTitle" type="Label" parent="PanelLayer/Center/StartPanel/SlotsBox"]
layout_mode = 2
theme_override_colors/font_color = Color(1, 0.84, 0, 1)
theme_override_font_sizes/font_size = 18
horizontal_alignment = 1
text = "ЗАГРУЗИТЬ ИГРУ"

[node name="SlotsList" type="VBoxContainer" parent="PanelLayer/Center/StartPanel/SlotsBox"]
layout_mode = 2
theme_override_constants/separation = 8

[node name="SlotsBackButton" type="Button" parent="PanelLayer/Center/StartPanel/SlotsBox"]
layout_mode = 2
text = "НАЗАД"

[node name="BonusPanel" type="PanelContainer" parent="PanelLayer/Center"]
visible = false
custom_minimum_size = Vector2(280, 0)
theme_override_styles/panel = SubResource("StyleBoxFlat_panel")

[node name="VBox" type="VBoxContainer" parent="PanelLayer/Center/BonusPanel"]
layout_mode = 2
theme_override_constants/separation = 14

[node name="TitleLabel" type="Label" parent="PanelLayer/Center/BonusPanel/VBox"]
layout_mode = 2
theme_override_colors/font_color = Color(1, 0.84, 0, 1)
theme_override_font_sizes/font_size = 18
horizontal_alignment = 1
text = "БОНУС"

[node name="Gift" type="TextureRect" parent="PanelLayer/Center/BonusPanel/VBox"]
layout_mode = 2
size_flags_horizontal = 4
custom_minimum_size = Vector2(64, 64)
stretch_mode = 0
texture = ExtResource("3_gift")

[node name="BonusLabel" type="Label" parent="PanelLayer/Center/BonusPanel/VBox"]
layout_mode = 2
theme_override_font_sizes/font_size = 13
theme_override_colors/font_color = Color(0.85, 0.87, 0.9, 1)
autowrap_mode = 3
horizontal_alignment = 1
text = "Раз в день: 50-200 золота\nи фиолетовая добыча!"

[node name="ClaimButton" type="Button" parent="PanelLayer/Center/BonusPanel/VBox"]
layout_mode = 2
text = "ЗАБРАТЬ ПОДАРОК"

[node name="ResultLabel" type="Label" parent="PanelLayer/Center/BonusPanel/VBox"]
layout_mode = 2
theme_override_font_sizes/font_size = 14
theme_override_colors/font_color = Color(0.85, 0.87, 0.9, 1)
autowrap_mode = 3
horizontal_alignment = 1
text = ""

[node name="CloseButton" type="Button" parent="PanelLayer/Center/BonusPanel/VBox"]
layout_mode = 2
text = "ЗАКРЫТЬ"

[connection signal="gui_input" from="Chest" to="." method="_on_chest_gui_input"]
[connection signal="toggled" from="PanelLayer/Center/SettingsPanel/VBox/SoundCheck" to="." method="_on_sound_toggled"]
[connection signal="toggled" from="PanelLayer/Center/SettingsPanel/VBox/MusicCheck" to="." method="_on_music_toggled"]
[connection signal="pressed" from="PanelLayer/Center/SettingsPanel/VBox/ResetButton" to="." method="_on_reset_pressed"]
[connection signal="pressed" from="PanelLayer/Center/SettingsPanel/VBox/CloseButton" to="." method="_close_panel"]
[connection signal="pressed" from="PanelLayer/Center/AuthorsPanel/VBox/CloseButton" to="." method="_close_panel"]
[connection signal="pressed" from="PanelLayer/Center/StartPanel/VBox/NewGameButton" to="." method="_on_new_game_pressed"]
[connection signal="pressed" from="PanelLayer/Center/StartPanel/VBox/ContinueButton" to="." method="_on_continue_pressed"]
[connection signal="pressed" from="PanelLayer/Center/StartPanel/VBox/LoadButton" to="." method="_on_load_pressed"]
[connection signal="pressed" from="PanelLayer/Center/StartPanel/VBox/StartCloseButton" to="." method="_close_panel"]
[connection signal="pressed" from="PanelLayer/Center/StartPanel/SlotsBox/SlotsBackButton" to="." method="_on_slots_back_pressed"]
[connection signal="pressed" from="PanelLayer/Center/BonusPanel/VBox/ClaimButton" to="." method="_on_claim_bonus_pressed"]
[connection signal="pressed" from="PanelLayer/Center/BonusPanel/VBox/CloseButton" to="." method="_close_panel"]

````

#### `scenes/world/dialogue_ui.gd`

````gdscript
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
    _trade_button.pressed.connect(func() -> void: trade_requested.emit())
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

func _on_dim_input(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        _advance()

## Клик по телу панели — тоже «дальше» (шаг 11). Кнопка ТОРГОВАТЬ сама
## перехватывает нажатие и сюда не пропускает.
func _on_panel_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed \
            and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
        _advance()

func _unhandled_input(event: InputEvent) -> void:
    if not _active:
        return
    # Шаг 11: листают реплики E и F (действие "interact"), Enter/пробел и
    # клик по затемнению (см. _on_dim_input). Удар (ЛКМ) в мире — но открытое
    # окно приоритетнее, а ЛКМ уже ловится затемнением как «дальше».
    if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
        _advance()
        # Шаг 6 (фикс мигания): помечаем событие обработанным, чтобы
        # то же нажатие E не дошло до мира и не переоткрыло диалог тут же.
        get_viewport().set_input_as_handled()
    elif event.is_action_pressed("ui_cancel"):
        _close()
        get_viewport().set_input_as_handled()

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

````

#### `scenes/world/inventory_ui.gd`

````gdscript
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
    close_btn.pressed.connect(close)
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

func _on_dim_input(_viewport: Node, event: InputEvent, _idx: int) -> void:
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        var pos: Vector2 = (event as InputEventMouseButton).position
        if not _panel.get_global_rect().has_point(pos):
            close()

func _unhandled_input(event: InputEvent) -> void:
    if not visible:
        return
    if event.is_action_pressed("toggle_inventory") or event.is_action_pressed("ui_cancel"):
        close()

````

#### `scenes/world/trade_ui.gd`

````gdscript
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
    close_btn.pressed.connect(close)
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

func _on_dim_input(_viewport: Node, event: InputEvent, _idx: int) -> void:
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        var pos: Vector2 = (event as InputEventMouseButton).position
        if not _panel.get_global_rect().has_point(pos):
            close()

func _unhandled_input(event: InputEvent) -> void:
    if not visible:
        return
    if event.is_action_pressed("ui_cancel"):
        close()

````

#### `scenes/world/world.gd`

````gdscript
## Мир «Dungeon Loot» (шаг 7): замок + двор + край мира с безграничным космосом.
## Персонажи 24x32 с покадровыми анимациями (idle с дыханием/морганием,
## ходьба в 4 направления), y-sort глубины, диалоги с портретами,
## торговля с NPC (покупка/продажа), инвентарь, анимированные факелы/жаровни/
## фонтан/горн, парящие астероиды.
## Шаг 6: полосы ХП и маны в HUD, у мага — кнопка МАГИЯ (Q) и снаряд
## «Магической стрелы», реген маны; фиксы мигания диалога.
## Шаг 7 (боевая система): удар E и кнопка УДАР у всех героев — без оружия
## в руках удар рукой, с оружием — оружием (урон из ItemDB); у NPC есть хп
## и полоска над головой; убитый NPC падает и не воскресает в этой сессии,
## остальные NPC запоминают убийство (реплика + отказ торговать).
## Шаг 8 (демон): после первого убийства у края улицы из теней выступает
## Таинственный демон (втрое крупнее NPC, парит на хвосте). Он радуется
## убийству жителей, хвалит героя и зовёт убивать ещё: -10% за каждого
## убитого NPC, а товары убитых торговцев переезжают в его лавку.
## Старые диалоги живых NPC пропадают: остаётся только реплика про убийство.
## Шаг 9: «Магическая стрела» больше не пустышка — наносит урон первому
## живому NPC на пути (урон из Game.SPELL); двери данжей стали явными:
## видимые запертые створки с подписью «Данж N», клик или E рядом —
## «Подземелье пока недоступно»; реплики NPC переписаны под хтонический
## космический хоррор; фикс Godot 4.7.2: у джойстика больше нет class_name
## (конфликт с нативным классом VirtualJoystick).
## Шаг 10 (UI вне экрана ходьбы): мир рендерится в SubViewport у верхнего
## края экрана, нижняя полоса отдана консоли UI — панель героя (хп/мана/
## золото), кнопки действий и джойстик живут там и физически не могут
## перекрыть окружение. Временные подсказки переехали к верхнему краю
## экрана ходьбы.
## Шаг 11 (управление и компактный HUD): диалог теперь на E (F тоже
## работает), удар — на левую кнопку мыши (E больше не бьёт; телефон
## адаптируем позже). Кнопки действий уменьшены (64x22), джойстик 100 px,
## консоль сжата до 112 px — экран ходьбы вырос до 360x528. Клик по пустому
## месту экрана ходьбы = удар, клик по NPC/двери = диалог (как раньше).
## Диалоговые панели (dialogue_ui.gd) больше не могут уехать за экран:
## высота считается от размера вьюпорта и резерва консоли.
## Движение: клавиатура (стрелки/WASD/E или F — говорить, ЛКМ — удар,
## I — сумка, Q — магия у мага) + VirtualJoystick.
## Шаг 12 (боевая система на демоне):
## - демон терпит ровно 3 удара (DEMON_RAGE_HITS), потом впадает в ярость:
##   красный аура, преследует героя (DEMON_SPEED), бьёт когтями по
##   DEMON_DAMAGE с кулдауном; лавка демона в ярости закрыта, реплики
##   меняются на угрозы; в этом состоянии он остаётся до конца сессии;
## - герой получил смерть: при хп 0 — затемнение «ТЫ ПАЛ», по кнопке герой
##   очинается в замке с полными хп/маной (без штрафов — ЗАГЛУШКА);
## - у мага Q стал зависимым от оружия: с магическим оружием — залп
##   этого оружия (веер снарядов из ItemDB.volley), без него — классическая
##   «Магическая стрела»; не-магам Q отвечает отказом (свой у каждого класса);
## - реплики NPC и демона переписаны под лавкрафтовский космо-хоррор
##   («добряки» в тексте заменены на «жителей»/«смертных»).
## Шаг 13 (данж 1 и вечная смерть демона):
## - подписи «Данж N» с дверей убраны — двери говорят сами за себя;
## - дверь 1 открывается: она ведёт в Подземелье замка (сцена dungeon.tscn);
##   остальные двери всё ещё заперты (хоррор-диалог);
## - при возрождении героя ярость демона ГАСНЕТ (Game.reset_demon_rage):
##   демон снова мирен, счёт ударов обнулён, аура снята;
## - если убить демона НА КАРТЕ — Game.defeat_demon_permanently(): убитые
##   NPC оживают и забывают убийства (сигнал npcs_revived), демон больше
##   не возвращается (и как босс данжа 1 тоже — см. dungeon.gd);
## - демона больше нет и если он уже повержен: спавн у края мира
##   блокируется навсегда (Game.demon_gone_forever).
extends Node2D

const MAIN_SCENE := "res://scenes/main/main.tscn"
const DUNGEON_SCENE := "res://scenes/dungeon/dungeon.tscn"
const SPEED := 95.0
const COLOR_GOLD := Color(1, 0.84, 0)
const CHAR_W := 24
const CHAR_H := 32

## Шаг 10/11: экран ходьбы и консоль UI. Мир рендерится в SubViewport
## 360xWALK_H, вставленный в верхнюю часть экрана; нижние UI_BAR_H
## пикселей отданы нижней консоли: панель героя, кнопки действий и
## джойстик живут там и окружение не перекрывают. Шаг 11: консоль сжата
## с 148 до 112 px (кнопки 64x22, джойстик 100 px) — экран ходьбы вырос.
const UI_BAR_H := 112.0
const WALK_H := 640.0 - UI_BAR_H
## Геометрия консоли (в её локальных координатах, 360 x UI_BAR_H):
## слева джойстик 100 px, в центре панель героя, справа столбик кнопок.
const BAR_JOY_POS := Vector2(2, 6)
const BAR_HERO_POS := Vector2(110, 6)
const BAR_BUTTONS_X := 292.0
## Размер кнопок действий (шаг 11): подписи без клавиш — клавиши
## перечислены в подсказке у верхнего края экрана ходьбы.
const BAR_BTN_SIZE := Vector2(64, 22)
const BAR_BTN_STEP := 25.0

## Реплики NPC (шаг 4; шаг 9/12 — лавкрафтовский космо-хоррор: замок висит
## над Пустотой уже тысячу лет, и жители давно перестали делать вид,
## что это нормально). Числа товаров в репликах совпадают с ItemDB.
const NPC_LINES := {
    "zlus": [
        "Рецепты приходят ко мне во сне. Я не сплю девятую ночь, но зелья готовы: лечение и мана, флаконы трёх размеров.",
        "Не заглядывай в котёл надолго. Он смотрит в ответ и запоминает лица. Малое зелье — 25 з., большое — 100.",
        "Верхние двери запечатаны не замком, а страхом. То, что спит за ними, видело тебя ещё до твоего рождения.",
    ],
    "lira": [
        "Добро пожаловать в замок, смертный. Он плывёт по Пустоте уже тысячу лет, и никто не помнит, куда мы плывём.",
        "Звёзды сегодня стоят неправильно. Я сверяла с картами: так они стояли в ночь, когда замок оторвался от земли.",
        "Это платье сшито из тьмы между звёздами. Мне больше ничего не снится. Тебе скоро тоже перестанет.",
    ],
    "glot": [
        "Пей, пока горло ещё твоё. Вода, морс, сок, пиво — всё, что удерживает тебя в этом мире.",
        "Чем дороже напиток, тем крепче он держит: вода 20 хп, морс 40, сок 60, пиво 100.",
        "Пиво даёт сто хп, но потом в затылке дышит кто-то другой. Это не похмелье. Не оборачивайся.",
    ],
    "zoran": [
        "Обычная сталь — к Вирасу. Магическое оружие и одеяния — ко мне: металлы шепчут мне имена прежних хозяев. Все они мертвы.",
        "Жезл молний — 1200 з. и 35 урона. Клинок инея — 2500 з. и 55: его раны не греются даже у костра. Скипетр кометы — 6000 з. и 110.",
        "Одеяния для мага висят справа: чем темнее ткань, тем больше маны она вмещает. Луну в окне я не вывешивал. Она пришла сама.",
    ],
    "gura": [
        "Кухня ещё заперта, но окорок готов: мясо зрело во тьме между звёздами. 10 золота — и оно твоё.",
        "Пиво не варю. Ножи не любят пьяных, а я не спорю с тем, что живёт в ящиках с ножами.",
        "Голодный слышит зов запертых дверей громче всех. Ешь, смертный. Пока еда ещё еда.",
    ],
    "viras": [
        "Меч — 1000, большой меч — 2000, моргенштерн — 5000. Каждый удар в моргенштерн уже вбит заранее. Как гвоздь. Как судьба.",
        "Горн дышит. Я кую всю жизнь и ни разу не видел пламени — только тень пламени, отброшенную из-за края мира.",
        "Теперь вью и доспехи: кожа 40 з., кольчуга 90, латы 180. Чем крепче железо на груди, тем дольше космос будет ждать твою душу.",
    ],
}
## Двери данжей (шаг 9; шаг 13): подписи с дверей убраны. Дверь 1 открыта:
## ведёт в Подземелье замка. Остальные заперты — клик или E рядом — сообщение.
const DOOR_LINES := [
    "Подземелье пока недоступно. Дверь запечатана изнутри — тем, что спит за ней. Это милосердие, а не замок.",
    "Прислушайся: иногда по ту сторону что-то скребётся в ответ на твои шаги. Сегодня оно молчит. Это хуже.",
]
const EDGE_HINT := "Край мира. Дальше — безграничный космос. Он давно смотрит в ответ, и тебе уже кажется, что ты узнал этот взгляд."
## Название двери в диалоге (шаг 9): клик или E рядом с запертой дверью.
const DOOR_NAME := "Дверь данжа"
const DOOR_ROLE := "Заперто"
## Шаг 13: диалог открытой двери 1 (перед входом в данж — у двери свой голос).
const DOOR_OPEN_LINES := [
    "Эта дверь дышит. За ней — четыре огромных этажа вниз, и на каждом что-то шевелится.",
    "На самом дне ждёт тот, кто уже знает твоё имя. Лестницы открываются тишине: очисти зал — и путь вниз откроется.",
]
const DOOR_OPEN_ROLE := "Открыто"
## Дистанция до двери для E-взаимодействия (клик работает издалека).
const DOOR_INTERACT_RANGE := 44.0

## Параметры удара (шаг 7): дистанция до цели и кулдаун между ударами.
const STRIKE_RANGE := 28.0
const STRIKE_COOLDOWN := 0.4

## Шаг 12: ярость демона. Порог ударов — в Game.DEMON_RAGE_HITS (3).
## Скорость преследования ниже скорости героя (SPEED 95) — убежать можно.
## DEMON_DAMAGE и дистанция когтей — ЗАГЛУШКИ, утверждает автор.
const DEMON_SPEED := 55.0
const DEMON_DAMAGE := 8
const DEMON_ATTACK_RANGE := 30.0
const DEMON_ATTACK_CD := 1.0
const DEMON_RAGE_TINT := Color(1.2, 0.45, 0.45)
## Демон считает удары вслух: после третьего следует ярость (сигнал Game).
const DEMON_HIT_HINTS := [
    "Демон шепчет: «Один...»",
    "Демон шепчет: «Два... ДВА!»",
]
const DEMON_ENRAGE_HINT := "Демон взревел! Три удара пробудили древнюю ярость: лавка закрыта, а сам он охотится на тебя."
## Реплики демона в ярости (шаг 12): лавки больше нет, только угрозы.
const DEMON_RAGE_LINES := [
    "Ты ударил меня. ТРИЖДЫ. Смертный, ты не понимаешь, чью руку поднял.",
    "Моя лавка закрыта. Милосердие кончилось. Сейчас я покажу тебе, что живёт между звёздами.",
    "Беги или стой — всё равно. Пустота уже держит твою тень за горло.",
]
## Текст экрана смерти (шаг 12, ЗАГЛУШКА: штрафов нет — автор утвердит позже).
const DEATH_TITLE := "ТЫ ПАЛ"
const DEATH_TEXT := "Космос равнодушно смотрел, как твоя тень растворилась между звёзд. Но замок ещё держит тебя в этом сне — и возвращать не собирается."
const DEATH_BUTTON := "ОЧНУТЬСЯ В ЗАМКЕ"
const RESPAWN_HINT := "Ты очнулся в замке. Демон забыл свою ярость — он снова мирен... пока что."
## Шаг 13: демон повержен НАВСЕГДА (на карте). Жертвы возвращаются к жизни.
const DEMON_DEFEATED_HINT := "Демон повержен! Убитые тобой жители вернулись в замок и ничего не помнят. Демон больше не вернётся — ни сюда, ни из глубины подземелья."

## Реакция живых NPC на убийства (шаг 7; шаг 9/12 — тон жутче): id говорящего
## -> шаблон, %s заменяется на имена убитых (в винительном падеже).
## У торговцев при этом скрывается кнопка «ТОРГОВАТЬ» — они помнят.
const NPC_MURDER_REACTIONS := {
    "zlus": "Ты убил %s! Котёл замолчал навсегда. Теперь рецепты будут шептаться только о тебе.",
    "lira": "Ты убил %s... Звёзды отвернулись от замка. Даже Пустота осуждает тебя, смертный.",
    "glot": "Ты убил %s?! В моём зале убийце не нальют. Даже вода помнит вкус твоих рук.",
    "zoran": "Ты убил %s... Сталь почуяла кровь убийцы. Она не ляжет в твою руку, что бы ты ни платил.",
    "gura": "Ты убил %s?! Ножи всё видели. Ножи всё запомнили. Однажды они заговорят с тобой.",
    "viras": "Ты убил %s... Я не кую для убийц: металл ржавеет от одного твоего дыхания.",
}

## Имена убитых NPC в винительном падеже (для реплик остальных).
const NPC_VICTIM_ACC := {
    "zlus": "Злуса", "lira": "Лиру", "glot": "Глота",
    "zoran": "Зорана", "gura": "Гуру", "viras": "Вираса",
    "demon": "демона",
}

var _ground: TileMapLayer
var _entities: Node2D
var player: CharacterBody2D
var _player_sprite: AnimatedSprite2D
var _camera: Camera2D
var _joystick: Control = null
var _world: Node2D = null              # контент мира внутри SubViewport (шаг 10)
var _walk_holder: SubViewportContainer = null  # контейнер экрана ходьбы (шаг 11)
var _walk_view: SubViewport = null     # сам SubViewport экрана ходьбы (шаг 11)
var _hud_bar: Control = null           # нижняя консоль UI (шаг 10)
var _npcs: Array[Dictionary] = []
var _doors: Array[Dictionary] = []
var _hud_gold: Label
var _hud_hp: ProgressBar
var _hud_mana: ProgressBar
var _spell_button: Button = null
var _attack_button: Button = null
var _hud_weapon: Label
var _hud_hint: Label
var _dialogue: DialogueUI
var _inventory_ui: InventoryUI
var _trade_ui: TradeUI
var _dialogue_npc: Dictionary = {}   # данные NPC последнего открытого диалога

## Лямбды HUD хранятся отдельно: сигналы Game (автозагрузка) переживают
## смену сцены, поэтому в _exit_tree их нужно отвязать — иначе после ухода
## из мира мёртвая лямбда падает на первом же изменении золота/хп в данже.
var _cb_gold: Callable
var _cb_equipped: Callable
var _cb_hp: Callable
var _cb_mana: Callable
var _anim_time := 0.0
var _facing := "down"
var _edge_hint_shown := false
var _hero_sheet_tex: Texture2D
var _shadow_tex: Texture2D
var _pointer_tex: Texture2D
var _bolt_tex: Texture2D
# --- шаг 6: заклинание мага и фиксы мигания ---
var _bolts: Array[Dictionary] = []       # летящие стрелы: {node, dir, left}
var _spell_cd := 0.0                     # кулдаун каста, сек
var _mana_regen_accum := 0.0             # накопитель регена маны
var _dialogue_closed_at := -10000        # msec, когда диалог закрылся
var _hint_tween: Tween
# --- шаг 7: удары и память NPC ---
var _strike_cd := 0.0                    # кулдаун удара, сек
# --- шаг 8: Таинственный демон ---
var _demon_spawned := false              # демон появляется один раз за сессию
# --- шаг 11: удар по клику ЛКМ — время клика, который открыл диалог ---
# физпикинг может сработать позже gui_input: без метки клик по NPC
# успевал бы и ударить, и открыть диалог
var _click_dialog_at := -10000           # msec, когда клик открыл диалог
# --- шаг 12: ярость демона и смерть героя ---
var _player_dead := false                # экран смерти поверх мира
var _death_layer: CanvasLayer = null     # затемнение «ТЫ ПАЛ» (шаг 12)

func _ready() -> void:
    _shadow_tex = load("res://assets/sprites/props/shadow.png")
    _pointer_tex = load("res://assets/sprites/props/pointer.png")
    _bolt_tex = load("res://assets/sprites/icons/magic_bolt.png")
    _build_walk_screen()
    _build_background()
    _build_tiles()
    _build_entities()
    _build_props()
    _build_npcs()
    _build_doors()
    _build_player()
    _build_hud()
    _build_joystick()
    _build_death_ui()
    # шаг 8/9/13: демон следит за убийствами и выходит из теней строго после
    # первой жертвы — но только если он ещё не повержен навсегда.
    Game.npc_killed.connect(_on_npc_killed)
    if Game.demon_kill_count() > 0 and not Game.demon_gone_forever():
        _spawn_demon()   # сессия продолжается — демон уже ждёт у края
    # шаг 13: ожившие жертвы демона возвращаются на свои места
    Game.npcs_revived.connect(_revive_npcs_in_world)
    # шаг 12: ярость демона (третий удар) и смерть героя (хп до нуля)
    Game.demon_enraged_changed.connect(_on_demon_enraged)
    Game.hp_changed.connect(_on_player_hp_changed)
    _dialogue = DialogueUI.new()
    add_child(_dialogue)
    # шаг 11: диалоговая панель держится над консолью UI — резерв берётся
    # из её высоты, поэтому панель не уедет и за экран при любом контенте
    _dialogue.bottom_reserve = UI_BAR_H + 8.0
    _dialogue.trade_requested.connect(_on_trade_requested)
    _dialogue.closed.connect(_on_dialogue_closed)
    _inventory_ui = InventoryUI.new()
    add_child(_inventory_ui)
    _trade_ui = TradeUI.new()
    add_child(_trade_ui)
    Platform.gameplay_start()

func _exit_tree() -> void:
    Platform.gameplay_stop()
    _disconnect_cb(Game.gold_changed, _cb_gold)
    _disconnect_cb(Game.equipped_changed, _cb_equipped)
    _disconnect_cb(Game.hp_changed, _cb_hp)
    _disconnect_cb(Game.mana_changed, _cb_mana)
    if Game.npc_killed.is_connected(_on_npc_killed):
        Game.npc_killed.disconnect(_on_npc_killed)
    if Game.npcs_revived.is_connected(_revive_npcs_in_world):
        Game.npcs_revived.disconnect(_revive_npcs_in_world)
    if Game.demon_enraged_changed.is_connected(_on_demon_enraged):
        Game.demon_enraged_changed.disconnect(_on_demon_enraged)
    if Game.hp_changed.is_connected(_on_player_hp_changed):
        Game.hp_changed.disconnect(_on_player_hp_changed)

## Отвязать лямбду HUD от сигнала Game (если была привязана).
func _disconnect_cb(sig: Signal, cb: Callable) -> void:
    if not cb.is_null() and sig.is_connected(cb):
        sig.disconnect(cb)

# ----------------------------------------------------------- экран ходьбы

## Шаг 10/11: мир живёт в SubViewport 360xWALK_H, вставленном контейнером в
## верхнюю часть экрана. Вся нижняя полоса отдана консоли UI, поэтому
## интерфейс физически не может перекрыть окружение. Клики по NPC и
## дверям работают внутри SubViewport: physics_object_picking включён,
## ввод в него пробрасывает SubViewportContainer (область 360xWALK_H).
## Шаг 11: тот же контейнер отдаёт клики ЛКМ в gui_input — оттуда бьёт
## клик-удар по пустому месту (см. _on_walk_click).
func _build_walk_screen() -> void:
    var holder := SubViewportContainer.new()
    holder.name = "WalkScreen"
    holder.stretch = true
    holder.position = Vector2.ZERO
    holder.size = Vector2(360.0, WALK_H)
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
    # шаг 11: клики ЛКМ по экрану ходьбы ловим в gui_input контейнера —
    # они и бьют (по пустому месту), и не мешают кликам по NPC/дверям
    holder.gui_input.connect(_on_walk_click)
    _world = Node2D.new()
    _world.name = "WorldContent"
    walk_view.add_child(_world)

# ---------------------------------------------------------------- космос

func _build_background() -> void:
    var parallax := ParallaxBackground.new()
    for config in [
        {"tex": "res://assets/backgrounds/stars_far.png", "scale": Vector2(0.12, 0.12)},
        {"tex": "res://assets/backgrounds/stars_near.png", "scale": Vector2(0.3, 0.3)},
    ]:
        var layer := ParallaxLayer.new()
        layer.motion_scale = config["scale"]
        layer.motion_mirroring = Vector2(360, 640)
        var spr := Sprite2D.new()
        spr.texture = load(config["tex"])
        spr.centered = false
        layer.add_child(spr)
        parallax.add_child(layer)
    _world.add_child(parallax)

# ---------------------------------------------------------------- тайлы

func _build_tiles() -> void:
    var atlas_tex: Texture2D = load("res://assets/tilesets/world_tiles.png")
    var tileset := TileSet.new()
    tileset.tile_size = Vector2i(WorldMap.TILE_SIZE, WorldMap.TILE_SIZE)
    tileset.add_physics_layer()
    tileset.set_physics_layer_collision_layer(0, 1)
    var source := TileSetAtlasSource.new()
    source.texture = atlas_tex
    source.texture_region_size = Vector2i(WorldMap.TILE_SIZE, WorldMap.TILE_SIZE)
    var source_id := tileset.add_source(source)
    var half := WorldMap.TILE_SIZE / 2.0
    var square := PackedVector2Array([
        Vector2(-half, -half), Vector2(half, -half),
        Vector2(half, half), Vector2(-half, half),
    ])
    for symbol in WorldMap.TILE_ATLAS:
        var coords: Vector2i = WorldMap.TILE_ATLAS[symbol]
        source.create_tile(coords)
        if WorldMap.SOLID_TILES.contains(symbol):
            var data := source.get_tile_data(coords, 0)
            data.add_collision_polygon(0)
            data.set_collision_polygon_points(0, 0, square)

    _ground = TileMapLayer.new()
    _ground.name = "Ground"
    _ground.tile_set = tileset
    _world.add_child(_ground)
    for y in WorldMap.MAP_H:
        for x in WorldMap.MAP_W:
            var symbol: String = WorldMap.MAP[y][x]
            _ground.set_cell(Vector2i(x, y), source_id, WorldMap.TILE_ATLAS[symbol])

# ---------------------------------------------------------------- сущности (y-sort)

func _build_entities() -> void:
    _entities = Node2D.new()
    _entities.name = "Entities"
    _entities.y_sort_enabled = true
    _world.add_child(_entities)

## Позиция сущности у «ног» (для честной y-сортировки глубины).
func _feet_pos(tile: Vector2, w: int, h: int) -> Vector2:
    return Vector2(tile.x * 16.0 + w * 8.0, (tile.y + h) * 16.0 - 3.0)

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

# ---------------------------------------------------------------- пропы

func _build_props() -> void:
    for prop in WorldMap.PROPS:
        var w: int = prop["w"]
        var h: int = prop["h"]
        var pos := _feet_pos(prop["tile"], w, h)
        var node := Node2D.new()
        node.name = "Prop_%s" % prop["name"]
        node.position = pos
        _entities.add_child(node)

        var visual: Node2D
        if prop.has("anim"):
            var anim_info: Array = prop["anim"]
            var spr := AnimatedSprite2D.new()
            var frames := SpriteFrames.new()
            frames.remove_animation("default")
            frames.add_animation("idle")
            frames.set_animation_speed("idle", anim_info[2])
            frames.set_animation_loop("idle", true)
            for i in range(int(anim_info[1])):
                var variant_tex: Texture2D = load("%s_%d.png" % [anim_info[0], i])
                frames.add_frame("idle", variant_tex)
            spr.sprite_frames = frames
            spr.play("idle")
            visual = spr
        else:
            var spr := Sprite2D.new()
            spr.texture = load(String(prop["texture"]))
            visual = spr
        var visual_h: float
        if visual is AnimatedSprite2D:
            visual_h = (visual as AnimatedSprite2D).sprite_frames \
                .get_frame_texture("idle", 0).get_height()
        else:
            visual_h = (visual as Sprite2D).texture.get_height()
        visual.position = Vector2(0, -(visual_h / 2.0) + 3.0)
        node.add_child(visual)

        # орбита луны вокруг планеты
        if prop["name"] == "planet":
            var moon := Node2D.new()
            var moon_spr := Sprite2D.new()
            moon_spr.texture = load("res://assets/sprites/props/moon.png")
            moon_spr.position = Vector2(44, 0)
            moon.add_child(moon_spr)
            node.add_child(moon)
            var tw := create_tween().set_loops()
            tw.tween_property(moon, "rotation", TAU, 14.0).from(0.0)

        # покачивание парящих островов и астероидов
        if prop.has("bob"):
            var bob: Vector2 = prop["bob"]
            var tw := create_tween().set_loops()
            tw.tween_property(visual, "position:y",
                visual.position.y - bob.x, bob.y) \
                .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
            tw.tween_property(visual, "position:y", visual.position.y, bob.y) \
                .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

        if bool(prop["solid"]):
            var body := StaticBody2D.new()
            body.collision_layer = 1
            body.collision_mask = 0
            var shape := CollisionShape2D.new()
            var rect := RectangleShape2D.new()
            rect.size = Vector2(w * 16.0 - 4.0, 10.0)
            shape.shape = rect
            shape.position = Vector2(0, -4)
            body.add_child(shape)
            node.add_child(body)

# ---------------------------------------------------------------- NPC

func _build_npcs() -> void:
    for npc_data in WorldMap.NPCS:
        if bool(npc_data.get("demon", false)):
            continue   # шаг 8: демон появляется только после первого убийства
        _spawn_npc(npc_data)

## Создать узел NPC по данным из WorldMap.NPCS и добавить его в мир.
## scale (шаг 8) — во сколько раз NPC крупнее обычного (демон втрое крупнее):
## кадры листа 24x32 * scale, крупнее тело, зона клика, имя и полоска хп.
func _spawn_npc(npc_data: Dictionary) -> Dictionary:
    var npc_id: String = npc_data["id"]
    var s := maxi(1, int(npc_data.get("scale", 1)))
    var fw := CHAR_W * s
    var fh := CHAR_H * s
    var pos := _feet_pos(npc_data["tile"], 1, 1)
    var node := Node2D.new()
    node.name = "NPC_%s" % npc_id
    node.position = pos

    _add_shadow(node, 0.9 * s)
    var spr := AnimatedSprite2D.new()
    var tex: Texture2D = load(String(npc_data["sheet"]))
    spr.sprite_frames = _make_frames(tex, fw, fh)
    spr.position = Vector2(0, -fh / 2.0 + 3.0)
    spr.play("idle_down")
    node.add_child(spr)

    # Небольшое тело, чтобы нельзя было пройти сквозь NPC.
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

    var area := Area2D.new()
    area.input_pickable = true
    area.collision_layer = 4
    area.collision_mask = 0
    var area_shape := CollisionShape2D.new()
    var rect := RectangleShape2D.new()
    rect.size = Vector2(18.0 * s, 24.0 * s)
    area_shape.shape = rect
    area_shape.position = Vector2(0, -10.0 * s)
    area.add_child(area_shape)
    area.input_event.connect(_on_npc_input.bind(npc_id))
    node.add_child(area)

    var name_label := Label.new()
    name_label.text = "%s · %s" % [npc_data["name"], npc_data["role"]]
    name_label.position = Vector2(-66.0 * s, -fh - 14)
    name_label.size = Vector2(132.0 * s, 12)
    name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    name_label.add_theme_font_size_override("font_size", 9)
    name_label.add_theme_color_override("font_color", COLOR_GOLD)
    name_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.7))
    name_label.add_theme_constant_override("shadow_offset_y", 1)
    node.add_child(name_label)

    # шаг 7: полоска хп NPC над головой — видна после первого урона
    var npc_hp := maxi(1, int(npc_data.get("hp", 1)))
    var hp_bar := ProgressBar.new()
    hp_bar.min_value = 0
    hp_bar.max_value = npc_hp
    hp_bar.value = npc_hp
    hp_bar.show_percentage = false
    hp_bar.custom_minimum_size = Vector2(24.0 * s, 4)
    hp_bar.size = Vector2(24.0 * s, 4)
    hp_bar.position = Vector2(-12.0 * s, -fh - 4)
    hp_bar.visible = false
    hp_bar.add_theme_stylebox_override("background",
        _bar_style(Color(0.09, 0.08, 0.1), Color(0.4, 0.18, 0.18)))
    hp_bar.add_theme_stylebox_override("fill",
        _bar_style(Color(0.72, 0.26, 0.26), Color(0.72, 0.26, 0.26)))
    node.add_child(hp_bar)

    # золотой указатель: появляется, когда игрок рядом
    var pointer := Sprite2D.new()
    pointer.texture = _pointer_tex
    pointer.position = Vector2(0, -fh - 10)
    pointer.visible = false
    node.add_child(pointer)
    var ptw := create_tween().set_loops()
    ptw.tween_property(pointer, "position:y", -float(fh) - 14.0, 0.5) \
        .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    ptw.tween_property(pointer, "position:y", -float(fh) - 10.0, 0.5) \
        .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

    _entities.add_child(node)
    var npc := {"id": npc_id, "node": node, "sprite": spr, "pointer": pointer,
                "tile": npc_data["tile"], "zone": npc_data["zone"],
                "data": npc_data, "hp": npc_hp, "max_hp": npc_hp,
                "hp_bar": hp_bar, "body": body, "area": area,
                "name_label": name_label, "dead": false}
    _npcs.append(npc)
    return npc

# ------------------------------------------------------------- демон (шаг 8)

## Определение демона из WorldMap.NPCS (пустой словарь — не задан).
func _demon_def() -> Dictionary:
    for npc_data in WorldMap.NPCS:
        if bool(npc_data.get("demon", false)):
            return npc_data
    return {}

## Таинственный демон выходит из теней у края улицы: строго после первой
## жертвы (см. _on_npc_killed и проверку Game.demon_kill_count в _ready).
## При продолжении сессии (мир пересобран) встаёт на место молча.
func _spawn_demon() -> void:
    if _demon_spawned:
        return
    # шаг 13: демон, поверженный навсегда, не возвращается — даже если
    # убить нового жителя после его смерти в подземелье.
    if Game.demon_gone_forever():
        return
    var def := _demon_def()
    if def.is_empty():
        return
    _demon_spawned = true
    var npc := _spawn_npc(def)
    var node: Node2D = npc["node"]
    _spell_poof(node.position + Vector2(0, -46), Color(0.62, 0.4, 0.9))
    _show_hint("У самого края улицы из теней выступил Таинственный демон — втрое выше любого из жителей. Он доволен тем, что ты уже сделал.", 5.0)

## NPC убит: демон материализуется у края мира — но только когда жертвой
## стал житель (демон сам в подсчёте не участвует).
func _on_npc_killed(_npc_id: String) -> void:
    if not _demon_spawned and Game.demon_kill_count() > 0:
        # отложенно: спавн не должен срабатывать внутри сигнала об убийстве
        call_deferred("_spawn_demon")

## Шаг 12/13: демон впал в ярость (сигнал Game) — красная аура, вспышка,
## подсказка. Если сигнал пришёл при ПОГАШЕННОЙ ярости (возрождение героя
## или его смерть) — аура снимается, демон возвращается на своё место
## у края улицы и снова становится мирным.
func _on_demon_enraged() -> void:
    var demon := _demon_record()
    if demon.is_empty():
        return
    var node: Node2D = demon["node"]
    if Game.demon_enraged:
        (demon["sprite"] as AnimatedSprite2D).modulate = DEMON_RAGE_TINT
        _spell_poof(node.position + Vector2(0, -46), Color(0.85, 0.25, 0.2))
        _show_hint(DEMON_ENRAGE_HINT, 4.5)
    else:
        (demon["sprite"] as AnimatedSprite2D).modulate = Color.WHITE
        var def := _demon_def()
        if not def.is_empty():
            node.position = _feet_pos(def["tile"], 1, 1)
        demon["atk_cd"] = 0.0

## Запись живого демона в мире (пустой словарь — не спавнен или мёртв).
func _demon_record() -> Dictionary:
    for npc in _npcs:
        if String(npc["id"]) == "demon" and not bool(npc.get("dead", false)):
            return npc
    return {}

func _on_npc_input(_viewport: Node, event: InputEvent, _shape_idx: int, npc_id: String) -> void:
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        _click_dialog_at = Time.get_ticks_msec()   # шаг 11: этот клик — не удар
        npc_say(npc_id)

# ------------------------------------------------- удар по клику (шаг 11)

## Клик ЛКМ по экрану ходьбы (ловится в gui_input контейнера SubViewport).
## Клик по NPC или двери не бьёт — он открывает диалог/сообщение: точка
## клика проверяется по тем же прямоугольникам, что и их зоны кликов.
func _on_walk_click(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed \
            and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
        _try_click_strike((event as InputEventMouseButton).position)

## Удар по клику: ЛКМ по пустому месту экрана ходьбы бьёт в сторону взгляда.
func _try_click_strike(view_pos: Vector2) -> void:
    if _dialogue.visible or _inventory_ui.visible or _trade_ui.visible \
            or _player_dead:
        return
    if player == null:
        return
    if Time.get_ticks_msec() - _click_dialog_at <= 100:
        return   # этот же клик уже открыл диалог через физпикинг
    var world_pos := _walk_pos_to_world(view_pos)
    if not world_pos.is_finite() or _point_on_interactive(world_pos):
        return
    _strike()

## Точка клика в координатах мира (локальные координаты контейнера —
## это координаты SubViewport, камера живёт внутри него же).
func _walk_pos_to_world(view_pos: Vector2) -> Vector2:
    if _walk_view == null:
        return Vector2.INF
    return _walk_view.get_canvas_transform().affine_inverse() * view_pos

## Есть ли под точкой интерактивный объект: живой NPC или дверь данжа.
## NPC — через _npc_at_point (те же прямоугольники, что и у снаряда),
## дверь — по прямоугольнику зоны клика из _build_doors.
func _point_on_interactive(pos: Vector2) -> bool:
    if not _npc_at_point(pos).is_empty():
        return true
    for door in _doors:
        var half: Vector2 = door["half"]
        var dnode: Node2D = door["node"]
        if absf(pos.x - dnode.position.x) <= half.x \
                and absf(pos.y - dnode.position.y) <= half.y:
            return true
    return false

## Открыть диалог с NPC (публично: используется и тестами).
## Мёртвый NPC молчит (труп не разговаривает и не торгует).
## Шаг 8: если в этой сессии герой уже кого-то убил, у живых NPC старые
## диалоги пропадают — остаётся только реплика про убийство, и торговать
## с ними больше нельзя. Демон же убийцу приветствует и сам зовёт торговать.
func npc_say(npc_id: String) -> void:
    for npc in _npcs:
        if npc["id"] != npc_id:
            continue
        if bool(npc.get("dead", false)) or Game.is_npc_dead(npc_id):
            return
        var data: Dictionary = npc["data"]
        _dialogue_npc = data
        var lines: Array
        var goods: Array
        if bool(data.get("demon", false)):
            # демон: до ярости радуется убийству жителей и зовёт к своей лавке.
            # Шаг 13: разговор с демоном — «мы видели демона»: босс данжа 1
            # по этому флагу узнаёт героя.
            Game.mark_demon_seen()
            # Ассортимент динамический — товары павших торговцев, поэтому
            # для лавки кладём его прямо в словарь торговца (TradeUI
            # читает goods из данных торговца).
            # Шаг 12: в ярости лавки нет — только угрозы.
            _dialogue_npc = data.duplicate()
            if Game.demon_enraged:
                (_dialogue_npc as Dictionary)["role"] = "разбуженная ярость"
                (_dialogue_npc as Dictionary)["goods"] = []
                lines = DEMON_RAGE_LINES.duplicate()
                goods = []
            else:
                (_dialogue_npc as Dictionary)["goods"] = Game.demon_goods()
                lines = _demon_lines()
                goods = Game.demon_goods()
        else:
            lines = NPC_LINES.get(npc_id, ["..."])
            if not Game.dead_npcs.is_empty():
                # шаг 8: старые диалоги больше не появятся — только память
                # об убийстве; торговцы отказываются торговать с убийцей
                lines = [_murder_reaction(npc_id)]
                goods = []
            else:
                goods = data.get("goods", [])
        _dialogue.open({
            "name": data["name"],
            "role": data["role"],
            "portrait": data["portrait"],
            "lines": lines,
            "goods": goods,
        })
        (npc["sprite"] as AnimatedSprite2D).play("idle_down")
        return

## Реплики живого NPC про убитых героем: имена подставляются
## в винительном падеже (см. NPC_VICTIM_ACC).
func _murder_reaction(speaker_id: String) -> String:
    var victims: Array[String] = []
    for victim_id in Game.dead_npcs:
        victims.append(String(NPC_VICTIM_ACC.get(String(victim_id), String(victim_id))))
    var template: String = NPC_MURDER_REACTIONS.get(speaker_id, "Ты убил %s!")
    return template % ", ".join(victims)

## Реплики демона (шаг 8; шаг 9/12 — лавкрафтовский хоррор): рад убийству
## жителей, перечисляет жертв, хвастается лавкой из товаров павших и зовёт
## убивать ещё — каждая новая жертва дешевит его лавку ещё на 10%.
## (В ярости реплики другие — DEMON_RAGE_LINES, см. npc_say.)
func _demon_lines() -> Array:
    var lines: Array = []
    var victims: Array[String] = []
    for victim_id in Game.dead_npcs:
        var vid := String(victim_id)
        if vid != "demon":
            victims.append(String(NPC_VICTIM_ACC.get(vid, vid)))
    lines.append("Хе-хе-хе! Я чую это с края мира: смертный остыл — и это сделал ты. Пустота аплодирует стоя.")
    if not victims.is_empty():
        lines.append("Ты убил %s. Я всё видел отсюда: их тени уже переползли через ограду и ползут ко мне. Теперь они мои." % ", ".join(victims))
    if Game.demon_goods().is_empty():
        lines.append("Пока мне нечего тебе продать. Убей торговца — его лавка переедет ко мне. Вместе с ценами. Вместе с голосом.")
    else:
        lines.append("Товары павших торговцев теперь мои. И дешевле, чем у них были: скидка %d%%. Мёртвые не торгуются." % Game.demon_discount_pct())
    lines.append("Убей ещё жителя — и цены упадут ещё на десять процентов. Каждая новая тень делает мой товар щедрее.")
    return lines

## Кнопка «ТОРГОВАТЬ» в диалоге: закрываем реплики и открываем лавку.
func _on_trade_requested() -> void:
    _dialogue.close()
    if not _dialogue_npc.is_empty():
        _trade_ui.open(_dialogue_npc)

## Диалог закрылся: запоминаем время — ближайшие 250 мс мир не реагирует
## на E, чтобы то же нажатие не переоткрыло диалог (фикс мигания).
func _on_dialogue_closed() -> void:
    _dialogue_closed_at = Time.get_ticks_msec()

## Разрешено ли сейчас взаимодействие E (вне кулдауна после закрытия диалога).
func _interact_allowed() -> bool:
    return Time.get_ticks_msec() - _dialogue_closed_at > 250

# ---------------------------------------------------------------- двери данжей

## Явные двери данжей (шаг 9; шаг 13): каменные створки с фиолетовым зевом
## (props/door_dungeon.png) поверх тайлов D. Подписи убраны — двери говорят
## сами за себя. Дверь 1 открыта: ведёт в Подземелье замка; остальные
## заперты — клик или E рядом — диалог «Подземелье пока недоступно».
func _build_doors() -> void:
    var door_tex: Texture2D = load("res://assets/sprites/props/door_dungeon.png")
    for i in range(WorldMap.DOORS.size()):
        var door: Dictionary = WorldMap.DOORS[i]
        var tiles: Array = door["tiles"]
        var center := Vector2.ZERO
        for t in tiles:
            center += Vector2(t) * float(WorldMap.TILE_SIZE) + Vector2(8, 8)
        center /= float(tiles.size())
        var node := Node2D.new()
        node.name = "Door_%s" % door["id"]
        node.position = center
        # видимые створки: спрайт 32x16 ровно накрывает два тайла двери
        var spr := Sprite2D.new()
        spr.name = "Sprite"
        spr.texture = door_tex
        node.add_child(spr)
        # клик по двери — диалог: дверь 1 ведёт в данж, остальные молчат
        var area := Area2D.new()
        area.input_pickable = true
        area.collision_layer = 4
        area.collision_mask = 0
        var shape := CollisionShape2D.new()
        var rect := RectangleShape2D.new()
        rect.size = Vector2(tiles.size() * 16.0, 16.0)
        shape.shape = rect
        area.add_child(shape)
        area.input_event.connect(_on_door_input.bind(String(door["id"])))
        node.add_child(area)
        _world.add_child(node)
        _doors.append({"id": String(door["id"]), "area": area, "node": node,
            "half": Vector2(tiles.size() * 8.0, 8.0)})

## Клик по двери данжа.
func _on_door_input(_viewport: Node, event: InputEvent, _shape_idx: int,
        door_id: String) -> void:
    if event is InputEventMouseButton and event.pressed \
            and event.button_index == MOUSE_BUTTON_LEFT:
        _click_dialog_at = Time.get_ticks_msec()   # шаг 11: этот клик — не удар
        _open_door_dialog(door_id)

## Сообщение двери (шаг 13): дверь 1 открыта — ведёт в Подземелье замка;
## остальные заперты (подземелья 2-4 появятся позже).
func _open_door_dialog(door_id: String = "") -> void:
    if _dialogue.visible:
        return
    if door_id == "dungeon_1":
        _begin_dungeon_transition()
        return
    _dialogue.open({
        "name": DOOR_NAME,
        "role": DOOR_ROLE,
        "portrait": "res://assets/sprites/portraits/door.png",
        "lines": DOOR_LINES,
    })

## Шаг 13: вход в 1-е подземелье — «Подземелье замка». Фиксируем этаж и
## меняем сцену; сам данж генерирует этажи заново (см. dungeon.gd).
func _begin_dungeon_transition() -> void:
    if Game.dungeon_floor > 0:
        return   # уже переходим
    Game.dungeon_floor = 1
    Platform.gameplay_stop()
    get_tree().change_scene_to_file(DUNGEON_SCENE)

# ---------------------------------------------------------------- игрок

func _build_player() -> void:
    _apply_hero_textures()
    player = CharacterBody2D.new()
    player.name = "Player"
    player.motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
    player.collision_layer = 2
    player.collision_mask = 1
    player.position = Vector2(WorldMap.PLAYER_SPAWN) * float(WorldMap.TILE_SIZE) + Vector2(8, 8)
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
    _camera.limit_right = WorldMap.MAP_W * WorldMap.TILE_SIZE
    _camera.limit_bottom = WorldMap.MAP_H * WorldMap.TILE_SIZE
    _camera.position_smoothing_enabled = true
    _camera.position_smoothing_speed = 6.0
    player.add_child(_camera)
    _camera.make_current()

## Подставить лист анимаций выбранного героя (публично: используется тестами).
func _apply_hero_textures() -> void:
    var hero: Dictionary = Game.HEROES.get(Game.hero_id, Game.HEROES[Game.DEFAULT_HERO])
    _hero_sheet_tex = load(String(hero["sheet"]))
    if _player_sprite != null:
        _player_sprite.sprite_frames = _make_frames(_hero_sheet_tex)
        _player_sprite.play("idle_down")

func _physics_process(delta: float) -> void:
    if player == null:
        return
    var moving := false
    var dir := Vector2.ZERO
    var blocked := _dialogue.visible or _inventory_ui.visible \
        or _trade_ui.visible or _player_dead
    if not blocked:
        dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
        var joy_vec := _joystick_output()
        if joy_vec.length() > 0.15:
            dir = (dir + joy_vec).limit_length(1.0)
        moving = dir.length() > 0.05
        player.velocity = dir * SPEED
        player.move_and_slide()
        if not _edge_hint_shown and player.position.y > 43.0 * WorldMap.TILE_SIZE:
            _edge_hint_shown = true
            _show_hint(EDGE_HINT, 4.5)
    else:
        player.velocity = Vector2.ZERO
    # шаг 6: мана мага — кулдаун заклинания, реген, полёт снарядов
    if _spell_cd > 0.0:
        _spell_cd = maxf(0.0, _spell_cd - delta)
    if Game.is_mage() and Game.mana < Game.max_mana():
        _mana_regen_accum += delta
        if _mana_regen_accum >= 1.0:
            Game.regen_mana(int(Game.SPELL["regen_per_sec"]) * int(_mana_regen_accum))
            _mana_regen_accum = 0.0
    else:
        _mana_regen_accum = 0.0
    # шаг 7: кулдаун удара
    if _strike_cd > 0.0:
        _strike_cd = maxf(0.0, _strike_cd - delta)
    _update_bolts(delta)
    _update_walk_anim(delta, moving, dir)
    _update_pointers()
    # шаг 12: разъярённый демон охотится на героя
    _update_demon(delta)

## Шаг 12: ИИ разъярённого демона. Демон парит к герою (стены и ограда
## его держат — точки-проверки по тайлам), а вплотную бьёт когтями:
## урон Game.damage_hp(DEMON_DAMAGE) раз в DEMON_ATTACK_CD секунд.
## Атака продолжается и при открытых окнах — это бой, а не экскурсия.
func _update_demon(delta: float) -> void:
    if player == null or not Game.demon_enraged or Game.hp <= 0:
        return
    var demon := _demon_record()
    if demon.is_empty():
        return
    var node: Node2D = demon["node"]
    var spr: AnimatedSprite2D = demon["sprite"]
    var to := player.position - node.position
    demon["atk_cd"] = maxf(0.0, float(demon.get("atk_cd", 0.0)) - delta)
    if to.length() > DEMON_ATTACK_RANGE * 0.8:
        var dirv := to.normalized()
        var step := DEMON_SPEED * delta
        var nx := node.position + Vector2(dirv.x, 0.0) * step
        if not _tile_is_solid(nx):
            node.position.x = nx.x
        var ny := node.position + Vector2(0.0, dirv.y) * step
        if not _tile_is_solid(ny):
            node.position.y = ny.y
        if absf(dirv.x) >= absf(dirv.y):
            spr.play("walk_side")
            spr.flip_h = dirv.x < 0.0
        else:
            spr.play("walk_down" if dirv.y > 0.0 else "walk_up")
    else:
        spr.play("idle_down")
    if to.length() <= DEMON_ATTACK_RANGE and float(demon.get("atk_cd", 0.0)) <= 0.0:
        demon["atk_cd"] = DEMON_ATTACK_CD
        Game.damage_hp(DEMON_DAMAGE)
        _spawn_swing(player.position + Vector2(0, -10), Color(0.9, 0.3, 0.25))
        _spawn_damage_label(player.position + Vector2(0, -40), DEMON_DAMAGE)
        _spell_poof(player.position + Vector2(0, -14), Color(0.85, 0.3, 0.25))

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

func _update_pointers() -> void:
    if player == null:
        return
    for npc in _npcs:
        var node: Node2D = npc["node"]
        var pointer: Sprite2D = npc["pointer"]
        var near := player.position.distance_to(node.position) < 30.0 \
            and not _dialogue.visible and not _inventory_ui.visible \
            and not _trade_ui.visible \
            and not bool(npc.get("dead", false))   # над трупом указателя нет
        pointer.visible = near

func _unhandled_input(event: InputEvent) -> void:
    if _player_dead:
        return   # шаг 12: на экране смерти мир не слушает удары и диалоги
    if event.is_action_pressed("toggle_inventory"):
        if _trade_ui.visible:
            return
        if _inventory_ui.visible:
            _inventory_ui.close()
        elif not _dialogue.visible:
            _inventory_ui.open()
        return
    if event.is_action_pressed("attack") and not _dialogue.visible \
            and not _inventory_ui.visible and not _trade_ui.visible:
        # шаг 11: ЛКМ над экраном ходьбы уже обработана в _on_walk_click
        # (в консоли ЛКМ забирают джойстик и кнопки; сюда долетают редкие
        # незанятые клики — бьём и по ним)
        if event is InputEventMouseButton and _walk_holder != null \
                and (_walk_holder.get_global_rect() as Rect2) \
                    .has_point((event as InputEventMouseButton).position):
            return
        _strike()
        return
    if event.is_action_pressed("cast_spell") and not _dialogue.visible \
            and not _inventory_ui.visible and not _trade_ui.visible:
        _cast_spell()
        return
    if event.is_action_pressed("interact") and not _dialogue.visible \
            and not _inventory_ui.visible and not _trade_ui.visible \
            and player != null and _interact_allowed():
        # шаг 11: диалог на E (F тоже работает — обе клавиши в действии
        # "interact"); ближайший живой NPC в радиусе 32 px
        var nearest: Dictionary = {}
        var best := 32.0
        for npc in _npcs:
            if bool(npc.get("dead", false)):
                continue   # с трупом не поговоришь
            var d: float = player.position.distance_to((npc["node"] as Node2D).position)
            if d < best:
                best = d
                nearest = npc
        if not nearest.is_empty():
            npc_say(String(nearest["id"]))
        else:
            # шаг 9/13: рядом с дверью данжа E тоже работает — дверь 1
            # ведёт в подземелье, остальные открывают сообщение о запертости
            var door: Dictionary = _nearest_door()
            if not door.is_empty():
                _open_door_dialog(String(door["id"]))

## Ближайшая дверь данжа в радиусе DOOR_INTERACT_RANGE (шаг 9).
func _nearest_door() -> Dictionary:
    if player == null:
        return {}
    var best: Dictionary = {}
    var best_d := DOOR_INTERACT_RANGE
    for door in _doors:
        var d: float = player.position.distance_to((door["node"] as Node2D).position)
        if d < best_d:
            best_d = d
            best = door
    return best

# ---------------------------------------------------------------- магия (шаг 6)

## Каст заклинания: кнопка МАГИЯ или клавиша Q. Только у мага.
## Шаг 12: оружие в руках определяет, что вылетит:
## магическое оружие — залп этого оружия (веер из spell_info["count"]
## снарядов с цветом и размером оружия), обычная сталь или пустые руки —
## классическая «Магическая стрела». Не-магу — отказ по классу.
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

## Направление взгляда героя — вектор полёта стрелы.
func _facing_vector() -> Vector2:
    match _facing:
        "up":
            return Vector2(0, -1)
        "side":
            return Vector2(-1, 0) if _player_sprite.flip_h else Vector2(1, 0)
        _:
            return Vector2(0, 1)

## Создать снаряд в точке героя: летит по dir, наносит урон живому NPC
## на пути (шаг 9), гаснет у стен или по дистанции. info — параметры
## заклинания (Game.spell_info): урон, скорость, дистанция, цвет и размер;
## пустой/отсутствующий — классическая «Магическая стрела» (шаг 12).
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
    bolt.z_index = 10
    _world.add_child(bolt)
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
        # шаг 9: стрела бьёт первого живого NPC, в чьё тело она попала
        var target := _npc_at_point(node.position)
        if not target.is_empty():
            _spell_poof(node.position, b.get("color", Color(0.55, 0.85, 0.95)))
            node.queue_free()
            _bolts.remove_at(i)
            _hit_npc(target, int(b["damage"]))
            continue
        var faded := float(b["left"]) <= 0.0
        if faded or _tile_is_solid(node.position):
            _spell_poof(node.position, b.get("color", Color(0.55, 0.85, 0.95)))
            node.queue_free()
            _bolts.remove_at(i)

## Живой NPC в точке (шаг 9): прямоугольник тела с учётом масштаба
## (демон втрое крупнее — его зона попадания тоже втрое больше).
func _npc_at_point(pos: Vector2) -> Dictionary:
    for npc in _npcs:
        if bool(npc.get("dead", false)):
            continue   # труп стрела не бьёт
        var node: Node2D = npc["node"]
        var s := maxi(1, int((npc["data"] as Dictionary).get("scale", 1)))
        if pos.x < node.position.x - 10.0 * s or pos.x > node.position.x + 10.0 * s:
            continue
        if pos.y < node.position.y - float(CHAR_H * s) - 6.0 \
                or pos.y > node.position.y + 4.0:
            continue
        return npc
    return {}

## Символ тайла под точкой (за границей карты — «твёрдый» космос).
func _tile_is_solid(pos: Vector2) -> bool:
    var tx := int(floor(pos.x / float(WorldMap.TILE_SIZE)))
    var ty := int(floor(pos.y / float(WorldMap.TILE_SIZE)))
    if tx < 0 or ty < 0 or tx >= WorldMap.MAP_W or ty >= WorldMap.MAP_H:
        return true
    return WorldMap.SOLID_TILES.contains(WorldMap.MAP[ty][tx])

## Вспышка-частицы при исчезновении стрелы (и при смерти NPC — серым).
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
    poof.z_index = 10
    _world.add_child(poof)
    get_tree().create_timer(0.6).timeout.connect(func() -> void:
        if is_instance_valid(poof):
            poof.queue_free())

# ---------------------------------------------------------------- удары (шаг 7)

## Удар (ЛКМ, кнопка УДАР или клик по пустому месту экрана ходьбы):
## есть оружие в руках — бьём оружием (урон из ItemDB с классовыми
## множителями и магическим эффектом — см. Game), нет — рукой
## (кулаки, у всех героев, маг тоже). Цель — живой NPC в направлении
## взгляда на дистанции STRIKE_RANGE.
func _strike() -> void:
    if player == null or _strike_cd > 0.0 or _player_dead:
        return
    _strike_cd = STRIKE_COOLDOWN
    var dir := _facing_vector()
    var target := _living_npc_in_front(dir)
    var weapon_color := Game.strike_swing_color()
    if target.is_empty():
        # промах: просто взмах в сторону взгляда
        _spawn_swing(player.position + dir * 14.0 + Vector2(0, -12), weapon_color)
        return
    var npc_node: Node2D = target["node"]
    _spawn_swing((player.position + npc_node.position) * 0.5 + Vector2(0, -12), weapon_color)
    _hit_npc(target, Game.strike_damage())
    # шаг 12: не-маг бьёт магическим оружием — в точке цели синеет вспышка
    # «магического эффекта» (бонус урона уже учтён в Game.strike_damage)
    if Game.strike_is_magic_surge():
        _spell_poof(npc_node.position + Vector2(0, -16), weapon_color)

## Нанести урон NPC (шаг 9, общее для удара ЛКМ и магии):
## всплывающее число, вспышка боли, полоска хп; при нуле — NPC умирает.
## Шаг 12: удар по живому демону — регистрируется в Game (register_demon_hit);
## после третьего удара демон взрывается яростью (см. _on_demon_enraged).
func _hit_npc(npc: Dictionary, damage: int) -> void:
    var npc_node: Node2D = npc["node"]
    var s := maxi(1, int((npc["data"] as Dictionary).get("scale", 1)))
    npc["hp"] = maxi(0, int(npc["hp"]) - damage)
    _spawn_damage_label(npc_node.position + Vector2(0, -float(CHAR_H * s) - 2), damage)
    _flash_npc(npc)
    _show_npc_hp_bar(npc)
    if int(npc["hp"]) <= 0:
        _kill_npc(npc)
    elif String(npc["id"]) == "demon":
        var count := Game.register_demon_hit()
        if not Game.demon_enraged:
            var idx := count - 1
            if idx >= 0 and idx < DEMON_HIT_HINTS.size():
                _show_hint(String(DEMON_HIT_HINTS[idx]), 2.2)

## Ближайший живой NPC перед героем (в дуге взгляда).
func _living_npc_in_front(dir: Vector2) -> Dictionary:
    var best: Dictionary = {}
    var best_d := STRIKE_RANGE
    for npc in _npcs:
        if bool(npc.get("dead", false)):
            continue   # труп не бьётся
        var node: Node2D = npc["node"]
        var to := node.position - player.position
        var dist := to.length()
        if dist > best_d:
            continue
        if dist > 1.0 and dir.dot(to.normalized()) < 0.2:
            continue   # за спиной
        best_d = dist
        best = npc
    return best

## Взмах: россыпь искр в точке удара (золотые — оружие, серые — кулаки).
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
    swing.z_index = 10
    _world.add_child(swing)
    get_tree().create_timer(0.5).timeout.connect(func() -> void:
        if is_instance_valid(swing):
            swing.queue_free())

## Всплывающее число урона над NPC: поднимается и тает.
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
    label.z_index = 12
    _world.add_child(label)
    var tw := create_tween()
    tw.set_parallel(true)
    tw.tween_property(label, "position:y", label.position.y - 16.0, 0.6) \
        .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    tw.tween_property(label, "modulate:a", 0.0, 0.6).set_delay(0.15)
    tw.chain().tween_callback(label.queue_free)

## Короткая вспышка боли на спрайте NPC (твин хранится, чтобы при смерти
## его можно было погасить и труп остался серым). Разъярённый демон
## после вспышки возвращается не к белому, а к своей красной ауре (шаг 12).
func _flash_npc(npc: Dictionary) -> void:
    var spr: AnimatedSprite2D = npc["sprite"]
    var restore := Color.WHITE
    if String(npc["id"]) == "demon" and Game.demon_enraged:
        restore = DEMON_RAGE_TINT
    var old: Tween = npc.get("flash_tween")
    if old != null and old.is_valid():
        old.kill()
    spr.modulate = Color(1.0, 0.35, 0.35)
    var tw := create_tween()
    tw.tween_property(spr, "modulate", restore, 0.25)
    npc["flash_tween"] = tw

## Показать/обновить полоску хп NPC (после первого удара остаётся видимой).
func _show_npc_hp_bar(npc: Dictionary) -> void:
    var bar: ProgressBar = npc["hp_bar"]
    bar.max_value = int(npc["max_hp"])
    bar.value = int(npc["hp"])
    bar.visible = true

## NPC убит: Game запоминает на всю сессию, труп падает и сероет,
## сквозь него можно пройти, разговор и торговля больше недоступны.
## Остальные NPC узнают об этом через Game.dead_npcs (см. npc_say).
## Шаг 13: демон умирает по-настоящему — Game.defeat_demon_permanently():
## убитые NPC оживают и забывают убийства, демон больше не возвращается
## (ни у края мира, ни в подземелье), состояние пишется в сейв v6.
func _kill_npc(npc: Dictionary) -> void:
    var npc_id := String(npc["id"])
    npc["dead"] = true
    Game.kill_npc(npc_id)
    var npc_name := String((npc["data"] as Dictionary).get("name", npc_id))
    var spr: AnimatedSprite2D = npc["sprite"]
    var flash: Tween = npc.get("flash_tween")
    if flash != null and flash.is_valid():
        flash.kill()   # вспышка боли не должна перекрасить труп обратно
    spr.stop()
    spr.rotation = PI / 2.0   # падает на бок
    spr.modulate = Color(0.5, 0.47, 0.55)
    var bar: ProgressBar = npc["hp_bar"]
    bar.visible = false
    var pointer: Sprite2D = npc["pointer"]
    pointer.visible = false
    (npc["name_label"] as Label).add_theme_color_override("font_color", Color(0.52, 0.52, 0.58))
    # через труп можно ходить, кликать по нему больше нельзя
    var body: StaticBody2D = npc["body"]
    (body.get_child(0) as CollisionShape2D).set_deferred("disabled", true)
    var area: Area2D = npc["area"]
    area.set_deferred("monitorable", false)
    area.set_deferred("monitoring", false)
    area.input_pickable = false
    _spell_poof((npc["node"] as Node2D).position + Vector2(0, -12),
        Color(0.6, 0.6, 0.66))
    if npc_id == "demon":
        Game.defeat_demon_permanently()
        _show_hint(DEMON_DEFEATED_HINT, 5.0)
    else:
        _show_hint("%s больше нет. Остальные жители это запомнят... А кое-кто у края улицы улыбается." % npc_name, 4.0)

## Шаг 13: ожившие жертвы демона (сигнал Game.npcs_revived): трупы встают,
## хп восстанавливается, разговоры и торговля снова доступны.
## Труп самого демона остаётся трупом — он повержен навсегда.
func _revive_npcs_in_world() -> void:
    for npc in _npcs:
        if String(npc["id"]) == "demon" or not bool(npc.get("dead", false)):
            continue
        npc["dead"] = false
        npc["hp"] = int(npc["max_hp"])
        var spr: AnimatedSprite2D = npc["sprite"]
        spr.rotation = 0.0
        spr.modulate = Color.WHITE
        spr.play("idle_down")
        (npc["hp_bar"] as ProgressBar).visible = false
        (npc["name_label"] as Label).add_theme_color_override("font_color", COLOR_GOLD)
        var body: StaticBody2D = npc["body"]
        (body.get_child(0) as CollisionShape2D).set_deferred("disabled", false)
        var area: Area2D = npc["area"]
        area.set_deferred("monitorable", true)
        area.set_deferred("monitoring", true)
        area.input_pickable = true

# ---------------------------------------------------------------- джойстик

func _build_joystick() -> void:
    # шаг 8 (фикс): VirtualJoystick — скриптовый класс, ClassDB его не видит
    # (class_exists всегда false), поэтому джойстик никогда не спавнился.
    # Загружаем скрипт напрямую и создаём инстанс через GDScript.new().
    var script: GDScript = load("res://scripts/ui/virtual_joystick.gd") as GDScript
    if script == null or not script.can_instantiate():
        push_warning("VirtualJoystick недоступен: только клавиатура")
        return
    var joystick: Control = script.new() as Control
    if joystick == null:
        return
    # шаг 10/11: джойстик — часть нижней консоли UI, вне экрана ходьбы
    if _hud_bar == null:
        return
    joystick.size = Vector2(100, 100)
    joystick.position = BAR_JOY_POS
    _hud_bar.add_child(joystick)
    _joystick = joystick

# ---------------------------------------------------------------- смерть героя (шаг 12)

## Экран смерти: затемнение поверх всего («ТЫ ПАЛ») с кнопкой пробуждения.
## Штрафов за смерть нет (ЗАГЛУШКА): герой очинается в замке с полными
## хп/маной, демон остаётся в ярости и продолжает охоту.
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

## Хп героя упало до нуля — показать экран смерти (один раз).
func _on_player_hp_changed(hp: int, _max_hp: int) -> void:
    if hp <= 0 and not _player_dead:
        _player_dead = true
        if _death_layer != null:
            _death_layer.visible = true

## Пробуждение: полные хп/мана, герой в замке. Шаг 13: ярость демона ГАСНЕТ
## (Game.reset_demon_rage) — демон снова мирен и возвращается к краю улицы.
func _respawn_player() -> void:
    _player_dead = false
    if _death_layer != null:
        _death_layer.visible = false
    Game.reset_demon_rage()
    Game.heal_hp(Game.max_hp() * 2)   # излишек срезается до максимума
    if Game.is_mage():
        Game.restore_mana(Game.max_mana() * 2)
    player.position = Vector2(WorldMap.PLAYER_SPAWN) \
        * float(WorldMap.TILE_SIZE) + Vector2(8, 8)
    if _camera != null:
        _camera.reset_smoothing()
    var demon := _demon_record()
    if not demon.is_empty():
        demon["atk_cd"] = 2.0
    _show_hint(RESPAWN_HINT, 4.0)

# ---------------------------------------------------------------- HUD

func _build_hud() -> void:
    var layer := CanvasLayer.new()
    layer.name = "HUD"
    layer.layer = 20
    add_child(layer)

    # --- шаг 10: нижняя консоль UI — непрозрачная полоса вне экрана ходьбы.
    # Панель героя и кнопки кладём прямо в слой HUD (абсолютные координаты
    # в полосе консоли), джойстик — внутрь консоли (см. _build_joystick).
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
    var bar_top := 640.0 - UI_BAR_H   # верхняя граница консоли на экране

    # мини-панель героя: портрет + имя + золото (в консоли, шаг 10)
    var hero_panel := PanelContainer.new()
    hero_panel.position = Vector2(BAR_HERO_POS.x, bar_top + BAR_HERO_POS.y)
    var hero_style := UiStyle.flat_style(Color(0.11, 0.12, 0.19), Color(0.5, 0.42, 0.16))
    hero_style.content_margin_left = 6
    hero_style.content_margin_right = 10
    hero_style.content_margin_top = 4
    hero_style.content_margin_bottom = 4
    hero_panel.add_theme_stylebox_override("panel", hero_style)
    layer.add_child(hero_panel)
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

    # шаг 7: чем герой бьёт (кулаки или оружие из сумки); шаг 10: автоперенос —
    # длинное название оружия не распирает панель в узкой консоли
    _hud_weapon = Label.new()
    _hud_weapon.add_theme_font_size_override("font_size", 9)
    _hud_weapon.add_theme_color_override("font_color", Color(0.62, 0.66, 0.74))
    _hud_weapon.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    _hud_weapon.text = _weapon_text()
    hero_box.add_child(_hud_weapon)
    _cb_equipped = func(_weapon_id: String) -> void:
        if is_instance_valid(_hud_weapon):
            _hud_weapon.text = _weapon_text()
    Game.equipped_changed.connect(_cb_equipped)

    # шаг 6: полоса здоровья героя (видна всем героям)
    _hud_hp = ProgressBar.new()
    _hud_hp.custom_minimum_size = Vector2(74, 8)
    _hud_hp.min_value = 0
    _hud_hp.max_value = Game.max_hp()
    _hud_hp.value = Game.hp
    _hud_hp.show_percentage = false
    _hud_hp.add_theme_stylebox_override("background", _bar_style(Color(0.09, 0.08, 0.1), Color(0.45, 0.2, 0.2)))
    _hud_hp.add_theme_stylebox_override("fill", _bar_style(Color(0.72, 0.26, 0.26), Color(0.72, 0.26, 0.26)))
    hero_box.add_child(_hud_hp)
    _cb_hp = func(hp: int, max_hp: int) -> void:
        if is_instance_valid(_hud_hp):
            _hud_hp.max_value = max_hp
            _hud_hp.value = hp
    Game.hp_changed.connect(_cb_hp)

    # шаг 6: полоса маны — только у мага (новый показатель при выборе мага)
    if Game.is_mage():
        _hud_mana = ProgressBar.new()
        _hud_mana.custom_minimum_size = Vector2(74, 8)
        _hud_mana.min_value = 0
        _hud_mana.max_value = Game.max_mana()
        _hud_mana.value = Game.mana
        _hud_mana.show_percentage = false
        _hud_mana.add_theme_stylebox_override("background", _bar_style(Color(0.08, 0.09, 0.13), Color(0.2, 0.3, 0.45)))
        _hud_mana.add_theme_stylebox_override("fill", _bar_style(Color(0.3, 0.6, 0.85), Color(0.3, 0.6, 0.85)))
        hero_box.add_child(_hud_mana)
        _cb_mana = func(mana: int, max_mana: int) -> void:
            if is_instance_valid(_hud_mana):
                _hud_mana.max_value = max_mana
                _hud_mana.value = mana
        Game.mana_changed.connect(_cb_mana)

    # --- шаг 10/11: кнопки действий — столбик в правой части консоли,
    # вертикально центрированы. Порядок прежний: МЕНЮ, СУМКА, (МАГИЯ), УДАР.
    # Шаг 11: подписи без клавиш (клавиши — в подсказке у края экрана),
    # размер 64x22 — консоль стала ниже, экран ходьбы больше.
    var open_bag := func() -> void:
        if not _dialogue.visible:
            _inventory_ui.open()
    var actions: Array = [
        {"text": "МЕНЮ", "font": 10, "cb": _on_menu_pressed},
        {"text": "СУМКА", "font": 10, "cb": open_bag},
    ]
    if Game.is_mage():
        actions.insert(2, {"text": "МАГИЯ", "font": 10, "cb": _cast_spell})
    # шаг 7: кнопка удара — у всех героев (ЛКМ): рукой без оружия, оружием с ним
    actions.append({"text": "УДАР", "font": 10, "cb": _strike})
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
        layer.add_child(btn)
        if String(spec["text"]) == "МАГИЯ":
            _spell_button = btn
        elif String(spec["text"]) == "УДАР":
            _attack_button = btn

    _hud_hint = Label.new()
    # шаг 10: подсказки — у верхнего края экрана ходьбы (временные, гаснут:
    # внизу теперь консоль UI, перекрывать мир они больше не должны)
    _hud_hint.set_anchors_preset(Control.PRESET_TOP_WIDE)
    _hud_hint.offset_top = 4.0
    _hud_hint.offset_bottom = 42.0
    _hud_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    _hud_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    _hud_hint.add_theme_font_size_override("font_size", 12)
    _hud_hint.add_theme_color_override("font_color", Color(0.85, 0.88, 0.94))
    _hud_hint.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
    _hud_hint.add_theme_constant_override("shadow_offset_y", 1)
    var controls_hint := "WASD/джойстик — идти, E — говорить, ЛКМ — удар, I — сумка"
    if Game.is_mage():
        controls_hint += ", Q — магия"
    _hud_hint.text = controls_hint
    layer.add_child(_hud_hint)
    _show_hint(_hud_hint.text, 5.0)

## Строка «В руках: …» в HUD — что у героя в руках и сколько урона.
func _weapon_text() -> String:
    return "В руках: %s · %d ур." % [Game.strike_title(), Game.strike_damage()]

func _show_hint(text: String, seconds: float) -> void:
    # фикс: предыдущий твин подсказки гасим, чтобы два твина не мигали в борьбе
    if _hint_tween != null and _hint_tween.is_valid():
        _hint_tween.kill()
    _hud_hint.text = text
    _hud_hint.modulate.a = 1.0
    _hint_tween = create_tween()
    _hint_tween.tween_interval(seconds)
    _hint_tween.tween_property(_hud_hint, "modulate:a", 0.0, 0.6)

## Стиль полосы ХП/маны: рамка 1 px, без внутренних отступов.
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

## Кнопка действия в нижней консоли (шаг 11): те же цвета, но компактные
## отступы — иначе Button не даст себе стать ниже 29 px и столбик 64x22
## не влезет в консоль высотой 112 px.
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
    Platform.gameplay_stop()
    get_tree().change_scene_to_file(MAIN_SCENE)

````

#### `scenes/world/world.tscn`

````ini
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scenes/world/world.gd" id="1_world"]

[node name="World" type="Node2D"]
script = ExtResource("1_world")

````

### Скрипты

#### `scripts/autoload/game_state.gd`

````gdscript
## Автозагрузка Game: герой, золото, здоровье/мана, инвентарь (добыча),
## прогресс по данжам и заклинания мага.
## Прогресс хранится в 3 слотах сейва; настройки и ежедневный бонус —
## глобально в meta.json (общие для всех слотов).
## Все изменения дергают сигналы и просят Saves сохранить состояние.
## Торговля (шаг 5): у каждого героя своё стартовое золото,
## buy_item()/sell_item() — покупка у NPC и продажа своих вещей.
## Шаг 6: новый герой Маг (хп 30, мана 70), использование еды/питья/зелий
## и «Магическая стрела» — заклинание за ману (визуал в world.gd).
## Шаг 7 (боевая система): оружие в руках (equipped_weapon_id) — удар E
## идёт оружием, без него — рукой (кулаки, у всех героев, маг тоже);
## мана-зелья лечат ману только магу; список убитых NPC (dead_npcs)
## живёт только в текущей сессии: в сейв не пишется, при новой игре
## и загрузке слота обнуляется — мёртвые NPC не воскресают в этой сессии,
## а остальные NPC помнят убийство (реплики и отказ торговать — в world.gd).
## Шаг 12 (боевая система: экипировка и ярость демона):
## - второй слот экипировки — броня/одеяние (equipped_armor_id): броня даёт
##   +hp_bonus к максимуму ХП (носят все), одеяния — +мана и немного ХП
##   (только маг); max_hp()/max_mana() считаются с бонусом экипировки;
## - классовые множители удара обычным оружием: маг х0.5, варвар х2,
##   остальные х1; магическое оружие магу — полная сила и залп на Q
##   (spell_info()), воину/бомжу — обычный урон + магический эффект
##   (+25% урона, strike_is_magic_surge), варвару — отказ (оружие отвергает);
## - демон: после DEMON_RAGE_HITS ударов (3) впадает в ярость
##   (demon_hits/demon_enraged, состояние сессии, в сейв не пишется);
## - сейв v5: добавлен equipped_armor_id (старые сейвы мигрируют: без брони).
## Шаг 13 (данж 1 и вечная смерть демона):
## - ярость демона гаснет при возрождении героя (reset_demon_rage): после
##   «ОЧНУТЬСЯ В ЗАМКЕ» демон снова мирный, счёт ударов обнулён;
## - demon_seen — «мы видели демона» (диалог с ним у края мира, сессия);
## - demon_defeated — демон убит навсегда (на карте или как босс данжа 1):
##   сейв v6, все убитые NPC оживают и забывают убийства, демон больше
##   не возвращается даже после новых убийств (revive_all_npcs);
## - dungeon_floor — текущий этаж данжа (0 = не в данже, только сессия).
extends Node

signal gold_changed(new_gold: int)
signal inventory_changed()
signal hp_changed(hp: int, max_hp: int)
signal mana_changed(mana: int, max_mana: int)
signal equipped_changed(weapon_id: String)
signal armor_changed(armor_id: String)
signal npc_killed(npc_id: String)
signal demon_enraged_changed
signal npcs_revived

const START_GOLD := 0
const SLOT_COUNT := 3
## ЗАГЛУШКА характеристик: точные числа неиграбельных героев уточняются позже.
## sheet — лист 24x32 (6 рядов анимаций), portrait — крупный портрет для диалогов,
## start_gold — стартовый кошелёк героя при новой игре (шаг 5),
## hp/mana — стартовое здоровье и мана (шаг 6; мана есть только у мага).
const HEROES: Dictionary = {
    "warrior": {
        "title": "Воин",
        "flavor": "Сталь, дисциплина и верный меч.",
        "sheet": "res://assets/sprites/chars/warrior.png",
        "portrait": "res://assets/sprites/portraits/warrior.png",
        "start_gold": 100,
        "hp": 50, "mana": 0,
    },
    "barbarian": {
        "title": "Варвар",
        "flavor": "Бьёт первым. Вопросов не задаёт.",
        "sheet": "res://assets/sprites/chars/barbarian.png",
        "portrait": "res://assets/sprites/portraits/barbarian.png",
        "start_gold": 50,
        "hp": 60, "mana": 0,
    },
    "bum": {
        "title": "Бомж",
        "flavor": "Живёт у стен замка. Терять нечего.",
        "sheet": "res://assets/sprites/chars/bum.png",
        "portrait": "res://assets/sprites/portraits/bum.png",
        "start_gold": 1,
        "hp": 20, "mana": 0,
    },
    "mage": {
        "title": "Маг",
        "flavor": "Хрупкий, но повелевает маной. Стреляет стрелами света.",
        "sheet": "res://assets/sprites/chars/mage.png",
        "portrait": "res://assets/sprites/portraits/mage.png",
        "start_gold": 60,   # ЗАГЛУШКА: стартовое золото мага не задано автором
        "hp": 30, "mana": 70,
    },
}
const DEFAULT_HERO := "warrior"

## Урон удара рукой (шаг 7, ЗАГЛУШКА — уточняется с автором).
## Удар без оружия в руках доступен всем героям, включая мага.
const HAND_DAMAGE := 5
## Название удара без оружия (для HUD, сумки и подсказок).
const HAND_TITLE := "Кулаки"

## Шаг 12: множители урона обычного (не магического) оружия по классам.
## Маг клинками машет плохо (х0.5), варвар — сильнее всех (х2; у мага
## относительно варвара выходит в 4 раза слабее). Остальные — х1.
const CLASS_STRIKE_MULT := {
    "mage": 0.5,
    "barbarian": 2.0,
}
## Шаг 12: магический эффект магического оружия у не-магов (воин и бомж):
## удар наносит обычный урон + 25% сверх (вспышка цвета оружия).
## Варвару магическое оружие вообще не даётся, а маг бьёт им в полную силу.
const MAGIC_SURGE_FACTOR := 0.25

## Заклинание мага (шаг 6): «Магическая стрела».
## cost — цена в мане, damage — урон в будущих боях, regen — реген маны в секунду.
const SPELL := {
    "id": "magic_bolt",
    "title": "Магическая стрела",
    "cost": 12,
    "damage": 15,
    "speed": 240.0,
    "range_px": 150.0,
    "cooldown": 0.35,
    "regen_per_sec": 2,
}

var gold: int = START_GOLD
var inventory: Array = []          # [{"quality": "...", "title": "..."} или {"item_id": "..."}]
var dungeons_cleared: Array = []   # id пройденных данжей: ["forest_cave", ...]
var hero_id: String = DEFAULT_HERO
var hp: int = 0                    # текущее здоровье героя (шаг 6)
var mana: int = 0                  # текущая мана героя (шаг 6, у не-магов 0)
## Оружие в руках (шаг 7): item_id из ItemDB или "" — удары идут кулаками.
var equipped_weapon_id: String = ""
## Броня/одеяние на теле (шаг 12): item_id из ItemDB (type "armor" или "robe")
## или "" — ничего не надето. Даёт +ХП (броня) и +мана/+ХП (одеяния мага).
var equipped_armor_id: String = ""
## Убитые NPC (шаг 7): только текущая сессия — в сейв не пишется.
## Остальные NPC помнят убийство (реплики и отказ торговать — в world.gd).
var dead_npcs: Array[String] = []
## Ярость демона (шаг 12, состояние сессии — в сейв не пишется):
## сколько раз герой ударил демона и впал ли он в ярость после 3-го удара.
var demon_hits: int = 0
var demon_enraged: bool = false
## Сколько ударов демон терпит, прежде чем броситься драться (шаг 12).
const DEMON_RAGE_HITS := 3
## Шаг 13: видели ли мы демона (диалог с ним у края мира) — босс данжа 1
## по этому флагу узнаёт героя. Только сессия, в сейв не пишется.
var demon_seen: bool = false
## Шаг 13: демон убит НАВСЕГДА (на карте или как босс данжа 1). Пишется
## в сейв v6: убитые NPC оживают и забывают убийства, демон больше
## не возвращается даже после новых убийств жителей.
var demon_defeated: bool = false
## Шаг 13: текущий этаж данжа 1 (1..10), 0 — герой не в подземелье.
## Только сессия: в сейв не пишется, при выходе/смерти обнуляется.
var dungeon_floor: int = 0
## Текущий слот сейва: 0 — игра не идёт (просто смотрим меню).
var current_slot: int = 0
## Глобальные настройки игрока (хранятся в meta.json).
var settings := {"sound": true, "music": true}
## Глобальная meta: последний слот, дата бонуса, отложенные награды бонуса.
var meta := {"last_slot": 0, "last_bonus_date": "", "pending_gold": 0, "pending_items": []}

func _ready() -> void:
    randomize()
    meta = Platform.load_meta()
    var saved_settings: Dictionary = meta.get("settings", {})
    settings["sound"] = bool(saved_settings.get("sound", true))
    settings["music"] = bool(saved_settings.get("music", true))

## Записать глобальную meta на диск.
func save_meta() -> void:
    meta["settings"] = settings.duplicate()
    Platform.save_meta(meta)

func hero_title() -> String:
    return String(HEROES.get(hero_id, {}).get("title", hero_id))

## Стартовый кошелёк героя при новой игре (Воин 100, Варвар 50, Бомж 1, Маг 60).
func hero_start_gold(hero: String) -> int:
    return int(HEROES.get(hero, {}).get("start_gold", START_GOLD))

## Максимум здоровья/маны героя (Маг: 30 хп и 70 маны — задал автор).
## Шаг 12: максимум растёт от экипировки — броня даёт +hp_bonus,
## одеяния/плащ дают +mana_bonus (и немного +hp_bonus).
func hero_max_hp(hero: String) -> int:
    return int(HEROES.get(hero, {}).get("hp", 1))

func hero_max_mana(hero: String) -> int:
    return int(HEROES.get(hero, {}).get("mana", 0))

func max_hp() -> int:
    return hero_max_hp(hero_id) + ItemDB.hp_bonus(equipped_armor_id)

func max_mana() -> int:
    return hero_max_mana(hero_id) + ItemDB.mana_bonus(equipped_armor_id)

## Является ли текущий герой магом по природе (у него врождённая мана
## и заклинания). Экипировка потолок маны растит, но магом не делает.
func is_mage() -> bool:
    return hero_max_mana(hero_id) > 0

func add_gold(amount: int) -> void:
    gold = maxi(0, gold + amount)
    gold_changed.emit(gold)
    Saves.request_save()

func spend_gold(amount: int) -> bool:
    if amount > gold:
        return false
    gold -= amount
    gold_changed.emit(gold)
    Saves.request_save()
    return true

# ------------------------------------------------------------- хп и мана (шаг 6)

## Выпить/съесть предмет: лечит хп и/или ману, предмет исчезает из сумки.
## Зелья маны (шаг 7) годятся только магу; остальным героям отказ —
## зелье не тратится (result["blocked"] == "not_mage").
## Возвращает {"ok", "healed", "restored", "full", "blocked"}.
func use_consumable(index: int) -> Dictionary:
    var result := {"ok": false, "healed": 0, "restored": 0, "full": false, "blocked": ""}
    if index < 0 or index >= inventory.size():
        return result
    var item: Dictionary = inventory[index]
    var item_id := String(item.get("item_id", ""))
    var def := ItemDB.get_item(item_id)
    if def.is_empty() or not (String(def.get("type", "")) in ItemDB.USABLE_TYPES):
        return result
    var heal_amount := int(def.get("heal", 0))
    var mana_amount := int(def.get("mana", 0))
    if mana_amount > 0 and not is_mage():
        result["blocked"] = "not_mage"
        return result
    var hp_needed := heal_amount > 0 and hp < max_hp()
    var mana_needed := mana_amount > 0 and mana < max_mana()
    if not hp_needed and not mana_needed:
        result["full"] = true
        return result
    if hp_needed:
        result["healed"] = heal_hp(heal_amount)
    if mana_needed:
        result["restored"] = restore_mana(mana_amount)
    inventory.remove_at(index)
    inventory_changed.emit()
    Saves.request_save()
    result["ok"] = true
    return result

## Лечит героя, возвращает фактически восстановленное хп.
func heal_hp(amount: int) -> int:
    if amount <= 0:
        return 0
    var before := hp
    hp = mini(max_hp(), hp + amount)
    if hp != before:
        hp_changed.emit(hp, max_hp())
        Saves.request_save()
    return hp - before

## Урон по герою (бои появятся позже; сейчас используется тестами).
func damage_hp(amount: int) -> void:
    if amount <= 0:
        return
    hp = maxi(0, hp - amount)
    hp_changed.emit(hp, max_hp())
    Saves.request_save()

## Потратить ману на заклинание. false — маны не хватает.
func spend_mana(amount: int) -> bool:
    if amount > mana:
        return false
    mana -= amount
    mana_changed.emit(mana, max_mana())
    Saves.request_save()
    return true

## Плавный реген маны (вызывает мир раз в секунду).
func regen_mana(amount: int) -> void:
    if max_mana() <= 0 or amount <= 0 or mana >= max_mana():
        return
    mana = mini(max_mana(), mana + amount)
    mana_changed.emit(mana, max_mana())

## Восстанавливает ману (зелья маны, шаг 7), возвращает фактически
## восстановленное количество. Лишнее срезается по максимуму маны героя.
func restore_mana(amount: int) -> int:
    if amount <= 0:
        return 0
    var before := mana
    mana = mini(max_mana(), mana + amount)
    if mana != before:
        mana_changed.emit(mana, max_mana())
        Saves.request_save()
    return mana - before

## Каст заклинания (шаг 6; шаг 12 — цена зависит от оружия в руках):
## списывает ману, если это маг и маны хватает.
func cast_spell() -> bool:
    var info := spell_info()
    if info.is_empty():
        return false
    return spend_mana(int(info["cost"]))

## Что получится на Q прямо сейчас (шаг 12).
## Маг с магическим оружием получает залп этого оружия (volley из ItemDB);
## маг без оружия или с обычной сталью — классическую «Магическую стрелу».
## Не-маг получает пустой словарь.
func spell_info() -> Dictionary:
    if not is_mage():
        return {}
    if has_weapon() and ItemDB.is_magic(equipped_weapon_id):
        var v := ItemDB.volley(equipped_weapon_id)
        if not v.is_empty():
            var info := SPELL.duplicate()
            info["id"] = equipped_weapon_id + "_volley"
            info["title"] = String(v.get("title", "Залп"))
            info["cost"] = int(v.get("mana", SPELL["cost"]))
            info["damage"] = int(v.get("damage", SPELL["damage"]))
            info["speed"] = float(v.get("speed", SPELL["speed"]))
            info["range_px"] = float(v.get("range_px", SPELL["range_px"]))
            info["cooldown"] = float(v.get("cooldown", SPELL["cooldown"]))
            info["count"] = int(v.get("count", 1))
            info["spread_deg"] = float(v.get("spread_deg", 0.0))
            info["color"] = v.get("color", [0.55, 0.85, 0.95])
            info["size"] = float(v.get("size", 1.0))
            info["weapon_id"] = equipped_weapon_id
            return info
    return SPELL.duplicate()

## Подсказка не-магу, нажавшему Q (шаг 12): у каждого класса свой отказ.
func non_mage_spell_hint() -> String:
    if hero_id == "barbarian":
        return "Магия отвергает варвара — залп не выйдет"
    if has_weapon() and ItemDB.is_magic(equipped_weapon_id):
        return "Оружие шепчет на своём языке, но залп тебе неподвластен"
    return "Колдовать умеет только Маг"

# ------------------------------------------------- оружие в руках и удары (шаг 7)

## Взять вещь из сумки в руки (шаг 7; шаг 12 — варвару отказ на магическое).
## Только оружие из ItemDB; если оно уже в руках — ничего.
func equip_weapon(item_id: String) -> bool:
    return bool(try_equip_weapon(item_id).get("ok", false))

## Шаг 12: экипировка оружия с причиной отказа (для сообщений в сумке):
## {"ok": bool, "reason": ""} — reason: not_weapon | already | not_in_bag |
## barbarian_rejected (магическое оружие отвергает варвара).
func try_equip_weapon(item_id: String) -> Dictionary:
    var result := {"ok": false, "reason": ""}
    var def := ItemDB.get_item(item_id)
    if def.is_empty() or String(def.get("type", "")) != "weapon":
        result["reason"] = "not_weapon"
        return result
    if item_id == equipped_weapon_id:
        result["reason"] = "already"
        return result
    if not _has_item(item_id):
        result["reason"] = "not_in_bag"
        return result
    # Варвар может драться только обычным оружием: магическое его отвергает
    # (металл, пропитанный чужой волей, жжёт его руки).
    if hero_id == "barbarian" and ItemDB.is_magic(item_id):
        result["reason"] = "barbarian_rejected"
        return result
    equipped_weapon_id = item_id
    equipped_changed.emit(equipped_weapon_id)
    Saves.request_save()
    result["ok"] = true
    return result

## Убрать оружие из рук — удары снова идут кулаками.
func unequip_weapon() -> void:
    if equipped_weapon_id.is_empty():
        return
    equipped_weapon_id = ""
    equipped_changed.emit("")
    Saves.request_save()

## Есть ли у героя оружие в руках (иначе удары рукой).
func has_weapon() -> bool:
    return not equipped_weapon_id.is_empty()

# ----------------------------------------- броня и одеяния (шаг 12)

## Надеть броню/одеяние из сумки. Броню (type "armor") носят все герои —
## она даёт +hp_bonus к максимуму ХП. Одеяния (type "robe") слушаются
## только мага: +mana_bonus к максимуму маны и немного +hp_bonus.
## Возвращает {"ok": bool, "reason": ""}:
## reason: not_armor | robe_not_mage | already | not_in_bag.
func equip_armor(item_id: String) -> Dictionary:
    var result := {"ok": false, "reason": ""}
    var t := String(ItemDB.get_item(item_id).get("type", ""))
    if t != "armor" and t != "robe":
        result["reason"] = "not_armor"
        return result
    if t == "robe" and not is_mage():
        result["reason"] = "robe_not_mage"
        return result
    if item_id == equipped_armor_id:
        result["reason"] = "already"
        return result
    if not _has_item(item_id):
        result["reason"] = "not_in_bag"
        return result
    equipped_armor_id = item_id
    armor_changed.emit(equipped_armor_id)
    # Текущие хп/мана остаются как были: вырос только потолок.
    hp = mini(hp, max_hp())
    mana = mini(mana, max_mana())
    hp_changed.emit(hp, max_hp())
    mana_changed.emit(mana, max_mana())
    Saves.request_save()
    result["ok"] = true
    return result

## Снять броню/одеяние: максимум ХП/маны возвращается к базовому,
## текущие значения срезаются под новый потолок.
func unequip_armor() -> void:
    if equipped_armor_id.is_empty():
        return
    equipped_armor_id = ""
    armor_changed.emit("")
    hp = mini(hp, max_hp())
    mana = mini(mana, max_mana())
    hp_changed.emit(hp, max_hp())
    mana_changed.emit(mana, max_mana())
    Saves.request_save()

## Есть ли на герое броня/одеяние.
func has_armor() -> bool:
    return not equipped_armor_id.is_empty()

## Урон удара: оружием в руках или кулаками (маг тоже бьёт рукой).
## Шаг 12: классы по-разному ладят с обычной сталью (CLASS_STRIKE_MULT):
## маг х0.5, варвар х2. Магическое оружие: маг — полная сила,
## воин/бомж — урон + магический эффект (+MAGIC_SURGE_FACTOR).
func strike_damage() -> int:
    if not has_weapon():
        return HAND_DAMAGE
    var base := ItemDB.damage(equipped_weapon_id)
    if ItemDB.is_magic(equipped_weapon_id):
        if is_mage():
            return base
        return base + maxi(1, int(round(float(base) * MAGIC_SURGE_FACTOR)))
    var mult := float(CLASS_STRIKE_MULT.get(hero_id, 1.0))
    return maxi(1, int(round(float(base) * mult)))

## Шаг 12: магический эффект в действии? (не-маг бьёт магическим оружием:
## урон с прибавкой, вспышка цвета оружия — визуал в world.gd)
func strike_is_magic_surge() -> bool:
    return has_weapon() and ItemDB.is_magic(equipped_weapon_id) and not is_mage()

## Цвет росчерка удара (шаг 12): магическое оружие — свой цвет,
## обычное — золото, кулаки — серый.
func strike_swing_color() -> Color:
    if has_weapon() and ItemDB.is_magic(equipped_weapon_id):
        var c: Array = ItemDB.volley(equipped_weapon_id).get("color", [1.0, 0.9, 0.5])
        return Color(float(c[0]), float(c[1]), float(c[2]))
    if has_weapon():
        return Color(1.0, 0.84, 0.0)
    return Color(0.8, 0.84, 0.95)

## Название того, чем герой бьёт (для HUD и подсказок).
func strike_title() -> String:
    if has_weapon():
        return ItemDB.title(equipped_weapon_id)
    return HAND_TITLE

# ------------------------------------------------------ смерть NPC (шаг 7)

## NPC мёртв? (мёртвые не разговаривают, не торгуют и не получают урон)
func is_npc_dead(npc_id: String) -> bool:
    return npc_id in dead_npcs

## NPC убит ударом героя: помечается на всю сессию. В сейв не пишется:
## при новой игре и загрузке слота мир жив снова, но в текущей сессии
## мёртвые не воскресают, а остальные NPC помнят убийство.
func kill_npc(npc_id: String) -> void:
    if npc_id.is_empty() or npc_id in dead_npcs:
        return
    dead_npcs.append(npc_id)
    npc_killed.emit(npc_id)

# ------------------------------------------------------------- демон (шаг 8)

## Скидка лавки демона: -10% за каждого убитого NPC (сам демон не в счёт).
const DEMON_DISCOUNT_PER_KILL := 10

## Сколько жителей убито: демон сам в подсчёте не участвует.
func demon_kill_count() -> int:
    var count := 0
    for npc_id in dead_npcs:
        if String(npc_id) != "demon":
            count += 1
    return count

## Шаг 12: герой ударил демона. После DEMON_RAGE_HITS ударов демон впадает
## в ярость (сигнал demon_enraged_changed): лавка закрывается, демон
## охотится на героя (ИИ — в world.gd). Возвращает текущий счёт ударов.
func register_demon_hit() -> int:
    demon_hits += 1
    if demon_hits >= DEMON_RAGE_HITS and not demon_enraged:
        demon_enraged = true
        demon_enraged_changed.emit()
    return demon_hits

## Шаг 13: погасить ярость демона — вызывается при возрождении героя
## («ОЧНУТЬСЯ В ЗАМКЕ»): демон снова мирен, счёт ударов обнулён,
## лавка открыта. Сигнал демон-мир получает world.gd (снимает красную ауру).
func reset_demon_rage() -> void:
    if demon_hits == 0 and not demon_enraged:
        return
    demon_hits = 0
    demon_enraged = false
    demon_enraged_changed.emit()

## Шаг 13: герой поговорил с демоном у края мира — «мы видели демона».
## Босс данжа 1 по этому флагу узнаёт героя и говорит об этом.
func mark_demon_seen() -> void:
    demon_seen = true

## Демон уже убит навсегда (больше не появится ни у края мира, ни в данже).
func demon_gone_forever() -> bool:
    return demon_defeated

## Шаг 13: оживить всех убитых NPC и стереть память об убийствах.
## Вызывается, когда демон повержен (на карте или как босс данжа 1):
## жертвы возвращаются в замок и не помнят, что их убивали.
func revive_all_npcs() -> void:
    if dead_npcs.is_empty():
        return
    dead_npcs.clear()
    npcs_revived.emit()

## Шаг 13: демон повержен НАВСЕГДА (на карте или как босс данжа 1):
## убитые NPC оживают и забывают убийства, ярость гаснет, демон больше
## не возвращается — ни у края мира, ни в подземелье (demon_defeated
## пишется в сейв v6).
func defeat_demon_permanently() -> void:
    demon_defeated = true
    demon_seen = false
    demon_hits = 0
    demon_enraged = false
    dead_npcs.clear()
    demon_enraged_changed.emit()
    npcs_revived.emit()
    Saves.request_save()

## Текущая скидка демона в процентах (-10% за убитого NPC, не больше 90%).
func demon_discount_pct() -> int:
    return mini(90, DEMON_DISCOUNT_PER_KILL * demon_kill_count())

## Данные NPC по id из WorldMap.NPCS (пустой словарь — не найден).
func npc_def(npc_id: String) -> Dictionary:
    for npc_data in WorldMap.NPCS:
        if String(npc_data.get("id", "")) == npc_id:
            return npc_data
    return {}

## Ассортимент демона (шаг 8): товары убитых торговцев — в порядке убийств,
## без повторов. Убитый не-торговец (Лира) товаров не приносит.
func demon_goods() -> Array[String]:
    var goods: Array[String] = []
    for npc_id in dead_npcs:
        for item_id in npc_def(String(npc_id)).get("goods", []):
            var id := String(item_id)
            if id not in goods and ItemDB.price(id) > 0:
                goods.append(id)
    return goods

## Цена демона: обычная цена лавки со скидкой, минимум 1 золото.
## Непродажные вещи (price <= 0) остаются непродажными.
func demon_price(item_id: String) -> int:
    var base := ItemDB.price(item_id)
    if base <= 0:
        return base
    var discounted := int(round(float(base) * (100.0 - float(demon_discount_pct())) / 100.0))
    return maxi(1, discounted)

## Купить у демона: как buy_item, но по демонической цене со скидкой
## и только из ассортимента павших торговцев.
func buy_from_demon(item_id: String) -> bool:
    if item_id not in demon_goods():
        return false
    var cost := demon_price(item_id)
    if cost <= 0 or cost > gold:
        return false
    gold -= cost
    add_item({"item_id": item_id, "title": ItemDB.title(item_id),
              "quality": "gray"}, false)
    gold_changed.emit(gold)
    Saves.request_save()
    return true

func add_item(item: Dictionary, do_save: bool = true) -> void:
    inventory.append(item.duplicate())
    inventory_changed.emit()
    if do_save:
        Saves.request_save()

# ------------------------------------------------------------- торговля (шаг 5)

## Купить предмет у торговца: списывает цену из ItemDB, кладёт вещь в сумку.
## Возвращает false, если товара нет в базе, он бесплатный/непродажный
## или не хватает золота.
func buy_item(item_id: String) -> bool:
    var cost := ItemDB.price(item_id)
    if cost <= 0:
        return false
    if not spend_gold(cost):
        return false
    add_item({"item_id": item_id, "title": ItemDB.title(item_id),
              "quality": "gray"}, false)
    Saves.request_save()
    return true

## Продать предмет из сумки торговцу за половину цены (ItemDB.sell_price).
## index — позиция в Game.inventory. Безымянная добыча без item_id и
## фиолетовые уники (price < 0) не продаются. Если продали оружие,
## бывшее в руках — оно снимается (шаг 7); если продали надетую броню —
## она снимается (шаг 12).
func sell_item(index: int) -> bool:
    if index < 0 or index >= inventory.size():
        return false
    var item: Dictionary = inventory[index]
    var item_id := String(item.get("item_id", ""))
    if item_id.is_empty():
        return false
    var earned := ItemDB.sell_price(item_id)
    if earned <= 0:
        return false
    inventory.remove_at(index)
    if equipped_weapon_id == item_id and not _has_item(equipped_weapon_id):
        equipped_weapon_id = ""
        equipped_changed.emit("")
    if equipped_armor_id == item_id and not _has_item(equipped_armor_id):
        unequip_armor()
    inventory_changed.emit()
    add_gold(earned)
    return true

## Есть ли предмет с таким item_id в сумке.
func _has_item(item_id: String) -> bool:
    for item in inventory:
        if String(item.get("item_id", "")) == item_id:
            return true
    return false

func mark_dungeon_cleared(dungeon_id: String) -> void:
    if dungeon_id not in dungeons_cleared:
        dungeons_cleared.append(dungeon_id)
        Saves.request_save()

func set_setting(key: String, value: bool) -> void:
    settings[key] = value
    save_meta()

## Полный сброс: очищает слоты сейвов, прогресс в памяти и meta-указатели.
## Настройки и дата ежедневного бонуса сохраняются (чтобы бонус не «фармили»).
func reset_progress() -> void:
    gold = START_GOLD
    inventory = []
    dungeons_cleared = []
    hero_id = DEFAULT_HERO
    equipped_weapon_id = ""
    equipped_armor_id = ""
    hp = hero_max_hp(hero_id)
    mana = hero_max_mana(hero_id)
    dead_npcs = []
    demon_hits = 0
    demon_enraged = false
    demon_seen = false
    demon_defeated = false
    dungeon_floor = 0
    current_slot = 0
    meta["last_slot"] = 0
    meta["pending_gold"] = 0
    meta["pending_items"] = []
    Saves.wipe_all_slots()
    save_meta()
    gold_changed.emit(gold)
    inventory_changed.emit()
    equipped_changed.emit("")
    armor_changed.emit("")

## Слот для новой игры: первый свободный, иначе последний игравшийся.
func pick_new_slot() -> int:
    for slot in range(1, SLOT_COUNT + 1):
        if not Platform.has_slot(slot):
            return slot
    var last := int(meta.get("last_slot", 0))
    return last if (last >= 1 and last <= SLOT_COUNT) else 1

## Начать новую игру в слоте slot за героя hero.
## Кошелёк на старте зависит от героя: Воин 100, Варвар 50, Бомж 1, Маг 60.
## Хп/мана ставятся на максимум героя (у мага: 30 хп, 70 маны).
## Оружие, броня и убитые NPC сбрасываются (шаги 7/12); демон забывает удары
## и возвращается (demon_defeated — только для текущего прохождения).
func new_run(slot: int, hero: String) -> void:
    gold = START_GOLD
    inventory = []
    dungeons_cleared = []
    hero_id = hero if HEROES.has(hero) else DEFAULT_HERO
    current_slot = clampi(slot, 1, SLOT_COUNT)
    gold = hero_start_gold(hero_id)
    equipped_weapon_id = ""
    equipped_armor_id = ""
    hp = max_hp()
    mana = max_mana()
    dead_npcs = []
    demon_hits = 0
    demon_enraged = false
    demon_seen = false
    demon_defeated = false
    dungeon_floor = 0
    _transfer_pending_bonus()
    gold_changed.emit(gold)
    inventory_changed.emit()
    hp_changed.emit(hp, max_hp())
    mana_changed.emit(mana, max_mana())
    equipped_changed.emit("")
    armor_changed.emit("")
    Saves.request_save()

## Загрузить игру из слота.
func continue_run(slot: int) -> bool:
    var data := Platform.load_data(slot)
    if data.is_empty():
        return false
    load_save_data(data)
    current_slot = clampi(slot, 1, SLOT_COUNT)
    _transfer_pending_bonus()
    Saves.request_save()
    return true

## Ежедневный бонус: раз в календарный день 50-200 золота + фиолетовая добыча.
## Возвращает {"gold": int, "item_id": String} или {} если сегодня уже получено.
## Награда сразу попадает в состояние игры; если игра ещё не идёт
## (нет активного слота) — дополнительно откладывается в meta и будет
## выдана при начале/загрузке игры (см. _transfer_pending_bonus).
func claim_daily_bonus() -> Dictionary:
    var today := Time.get_date_string_from_system()
    if String(meta.get("last_bonus_date", "")) == today:
        return {}
    var gold_reward := randi_range(50, 200)
    var item_id := ItemDB.random_violet_unique()
    meta["last_bonus_date"] = today
    add_gold(gold_reward)
    add_item({"item_id": item_id, "title": ItemDB.title(item_id), "quality": "violet"})
    if current_slot < 1:
        meta["pending_gold"] = int(meta.get("pending_gold", 0)) + gold_reward
        var pending: Array = meta.get("pending_items", [])
        pending.append(item_id)
        meta["pending_items"] = pending
    save_meta()
    return {"gold": gold_reward, "item_id": item_id}

## Может ли игрок забрать бонус прямо сейчас.
func can_claim_bonus() -> bool:
    return String(meta.get("last_bonus_date", "")) != Time.get_date_string_from_system()

## Отложенные награды бонуса (случились, когда игры ещё не было).
func _transfer_pending_bonus() -> void:
    var pending_gold := int(meta.get("pending_gold", 0))
    if pending_gold > 0:
        gold += pending_gold
        meta["pending_gold"] = 0
        gold_changed.emit(gold)
    var pending_items: Array = meta.get("pending_items", [])
    for item_id in pending_items:
        add_item({"item_id": String(item_id), "title": ItemDB.title(String(item_id)),
                  "quality": "violet"}, false)
    if not pending_items.is_empty():
        meta["pending_items"] = []
        inventory_changed.emit()
    if pending_gold > 0 or not pending_items.is_empty():
        save_meta()

func to_save_data() -> Dictionary:
    return {
        "v": 6,
        "hero_id": hero_id,
        "gold": gold,
        "hp": hp,
        "mana": mana,
        "inventory": inventory,
        "dungeons_cleared": dungeons_cleared,
        "equipped_weapon_id": equipped_weapon_id,
        "equipped_armor_id": equipped_armor_id,
        "demon_defeated": demon_defeated,
        "saved_at": Time.get_datetime_string_from_system(false, true),
    }

func load_save_data(data: Dictionary) -> void:
    hero_id = String(data.get("hero_id", DEFAULT_HERO))
    if not HEROES.has(hero_id):
        hero_id = DEFAULT_HERO
    gold = int(data.get("gold", hero_start_gold(hero_id)))
    inventory = []
    for item in data.get("inventory", []):
        if item is Dictionary:
            inventory.append(item)
    dungeons_cleared = []
    for dungeon_id in data.get("dungeons_cleared", []):
        dungeons_cleared.append(String(dungeon_id))
    # Шаг 7: оружие в руках восстанавливаем, только если оно действительно
    # лежит в сумке и является оружием (защита от старых/битых сейвов).
    # Шаг 12: магическое оружие у варвара из старого сейва снимается —
    # варвар может драться только обычной сталью.
    equipped_weapon_id = ""
    var saved_weapon := String(data.get("equipped_weapon_id", ""))
    if not saved_weapon.is_empty() \
            and String(ItemDB.get_item(saved_weapon).get("type", "")) == "weapon" \
            and _has_item(saved_weapon) \
            and not (hero_id == "barbarian" and ItemDB.is_magic(saved_weapon)):
        equipped_weapon_id = saved_weapon
    # Шаг 12: броня/одеяние восстанавливается только если это экипировка
    # из сумки; одеяние — только магу. Старые сейвы (v4 и раньше) мигрируют
    # с пустым слотом брони.
    equipped_armor_id = ""
    var saved_armor := String(data.get("equipped_armor_id", ""))
    var armor_type := String(ItemDB.get_item(saved_armor).get("type", ""))
    if not saved_armor.is_empty() \
            and (armor_type == "armor" or armor_type == "robe") \
            and _has_item(saved_armor) \
            and not (armor_type == "robe" and not is_mage()):
        equipped_armor_id = saved_armor
    # Совместимость с сейвами шагов 1-5: если хп/маны в сейве нет —
    # ставим максимум героя с учётом надетой экипировки (шаг 12).
    hp = clampi(int(data.get("hp", max_hp())), 0, max_hp())
    mana = clampi(int(data.get("mana", max_mana())), 0, max_mana())
    # Ярость демона и «мы видели демона» — состояние сессии (шаги 12/13).
    demon_hits = 0
    demon_enraged = false
    demon_seen = false
    dungeon_floor = 0
    # Шаг 13: демон, убитый навсегда, остаётся мёртвым и после загрузки
    # (сейв v6; старые сейвы мигрируют: демон ещё жив).
    demon_defeated = bool(data.get("demon_defeated", false))
    # Мёртвые NPC в сейв не пишутся: список живёт только в сессии.
    # Совместимость с сейвами шагов 1-2: настройки жили в сейве.
    if data.has("settings"):
        var saved_settings: Dictionary = data.get("settings", {})
        settings["sound"] = bool(saved_settings.get("sound", true))
        settings["music"] = bool(saved_settings.get("music", true))
        save_meta()
    gold_changed.emit(gold)
    inventory_changed.emit()
    hp_changed.emit(hp, max_hp())
    mana_changed.emit(mana, max_mana())
    equipped_changed.emit(equipped_weapon_id)
    armor_changed.emit(equipped_armor_id)

````

#### `scripts/autoload/game_state.gd.uid`

````
uid://dim0imch8nk7t

````

#### `scripts/autoload/platform.gd`

````gdscript
## Автозагрузка Platform: мост между игрой и площадкой.
## Сейчас работает «локальный режим» (десктоп/RuStore: файлы сохранений).
## Перед экспортом на Яндекс Игры сюда добавим вызовы Yandex Games SDK:
## LoadingAPI.ready(), GameplayAPI.start()/stop(), player.setData()/getData().
extends Node

enum Provider { LOCAL, YANDEX, RUSTORE }

const SLOT_TEMPLATE := "user://save_slot_%d.json"
const META_PATH := "user://meta.json"
const LEGACY_SAVE_PATH := "user://save.json"  # сейв из шагов 1-2

var provider: Provider = Provider.LOCAL
## Журнал вызовов для автотестов (в релизе не используется).
var calls: Array[String] = []

## Игра действительно готова к взаимодействию (на Яндексе — LoadingAPI.ready(),
## модерация проверяет этот вызов).
func notify_ready() -> void:
    calls.append("notify_ready")
    if provider == Provider.YANDEX:
        pass  # TODO(экспорт): ysdk.LoadingAPI.ready()

## Игрок начал играть (разметка геймплея для аналитики Яндекса).
func gameplay_start() -> void:
    calls.append("gameplay_start")
    if provider == Provider.YANDEX:
        pass  # TODO(экспорт): ysdk.GameplayAPI.start()

## Игрок остановился (меню, пауза, конец уровня).
func gameplay_stop() -> void:
    calls.append("gameplay_stop")
    if provider == Provider.YANDEX:
        pass  # TODO(экспорт): ysdk.GameplayAPI.stop()

func slot_path(slot: int) -> String:
    return SLOT_TEMPLATE % maxi(1, slot)

## Сохранить прогресс в слот. Локально — файл, на Яндексе — player.setData().
func save_data(data: Dictionary, slot: int = 1) -> int:
    var file := FileAccess.open(slot_path(slot), FileAccess.WRITE)
    if file == null:
        return FAILED
    file.store_string(JSON.stringify(data, "\t"))
    return OK

## Загрузить слот. Пустой словарь — сохранения нет.
func load_data(slot: int = 1) -> Dictionary:
    var path := slot_path(slot)
    if not FileAccess.file_exists(path):
        return {}
    var file := FileAccess.open(path, FileAccess.READ)
    if file == null:
        return {}
    var parsed: Variant = JSON.parse_string(file.get_as_text())
    if parsed is Dictionary:
        return parsed
    return {}

func has_slot(slot: int) -> bool:
    return FileAccess.file_exists(slot_path(slot))

## Удалить файл слота (не ошибка, если слота и не было).
func delete_slot(slot: int) -> void:
    if not has_slot(slot):
        return
    var dir := DirAccess.open("user://")
    if dir != null:
        dir.remove(slot_path(slot).get_file())

## Сохранить глобальные данные (настройки, последний слот, бонус) — meta.json.
func save_meta(meta: Dictionary) -> int:
    var file := FileAccess.open(META_PATH, FileAccess.WRITE)
    if file == null:
        return FAILED
    file.store_string(JSON.stringify(meta, "\t"))
    return OK

## Загрузить meta. Пустой словарь — файла нет.
func load_meta() -> Dictionary:
    if not FileAccess.file_exists(META_PATH):
        return {}
    var file := FileAccess.open(META_PATH, FileAccess.READ)
    if file == null:
        return {}
    var parsed: Variant = JSON.parse_string(file.get_as_text())
    if parsed is Dictionary:
        return parsed
    return {}

## Чтение старого сейва шагов 1-2 (миграция в слоты).
func load_legacy() -> Dictionary:
    if not FileAccess.file_exists(LEGACY_SAVE_PATH):
        return {}
    var file := FileAccess.open(LEGACY_SAVE_PATH, FileAccess.READ)
    if file == null:
        return {}
    var parsed: Variant = JSON.parse_string(file.get_as_text())
    if parsed is Dictionary:
        return parsed
    return {}

````

#### `scripts/autoload/platform.gd.uid`

````
uid://lob8gn5thi2u

````

#### `scripts/autoload/save_manager.gd`

````gdscript
## Автозагрузка Saves: управление 3 слотами сохранений.
## Само хранилище абстрагировано в Platform: сейчас это файлы user://save_slot_N.json,
## на Яндекс Играх станет облачным сохранением игрока (player.setData).
extends Node

func _ready() -> void:
    # Миграция старого сейва шагов 1-2 (user://save.json) в первый свободный слот.
    var legacy := Platform.load_legacy()
    if not legacy.is_empty():
        for slot in range(1, Game.SLOT_COUNT + 1):
            if not Platform.has_slot(slot):
                if Platform.save_data(legacy, slot) == OK:
                    Game.meta["last_slot"] = slot
                    Game.save_meta()
                break
    # Подтягиваем последний игравшийся слот в память (для меню и бонуса).
    var last := int(Game.meta.get("last_slot", 0))
    if last >= 1 and last <= Game.SLOT_COUNT and Platform.has_slot(last):
        Game.load_save_data(Platform.load_data(last))
        Game.current_slot = last

## Запрос на сохранение (вызывается из Game при любом изменении).
## Сохраняем только когда игра реально идёт (есть активный слот).
func request_save() -> void:
    if Game.current_slot < 1:
        return
    var err := Platform.save_data(Game.to_save_data(), Game.current_slot)
    if err != OK:
        push_warning("Saves: не удалось сохранить, код ошибки %d" % err)
        return
    Game.meta["last_slot"] = Game.current_slot
    Game.save_meta()

## Сводка по слоту для списка «Загрузить игру».
func get_slot_info(slot: int) -> Dictionary:
    var data := Platform.load_data(slot)
    if data.is_empty():
        return {"exists": false}
    var items: Array = data.get("inventory", [])
    return {
        "exists": true,
        "hero": Game.HEROES.get(String(data.get("hero_id", Game.DEFAULT_HERO)), {}).get("title", "?"),
        "gold": int(data.get("gold", 0)),
        "items": items.size(),
        "ts": String(data.get("saved_at", "")),
    }

## Удалить все слоты (используется при полном сбросе прогресса).
func wipe_all_slots() -> void:
    for slot in range(1, Game.SLOT_COUNT + 1):
        Platform.delete_slot(slot)

````

#### `scripts/autoload/save_manager.gd.uid`

````
uid://bgnwutmw3r0gu

````

#### `scripts/data/dungeon_bestiary.gd`

````gdscript
## Бестиарий и генератор 1-го подземелья «Dungeon Loot» (шаги 13–15).
## Данж 1 — «Подземелье замка» (шаг 15): теперь 4 БОЛЬШИХ тематических этажа
## вместо десяти тесных. Карта выросла с 40x36 до 64x48, комнат 10–13,
## врагов на этаж 7–13 (плюс элитные «чемпионы» и хранитель сокровищницы).
## Каждый этаж — своя тема (тайлы стен/полов, декор, акценты, свет):
##   1 «Смрадные катакомбы» — пауки и змеи, паутина, мшистый камень;
##   2 «Пустотные чертоги» — космические пауки и мертвецы, звёздный камень,
##     фиолетовые трещины и кристаллы;
##   3 «Костяная обитель» — мертвецы всех видов, пол в костях, смерть-свечение;
##   4 «Багровое логово» — высшие демоны, угли, ковровая дорожка к трону
##     и обязательный босс: Таинственный демон с юга карты (в диалоге он
##     узнаёт героя, если тот видел его у края мира).
## На этажах 1–3 есть СОКРОВИЩНИЦА: зал из золотой мозаики с парой сундуков,
## кристаллами и элитным хранителем. На 4-м — большой зал босса с колоннами,
## жаровнями и ковровой дорожкой. Сундуков на этаже 4–5.
## Лестница вниз открывается тишине: пока жив хоть один враг — путь закрыт.
## Все числа хп/урона/скоростей и награды — ЗАГЛУШКИ (утверждает автор).
class_name DungeonBestiary
extends RefCounted

const SHEET_DIR := "res://assets/sprites/dungeon/"

## Противники 1-го подземелья, по возрастанию сложности (порядок важен:
## от него зависит, каких врагов какой этаж может заспавнить).
## ranged: true — колдун: держит дистанцию и швыряет болт (болт летит
## со скоростью bolt_speed на дистанцию bolt_range, перезарядка bolt_cd).
## gold — награда за убийство (ЗАГЛУШКА).
const FOES: Array[Dictionary] = [
    {"id": "spider", "name": "Паук", "hp": 12, "damage": 4, "speed": 70.0,
        "sheet": SHEET_DIR + "spider.png", "ranged": false,
        "aggro": 110.0, "attack_range": 22.0, "attack_cd": 1.1,
        "gold": 3, "bolt_color": [0.55, 0.85, 0.95]},
    {"id": "snake", "name": "Змея", "hp": 16, "damage": 6, "speed": 85.0,
        "sheet": SHEET_DIR + "snake.png", "ranged": false,
        "aggro": 110.0, "attack_range": 22.0, "attack_cd": 1.0,
        "gold": 4, "bolt_color": [0.5, 0.9, 0.55]},
    {"id": "cosmic_spider", "name": "Космический паук", "hp": 26, "damage": 8,
        "speed": 80.0, "sheet": SHEET_DIR + "cosmic_spider.png", "ranged": false,
        "aggro": 120.0, "attack_range": 24.0, "attack_cd": 1.0,
        "gold": 6, "bolt_color": [0.72, 0.55, 0.95]},
    {"id": "undead_bum", "name": "Мертвец бомж", "hp": 34, "damage": 9,
        "speed": 52.0, "sheet": SHEET_DIR + "undead_bum.png", "ranged": false,
        "aggro": 120.0, "attack_range": 24.0, "attack_cd": 1.2,
        "gold": 8, "bolt_color": [0.6, 0.7, 0.5]},
    {"id": "undead_knight", "name": "Мертвец рыцарь", "hp": 55, "damage": 13,
        "speed": 58.0, "sheet": SHEET_DIR + "undead_knight.png", "ranged": false,
        "aggro": 130.0, "attack_range": 26.0, "attack_cd": 1.2,
        "gold": 12, "bolt_color": [0.75, 0.75, 0.8]},
    {"id": "undead_sorcerer", "name": "Мертвец колдун", "hp": 40, "damage": 11,
        "speed": 44.0, "sheet": SHEET_DIR + "undead_sorcerer.png", "ranged": true,
        "aggro": 150.0, "attack_range": 120.0, "attack_cd": 1.8,
        "gold": 14, "bolt_color": [0.45, 0.8, 0.6], "bolt_speed": 130.0,
        "bolt_range_px": 190.0, "keep_distance": 90.0},
    {"id": "demon_swordsman", "name": "Демон мечник", "hp": 75, "damage": 17,
        "speed": 72.0, "sheet": SHEET_DIR + "demon_swordsman.png", "ranged": false,
        "aggro": 130.0, "attack_range": 26.0, "attack_cd": 1.0,
        "gold": 18, "bolt_color": [0.95, 0.5, 0.3]},
    {"id": "demon_sorcerer", "name": "Демон колдун", "hp": 60, "damage": 15,
        "speed": 62.0, "sheet": SHEET_DIR + "demon_sorcerer.png", "ranged": true,
        "aggro": 150.0, "attack_range": 120.0, "attack_cd": 1.6,
        "gold": 22, "bolt_color": [0.95, 0.45, 0.55], "bolt_speed": 150.0,
        "bolt_range_px": 210.0, "keep_distance": 100.0},
]

## Обязательный босс последнего этажа: тот самый Таинственный демон,
## что появлялся на юге карты. Если мы видели его — он узнаёт героя,
## говорит об этом, и начинается битва. Лист 72x96 — он втрое крупнее
## обычных врагов (как у демона с юга мира). Числа — ЗАГЛУШКИ.
const BOSS: Dictionary = {
    "id": "boss_demon", "name": "Таинственный демон", "hp": 300, "damage": 12,
    "speed": 58.0, "sheet": "res://assets/sprites/chars/demon.png",
    "portrait": "res://assets/sprites/portraits/demon.png", "scale": 3,
    "aggro": 260.0, "attack_range": 34.0, "attack_cd": 1.0, "gold": 300,
}

# ------------------------------------------------------- этажи и темы (шаг 15)

const FLOORS := 4
const MAP_W := 64
const MAP_H := 48

## Тема этажа: тайлы стен/полов из атласа, цвет «воздуха» (CanvasModulate),
## плотность декора (паутина/кости/кровь/свечение), пул врагов и их число.
## wall/floors/glow — координаты тайлов в assets/tilesets/dungeon_tiles.png.
## hint — реплика при входе на этаж (тон — лавкрафтовский космо-хоррор).
const THEMES: Array[Dictionary] = [
    {
        "id": "catacombs", "name": "Смрадные катакомбы",
        "wall": Vector2i(2, 0),
        "floors": [Vector2i(0, 1), Vector2i(1, 1), Vector2i(4, 1)],
        "glow": Vector2i(5, 2),
        "canvas": Color(0.8, 0.86, 0.79),
        "webs": 26, "bones": 10, "blood": 10, "glow_n": 16,
        "pool": ["spider", "snake"],
        "foes_min": 7, "foes_max": 9,
        "hint": "Смрадные катакомбы. Паутина на каждом шагу, и ползёт что-то бесчисленное. Кости у стен — чьи-то, но не твои. Пока не твои.",
    },
    {
        "id": "void_halls", "name": "Пустотные чертоги",
        "wall": Vector2i(3, 0),
        "floors": [Vector2i(0, 1), Vector2i(5, 1), Vector2i(1, 1)],
        "glow": Vector2i(6, 2),
        "canvas": Color(0.79, 0.76, 0.9),
        "webs": 8, "bones": 8, "blood": 8, "glow_n": 18,
        "pool": ["cosmic_spider", "undead_bum"],
        "foes_min": 8, "foes_max": 10,
        "hint": "Пустотные чертоги. Камни здесь помнят чужие звёзды: фиолетовые трещины светятся в темноте, и в них смотрит что-то безымянное.",
    },
    {
        "id": "ossuary", "name": "Костяная обитель",
        "wall": Vector2i(4, 0),
        "floors": [Vector2i(0, 1), Vector2i(6, 1), Vector2i(1, 1)],
        "glow": Vector2i(7, 2),
        "canvas": Color(0.85, 0.84, 0.8),
        "webs": 4, "bones": 30, "blood": 10, "glow_n": 10,
        "pool": ["undead_bum", "undead_knight", "undead_sorcerer"],
        "foes_min": 9, "foes_max": 12,
        "hint": "Костяная обитель. Пол выстлан костями тех, кто спускался раньше тебя. Мертвецы не любят гостей, а колдуны — тем более.",
    },
    {
        "id": "crimson_lair", "name": "Багровое логово",
        "wall": Vector2i(5, 0),
        "floors": [Vector2i(0, 1), Vector2i(7, 1), Vector2i(1, 1)],
        "glow": Vector2i(0, 3),
        "canvas": Color(0.9, 0.79, 0.75),
        "webs": 0, "bones": 8, "blood": 24, "glow_n": 14,
        "pool": ["demon_swordsman", "demon_sorcerer"],
        "foes_min": 10, "foes_max": 13,
        "hint": "Багровое логово. Воздух дрожит от шёпота, угли трещат в темноте. Дорожка ведёт к трону — и к хозяину подземелья.",
    },
]

## Тема этажа (с защитой от неверных номеров при загрузке старых сейвов).
static func theme_for_floor(floor_num: int) -> Dictionary:
    return THEMES[clampi(floor_num - 1, 0, THEMES.size() - 1)]

## Награда за врага: золото ЗАГЛУШКА — растёт с глубиной этажа.
static func foe_gold(def: Dictionary, floor_num: int) -> int:
    return int(def.get("gold", 3)) + floor_num * 3

## Определение врага по id (пустой словарь — не найден).
static func foe_def(foe_id: String) -> Dictionary:
    for def in FOES:
        if String(def.get("id", "")) == foe_id:
            return def
    return {}

## Пул врагов этажа — по теме этажа (шаг 15: строгая прогрессия видов).
static func pool_for_floor(floor_num: int) -> Array:
    return theme_for_floor(floor_num).get("pool", ["spider"])

## Сколько врагов на этаже: 7–13 по мере глубины (босс последнего — отдельно).
static func foe_count_for_floor(floor_num: int) -> int:
    var theme := theme_for_floor(floor_num)
    return randi_range(int(theme.get("foes_min", 7)),
        int(theme.get("foes_max", 9)))

# --------------------------------------------------------- генерация этажа

## Сундуков на этаж (шаг 15): 2–3 раскиданы по комнатам, ещё 2 — в
## сокровищнице (этажи 1–3) или в зале босса (этаж 4). Итого 4–5.
const CHESTS_MIN := 2
const CHESTS_MAX := 3
## Факелов на этаж: по стенам комнат и коридоров.
const TORCHES_MIN := 10
const TORCHES_MAX := 14

## Символы сетки: "#" — стена (твёрдая), "o" — колонна (твёрдая),
## "." — каменный пол, "b" — пол с костями, "w" — паутина, "x" — кровь,
## "g" — светящаяся трещина, "p" — ковёр, "m" — золотая мозаика,
## "<" — лестница наверх, ">" — лестница вниз, "X" — выход в замок.
## Все, кроме "#" и "o", проходимы; спавнить врагов/сундуки можно
## только на «чистых полах» (см. _open_floor).
const SOLID := "#o"

## Сгенерировать этаж floor_num (1..4). Возвращает:
## {"grid": Array[String], "spawn": Vector2i, "up": Vector2i,
##  "down": Vector2i (Vector2i(-1,-1) на этаже босса),
##  "foe_spawns": Array[Dictionary] — {"tile": Vector2i, "id": String,
##      "elite": bool} (элитные чемпионы: больше хп/урона/золота),
##  "chest_tiles": Array[Vector2i] (4–5 сундуков),
##  "torch_tiles": Array[Vector2i] (факелы у стен),
##  "prop_tiles": Array[Dictionary] — {"tile": Vector2i, "kind": String}
##      (бочки, ящики, кристаллы, жаровни, трон),
##  "vault_center": Vector2i (центр сокровищницы; Vector2i(-1,-1) на этаже
##      босса — там вместо неё большой зал),
##  "boss_tile": Vector2i (Vector2i(-1,-1), если босса нет — он уже убит
##  навсегда или этаж не последний),
##  "exit_tile": Vector2i (появляется на этаже босса после победы)}
static func generate_floor(floor_num: int, boss_present: bool) -> Dictionary:
    var is_boss_floor := floor_num >= FLOORS
    var grid: Array[String] = []
    for y in range(MAP_H):
        grid.append("#".repeat(MAP_W))

    # зал босса: большой прямоугольник + прихожая с лестницей наверх;
    # обычные этажи: 10–13 комнат
    var rooms: Array[Rect2i] = []
    var hall := Rect2i(-1, -1, 0, 0)
    var ante := Rect2i(-1, -1, 0, 0)
    if is_boss_floor:
        hall = Rect2i(21, 5, 22, 14)
        _carve_rect(grid, hall)
        ante = Rect2i(30, 20, 4, 5)
        _carve_rect(grid, ante)
        # двухтайловый проход из зала в прихожую
        _carve_rect(grid, Rect2i(31, hall.end.y, 2,
            ante.position.y - hall.end.y))
        rooms.append(hall)
        rooms.append(ante)
        rooms.append_array(_carve_rooms(grid, rooms))
    else:
        rooms = _carve_rooms(grid)

    # декор: колонны в больших залах, паутина/кости/кровь/свечение по теме.
    # ДО коридоров: коридоры вырезаются поверх декора, поэтому колонна
    # не может перекрыть единственный путь (шаг 15)
    _sprinkle_decor(grid, rooms, theme_for_floor(floor_num))
    _connect_rooms(grid, rooms)

    # лестницы: наверх — в стартовой комнате (на этаже босса — в прихожей,
    # чтобы герой входил издалека); вниз — в самой дальней комнате
    var spawn := Vector2i(-1, -1)
    var up: Vector2i = _room_center(rooms[0])
    if is_boss_floor:
        up = _room_center(ante)
    _set_cell(grid, up, "<")
    spawn = up
    var down := Vector2i(-1, -1)
    if not is_boss_floor:
        down = _room_center(rooms[rooms.size() - 1])
        _set_cell(grid, down, ">")

    # босс: на ковровой дорожке зала (этаж последний и он ещё жив)
    var boss_tile := Vector2i(-1, -1)
    if is_boss_floor and boss_present:
        boss_tile = Vector2i(hall.position.x + hall.size.x / 2,
            hall.position.y + 5)
        _set_cell(grid, boss_tile, ".")

    # гарантированный декор зала босса (шаг 15): жаровни по углам и трон
    # за боссом — ДО врагов, чтобы никто не встал на их место;
    # эти клетки «резервируются» для врагов и сундуков
    var reserved: Array[Vector2i] = []
    var hall_props: Array[Dictionary] = []
    if is_boss_floor and hall.size.x > 0:
        _pick_hall_props(grid, hall, boss_tile, spawn, up,
            hall_props, reserved)

    # сокровищница: самая дальняя от входа комната выстлана золотой
    # мозаикой (этажи 1–3; на этаже босса вместо неё — большой зал)
    var vault := Rect2i(-1, -1, 0, 0)
    var vault_center := Vector2i(-1, -1)
    if not is_boss_floor and rooms.size() >= 3:
        vault = _farthest_room(rooms, _room_center(rooms[0]))
        vault_center = _room_center(vault)
        _fill_rect(grid, vault, "m")

    # ковровая дорожка к трону босса: только по чистым полам — лестницы,
    # тайл босса и мозаика не затрагиваются
    if is_boss_floor:
        var cx := hall.position.x + hall.size.x / 2
        for y in range(hall.position.y + 3,
                _room_center(ante).y + 1):
            if String(grid[y][cx]) == ".":
                _set_cell(grid, Vector2i(cx, y), "p")

    # враги: по свободным полам; стартовая комната и прихожая — тихие,
    # сокровищница — территория хранителя, в зале босса — не вплотную
    # к боссу. Элитные чемпионы: хранитель сокровищницы (всегда элита)
    # плюс 0–2 случайных чемпиона.
    var foe_spawns := _pick_foe_spawns(grid, rooms, spawn, down, boss_tile,
        vault, vault_center, floor_num, is_boss_floor, reserved)

    # сундуки: 2 в сокровищнице (или в зале босса по углам) + 2–3 по этажу
    var chest_tiles := _pick_chest_tiles(grid, rooms, spawn, up, down,
        boss_tile, vault, vault_center, foe_spawns, is_boss_floor, hall,
        reserved)

    # рассыпанный реквизит: бочки/ящики/кристаллы по комнатам и в
    # сокровищнице (жаровни и трон уже стоят). Реквизит ДО факелов:
    # факелы не встанут на занятую клетку (шаг 15)
    var prop_tiles := hall_props
    prop_tiles.append_array(_pick_prop_tiles(grid, rooms, spawn, up, down,
        boss_tile, chest_tiles, foe_spawns, floor_num,
        is_boss_floor, hall, vault, reserved))

    # факелы: полы у стен, вдали от сундуков и друг от друга
    var torch_tiles := _pick_torch_tiles(grid, spawn, up, down, boss_tile,
        chest_tiles, foe_spawns, prop_tiles)

    var exit_tile := Vector2i(-1, -1)
    if is_boss_floor and not boss_present:
        # босс уже повержен навсегда: выход ждёт в прихожей зала,
        # рядом с лестницей наверх
        exit_tile = _room_center(ante) + Vector2i(1, 0)
        if not _open_floor(grid, exit_tile):
            exit_tile = _room_center(ante)

    return {"grid": grid, "spawn": spawn, "up": up, "down": down,
        "foe_spawns": foe_spawns, "chest_tiles": chest_tiles,
        "torch_tiles": torch_tiles, "prop_tiles": prop_tiles,
        "vault_center": vault_center, "boss_tile": boss_tile,
        "exit_tile": exit_tile}

## Проходимый «чистый» пол (можно спавнить врагов, сундуки, декор):
## не стена/колонна и не лестница/выход.
static func _open_floor(grid: Array[String], t: Vector2i) -> bool:
    if t.x < 0 or t.y < 0 or t.x >= MAP_W or t.y >= MAP_H:
        return false
    var ch := String(grid[t.y][t.x])
    return not SOLID.contains(ch) and ch != "<" and ch != ">" and ch != "X"

## Прямоугольная комната, вырезанная в камне.
static func _carve_rect(grid: Array[String], rect: Rect2i) -> void:
    for y in range(rect.position.y, rect.end.y):
        for x in range(rect.position.x, rect.end.x):
            _set_cell(grid, Vector2i(x, y), ".")

## Выложить чистые полы прямоугольника заданным символом (мозаика
## сокровищницы); лестницы и прочие особые тайлы не трогаются.
static func _fill_rect(grid: Array[String], rect: Rect2i, symbol: String) -> void:
    for y in range(rect.position.y, rect.end.y):
        for x in range(rect.position.x, rect.end.x):
            var t := Vector2i(x, y)
            if String(grid[t.y][t.x]) == ".":
                _set_cell(grid, t, symbol)

## Комнаты: 10–13 прямоугольников без пересечений (с зазором 1 тайл);
## avoid — уже занятые залы (зал босса и прихожая на 4-м этаже).
static func _carve_rooms(grid: Array[String], avoid: Array[Rect2i] = []) \
        -> Array[Rect2i]:
    var rooms: Array[Rect2i] = []
    var want := randi_range(10, 13)
    var guard := 0
    while rooms.size() < want and guard < 600:
        guard += 1
        var w := randi_range(6, 13)
        var h := randi_range(5, 9)
        var x := randi_range(1, MAP_W - w - 1)
        var y := randi_range(1, MAP_H - h - 1)
        var room := Rect2i(x, y, w, h)
        var overlaps := false
        for other in avoid:
            # Rect2i.grow (не «grows»): расширение на 1 тайл — зазор
            if room.grow(1).intersects(other.grow(1)):
                overlaps = true
                break
        if not overlaps:
            for other in rooms:
                if room.grow(1).intersects(other.grow(1)):
                    overlaps = true
                    break
        if overlaps:
            continue
        rooms.append(room)
        _carve_rect(grid, room)
    if rooms.is_empty():
        var fallback := Rect2i(2, 2, 9, 6)
        rooms.append(fallback)
        _carve_rect(grid, fallback)
    return rooms

## Самая дальняя от точки комната (для сокровищницы).
static func _farthest_room(rooms: Array[Rect2i], from: Vector2i) -> Rect2i:
    var best := rooms[0]
    var best_d := -1.0
    for i in range(1, rooms.size()):
        var d := float(_room_center(rooms[i]).distance_squared_to(from))
        if d > best_d:
            best_d = d
            best = rooms[i]
    return best

## Соединить комнаты последовательными Г-образными коридорами шириной 2
## плюс пара случайных петель, чтобы карта не была тупиковой цепочкой.
static func _connect_rooms(grid: Array[String], rooms: Array[Rect2i]) -> void:
    for i in range(1, rooms.size()):
        var a := _room_center(rooms[i - 1])
        var b := _room_center(rooms[i])
        _carve_l_corridor(grid, a, b)
    if rooms.size() >= 4:
        var extra := randi_range(2, 4)
        for i in range(extra):
            var a := _room_center(rooms[randi() % rooms.size()])
            var b := _room_center(rooms[randi() % rooms.size()])
            if a != b:
                _carve_l_corridor(grid, a, b)

static func _carve_l_corridor(grid: Array[String], a: Vector2i, b: Vector2i) -> void:
    var x := a.x
    var y := a.y
    # горизонтальный ход: пара клеток по вертикали (ширина 2)
    while x != b.x:
        _carve_pair_h(grid, x, y)
        if x < b.x:
            _carve_pair_h(grid, x + 1, y)
        x += 1 if x < b.x else -1
    # вертикальный ход: пара клеток по горизонтали (ширина 2 — иначе
    # реквизит или колонна замуруют единственный путь, шаг 15)
    while y != b.y:
        _carve_pair_v(grid, x, y)
        if y < b.y:
            _carve_pair_v(grid, x, y + 1)
        y += 1 if y < b.y else -1
    _carve_pair_v(grid, x, y)

## Клетка горизонтального коридора + клетка под ней (ширина коридора 2).
static func _carve_pair_h(grid: Array[String], x: int, y: int) -> void:
    _set_cell(grid, Vector2i(x, y), ".")
    if y + 1 < MAP_H - 1:
        _set_cell(grid, Vector2i(x, y + 1), ".")

## Клетка вертикального коридора + клетка справа (ширина коридора 2).
static func _carve_pair_v(grid: Array[String], x: int, y: int) -> void:
    _set_cell(grid, Vector2i(x, y), ".")
    if x + 1 < MAP_W - 1:
        _set_cell(grid, Vector2i(x + 1, y), ".")

## Декор по теме этажа: колонны по углам больших комнат и рядами в широких
## залах; паутина, кости, кровь и светящиеся трещины на случайных полах.
static func _sprinkle_decor(grid: Array[String], rooms: Array[Rect2i],
        theme: Dictionary) -> void:
    for room in rooms:
        if room.size.x >= 7 and room.size.y >= 5:
            for corner in [Vector2i(1, 1), Vector2i(room.size.x - 2, 1),
                    Vector2i(1, room.size.y - 2),
                    Vector2i(room.size.x - 2, room.size.y - 2)]:
                var t: Vector2i = room.position + corner
                if randi() % 3 != 0 and String(grid[t.y][t.x]) == ".":
                    _set_cell(grid, t, "o")
        # широкие залы: колонны рядами (как в храме)
        if room.size.x >= 11 and room.size.y >= 7:
            var col_x := [room.position.x + 3, room.end.x - 4]
            for yy in range(room.position.y + 2, room.end.y - 2, 3):
                for xx in col_x:
                    var t2 := Vector2i(xx, yy)
                    if String(grid[t2.y][t2.x]) == ".":
                        _set_cell(grid, t2, "o")
    # мягкий декор: только на чистых полах, не на лестницах
    var counts := {"w": int(theme.get("webs", 8)),
        "b": int(theme.get("bones", 8)),
        "x": int(theme.get("blood", 8)),
        "g": int(theme.get("glow_n", 10))}
    for symbol in counts:
        var floors: Array[Vector2i] = []
        for y in range(MAP_H):
            for x in range(MAP_W):
                var t3 := Vector2i(x, y)
                if String(grid[t3.y][t3.x]) == ".":
                    floors.append(t3)
        var want: int = counts[symbol]
        var guard := 0
        var placed := 0
        while placed < want and not floors.is_empty() and guard < 500:
            guard += 1
            var idx := randi() % floors.size()
            var t4 := floors[idx]
            floors.remove_at(idx)
            _set_cell(grid, t4, symbol)
            placed += 1

## Гарантированный декор зала босса: жаровни в двух углах, трон за боссом.
## Заполняет hall_props и резервирует клетки (враги/сундуки их обходят).
static func _pick_hall_props(grid: Array[String], hall: Rect2i,
        boss_tile: Vector2i, spawn: Vector2i, up: Vector2i,
        hall_props: Array[Dictionary], reserved: Array[Vector2i]) -> void:
    var spots: Array[Dictionary] = [
        {"tile": Vector2i(hall.position.x + 2, hall.position.y + 2),
            "kind": "brazier"},
        {"tile": Vector2i(hall.end.x - 3, hall.end.y - 3),
            "kind": "brazier"},
    ]
    if boss_tile.x >= 0:
        spots.append({"tile": boss_tile + Vector2i(0, -3), "kind": "throne"})
    for spec in spots:
        var t: Vector2i = spec["tile"]
        if t == spawn or t == up or not _open_floor(grid, t):
            continue
        if reserved.has(t):
            continue
        hall_props.append(spec)
        reserved.append(t)

## Враги этажа: {"tile": Vector2i, "id": String, "elite": bool}.
## Этаж босса: часть миньонов в самом зале (не вплотную к боссу),
## остальные по обычным комнатам; прихожая всегда тихая.
static func _pick_foe_spawns(grid: Array[String], rooms: Array[Rect2i],
        spawn: Vector2i, _down: Vector2i, boss_tile: Vector2i,
        vault: Rect2i, vault_center: Vector2i, floor_num: int,
        is_boss_floor: bool, reserved: Array[Vector2i]) -> Array[Dictionary]:
    var spawns: Array[Dictionary] = []
    var pool: Array = pool_for_floor(floor_num)
    var free: Array[Vector2i] = []
    for i in range(rooms.size()):
        var room := rooms[i]
        # прихожая зала босса (rooms[1]) — тихая входная зона
        if is_boss_floor and i == 1:
            continue
        # сокровищница — территория хранителя: случайные враги туда
        # не попадают (и не забивают сундуками каждый угол)
        if not is_boss_floor and vault.size.x > 0 and room == vault:
            continue
        for y in range(room.position.y, room.end.y):
            for x in range(room.position.x, room.end.x):
                var t := Vector2i(x, y)
                if not _open_floor(grid, t) or reserved.has(t):
                    continue
                # в зале босса миньоны не подходят к трону вплотную (7 тайлов)
                if is_boss_floor and i == 0 and boss_tile.x >= 0 \
                        and t.distance_squared_to(boss_tile) <= 49:
                    continue
                free.append(t)
    var want := foe_count_for_floor(floor_num)
    # стартовая зона: на обычных этажах враги дальше 10 тайлов от входа,
    # на этаже босса — дальше 8 (зал большой, но прихожая должна быть тихой)
    var spawn_dist := 64 if is_boss_floor else 100
    var guard := 0
    while spawns.size() < want and not free.is_empty() and guard < 900:
        guard += 1
        var idx := randi() % free.size()
        var t := free[idx]
        free.remove_at(idx)
        if not _far_enough(grid, _tiles_of(spawns), t):
            continue
        if t.distance_squared_to(spawn) <= spawn_dist:
            continue
        spawns.append({"tile": t,
            "id": String(pool[randi() % pool.size()]), "elite": false})
    # элитные чемпионы: на этаже босса 1–2, на остальных 0–1
    var extra := randi_range(0, 1) if not is_boss_floor \
        else randi_range(1, 2)
    for i in range(mini(extra, spawns.size())):
        var pick := spawns[randi() % spawns.size()]
        pick["elite"] = true
    # хранитель сокровищницы: всегда элита, стоит в самой сокровищнице
    if not is_boss_floor and vault_center.x >= 0 and not spawns.is_empty():
        var best := Vector2i(-1, -1)
        var best_d := -1.0
        for y in range(vault.position.y, vault.end.y):
            for x in range(vault.position.x, vault.end.x):
                var t2 := Vector2i(x, y)
                if not _open_floor(grid, t2):
                    continue
                var d := float(t2.distance_squared_to(_room_center(vault)))
                if d > best_d:
                    best_d = d
                    best = t2
        if best.x >= 0:
            # если на этом тайле уже кто-то стоит — сдвинуть его некуда,
            # поэтому дубликат здесь допустим (враги не сталкиваются)
            var keeper := spawns[randi() % spawns.size()]
            keeper["tile"] = best
            keeper["elite"] = true
    return spawns

## Тайлы всех врагов из списка спавнов (для проверок дистанций).
static func _tiles_of(spawns: Array[Dictionary]) -> Array[Vector2i]:
    var out: Array[Vector2i] = []
    for s in spawns:
        out.append(s["tile"])
    return out

## Сундуки этажа (шаг 15): 2 в сокровищнице (этажи 1–3) или в двух углах
## зала босса (этаж 4), остальные 2–3 — по всем комнатам, вдали от спавна,
## лестниц, врагов (вплотную) и уже выбранных сундуков.
static func _pick_chest_tiles(grid: Array[String], rooms: Array[Rect2i],
        spawn: Vector2i, up: Vector2i, down: Vector2i, boss_tile: Vector2i,
        vault: Rect2i, vault_center: Vector2i,
        foe_spawns: Array[Dictionary], is_boss_floor: bool,
        hall: Rect2i, reserved: Array[Vector2i]) -> Array[Vector2i]:
    var chest_tiles: Array[Vector2i] = []
    var taken := _tiles_of(foe_spawns)
    if not is_boss_floor and vault_center.x >= 0:
        var vault_floors: Array[Vector2i] = []
        for y in range(vault.position.y, vault.end.y):
            for x in range(vault.position.x, vault.end.x):
                var t := Vector2i(x, y)
                if _open_floor(grid, t) and _far_enough(grid, taken, t):
                    vault_floors.append(t)
        for i in range(2):
            if vault_floors.is_empty():
                break
            var idx := randi() % vault_floors.size()
            chest_tiles.append(vault_floors[idx])
            taken.append(vault_floors[idx])
            vault_floors.remove_at(idx)
    if is_boss_floor and hall.size.x > 0:
        var corners: Array[Vector2i] = [
            Vector2i(hall.position.x + 2, hall.end.y - 3),
            Vector2i(hall.end.x - 3, hall.position.y + 2)]
        for t2 in corners:
            # угол зала — «охраняемый» сундук: главное — не на клетке врага,
            # реквизита-резерва или уже занятой позиции
            if not _open_floor(grid, t2) or reserved.has(t2):
                continue
            var on_foe := false
            for ft in _tiles_of(foe_spawns):
                if t2 == ft:
                    on_foe = true
                    break
            if on_foe or taken.has(t2):
                continue
            chest_tiles.append(t2)
            taken.append(t2)
    var floors_all: Array[Vector2i] = []
    for y in range(MAP_H):
        for x in range(MAP_W):
            var t3 := Vector2i(x, y)
            if _open_floor(grid, t3):
                floors_all.append(t3)
    var want := randi_range(CHESTS_MIN, CHESTS_MAX)
    # цель всегда «2 гарантированных + want рассыпанных» = 4–5 сундуков
    var guard := 0
    while chest_tiles.size() < want + 2 and not floors_all.is_empty() \
            and guard < 600:
        guard += 1
        var idx2 := randi() % floors_all.size()
        var t4 := floors_all[idx2]
        floors_all.remove_at(idx2)
        if t4 == spawn or t4 == up or t4 == down or t4 == boss_tile:
            continue
        if reserved.has(t4):
            continue
        if t4.distance_squared_to(spawn) <= 36:
            continue
        var on_foe := false
        for ft in _tiles_of(foe_spawns):
            if t4.distance_squared_to(ft) <= 4:
                on_foe = true
                break
        if on_foe or not _far_enough(grid, taken, t4):
            continue
        chest_tiles.append(t4)
        taken.append(t4)
    return chest_tiles

## Факелы: полы вплотную к стенам (свет «лампы на стене»), не на лестницах,
## сундуках, реквизите, врагах и не друг на друге (минимум 5 тайлов между).
static func _pick_torch_tiles(grid: Array[String], spawn: Vector2i,
        up: Vector2i, down: Vector2i, boss_tile: Vector2i,
        chest_tiles: Array[Vector2i], foe_spawns: Array[Dictionary],
        prop_tiles: Array[Dictionary]) -> Array[Vector2i]:
    var torches: Array[Vector2i] = []
    var walls_near: Array[Vector2i] = []
    var side_offsets: Array[Vector2i] = [Vector2i(0, -1), Vector2i(0, 1),
        Vector2i(-1, 0), Vector2i(1, 0)]
    for y in range(1, MAP_H - 1):
        for x in range(1, MAP_W - 1):
            var t := Vector2i(x, y)
            if not _open_floor(grid, t):
                continue
            var near_wall := false
            for off in side_offsets:
                var n: Vector2i = t + off
                if n.x < 0 or n.y < 0 or n.x >= MAP_W or n.y >= MAP_H:
                    continue
                if String(grid[n.y][n.x]) == "#":
                    near_wall = true
                    break
            if near_wall:
                walls_near.append(t)
    var want := randi_range(TORCHES_MIN, TORCHES_MAX)
    var guard := 0
    while torches.size() < want and not walls_near.is_empty() and guard < 800:
        guard += 1
        var idx := randi() % walls_near.size()
        var t2 := walls_near[idx]
        walls_near.remove_at(idx)
        if t2 == spawn or t2 == up or t2 == down or t2 == boss_tile:
            continue
        if t2.distance_squared_to(spawn) <= 25:
            continue
        var busy := false
        for ft in _tiles_of(foe_spawns):
            if t2 == ft:
                busy = true
                break
        for pt in prop_tiles:
            if t2 == (pt["tile"] as Vector2i):
                busy = true
                break
        for ct in chest_tiles:
            if t2 == ct or t2.distance_squared_to(ct) <= 9:
                busy = true
                break
        if busy:
            continue
        var crowded := false
        for ot in torches:
            if t2.distance_squared_to(ot) < 25:
                crowded = true
                break
        if crowded:
            continue
        torches.append(t2)
    return torches

## Реквизит этажа: {"tile": Vector2i, "kind": String}. Жаровни и трон зала
## босса ставятся отдельно (см. _pick_hall_props), здесь — рассыпанный:
## бочки/ящики/мешки в комнатах, кристаллы в сокровищнице.
static func _pick_prop_tiles(grid: Array[String], rooms: Array[Rect2i],
        spawn: Vector2i, up: Vector2i, down: Vector2i, boss_tile: Vector2i,
        chest_tiles: Array[Vector2i], foe_spawns: Array[Dictionary],
        floor_num: int, is_boss_floor: bool,
        hall: Rect2i, vault: Rect2i,
        reserved: Array[Vector2i]) -> Array[Dictionary]:
    var props: Array[Dictionary] = []
    var taken := _tiles_of(foe_spawns)
    taken.append_array(chest_tiles)
    taken.append(spawn)
    taken.append(up)
    if down.x >= 0:
        taken.append(down)
    if boss_tile.x >= 0:
        taken.append(boss_tile)

    # сокровищница: два кристалла по углам (фиолетовые — на 2-м этаже)
    if vault.size.x > 0:
        var crystal := "crystal" if floor_num != 2 else "crystal_violet"
        var offs: Array[Vector2i] = [Vector2i(2, 1), Vector2i(-2, -2)]
        for off in offs:
            var ct: Vector2i = _room_center(vault) + off
            if _open_floor(grid, ct) and not reserved.has(ct) \
                    and _far_enough(grid, taken, ct):
                props.append({"tile": ct, "kind": crystal})
                taken.append(ct)
    # рассыпанный реквизит по комнатам (кроме стартовой)
    var kinds: Array = ["barrel", "crate", "sacks"]
    if floor_num == 2:
        kinds = ["crystal_violet", "barrel", "crate"]
    elif floor_num == 3:
        kinds = ["sacks", "barrel", "lantern"]
    var want := randi_range(3, 6)
    var base := props.size()   # уже стоящие: кристаллы сокровищницы
    var guard := 0
    while props.size() < base + want and guard < 400:
        guard += 1
        var room := rooms[randi() % rooms.size()]
        if room == rooms[0]:
            continue
        var t2 := Vector2i(randi_range(room.position.x, room.end.x - 1),
            randi_range(room.position.y, room.end.y - 1))
        if reserved.has(t2):
            continue
        if not _open_floor(grid, t2) or not _far_enough(grid, taken, t2):
            continue
        props.append({"tile": t2, "kind": String(kinds[randi() % kinds.size()])})
        taken.append(t2)
    return props

static func _room_center(room: Rect2i) -> Vector2i:
    return room.position + room.size / 2

## Поставить символ, не трогая стены-границы карты.
static func _set_cell(grid: Array[String], t: Vector2i, symbol: String) -> void:
    if t.x <= 0 or t.y <= 0 or t.x >= MAP_W - 1 or t.y >= MAP_H - 1:
        return
    var row := grid[t.y]
    grid[t.y] = row.substr(0, t.x) + symbol + row.substr(t.x + 1)

## Слишком близко к уже занятым тайлам? (чтобы не кучковались)
static func _far_enough(_grid: Array[String], taken: Array[Vector2i],
        t: Vector2i) -> bool:
    for other in taken:
        if t.distance_squared_to(other) < 9:
            return false
    return true

````

#### `scripts/data/dungeon_bestiary.gd.uid`

````
uid://dch5ufdceb40m

````

#### `scripts/data/items.gd`

````gdscript
## База предметов «Dungeon Loot».
## Цены и эффекты, подтверждённые гейм-дизайном:
##   окорок 10 з. (+50 хп), пиво (+100 хп, -50 к попаданию на 2 хода),
##   меч 1000 з. (30 урона), большой меч 2000 з. (50 урона),
##   моргенштерн 5000 з. (100 урона).
## Напитки Глота (шаг 6): ряд растёт по цене И по лечению —
##   вода 5 з. (+20 хп) < морс 10 з. (+40 хп) < сок 15 з. (+60 хп) < пиво 25 з. (+100 хп).
## Магическое оружие Зорана (шаг 6): жезл 1200 з. (35), клинок инея 2500 з. (55),
##   скипетр кометы 6000 з. (110).
## Зелья Злуса (шаг 7): три размера, цена и эффект растут вместе с размером.
##   Лечение: малое 25 з. (+40 хп) < среднее 50 з. (+80) < большое 100 з. (+160).
##   Мана: малое 30 з. (+30) < среднее 60 з. (+60) < большое 120 з. (+120).
##   Мана-зелья пригодны только магу (проверяет Game.use_consumable).
## Шаг 12 (экипировка): новые типы "armor" (броня: +hp_bonus к максимуму ХП,
## носят все) и "robe" (магические одеяния: +mana_bonus к максимуму маны
## и немного +hp_bonus; надевает только маг). У оружия с ключом "magic": true
## есть "volley" — параметры магического залпа мага на Q (см. Game.spell_info).
## Значения с пометкой ЗАГЛУШКА — временные, уточняются с автором проекта.
## icon — иконка для инвентаря, desc — короткое описание (тултип в сумке).
## Торговля (шаг 5): price — цена покупки у NPC, sell_price — половина цены
## (см. SELL_FACTOR). Предметы с price < 0 (фиолетовые уники) не продаются.
class_name ItemDB
extends RefCounted

const ICON_DIR := "res://assets/sprites/icons/"
## Доля цены покупки, за которую NPC готовы выкупить предмет у героя.
const SELL_FACTOR := 0.5

const ITEMS: Dictionary = {
    "ham": {
        "title": "Окорок", "type": "food",
        "price": 10, "heal": 50,
        "desc": "Восстанавливает 50 HP. Рецепт Гуры — пальчики оближешь.",
    },
    "water": {
        "title": "Вода", "type": "drink",
        "price": 5, "heal": 20,
        "desc": "Восстанавливает 20 HP. Ключница космоса, чистая и бодрая.",
    },
    "mors": {
        "title": "Морс", "type": "drink",
        "price": 10, "heal": 40,
        "desc": "Восстанавливает 40 HP. Брусника с поля за оградой мира.",
    },
    "juice": {
        "title": "Сок", "type": "drink",
        "price": 15, "heal": 60,
        "desc": "Восстанавливает 60 HP. Солнечный апельсин из оранжереи замка.",
    },
    "beer": {
        "title": "Пиво", "type": "drink",
        "price": 25,
        "heal": 100,
        "debuff": {"hit_chance": -50, "turns": 2},
        "desc": "Восстанавливает 100 HP, но -50 к попаданию на 2 хода.",
    },
    "sword": {
        "title": "Меч", "type": "weapon",
        "price": 1000, "damage": 30,
        "desc": "30 урона. Надёжный клинок для первых данжей.",
    },
    "greatsword": {
        "title": "Большой меч", "type": "weapon",
        "price": 2000, "damage": 50,
        "desc": "50 урона. Двуручный, рубит с плеча.",
    },
    "morgenstern": {
        "title": "Моргенштерн", "type": "weapon",
        "price": 5000, "damage": 100,
        "desc": "100 урона. Спорах не увернёшься.",
    },
    # --- магическое оружие Зорана (шаг 6; шаг 12 — флаг magic и залп для мага);
    # цены и параметры залпов — ЗАГЛУШКИ ---
    "wand_lightning": {
        "title": "Жезл молний", "type": "weapon", "magic": true,
        "price": 1200, "damage": 35,
        "volley": {
            "title": "Залп молний", "count": 3, "spread_deg": 14.0,
            "damage": 10, "mana": 15, "speed": 300.0, "range_px": 170.0,
            "cooldown": 0.45, "color": [1.0, 0.88, 0.4], "size": 1.0,
        },
        "desc": "35 урона. Бьёт искрой туда, куда смотрит хозяин. Залп молний на Q (у мага).",
    },
    "blade_frost": {
        "title": "Клинок инея", "type": "weapon", "magic": true,
        "price": 2500, "damage": 55,
        "volley": {
            "title": "Залп инея", "count": 3, "spread_deg": 12.0,
            "damage": 12, "mana": 16, "speed": 260.0, "range_px": 160.0,
            "cooldown": 0.5, "color": [0.62, 0.86, 1.0], "size": 1.0,
        },
        "desc": "55 урона. Лезвие всегда холодное, раны не греются. Залп инея на Q (у мага).",
    },
    "scepter_comet": {
        "title": "Скипетр кометы", "type": "weapon", "magic": true,
        "price": 6000, "damage": 110,
        "volley": {
            "title": "Кометный залп", "count": 1, "spread_deg": 0.0,
            "damage": 40, "mana": 25, "speed": 220.0, "range_px": 210.0,
            "cooldown": 0.6, "color": [0.78, 0.6, 1.0], "size": 1.8,
        },
        "desc": "110 урона. Осколок хвоста кометы на золотом древке. Кометный залп на Q (у мага).",
    },
    # --- броня Вираса (шаг 12): +hp_bonus к максимуму ХП, носит любой герой;
    # цены и бонусы — ЗАГЛУШКИ ---
    "armor_leather": {
        "title": "Кожаный доспех", "type": "armor",
        "price": 40, "hp_bonus": 10,
        "desc": "+10 к максимуму ХП. Пахнет гарью, но держит удар.",
    },
    "armor_chain": {
        "title": "Кольчуга", "type": "armor",
        "price": 90, "hp_bonus": 20,
        "desc": "+20 к максимуму ХП. Кольца звенят шёпотом мёртвых кузнецов.",
    },
    "armor_plate": {
        "title": "Латный доспех", "type": "armor",
        "price": 180, "hp_bonus": 35,
        "desc": "+35 к максимуму ХП. Внутри холодно, будто тебя уже схоронили.",
    },
    # --- магические одеяния Зорана (шаг 12): +мана и немного ХП, только магу;
    # цены и бонусы — ЗАГЛУШКИ ---
    "robe_faded": {
        "title": "Выцветшая мантия", "type": "robe",
        "price": 35, "mana_bonus": 10, "hp_bonus": 3,
        "desc": "+10 к максимуму маны, +3 к ХП. Ткань помнит чужие сны. Только для Мага.",
    },
    "robe_stars": {
        "title": "Мантия звёздочёта", "type": "robe",
        "price": 90, "mana_bonus": 20, "hp_bonus": 6,
        "desc": "+20 к максимуму маны, +6 к ХП. Созвездия на подоле не совпадают с картами. Только для Мага.",
    },
    "robe_void": {
        "title": "Одеяние Пустоты", "type": "robe",
        "price": 170, "mana_bonus": 35, "hp_bonus": 10,
        "desc": "+35 к максимуму маны, +10 к ХП. Сшито из куска самой Пустоты. Только для Мага.",
    },
    # --- зелья Злуса (шаг 7): три размера, цена и эффект растут с размером ---
    "hp_potion_small": {
        "title": "Малое зелье лечения", "type": "potion",
        "price": 25, "heal": 40,
        "desc": "Восстанавливает 40 HP. Маленький флакон варки Злуса.",
    },
    "hp_potion": {
        "title": "Зелье лечения", "type": "potion",
        "price": 50, "heal": 80,
        "desc": "Восстанавливает 80 HP. Средний размер — классика Злуса.",
    },
    "hp_potion_large": {
        "title": "Большое зелье лечения", "type": "potion",
        "price": 100, "heal": 160,
        "desc": "Восстанавливает 160 HP. Большой флакон, хватит на весь данж.",
    },
    "mana_potion_small": {
        "title": "Малое зелье маны", "type": "potion",
        "price": 30, "mana": 30,
        "desc": "Восстанавливает 30 маны. Только для мага.",
    },
    "mana_potion": {
        "title": "Зелье маны", "type": "potion",
        "price": 60, "mana": 60,
        "desc": "Восстанавливает 60 маны. Почти полная фляга силы, только для мага.",
    },
    "mana_potion_large": {
        "title": "Большое зелье маны", "type": "potion",
        "price": 120, "mana": 120,
        "desc": "Восстанавливает 120 маны. Запас на целую битву, только для мага.",
    },
    # --- фиолетовые уники для ежедневного бонуса (ЗАГЛУШКИ, составим позже);
    # шаг 12: у уников появились бонусы и залп — как у обычной экипировки ---
    "star_blade": {
        "title": "Звёздный клинок", "type": "weapon", "violet": true, "magic": true,
        "price": -1, "damage": 120,
        "volley": {
            "title": "Звёздный залп", "count": 5, "spread_deg": 20.0,
            "damage": 14, "mana": 22, "speed": 320.0, "range_px": 200.0,
            "cooldown": 0.55, "color": [1.0, 0.95, 0.62], "size": 1.0,
        },
        "desc": "120 урона. Выкован из осколка кометы. Звёздный залп на Q (у мага).",
    },
    "abyss_cloak": {
        "title": "Плащ бездны", "type": "armor", "violet": true,
        "price": -1, "hp_bonus": 25, "mana_bonus": 15,
        "desc": "+25 к максимуму ХП, +15 к максимуму маны. Плащ, сшитый из самой тьмы космоса.",
    },
    "comet_elixir": {
        "title": "Эликсир кометы", "type": "potion", "violet": true,
        "price": -1, "heal": 200,
        "desc": "Восстанавливает 200 HP. Светится, как хвост кометы.",
    },
}

## Типы предметов, которые герой может использовать из сумки (шаг 6):
## еда/питьё/зелье восстанавливают HP (см. heal).
const USABLE_TYPES: Array[String] = ["food", "drink", "potion"]

## Типы экипировки (шаг 12): weapon — в руки (игрок любого класса),
## armor — на тело (+ХП), robe — одеяние мага (+мана и немного ХП).
const EQUIP_TYPES: Array[String] = ["weapon", "armor", "robe"]

## Фиолетовая добыча (самая редкая, выпадает из ежедневного бонуса).
const VIOLET_UNIQUES: Array[String] = ["star_blade", "abyss_cloak", "comet_elixir"]

static func get_item(id: String) -> Dictionary:
    return ITEMS.get(id, {})

static func title(id: String) -> String:
    return String(ITEMS.get(id, {}).get("title", id))

## Цена покупки у торговца. Отрицательная — предмет не продаётся (уник).
static func price(id: String) -> int:
    return int(ITEMS.get(id, {}).get("price", -1))

## Цена продажи торговцу: половина цены покупки, минимум 1 золото.
## Возвращает 0, если предмет продать нельзя (уники и безымянная добыча).
static func sell_price(id: String) -> int:
    var base := price(id)
    if base <= 0:
        return 0
    return maxi(1, int(floor(float(base) * SELL_FACTOR)))

static func desc(id: String) -> String:
    return String(ITEMS.get(id, {}).get("desc", ""))

## Урон предмета (у оружия). 0 — предмет не является оружием или не бьёт.
static func damage(id: String) -> int:
    return int(ITEMS.get(id, {}).get("damage", 0))

## Сколько маны восстанавливает предмет (у мана-зелий). 0 — ману не даёт.
static func mana_restored(id: String) -> int:
    return int(ITEMS.get(id, {}).get("mana", 0))

## Бонус к максимуму ХП (у брони и одеяний, шаг 12). 0 — бонуса нет.
static func hp_bonus(id: String) -> int:
    return int(ITEMS.get(id, {}).get("hp_bonus", 0))

## Бонус к максимуму маны (у одеяний и уникального плаща, шаг 12).
static func mana_bonus(id: String) -> int:
    return int(ITEMS.get(id, {}).get("mana_bonus", 0))

## Магическое ли оружие (шаг 12): варвару такое не достаётся,
## маг бьёт им в полную силу и получает залп на Q,
## остальные герои получают небольшой магический эффект (см. Game).
static func is_magic(id: String) -> bool:
    return bool(ITEMS.get(id, {}).get("magic", false))

## Параметры магического залпа оружия (у магического оружия).
## Пустой словарь — залпа нет (обычная сталь).
static func volley(id: String) -> Dictionary:
    var v: Variant = ITEMS.get(id, {}).get("volley", {})
    return v if v is Dictionary else {}

## Путь к иконке предмета (пустая строка — рисуем мешочек цвета качества).
static func icon(id: String) -> String:
    if ITEMS.has(id):
        return ICON_DIR + id + ".png"
    return ""

static func random_violet_unique() -> String:
    return VIOLET_UNIQUES[randi() % VIOLET_UNIQUES.size()]

````

#### `scripts/data/items.gd.uid`

````
uid://ds6nfojb4o5h5

````

#### `scripts/data/world_map.gd`

````gdscript
## Карта мира «Dungeon Loot» (шаг 4): замок + двор + край мира с космосом.
## Сгенерировано скриптом gen_worldmap.py — вручную не править,
## правки вносить в генератор и перегенерировать.
class_name WorldMap
extends RefCounted

const MAP_W := 30
const MAP_H := 56
const RAILING_ROW := 46
const CASTLE_LAST_ROW := 19
const TILE_SIZE := 16
const SOLID_TILES := "#BDFRWkf"
const PLAYER_SPAWN := Vector2(14, 13)

## Символ -> координата в атласе assets/tilesets/world_tiles.png
const TILE_ATLAS := {
    "#": Vector2i(0, 0),
    "W": Vector2i(2, 0),
    "D": Vector2i(3, 0),
    "k": Vector2i(4, 0),
    "B": Vector2i(5, 0),
    "F": Vector2i(6, 0),
    "R": Vector2i(7, 0),
    "c": Vector2i(0, 1),
    "m": Vector2i(1, 1),
    "p": Vector2i(2, 1),
    "d": Vector2i(3, 1),
    ",": Vector2i(4, 1),
    ".": Vector2i(5, 1),
    "g": Vector2i(6, 1),
    "V": Vector2i(7, 1),
    "f": Vector2i(0, 2),
    "s": Vector2i(1, 2),
    "1": Vector2i(2, 2),
    "2": Vector2i(3, 2),
    "3": Vector2i(4, 2),
    "4": Vector2i(5, 2),
    "5": Vector2i(6, 2),
    "6": Vector2i(7, 2),
}

const MAP: Array[String] = [
        "##W#DD#####DD#W##DD#W###DD#W##",
        "#cccccccccccccccccccccccccccc#",
        "#fccccccccccccccccccccccccccf#",
        "#cckcccccccccccccccccccccckcc#",
        "#cccccccccccccccccccccccccccc#",
        "#cccccccccccccccccccccccccccc#",
        "#cccccccccccccccccccccccccccc#",
        "#fccccccccccccccccccccccccccf#",
        "#cckcccccccccccccccccccccckcc#",
        "#cccccccccccccccccccccccccccc#",
        "#cccccccccccccccccccccccccccc#",
        "#fccccccccccccccccccccccccccf#",
        "#cccccccccccccccccccccccccccc#",
        "#cckcccccccccccccccccccccckcc#",
        "#ccccccccccmcmcmcmccccccccccc#",
        "#cccccccccccfcmcmcmfccccccccc#",
        "#ccccccccccmcppppmccccccccccc#",
        "#fccccccccccmppppcmcccccccccf#",
        "#ccccccccccmcppppmccccccccccc#",
        "#############pppp#############",
        "BBB,,,,,,.,,,dddd.,.,,.,,,,BBB",
        "BBB..,..g.,,,dddd,,,,,g,,,,BBB",
        "BBB,gg.,,,,,,dddd..,,,,.,,gBBB",
        "BBB.,,,.g..,.dddddddd,,.,.,BBB",
        "BBB.,.g,,,,.,dddddddd,,.,.gBBB",
        "BBB,,g..,g,,,dddddddd,,,,..BBB",
        "BBB,,g.,,.,,,dddddddd,..,g,BBB",
        "BBBg,,g.,.g,,dddddddd,g,..gBBB",
        "BBB,..,,.,,,,dddd,,...,,,.,BBB",
        "BBB,,,,.,,,,,dddd,,,,,,,,,,BBB",
        "BBB,,,,.,,,,,dddd,,,,.,.,,gBBB",
        "BBB,,,,g.,,..dddd,,,,,,.,,,BBB",
        "BBB,,,,.,,,,,ddddg.,g.,,,,,BBB",
        "BBB,,..,.,,,,dddd..,.,g..,,BBB",
        "FF,,,,,.,..,,dddd..g,,,,g,,.FF",
        "FF,,.g,,g,,,,dddd,,.,,,,.,,,FF",
        "FF,,.,,g.g,,,dddd.,.,..,..,,FF",
        "FF,,,,,..,.,,dddd,,,.g,,.,,,FF",
        "FF,.,,,.,,g,,dddd,,.,g,,.,.gFF",
        "FF,,,..,,.,..dddd.,.g,.,.,..FF",
        "FF,ggg,..,,,,dddd,,.,,,..,.,FF",
        "FF,..,..,g,.gdddd,..,,,.,,,,FF",
        "FF....,,,...,dddd,,..,,,.,,gFF",
        "FF,.,,.g,g..,dddd.,,,,,g,,,,FF",
        "FF.,,,,g,,,,,ddddg,.g,.g,,.,FF",
        "FF,.,,,g,,,,,dddd.,,.g..g..,FF",
        "RRRRRRRRRRRRRRRRRRRRRRRRRRRRRR",
        "2262635V24V6V1V13V6122VV32V4VV",
        "VVV4V54V66V6116V2641653V31VV2V",
        "131V2142664VV543VV32234VV665VV",
        "V13V2VV323V1VV45VV534V1V5V36V2",
        "461VV5VV213V4VV3VV43VVV4VV4266",
        "615VVV65VVVVVVV24252V45VV22263",
        "5V24VV45V3V43VV424VV6312446153",
        "55556324511V46VVV1V6VVV34VV126",
        "VVVVV42VVVV4V251V56V261VV65V22",
]

## NPC: id, имя, роль, тайл, зона, лист спрайтов и портрет.
## goods (шаг 5) — список id товаров для торговли (см. ItemDB.ITEMS);
## NPC без ключа goods — просто собеседник (кнопки «ТОРГОВАТЬ» не будет).
## Шаг 6: в замке добавились Глот (напитки) и Зоран (магическое оружие).
## Шаг 7 (боевая система): у каждого NPC есть hp (ЗАГЛУШКИ — числа уточняются
## с автором): по нему бьёт удар (E) — см. world.gd; NPC, чьё хп упало до 0,
## умирает и до конца сессии не воскресает, остальные NPC это запоминают.
## Шаг 8: Таинственный демон у края улицы. scale — во сколько раз он крупнее
## обычного NPC (кадры 24x32 * scale); demon: true — не спавнится на старте
## мира, а появляется после первого убийства (см. world.gd: _spawn_demon).
## Шаг 12: после 3 ударов демон впадает в ярость и дерётся (см. world.gd).
## Ключа goods у демона нет: его ассортимент — товары убитых торговцев
## (Game.demon_goods), цены со скидкой -10% за каждого убитого NPC
## (Game.demon_price). hp демона — ЗАГЛУШКА.
const NPCS: Array[Dictionary] = [
        {"id": "zlus", "name": "Злус", "role": "Придворный маг", "tile": Vector2(5, 5), "zone": "castle", "sheet": "res://assets/sprites/chars/zlus.png", "portrait": "res://assets/sprites/portraits/zlus.png", "goods": ["hp_potion_small", "hp_potion", "hp_potion_large", "mana_potion_small", "mana_potion", "mana_potion_large"], "hp": 40},
        {"id": "lira", "name": "Лира", "role": "Хозяйка замка", "tile": Vector2(16, 15), "zone": "castle", "sheet": "res://assets/sprites/chars/lira.png", "portrait": "res://assets/sprites/portraits/lira.png", "hp": 30},
        {"id": "glot", "name": "Глот", "role": "Трактирщик", "tile": Vector2(22, 9), "zone": "castle", "sheet": "res://assets/sprites/chars/glot.png", "portrait": "res://assets/sprites/portraits/glot.png", "goods": ["water", "mors", "juice", "beer"], "hp": 50},
        {"id": "zoran", "name": "Зоран", "role": "Оружейный чародей", "tile": Vector2(8, 11), "zone": "castle", "sheet": "res://assets/sprites/chars/zoran.png", "portrait": "res://assets/sprites/portraits/zoran.png", "goods": ["wand_lightning", "blade_frost", "scepter_comet", "robe_faded", "robe_stars", "robe_void"], "hp": 80},
        {"id": "gura", "name": "Гура", "role": "Повар", "tile": Vector2(6, 29), "zone": "street", "sheet": "res://assets/sprites/chars/gura.png", "portrait": "res://assets/sprites/portraits/gura.png", "goods": ["ham"], "hp": 35},
        {"id": "viras", "name": "Вирас", "role": "Кузнец", "tile": Vector2(23, 31), "zone": "street", "sheet": "res://assets/sprites/chars/viras.png", "portrait": "res://assets/sprites/portraits/viras.png", "goods": ["sword", "greatsword", "morgenstern", "armor_leather", "armor_chain", "armor_plate"], "hp": 90},
        {"id": "demon", "name": "Таинственный демон", "role": "поклонник смелости", "tile": Vector2(15, 44), "zone": "street", "sheet": "res://assets/sprites/chars/demon.png", "portrait": "res://assets/sprites/portraits/demon.png", "scale": 3, "demon": true, "hp": 200},
]

const PROPS: Array[Dictionary] = [
        {"name": "arch", "tile": Vector2(13, 19), "w": 4, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/arch.png"},
        {"name": "throne", "tile": Vector2(13, 14), "w": 2, "h": 2, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/throne.png"},
        {"name": "brazier_l", "tile": Vector2(11, 16), "w": 1, "h": 2, "solid": true, "layer": "base", "anim": ["res://assets/sprites/props/brazier", 3, 5.0]},
        {"name": "brazier_r", "tile": Vector2(18, 16), "w": 1, "h": 2, "solid": true, "layer": "base", "anim": ["res://assets/sprites/props/brazier", 3, 5.5]},
        {"name": "stand_zlus", "tile": Vector2(6, 4), "w": 1, "h": 2, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/stand_zlus.png"},
        # шаг 6: лавка Глота (бочка с напитками) и кристаллы Зорана
        {"name": "barrel_glot", "tile": Vector2(23, 9), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/barrel.png"},
        {"name": "crystal_zoran_l", "tile": Vector2(7, 12), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal_violet", 2, 2.0]},
        {"name": "crystal_zoran_r", "tile": Vector2(10, 12), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal_violet", 2, 2.2]},
        {"name": "cart_gura", "tile": Vector2(7, 29), "w": 3, "h": 2, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/cart_gura.png"},
        {"name": "anvil", "tile": Vector2(22, 31), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/anvil.png"},
        {"name": "forge", "tile": Vector2(24, 31), "w": 2, "h": 2, "solid": true, "layer": "base", "anim": ["res://assets/sprites/props/forge", 3, 4.0]},
        {"name": "fountain", "tile": Vector2(17, 24), "w": 2, "h": 2, "solid": true, "layer": "base", "anim": ["res://assets/sprites/props/fountain", 3, 4.0]},
        {"name": "stall_red", "tile": Vector2(6, 33), "w": 3, "h": 2, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/stall_red.png"},
        {"name": "stall_blue", "tile": Vector2(21, 38), "w": 3, "h": 2, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/stall_blue.png"},
        {"name": "barrel_1", "tile": Vector2(4, 21), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/barrel.png"},
        {"name": "barrel_2", "tile": Vector2(26, 30), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/barrel.png"},
        {"name": "crate_1", "tile": Vector2(3, 30), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/crate.png"},
        {"name": "crate_2", "tile": Vector2(25, 22), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/crate.png"},
        {"name": "sacks_1", "tile": Vector2(9, 33), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/sacks.png"},
        {"name": "sacks_2", "tile": Vector2(5, 22), "w": 1, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/sacks.png"},
        {"name": "bench_1", "tile": Vector2(10, 26), "w": 2, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/bench.png"},
        {"name": "bench_2", "tile": Vector2(18, 39), "w": 2, "h": 1, "solid": true, "layer": "base", "texture": "res://assets/sprites/props/bench.png"},
        {"name": "banner_r1", "tile": Vector2(1, 2), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/banner_red.png"},
        {"name": "banner_b1", "tile": Vector2(28, 2), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/banner_blue.png"},
        {"name": "banner_b2", "tile": Vector2(1, 7), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/banner_blue.png"},
        {"name": "banner_r2", "tile": Vector2(28, 7), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/banner_red.png"},
        {"name": "banner_r3", "tile": Vector2(1, 12), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/banner_red.png"},
        {"name": "banner_b3", "tile": Vector2(28, 12), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/banner_blue.png"},
        {"name": "moon", "tile": Vector2(8, 49), "w": 1, "h": 1, "solid": false, "layer": "base", "texture": "res://assets/sprites/props/moon.png"},
        {"name": "planet", "tile": Vector2(7, 49), "w": 3, "h": 3, "solid": false, "layer": "base", "texture": "res://assets/sprites/props/planet.png"},
        {"name": "island_1", "tile": Vector2(21, 50), "w": 3, "h": 2, "solid": false, "layer": "base", "texture": "res://assets/sprites/props/island.png", "bob": Vector2(2.0, 4.0)},
        {"name": "island_2", "tile": Vector2(12, 52), "w": 3, "h": 2, "solid": false, "layer": "base", "texture": "res://assets/sprites/props/island.png", "bob": Vector2(3.0, 5.0)},
        {"name": "asteroid_1", "tile": Vector2(16, 48), "w": 1, "h": 1, "solid": false, "layer": "base", "texture": "res://assets/sprites/props/asteroid_1.png", "bob": Vector2(1.5, 3.0)},
        {"name": "asteroid_2", "tile": Vector2(26, 52), "w": 1, "h": 1, "solid": false, "layer": "base", "texture": "res://assets/sprites/props/asteroid_2.png", "bob": Vector2(2.0, 3.6)},
        {"name": "asteroid_3", "tile": Vector2(3, 53), "w": 1, "h": 1, "solid": false, "layer": "base", "texture": "res://assets/sprites/props/asteroid_1.png", "bob": Vector2(1.5, 3.2)},
        {"name": "torch_0", "tile": Vector2(3, 0), "w": 1, "h": 2, "solid": false, "layer": "over", "anim": ["res://assets/sprites/props/torch", 3, 6.0]},
        {"name": "torch_1", "tile": Vector2(8, 0), "w": 1, "h": 2, "solid": false, "layer": "over", "anim": ["res://assets/sprites/props/torch", 3, 6.0]},
        {"name": "torch_2", "tile": Vector2(15, 0), "w": 1, "h": 2, "solid": false, "layer": "over", "anim": ["res://assets/sprites/props/torch", 3, 6.0]},
        {"name": "torch_3", "tile": Vector2(21, 0), "w": 1, "h": 2, "solid": false, "layer": "over", "anim": ["res://assets/sprites/props/torch", 3, 6.0]},
        {"name": "torch_4", "tile": Vector2(26, 0), "w": 1, "h": 2, "solid": false, "layer": "over", "anim": ["res://assets/sprites/props/torch", 3, 6.0]},
        {"name": "crystal_0", "tile": Vector2(4, 41), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal", 2, 2.0]},
        {"name": "crystal_1", "tile": Vector2(25, 40), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal", 2, 2.0]},
        {"name": "crystal_2", "tile": Vector2(3, 44), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal", 2, 2.0]},
        {"name": "crystal_3", "tile": Vector2(21, 43), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal", 2, 2.0]},
        {"name": "crystal_4", "tile": Vector2(8, 44), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal_violet", 2, 2.0]},
        {"name": "crystal_5", "tile": Vector2(24, 43), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal_violet", 2, 2.0]},
        {"name": "crystal_6", "tile": Vector2(27, 38), "w": 1, "h": 2, "solid": false, "layer": "base", "anim": ["res://assets/sprites/props/crystal_violet", 2, 2.0]},
        {"name": "lantern_0", "tile": Vector2(12, 22), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/lantern.png"},
        {"name": "lantern_1", "tile": Vector2(18, 22), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/lantern.png"},
        {"name": "lantern_2", "tile": Vector2(12, 30), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/lantern.png"},
        {"name": "lantern_3", "tile": Vector2(18, 30), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/lantern.png"},
        {"name": "lantern_4", "tile": Vector2(12, 38), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/lantern.png"},
        {"name": "lantern_5", "tile": Vector2(18, 38), "w": 1, "h": 2, "solid": false, "layer": "over", "texture": "res://assets/sprites/props/lantern.png"},
]

const DOORS: Array[Dictionary] = [
        {"id": "dungeon_1", "tiles": [Vector2(4, 0), Vector2(5, 0)]},
        {"id": "dungeon_2", "tiles": [Vector2(11, 0), Vector2(12, 0)]},
        {"id": "dungeon_3", "tiles": [Vector2(17, 0), Vector2(18, 0)]},
        {"id": "dungeon_4", "tiles": [Vector2(24, 0), Vector2(25, 0)]},
]

````

#### `scripts/data/world_map.gd.uid`

````
uid://dtsaeqeli0snl

````

#### `scripts/loot.gd`

````gdscript
## Лут: качество добычи и таблицы предметов для данжей (шаг 14 — сундуки).
class_name Loot
extends RefCounted

## Шансы качества (вес из 100): серая — частая и слабая,
## фиолетовая — самая редкая и самая сильная.
const QUALITIES: Array[Dictionary] = [
    {"id": "gray", "title": "Серая", "hex": "#9aa0a6", "weight": 70},
    {"id": "green", "title": "Зелёная", "hex": "#4caf50", "weight": 20},
    {"id": "gold", "title": "Золотая", "hex": "#ffd700", "weight": 7},
    {"id": "violet", "title": "Фиолетовая", "hex": "#b388ff", "weight": 3},
]

## Случайный бросок качества по весам.
static func roll_quality() -> Dictionary:
    var total := 0
    for quality in QUALITIES:
        total += int(quality["weight"])
    var roll := randi_range(1, total)
    for quality in QUALITIES:
        roll -= int(quality["weight"])
        if roll <= 0:
            return quality
    return QUALITIES[0]

# --------------------------------------------- сундуки подземелий (шаг 14)

## Категории добычи из сундука и их веса (из 100). Все числа — ЗАГЛУШКИ:
## состав и шансы утверждает автор. Золото — чаще всего, питьё и зелья —
## на подъём, экипировка — реже, одеяния (только магу) — реже прочего.
const CHEST_TABLES: Array[Dictionary] = [
    {"id": "gold", "weight": 30},
    {"id": "potion", "weight": 22},
    {"id": "drink", "weight": 14},
    {"id": "weapon", "weight": 14},
    {"id": "armor", "weight": 12},
    {"id": "robe", "weight": 8},
]

## Качество экипировки из сундуков: сундуки щедрее обычных падений
## (серое 40, зелёное 30, золотое 20, фиолетовое 10 — ЗАГЛУШКИ).
const CHEST_QUALITY_TABLES: Array[Dictionary] = [
    {"id": "gray", "weight": 40},
    {"id": "green", "weight": 30},
    {"id": "gold", "weight": 20},
    {"id": "violet", "weight": 10},
]

## Пулы предметов по глубине этажа (шаг 15 — четыре этажа:
## 1 «early», 2–3 «mid», 4 «late»). Оружие: обычная сталь и магическое —
## у мага залп на Q. Зелья: у «late» изредка попадается фиолетовый
## эликсир кометы. Все составы — ЗАГЛУШКИ.
const CHEST_POOLS: Dictionary = {
    "weapon": {
        "early": ["sword", "wand_lightning"],
        "mid": ["wand_lightning", "greatsword", "blade_frost"],
        "late": ["greatsword", "blade_frost", "scepter_comet", "morgenstern"],
    },
    "armor": {
        "early": ["armor_leather"],
        "mid": ["armor_leather", "armor_chain"],
        "late": ["armor_chain", "armor_plate"],
    },
    "robe": {
        "early": ["robe_faded"],
        "mid": ["robe_faded", "robe_stars"],
        "late": ["robe_stars", "robe_void"],
    },
    "potion": {
        "early": ["hp_potion_small", "mana_potion_small"],
        "mid": ["hp_potion", "mana_potion"],
        "late": ["hp_potion_large", "mana_potion_large", "comet_elixir"],
    },
    "drink": {
        "early": ["water", "mors", "ham"],
        "mid": ["mors", "juice", "beer", "ham"],
        "late": ["juice", "beer", "ham"],
    },
}

## Золото из сундука: база растёт с глубиной этажа (ЗАГЛУШКА).
static func chest_gold(floor_num: int) -> int:
    return 10 + floor_num * 6 + randi_range(0, 14)

## Добыча из сундука (шаг 14). Возвращает {"gold": int} либо
## {"item_id": String, "quality": String}. Сундук всегда не пуст.
static func chest_loot(floor_num: int) -> Dictionary:
    var category := String(_weighted_pick(CHEST_TABLES).get("id", "gold"))
    var pools: Dictionary = CHEST_POOLS.get(category, {})
    if pools.is_empty():
        return {"gold": chest_gold(floor_num)}
    var item_id := _pick_id(_tier_pool(pools, floor_num))
    if item_id.is_empty():   # пустой пул — сундук отступает к золоту
        return {"gold": chest_gold(floor_num)}
    var quality := "gray"
    if category == "weapon" or category == "armor" or category == "robe":
        quality = String(_weighted_pick(CHEST_QUALITY_TABLES).get("id", "gray"))
    return {"item_id": item_id, "quality": quality}

## Пул «early» / «mid» / «late» для этажа: 1 — ранний, 2–3 — средний,
## 4 (этаж босса) — поздний.
static func _tier_pool(pools: Dictionary, floor_num: int) -> Array:
    var key := "early"
    if floor_num >= 4:
        key = "late"
    elif floor_num >= 2:
        key = "mid"
    return pools.get(key, pools.get("early", []))

## Случайный id из пула строк: пулы CHEST_POOLS — простые массивы id
## ("sword", "armor_chain", ...) без весов, поэтому _weighted_pick им не подходит.
static func _pick_id(pool: Array) -> String:
    if pool.is_empty():
        return ""
    return String(pool[randi() % pool.size()])

## Взвешенный выбор строки таблицы ({"id": ..., "weight": ...}).
static func _weighted_pick(table: Array) -> Dictionary:
    var total := 0
    for row in table:
        total += int((row as Dictionary).get("weight", 0))
    var roll := randi_range(1, maxi(1, total))
    for row in table:
        roll -= int((row as Dictionary).get("weight", 0))
        if roll <= 0:
            return row
    return table[0]

## ------------------------------------------------ эпическое оружие босса

## Награда за босса данжа (шаг 14): случайное оружие из сильного пула
## золотого («эпического») качества. Обычный «Меч» в пул не входит:
## эпическая добыча обязана быть сильнее стартовой. Состав пула — ЗАГЛУШКА.
const EPIC_QUALITY := "gold"
const EPIC_WEAPONS: Array[String] = [
    "greatsword", "morgenstern", "wand_lightning", "blade_frost",
    "scepter_comet",
]

## Эпическая награда босса: {"item_id": ..., "quality": "gold"}.
static func epic_weapon_loot() -> Dictionary:
    return {"item_id": EPIC_WEAPONS[randi() % EPIC_WEAPONS.size()],
        "quality": EPIC_QUALITY}

````

#### `scripts/loot.gd.uid`

````
uid://4tqo4gypu13s

````

#### `scripts/ui/virtual_joystick.gd`

````gdscript
## Виртуальный джойстик «Dungeon Loot» (шаг 3, восстановлен в шаге 8).
## Тянешь палец (или мышь — emulate_mouse_from_touch включён) внутри круга —
## world.gd читает output как вектор движения (аналог Input.get_vector).
## Фикс шага 8: раньше world.gd искал класс через ClassDB.class_exists(),
## а скриптовые классы в ClassDB не видны — джойстик никогда не спавнился.
## Фикс шага 9 (Godot 4.7.2): class_name VirtualJoystick больше нельзя —
## в движке появился нативный класс VirtualJoystick, и скрипт падал с
## Parse Error «hides a native class». Имени класса больше нет вовсе:
## мир грузит скрипт по пути res://scripts/ui/virtual_joystick.gd и
## создаёт инстанс через GDScript.new() (см. world.gd: _build_joystick).
## Шаг 11: джойстик уменьшен (100 px в консоли, RADIUS 36) — консоль UI
## сжалась до 112 px, экран ходьбы стал больше.
extends Control

const RADIUS := 36.0
const THUMB := 13.0

var output := Vector2.ZERO
var _pressed := false
var _thumb := Vector2.ZERO

func _ready() -> void:
    _thumb = size / 2.0
    mouse_filter = Control.MOUSE_FILTER_STOP

func _input(event: InputEvent) -> void:
    # мышь и эмулированный из касания ввод покрывают и мобильные платформы
    if event is InputEventMouseButton \
            and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
        var mb := event as InputEventMouseButton
        if mb.pressed:
            if get_global_rect().has_point(mb.position):
                _pressed = true
                _update_thumb(mb.position)
        elif _pressed:
            _reset()
    elif event is InputEventMouseMotion and _pressed:
        _update_thumb((event as InputEventMouseMotion).position)

func _update_thumb(global_pos: Vector2) -> void:
    var offset := (global_pos - get_global_rect().get_center()).limit_length(RADIUS)
    _thumb = size / 2.0 + offset
    output = offset / RADIUS
    queue_redraw()

func _reset() -> void:
    _pressed = false
    output = Vector2.ZERO
    _thumb = size / 2.0
    queue_redraw()

func _exit_tree() -> void:
    output = Vector2.ZERO   # мир не должен уйти с зажатым направлением

func _draw() -> void:
    var center := size / 2.0
    draw_circle(center, RADIUS, Color(0.07, 0.08, 0.13, 0.55))
    draw_arc(center, RADIUS, 0.0, TAU, 40, Color(0.5, 0.42, 0.16, 0.9), 2.0, true)
    draw_circle(_thumb, THUMB, Color(0.85, 0.88, 0.94, 0.45))
    draw_arc(_thumb, THUMB, 0.0, TAU, 24, Color(1.0, 0.84, 0.0, 0.9), 2.0, true)

````

#### `scripts/ui/virtual_joystick.gd.uid`

````
uid://cyu3fryqh5di5

````

#### `scripts/ui_style.gd`

````gdscript
## Пиксельные стили UI: единый вид кнопок и панелей по всей игре.
class_name UiStyle
extends RefCounted

const COLOR_TEXT := Color(0.9, 0.92, 0.96)
const COLOR_GOLD := Color(1, 0.84, 0)

## Применяет пиксельный стиль к кнопке.
static func style_button(button: Button, font_size: int = 16) -> void:
    button.focus_mode = Control.FOCUS_NONE
    button.add_theme_font_size_override("font_size", font_size)
    button.add_theme_color_override("font_color", COLOR_TEXT)
    button.add_theme_color_override("font_hover_color", Color.WHITE)
    button.add_theme_color_override("font_pressed_color", COLOR_GOLD)
    button.add_theme_color_override("font_focus_color", Color.WHITE)
    button.add_theme_stylebox_override("normal", flat_style(Color(0.11, 0.12, 0.19), Color(0.55, 0.42, 0.1)))
    button.add_theme_stylebox_override("hover", flat_style(Color(0.15, 0.16, 0.25), COLOR_GOLD))
    button.add_theme_stylebox_override("pressed", flat_style(Color(0.07, 0.08, 0.12), COLOR_GOLD))
    button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())

## Тёмная плашка с рамкой и прямыми углами (пиксельный стиль).
static func flat_style(bg: Color, border: Color) -> StyleBoxFlat:
    var sb := StyleBoxFlat.new()
    sb.bg_color = bg
    sb.border_color = border
    sb.set_border_width_all(2)
    sb.content_margin_left = 10.0
    sb.content_margin_right = 10.0
    sb.content_margin_top = 8.0
    sb.content_margin_bottom = 8.0
    return sb

## Стиль панели (те же цвета, что и у кнопок, но просторнее).
static func panel_style() -> StyleBoxFlat:
    var sb := flat_style(Color(0.086, 0.094, 0.149), Color(0.85, 0.65, 0.13))
    sb.content_margin_left = 18.0
    sb.content_margin_right = 18.0
    sb.content_margin_top = 16.0
    sb.content_margin_bottom = 16.0
    return sb

````

#### `scripts/ui_style.gd.uid`

````
uid://d0gb2aedbmf7s

````

### Тесты

#### `tests/demon_test.gd`

````gdscript
## Тест демона (шаг 8; шаги 12/13): спавн Таинственного демона у края
## улицы после первого убийства, его реплики-обработка, товары и цены павших
## торговцев со скидкой -10% за каждого убитого NPC, запрет старых диалогов
## у живых NPC, лавка демона через UI (покупка со скидкой), ярость после
## трёх ударов (преследование, удары по герою, лавка закрыта), СБРОС ЯРОСТИ
## при возрождении героя (шаг 13), вечная смерть демона: жертвы оживают
## и забывают, демон больше не возвращается (сейв v6).
## Запуск: godot --headless --path . res://tests/demon_test.tscn
extends Node

var failed := 0

func check(name: String, condition: bool) -> void:
    if condition:
        print("  [OK] ", name)
    else:
        failed += 1
        print("  [ПРОВАЛ] ", name)

func find_npc(world: Node2D, npc_id: String) -> Dictionary:
    for npc in world._npcs:
        if String(npc["id"]) == npc_id:
            return npc
    return {}

func _ready() -> void:
    print("DEMON TEST: демон, скидки, лавка, память NPC")
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.meta["last_bonus_date"] = ""
    Game.meta["pending_gold"] = 0
    Game.meta["pending_items"] = []
    Game.save_meta()
    Platform.calls.clear()
    Game.new_run(1, "warrior")   # воин: моргенштерн бьёт ровно 100 (без множителей варвара)
    Game.add_gold(500)   # кошелёк на покупки у демона
    Platform.calls.clear()

    var world: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world)
    await get_tree().process_frame
    await get_tree().process_frame

    # --- до убийств: демона нет, товаров нет, скидки нет ---
    check("демона нет на старте мира", find_npc(world, "demon").is_empty())
    check("товаров у демона нет", Game.demon_goods().is_empty())
    check("скидка нулевая", Game.demon_discount_pct() == 0)
    check("уровень NPC в мире: только 6 жителей", world._npcs.size() == 6)

    # --- убиваем торговца Глота ударом (как в бою) ---
    var glot := find_npc(world, "glot")
    check("Глот найден", not glot.is_empty())
    world.player.position = (glot["node"] as Node2D).position + Vector2(-18, 0)
    world._facing = "side"
    world._player_sprite.flip_h = false
    Game.add_item({"item_id": "morgenstern", "title": "Моргенштерн", "quality": "gray"})
    check("моргенштерн в руках", Game.equip_weapon("morgenstern") and Game.strike_damage() == 100)
    world._strike_cd = 0.0
    world._strike()
    check("Глот убит одним ударом", bool(glot["dead"]) and Game.is_npc_dead("glot"))
    await get_tree().process_frame
    await get_tree().process_frame   # спавн демона отложен на кадр

    # --- демон появился у края улицы ---
    var demon := find_npc(world, "demon")
    check("демон появился после первого убийства", not demon.is_empty())
    check("демон втрое крупнее обычного NPC", int(demon["data"].get("scale", 1)) == 3 \
        and int(demon["max_hp"]) == 200)
    check("демон стоит у самого края улицы", int((demon["tile"] as Vector2).y) \
        >= WorldMap.RAILING_ROW - 3)
    check("товары Глота переехали к демону", Game.demon_goods() \
        == ["water", "mors", "juice", "beer"])
    check("скидка 10% за одну жертву", Game.demon_discount_pct() == 10)
    check("цена морса у демона 9 з. (было 10)", Game.demon_price("mors") == 9)
    check("цена пива у демона 23 з. (было 25, 22.5 округляется)", Game.demon_price("beer") == 23)
    check("buy_from_demon отказывает чужому товару", not Game.buy_from_demon("ham"))

    # --- реплики демона: он рад, а не пугается ---
    world.npc_say("demon")
    await get_tree().process_frame
    check("демон заговорил", world._dialogue.visible)
    check("имя демона в диалоге", world._dialogue._name_label.text.contains("демон"))
    check("демон радуется убийству", world._dialogue._text_label.text.contains("Хе-хе"))
    check("демон помнит имя жертвы", world._dialogue._lines.size() > 1 \
        and String(world._dialogue._lines[1]).contains("Глота"))
    check("демон зовёт торговать", world._dialogue._trade_button.visible)
    world._dialogue._close()
    await get_tree().process_frame

    # --- лавка демона: покупка со скидкой через UI ---
    world.npc_say("demon")
    await get_tree().process_frame
    world._dialogue._trade_button.pressed.emit()
    await get_tree().process_frame
    check("лавка демона открылась", world._trade_ui.visible and world._trade_ui._is_demon)
    check("в лавке демона 4 товара Глота", world._trade_ui._rows.get_child_count() == 4)
    var gold_before: int = Game.gold
    var mors_row: HBoxContainer = world._trade_ui._rows.get_child(1)   # морс второй
    var buy_btn: Button = null
    for child in mors_row.get_children():
        if child is Button and (child as Button).text == "КУПИТЬ":
            buy_btn = child
    check("кнопка КУПИТЬ у морса найдена", buy_btn != null \
        and not (buy_btn as Button).disabled)
    if buy_btn != null:
        buy_btn.pressed.emit()
        await get_tree().process_frame
    check("покупка у демона списала 9 з.", Game.gold == gold_before - 9)
    check("морс в сумке", String((Game.inventory.back() as Dictionary) \
        .get("item_id", "")) == "mors")
    world._trade_ui.close()
    await get_tree().process_frame

    # --- убиваем не-торговца Лиру: скидка растёт, товары не растут ---
    var lira := find_npc(world, "lira")
    world.player.position = (lira["node"] as Node2D).position + Vector2(-18, 0)
    world._facing = "side"
    world._player_sprite.flip_h = false
    world._strike_cd = 0.0
    world._strike()
    check("Лира убита", bool(lira["dead"]) and Game.is_npc_dead("lira"))
    await get_tree().process_frame
    check("скидка 20% за двух убитых", Game.demon_discount_pct() == 20)
    check("цена морса упала до 8 з.", Game.demon_price("mors") == 8)
    check("товаров у демона всё ещё 4 (Лира не торговала)", Game.demon_goods().size() == 4)
    check("демон не появился второй раз", world._npcs.size() == 7)   # 6 жителей + демон

    # --- старые диалоги пропали: у живых NPC только реплика про убийство ---
    world.npc_say("gura")
    await get_tree().process_frame
    check("старых реплик нет: только реакция", world._dialogue.visible \
        and world._dialogue._lines.size() == 1)
    check("реакция помнит обе жертвы", world._dialogue._text_label.text.contains("Глота") \
        and world._dialogue._text_label.text.contains("Лиру"))
    check("торговать с жителем нельзя", not world._dialogue._trade_button.visible)
    world._dialogue._close()
    await get_tree().process_frame

    # --- шаг 12: три удара по демону — ярость, преследование и удары по герою ---
    demon = find_npc(world, "demon")
    Game.add_item({"item_id": "sword", "title": "Меч", "quality": "gray"})
    check("меч в руках (30 урона у воина)", Game.equip_weapon("sword") \
        and Game.strike_damage() == 30)
    check("до ударов демон спокоен", not Game.demon_enraged and Game.demon_hits == 0)
    world.player.position = (demon["node"] as Node2D).position + Vector2(-20, 0)
    world._facing = "side"
    world._player_sprite.flip_h = false
    world._strike_cd = 0.0
    world._strike()
    check("первый удар: демон шепчет «Один», не в ярости", Game.demon_hits == 1 \
        and not Game.demon_enraged)
    world._strike_cd = 0.0
    world._strike()
    check("второй удар: счёт 2, демон всё ещё сдерживается", Game.demon_hits == 2 \
        and not Game.demon_enraged)
    world._strike_cd = 0.0
    world._strike()
    check("третий удар: демон в ярости и жив (200-90=110)", Game.demon_hits == 3 \
        and Game.demon_enraged and not bool(demon["dead"]) and int(demon["hp"]) == 110)
    await get_tree().process_frame
    world.npc_say("demon")
    await get_tree().process_frame
    check("в ярости демон грозит, а не торгует", world._dialogue.visible \
        and not world._dialogue._trade_button.visible \
        and world._dialogue._text_label.text.contains("Ты ударил меня"))
    world._dialogue._close()
    await get_tree().process_frame
    var hp_before: int = Game.hp
    var demon_dist_before: float = world.player.position.distance_to(
        (demon["node"] as Node2D).position)
    for _i in 150:
        await get_tree().physics_frame   # ~2.5 с: демон догоняет и бьёт когтями
    var demon_dist_after: float = world.player.position.distance_to(
        (demon["node"] as Node2D).position)
    check("демон преследует героя (в дистанции когтей)", demon_dist_after <= 34.0 \
        and demon_dist_after <= demon_dist_before)
    check("демон бьёт героя: хп упали", Game.hp < hp_before and Game.hp > 0)
    check("герой не умер от пары когтей (воин 50 хп)", not world._player_dead)

    # --- шаг 13: возрождение героя гасит ярость демона ---
    world._respawn_player()
    await get_tree().process_frame
    check("после возрождения ярость погасла", not Game.demon_enraged \
        and Game.demon_hits == 0)
    check("аура демона снята (спрайт снова белый)", \
        (demon["sprite"] as AnimatedSprite2D).modulate == Color.WHITE)
    check("демон вернулся к краю улицы", \
        (demon["node"] as Node2D).position.distance_to(\
            Vector2(15 * 16 + 8, 45 * 16 - 3)) < 8.0)
    var demon_dist_calm: float = world.player.position.distance_to(\
        (demon["node"] as Node2D).position)
    for _i in 60:
        await get_tree().physics_frame
    check("мирный демон не преследует героя", \
        world.player.position.distance_to((demon["node"] as Node2D).position) \
            >= demon_dist_calm - 4.0)

    # --- демон тоже смертен: добиваем моргенштерном (хп уже не восстановились) ---
    demon = find_npc(world, "demon")
    check("моргенштерн снова в руках (100 урона)", Game.equip_weapon("morgenstern") \
        and Game.strike_damage() == 100)
    world.player.position = (demon["node"] as Node2D).position + Vector2(-20, 0)
    world._facing = "side"
    world._player_sprite.flip_h = false
    world._strike_cd = 0.0
    world._strike()
    check("первый удар моргенштерном: 110 -> 10", not bool(demon["dead"]) \
        and int(demon["hp"]) == 10)
    world._strike_cd = 0.0
    world._strike()
    # Демон мёртв в мире, но в списке убитых его НЕТ: defeat_demon_permanently()
    # очищает dead_npcs (жертвы оживают и забывают), труп демона остаётся трупом.
    check("демон убит добиванием (труп, не жертва)", bool(demon["dead"]) \
        and not Game.is_npc_dead("demon"))
    await get_tree().process_frame

    # --- шаг 13: демон повержен НАВСЕГДА — жертвы оживают и забывают ---
    check("демон повержен навсегда (Game)", Game.demon_gone_forever() \
        and Game.demon_defeated)
    check("жертвы забыты: список убитых пуст", Game.dead_npcs.is_empty())
    check("скидка сброшена (жертв больше нет)", Game.demon_discount_pct() == 0)
    check("товаров у демона больше нет", Game.demon_goods().is_empty())
    check("сейв v6 хранит demon_defeated", int(Game.to_save_data().get("v", 0)) == 6 \
        and bool(Game.to_save_data().get("demon_defeated", false)))
    glot = find_npc(world, "glot")
    check("Глот ожил", not bool(glot["dead"]) and int(glot["hp"]) == 50)
    world.npc_say("glot")
    await get_tree().process_frame
    check("Глот забыл убийство: обычные реплики вернулись", world._dialogue.visible \
        and world._dialogue._lines.size() > 1)
    check("торговля с ожившим Глотом вернулась", world._dialogue._trade_button.visible)
    world._dialogue._close()
    await get_tree().process_frame
    world.npc_say("viras")
    await get_tree().process_frame
    check("Вирас тоже забыл: обычные реплики", world._dialogue.visible \
        and world._dialogue._lines.size() > 1)
    world._dialogue._close()
    await get_tree().process_frame
    # --- демон больше не вернётся, даже если снова убить NPC ---
    var gura_rec: Dictionary = find_npc(world, "gura")
    world.player.position = (gura_rec["node"] as Node2D).position + Vector2(-18, 0)
    world._facing = "side"
    world._player_sprite.flip_h = false
    world._strike_cd = 0.0
    world._strike()
    check("Гура убита уже после победы над демоном", bool(gura_rec["dead"]))
    await get_tree().process_frame
    await get_tree().process_frame
    var demon_after: Dictionary = find_npc(world, "demon")
    check("демон не вернулся после нового убийства", \
        demon_after.is_empty() or bool(demon_after.get("dead", true)))
    world.npc_say("demon")
    await get_tree().process_frame
    check("труп демона молчит и не торгует", not world._dialogue.visible)

    # --- новая игра воскрешает мир: демон исчезает вместе с памятью ---
    world.free()
    await get_tree().process_frame
    Game.new_run(2, "warrior")
    check("новая игра: убитых нет", Game.dead_npcs.is_empty())
    check("новая игра: удары демона забыты, ярость снята", Game.demon_hits == 0 \
        and not Game.demon_enraged)
    check("новая игра: демон снова жив (demon_defeated сброшен)", \
        not Game.demon_defeated)
    check("новая игра: товаров у демона нет", Game.demon_goods().is_empty())
    check("новая игра: скидки нет", Game.demon_discount_pct() == 0)
    var world2: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world2)
    await get_tree().process_frame
    await get_tree().process_frame
    check("в новом мире демона нет", find_npc(world2, "demon").is_empty())
    world2.free()
    await get_tree().process_frame

    if failed == 0:
        print("DEMON TEST: ВСЁ ОК")
        get_tree().quit(0)
    else:
        print("DEMON TEST: ПРОВАЛОВ: ", failed)
        get_tree().quit(1)

````

#### `tests/demon_test.gd.uid`

````
uid://qamdanm8auqp

````

#### `tests/demon_test.tscn`

````ini
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://tests/demon_test.gd" id="1_demon"]

[node name="DemonTest" type="Node"]
script = ExtResource("1_demon")

````

#### `tests/dungeon_test.gd`

````gdscript
## Тест подземелья (шаги 13–15): генерация 4 больших тематических этажей,
## пулы врагов по глубине, элитные чемпионы и хранитель сокровищницы,
## факелы/реквизит/мозаика/ковёр, лестница вниз заперта, пока враги живы,
## переход между этажами, босс 4-го этажа (Таинственный демон):
## мирен до диалога, узнаёт героя, если видели его у края мира, дерётся
## после реплик, при смерти — demon_defeated, ожившие NPC, данж пройден,
## выход в замок; после победы босса на 4-м этаже его больше нет.
## Запуск: godot --headless --path . res://tests/dungeon_test.tscn
extends Node

var failed := 0

func check(name: String, condition: bool) -> void:
    if condition:
        print("  [OK] ", name)
    else:
        failed += 1
        print("  [ПРОВАЛ] ", name)

func find_foe(world: Node2D, foe_id: String) -> Dictionary:
    for foe in world._foes:
        if String(foe["id"]) == foe_id and not bool(foe.get("dead", false)):
            return foe
    return {}

func _ready() -> void:
    print("DUNGEON TEST: этажи, враги, лестницы, босс, вечная смерть демона")
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.meta["last_bonus_date"] = ""
    Game.meta["pending_gold"] = 0
    Game.meta["pending_items"] = []
    Game.save_meta()
    Game.new_run(1, "warrior")

    # --- жертвы до подземелья: босс вернёт их к жизни ---
    Game.kill_npc("glot")
    Game.kill_npc("lira")
    check("до подземелья убиты двое жителей", Game.dead_npcs.size() == 2)

    # --- вход на 1-й этаж ---
    Game.dungeon_floor = 1
    var dungeon: Node2D = (load("res://scenes/dungeon/dungeon.tscn") as PackedScene).instantiate()
    add_child(dungeon)
    await get_tree().process_frame
    await get_tree().process_frame

    check("этаж 1 установлен в Game", Game.dungeon_floor == 1 \
        and dungeon._floor_num == 1)
    check("сетка этажа 64x48 сгенерирована", dungeon._grid.size() == DungeonBestiary.MAP_H \
        and String(dungeon._grid[0]).length() == DungeonBestiary.MAP_W)
    check("есть лестница наверх", not dungeon._stairs_up.is_empty())
    check("есть лестница вниз", not dungeon._stairs_down.is_empty())
    check("на этаже 7–9 врагов (шаг 15)", dungeon._foes.size() >= 7 \
        and dungeon._foes.size() <= 9)
    check("тема этажа — Смрадные катакомбы", \
        String(dungeon._theme.get("id", "")) == "catacombs")
    var pool_ok := true
    for foe in dungeon._foes:
        if String(foe["id"]) != "spider" and String(foe["id"]) != "snake":
            pool_ok = false   # на 1-м этаже только пауки и змеи (пул 1+этаж)
    check("на 1-м этаже только пауки и змеи", pool_ok)
    var spread_ok := true
    for foe in dungeon._foes:
        if (foe["node"] as Node2D).position.distance_to(dungeon.player.position) < 80.0:
            spread_ok = false
    check("враги не толпятся у спавна", spread_ok)
    var elite_found := false
    for foe in dungeon._foes:
        if bool(foe.get("elite", false)):
            elite_found = true
            check("элита крупнее и злее", int(foe["max_hp"]) \
                > int((foe["def"] as Dictionary)["hp"]) \
                and int(foe["dmg"]) > int((foe["def"] as Dictionary)["damage"]))
    check("на этаже есть элитный чемпион (хранитель)", elite_found)
    check("HUD показывает уровень 1/4", String(dungeon._hud_floor.text) \
        .contains("ур. 1/4"))
    check("HUD считает врагов", String(dungeon._hud_floor.text).contains("врагов"))

    # --- шаг 15: сундуки на этаже (4–5 шт.), сокровищница, реквизит, факелы ---
    check("на этаже 4–5 сундуков", dungeon._chests.size() >= 4 \
        and dungeon._chests.size() <= 5)
    var chest_floor_ok := true
    for chest in dungeon._chests:
        var ct: Vector2i = chest["tile"]
        if String(dungeon._grid[ct.y][ct.x]) in DungeonBestiary.SOLID:
            chest_floor_ok = false
        if (chest["sprite"] as Sprite2D).texture == null:
            chest_floor_ok = false
        if bool(chest.get("opened", true)):
            chest_floor_ok = false   # спавнятся закрытыми
    check("сундуки стоят на полу, закрыты, со спрайтом", chest_floor_ok)
    var mosaic_ok := false
    for y in range(DungeonBestiary.MAP_H):
        if mosaic_ok:
            break
        for x in range(DungeonBestiary.MAP_W):
            if String(dungeon._grid[y][x]) == "m":
                mosaic_ok = true
                break
    check("сокровищница из золотой мозаики на этаже", mosaic_ok)
    var torch_count := 0
    var prop_count := 0
    for child in dungeon._entities.get_children():
        if String(child.name).begins_with("Torch_"):
            torch_count += 1
        elif String(child.name).begins_with("Prop_"):
            prop_count += 1
    check("факелы на этаже (10–14)", torch_count >= 10 and torch_count <= 14)
    check("реквизит на этаже (>=3)", prop_count >= 3)
    var chest_gold_before: int = Game.gold
    var chest_inv_before: int = Game.inventory.size()
    dungeon._open_chest(dungeon._chests[0])
    await get_tree().process_frame
    check("сундук открылся (флаг и спрайт)", bool(dungeon._chests[0]["opened"])
        and (dungeon._chests[0]["sprite"] as Sprite2D).texture != null)
    check("сундук дал добычу (золото или предмет)", Game.gold > chest_gold_before \
        or Game.inventory.size() > chest_inv_before)
    var chest_gold_mid: int = Game.gold
    var chest_inv_mid: int = Game.inventory.size()
    dungeon._open_chest(dungeon._chests[0])
    check("повторное открытие сундука пусто", Game.gold == chest_gold_mid \
        and Game.inventory.size() == chest_inv_mid)

    # --- таблицы сундуков: на всех этажах только золото или РЕАЛЬНЫЙ предмет ---
    var loot_ok := true
    for floor_num in range(1, DungeonBestiary.FLOORS + 1):
        for _try in range(150):
            var roll: Dictionary = Loot.chest_loot(floor_num)
            if roll.has("item_id"):
                var iid := String(roll["item_id"])
                if iid.is_empty() or ItemDB.get_item(iid).is_empty():
                    loot_ok = false
                    print("    плохой дроп: этаж ", floor_num, " id=", iid)
            elif not roll.has("gold"):
                loot_ok = false
    check("таблицы сундуков дают золото или существующие предметы", loot_ok)
    var epic_ok := true
    for wid in Loot.EPIC_WEAPONS:
        if ItemDB.get_item(String(wid)).is_empty():
            epic_ok = false
    check("все эпические оружия босса существуют в ItemDB", epic_ok)

    # --- лестница вниз заперта, пока враги живы ---
    dungeon._use_stairs("_use_stairs_down")
    await get_tree().process_frame
    check("лестница вниз заперта при живых врагах", dungeon._floor_num == 1)

    # --- убиваем всех: тишина открывает путь; за убийство дают золото ---
    var gold_before: int = Game.gold
    for foe in dungeon._foes.duplicate():
        dungeon._hit_foe(foe, 999)
    check("все враги этажа мертвы", dungeon._stairs_open())
    check("за убийства начислено золото", Game.gold > gold_before)
    dungeon._use_stairs("_use_stairs_down")
    await get_tree().process_frame
    await get_tree().process_frame
    check("переход на этаж 2", dungeon._floor_num == 2 and Game.dungeon_floor == 2)
    check("этаж 2 перегенерирован: снова 8–10 врагов", dungeon._foes.size() >= 8 \
        and dungeon._foes.size() <= 10)
    check("тема этажа 2 — Пустотные чертоги", \
        String(dungeon._theme.get("id", "")) == "void_halls")
    check("игрок переставлен на новый спавн", dungeon.player != null)

    # --- этаж 4: обязательный босс и зал с жаровнями/троном/ковром ---
    dungeon._goto_floor(4)
    await get_tree().process_frame
    await get_tree().process_frame
    var boss: Dictionary = dungeon._boss_record()
    check("на 4-м этаже есть босс", not boss.is_empty())
    check("босс — демон с юга карты (лист 72x96, втрое крупнее)", \
        String(boss["def"]["sheet"]).contains("demon") \
        and int(boss["def"]["scale"]) == 3 and int(boss["max_hp"]) == 300)
    check("тема этажа 4 — Багровое логово", \
        String(dungeon._theme.get("id", "")) == "crimson_lair")
    var carpet_ok := false
    for y in range(DungeonBestiary.MAP_H):
        if carpet_ok:
            break
        for x in range(DungeonBestiary.MAP_W):
            if String(dungeon._grid[y][x]) == "p":
                carpet_ok = true
                break
    check("ковровая дорожка к трону есть", carpet_ok)
    var top_pool_ok := true
    for foe in dungeon._foes:
        if bool(foe.get("boss", false)):
            continue
        if String(foe["id"]) != "demon_swordsman" \
                and String(foe["id"]) != "demon_sorcerer":
            top_pool_ok = false
    check("миньоны 10-го этажа — высшие демоны", top_pool_ok)
    check("босс ещё мирен (до диалога)", not dungeon._boss_hostile)

    # --- диалог босса: демона не видели — он представляется ---
    dungeon._open_boss_dialog()
    await get_tree().process_frame
    check("босс заговорил", dungeon._dialogue.visible)
    check("роль незнакомца", String(dungeon._dialogue._role_label.text) \
        .contains("хозяин"))
    check("реплики незнакомца", String(dungeon._dialogue._lines[0]).contains("А вот и ты"))
    dungeon._dialogue._close()
    await get_tree().process_frame
    check("после диалога босс в ярости", dungeon._boss_hostile)

    # --- демон узнаёт героя, если мы видели его у края мира ---
    Game.mark_demon_seen()
    dungeon._open_boss_dialog()
    await get_tree().process_frame
    check("роль узнавшего", String(dungeon._dialogue._role_label.text) \
        .contains("узнавш"))
    check("реплики узнавания", String(dungeon._dialogue._lines[0]) \
        .contains("Ты помнишь меня"))
    dungeon._dialogue._close()
    await get_tree().process_frame

    # --- битва: босс преследует и бьёт ---
    boss = dungeon._boss_record()
    var hp_before: int = Game.hp
    dungeon.player.position = (boss["node"] as Node2D).position + Vector2(-60, 0)
    for _i in 150:
        await get_tree().physics_frame   # ~2.5 с: демон догоняет и бьёт
    # Воин (50 хп) за 2.5 с под боссом (12 ур.) и миньонами (15-17 ур.)
    # может и погибнуть — это честный исход: проверяем только, что босс бьёт.
    check("босс догнал героя и бьёт", Game.hp < hp_before)

    # --- победа над боссом ---
    boss = dungeon._boss_record()
    dungeon._hit_foe(boss, 9999)
    await get_tree().process_frame
    check("босс мёртв", bool(boss.get("dead", false)))
    check("демон повержен навсегда", Game.demon_gone_forever())
    check("данж 1 засчитан пройденным", "dungeon_1" in Game.dungeons_cleared)
    check("жертвы оживили и забыли (Глот и Лира)", Game.dead_npcs.is_empty())
    check("выход в замок появился", not dungeon._stairs_exit.is_empty())
    check("тайл выхода X в сетке", dungeon._grid[int(dungeon._stairs_exit["pos"].y / 16.0)] \
        [int(dungeon._stairs_exit["pos"].x / 16.0)] == "X")
    check("флаг победы на этаже", dungeon._boss_defeated_here)
    var epic_found := false
    for item in Game.inventory:
        if String(item.get("item_id", "")) in Loot.EPIC_WEAPONS \
                and String(item.get("quality", "")) == Loot.EPIC_QUALITY:
            epic_found = true
    check("за босса выпало эпическое оружие (золотое качество)", epic_found)
    var exit_free_of_chests := true
    for chest in dungeon._chests:
        if (chest["tile"] as Vector2i) == Vector2i(
            int(dungeon._stairs_exit["pos"].x / 16.0),
            int(dungeon._stairs_exit["pos"].y / 16.0)):
            exit_free_of_chests = false
    check("выход не встал на сундук", exit_free_of_chests)

    # --- после победы босса на 4-м этаже его больше нет ---
    dungeon._load_floor(4)
    await get_tree().process_frame
    await get_tree().process_frame
    check("на 4-м этаже больше нет босса", dungeon._boss_record().is_empty())
    check("выход в замок доступен сразу", not dungeon._stairs_exit.is_empty())
    check("спавн-страж на карте: демон не вернётся", Game.demon_gone_forever())

    dungeon.free()
    await get_tree().process_frame

    # --- сейв v6: demon_defeated переживает загрузку слота ---
    var data: Dictionary = Game.to_save_data()
    check("сейв v6 с demon_defeated", int(data.get("v", 0)) == 6 \
        and bool(data.get("demon_defeated", false)))
    Game.new_run(2, "warrior")
    check("новая игра: demon_defeated сброшен", not Game.demon_defeated)
    Game.load_save_data(data)
    check("загрузка слота: демон остаётся мёртвым", Game.demon_defeated)

    if failed == 0:
        print("DUNGEON TEST: ВСЁ ОК")
        get_tree().quit(0)
    else:
        print("DUNGEON TEST: ПРОВАЛОВ: ", failed)
        get_tree().quit(1)

````

#### `tests/dungeon_test.gd.uid`

````
uid://bc06wxu4n7r26

````

#### `tests/dungeon_test.tscn`

````ini
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://tests/dungeon_test.gd" id="1_dungeon_test"]

[node name="DungeonTest" type="Node"]
script = ExtResource("1_dungeon_test")

````

#### `tests/menu_test.gd`

````gdscript
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

````

#### `tests/menu_test.gd.uid`

````
uid://dmbyaotctf56p

````

#### `tests/menu_test.tscn`

````ini
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://tests/menu_test.gd" id="1_menu_test"]

[node name="MenuTest" type="Node"]
script = ExtResource("1_menu_test")

````

#### `tests/screenshot.gd`

````gdscript
## Съёмка скриншотов мира (шаг 6): тронная, диалог, двор, инвентарь,
## лавки торговцев (покупка/продажа), Глот, Зоран, маг в HUD, край мира.
## Запуск: xvfb-run godot --path . --rendering-driver opengl3 res://tests/screenshot.tscn
extends Node

func snap(path: String) -> void:
    await RenderingServer.frame_post_draw
    var img := get_viewport().get_texture().get_image()
    img.save_png(path)
    print("SHOT ", path)

func _ready() -> void:
    # чистый прогон для съёмки: новая игра в слоте 1
    Game.new_run(1, "barbarian")
    Platform.calls.clear()
    var world: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world)
    await get_tree().create_timer(0.8).timeout

    # тронная зала с Лирой
    world.player.position = Vector2(14.5 * 16.0, 18.2 * 16.0)
    await get_tree().create_timer(1.4).timeout
    await snap("/tmp/shot_throne.png")

    # диалог с Лирой
    world.npc_say("lira")
    await get_tree().create_timer(1.2).timeout
    await snap("/tmp/shot_dialogue.png")
    world._dialogue._close()

    # двор: фонтан и палатка
    world.player.position = Vector2(15.0 * 16.0, 28.0 * 16.0)
    await get_tree().create_timer(1.4).timeout
    await snap("/tmp/shot_yard.png")

    # рынок Гуры
    world.player.position = Vector2(8.0 * 16.0, 32.0 * 16.0)
    await get_tree().create_timer(1.4).timeout
    await snap("/tmp/shot_market.png")

    # инвентарь с предметами
    Game.add_item({"item_id": "star_blade", "title": "Звёздный клинок", "quality": "violet"})
    Game.add_item({"item_id": "comet_elixir", "title": "Эликсир кометы", "quality": "violet"})
    world._inventory_ui.open()
    await get_tree().create_timer(0.6).timeout
    await snap("/tmp/shot_inventory.png")
    world._inventory_ui.close()

    # --- торговля (шаг 5) ---
    # диалог Гуры с кнопкой ТОРГОВАТЬ
    world.npc_say("gura")
    await get_tree().create_timer(1.2).timeout
    await snap("/tmp/shot_trade_dialogue.png")
    world._dialogue.close()

    # лавка Гуры: покупка еды
    world._trade_ui.open({"name": "Гура", "role": "Повар", "goods": ["ham"]})
    await get_tree().create_timer(0.6).timeout
    await snap("/tmp/shot_trade_gura.png")

    # шаг 6: лавка Глота — растущий ряд напитков
    world.npc_say("glot")
    await get_tree().create_timer(1.0).timeout
    world._trade_ui.open({"name": "Глот", "role": "Трактирщик",
                          "goods": ["water", "mors", "juice", "beer"]})
    await get_tree().create_timer(0.6).timeout
    await snap("/tmp/shot_trade_glot.png")

    # шаг 6: лавка Зорана — магическое оружие
    world._trade_ui.open({"name": "Зоран", "role": "Оружейный чародей",
                          "goods": ["wand_lightning", "blade_frost", "scepter_comet"]})
    await get_tree().create_timer(0.6).timeout
    await snap("/tmp/shot_trade_zoran.png")

    # лавка Вираса: дорогое оружие варвару не по карману (кнопки неактивны)
    world._trade_ui.open({"name": "Вирас", "role": "Кузнец",
                          "goods": ["sword", "greatsword", "morgenstern"]})
    await get_tree().create_timer(0.6).timeout
    await snap("/tmp/shot_trade_viras.png")

    # вкладка ПРОДАЖА: выкуп вещей за половину цены
    world._trade_ui._tab_sell.pressed.emit()
    await get_tree().create_timer(0.4).timeout
    await snap("/tmp/shot_trade_sell.png")
    world._trade_ui.close()

    # край мира с планетой
    world.player.position = Vector2(15.0 * 16.0, 44.0 * 16.0)
    await get_tree().create_timer(1.4).timeout
    await snap("/tmp/shot_edge.png")

    # шаг 6: мир под магом — полосы хп и маны, кнопка МАГИЯ, снаряд
    world.queue_free()
    await get_tree().process_frame
    Game.new_run(1, "mage")
    var world_mage: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world_mage)
    await get_tree().create_timer(0.8).timeout
    world_mage.player.position = Vector2(14.0 * 16.0, 13.0 * 16.0)
    world_mage._cast_spell()
    await get_tree().create_timer(0.25).timeout
    await snap("/tmp/shot_mage_cast.png")
    await get_tree().create_timer(1.0).timeout

    # экран выбора героя (мир выгружаем, как при смене сцены)
    world_mage.queue_free()
    await get_tree().process_frame
    var select: Control = (load("res://scenes/character_select/character_select.tscn") as PackedScene).instantiate()
    add_child(select)
    select.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    await get_tree().create_timer(0.5).timeout
    await snap("/tmp/shot_select.png")

    get_tree().quit(0)

````

#### `tests/screenshot.gd.uid`

````
uid://v3fn1i0aqcu4

````

#### `tests/screenshot.tscn`

````ini
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://tests/screenshot.gd" id="1_shot"]

[node name="Screenshot" type="Node"]
script = ExtResource("1_shot")

````

#### `tests/shot_demon.gd`

````gdscript
## Съёмка скриншотов демона (шаг 8) для визуальной проверки.
## Запуск: xvfb-run godot --path . res://tests/shot_demon.tscn
extends Node

func _ready() -> void:
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.save_meta()
    Game.new_run(1, "warrior")
    var world: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world)
    await get_tree().process_frame
    await get_tree().process_frame
    # убиваем Глота, чтобы призвать демона
    var glot := {}
    for npc in world._npcs:
        if String(npc["id"]) == "glot":
            glot = npc
    world.player.position = (glot["node"] as Node2D).position + Vector2(-18, 0)
    world._facing = "side"
    world._player_sprite.flip_h = false
    Game.add_item({"item_id": "morgenstern", "title": "Моргенштерн", "quality": "gray"})
    Game.equip_weapon("morgenstern")
    world._strike_cd = 0.0
    world._strike()
    await get_tree().process_frame
    await get_tree().process_frame
    var demon := {}
    for npc in world._npcs:
        if String(npc["id"]) == "demon":
            demon = npc
    if demon.is_empty():
        print("NO DEMON SPAWNED")
        get_tree().quit(1)
        return
    print("DEMON AT: ", (demon["node"] as Node2D).position)
    # кадр 1: демон у края улицы
    world.player.position = (demon["node"] as Node2D).position + Vector2(-34, 14)
    world._facing = "side"
    world._player_sprite.flip_h = false
    await get_tree().create_timer(1.6).timeout
    var img := get_viewport().get_texture().get_image()
    img.save_png("user://demon_shot.png")
    print("SAVED world shot")
    # кадр 2: диалог демона с портретом и кнопкой ТОРГОВАТЬ
    world.npc_say("demon")
    await get_tree().create_timer(1.4).timeout
    img = get_viewport().get_texture().get_image()
    img.save_png("user://demon_dialog.png")
    print("SAVED dialog shot")
    # кадр 3: лавка демона со скидочными ценами
    world._dialogue._trade_button.pressed.emit()
    await get_tree().create_timer(0.8).timeout
    img = get_viewport().get_texture().get_image()
    img.save_png("user://demon_shop.png")
    print("SAVED shop shot")
    get_tree().quit(0)

````

#### `tests/shot_demon.gd.uid`

````
uid://b87hx58dndgc1

````

#### `tests/shot_demon.tscn`

````ini
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://tests/shot_demon.gd" id="1"]

[node name="ShotDemon" type="Node"]
script = ExtResource("1")

````

#### `tests/smoke_test.gd`

````gdscript
## Дымовой тест обвязки проекта. Запуск из папки проекта:
##   godot --headless --path . res://tests/smoke_test.tscn
## Проверяет автозагрузки, слоты сейвов, meta, героев, бонус,
## базу предметов и шансы лута. В конце восстанавливает исходное состояние.
extends Node

const ROLLS := 20000

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
    print("SMOKE: автозагрузки, слоты, герои, бонус, предметы, лут")
    snapshot()
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.meta["last_bonus_date"] = ""
    Game.meta["pending_gold"] = 0
    Game.meta["pending_items"] = []
    Game.current_slot = 0
    Game.save_meta()

    # --- золото и инвентарь ---
    var gold_before: int = Game.gold
    Game.add_gold(25)
    check("Game.add_gold", Game.gold == gold_before + 25)
    check("Game.spend_gold хватает", Game.spend_gold(10) and Game.gold == gold_before + 15)
    check("Game.spend_gold не уводит в минус", not Game.spend_gold(1000000))
    var items_before: int = Game.inventory.size()
    Game.add_item({"quality": "green", "title": "Зелёная"})
    check("Game.add_item", Game.inventory.size() == items_before + 1)

    # --- слоты Platform ---
    var data1 := {"v": 2, "hero_id": "warrior", "gold": 111, "inventory": [], "dungeons_cleared": []}
    check("Platform.save_data слот 1", Platform.save_data(data1, 1) == OK)
    var data2 := {"v": 2, "hero_id": "barbarian", "gold": 222, "inventory": [], "dungeons_cleared": []}
    check("Platform.save_data слот 2", Platform.save_data(data2, 2) == OK)
    check("Platform.has_slot(1,2)", Platform.has_slot(1) and Platform.has_slot(2))
    check("слоты изолированы", int(Platform.load_data(1).get("gold", 0)) == 111 \
        and int(Platform.load_data(2).get("gold", 0)) == 222)
    check("пустой слот 3", Platform.load_data(3).is_empty() and not Platform.has_slot(3))

    # --- meta Platform ---
    check("Platform.save_meta", Platform.save_meta({"settings": {"sound": true}}) == OK)
    check("Platform.load_meta", bool(Platform.load_meta().get("settings", {}).get("sound", false)))

    # --- настройки (теперь в meta) ---
    Game.set_setting("sound", false)
    check("Game.set_setting хранится в meta", \
        not bool((Platform.load_meta().get("settings", {}) as Dictionary).get("sound", true)))
    Game.set_setting("sound", true)

    # --- герои и новая игра ---
    check("HEROES: четыре героя", Game.HEROES.size() == 4 \
        and Game.HEROES.has("warrior") and Game.HEROES.has("barbarian") \
        and Game.HEROES.has("bum") and Game.HEROES.has("mage"))
    check("маг: хп 30 и мана 70 (числа автора)", \
        Game.hero_max_hp("mage") == 30 and Game.hero_max_mana("mage") == 70)
    check("стартовое золото: воин 100, варвар 50, бомж 1", \
        Game.hero_start_gold("warrior") == 100 and Game.hero_start_gold("barbarian") == 50 \
        and Game.hero_start_gold("bum") == 1)
    Game.new_run(1, "barbarian")
    check("new_run: сброс и герой", Game.gold == Game.hero_start_gold("barbarian") \
        and Game.inventory.is_empty() and Game.hero_id == "barbarian" and Game.current_slot == 1)
    check("to_save_data содержит героя", Game.to_save_data().get("hero_id", "") == "barbarian")
    check("new_run записал слот 1", Platform.has_slot(1) \
        and int(Platform.load_data(1).get("gold", -1)) == Game.hero_start_gold("barbarian"))
    check("meta.last_slot обновлён", int(Game.meta.get("last_slot", 0)) == 1)

    # --- выбор слота для новой игры ---
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    check("pick_new_slot: первый свободный", Game.pick_new_slot() == 1)
    Platform.save_data({"v": 2}, 1)
    check("pick_new_slot: обходит занятый", Game.pick_new_slot() == 2)
    Platform.save_data({"v": 2}, 2)
    Platform.save_data({"v": 2}, 3)
    Game.meta["last_slot"] = 3
    check("pick_new_slot: все заняты — последний", Game.pick_new_slot() == 3)

    # --- продолжить/загрузить ---
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.current_slot = 0
    check("continue_run на пустом слоте — false", not Game.continue_run(1))
    Game.gold = 500
    Game.hero_id = "warrior"
    Game.current_slot = 3
    Saves.request_save()
    Game.gold = 0
    Game.hero_id = "bum"
    check("continue_run грузит слот", Game.continue_run(3) and Game.gold == 500 \
        and Game.hero_id == "warrior" and Game.current_slot == 3)

    # --- база предметов (числа из дизайн-документа) ---
    var ham: Dictionary = ItemDB.get_item("ham")
    check("окорок: 10 з., +50 хп", int(ham.get("price", 0)) == 10 and int(ham.get("heal", 0)) == 50)
    var beer: Dictionary = ItemDB.get_item("beer")
    var beer_debuff: Dictionary = beer.get("debuff", {})
    check("пиво: +100 хп, -50 к попаданию на 2 хода", int(beer.get("heal", 0)) == 100 \
        and int(beer_debuff.get("hit_chance", 0)) == -50 and int(beer_debuff.get("turns", 0)) == 2)
    var sword: Dictionary = ItemDB.get_item("sword")
    check("меч: 1000 з., 30 урона", int(sword.get("price", 0)) == 1000 and int(sword.get("damage", 0)) == 30)
    var greatsword: Dictionary = ItemDB.get_item("greatsword")
    check("большой меч: 2000 з., 50 урона", int(greatsword.get("price", 0)) == 2000 and int(greatsword.get("damage", 0)) == 50)
    var morgenstern: Dictionary = ItemDB.get_item("morgenstern")
    check("моргенштерн: 5000 з., 100 урона", int(morgenstern.get("price", 0)) == 5000 and int(morgenstern.get("damage", 0)) == 100)
    check("зелье на хп есть", ItemDB.get_item("hp_potion").get("type", "") == "potion" \
        and ItemDB.get_item("hp_potion").has("heal"))
    var violet_id := ItemDB.random_violet_unique()
    check("фиолетовый уник в списке", violet_id in ItemDB.VIOLET_UNIQUES \
        and bool(ItemDB.get_item(violet_id).get("violet", false)))
    check("названия предметов на русском", ItemDB.title("ham") == "Окорок" \
        and ItemDB.title("morgenstern") == "Моргенштерн")

    # --- шаг 6: напитки Глота (ряд растёт по цене и хп) и магическое оружие ---
    check("вода: 5 з., +20 хп", ItemDB.price("water") == 5 \
        and int(ItemDB.get_item("water").get("heal", 0)) == 20)
    check("морс: 10 з., +40 хп", ItemDB.price("mors") == 10 \
        and int(ItemDB.get_item("mors").get("heal", 0)) == 40)
    check("сок: 15 з., +60 хп", ItemDB.price("juice") == 15 \
        and int(ItemDB.get_item("juice").get("heal", 0)) == 60)
    check("ряд напитков растёт по цене и хп", ItemDB.price("water") < ItemDB.price("mors") \
        and ItemDB.price("mors") < ItemDB.price("juice") \
        and ItemDB.price("juice") < ItemDB.price("beer") \
        and int(ItemDB.get_item("water").get("heal", 0)) < int(ItemDB.get_item("mors").get("heal", 0)) \
        and int(ItemDB.get_item("mors").get("heal", 0)) < int(ItemDB.get_item("juice").get("heal", 0)) \
        and int(ItemDB.get_item("juice").get("heal", 0)) < int(ItemDB.get_item("beer").get("heal", 0)))
    check("жезл молний: 1200 з., 35 урона", ItemDB.price("wand_lightning") == 1200 \
        and int(ItemDB.get_item("wand_lightning").get("damage", 0)) == 35)
    check("клинок инея: 2500 з., 55 урона", ItemDB.price("blade_frost") == 2500 \
        and int(ItemDB.get_item("blade_frost").get("damage", 0)) == 55)
    check("скипетр кометы: 6000 з., 110 урона", ItemDB.price("scepter_comet") == 6000 \
        and int(ItemDB.get_item("scepter_comet").get("damage", 0)) == 110)
    check("еда/питьё/зелья можно использовать", "food" in ItemDB.USABLE_TYPES \
        and "drink" in ItemDB.USABLE_TYPES and "potion" in ItemDB.USABLE_TYPES)

    # --- торговля (шаг 5): цены продажи — половина цены покупки ---
    check("продажа: окорок 5, пиво 12, меч 500", ItemDB.sell_price("ham") == 5 \
        and ItemDB.sell_price("beer") == 12 and ItemDB.sell_price("sword") == 500)
    check("продажа: большой меч 1000, моргенштерн 2500, зелье 25", \
        ItemDB.sell_price("greatsword") == 1000 and ItemDB.sell_price("morgenstern") == 2500 \
        and ItemDB.sell_price("hp_potion") == 25)
    check("продажа: вода 2, морс 5, сок 7", ItemDB.sell_price("water") == 2 \
        and ItemDB.sell_price("mors") == 5 and ItemDB.sell_price("juice") == 7)
    check("продажа: жезл 600, клинок инея 1250, скипетр 3000", \
        ItemDB.sell_price("wand_lightning") == 600 and ItemDB.sell_price("blade_frost") == 1250 \
        and ItemDB.sell_price("scepter_comet") == 3000)
    check("уники и несуществующие не продаются", ItemDB.sell_price("star_blade") == 0 \
        and ItemDB.sell_price("abyss_cloak") == 0 and ItemDB.sell_price("no_such_item") == 0)

    # --- торговля: покупка и продажа ---
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.current_slot = 0
    Game.new_run(1, "warrior")
    check("воин начал со 100 з.", Game.gold == 100)
    check("покупка окорока: 100 -> 90", Game.buy_item("ham") and Game.gold == 90)
    check("окорок оказался в сумке", not Game.inventory.is_empty() \
        and String((Game.inventory.back() as Dictionary).get("item_id", "")) == "ham")
    check("моргенштерн не по карману", not Game.buy_item("morgenstern") and Game.gold == 90)
    check("уник купить нельзя", not Game.buy_item("star_blade") \
        and not Game.buy_item("no_such_item"))
    check("продажа окорока: +5 з.", Game.sell_item(Game.inventory.size() - 1) \
        and Game.gold == 95)
    check("сумка снова пуста", Game.inventory.is_empty())
    Game.add_item({"quality": "green", "title": "Безымянная добыча"})
    check("безымянную добычу не продать", not Game.sell_item(Game.inventory.size() - 1))
    Game.add_item({"item_id": "abyss_cloak", "title": "Плащ бездны", "quality": "violet"})
    check("фиолетовый уник не продать", not Game.sell_item(Game.inventory.size() - 1))
    check("кривые индексы продажи безопасны", not Game.sell_item(-1) and not Game.sell_item(999))
    check("золото не изменилось от неудачных продаж", Game.gold == 95)

    # --- шаг 6: герой Маг — хп 30, мана 70, заклинание, напитки ---
    Game.new_run(1, "mage")
    check("маг начал с 60 з. (ЗАГЛУШКА, задать автору)", Game.gold == 60 \
        and Game.hero_start_gold("mage") == 60)
    check("маг: хп 30/30 и мана 70/70 на старте", Game.hp == 30 and Game.mana == 70 \
        and Game.max_hp() == 30 and Game.max_mana() == 70 and Game.is_mage())
    check("хп и мана мага попали в сейв (v3)", int(Platform.load_data(1).get("hp", -1)) == 30 \
        and int(Platform.load_data(1).get("mana", -1)) == 70)
    check("стрела списывает ману: 70 -> 58", Game.cast_spell() and Game.mana == 58)
    Game.regen_mana(3)
    check("реген маны: 58 -> 61", Game.mana == 61)
    Game.mana = 5
    check("без маны заклинание не кастуется", not Game.cast_spell() and Game.mana == 5)
    Game.damage_hp(20)                                   # 30 -> 10
    check("урон по герою: хп 10/30", Game.hp == 10)
    Game.buy_item("mors")                                # 48 - 10 = 38 з.
    check("морс куплен и в сумке", String((Game.inventory.back() as Dictionary).get("item_id", "")) == "mors")
    var used := Game.use_consumable(Game.inventory.size() - 1)
    check("морс выпит: +20 хп (срезано до максимума 30)", bool(used.get("ok", false)) \
        and Game.hp == 30 and int(used.get("healed", 0)) == 20)
    check("выпитый морс исчез из сумки", Game.inventory.is_empty())
    Game.add_item({"item_id": "water", "title": "Вода", "quality": "gray"})
    var full_res := Game.use_consumable(Game.inventory.size() - 1)
    check("при полных хп напиток не тратится", bool(full_res.get("full", false)) \
        and not bool(full_res.get("ok", false)) and Game.inventory.size() == 1)
    check("кривой индекс безопасен", not bool((Game.use_consumable(-1)).get("ok", true)) \
        and not bool((Game.use_consumable(999)).get("ok", true)))
    Game.hero_id = "warrior"
    check("воин не маг — каст запрещён", not Game.cast_spell())

    # --- шаг 7: зелья трёх размеров, мана-зелья только магу ---
    Game.new_run(1, "mage")
    check("зелья лечения: 25/50/100 з. и +40/80/160 хп", \
        ItemDB.price("hp_potion_small") == 25 and ItemDB.price("hp_potion") == 50 \
        and ItemDB.price("hp_potion_large") == 100 \
        and int(ItemDB.get_item("hp_potion_small").get("heal", 0)) == 40 \
        and int(ItemDB.get_item("hp_potion").get("heal", 0)) == 80 \
        and int(ItemDB.get_item("hp_potion_large").get("heal", 0)) == 160)
    check("зелья маны: 30/60/120 з. и +30/60/120 маны", \
        ItemDB.price("mana_potion_small") == 30 and ItemDB.price("mana_potion") == 60 \
        and ItemDB.price("mana_potion_large") == 120 \
        and ItemDB.mana_restored("mana_potion_small") == 30 \
        and ItemDB.mana_restored("mana_potion") == 60 \
        and ItemDB.mana_restored("mana_potion_large") == 120)
    check("продажа зелий: 12/25/50 и 15/30/60", ItemDB.sell_price("hp_potion_small") == 12 \
        and ItemDB.sell_price("hp_potion") == 25 and ItemDB.sell_price("hp_potion_large") == 50 \
        and ItemDB.sell_price("mana_potion_small") == 15 and ItemDB.sell_price("mana_potion") == 30 \
        and ItemDB.sell_price("mana_potion_large") == 60)
    Game.mana = 10
    Game.add_item({"item_id": "mana_potion", "title": "Зелье маны", "quality": "gray"})
    var mana_res := Game.use_consumable(Game.inventory.size() - 1)
    check("маг выпил зелье маны: 10 -> 70 (срезано до максимума)", \
        bool(mana_res.get("ok", false)) and Game.mana == 70 \
        and int(mana_res.get("restored", 0)) == 60)
    check("выпитое мана-зелье исчезло", Game.inventory.is_empty())
    Game.hero_id = "warrior"
    Game.add_item({"item_id": "mana_potion_small", "title": "Малое зелье маны", "quality": "gray"})
    var blocked_res := Game.use_consumable(Game.inventory.size() - 1)
    check("не-магу мана-зелье не тратится", not bool(blocked_res.get("ok", false)) \
        and String(blocked_res.get("blocked", "")) == "not_mage" \
        and Game.inventory.size() == 1)

    # --- шаг 7: оружие в руках — удар рукой vs удар оружием ---
    check("кулаки: удар рукой у всех (заглушка 5 урона)", not Game.has_weapon() \
        and Game.strike_damage() == Game.HAND_DAMAGE and Game.strike_title() == "Кулаки")
    Game.add_item({"item_id": "sword", "title": "Меч", "quality": "gray"})
    check("экипировка меча: 30 урона", Game.equip_weapon("sword") and Game.has_weapon() \
        and Game.strike_damage() == 30 and Game.strike_title() == "Меч")
    check("оружие в руках сохраняется в сейве (v5)", \
        String(Platform.load_data(1).get("equipped_weapon_id", "")) == "sword")
    check("повторная экипировка того же — false", not Game.equip_weapon("sword"))
    check("экипировать не-оружие нельзя", not Game.equip_weapon("ham"))
    check("экипировать то, чего нет в сумке, нельзя", not Game.equip_weapon("greatsword"))
    Game.add_item({"item_id": "morgenstern", "title": "Моргенштерн", "quality": "gray"})
    check("смена оружия в руках: 100 урона", Game.equip_weapon("morgenstern") \
        and Game.strike_damage() == 100)
    Game.unequip_weapon()
    check("снятие оружия возвращает кулаки", not Game.has_weapon() \
        and Game.strike_damage() == Game.HAND_DAMAGE)
    check("меч снова в руках", Game.equip_weapon("sword"))
    check("продажа оружия из рук снимает его", Game.sell_item(1) \
        and not Game.has_weapon() and Game.gold == Game.hero_start_gold("mage") + 500)

    # --- шаг 12: броня и одеяния — база предметов ---
    check("типы экипировки в ItemDB.EQUIP_TYPES", "weapon" in ItemDB.EQUIP_TYPES \
        and "armor" in ItemDB.EQUIP_TYPES and "robe" in ItemDB.EQUIP_TYPES)
    check("броня Вираса: 40/90/180 з. и +10/+20/+35 ХП (ЗАГЛУШКИ)", \
        ItemDB.price("armor_leather") == 40 and ItemDB.price("armor_chain") == 90 \
        and ItemDB.price("armor_plate") == 180 \
        and ItemDB.hp_bonus("armor_leather") == 10 and ItemDB.hp_bonus("armor_chain") == 20 \
        and ItemDB.hp_bonus("armor_plate") == 35)
    check("одеяния Зорана: +мана и немного ХП (ЗАГЛУШКИ)", \
        ItemDB.price("robe_faded") == 35 and ItemDB.price("robe_stars") == 90 \
        and ItemDB.price("robe_void") == 170 \
        and ItemDB.mana_bonus("robe_faded") == 10 and ItemDB.hp_bonus("robe_faded") == 3 \
        and ItemDB.mana_bonus("robe_stars") == 20 and ItemDB.mana_bonus("robe_void") == 35)
    check("магическое оружие помечено magic", ItemDB.is_magic("wand_lightning") \
        and ItemDB.is_magic("blade_frost") and ItemDB.is_magic("scepter_comet") \
        and ItemDB.is_magic("star_blade") and not ItemDB.is_magic("morgenstern") \
        and not ItemDB.is_magic("sword"))
    check("у магического оружия есть залп", not ItemDB.volley("wand_lightning").is_empty() \
        and int(ItemDB.volley("wand_lightning").get("count", 0)) == 3 \
        and not ItemDB.volley("scepter_comet").is_empty() \
        and ItemDB.volley("morgenstern").is_empty())

    # --- шаг 12: экипировка брони и одеяний ---
    Game.new_run(1, "warrior")
    check("воин: базовый максимум 50 (ЗАГЛУШКА)", Game.max_hp() == 50)
    Game.add_item({"item_id": "armor_plate", "title": "Латный доспех", "quality": "gray"})
    check("броня надета: максимум 50 -> 85", bool(Game.equip_armor("armor_plate").get("ok", false)) \
        and Game.max_hp() == 85 and Game.has_armor())
    check("текущие хп не выросли от надевания", Game.hp == 50)
    check("надетая броня сохраняется в сейве (v5)", \
        String(Platform.load_data(1).get("equipped_armor_id", "")) == "armor_plate")
    Game.damage_hp(10)   # 50 -> 40
    Game.unequip_armor()
    check("снятие брони вернуло потолок 50 и срезало хп под него", \
        not Game.has_armor() and Game.max_hp() == 50 and Game.hp == 40)
    Game.add_item({"item_id": "robe_faded", "title": "Выцветшая мантия", "quality": "gray"})
    var robe_res := Game.equip_armor("robe_faded")
    check("одеяние не слушается не-мага", not bool(robe_res.get("ok", false)) \
        and String(robe_res.get("reason", "")) == "robe_not_mage")

    # --- шаг 12: маг + одеяние: потолок маны растёт ---
    Game.new_run(1, "mage")
    Game.add_item({"item_id": "robe_void", "title": "Одеяние Пустоты", "quality": "gray"})
    check("маг: одеяние надето, мана 70 -> 105, ХП 30 -> 40", \
        bool(Game.equip_armor("robe_void").get("ok", false)) \
        and Game.max_mana() == 105 and Game.max_hp() == 40)
    check("стрела по умолчанию: «Магическая стрела» без оружия", \
        String(Game.spell_info().get("title", "")) == "Магическая стрела" \
        and int(Game.spell_info().get("cost", 0)) == 12)

    # --- шаг 12: классовые множители и магический эффект оружия ---
    Game.hero_id = "warrior"
    Game.add_item({"item_id": "morgenstern", "title": "Моргенштерн", "quality": "gray"})
    check("воин: моргенштерн 100 урона (х1)", Game.equip_weapon("morgenstern") \
        and Game.strike_damage() == 100)
    Game.hero_id = "mage"
    check("маг: моргенштерн 50 урона (х0.5)", Game.strike_damage() == 50)
    Game.add_item({"item_id": "sword", "title": "Меч", "quality": "gray"})
    check("маг: меч 15 урона (х0.5)", Game.equip_weapon("sword") and Game.strike_damage() == 15)
    Game.add_item({"item_id": "wand_lightning", "title": "Жезл молний", "quality": "gray"})
    check("маг: жезл в полную силу 35", Game.equip_weapon("wand_lightning") \
        and Game.strike_damage() == 35)
    var volley_info := Game.spell_info()
    check("маг: на Q — Залп молний жезла (3 стрелы за 15 маны)", \
        String(volley_info.get("title", "")) == "Залп молний" \
        and int(volley_info.get("count", 0)) == 3 and int(volley_info.get("cost", 0)) == 15 \
        and int(volley_info.get("damage", 0)) == 10)
    Game.hero_id = "warrior"
    check("воин: жезл с магическим эффектом 44 (35 + 25%)", Game.strike_damage() == 44)
    check("воину залп недоступен — spell_info пуст", Game.spell_info().is_empty())
    check("подсказка не-магу с магическим оружием", \
        Game.non_mage_spell_hint().contains("залп"))
    Game.unequip_weapon()
    Game.hero_id = "barbarian"
    check("варвар: меч 60 урона (х2)", Game.equip_weapon("sword") and Game.strike_damage() == 60)
    check("варвару магическое оружие взять нельзя", not Game.equip_weapon("wand_lightning") \
        and Game.strike_damage() == 60 and Game.has_weapon() \
        and String(Game.equipped_weapon_id) == "sword")
    check("варвар: моргенштерн 200 урона (х2)", Game.equip_weapon("morgenstern") \
        and Game.strike_damage() == 200)
    check("варвару Q отвечает отказ магии", Game.non_mage_spell_hint().contains("варвара"))
    Game.unequip_weapon()

    # --- шаг 12: ярость демона после трёх ударов ---
    check("демон в новой игре мирен: 0 ударов", not Game.demon_enraged and Game.demon_hits == 0)
    Game.register_demon_hit()
    Game.register_demon_hit()
    check("после 2 ударов демон ещё сдерживается", Game.demon_hits == 2 and not Game.demon_enraged)
    Game.register_demon_hit()
    check("после 3 ударов демон в ярости", Game.demon_enraged)
    Game.new_run(2, "warrior")
    check("новая игра: демон забывает удары", Game.demon_hits == 0 and not Game.demon_enraged)

    # --- шаг 7: смерть NPC — память на текущую сессию ---
    check("NPC живы по умолчанию", not Game.is_npc_dead("glot") and not Game.is_npc_dead("gura"))
    Game.kill_npc("glot")
    check("убитый NPC мёртв", Game.is_npc_dead("glot"))
    Game.kill_npc("glot")
    check("повторное kill_npc не дублирует", Game.dead_npcs.size() == 1)
    Game.kill_npc("gura")
    check("несколько убитых помнятся", Game.dead_npcs.size() == 2)
    Game.new_run(2, "warrior")
    check("новая игра: мёртвые воскресли (список живёт в сессии)", Game.dead_npcs.is_empty())


    # --- ежедневный бонус: 50-200 золота + фиолетовая добыча ---
    Game.meta["last_bonus_date"] = ""
    Game.current_slot = 0
    var gold_pre_bonus: int = Game.gold
    check("can_claim_bonus после сброса даты", Game.can_claim_bonus())
    var reward := Game.claim_daily_bonus()
    check("бонус выдаётся", not reward.is_empty())
    check("бонус: 50-200 золота", int(reward.get("gold", 0)) >= 50 and int(reward.get("gold", 0)) <= 200)
    check("бонус: золото начислено", Game.gold == gold_pre_bonus + int(reward.get("gold", 0)))
    check("бонус: фиолетовая добыча в инвентаре", not Game.inventory.is_empty() \
        and String((Game.inventory.back() as Dictionary).get("item_id", "")) in ItemDB.VIOLET_UNIQUES)
    check("бонус: дата зафиксирована", String(Game.meta.get("last_bonus_date", "")) == Time.get_date_string_from_system())
    check("повторный бонус блокируется", Game.claim_daily_bonus().is_empty() and not Game.can_claim_bonus())

    # --- отложенный бонус переносится при новой игре ---
    Game.meta["pending_gold"] = 77
    Game.meta["pending_items"] = ["abyss_cloak"]
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.current_slot = 0
    Game.new_run(2, "warrior")
    check("новая игра: отложенное золото выдано", \
        Game.gold == Game.hero_start_gold("warrior") + 77)
    check("новая игра: отложенный предмет выдан", Game.inventory.size() == 1 \
        and String((Game.inventory[0] as Dictionary).get("item_id", "")) == "abyss_cloak")
    check("новая игра: отложенное обнулено", int(Game.meta.get("pending_gold", -1)) == 0 \
        and (Game.meta.get("pending_items", []) as Array).is_empty())

    # --- сброс прогресса ---
    Game.reset_progress()
    check("reset_progress чистит всё", Game.gold == 0 and Game.inventory.is_empty() \
        and Game.dungeons_cleared.is_empty() and Game.current_slot == 0 \
        and int(Game.meta.get("last_slot", -1)) == 0 and not Platform.has_slot(2))
    check("reset хранит дату бонуса", String(Game.meta.get("last_bonus_date", "")) == Time.get_date_string_from_system())

    # --- сцены ---
    for scene_path in [
        "res://scenes/main/main.tscn",
        "res://scenes/character_select/character_select.tscn",
        "res://scenes/world/world.tscn",
    ]:
        var packed: PackedScene = load(scene_path)
        check("%s грузится" % scene_path.get_file(), packed != null)
        if packed != null:
            var inst: Node = packed.instantiate()
            check("%s инстанцируется" % scene_path.get_file(), inst != null)
            if scene_path.ends_with("world.tscn"):
                await get_tree().process_frame
            inst.free()

    # --- лут ---
    var counts := {}
    for quality in Loot.QUALITIES:
        counts[quality["id"]] = 0
    for _i in ROLLS:
        counts[Loot.roll_quality()["id"]] += 1
    print("  распределение качества (ожидание 70/20/7/3):")
    for quality in Loot.QUALITIES:
        var share := float(counts[quality["id"]]) / float(ROLLS) * 100.0
        check("%s: %.1f%%" % [quality["id"], share], absf(share - float(quality["weight"])) < 1.5)

    # Возвращаем исходное состояние, чтобы тест не портил сейвы.
    restore()

    if failed == 0:
        print("SMOKE: ВСЁ ОК")
        get_tree().quit(0)
    else:
        print("SMOKE: ПРОВАЛОВ: ", failed)
        get_tree().quit(1)

````

#### `tests/smoke_test.gd.uid`

````
uid://beecml157md6k

````

#### `tests/smoke_test.tscn`

````ini
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://tests/smoke_test.gd" id="1_smoke"]

[node name="SmokeTest" type="Node"]
script = ExtResource("1_smoke")

````

#### `tests/trade_test.gd`

````gdscript
## Тест торговли (шаг 6): стартовое золото героев, товары торговцев
## из WorldMap.NPCS (включая Глота и Зорана), цены покупки/продажи ItemDB,
## логика Game.buy_item()/Game.sell_item(), окно лавки TradeUI, сейв после покупки.
## Запуск: godot --headless --path . res://tests/trade_test.tscn
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
    print("TRADE TEST: золото героев, товары NPC, покупка, продажа, лавка, сейв")
    snapshot()
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.meta["last_bonus_date"] = ""
    Game.meta["pending_gold"] = 0
    Game.meta["pending_items"] = []
    Game.current_slot = 0
    Game.save_meta()

    # --- стартовое золото героев ---
    Game.new_run(1, "warrior")
    check("воин начал со 100 з.", Game.gold == 100 and Game.hero_start_gold("warrior") == 100)
    Game.new_run(1, "barbarian")
    check("варвар начал с 50 з.", Game.gold == 50 and Game.hero_start_gold("barbarian") == 50)
    Game.new_run(1, "bum")
    check("бомж начал с 1 з.", Game.gold == 1 and Game.hero_start_gold("bum") == 1)
    check("стартовое золото попало в сейв", \
        int(Platform.load_data(1).get("gold", -1)) == 1)

    # --- товары торговцев (расстановка из дизайн-документа) ---
    var goods_of := {}
    for npc_data in WorldMap.NPCS:
        goods_of[String(npc_data["id"])] = npc_data.get("goods", [])
    check("Гура (повар): окорок", "ham" in goods_of["gura"] \
        and (goods_of["gura"] as Array).size() == 1)
    check("Вирас (кузнец): меч, большой меч, моргенштерн + броня (шаг 12)", "sword" in goods_of["viras"] \
        and "greatsword" in goods_of["viras"] and "morgenstern" in goods_of["viras"] \
        and "armor_leather" in goods_of["viras"] and "armor_chain" in goods_of["viras"] \
        and "armor_plate" in goods_of["viras"] and (goods_of["viras"] as Array).size() == 6)
    check("Злус (маг): зелья лечения и маны 3 размеров", "hp_potion" in goods_of["zlus"] \
        and "hp_potion_small" in goods_of["zlus"] and "hp_potion_large" in goods_of["zlus"] \
        and "mana_potion_small" in goods_of["zlus"] and "mana_potion" in goods_of["zlus"] \
        and "mana_potion_large" in goods_of["zlus"] and (goods_of["zlus"] as Array).size() == 6)
    check("Глот (трактирщик): вода, морс, сок, пиво", "water" in goods_of["glot"] \
        and "mors" in goods_of["glot"] and "juice" in goods_of["glot"] \
        and "beer" in goods_of["glot"] and (goods_of["glot"] as Array).size() == 4)
    check("Зоран (чародей): жезл, клинок инея, скипетр + одеяния (шаг 12)", \
        "wand_lightning" in goods_of["zoran"] \
        and "blade_frost" in goods_of["zoran"] and "scepter_comet" in goods_of["zoran"] \
        and "robe_faded" in goods_of["zoran"] and "robe_stars" in goods_of["zoran"] \
        and "robe_void" in goods_of["zoran"] and (goods_of["zoran"] as Array).size() == 6)
    check("Лира не торгует", (goods_of["lira"] as Array).is_empty())
    var all_goods_known := true
    var all_goods_priced := true
    for npc_data in WorldMap.NPCS:
        for item_id in npc_data.get("goods", []):
            if ItemDB.get_item(String(item_id)).is_empty():
                all_goods_known = false
            if ItemDB.price(String(item_id)) <= 0:
                all_goods_priced = false
    check("все товары есть в ItemDB", all_goods_known)
    check("у всех товаров цена больше нуля", all_goods_priced)

    # --- цены продажи: половина цены покупки ---
    check("цены продажи: 5/12/500/1000/2500/25", ItemDB.sell_price("ham") == 5 \
        and ItemDB.sell_price("beer") == 12 and ItemDB.sell_price("sword") == 500 \
        and ItemDB.sell_price("greatsword") == 1000 and ItemDB.sell_price("morgenstern") == 2500 \
        and ItemDB.sell_price("hp_potion") == 25)
    check("цены продажи шага 6: 2/5/7/600/1250/3000", ItemDB.sell_price("water") == 2 \
        and ItemDB.sell_price("mors") == 5 and ItemDB.sell_price("juice") == 7 \
        and ItemDB.sell_price("wand_lightning") == 600 and ItemDB.sell_price("blade_frost") == 1250 \
        and ItemDB.sell_price("scepter_comet") == 3000)
    check("цены продажи брони и одеяний (шаг 12): 20/45/90 и 17/45/85", \
        ItemDB.sell_price("armor_leather") == 20 and ItemDB.sell_price("armor_chain") == 45 \
        and ItemDB.sell_price("armor_plate") == 90 \
        and ItemDB.sell_price("robe_faded") == 17 and ItemDB.sell_price("robe_stars") == 45 \
        and ItemDB.sell_price("robe_void") == 85)
    check("уники не продаются (price < 0)", ItemDB.sell_price("star_blade") == 0 \
        and ItemDB.sell_price("comet_elixir") == 0)

    # --- покупка: бомжу с 1 монетой недоступно ничего ---
    check("бомжу окорок за 10 не по карману", not Game.buy_item("ham") and Game.gold == 1)
    check("бомжу пиво за 25 не по карману", not Game.buy_item("beer") and Game.gold == 1)
    check("бомжу даже вода за 5 не по карману", not Game.buy_item("water") and Game.gold == 1)

    # --- продажа может спасти нищего героя ---
    Game.add_item({"item_id": "ham", "title": "Окорок", "quality": "gray"})
    check("продажа окорока бомжу дала +5 з.", Game.sell_item(Game.inventory.size() - 1) \
        and Game.gold == 6)

    # --- воин с 100 з.: полный цикл покупки и продажи ---
    Game.new_run(1, "warrior")
    check("покупка зелья у Злуса: 100 -> 50", Game.buy_item("hp_potion") and Game.gold == 50)
    check("покупка пива у Глота: 50 -> 25", Game.buy_item("beer") and Game.gold == 25)
    check("меч за 1000 не по карману даже воину", not Game.buy_item("sword") and Game.gold == 25)
    check("в сумке зелье и пиво", Game.inventory.size() == 2 \
        and String((Game.inventory[0] as Dictionary).get("item_id", "")) == "hp_potion" \
        and String((Game.inventory[1] as Dictionary).get("item_id", "")) == "beer")
    check("продажа пива вернула 12 з.", Game.sell_item(1) and Game.gold == 37)
    check("продажа зелья вернула 25 з.", Game.sell_item(0) and Game.gold == 62)
    check("после продаж сумка пуста", Game.inventory.is_empty())

    # --- окно лавки TradeUI ---
    var trade_ui := TradeUI.new()
    add_child(trade_ui)
    await get_tree().process_frame
    await trade_ui.open({"name": "Вирас", "role": "Кузнец",
                         "goods": ["sword", "greatsword", "morgenstern"]})
    await get_tree().process_frame
    check("лавка открылась", trade_ui.visible)
    check("имя торговца в шапке", trade_ui._trader_label.text.contains("Вирас"))
    check("кошелёк героя в шапке", trade_ui._gold_label.text == "Золото: %d" % Game.gold)
    check("в лавке кузнеца 3 товара", trade_ui._rows.get_child_count() == 3)
    var buy_row: HBoxContainer = trade_ui._rows.get_child(0)
    var buy_btn: Button = null
    for child in buy_row.get_children():
        if child is Button and (child as Button).text == "КУПИТЬ":
            buy_btn = child
    check("меч воину не по карману — кнопка отключена", buy_btn != null \
        and (buy_btn as Button).disabled)
    trade_ui.close()
    check("лавка закрылась", not trade_ui.visible)

    # лавка Глота: покупка и продажа прямо через кнопки UI
    var gold_before: int = Game.gold
    await trade_ui.open({"name": "Глот", "role": "Трактирщик",
                         "goods": ["water", "mors", "juice", "beer"]})
    await get_tree().process_frame
    check("в лавке Глота 4 напитка", trade_ui._rows.get_child_count() == 4)
    buy_row = trade_ui._rows.get_child(0)
    buy_btn = null
    for child in buy_row.get_children():
        if child is Button and (child as Button).text == "КУПИТЬ":
            buy_btn = child
    check("вода по карману — кнопка активна", buy_btn != null \
        and not (buy_btn as Button).disabled)
    if buy_btn != null:
        buy_btn.pressed.emit()
        await get_tree().process_frame
    check("покупка через UI списала цену", Game.gold == gold_before - ItemDB.price("water"))
    trade_ui._tab_sell.pressed.emit()
    await get_tree().process_frame
    check("вкладка ПРОДАЖА отражает сумку", \
        trade_ui._rows.get_child_count() == Game.inventory.size())
    var sell_row: HBoxContainer = trade_ui._rows.get_child(0)
    var sell_btn: Button = null
    for child in sell_row.get_children():
        if child is Button and (child as Button).text == "ПРОДАТЬ":
            sell_btn = child
    if sell_btn != null:
        sell_btn.pressed.emit()
        await get_tree().process_frame
    check("продажа через UI вернула половину цены", \
        Game.gold == gold_before - ItemDB.price("water") + ItemDB.sell_price("water"))
    trade_ui.close()
    trade_ui.free()
    await get_tree().process_frame

    # --- шаг 12: покупка и надевание брони ---
    Game.new_run(1, "warrior")
    check("воин купил кожаный доспех за 40 з. у Вираса", Game.buy_item("armor_leather") \
        and Game.gold == 60)
    check("доспех надет: максимум ХП 50 -> 60", \
        bool(Game.equip_armor("armor_leather").get("ok", false)) and Game.max_hp() == 60)
    check("надетая броня уехала в сейв (v5)", \
        String(Platform.load_data(1).get("equipped_armor_id", "")) == "armor_leather")
    check("загрузка слота восстанавливает броню", Game.continue_run(1) \
        and Game.has_armor() and Game.equipped_armor_id == "armor_leather")

    # --- сейв после покупок ---
    Game.new_run(1, "warrior")
    Game.buy_item("ham")
    Game.buy_item("hp_potion")
    var saved: Dictionary = Platform.load_data(1)
    check("золото после покупок сохранилось (100-10-50=40)", \
        int(saved.get("gold", -1)) == 40)
    var saved_items: Array = saved.get("inventory", [])
    check("купленные предметы сохранились", saved_items.size() == 2 \
        and String((saved_items[0] as Dictionary).get("item_id", "")) == "ham" \
        and String((saved_items[1] as Dictionary).get("item_id", "")) == "hp_potion")
    check("загрузка слота возвращает 40 з.", Game.continue_run(1) and Game.gold == 40)

    # Возвращаем исходное состояние, чтобы тест не портил сейвы.
    restore()

    if failed == 0:
        print("TRADE TEST: ВСЁ ОК")
        get_tree().quit(0)
    else:
        print("TRADE TEST: ПРОВАЛОВ: ", failed)
        get_tree().quit(1)

````

#### `tests/trade_test.gd.uid`

````
uid://c2b226blg3v6m

````

#### `tests/trade_test.tscn`

````ini
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://tests/trade_test.gd" id="1_trade"]

[node name="TradeTest" type="Node"]
script = ExtResource("1_trade")

````

#### `tests/world_test.gd`

````gdscript
## Тест мира (шаг 7): тайлмап, игрок, движение, коллизии,
## 6 NPC (Злус, Лира, Глот и Зоран в замке, Гура и Вирас на улице), двери данжей,
## диалоги с портретами и кнопкой «ТОРГОВАТЬ», лавка (покупка/продажа),
## инвентарь, HUD (хп/мана), заклинание мага, джойстик.
## Шаг 7: кнопка УДАР у всех героев, удар рукой/оружием по хп NPC,
## смерть NPC без воскрешения в сессии, память остальных NPC.
## Шаг 11: консоль UI сжата до 112 px, удар на ЛКМ, диалог на E —
## проверки InputMap и точек клика.
## Запуск: godot --headless --path . res://tests/world_test.tscn
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
    print("WORLD TEST: тайлы, игрок, NPC, диалоги, инвентарь, край мира")
    snapshot()
    Saves.wipe_all_slots()
    Game.meta["last_slot"] = 0
    Game.meta["last_bonus_date"] = ""
    Game.meta["pending_gold"] = 0
    Game.meta["pending_items"] = []
    Game.save_meta()
    Platform.calls.clear()
    Game.new_run(1, "barbarian")
    Platform.calls.clear()

    var world: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world)
    await get_tree().process_frame
    await get_tree().process_frame

    # --- структура мира ---
    # Ground живёт внутри SubViewport (шаг 10/11): WalkScreen/WalkViewport/WorldContent
    var ground: TileMapLayer = world.get_node("WalkScreen/WalkViewport/WorldContent/Ground")
    check("тайлмап заполнен", ground.get_used_cells().size() == WorldMap.MAP_W * WorldMap.MAP_H)
    check("размер карты 30x56", WorldMap.MAP_W == 30 and WorldMap.MAP_H == 56)
    check("спавн в замке", WorldMap.PLAYER_SPAWN.y <= WorldMap.CASTLE_LAST_ROW)

    var player: CharacterBody2D = world.player
    check("игрок создан", player != null)
    check("камера с границами карты", world._camera.limit_right == WorldMap.MAP_W * 16 \
        and world._camera.limit_bottom == WorldMap.MAP_H * 16)
    check("лист анимаций героя — варвар", world._hero_sheet_tex != null \
        and world._hero_sheet_tex.resource_path.contains("barbarian"))
    check("у игрока покадровые анимации", world._player_sprite.sprite_frames != null \
        and world._player_sprite.sprite_frames.has_animation("walk_down") \
        and world._player_sprite.sprite_frames.has_animation("idle_down"))

    # --- NPC: 4 в замке (Злус + Лира + Глот + Зоран), 2 на улице ---
    check("всего 6 NPC", world._npcs.size() == 6)
    var castle_npcs := 0
    var street_npcs := 0
    for npc in world._npcs:
        var ty: int = int((npc["tile"] as Vector2).y)
        if ty <= WorldMap.CASTLE_LAST_ROW:
            castle_npcs += 1
        elif ty < WorldMap.RAILING_ROW:
            street_npcs += 1
    check("4 NPC в замке (Злус, Лира, Глот, Зоран)", castle_npcs == 4)
    check("2 NPC на улице (Гура и Вирас)", street_npcs == 2)
    var ids := []
    for npc in world._npcs:
        ids.append(npc["id"])
    check("это Гура, Вирас, Злус, Лира, Глот, Зоран", "gura" in ids and "viras" in ids \
        and "zlus" in ids and "lira" in ids and "glot" in ids and "zoran" in ids)
    # у каждого NPC: лист спрайтов, портрет, золотой указатель
    var npcs_ok := true
    for npc in world._npcs:
        var data: Dictionary = npc["data"]
        if not ResourceLoader.exists(String(data["sheet"])) \
                or not ResourceLoader.exists(String(data["portrait"])):
            npcs_ok = false
    check("у всех NPC есть спрайты и портреты", npcs_ok)
    check("у NPC анимации idle/walk", (world._npcs[0]["sprite"] as AnimatedSprite2D) \
        .sprite_frames.has_animation("idle_down"))

    # --- двери данжей ---
    check("4 прохода в данжи", world._doors.size() == 4)
    var doors_on_top_wall := true
    for door in WorldMap.DOORS:
        for t in door["tiles"]:
            if int(t.y) != 0 or WorldMap.MAP[0][int(t.x)] != "D":
                doors_on_top_wall = false
    check("двери стоят в верхней стене замка", doors_on_top_wall)
    # шаг 9/13: двери явные — видимый спрайт, клик (и E рядом) отвечает.
    # Шаг 13: подписи «Данж N» убраны, дверь 1 открыта — ведёт в
    # Подземелье замка, остальные заперты.
    var door_node := world.get_node_or_null(
        "WalkScreen/WalkViewport/WorldContent/Door_dungeon_1") as Node2D
    check("у двери есть узел в мире", door_node != null)
    if door_node != null:
        var door_spr := door_node.get_node_or_null("Sprite") as Sprite2D
        check("у двери есть видимый спрайт", door_spr != null \
            and door_spr.texture != null \
            and door_spr.texture.resource_path.contains("door_dungeon"))
        var door_label: Label = null
        for child in door_node.get_children():
            if child is Label:
                door_label = child
        check("подписи «Данж N» на дверях больше нет (шаг 13)", door_label == null)
    var door_click := InputEventMouseButton.new()
    door_click.button_index = MOUSE_BUTTON_LEFT
    door_click.pressed = true
    world._on_door_input(null, door_click, 0, "dungeon_2")
    await get_tree().process_frame
    check("запертая дверь отвечает: подземелье недоступно", world._dialogue.visible \
        and world._dialogue._lines.size() > 0 \
        and String(world._dialogue._lines[0]).contains("недоступно"))
    check("с дверью нельзя торговать", not world._dialogue._trade_button.visible)
    world._dialogue._close()
    await get_tree().process_frame
    # шаг 13: дверь 1 открыта — маршрут в Подземелье замка. Смену сцены
    # в тесте не запускаем: под флагом «уже переходим» (dungeon_floor > 0)
    # вызов только подтверждает маршрут — диалог запертости не открывается.
    check("сцена данжа существует", ResourceLoader.exists("res://scenes/dungeon/dungeon.tscn"))
    Game.dungeon_floor = 1
    world._open_door_dialog("dungeon_1")
    await get_tree().process_frame
    check("дверь 1 не открывает диалог запертости", not world._dialogue.visible)
    check("маршрут двери 1 — вход в данж (флаг этажа)", Game.dungeon_floor == 1)
    Game.dungeon_floor = 0
    await get_tree().process_frame

    # --- диалог с портретом ---
    world.npc_say("gura")
    await get_tree().process_frame
    check("диалог открыт", world._dialogue.visible)
    check("в диалоге имя Гуры", world._dialogue._name_label.text == "Гура")
    check("в диалоге портрет Гуры", world._dialogue._portrait.texture != null \
        and world._dialogue._portrait.texture.resource_path.contains("gura"))
    check("реплика печатается", world._dialogue._text_label.text.length() > 0)
    check("у торговца в диалоге есть ТОРГОВАТЬ", world._dialogue._trade_button.visible)
    for _i in 8:
        world._dialogue._advance()
    await get_tree().process_frame
    check("диалог закрылся после реплик", not world._dialogue.visible)
    # шаг 6 (регресс мигания): то же нажатие E не переоткрывает диалог —
    # мир игнорирует interact первые 250 мс после закрытия.
    check("E сразу после закрытия заблокирован", not world._interact_allowed())
    await get_tree().create_timer(0.3).timeout
    check("после паузы E снова работает", world._interact_allowed())

    # --- торговля (шаг 5): товары NPC ---
    var goods_of := {}
    for npc_data in WorldMap.NPCS:
        goods_of[String(npc_data["id"])] = npc_data.get("goods", [])
    check("Гура торгует едой (окорок)", "ham" in goods_of["gura"] \
        and (goods_of["gura"] as Array).size() == 1)
    check("Глот торгует напитками: вода, морс, сок, пиво", "water" in goods_of["glot"] \
        and "mors" in goods_of["glot"] and "juice" in goods_of["glot"] \
        and "beer" in goods_of["glot"] and (goods_of["glot"] as Array).size() == 4)
    check("Зоран торгует магическим оружием и одеяниями (шаг 12)", "wand_lightning" in goods_of["zoran"] \
        and "blade_frost" in goods_of["zoran"] and "scepter_comet" in goods_of["zoran"] \
        and "robe_faded" in goods_of["zoran"] and "robe_void" in goods_of["zoran"] \
        and (goods_of["zoran"] as Array).size() == 6)
    check("Вирас торгует оружием", "sword" in goods_of["viras"] \
        and "greatsword" in goods_of["viras"] and "morgenstern" in goods_of["viras"])
    check("Злус торгует зельями", "hp_potion" in goods_of["zlus"])
    check("Лира не торговец", (goods_of["lira"] as Array).is_empty())
    # напитки Глота стоят растущим рядом (цена и хп)
    check("ряд напитков по цене", ItemDB.price("water") < ItemDB.price("mors") \
        and ItemDB.price("mors") < ItemDB.price("juice") \
        and ItemDB.price("juice") < ItemDB.price("beer"))

    # --- лавка: открытие из диалога, покупка и продажа через UI ---
    world.npc_say("gura")
    await get_tree().process_frame
    world._dialogue._trade_button.pressed.emit()
    await get_tree().process_frame
    check("реплики закрылись, лавка открылась", not world._dialogue.visible \
        and world._trade_ui.visible)
    check("в лавке Гуры 1 товар (пиво у Глота с шага 6)", world._trade_ui._rows.get_child_count() == 1)
    var gold_before: int = Game.gold
    var buy_row: HBoxContainer = world._trade_ui._rows.get_child(0)
    var buy_btn: Button = null
    for child in buy_row.get_children():
        if child is Button and (child as Button).text == "КУПИТЬ":
            buy_btn = child
    check("кнопка КУПИТЬ у первого товара найдена", buy_btn != null \
        and not (buy_btn as Button).disabled)
    if buy_btn != null:
        buy_btn.pressed.emit()
        await get_tree().process_frame
    check("покупка через UI списала 10 з.", Game.gold == gold_before - 10)
    check("купленный окорок в сумке", String((Game.inventory.back() as Dictionary) \
        .get("item_id", "")) == "ham")
    world._trade_ui._tab_sell.pressed.emit()
    await get_tree().process_frame
    check("вкладка ПРОДАЖА показывает сумку", \
        world._trade_ui._rows.get_child_count() == Game.inventory.size())
    var sell_row: HBoxContainer = world._trade_ui._rows.get_child(0)
    var sell_btn: Button = null
    for child in sell_row.get_children():
        if child is Button and (child as Button).text == "ПРОДАТЬ":
            sell_btn = child
    check("кнопка ПРОДАТЬ у окорока найдена", sell_btn != null \
        and not (sell_btn as Button).disabled)
    if sell_btn != null:
        sell_btn.pressed.emit()
        await get_tree().process_frame
    check("продажа через UI вернула 5 з.", Game.gold == gold_before - 5 \
        and Game.inventory.is_empty())
    world._trade_ui.close()
    check("лавка закрывается", not world._trade_ui.visible)
    world.npc_say("lira")
    await get_tree().process_frame
    check("у Лиры нет кнопки ТОРГОВАТЬ", not world._dialogue._trade_button.visible)
    world._dialogue._close()

    # --- инвентарь ---
    check("инвентарь закрыт по умолчанию", not world._inventory_ui.visible)
    world._inventory_ui.open()
    check("инвентарь открывается", world._inventory_ui.visible)
    check("в инвентаре 20 слотов", world._inventory_ui._grid.get_child_count() == 20)
    check("в инвентаре две ячейки экипировки (ОРУЖИЕ и БРОНЯ, шаг 12)", \
        world._inventory_ui._weapon_cell != null and world._inventory_ui._armor_cell != null)
    Game.add_item({"item_id": "star_blade", "title": "Звёздный клинок", "quality": "violet"})
    world._inventory_ui.open()
    var first_slot: PanelContainer = world._inventory_ui._grid.get_child(0)
    var has_icon := false
    for sub in first_slot.get_children():
        for subsub in sub.get_children():
            if subsub is TextureRect and subsub.texture != null:
                has_icon = true
    check("предмет из бонуса виден в слоте", has_icon)
    world._inventory_ui.close()
    check("инвентарь закрывается", not world._inventory_ui.visible)

    # --- анимированные пропы (факелы, фонтан, горн, жаровни) ---
    var animated_props := 0
    for prop in WorldMap.PROPS:
        if prop.has("anim"):
            animated_props += 1
    check("есть анимированные пропы (>=9)", animated_props >= 9)
    check("Лира и трон в замке", WorldMap.NPCS.any(
        func(n: Dictionary) -> bool: return n["id"] == "lira" and n["zone"] == "castle"))

    # --- коллизии: ограда края мира непроходима ---
    # шаг 10: физика мира живёт в SubViewport экрана ходьбы, поэтому
    # пространство запрашиваем через игрока (он внутри этого мира).
    # Фикс шага 11 (Godot 4.7.2): world.player через переменную типа Node2D —
    # это Variant, и «:=» не может вывести тип (Parse Error: Cannot infer
    # the type of "space"/"hits" variable). Ставим явные типы.
    var walker: CharacterBody2D = world.player
    var space: PhysicsDirectSpaceState2D = walker.get_world_2d().direct_space_state
    var query := PhysicsPointQueryParameters2D.new()
    query.position = Vector2(240, WorldMap.RAILING_ROW * 16.0 + 8.0)
    query.collision_mask = 1
    var hits: Array = space.intersect_point(query, 4)
    check("ограда края имеет коллизию", hits.size() > 0)

    # --- движение: игрок слушает действия ввода ---
    var x_before: float = player.position.x
    Input.action_press("move_left")
    for _i in 30:
        await get_tree().physics_frame
    Input.action_release("move_left")
    check("влево игрок идёт", player.position.x < x_before - 5.0)

    # --- игрок не проваливается за край ---
    var controls_hint: String = world._hud_hint.text   # подсказка до сообщений у края
    player.position = Vector2(240, 45 * 16.0 - 6.0)
    Input.action_press("move_down")
    for _i in 90:
        await get_tree().physics_frame
    Input.action_release("move_down")
    check("ограда остановила игрока", player.position.y < WorldMap.RAILING_ROW * 16.0 + 2.0)

    # --- замок: стены верхнего ряда не проходимы ---
    player.position = Vector2(8 * 16.0 + 8.0, 2 * 16.0 + 8.0)
    Input.action_press("move_up")
    for _i in 60:
        await get_tree().physics_frame
    Input.action_release("move_up")
    check("стена замка остановила игрока", player.position.y > 8.0)

    # --- смена героя подменяет лист анимаций ---
    Game.hero_id = "warrior"
    world._apply_hero_textures()
    check("анимации воина применились", world._hero_sheet_tex.resource_path.contains("warrior"))
    Game.hero_id = "barbarian"
    world._apply_hero_textures()

    # --- HUD ---
    var hud_gold: Label = world.get_node("HUD").get_children().filter(
        func(c: Node) -> bool: return c is PanelContainer)[0].get_child(0).get_child(1).get_child(1)
    check("HUD показывает золото", hud_gold.text == "Золото: %d" % Game.gold)
    Game.add_gold(11)
    check("HUD реагирует на золото", hud_gold.text == "Золото: %d" % (Game.gold))
    Game.spend_gold(11)
    check("подсказка управления: E — говорить, ЛКМ — удар", controls_hint.contains("E — говорить") \
        and controls_hint.contains("ЛКМ — удар"))
    # шаг 11: удар переехал на ЛКМ, диалог — на E (F тоже работает)
    var lmb_attack := false
    var e_in_attack := false
    for ev in InputMap.action_get_events("attack"):
        if ev is InputEventMouseButton \
                and (ev as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
            lmb_attack = true
        if ev is InputEventKey and (ev as InputEventKey).physical_keycode == KEY_E:
            e_in_attack = true
    check("удар на ЛКМ и больше не на E", lmb_attack and not e_in_attack)
    var e_interact := false
    for ev in InputMap.action_get_events("interact"):
        if ev is InputEventKey and (ev as InputEventKey).physical_keycode == KEY_E:
            e_interact = true
    check("диалог на E", e_interact)
    check("кнопка УДАР у не-мага", world._attack_button != null \
        and world._attack_button.text.contains("УДАР"))
    check("HUD показывает «В руках: Кулаки»", world._hud_weapon.text.contains("Кулаки"))

    # --- джойстик ---
    check("VirtualJoystick подключён", world._joystick != null)

    # --- шаг 11: компактная консоль и клик-удар ---
    check("консоль UI сжата до 112 px (экран ходьбы вырос)", world.UI_BAR_H == 112.0 \
        and world._walk_holder.size == Vector2(360.0, 528.0))
    var npc_pos: Vector2 = (world._npcs[0]["node"] as Node2D).position
    check("точка NPC интерактивна (клик по ней не бьёт)", \
        world._point_on_interactive(npc_pos + Vector2(0, -16)))
    check("пустая точка мира не интерактивна", \
        not world._point_on_interactive(Vector2(180, 300)))

    # --- жизненный цикл площадки ---
    check("gameplay_start вызван миром", "gameplay_start" in Platform.calls)

    world.free()
    await get_tree().process_frame

    # --- шаг 6: мир под магом — мана в HUD, кнопка МАГИЯ, снаряд ---
    Game.new_run(2, "mage")
    var world_mage: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world_mage)
    await get_tree().process_frame
    await get_tree().process_frame
    check("HUD мага: полоса маны есть", world_mage._hud_mana != null)
    check("HUD мага: кнопка МАГИЯ есть", world_mage._spell_button != null)
    check("HUD мага: кнопка УДАР тоже есть (маг бьёт рукой)", world_mage._attack_button != null)
    check("мана мага полная (70)", Game.mana == 70 and Game.max_mana() == 70)
    check("лист анимаций героя — маг", world_mage._hero_sheet_tex.resource_path.contains("mage"))
    check("каст через Game списал ману", Game.cast_spell() \
        and Game.mana == 70 - int(Game.SPELL["cost"]))
    world_mage._spawn_bolt(Vector2(1, 0))
    check("снаряд появился в мире", world_mage._bolts.size() == 1)
    var bolt_node: Sprite2D = world_mage._bolts[0]["node"]
    var bx: float = bolt_node.position.x
    for _i in 10:
        await get_tree().physics_frame
    check("снаряд летит вправо", bolt_node.position.x > bx + 20.0)
    for _i in 80:
        await get_tree().physics_frame
    check("снаряд гаснет в конце дистанции", world_mage._bolts.is_empty())
    # --- шаг 9: магия наносит урон NPC (как удар, но издалека) ---
    var zl: Dictionary = {}
    for npc in world_mage._npcs:
        if String(npc["id"]) == "zlus":
            zl = npc
    check("Злус найден в мире мага с полным хп", not zl.is_empty() \
        and int(zl["hp"]) == 40)
    world_mage.player.position = (zl["node"] as Node2D).position + Vector2(-20, 0)
    world_mage._facing = "side"
    world_mage._player_sprite.flip_h = false
    world_mage._spawn_bolt(Vector2(1, 0))
    check("стрела запущена в Злуса", world_mage._bolts.size() == 1)
    for _i in 12:
        await get_tree().physics_frame
    check("магическая стрела сняла %d хп Злуса (40 -> %d)" \
        % [int(Game.SPELL["damage"]), 40 - int(Game.SPELL["damage"])],
        int(zl["hp"]) == 40 - int(Game.SPELL["damage"]))
    check("стрела исчезла при попадании", world_mage._bolts.is_empty())
    check("полоска хп Злуса показана после магии", (zl["hp_bar"] as ProgressBar).visible)
    # --- шаг 12: залп магического оружия — веер снарядов вместо одной стрелы ---
    world_mage.player.position = Vector2(240, 30 * 16.0)   # пустая улица
    world_mage._facing = "side"
    world_mage._player_sprite.flip_h = false
    Game.add_item({"item_id": "wand_lightning", "title": "Жезл молний", "quality": "gray"})
    check("маг взял жезл в руки (35 урона)", Game.equip_weapon("wand_lightning") \
        and Game.strike_damage() == 35)
    var volley := Game.spell_info()
    check("Q жезла — «Залп молний»: 3 стрелы за 15 маны", \
        String(volley.get("title", "")) == "Залп молний" \
        and int(volley.get("count", 0)) == 3 and int(volley.get("cost", 0)) == 15)
    world_mage._spell_cd = 0.0
    world_mage._cast_spell()
    check("залп выпустил 3 снаряда", world_mage._bolts.size() == 3)
    for _i in 110:
        await get_tree().physics_frame
    check("залп погас в конце дистанции", world_mage._bolts.is_empty())
    Game.unequip_weapon()
    world_mage.free()
    await get_tree().process_frame

    # --- шаг 7: удары по NPC, хп, смерть, память остальных ---
    Game.new_run(3, "warrior")
    var world_w: Node2D = (load("res://scenes/world/world.tscn") as PackedScene).instantiate()
    add_child(world_w)
    await get_tree().process_frame
    await get_tree().process_frame
    var glot: Dictionary = {}
    for npc in world_w._npcs:
        if String(npc["id"]) == "glot":
            glot = npc
    check("Глот найден с хп 50 (ЗАГЛУШКА)", not glot.is_empty() and int(glot["max_hp"]) == 50)
    # воин вплотную слева от Глота, смотрит вправо
    world_w.player.position = (glot["node"] as Node2D).position + Vector2(-18, 0)
    world_w._facing = "side"
    world_w._player_sprite.flip_h = false
    # кулаки: 5 урона за удар
    world_w._strike_cd = 0.0
    world_w._strike()
    check("удар рукой снял 5 хп (50 -> 45)", int(glot["hp"]) == 45)
    check("полоска хп появилась над Глотом", (glot["hp_bar"] as ProgressBar).visible)
    check("куладдаун удара включился", world_w._strike_cd > 0.0)
    world_w._strike()
    check("куладдаун не даёт бить дважды подряд", int(glot["hp"]) == 45)
    # меч из сумки: 30 урона
    Game.add_item({"item_id": "sword", "title": "Меч", "quality": "gray"})
    check("меч в руках через Game", Game.equip_weapon("sword") and Game.strike_damage() == 30)
    check("HUD обновил оружие в руках", world_w._hud_weapon.text.contains("Меч"))
    world_w._strike_cd = 0.0
    world_w._strike()
    check("удар мечом снял 30 хп (45 -> 15)", int(glot["hp"]) == 15)
    # добиваем: 30 урона по остатку 15
    world_w._strike_cd = 0.0
    world_w._strike()
    check("Глот мёртв", bool(glot["dead"]) and Game.is_npc_dead("glot") and int(glot["hp"]) == 0)
    await get_tree().process_frame
    check("труп: спрайт повален на бок", absf((glot["sprite"] as AnimatedSprite2D).rotation) > 1.0)
    check("труп: коллизия выключена", (glot["body"].get_child(0) as CollisionShape2D).disabled)
    check("труп: полоска хп скрыта", not (glot["hp_bar"] as ProgressBar).visible)
    # мёртвый не разговаривает и не торгует
    world_w.npc_say("glot")
    await get_tree().process_frame
    check("труп молчит", not world_w._dialogue.visible)
    # остальные помнят убийство: реплика про жертву + отказ торговать
    world_w.npc_say("gura")
    await get_tree().process_frame
    check("Гура помнит: реплика про Глота", world_w._dialogue.visible \
        and world_w._dialogue._text_label.text.contains("Глота"))
    check("Гура не торгует с убийцей", not world_w._dialogue._trade_button.visible)
    world_w._dialogue._close()
    world_w.free()
    await get_tree().process_frame
    # новая игра воскрешает NPC (список убитых живёт только в сессии)
    Game.new_run(3, "warrior")
    check("новая игра воскресила NPC", Game.dead_npcs.is_empty())

    # Возвращаем исходное состояние, чтобы тест не портил сейвы.
    restore()

    if failed == 0:
        print("WORLD TEST: ВСЁ ОК")
        get_tree().quit(0)
    else:
        print("WORLD TEST: ПРОВАЛОВ: ", failed)
        get_tree().quit(1)

````

#### `tests/world_test.gd.uid`

````
uid://bxilb30c4est

````

#### `tests/world_test.tscn`

````ini
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://tests/world_test.gd" id="1_world_test"]

[node name="WorldTest" type="Node"]
script = ExtResource("1_world_test")

````

### Генераторы арта

#### `tools/check_map.py`

````python
# -*- coding: utf-8 -*-
"""Проверка world_map.gd: проходимость от спавна до всех NPC/точек интереса."""
import os
import re
from collections import deque

src = open(os.path.join(os.path.dirname(__file__), "..",
                        "scripts/data/world_map.gd")).read()
rows = re.findall(r'^\s+"([#WDkBFRdpqcg.,fsVm123456]{30})",?$', src, re.M)
assert len(rows) == 56, f"рядов: {len(rows)}"
SOLID = set("#BDFRWkf")
start = (14, 13)
targets = {"zlus": (5, 5), "lira": (16, 15), "gura": (6, 29), "viras": (23, 31),
           "glot": (22, 9), "zoran": (8, 11),
           "edge": (14, 44), "fountain": (17, 23), "stall_r": (8, 33), "stall_b": (22, 38),
           "crystal": (4, 41), "doors": (4, 1), "throne": (14, 13)}
seen = {start}
q = deque([start])
while q:
    x, y = q.popleft()
    for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
        nx, ny = x + dx, y + dy
        if 0 <= nx < 30 and 0 <= ny < 56 and (nx, ny) not in seen and rows[ny][nx] not in SOLID:
            seen.add((nx, ny))
            q.append((nx, ny))
bad = 0
for name, (tx, ty) in targets.items():
    ok = any((tx + dx, ty + dy) in seen for dx in range(-1, 2) for dy in range(-1, 2))
    if not ok:
        bad += 1
    print(name, "достижим" if ok else "!!! БЛОКИРОВАН")
print("достижимо клеток:", len(seen))
print("ПРОВАЛОВ:", bad)

````

#### `tools/gen_armor.py`

````python
# -*- coding: utf-8 -*-
"""Иконки экипировки «Dungeon Loot» (шаг 12): броня Вираса и одеяния Зорана.
Стиль и палитра — как в gen_world_art.py: 16x16, обводка INK, тени/блики.
Запуск: python3 tools/gen_armor.py
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from px import Cv, C, shade, save  # noqa: E402

# ------------------------------------------------------------- броня (куирасс)

def ic_armor(base, dark, light, trim=None):
    """Кираса: наплечники, грудь, пояс и юбка доспеха.
    base/dark/light — основной цвет металла/кожи и его грани."""
    if trim is None:
        trim = C(196, 152, 66)   # золотая фурнитура по умолчанию
    c = Cv(16, 16)
    # наплечники
    c.R(2, 3, 5, 6, base)
    c.R(10, 3, 13, 6, base)
    c.HLINE(3, 2, 5, light)
    c.HLINE(3, 10, 13, light)
    c.VLINE(2, 4, 6, dark)
    c.VLINE(13, 4, 6, dark)
    # грудь (ворот между наплечниками)
    c.R(5, 4, 10, 12, base)
    c.VLINE(5, 4, 12, light)            # блик слева
    c.VLINE(10, 4, 12, dark)            # тень справа
    c.HLINE(4, 5, 10, light)
    # вертикальный шов посередине
    c.VLINE(8, 6, 12, dark)
    c.P(8, 6, shade(base, 0.25))
    # вырез горловины
    c.R(6, 2, 9, 3, dark)
    c.HLINE(2, 6, 9, shade(dark, -0.25))
    # ремень с пряжкой
    c.R(4, 11, 11, 12, dark)
    c.R(7, 11, 8, 12, trim)
    c.P(7, 11, shade(trim, 0.3))
    # юбка доспеха (сегменты)
    c.R(4, 13, 11, 14, base)
    c.HLINE(13, 4, 11, light)
    c.VLINE(5, 13, 14, dark)
    c.VLINE(10, 13, 14, dark)
    c.P(3, 13, base)
    c.P(12, 13, base)
    c.outline()
    return c.img


def ic_armor_leather():
    # кожа: коричневая, с латунной фурнитурой
    return ic_armor(C(140, 96, 54), C(104, 68, 38), C(172, 124, 74), C(196, 152, 66))


def ic_armor_chain():
    # кольчуга: серые кольца — точки-«кольца» поверх стали
    c = ic_armor(C(150, 156, 170), C(108, 112, 128), C(186, 192, 206), C(120, 124, 140))
    img = c
    # «кольца» рисуем поверх готового силуэта — тёмные точки
    pmap = [(6, 6), (9, 6), (7, 8), (10, 8), (6, 10), (9, 10), (8, 13), (6, 14), (9, 14)]
    from PIL import Image
    for (x, y) in pmap:
        img.putpixel((x, y), C(120, 124, 140))
    return img


def ic_armor_plate():
    # латы: полированная сталь с золотой отделкой
    return ic_armor(C(178, 186, 202), C(126, 134, 152), C(222, 230, 244))


# ------------------------------------------------------------------ одеяния

def ic_robe(cloth, cloth_dark, cloth_light, trim, pattern):
    """Мантия: капюшон с пустой тенью лица, расширяющийся подол,
    золотая кайма и магический узор."""
    c = Cv(16, 16)
    # капюшон
    c.R(5, 1, 10, 5, cloth)
    c.HLINE(1, 5, 10, cloth_light)
    c.VLINE(5, 1, 5, cloth_light)
    c.VLINE(10, 1, 5, cloth_dark)
    # тень лица под капюшоном: внутри ничего не видно
    c.R(6, 3, 9, 5, C(24, 20, 36))
    c.P(7, 4, C(12, 10, 20))
    c.P(9, 3, C(12, 10, 20))
    # плечи и тело
    c.R(4, 5, 11, 9, cloth)
    c.VLINE(4, 5, 9, cloth_light)
    c.VLINE(11, 5, 9, cloth_dark)
    # рукава по бокам
    c.R(2, 6, 3, 10, cloth)
    c.R(12, 6, 13, 10, cloth)
    c.VLINE(2, 6, 10, cloth_light)
    c.VLINE(13, 6, 10, cloth_dark)
    # расширяющийся подол
    c.R(3, 10, 12, 14, cloth)
    c.R(2, 13, 13, 14, cloth_dark)
    c.HLINE(14, 2, 13, trim)            # золотая кайма
    c.HLINE(10, 3, 12, cloth_light)
    # узор на груди и подоле
    c.P(7, 7, pattern)
    c.P(9, 8, pattern)
    c.P(6, 12, pattern)
    c.P(10, 12, pattern)
    c.outline()
    return c.img


def ic_robe_faded():
    # выцветшая мантия: серо-голубая ткань, бледная серебряная кайма
    return ic_robe(C(120, 128, 152), C(88, 94, 118), C(148, 156, 180),
                   C(170, 176, 192), C(190, 200, 224))


def ic_robe_stars():
    # мантия звёздочёта: глубокая синева с золотыми звёздами
    return ic_robe(C(52, 66, 128), C(36, 46, 96), C(74, 90, 160),
                   C(196, 152, 66), C(255, 244, 180))


def ic_robe_void():
    # одеяние Пустоты: фиолетово-чёрная ткань с лиловыми вкраплениями
    return ic_robe(C(64, 44, 96), C(44, 28, 70), C(88, 62, 128),
                   C(186, 130, 255), C(150, 110, 220))


ICONS = {
    "armor_leather": ic_armor_leather,
    "armor_chain": ic_armor_chain,
    "armor_plate": ic_armor_plate,
    "robe_faded": ic_robe_faded,
    "robe_stars": ic_robe_stars,
    "robe_void": ic_robe_void,
}


def px_contact(cells):
    """Превью-лист иконок 16x16 (масштаб 4, подписи не нужны)."""
    from PIL import Image
    sheet = Image.new("RGBA", (len(cells) * 64 + (len(cells) - 1) * 8, 64),
                      (46, 48, 66, 255))
    for i, img in enumerate(cells):
        big = img.resize((64, 64), Image.NEAREST)
        sheet.alpha_composite(big, (i * 72, 0))
    return sheet


if __name__ == "__main__":
    for iid, fn in ICONS.items():
        save(fn(), "sprites/icons/%s.png" % iid)
    # превью для быстрой проверки (в /tmp, в проект не попадает)
    cells = [fn() for fn in ICONS.values()]
    save(px_contact(cells), "/tmp/armor_icons_preview.png")
    print("OK: %d иконок экипировки" % len(ICONS))

````

#### `tools/gen_chars.py`

````python
# -*- coding: utf-8 -*-
"""Генератор персонажей «Dungeon Loot» v2 — листы 24x32.
Ряды: idle_down(6), idle_side(6), idle_up(6), walk_down(4), walk_side(4), walk_up(4).
Персонажи: warrior, barbarian, bum, gura, viras, zlus, lira."""
import sys
sys.path.insert(0, "/home/z/my-project/scripts")
from px import *

W, H = 24, 32

# ---------------------------------------------------------------- позы
def pose(walking, f, dir):
    """Возвращает dict позы кадра."""
    p = {"bob": 0, "arm": 0, "lift": None, "stride": 0, "blink": False}
    if walking:
        if dir == "side":
            p["stride"] = [3, 0, -3, 0][f]
            p["bob"] = 1 if f % 2 == 1 else 0
            p["arm"] = [1, 0, -1, 0][f]
        else:
            p["lift"] = "L" if f == 0 else ("R" if f == 2 else None)
            p["bob"] = 1 if f % 2 == 1 else 0
            p["arm"] = [1, 0, -1, 0][f]
    else:
        p["bob"] = [0, 1, 1, 0, 1, 1][f % 6]
        p["blink"] = (f % 6 == 5)
    return p


def rr(c, x0, y0, x1, y1, col, r=1):
    """Прямоугольник со скруглёнными углами (r=1 — срезаны угловые пиксели)."""
    c.R(x0, y0, x1, y1, col)
    if r >= 1:
        for (x, y) in ((x0, y0), (x1, y0), (x0, y1), (x1, y1)):
            c.P(x, y, (0, 0, 0, 0))
    if r >= 2:
        for (x, y) in ((x0 + 1, y0), (x1 - 1, y0), (x0, y0 + 1), (x1, y0 + 1),
                       (x0 + 1, y1), (x1 - 1, y1), (x0, y1 - 1), (x1, y1 - 1)):
            c.P(x, y, (0, 0, 0, 0))


def erase_row(c, y, x0, x1):
    c.R(x0, y, x1, y, (0, 0, 0, 0))


# ---------------------------------------------------------------- голова
def draw_head(c, g, dir, p):
    """Череп/лицо y 3..12. bob сдвигает верх тела; здесь рисуем с учётом bob."""
    b = p["bob"]
    skin, skin_sh = g["skin"], g["skin_sh"]
    hy = b  # сдвиг головы
    # череп: y 3+hy .. 12+hy, скруглённый
    rr(c, 7, 3 + hy, 16, 12 + hy, skin, r=1)
    c.R(8, 2 + hy, 15, 3 + hy, skin)                    # макушка
    erase_row(c, 2 + hy, 8, 8); erase_row(c, 2 + hy, 15, 15)
    c.VLINE(16, 5 + hy, 11 + hy, skin_sh)               # тень справа
    c.HLINE(12 + hy, 9, 15, skin_sh)                    # низ
    c.P(8, 4 + hy, g["skin_hi"]); c.P(9, 3 + hy, g["skin_hi"])
    if dir == "down":
        if p["blink"]:
            c.HLINE(9 + hy, 9, 10, skin_sh); c.HLINE(9 + hy, 13, 14, skin_sh)
        else:
            c.R(9, 8 + hy, 10, 9 + hy, g["eye"])        # глаза 2x2
            c.R(13, 8 + hy, 14, 9 + hy, g["eye"])
            c.P(9, 8 + hy, (232, 238, 244, 255)); c.P(13, 8 + hy, (232, 238, 244, 255))
        c.P(11, 10 + hy, skin_sh); c.P(12, 10 + hy, skin_sh)     # нос
        if g.get("mouth"):
            c.HLINE(11 + hy, 11, 12, g["mouth"])
        else:
            c.HLINE(11 + hy, 11, 12, shade(skin_sh, -0.2))
        if g.get("rosy"):
            c.P(8, 10 + hy, (226, 132, 122, 255)); c.P(15, 10 + hy, (226, 132, 122, 255))
    elif dir == "side":
        c.P(17, 8 + hy, skin); c.P(17, 9 + hy, skin)    # нос
        c.P(17, 10 + hy, skin_sh)
        if p["blink"]:
            c.HLINE(9 + hy, 13, 14, skin_sh)
        else:
            c.R(13, 8 + hy, 14, 9 + hy, g["eye"])
            c.P(13, 8 + hy, (232, 238, 244, 255))
        c.HLINE(11 + hy, 12, 14, shade(skin_sh, -0.2))
        if g.get("rosy"):
            c.P(12, 10 + hy, (226, 132, 122, 255))
    # уши
    if dir == "side":
        c.R(8, 8 + hy, 9, 10 + hy, skin)
        c.P(8, 9 + hy, skin_sh)
    elif dir == "down":
        c.P(6, 9 + hy, skin); c.P(17, 9 + hy, skin)
    return hy


def draw_face_overlay(c, g, dir, p, hy):
    """Борода/усы/шрамы поверх лица (после волос)."""
    if g.get("beard") == "stubble" and dir != "up":
        d = shade(g["hair"], -0.1)
        for x in (9, 11, 13, 15):
            c.P(x, 11 + hy, d)
        if dir == "side":
            c.P(15, 11 + hy, d)
    if g.get("beard") == "mustache" and dir == "down":
        m = g["beard_c"]
        c.P(9, 10 + hy, m); c.P(10, 10 + hy, m)          # усы уголками
        c.P(13, 10 + hy, m); c.P(14, 10 + hy, m)
        c.P(9, 9 + hy, m); c.P(14, 9 + hy, m)
        c.P(11, 11 + hy, shade(m, -0.2)); c.P(12, 11 + hy, shade(m, -0.2))
    if g.get("beard") == "full" and dir != "up":
        bc = g["beard_c"]
        c.R(8, 11 + hy, 15, 12 + hy, bc)         # борода ниже рта
        c.R(9, 13 + hy, 14, 14 + hy, bc)
        c.HLINE(15 + hy, 10, 13, shade(bc, -0.2))
        if dir == "down":
            c.R(6, 11 + hy, 7, 13 + hy, bc); c.R(16, 11 + hy, 17, 13 + hy, bc)
            c.HLINE(10 + hy, 9, 10, bc)          # усы в стороны
            c.HLINE(10 + hy, 13, 14, bc)
            c.P(11, 11 + hy, shade(bc, 0.2)); c.P(12, 11 + hy, shade(bc, 0.2))
        if dir == "side":
            c.R(15, 11 + hy, 17, 13 + hy, bc)
            c.HLINE(10 + hy, 13, 15, bc)


# ---------------------------------------------------------------- волосы/головные уборы
def hair_short(c, g, dir, hy):
    hr, hr_d, hr_hi = g["hair"], g["hair_d"], g["hair_hi"]
    rr(c, 6, 2 + hy, 17, 6 + hy, hr, r=1)
    c.R(7, 1 + hy, 16, 2 + hy, hr)
    erase_row(c, 1 + hy, 7, 7); erase_row(c, 1 + hy, 16, 16)
    c.HLINE(2 + hy, 9, 14, hr_hi)
    c.HLINE(5 + hy, 6, 8, hr_d); c.HLINE(5 + hy, 15, 17, hr_d)
    if dir == "down":
        c.P(8, 6 + hy, hr); c.P(15, 6 + hy, hr)         # чёлка зубцами
        c.P(7, 7 + hy, hr_d); c.P(16, 7 + hy, hr_d)
    elif dir == "side":
        c.R(6, 3 + hy, 8, 8 + hy, hr)
        c.VLINE(6, 6 + hy, 9 + hy, hr_d)
        c.P(9, 3 + hy, hr_hi)
    else:  # up
        c.R(7, 4 + hy, 16, 11 + hy, hr)                 # затылок
        c.R(9, 5 + hy, 14, 9 + hy, hr_hi)
        c.HLINE(11 + hy, 8, 15, hr_d)
        c.R(7, 12 + hy, 16, 12 + hy, hr_d)


def hair_wild(c, g, dir, hy):
    hr, hr_d, hr_hi = g["hair"], g["hair_d"], g["hair_hi"]
    rr(c, 6, 2 + hy, 17, 5 + hy, hr, r=1)
    c.R(8, 1 + hy, 15, 2 + hy, hr)
    erase_row(c, 1 + hy, 8, 8); erase_row(c, 1 + hy, 15, 15)
    for x in (6, 9, 12, 15, 17):                         # вихры
        c.P(x, 1 + hy, hr); c.P(x, hy, hr_d)
    c.P(7, 2 + hy, hr_hi); c.P(13, 1 + hy, hr_hi)
    if dir == "up":
        c.R(7, 4 + hy, 16, 12 + hy, hr)
        c.R(9, 6 + hy, 14, 10 + hy, hr_hi)
        c.R(7, 11 + hy, 16, 12 + hy, hr_d)
    elif dir == "side":
        c.R(6, 3 + hy, 9, 10 + hy, hr)
        c.VLINE(6, 7 + hy, 10 + hy, hr_d)
        c.P(10, 4 + hy, hr_hi)
    else:
        c.P(8, 5 + hy, hr_d); c.P(15, 5 + hy, hr_d)      # рваная чёлка
        c.P(11, 5 + hy, hr); c.P(7, 6 + hy, hr_d); c.P(16, 6 + hy, hr_d)


def hair_long(c, g, dir, hy, flower=True):
    hr, hr_d, hr_hi = g["hair"], g["hair_d"], g["hair_hi"]
    rr(c, 6, 2 + hy, 17, 6 + hy, hr, r=1)
    c.R(7, 1 + hy, 16, 2 + hy, hr)
    erase_row(c, 1 + hy, 7, 7); erase_row(c, 1 + hy, 16, 16)
    # пробор
    c.VLINE(11, 2 + hy, 5 + hy, hr_d); c.VLINE(12, 2 + hy, 5 + hy, shade(hr, -0.15))
    c.HLINE(2 + hy, 8, 10, hr_hi); c.HLINE(2 + hy, 13, 15, hr_hi)
    # пряди у лица
    if dir == "down":
        c.R(5, 4 + hy, 6, 15 + hy, hr)                   # длинные пряди
        c.R(17, 4 + hy, 18, 15 + hy, hr)
        c.VLINE(5, 6 + hy, 14 + hy, hr_d); c.VLINE(18, 6 + hy, 14 + hy, hr_d)
        c.HLINE(15 + hy, 5, 6, hr_d); c.HLINE(15 + hy, 17, 18, hr_d)
        c.P(6, 4 + hy, hr_hi); c.P(17, 4 + hy, hr_hi)
        # чёлка-зубцы
        c.P(8, 5 + hy, hr); c.P(15, 5 + hy, hr); c.P(7, 6 + hy, hr); c.P(16, 6 + hy, hr)
    elif dir == "side":
        c.R(5, 3 + hy, 8, 15 + hy, hr)
        c.VLINE(5, 6 + hy, 14 + hy, hr_d)
        c.P(8, 4 + hy, hr_hi)
        c.P(9, 5 + hy, hr)
    else:
        c.R(6, 3 + hy, 17, 17 + hy, hr)                  # вся спина в волосах
        c.R(8, 4 + hy, 15, 14 + hy, hr_hi)
        c.R(6, 14 + hy, 17, 17 + hy, hr_d)
        c.HLINE(12 + hy, 7, 16, hr_d)
        c.HLINE(18 + hy, 8, 15, hr_d)
    if flower and dir != "up":
        fx = 5 if dir == "down" else 6
        c.R(fx, 2 + hy, fx + 2, 4 + hy, (250, 224, 234, 255))
        c.P(fx + 1, 3 + hy, (255, 250, 214, 255))
        c.P(fx + 1, 2 + hy, (233, 170, 190, 255)); c.P(fx, 3 + hy, (233, 170, 190, 255))


def helmet_warrior(c, g, dir, hy):
    st, st_d, st_hi = g["steel"], shade(g["steel"], -0.25), shade(g["steel"], 0.25)
    rr(c, 6, 2 + hy, 17, 6 + hy, st, r=1)
    c.R(7, 1 + hy, 16, 2 + hy, st)
    erase_row(c, 1 + hy, 7, 7); erase_row(c, 1 + hy, 16, 16)
    c.HLINE(2 + hy, 8, 15, st_hi)
    c.HLINE(6 + hy, 6, 17, st_d)                          # нижний край купола
    # гребень
    c.R(10, 0 + hy, 13, 1 + hy, (172, 44, 54, 255))
    c.P(9, 1 + hy, (172, 44, 54, 255)); c.P(14, 1 + hy, (172, 44, 54, 255))
    c.P(11, 0 + hy, (224, 96, 100, 255)); c.P(12, 0 + hy, (224, 96, 100, 255))
    if dir == "down":
        c.VLINE(11, 7 + hy, 10 + hy, st_d)                # нозальная пластина
        c.VLINE(12, 7 + hy, 10 + hy, st)
        c.R(6, 7 + hy, 8, 11 + hy, shade(st, -0.12))      # щёчные пластины
        c.R(15, 7 + hy, 17, 11 + hy, shade(st, -0.12))
        c.P(7, 7 + hy, st); c.P(16, 7 + hy, st)
    elif dir == "side":
        c.R(16, 7 + hy, 17, 11 + hy, shade(st, -0.12))    # передняя пластина
        c.P(16, 10 + hy, st_d)
    else:
        c.R(8, 7 + hy, 15, 11 + hy, shade(st, -0.18))
        c.HLINE(11 + hy, 9, 14, st_d)


def hat_chef(c, g, dir, hy):
    wh, wh_d = (242, 242, 246, 255), (206, 208, 218, 255)
    rr(c, 6, 0 + hy, 17, 3 + hy, wh, r=1)
    c.R(7, 0 + hy, 16, 0 + hy, wh)
    c.P(8, 0 + hy, wh); c.P(11, 0 + hy, wh); c.P(15, 0 + hy, wh)
    c.VLINE(17, 1 + hy, 3 + hy, wh_d)
    c.HLINE(2 + hy, 7, 12, (255, 255, 255, 255))
    c.R(7, 4 + hy, 16, 5 + hy, wh_d)                      # лента
    c.HLINE(4 + hy, 7, 16, (255, 255, 255, 255))
    if dir == "down":
        c.P(7, 5 + hy, shade(wh_d, -0.1)); c.P(16, 5 + hy, shade(wh_d, -0.1))


def hat_wizard(c, g, dir, hy):
    rc, rc_d = g["top"], shade(g["top"], -0.3)
    rc_hi = shade(g["top"], 0.25)
    c.R(5, 6 + hy, 19, 7 + hy, rc_d)                      # поля
    c.HLINE(7 + hy, 5, 19, shade(rc_d, -0.2))
    c.R(8, 3 + hy, 15, 5 + hy, rc)                        # конус
    c.R(10, 1 + hy, 13, 2 + hy, rc)
    c.R(11, 0 + hy, 12, 0 + hy, rc)
    c.P(11, 1 + hy, rc_hi); c.HLINE(4 + hy, 9, 12, rc_hi)
    c.HLINE(5 + hy, 8, 15, g.get("trim", (222, 178, 74, 255)))   # лента
    if dir == "down":
        c.P(10, 3 + hy, (238, 222, 128, 255))             # звёздочки
        c.P(14, 5 + hy, (238, 222, 128, 255))
        c.P(6, 6 + hy, rc_d); c.P(18, 6 + hy, rc_d)


# ---------------------------------------------------------------- тело
def torso(c, g, dir, p):
    b = p["bob"]
    ty = 13 + b
    top, top_d, top_hi = g["top"], shade(g["top"], -0.28), shade(g["top"], 0.2)
    if g.get("belly"):
        rr(c, 5, ty, 18, ty + 7, top, r=1)
        c.R(6, ty + 7, 17, ty + 8, top_d)
        c.R(5, ty + 5, 18, ty + 6, top)                  # живот напуском
        c.HLINE(ty + 8, 7, 16, shade(top, -0.38))
    else:
        rr(c, 6, ty, 17, ty + 7, top, r=1)
        c.R(7, ty + 7, 16, ty + 8, top_d)                # талия уже
        erase_row(c, ty + 8, 7, 7); erase_row(c, ty + 8, 16, 16)
    c.VLINE(17, ty + 1, ty + 7, top_d)
    c.HLINE(ty, 8, 15, top_hi)
    return ty


def arms(c, g, dir, p, ty, sleeve=None):
    """Руки по бокам; arm=+1/-1 мах."""
    sl = sleeve or g["sleeve"] or g["top"]
    a = p["arm"]
    if dir == "side":
        # передняя рука по центру силуэта
        y0 = ty + 1 + (1 if a > 0 else 0)
        y1 = ty + 7 + (1 if a < 0 else 0)
        c.R(11, y0, 13, y1 - 1, sl)
        c.R(11, y1, 13, y1 + 1, g["skin"])               # кисть
        c.VLINE(13, y0, y1 + 1, shade(sl, -0.28))
        return
    y0L, y1L = ty + 1 + (1 if a < 0 else 0), ty + 7
    y0R, y1R = ty + 1 + (1 if a > 0 else 0), ty + 7
    c.R(4, y0L, 6, y1L, sl); c.R(17, y0R, 19, y1R, sl)
    c.R(4, y1L + 1, 6, y1L + 1, g["skin"]); c.R(17, y1R + 1, 19, y1R + 1, g["skin"])
    c.VLINE(6, y0L, y1L, shade(sl, -0.28)); c.VLINE(19, y0R, y1R, shade(sl, -0.28))
    c.VLINE(4, y0L, y1L, shade(sl, 0.15)); c.VLINE(17, y0R, y1R, shade(sl, 0.15))


def belt(c, g, ty, x0=6, x1=17):
    c.HLINE(ty + 8, x0, x1, g.get("belt", (94, 66, 44, 255)))
    c.P((x0 + x1) // 2, ty + 8, (226, 182, 78, 255))
    c.P((x0 + x1) // 2 + 1, ty + 8, (226, 182, 78, 255))


def legs(c, g, dir, p):
    """Ноги y22..31. lift: поднятая нога; stride: шаг вбок."""
    pants, boots = g["pants"], g["boots"]
    pants_d, boots_d = shade(pants, -0.25), shade(boots, -0.28)
    if dir == "side":
        s = p["stride"]
        if s != 0:
            fx0 = 12 + (1 if s > 0 else 0)               # передняя нога
            bx0 = 8 - (1 if s > 0 else 0)
            c.R(fx0, 22, fx0 + 2, 29, pants)
            c.R(bx0, 22, bx0 + 2, 29, pants_d)
            c.R(fx0 - 1 if s > 0 else fx0, 30, fx0 + 3 if s > 0 else fx0 + 2, 31, boots)
            c.R(bx0 - 1 if s < 0 else bx0, 30, bx0 + 2, 31, boots_d)
        else:
            c.R(10, 22, 12, 29, pants); c.R(13, 22, 15, 29, pants_d)
            c.R(9, 30, 12, 31, boots); c.R(13, 30, 16, 31, boots_d)
        return
    lift = p["lift"]
    l_end, r_end = 29, 29
    if lift == "L":
        l_end = 26
    elif lift == "R":
        r_end = 26
    c.R(7, 22, 10, l_end, pants); c.R(13, 22, 16, r_end, pants)
    c.VLINE(10, 22, l_end, pants_d); c.VLINE(16, 22, r_end, pants_d)
    if l_end == 29:
        c.R(6, 30, 11, 31, boots)
        c.HLINE(30, 6, 11, shade(boots, 0.2))
    else:
        c.R(6, l_end + 1, 11, l_end + 3, boots)          # поднятая ступня
        c.HLINE(l_end + 1, 6, 11, shade(boots, 0.2))
    if r_end == 29:
        c.R(12, 30, 17, 31, boots)
        c.HLINE(30, 12, 17, shade(boots, 0.2))
    else:
        c.R(12, r_end + 1, 17, r_end + 3, boots)
        c.HLINE(r_end + 1, 12, 17, shade(boots, 0.2))


def robe(c, g, dir, p):
    rc, rc_d, rc_hi = g["top"], shade(g["top"], -0.3), shade(g["top"], 0.2)
    b = p["bob"]
    ty = 13 + b
    rr(c, 6, ty, 17, ty + 6, rc, r=1)
    c.R(5, ty + 5, 18, ty + 9, rc)
    c.R(4, ty + 9, 19, ty + 13, rc)
    erase_row(c, ty + 13, 4, 4); erase_row(c, ty + 13, 19, 19)
    c.VLINE(17, ty + 1, ty + 12, rc_d)
    c.R(5, ty + 12, 18, ty + 13, rc_d)
    c.HLINE(ty, 8, 15, rc_hi)
    c.VLINE(9, ty + 6, ty + 12, rc_d)                     # складки
    c.VLINE(13, ty + 7, ty + 12, rc_d)
    # широкие рукава
    a = p["arm"]
    c.R(3, ty + 1 + (1 if a < 0 else 0), 6, ty + 7, rc)
    c.R(17, ty + 1 + (1 if a > 0 else 0), 20, ty + 7, rc)
    c.R(3, ty + 7, 6, ty + 9, rc_d); c.R(17, ty + 7, 20, ty + 9, rc_d)
    c.P(5, ty + 9, g["skin"]); c.P(18, ty + 9, g["skin"])
    # кайма
    c.HLINE(ty + 12, 5, 18, g.get("trim", (222, 178, 74, 255)))
    c.HLINE(ty + 13, 6, 17, shade(g.get("trim", (222, 178, 74, 255)), -0.3))
    # ступни
    c.R(7, 30, 10, 31, g["boots"]); c.R(13, 30, 16, 31, g["boots"])


def dress(c, g, dir, p):
    dc = g["top"]
    dc_d, dc_hi = shade(dc, -0.26), shade(dc, 0.24)
    trim = g.get("trim", (238, 196, 92, 255))
    b = p["bob"]
    ty = 13 + b
    # лиф
    rr(c, 7, ty, 16, ty + 5, dc, r=1)
    c.VLINE(16, ty + 1, ty + 5, dc_d)
    c.HLINE(ty, 9, 14, dc_hi)
    # руки (открытые)
    a = p["arm"]
    c.R(5, ty + 1 + (1 if a < 0 else 0), 6, ty + 6, g["skin"])
    c.R(17, ty + 1 + (1 if a > 0 else 0), 18, ty + 6, g["skin"])
    c.VLINE(6, ty + 1, ty + 6, g["skin_sh"]); c.VLINE(17, ty + 1, ty + 6, g["skin_sh"])
    c.P(5, ty + 7 + (1 if a < 0 else 0), g["skin"]); c.P(18, ty + 7 + (1 if a > 0 else 0), g["skin"])
    if dir == "down":
        c.P(5, ty + 6, g["skin"]); c.P(18, ty + 6, g["skin"])    # плечи
    # пышные рукавчики
    c.R(4, ty, 6, ty + 2, dc); c.R(17, ty, 19, ty + 2, dc)
    c.P(5, ty + 2, dc_d); c.P(18, ty + 2, dc_d)
    # пояс
    c.HLINE(ty + 6, 7, 16, trim)
    c.P(11, ty + 6, (255, 236, 150, 255)); c.P(12, ty + 6, (255, 236, 150, 255))
    # юбка-колокол
    sway = p["stride"] if dir == "side" else 0
    x0, x1 = 6 - (1 if sway > 0 else 0), 17 + (1 if sway > 0 else 0)
    if sway < 0:
        x0, x1 = 7, 16
    c.R(7, ty + 7, 16, ty + 9, dc)
    c.R(x0, ty + 10, x1, ty + 13, dc)
    hem_x0, hem_x1 = (x0 - 1 if sway >= 0 else x0), (x1 + 1 if sway >= 0 else x1)
    c.R(hem_x0, ty + 14, hem_x1, ty + 16, dc)
    c.VLINE(x1, ty + 7, ty + 16, dc_d)
    c.VLINE(10, ty + 8, ty + 15, dc_d); c.VLINE(14, ty + 8, ty + 15, dc_d)
    c.HLINE(ty + 7, 8, 15, dc_hi)
    c.HLINE(ty + 15, hem_x0 + 1, hem_x1 - 1, shade(dc, 0.3))  # свет на кромке
    c.HLINE(ty + 16, hem_x0, hem_x1, dc_d)
    # подвеска
    if dir == "down":
        c.P(11, ty + 1, trim); c.P(12, ty + 2, (255, 244, 190, 255))
        c.P(11, ty + 2, trim)
    # туфельки
    c.R(7, 30, 10, 31, g["boots"]); c.R(13, 30, 16, 31, g["boots"])


# ---------------------------------------------------------------- оружие/детали
def weapon(c, g, dir, p, ty):
    w = g.get("weapon")
    if not w:
        return
    wd = (96, 68, 44, 255)
    met, met_d = (196, 206, 220, 255), (128, 138, 154, 255)
    gold = (226, 182, 78, 255)
    if w == "sword":
        if dir == "up":
            c.R(17, ty - 7, 18, ty + 2, met_d)            # клинок над плечом
            c.VLINE(17, ty - 7, ty + 2, met)
            c.HLINE(ty - 8, 16, 19, gold)
            c.P(17, ty - 9, met_d); c.P(18, ty - 9, met_d)
        else:
            c.R(3, ty + 6, 4, ty + 14, (58, 66, 92, 255))  # ножны у левого бедра
            c.P(4, ty + 6, (70, 80, 108, 255))
            c.HLINE(ty + 5, 3, 5, gold)
            c.P(5, ty + 4, (58, 66, 92, 255))
    elif w == "axe":
        if dir == "up":
            c.VLINE(16, ty - 6, ty + 8, wd)
            c.R(13, ty - 9, 18, ty - 7, met)
            c.VLINE(18, ty - 9, ty - 7, met_d)
            c.P(14, ty - 10, met); c.P(17, ty - 10, met)
        else:
            c.VLINE(19, ty - 3, ty + 2, wd)               # топорище над плечом
            c.R(18, ty - 6, 20, ty - 4, met)
            c.P(20, ty - 5, met_d); c.P(18, ty - 6, shade(met, 0.25))
    elif w == "staff":
        orb = (128, 224, 242, 255)
        c.VLINE(20, ty - 5, ty + 13, wd)                  # посох справа
        c.R(19, ty - 8, 21, ty - 6, orb)
        c.P(20, ty - 8, (222, 248, 255, 255))
        c.P(19, ty - 6, shade(orb, -0.3))
        c.P(20, ty - 5, shade(wd, -0.3))
    elif w == "hammer":
        if dir == "up":
            c.VLINE(7, ty - 4, ty + 8, wd)
            c.R(5, ty - 7, 9, ty - 5, met)
            c.HLINE(ty - 7, 6, 8, shade(met, 0.25))
        else:
            c.VLINE(19, ty - 1, ty + 8, wd)               # в правой руке
            c.R(17, ty - 4, 21, ty - 2, met)
            c.HLINE(ty - 4, 18, 20, shade(met, 0.3))
            c.VLINE(21, ty - 4, ty - 2, met_d)


def char_extras(c, g, dir, p, ty):
    if g.get("fur") and dir != "up":
        f = g["fur_c"]
        c.R(3, ty - 1, 7, ty + 1, f); c.R(16, ty - 1, 20, ty + 1, f)
        c.P(4, ty + 2, f); c.P(6, ty + 2, f); c.P(17, ty + 2, f); c.P(19, ty + 2, f)
        c.P(5, ty - 2, shade(f, 0.22)); c.P(18, ty - 2, shade(f, 0.22))
        c.P(3, ty, f); c.P(8, ty, f); c.P(15, ty, f); c.P(20, ty, f)
    if g.get("apron") and dir != "up":
        ap = g["apron"]
        c.R(8, ty + 1, 15, ty + 7, ap)
        c.VLINE(15, ty + 1, ty + 7, shade(ap, -0.25))
        c.HLINE(ty + 1, 9, 14, shade(ap, 0.18))
        c.VLINE(8, ty + 1, ty + 2, shade(ap, -0.15))
        if g.get("belly"):
            c.R(8, ty + 6, 16, ty + 8, ap)
            c.VLINE(16, ty + 6, ty + 8, shade(ap, -0.25))
    if g.get("neckerchief") and dir == "down":
        c.HLINE(ty, 9, 14, g["neckerchief"])
        c.P(11, ty + 1, g["neckerchief"]); c.P(12, ty + 1, g["neckerchief"])
    if g.get("patches"):
        for (px, py, pc) in g["patches"]:
            c.R(ty + py, px, ty + py + 1, px + 1, pc)
    if g.get("bottle") and dir == "down":
        c.R(3, ty + 4, 4, ty + 8, (118, 82, 44, 255))
        c.P(3, ty + 3, (154, 172, 92, 255)); c.P(4, ty + 3, (154, 172, 92, 255))
    if g.get("bracers") and dir != "side":
        br = g["bracers"]
        c.R(4, ty + 5, 6, ty + 6, br); c.R(17, ty + 5, 19, ty + 6, br)
    if g.get("soot") and dir == "down":
        c.P(15, 9 + p["bob"], (92, 88, 92, 255)); c.P(15, 10 + p["bob"], (92, 88, 92, 255))
    if g.get("armor_ridge") and dir != "up":
        st = g["armor_ridge"]
        c.VLINE(11, ty + 1, ty + 6, st)
        c.VLINE(12, ty + 1, ty + 6, shade(st, -0.2))
        c.P(8, ty + 2, st); c.P(15, ty + 2, st)          # заклёпки
        c.P(8, ty + 5, st); c.P(15, ty + 5, st)


# ---------------------------------------------------------------- сборка
def draw_frame(g, dir, f, walking):
    c = Cv(W, H)
    p = pose(walking, f, dir)
    hy = p["bob"]
    if g.get("robe"):
        robe(c, g, dir, p)
    elif g.get("dress"):
        dress(c, g, dir, p)
    else:
        legs(c, g, dir, p)
        ty = torso(c, g, dir, p)
        arms(c, g, dir, p, ty)
        belt(c, g, ty)
        char_extras(c, g, dir, p, ty)
    draw_head(c, g, dir, p)
    if g.get("helmet"):
        helmet_warrior(c, g, dir, hy)
        draw_face_overlay(c, g, dir, p, hy)
    else:
        hs = g.get("hair_style", "short")
        if hs == "short":
            hair_short(c, g, dir, hy)
        elif hs == "wild":
            hair_wild(c, g, dir, hy)
        elif hs == "long":
            hair_long(c, g, dir, hy, flower=g.get("flower", False))
        h = g.get("hat")
        if h == "chef":
            hat_chef(c, g, dir, hy)
        elif h == "wizard":
            hat_wizard(c, g, dir, hy)
        draw_face_overlay(c, g, dir, p, hy)
    if g.get("robe"):
        # борода поверх мантии + посох
        draw_face_overlay(c, g, dir, p, hy)
    if g.get("weapon"):
        weapon(c, g, dir, p, 13 + p["bob"])
    if g.get("bow_back") and dir == "up":
        c.R(10, 6, 13, 8, (198, 42, 62, 255))            # бант на затылке
        c.P(11, 7, (240, 198, 94, 255)); c.P(12, 7, (240, 198, 94, 255))
    c.outline()
    return c.img


# ---------------------------------------------------------------- конфиги
def G(**kw):
    d = {
        "skin": SKIN, "skin_sh": SKIN_SH, "skin_hi": SKIN_HI,
        "hair": (74, 52, 38, 255), "hair_d": shade((74, 52, 38, 255), -0.35),
        "hair_hi": shade((74, 52, 38, 255), 0.3),
        "top": (110, 110, 130, 255), "sleeve": None,
        "pants": (52, 56, 74, 255), "boots": (74, 56, 44, 255),
        "belt": (94, 66, 44, 255), "eye": (40, 36, 50, 255),
        "hair_style": "short", "beard": "none",
    }
    d.update(kw)
    return d


CHARS = {
    "warrior": G(
        hair=(84, 62, 44, 255), hair_style="short",
        top=(62, 86, 158, 255), pants=(58, 62, 84, 255), boots=(66, 52, 44, 255),
        belt=(70, 74, 92, 255), helmet=True,
        steel=(176, 186, 200, 255), armor_ridge=(150, 190, 230, 255),
        weapon="sword",
    ),
    "barbarian": G(
        hair=(72, 50, 36, 255), hair_style="wild",
        top=(152, 98, 62, 255), sleeve=(152, 98, 62, 255),
        pants=(108, 44, 52, 255), boots=(62, 46, 38, 255),
        belt=(84, 60, 38, 255), fur=True, fur_c=(134, 92, 58, 255),
        beard="stubble", weapon="axe", bracers=(96, 66, 40, 255),
    ),
    "bum": G(
        skin=(224, 176, 138, 255), skin_sh=(192, 138, 100, 255),
        hair=(84, 70, 56, 255), hair_style="wild",
        top=(120, 110, 94, 255), pants=(76, 70, 62, 255), boots=(54, 48, 42, 255),
        beard="stubble", patches=[(9, 2, (96, 108, 72, 255)), (13, 5, (88, 78, 66, 255))],
        bottle=True,
    ),
    "gura": G(
        skin=(242, 192, 152, 255), rosy=True, hair=(148, 96, 58, 255),
        top=(240, 240, 246, 255), sleeve=(240, 240, 246, 255),
        pants=(54, 62, 86, 255), boots=(58, 50, 46, 255),
        hat="chef", beard="mustache", beard_c=(118, 108, 98, 255),
        belly=True, neckerchief=(196, 60, 60, 255),
    ),
    "viras": G(
        skin=(216, 158, 112, 255), hair=(60, 44, 34, 255), hair_style="bald",
        top=(150, 98, 62, 255), sleeve=(150, 98, 62, 255),
        pants=(64, 56, 50, 255), boots=(50, 44, 40, 255),
        beard="full", beard_c=(66, 50, 40, 255), apron=(122, 84, 52, 255),
        weapon="hammer", soot=True,
    ),
    "zlus": G(
        skin=(228, 180, 142, 255), hair=(224, 224, 232, 255),
        hair_d=(188, 188, 200, 255), hair_hi=(255, 255, 255, 255),
        top=(108, 74, 164, 255), pants=(78, 52, 122, 255), boots=(52, 38, 66, 255),
        hat="wizard", beard="full", beard_c=(224, 224, 232, 255),
        robe=True, trim=(226, 182, 78, 255), weapon="staff",
    ),
    "lira": G(
        skin=(248, 202, 160, 255), rosy=True,
        hair=(228, 184, 98, 255), hair_d=(186, 140, 62, 255), hair_hi=(252, 226, 150, 255),
        hair_style="long", flower=True,
        top=(198, 42, 62, 255), boots=(208, 166, 86, 255),
        dress=True, trim=(240, 198, 94, 255), mouth=(190, 76, 80, 255),
        bow_back=True,
    ),
    # --- шаг 6: играбельный маг + два торговца в замке ---
    "mage": G(
        skin=(240, 196, 156, 255), rosy=True,
        hair=(56, 48, 76, 255), hair_d=(40, 34, 56, 255), hair_hi=(88, 78, 116, 255),
        hair_style="short",
        top=(44, 96, 128, 255), pants=(36, 74, 100, 255), boots=(40, 34, 52, 255),
        hat="wizard", robe=True, trim=(120, 200, 220, 255), weapon="staff",
    ),
    "glot": G(
        skin=(238, 188, 148, 255), rosy=True,
        hair=(96, 62, 40, 255), hair_style="short",
        top=(86, 122, 74, 255), sleeve=(86, 122, 74, 255),
        pants=(70, 52, 42, 255), boots=(54, 42, 34, 255),
        belt=(80, 58, 40, 255), belly=True,
        apron=(214, 204, 186, 255), beard="stubble",
    ),
    "zoran": G(
        skin=(222, 172, 132, 255),
        hair=(168, 170, 186, 255), hair_d=(130, 132, 150, 255),
        hair_hi=(210, 212, 226, 255), hair_style="long", flower=False,
        top=(58, 58, 96, 255), sleeve=(58, 58, 96, 255),
        pants=(48, 48, 70, 255), boots=(44, 40, 56, 255),
        beard="full", beard_c=(178, 180, 196, 255),
        trim=(150, 110, 220, 255), weapon="sword",
    ),
}

ROWS = [("idle_down", 6, False), ("idle_side", 6, False), ("idle_up", 6, False),
        ("walk_down", 4, True), ("walk_side", 4, True), ("walk_up", 4, True)]


def build_sheet(cid):
    sheet = Image.new("RGBA", (6 * W, 6 * H), (0, 0, 0, 0))
    for r, (row, n, walking) in enumerate(ROWS):
        dir = row.split("_")[1]
        for f in range(n):
            img = draw_frame(CHARS[cid], dir, f, walking)
            sheet.paste(img, (f * W, r * H))
    return sheet


if __name__ == "__main__":
    import os
    for cid in CHARS:
        save(build_sheet(cid), f"sprites/chars/{cid}.png")
    cells, labels = [], []
    for cid in CHARS:
        for row, n, walking in ROWS:
            cells.append(draw_frame(CHARS[cid], row.split("_")[1], 0, walking))
            labels.append(f"{cid}:{row}")
    save(contact(cells, W, H, cols=6, scale=7, bg=(52, 54, 76, 255), labels=labels), "/tmp/chars_v2.png")
    print("OK")

````

#### `tools/gen_demon.py`

````python
# -*- coding: utf-8 -*-
"""Генератор Таинственного демона «Dungeon Loot» (шаг 8).
Демон втрое крупнее обычных NPC: кадры 72x96 (лист 432x576).
Ряды как у персонажей 24x32: idle_down(6), idle_side(6), idle_up(6),
walk_down(4), walk_side(4), walk_up(4).
Демон парит над землёй: вместо ног — хвост с огоньком, «ходьба» — полёт.
Портрет 64x64 для диалогов: assets/sprites/portraits/demon.png."""
import os
import sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from px import *

FW, FH = 72, 96

# ---------------------------------------------------------------- палитра
BODY = C(126, 38, 48)        # багровая кожа
BODY_SH = C(94, 26, 38)
BODY_HI = C(168, 62, 66)
BODY_DK = C(74, 20, 32)
WING = C(58, 38, 82)         # тёмно-фиолетовые крылья
WING_HI = C(84, 54, 116)
HORN = C(226, 210, 186)      # костяные рога
HORN_SH = C(172, 152, 136)
EYE_GLOW = C(255, 186, 64)   # горящие янтарные глаза
EYE_CORE = C(255, 238, 152)
FANG = C(236, 232, 218)
MOUTH = C(46, 14, 22)
FLAME = C(255, 128, 44)      # огонёк на хвосте
FLAME_HI = C(255, 198, 96)
AURA = C(96, 60, 140)        # лиловая аура

def pose(walking, f, dir):
    """Параметры кадра демона."""
    p = {"bob": 0, "arm": 0, "tail": 0, "glow": False, "blink": False}
    if walking:
        p["bob"] = [-3, 0, 1, 0][f]
        p["arm"] = [2, 0, -2, 0][f]
        p["tail"] = [3, 0, -3, 0][f]
        p["glow"] = True
    else:
        p["bob"] = [0, 1, 1, 0, 1, 1][f % 6]
        p["arm"] = 0
        p["tail"] = [0, 1, 2, 0, -1, -2][f % 6]
        p["glow"] = (f % 6) in (3, 4)
        p["blink"] = (f % 6 == 5)
    return p


def rr(c, x0, y0, x1, y1, col, r=1):
    """Прямоугольник со срезанными угловыми пикселями."""
    c.R(x0, y0, x1, y1, col)
    if r >= 1:
        for (x, y) in ((x0, y0), (x1, y0), (x0, y1), (x1, y1)):
            c.P(x, y, (0, 0, 0, 0))


# ---------------------------------------------------------------- крылья
def draw_wings(c, dir, p):
    """Крылья за спиной; со спины (up) раскрыты шире."""
    cx = 36
    top = 40 + p["bob"]
    if dir == "up":
        # раскрытые крылья: широкие перепонки по обе стороны
        c.ellipse(cx - 24, top + 14, 13, 16, WING)
        c.ellipse(cx + 24, top + 14, 13, 16, WING)
        c.ellipse(cx - 20, top + 12, 8, 10, WING_HI)
        c.ellipse(cx + 20, top + 12, 8, 10, WING_HI)
        # костяные опоры перепонок
        for dy in (0, 10, 20):
            c.HLINE(cx - 34 + dy // 2, top + dy + 2, cx - 16, WING_HI if dy == 0 else WING)
            c.HLINE(cx + 16, top + dy + 2, cx + 34 - dy // 2, WING_HI if dy == 0 else WING)
        for dx in (-1, 1):
            x = cx + dx * 30
            c.VLINE(x, top - 2, top + 14, HORN_SH)
            c.P(x, top - 3, HORN)
    else:
        # сложенные за спиной: видны по бокам торса
        c.ellipse(cx - 21, top + 14, 8, 15, WING)
        c.ellipse(cx + 21, top + 14, 8, 15, WING)
        c.ellipse(cx - 21, top + 12, 5, 9, WING_HI)
        c.ellipse(cx + 21, top + 12, 5, 9, WING_HI)
        # костяные отростки крыльев
        for dx in (-1, 1):
            x = cx + dx * 25
            c.VLINE(x, top - 2, top + 16, HORN_SH)
            c.P(x, top - 3, HORN)
            c.P(x + dx, top - 2, HORN_SH)


# ---------------------------------------------------------------- хвост
def draw_tail(c, dir, p):
    """Хвост вместо ног: изгиб вниз с огоньком на кончике."""
    cx = 36
    base_y = 72 + p["bob"]
    sway = p["tail"]
    if dir == "side":
        sway -= 5   # волочится позади
    pts = []
    for i in range(7):
        t = i / 6.0
        x = cx + int(8 * (1 - t) * (1 if dir != "up" else 0)) + int(sway * (t * t)) \
            + int(sway * 0.4 * t)
        y = base_y + int(t * 16)
        pts.append((x, y))
    for (x, y) in pts:
        c.R(x - 3, y, x + 3, y + 3, BODY_SH)
        c.R(x - 2, y, x + 2, y + 2, BODY)
        c.P(x, y, BODY_HI)
    # кончик-огонёк
    tip = pts[-1]
    c.ellipse(tip[0], tip[1] + 4, 3, 4, FLAME)
    c.ellipse(tip[0], tip[1] + 4, 1, 2, FLAME_HI)
    c.P(tip[0], tip[1] + 3, FLAME_HI)


# ---------------------------------------------------------------- торс
def draw_torso(c, dir, p):
    cx = 36
    top = 46 + p["bob"]
    rr(c, cx - 18, top, cx + 18, top + 28, BODY, r=2)
    # объём: тени по бокам, блик по центру груди
    c.VLINE(cx - 18, top + 4, top + 25, BODY_SH)
    c.VLINE(cx + 18, top + 4, top + 25, BODY_SH)
    c.VLINE(cx - 17, top + 4, top + 25, BODY_DK)
    c.VLINE(cx + 17, top + 4, top + 25, BODY_DK)
    c.R(cx - 9, top + 3, cx - 2, top + 12, BODY_HI)
    c.R(cx + 3, top + 3, cx + 10, top + 12, BODY_HI)
    c.HLINE(top + 13, cx - 9, cx + 10, BODY_SH)        # под грудными
    c.R(cx - 6, top + 18, cx + 6, top + 19, BODY_SH)   # пресс
    c.R(cx - 3, top + 22, cx + 3, top + 23, BODY_DK)
    # низ уходит в тень (хвост)
    c.R(cx - 11, top + 26, cx + 11, top + 28, BODY_SH)
    if dir == "side":
        # профиль: плечо ближе к зрителю
        c.VLINE(cx + 14, top, top + 20, BODY_HI)


# ---------------------------------------------------------------- руки
def draw_arms(c, dir, p):
    cx = 36
    top = 46 + p["bob"]
    arm = p["arm"]
    for dx in (-1, 1):
        ax = cx + dx * 19
        swing = arm * dx if dir != "side" else arm
        sh_y = top + 2
        elbow_y = sh_y + 12
        hand_y = elbow_y + 10 + (swing if dir != "side" else 0)
        c.R(ax - 3, sh_y, ax + 3, elbow_y, BODY)
        c.VLINE(ax + dx * 3, sh_y + 2, elbow_y, BODY_SH)
        c.VLINE(ax - dx * 2, sh_y + 1, elbow_y, BODY_HI)
        c.R(ax - 4, elbow_y, ax + 4, hand_y, BODY)
        c.VLINE(ax + dx * 4, elbow_y + 2, hand_y - 1, BODY_SH)
        # большие когти
        for k in (-2, 0, 2):
            c.R(ax + k, hand_y + 1, ax + k + 1, hand_y + 5, HORN)
            c.P(ax + k + (1 if k < 0 else 0), hand_y + 6, HORN_SH)
            c.P(ax + k + 1, hand_y, HORN_SH)


# ---------------------------------------------------------------- голова
def draw_head(c, dir, p):
    cx = 36
    top = 46 + p["bob"]
    hy = top - 36             # верх черепа (y≈10)
    blink = p["blink"]
    glow = p["glow"]
    if dir == "side":
        # профиль вправо
        hx = cx + 5
        rr(c, hx - 17, hy, hx + 17, hy + 34, BODY, r=2)
        c.VLINE(hx + 17, hy + 5, hy + 29, BODY_SH)
        c.VLINE(hx + 16, hy + 5, hy + 29, BODY_DK)
        # морда выступает
        c.R(hx + 10, hy + 16, hx + 18, hy + 24, BODY)
        c.R(hx + 12, hy + 18, hx + 18, hy + 24, BODY_SH)
        c.HLINE(hy + 8, hx - 14, hx + 12, BODY_HI)
        # рога: пара, уходят вверх-назад
        for (dx, dy, ln) in ((-12, -6, 8), (-5, -10, 9)):
            c.R(hx + dx, hy + dy, hx + dx + 4, hy + dy + ln, HORN)
            c.VLINE(hx + dx + 4, hy + dy + 1, hy + dy + ln, HORN_SH)
            c.P(hx + dx + 2, hy + dy - 1, HORN)
            c.P(hx + dx + 3, hy + dy - 2, HORN)
        # глаз
        if not blink:
            ex = hx + 4
            c.R(ex, hy + 18, ex + 7, hy + 22, EYE_GLOW)
            c.R(ex + 2, hy + 19, ex + 7, hy + 22, EYE_CORE)
            c.P(ex + 4, hy + 20, EYE_CORE)
        else:
            c.HLINE(hy + 20, hx + 4, hx + 11, BODY_DK)
        # бровь
        c.HLINE(hy + 16, hx + 3, hx + 12, BODY_DK)
        # ухмылка
        c.R(hx + 8, hy + 28, hx + 18, hy + 32, MOUTH)
        for fx in (hx + 9, hx + 13):
            c.VLINE(fx, hy + 28, hy + 31, FANG)
            c.P(fx, hy + 32, FANG)
        return
    # вид спереди или сзади
    rr(c, cx - 17, hy, cx + 17, hy + 34, BODY, r=2)
    c.VLINE(cx + 17, hy + 6, hy + 28, BODY_SH)
    c.VLINE(cx + 16, hy + 6, hy + 28, BODY_DK)
    c.R(cx - 12, hy + 2, cx + 12, hy + 5, BODY_HI)
    c.P(cx - 13, hy + 3, BODY_HI)
    if dir == "up":
        # затылок: без лица, рога вперёд не видны, кожа и тень
        c.R(cx - 10, hy + 12, cx + 10, hy + 28, BODY_SH)
        c.HLINE(hy + 30, cx - 14, cx + 14, BODY_DK)
        # рога торчат вверх
        for dx in (-1, 1):
            bx = cx + dx * 12
            c.R(bx - 1, hy - 8, bx + 2, hy - 2, HORN)
            c.P(bx + (2 if dx > 0 else -1), hy - 9, HORN)
        return
    # лицо: рога — большие, изогнутые наружу
    for dx in (-1, 1):
        bx = cx + dx * 14
        seg = [(bx, hy - 6), (bx + dx * 4, hy - 11), (bx + dx * 7, hy - 15)]
        for (sx, sy) in seg:
            c.R(min(sx, sx + dx * 3), sy, max(sx, sx + dx * 3) + dx * 2, sy + 4, HORN)
        c.P(bx + dx * 2, hy - 5, HORN_SH)
        c.P(bx + dx * 5, hy - 9, HORN_SH)
        tip_x = bx + dx * 9
        c.P(tip_x, hy - 16, HORN)
        c.P(tip_x - dx, hy - 16, HORN)
        c.P(tip_x, hy - 17, HORN)
    # уши острые
    for dx in (-1, 1):
        ex = cx + dx * 18
        c.R(ex, hy + 16, ex + dx * 3, hy + 22, BODY)
        c.P(ex + dx * 3, hy + 15, BODY_SH)
        c.P(ex + dx * 3, hy + 16, BODY_DK)
    # глаза: горящие щели
    if not blink:
        for dx in (-1, 1):
            ex = cx + dx * 9 - (5 if dx < 0 else 0)
            c.R(ex, hy + 16, ex + 6, hy + 21, EYE_GLOW)
            c.R(ex + 1, hy + 17, ex + 6, hy + 21, EYE_CORE)
            c.P(ex + 3, hy + 19, EYE_CORE)
        if glow:
            for dx in (-1, 1):
                ex = cx + dx * 9 - (5 if dx < 0 else 0)
                c.P(ex - 1, hy + 16, AURA)
                c.P(ex + 7, hy + 21, AURA)
    else:
        c.HLINE(hy + 19, cx - 13, cx - 4, BODY_DK)
        c.HLINE(hy + 19, cx + 4, cx + 13, BODY_DK)
    # нахмуренные брови
    c.HLINE(hy + 13, cx - 13, cx - 5, BODY_DK)
    c.P(cx - 4, hy + 14, BODY_DK)
    c.HLINE(hy + 13, cx + 5, cx + 13, BODY_DK)
    c.P(cx + 4, hy + 14, BODY_DK)
    # широкая ухмылка с клыками
    c.R(cx - 12, hy + 26, cx + 12, hy + 30, MOUTH)
    c.P(cx - 12, hy + 31, MOUTH)
    c.P(cx + 12, hy + 31, MOUTH)
    for fx in (cx - 9, cx - 3, cx + 3, cx + 8):
        c.R(fx, hy + 26, fx + 1, hy + 29, FANG)
        c.P(fx, hy + 30, FANG)


# ---------------------------------------------------------------- кадр

def frame(walking, f, dir):
    c = Cv(FW, FH)
    p = pose(walking, f, dir)
    draw_wings(c, dir, p)
    draw_tail(c, dir, p)
    draw_torso(c, dir, p)
    draw_arms(c, dir, p)
    draw_head(c, dir, p)
    c.outline()
    return c


def gen_sheet():
    rows = [
        ("idle_down", False, "down", 6), ("idle_side", False, "side", 6),
        ("idle_up", False, "up", 6),
        ("walk_down", True, "down", 4), ("walk_side", True, "side", 4),
        ("walk_up", True, "up", 4),
    ]
    sheet = Image.new("RGBA", (FW * 6, FH * len(rows)), (0, 0, 0, 0))
    for r, (name, walking, dir, count) in enumerate(rows):
        for f in range(count):
            c = frame(walking, f, dir)
            sheet.paste(c.img, (f * FW, r * FH), c.img)
    save(sheet, "sprites/chars/demon.png")
    return sheet


# ---------------------------------------------------------------- портрет

def gen_portrait():
    S = 64
    c = Cv(S, S)
    # фон: космос + лиловое свечение
    for y in range(S):
        k = y / (S - 1)
        c.HLINE(y, 0, S - 1, C(int(16 + 10 * k), int(12 + 8 * k), int(28 + 16 * k)))
    cx, cy, rad = 32, 32, 30
    for y in range(S):
        for x in range(S):
            d = ((x - cx) ** 2 + (y - cy) ** 2) ** 0.5
            if d < rad:
                a = int(90 * (1 - d / rad) ** 2)
                base = c.px_map.get((x, y), (16, 12, 28, 255))
                c.P(x, y, C(base[0] + 60 * a // 255, base[1] + 20 * a // 255,
                            base[2] + 90 * a // 255))
    for (x, y, b) in ((6, 10, 200), (57, 8, 160), (10, 49, 140), (54, 46, 190),
                      (15, 15, 120), (49, 54, 130), (60, 22, 150), (4, 29, 130)):
        c.P(x, y, C(b, b, min(255, b + 40)))
    # рога: большие, от краёв макушки вверх
    for dx in (-1, 1):
        bx = 32 + dx * 17
        seg = [(bx, 8), (bx + dx * 3, 5), (bx + dx * 5, 2)]
        for i, (sx, sy) in enumerate(seg):
            c.R(min(sx, sx + dx * 2), sy, max(sx, sx + dx * 2) + dx, sy + 8 - i * 2, HORN)
        c.P(bx + dx * 6, 1, HORN)
        c.P(bx + dx * 6, 0, HORN)
        c.P(bx + dx * 2, 9, HORN_SH)
    # голова
    c.R(13, 12, 50, 48, BODY)
    c.R(15, 10, 48, 12, BODY)
    c.R(17, 48, 46, 52, BODY)
    c.VLINE(50, 16, 46, BODY_SH)
    c.VLINE(49, 16, 46, BODY_DK)
    c.R(46, 44, 50, 48, BODY_SH)
    c.R(16, 12, 34, 16, BODY_HI)
    c.P(14, 13, BODY_HI)
    # уши острые
    for dx in (-1, 1):
        ex = 32 + dx * 20
        c.R(ex, 28, ex + dx * 4, 36, BODY)
        c.P(ex + dx * 4, 27, BODY_SH)
        c.P(ex + dx * 4, 28, BODY_DK)
    # глаза: горящие щели
    for dx in (-1, 1):
        ex = 32 + dx * 10 - (6 if dx < 0 else 0)
        c.R(ex, 28, ex + 8, 34, EYE_GLOW)
        c.R(ex + 2, 30, ex + 8, 34, EYE_CORE)
        c.P(ex + 4, 32, EYE_CORE)
        c.P(ex - 1, 28, AURA)
        c.P(ex + 9, 34, AURA)
        # брови-рогалки
        c.HLINE(27, ex, ex + 8, BODY_DK)
        c.P(ex + (8 if dx > 0 else 0), 25, BODY_DK)
        c.P(ex + (8 if dx > 0 else 0), 26, BODY_DK)
    # широкая ухмылка с клыками
    c.R(18, 42, 45, 48, MOUTH)
    c.R(19, 48, 44, 49, BODY_SH)
    for fx in (21, 26, 36, 41):
        c.R(fx, 42, fx + 1, 45, FANG)
        c.P(fx, 46, FANG)
    c.HLINE(44, 18, 45, BODY_DK)
    # воротник-плащ
    c.R(4, 54, 59, 63, WING)
    c.R(0, 58, 63, 63, WING)
    c.VLINE(59, 54, 63, shade(WING, -0.3))
    c.VLINE(63, 58, 63, shade(WING, -0.3))
    c.HLINE(54, 6, 57, WING_HI)
    c.R(28, 52, 35, 54, BODY_DK)   # горло
    c.outline()
    save(c.img, "sprites/portraits/demon.png")


if __name__ == "__main__":
    print("Генерация Таинственного демона (шаг 8):")
    gen_sheet()
    gen_portrait()
    print("Готово.")

````

#### `tools/gen_doors.py`

````python
# -*- coding: utf-8 -*-
"""Шаг 9: явные запертые двери данжей для мира «Dungeon Loot».
Спрайт 32x16 — ровно две верхних тайла стены (D D): каменная рама,
двойные створки с железными полосами, золотые заклёпки и фиолетовый
зловещий зев между створками (подземелья ещё спят).
Запуск: python3 tools/gen_doors.py"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from px import *  # noqa: F401,F403

STONE = C(96, 94, 116)
STONE_HI = C(118, 116, 138)
STONE_SH = C(76, 74, 94)
WOOD = C(92, 62, 38)
WOOD_SH = C(72, 48, 30)
WOOD_HI = C(110, 78, 48)
IRON = C(116, 122, 136)
IRON_HI = C(146, 152, 166)
GOLD = C(224, 188, 80)
GLOW = C(150, 80, 220)
GLOW_HI = C(210, 160, 255)
VOID = C(18, 14, 30)


def gen_door() -> None:
    """Двойная запертая дверь данжа 32x16 (два тайла стены)."""
    c = Cv(32, 16)
    # каменная рама по всему периметру
    c.R(0, 0, 31, 15, STONE)
    c.HLINE(0, 0, 31, STONE_HI)
    c.HLINE(15, 0, 31, STONE_SH)
    # кладка рамы
    for x in (7, 16, 24):
        c.VLINE(x, 0, 1, STONE_SH)
    c.P(3, 1, STONE_SH); c.P(28, 1, STONE_SH)
    # зловещий зев подземелья: тьма за створками
    c.R(2, 2, 29, 14, VOID)
    # створки: левая x=3..15, правая x=16..28
    c.R(3, 2, 15, 14, WOOD)
    c.R(16, 2, 28, 14, WOOD)
    for x in range(3, 16, 4):                    # доски
        c.VLINE(x, 2, 14, WOOD_SH)
    for x in range(16, 29, 4):
        c.VLINE(x, 2, 14, WOOD_SH)
    c.HLINE(2, 3, 15, WOOD_HI)
    c.HLINE(2, 16, 28, WOOD_HI)
    # щель между створками: фиолетовый свет изнутри
    c.VLINE(15, 2, 14, GLOW)
    c.VLINE(16, 2, 14, GLOW)
    for y in (4, 8, 12):
        c.P(15, y, GLOW_HI)
        c.P(16, y, GLOW_HI)
    # железные полосы поперёк створок
    for y in (5, 10):
        c.R(3, y, 15, y + 1, IRON)
        c.R(16, y, 28, y + 1, IRON)
        c.HLINE(y, 3, 28, IRON_HI)
        # полосы не гасят свет щели
        c.P(15, y, GLOW); c.P(15, y + 1, GLOW)
        c.P(16, y, GLOW); c.P(16, y + 1, GLOW)
    # золотые заклёпки на полосах и рога рамы
    for x in (4, 9, 14, 17, 22, 27):
        c.P(x, 5, GOLD)
        c.P(x, 11, GOLD)
    c.P(1, 1, GOLD); c.P(30, 1, GOLD)
    c.P(1, 14, GOLD); c.P(30, 14, GOLD)
    # рунные точки над створками: данжи ещё «спят»
    for x in (6, 11, 20, 25):
        c.P(x, 1, GLOW)
    # замковая накладка по центру
    c.R(14, 6, 17, 9, IRON)
    c.HLINE(6, 14, 17, IRON_HI)
    c.P(15, 7, GOLD); c.P(16, 7, GOLD)
    c.P(15, 8, GOLD); c.P(16, 8, GOLD)
    c.outline()
    save(c.img, "sprites/props/door_dungeon.png")


if __name__ == "__main__":
    print("Генерация двери данжа (шаг 9):")
    gen_door()
    print("Готово.")

````

#### `tools/gen_dungeon.py`

````python
# -*- coding: utf-8 -*-
"""Генератор арта 1-го подземелья «Dungeon Loot» (шаг 13).
Тайлы: assets/tilesets/dungeon_tiles.png — атлас 16x16 (8x8 клеток):
  (0,0) стена #, (1,0) колонна o, (0,1) пол ., (1,1) пол , (2,1) пол ;,
  (3,1) кости b, (0,2) лестница вверх <, (1,2) лестница вниз >,
  (2,2) выход в замок X.
Враги: листы 24x32 (те же ряды, что у персонажей): idle_down(6),
idle_side(6), idle_up(6), walk_down(4), walk_side(4), walk_up(4).
Порядок по возрастанию сложности (шаг 13): паук, змея, космический паук,
мертвец бомж, мертвец рыцарь, мертвец колдун, демон мечник, демон колдун."""
import os
import sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from px import *

W, H = 24, 32

def rr(c, x0, y0, x1, y1, col, r=1):
    c.R(x0, y0, x1, y1, col)
    if r >= 1:
        for (x, y) in ((x0, y0), (x1, y0), (x0, y1), (x1, y1)):
            c.P(x, y, (0, 0, 0, 0))


# ---------------------------------------------------------------- тайлы

STONE = C(38, 34, 46)        # стена
STONE_HI = C(52, 47, 62)
STONE_LO = C(26, 23, 34)
FLOOR = C(56, 51, 62)        # пол
FLOOR_HI = C(66, 61, 74)
FLOOR_LO = C(46, 42, 54)
MOSS = C(58, 74, 52)
BONE = C(212, 204, 182)
BONE_SH = C(168, 158, 140)
STAIR = C(96, 88, 104)
STAIR_HI = C(120, 110, 130)
STAIR_LO = C(30, 27, 38)
GLOW = C(146, 92, 196)
GLOW_HI = C(206, 156, 240)


def gen_tiles():
    T = 16
    sheet = Image.new("RGBA", (T * 8, T * 8), (0, 0, 0, 0))

    def stone_base(c, shade_map=None):
        c.R(0, 0, T - 1, T - 1, STONE)
        for (x, y) in ((0, 0), (T - 1, 0), (0, T - 1), (T - 1, T - 1)):
            c.P(x, y, STONE_LO)
        # швы кладки
        c.HLINE(5, 0, T - 1, STONE_LO)
        c.HLINE(11, 0, T - 1, STONE_LO)
        c.VLINE(8, 0, 5, STONE_LO)
        c.VLINE(4, 6, 11, STONE_LO)
        c.VLINE(12, 6, 11, STONE_LO)
        c.VLINE(8, 12, T - 1, STONE_LO)
        # блики на кирпичах
        c.R(1, 1, 6, 3, STONE_HI)
        c.R(10, 7, 11, 9, STONE_HI)
        c.R(2, 13, 6, 14, STONE_HI)

    def wall(c):
        stone_base(c)

    def pillar(c):
        c.R(2, 0, T - 3, T - 1, C(64, 58, 74))
        c.VLINE(2, 0, T - 1, C(44, 40, 54))
        c.VLINE(T - 3, 0, T - 1, C(44, 40, 54))
        c.R(4, 0, T - 5, 2, C(78, 71, 92))
        c.R(4, T - 4, T - 5, T - 1, C(78, 71, 92))
        c.VLINE(6, 3, T - 5, C(76, 69, 88))
        c.VLINE(10, 3, T - 5, C(48, 43, 60))

    def floor(c, speckle=True):
        c.R(0, 0, T - 1, T - 1, FLOOR)
        c.R(0, 0, T - 1, 0, FLOOR_LO)
        c.R(0, T - 1, T - 1, T - 1, FLOOR_LO)
        if speckle:
            for (x, y) in ((3, 4), (9, 2), (13, 7), (5, 10), (11, 12), (7, 14)):
                c.P(x, y, FLOOR_LO)
            for (x, y) in ((2, 12), (12, 4), (6, 6)):
                c.P(x, y, FLOOR_HI)

    def floor_cracked(c):
        floor(c)
        c.VLINE(7, 1, 6, STONE_LO)
        c.P(8, 7, STONE_LO)
        c.VLINE(6, 8, 10, STONE_LO)
        c.HLINE(6, 12, 14, STONE_LO)
        c.P(11, 13, STONE_LO)

    def floor_mossy(c):
        floor(c)
        c.ellipse(4, 12, 3, 2, C(50, 62, 46))
        c.ellipse(11, 5, 2, 1, C(50, 62, 46))
        c.P(5, 11, MOSS)
        c.P(4, 12, MOSS)
        c.P(12, 5, MOSS)
        c.P(11, 6, C(46, 56, 42))

    def floor_bones(c):
        floor(c)
        # череп и рёбра
        rr(c, 3, 8, 7, 12, BONE, r=1)
        c.P(4, 10, STONE_LO)
        c.P(6, 10, STONE_LO)
        c.HLINE(12, 10, 13, BONE_SH)
        c.HLINE(13, 10, 13, BONE)
        c.HLINE(14, 10, 13, BONE_SH)
        c.P(2, 6, BONE)
        c.P(2, 5, BONE_SH)

    def stairs_up(c):
        # светлые ступени, ведущие к свету
        for i, y in enumerate(range(2, 14, 3)):
            c.R(1, y, T - 2, y + 2, C(96 - i * 10, 88 - i * 10, 104 - i * 10))
            c.HLINE(y, 1, T - 2, STAIR_HI if i < 2 else STAIR)
        c.HLINE(14, 1, T - 2, STAIR_LO)

    def stairs_down(c):
        # тёмные ступени, ведущие во тьму
        for i, y in enumerate(range(2, 14, 3)):
            c.R(1, y, T - 2, y + 2, C(52 + i * 8, 48 + i * 8, 60 + i * 8))
            c.HLINE(y + 2, 1, T - 2, C(26, 23, 32))
        c.HLINE(14, 1, T - 2, C(14, 12, 20))

    def exit_hatch(c):
        floor(c)
        rr(c, 2, 2, T - 3, T - 3, C(30, 20, 46), r=1)
        rr(c, 4, 4, T - 5, T - 5, C(52, 32, 78), r=1)
        c.ellipse(8, 8, 3, 3, GLOW)
        c.ellipse(8, 8, 1, 1, GLOW_HI)
        c.HLINE(4, 4, T - 5, C(96, 66, 132))
        c.VLINE(4, 4, T - 5, C(96, 66, 132))

    tiles = [
        (0, 0, wall), (1, 0, pillar),
        (0, 1, floor), (1, 1, floor_cracked), (2, 1, floor_mossy),
        (3, 1, floor_bones),
        (0, 2, stairs_up), (1, 2, stairs_down), (2, 2, exit_hatch),
    ]
    for (cx, cy, painter) in tiles:
        c = Cv(T, T)
        painter(c)
        sheet.paste(c.img, (cx * T, cy * T), c.img)
    save(sheet, "tilesets/dungeon_tiles.png")
    return sheet


# ---------------------------------------------------------------- враги

# --- пауки (паук, космический паук) ---
def spider_frame(c, dir, p, pal, cosmic=False):
    bob = p.get("bob", 0)
    cx, cy = 12, 17 + bob
    leg_swing = p.get("stride", 0)
    # ноги: по 4 с каждой стороны, шаг чередует фронт/тыл
    for side in (-1, 1):
        for i in range(4):
            x0 = cx + side * 4
            y0 = cy - 2 + i * 2
            swing = leg_swing if i % 2 == 0 else -leg_swing
            if dir == "side":
                x0 = cx + side * 5 + (2 if side > 0 else -2)
            knee_x = x0 + side * 5 + swing
            knee_y = y0 - 3
            tip_x = x0 + side * 6 + swing * 2
            tip_y = y0 + 7
            col = pal["leg"]
            for t in range(6):
                lx = int(x0 + (knee_x - x0) * t / 5.0 + (tip_x - knee_x) * max(0, t - 3) / 3.0)
                ly = int(y0 + (knee_y - y0) * t / 5.0 * (1 if t < 4 else 0)
                         + (tip_y - knee_y) * max(0, t - 3) / 3.0)
                c.P(lx, ly, col)
            c.P(knee_x, knee_y, shade(col, 0.15))
    # тело: два отдела
    c.ellipse(cx, cy, 5, 4, pal["body"])
    c.ellipse(cx, cy - 1, 3, 2, pal["body_hi"])
    c.ellipse(cx, cy + 4, 4, 3, pal["body_sh"])
    if cosmic:
        # звёздные точки на панцире
        for (dx, dy) in ((-2, -1), (2, 0), (0, 1), (-1, 2)):
            c.P(cx + dx, cy + dy + (1 if cosmic else 0), pal["spark"])
    # глаза: впереди (вниз) или сбоку
    if dir == "down":
        for dx in (-2, -1, 1, 2):
            c.P(cx + dx, cy - 3, pal["eye"])
            c.P(cx + dx, cy - 2, shade(pal["eye"], -0.4))
    elif dir == "side":
        c.P(cx + 4, cy - 2, pal["eye"])
        c.P(cx + 5, cy - 1, shade(pal["eye"], -0.4))
    if p.get("blink"):
        pass
    # хелицеры вниз
    if dir == "down":
        c.VLINE(cx - 1, cy + 1, cy + 3, pal["body_sh"])
        c.VLINE(cx + 1, cy + 1, cy + 3, pal["body_sh"])


# --- змея ---
def snake_frame(c, dir, p, pal):
    bob = p.get("bob", 0)
    sway = p.get("stride", 0)
    pts = []
    if dir == "side":
        for i in range(8):
            t = i / 7.0
            x = 4 + int(16 * t)
            y = 20 + int(3 * ((1 - t) if i > 5 else t)) + int(2 * ((1 if i % 2 else -1) if sway else 0))
            pts.append((x, y))
        head = (20, 20 - 2 * (1 if sway else 0) + bob)
        hd = 1
    elif dir == "up":
        for i in range(8):
            t = i / 7.0
            x = 12 + int(3 * (1 - t)) + int(2 * ((1 if i % 2 else -1) * (1 if sway else 0)))
            y = 26 - int(16 * t)
            pts.append((x, y))
        head = (pts[-1][0] - 1, pts[-1][1] - 2)
        hd = -1
    else:
        for i in range(8):
            t = i / 7.0
            x = 12 + int(3 * (1 - t)) + int(2 * ((1 if i % 2 else -1) * (1 if sway else 0)))
            y = 10 + int(16 * t)
            pts.append((x, y))
        head = (pts[-1][0] + 1, pts[-1][1] + 2)
        hd = 1
    for i, (x, y) in enumerate(pts):
        r = 3 - int(1 * (i / 7.0) > 0.6)
        c.ellipse(x, y + bob // 2, max(1, r - 1), max(1, r), pal["body"])
        if i % 2 == 0:
            c.P(x, y, pal["body_hi"])
        if i % 3 == 0:
            c.P(x, y + r - 1, pal["body_sh"])
    # голова
    hx, hy = head
    c.ellipse(hx, hy, 2, 3, pal["body"])
    c.ellipse(hx, hy - 1, 1, 1, pal["body_hi"])
    if dir != "up":
        eye_x = hx + (1 if dir == "side" else 0) + hd
        c.P(eye_x, hy - 1, pal["eye"])
        # жала
        c.P(hx + hd * 2, hy + 1, pal["tongue"])
        c.P(hx + hd * 3, hy + 1, pal["tongue"])


# --- гуманоиды (мертвецы и демоны) ---
def humanoid_frame(c, dir, p, pal, opt):
    bob = p.get("bob", 0)
    stride = p.get("stride", 0)
    arm = p.get("arm", 0)
    cx = 12
    top = 6 + bob
    ragged = opt.get("ragged", False)
    # ноги
    leg_top = 22
    for side in (-1, 1):
        x = cx + side * 3
        step = stride * side if dir == "side" else stride
        c.R(x - 2, leg_top, x + 1, 29 - abs(step), pal["leg"])
        c.R(x - 2, 28 - abs(step), x + 1, 29, pal["boot"])
        if side < 0:
            c.VLINE(x - 2, leg_top, 28, shade(pal["leg"], -0.25))
    # торс
    rr(c, cx - 5, top + 10, cx + 5, top + 21, pal["body"], r=1)
    c.VLINE(cx - 5, top + 11, top + 20, shade(pal["body"], -0.25))
    c.VLINE(cx - 1, top + 11, top + 20, shade(pal["body"], 0.12))
    if ragged:
        for (dx0, dy0, dx1, dy1) in ((-3, 14, -2, 16), (2, 17, 3, 19), (-1, 19, 0, 20)):
            c.R(cx + dx0, top + dy0, cx + dx1, top + dy1, pal["rag"])
    if opt.get("armor"):
        # наплечники и нагрудник
        c.R(cx - 6, top + 10, cx - 4, top + 13, pal["armor"])
        c.R(cx + 4, top + 10, cx + 6, top + 13, pal["armor"])
        c.HLINE(top + 13, cx - 4, cx + 4, shade(pal["armor"], -0.3))
        c.P(cx, top + 15, pal["armor_hi"])
    if opt.get("robe"):
        # мантия вместо ног
        rr(c, cx - 5, top + 10, cx + 5, 29, pal["body"], r=1)
        c.VLINE(cx - 5, top + 12, 28, shade(pal["body"], -0.3))
        c.HLINE(26, cx - 4, cx + 4, shade(pal["body"], -0.2))
        c.P(cx - 2, 27, pal["hood_dark"])
    # руки
    for side in (-1, 1):
        ax = cx + side * 6
        swing = arm * side if dir != "side" else arm
        c.R(ax - 1, top + 11, ax + 1, top + 18 + (swing if dir != "side" else 0),
            pal["limb"])
        c.R(ax - 1, top + 18 + swing, ax + 1, top + 20 + swing, pal["skin"])
    # голова
    hy = top
    if opt.get("hood"):
        rr(c, cx - 4, hy, cx + 4, hy + 9, pal["body"], r=1)
        c.R(cx - 2, hy + 2, cx + 2, hy + 8, pal["hood_dark"])
        if dir != "up":
            for dx in (-1, 1):
                c.P(cx + dx, hy + 4, pal["eye"])
    elif opt.get("helm"):
        rr(c, cx - 4, hy, cx + 4, hy + 8, pal["armor"], r=1)
        c.HLINE(hy + 4, cx - 4, cx + 4, shade(pal["armor"], -0.35))
        c.HLINE(hy + 2, cx - 4, cx + 4, pal["armor_hi"])
        if dir == "down":
            c.R(cx - 3, hy + 5, cx + 3, hy + 6, pal["hood_dark"])
            for dx in (-2, 0, 2):
                c.P(cx + dx, hy + 5, pal["eye"])
        elif dir == "side":
            c.P(cx + 2, hy + 5, pal["eye"])
        # гребень шлема
        c.R(cx - 1, hy - 1, cx + 1, hy, pal["armor_hi"])
    else:
        rr(c, cx - 4, hy, cx + 4, hy + 8, pal["skin"], r=1)
        c.VLINE(cx + 3, hy + 1, hy + 7, shade(pal["skin"], -0.25))
        if dir == "down":
            for dx in (-2, 1):
                c.P(cx + dx, hy + 3, pal["eye"])
            c.P(cx + dx + 1, hy + 3, pal["eye"])
            c.HLINE(hy + 6, cx - 2, cx + 2, shade(pal["skin"], -0.4))
            if ragged:
                c.P(cx - 2, hy + 2, shade(pal["skin"], -0.3))
                c.P(cx + 1, hy + 7, shade(pal["skin"], -0.3))
        elif dir == "side":
            c.P(cx + 2, hy + 3, pal["eye"])
            c.HLINE(hy + 6, cx + 1, cx + 3, shade(pal["skin"], -0.4))
    # рога демона
    if opt.get("horns"):
        for dx in (-1, 1):
            bx = cx + dx * 4
            c.R(min(bx, bx + dx * 2), hy - 1, max(bx, bx + dx * 2), hy + 1, pal["horn"])
            c.P(bx + dx * 3, hy - 2, pal["horn"])
    # оружие
    if opt.get("sword"):
        wx = cx + 7
        hy_sword = top + 2
        c.R(wx, hy_sword, wx + 1, top + 16, pal["blade"])
        c.VLINE(wx + 1, hy_sword + 1, top + 16, shade(pal["blade"], -0.3))
        c.R(wx - 1, top + 16, wx + 3, top + 17, pal["hilt"])
        c.R(wx, top + 17, wx + 1, top + 20, pal["hilt"])
    if opt.get("staff"):
        wx = cx + 7
        c.R(wx, top - 1, wx + 1, top + 20, pal["staff"])
        c.ellipse(wx, top - 3, 2, 2, pal["orb"])
        c.P(wx, top - 4, pal["orb_hi"])
    if opt.get("cloak"):
        # рваный плащ сзади (вид сбоку)
        if dir == "side":
            c.R(cx - 6, top + 10, cx - 4, 29, pal["rag"])


def pose(walking, f, dir):
    p = {"bob": 0, "arm": 0, "stride": 0, "blink": False}
    if walking:
        p["stride"] = [2, 0, -2, 0][f]
        p["bob"] = 1 if f % 2 == 1 else 0
        p["arm"] = [1, 0, -1, 0][f]
    else:
        p["bob"] = [0, 1, 1, 0, 1, 1][f % 6]
        p["blink"] = (f % 6 == 5)
    return p


# ---------------------------------------------------------------- палитры

SPIDER_PAL = {
    "body": C(64, 44, 40), "body_hi": C(88, 62, 54), "body_sh": C(44, 30, 28),
    "leg": C(40, 28, 26), "eye": C(226, 84, 60), "spark": C(200, 160, 90),
}
COSMIC_PAL = {
    "body": C(74, 52, 110), "body_hi": C(104, 78, 148), "body_sh": C(52, 36, 82),
    "leg": C(44, 32, 68), "eye": C(240, 210, 120), "spark": C(216, 196, 255),
}
SNAKE_PAL = {
    "body": C(58, 92, 56), "body_hi": C(84, 124, 78), "body_sh": C(40, 66, 42),
    "eye": C(240, 200, 70), "tongue": C(220, 90, 70),
}
BUM_PAL = {
    "skin": C(148, 152, 128), "body": C(78, 72, 62), "rag": C(56, 52, 46),
    "limb": C(70, 64, 56), "leg": C(64, 58, 52), "boot": C(46, 42, 38),
    "eye": C(190, 210, 160), "horn": C(0, 0, 0),
}
KNIGHT_PAL = {
    "skin": C(150, 148, 142), "body": C(88, 88, 98), "rag": C(60, 60, 68),
    "limb": C(78, 78, 88), "leg": C(72, 72, 82), "boot": C(52, 52, 60),
    "armor": C(104, 104, 118), "armor_hi": C(140, 140, 156),
    "hood_dark": C(24, 22, 30), "eye": C(120, 220, 200),
    "blade": C(150, 150, 162), "hilt": C(96, 72, 48), "horn": C(0, 0, 0),
}
SORC_PAL = {
    "skin": C(132, 140, 124), "body": C(52, 66, 58), "rag": C(38, 48, 44),
    "limb": C(46, 58, 52), "leg": C(42, 52, 47), "boot": C(30, 36, 33),
    "armor": C(64, 78, 70), "armor_hi": C(90, 106, 94),
    "hood_dark": C(18, 24, 21), "eye": C(120, 240, 150),
    "staff": C(66, 54, 44), "orb": C(110, 220, 150), "orb_hi": C(190, 255, 210),
    "horn": C(0, 0, 0), "hood": True,
}
DSWORD_PAL = {
    "skin": C(150, 62, 54), "body": C(126, 38, 48), "rag": C(90, 28, 36),
    "limb": C(110, 34, 44), "leg": C(96, 30, 40), "boot": C(60, 20, 28),
    "armor": C(146, 44, 50), "armor_hi": C(180, 70, 66),
    "hood_dark": C(40, 12, 18), "eye": C(255, 186, 64),
    "blade": C(196, 196, 208), "hilt": C(110, 78, 46),
    "horn": C(226, 210, 186),
}
DSORC_PAL = {
    "skin": C(150, 62, 54), "body": C(96, 40, 92), "rag": C(70, 28, 66),
    "limb": C(84, 34, 80), "leg": C(72, 30, 68), "boot": C(48, 20, 46),
    "armor": C(110, 46, 104), "armor_hi": C(146, 64, 138),
    "hood_dark": C(30, 12, 28), "eye": C(255, 170, 90),
    "staff": C(70, 52, 66), "orb": C(190, 110, 230), "orb_hi": C(240, 190, 255),
    "horn": C(226, 210, 186),
}

# id -> (фабрика кадра, опции гуманоида)
FOE_FACTORIES = {
    "spider": lambda c, dir, p: spider_frame(c, dir, p, SPIDER_PAL),
    "snake": lambda c, dir, p: snake_frame(c, dir, p, SNAKE_PAL),
    "cosmic_spider": lambda c, dir, p: spider_frame(c, dir, p, COSMIC_PAL, cosmic=True),
    "undead_bum": lambda c, dir, p: humanoid_frame(c, dir, p, BUM_PAL,
        {"ragged": True}),
    "undead_knight": lambda c, dir, p: humanoid_frame(c, dir, p, KNIGHT_PAL,
        {"armor": True, "helm": True, "sword": True}),
    "undead_sorcerer": lambda c, dir, p: humanoid_frame(c, dir, p, SORC_PAL,
        {"robe": True, "hood": True, "staff": True}),
    "demon_swordsman": lambda c, dir, p: humanoid_frame(c, dir, p, DSWORD_PAL,
        {"horns": True, "sword": True}),
    "demon_sorcerer": lambda c, dir, p: humanoid_frame(c, dir, p, DSORC_PAL,
        {"horns": True, "robe": True, "hood": True, "staff": True}),
}

SHEET_ROWS = [
    ("idle_down", False, "down", 6), ("idle_side", False, "side", 6),
    ("idle_up", False, "up", 6),
    ("walk_down", True, "down", 4), ("walk_side", True, "side", 4),
    ("walk_up", True, "up", 4),
]


def gen_foe_sheets():
    sheets = {}
    for foe_id, factory in FOE_FACTORIES.items():
        sheet = Image.new("RGBA", (W * 6, H * 6), (0, 0, 0, 0))
        for r, (name, walking, dir, count) in enumerate(SHEET_ROWS):
            for f in range(count):
                c = Cv(W, H)
                p = pose(walking, f, dir)
                factory(c, dir, p)
                c.outline()
                sheet.paste(c.img, (f * W, r * H), c.img)
        save(sheet, "sprites/dungeon/%s.png" % foe_id)
        sheets[foe_id] = sheet
    return sheets


def gen_preview(sheets, tiles):
    """Превью врагов и тайлов для быстрой проверки глазами."""
    from PIL import ImageDraw
    scale = 3
    cols = 4
    ids = list(FOE_FACTORIES.keys())
    rows = (len(ids) + cols - 1) // cols + 1
    cell_w, cell_h = W * scale, H * scale
    pv = Image.new("RGBA", (cols * cell_w, rows * cell_h + 64), (30, 28, 42, 255))
    d = ImageDraw.Draw(pv)
    for i, foe_id in enumerate(ids):
        x = (i % cols) * cell_w
        y = (i // cols) * cell_h
        img = sheets[foe_id].crop((0, 0, W * 6 // 4, H))
        img = img.resize((W * scale, H * scale), Image.NEAREST)
        pv.paste(img, (x + 4, y + 4), img)
        d.text((x + 6, y + 2), foe_id, fill=(255, 255, 140, 255))
    # тайлы в ряд
    ty = rows * cell_h + 8
    T = 16
    for i, (cx, cy) in enumerate([(0, 0), (1, 0), (0, 1), (1, 1), (2, 1), (3, 1),
                                  (0, 2), (1, 2), (2, 2)]):
        img = tiles.crop((cx * T, cy * T, (cx + 1) * T, (cy + 1) * T))
        img = img.resize((T * 4, T * 4), Image.NEAREST)
        pv.paste(img, (i * T * 4 + 4, ty + 14), img)
    save(pv, "../dungeon_foes_preview.png")


if __name__ == "__main__":
    print("Генерация арта подземелья (шаг 13):")
    tiles = gen_tiles()
    sheets = gen_foe_sheets()
    gen_preview(sheets, tiles)
    print("Готово.")

````

#### `tools/gen_portraits.py`

````python
# -*- coding: utf-8 -*-
"""Портреты 64x64 для диалогов «Dungeon Loot».
Крупные пиксельные боты: фон с акцентным свечением, детальное лицо, одежда."""
import sys
sys.path.insert(0, "/home/z/my-project/scripts")
from px import *

S = 64
INK = (18, 14, 26, 255)

def bg(c, accent):
    """Фон: градиент + свечение за головой + искры."""
    for y in range(S):
        k = y / (S - 1)
        col = C(int(14 + 10 * k), int(12 + 9 * k), int(24 + 14 * k))
        c.HLINE(y, 0, S - 1, col)
    # свечение за головой
    cx, cy, r = 32, 30, 26
    for y in range(S):
        for x in range(S):
            d = ((x - cx) ** 2 + (y - cy) ** 2) ** 0.5
            if d < r:
                a = int(70 * (1 - d / r) ** 2)
                ar, ag, ab = accent
                base = c.px_map.get((x, y), (14, 12, 24, 255))
                c.P(x, y, C(base[0] + ar * a // 255, base[1] + ag * a // 255,
                            base[2] + ab * a // 255))
    # звёздные искры
    for (x, y, b) in ((7, 9, 200), (55, 7, 160), (11, 46, 140), (53, 42, 190),
                      (17, 16, 120), (48, 52, 130), (58, 22, 150), (5, 28, 130)):
        c.P(x, y, C(b, b, min(255, b + 40)))
        c.P(x + 1, y, C(b // 2, b // 2, b // 2 + 30))


def bust(c, g):
    """Шея, плечи, голова-заготовка. Возвращает словарь точек."""
    skin, skin_sh, skin_hi = g["skin"], g["skin_sh"], g["skin_hi"]
    # шея
    c.R(27, 36, 36, 43, skin)
    c.R(27, 36, 36, 38, skin_sh)                       # тень от подбородка
    c.VLINE(36, 36, 43, skin_sh)
    # плечи/грудь (одежда рисуется поверх)
    c.R(14, 47, 49, 63, g["cloth"])
    c.R(10, 52, 53, 63, g["cloth"])
    c.R(14, 45, 49, 47, g["cloth"])
    c.VLINE(49, 47, 63, shade(g["cloth"], -0.3))
    c.VLINE(53, 52, 63, shade(g["cloth"], -0.3))
    c.HLINE(45, 18, 45, shade(g["cloth"], 0.22))
    # голова
    c.R(20, 8, 43, 32, skin)                           # череп
    c.R(22, 6, 41, 8, skin)
    c.R(24, 34, 39, 36, skin)                          # челюсть
    c.R(26, 36, 37, 37, skin)                          # подбородок
    c.VLINE(43, 10, 32, skin_sh)                       # тени
    c.R(41, 30, 43, 33, skin_sh)
    c.HLINE(36, 27, 36, skin_sh)
    c.R(40, 32, 42, 35, skin_sh)                       # скула справа
    c.P(22, 7, skin_hi); c.R(23, 6, 30, 7, skin_hi)    # блик макушки
    c.P(21, 9, skin_hi)
    # уши
    c.R(17, 22, 19, 28, skin); c.R(44, 22, 46, 28, skin)
    c.P(18, 24, skin_sh); c.P(45, 24, skin_sh)


def eyes(c, g, iris, y=21, sad=False, thick_brow=True):
    """Глаза 5x4 с радужкой и брови."""
    wh = (236, 240, 246, 255)
    for lx in (23, 36):
        c.R(lx, y, lx + 4, y + 3, wh)
        c.R(lx + 1, y, lx + 3, y + 3, iris)            # радужка
        c.P(lx + 2, y + 1, (16, 14, 22, 255))          # зрачок
        c.P(lx + 1, y, (255, 255, 255, 255))           # блик
        c.HLINE(y + 4, lx, lx + 4, (18, 14, 26, 255))  # ресничная линия
        c.HLINE(y - 1, lx + 3, lx + 4, (18, 14, 26, 255))
    # брови
    bc = g["brow"]
    if sad:
        c.HLINE(y - 4, 23, 26, bc); c.P(27, y - 3, bc)
        c.HLINE(y - 3, 36, 39, bc); c.P(35, y - 3, bc)
    elif thick_brow:
        c.HLINE(y - 3, 22, 27, bc); c.HLINE(y - 3, 36, 41, bc)
        c.P(22, y - 2, bc); c.P(41, y - 2, bc)
    else:
        c.HLINE(y - 3, 23, 27, bc); c.HLINE(y - 3, 36, 40, bc)


def nose_mouth(c, g, smile=True, lips=None, wrinkles=False):
    skin_sh = g["skin_sh"]
    c.R(31, 28, 32, 30, skin_sh)                       # нос
    c.P(30, 30, skin_sh); c.P(33, 30, skin_sh)         # ноздри
    if lips:
        c.R(28, 34, 35, 35, lips)
        c.HLINE(36, 29, 34, shade(lips, 0.3))
        c.P(28, 35, shade(lips, -0.2)); c.P(35, 35, shade(lips, -0.2))
    elif smile:
        c.HLINE(34, 28, 35, (120, 72, 62, 255))
        c.P(27, 33, (120, 72, 62, 255)); c.P(36, 33, (120, 72, 62, 255))
    else:
        c.HLINE(34, 29, 34, (110, 70, 62, 255))
    if g.get("rosy"):
        for x in range(23, 27):
            c.P(x, 31, (232, 138, 128, 255)); c.P(x, 32, (226, 128, 120, 255))
        for x in range(38, 42):
            c.P(x, 31, (232, 138, 128, 255)); c.P(x, 32, (226, 128, 120, 255))
    if wrinkles:
        for x in range(26, 38):
            if x % 2 == 0:
                c.P(x, 16, g["skin_sh"])
        c.HLINE(30, 25, 27, g["skin_sh"]); c.HLINE(30, 36, 38, g["skin_sh"])  # носогубные


def finish(c):
    c.outline(INK)
    # внутренние тёмные контуры лица
    return c.img


# ---------------------------------------------------------------- персонажи
def p_warrior():
    c = Cv(S, S)
    g = {"skin": C(232, 172, 128), "skin_sh": C(198, 138, 98), "skin_hi": C(248, 204, 164),
         "cloth": C(58, 82, 150), "brow": C(84, 62, 44), "rosy": False}
    bg(c, (40, 70, 140))
    bust(c, g)
    eyes(c, g, C(96, 140, 200), thick_brow=True)
    nose_mouth(c, g, smile=False)
    # шрам через бровь
    c.P(37, 17, (150, 84, 70, 255)); c.P(38, 18, (150, 84, 70, 255)); c.P(38, 19, (150, 84, 70, 255))
    # волосы низом + открытый шлем
    c.R(19, 12, 21, 24, C(84, 62, 44)); c.R(42, 12, 44, 24, C(84, 62, 44))
    st, st_d, st_hi = C(178, 188, 202), C(132, 142, 158), C(222, 230, 240)
    c.R(18, 4, 45, 12, st)                              # шлем
    c.R(16, 8, 47, 14, st)
    erase = [(16, 8), (47, 8), (16, 9), (47, 9), (18, 4), (45, 4), (18, 5), (45, 5)]
    for (x, y) in erase:
        c.P(x, y, (0, 0, 0, 0))
    c.HLINE(5, 20, 43, st_hi)
    c.VLINE(45, 9, 14, st_d)
    c.R(18, 14, 45, 15, st_d)                           # край шлема
    c.R(20, 15, 43, 16, C(120, 96, 60))                 # золотой обод
    c.HLINE(16, 21, 42, C(240, 204, 110))
    # гребень
    c.R(28, 0, 35, 3, C(178, 44, 54))
    c.R(26, 2, 28, 5, C(178, 44, 54)); c.R(35, 2, 37, 5, C(178, 44, 54))
    c.P(29, 0, C(230, 100, 104)); c.P(32, 1, C(230, 100, 104))
    # наручи-погоны и туника
    c.R(10, 50, 19, 63, st); c.R(44, 50, 53, 63, st)
    c.VLINE(19, 50, 63, st_d); c.VLINE(44, 50, 63, st_d)
    c.HLINE(50, 11, 18, st_hi); c.HLINE(50, 45, 52, st_hi)
    c.VLINE(31, 47, 63, shade(C(58, 82, 150), -0.25)); c.VLINE(32, 47, 63, shade(C(58, 82, 150), -0.25))
    c.R(28, 55, 35, 57, C(226, 182, 78))                # пряжка-эмблема
    c.P(31, 55, C(255, 232, 140)); c.P(32, 56, C(255, 232, 140))
    return finish(c)


def p_barbarian():
    c = Cv(S, S)
    g = {"skin": C(218, 156, 110), "skin_sh": C(184, 124, 84), "skin_hi": C(240, 190, 148),
         "cloth": C(150, 96, 60), "brow": C(60, 42, 30), "rosy": False}
    bg(c, (170, 90, 40))
    bust(c, g)
    eyes(c, g, C(150, 96, 60), thick_brow=True)
    nose_mouth(c, g, smile=True)
    # шрам на щеке
    for i in range(5):
        c.P(40 - i // 2, 24 + i, C(140, 84, 66))
    # грива
    hr, hr_d, hr_hi = C(74, 52, 36), C(52, 36, 26), C(104, 76, 52)
    c.R(17, 4, 46, 14, hr)
    c.R(14, 8, 49, 20, hr)
    for (x, y) in ((14, 8), (49, 8), (17, 4), (46, 4), (14, 9), (49, 9), (17, 5), (46, 5),
                   (15, 8), (48, 8)):
        c.P(x, y, (0, 0, 0, 0))
    for (x, y) in ((16, 3), (20, 2), (25, 1), (31, 0), (37, 1), (42, 2), (46, 3)):  # вихры
        c.P(x, y, hr); c.P(x + 1, y, hr_d)
    c.HLINE(5, 22, 34, hr_hi); c.P(18, 6, hr_hi); c.P(44, 7, hr_hi)
    c.R(14, 16, 18, 30, hr); c.R(45, 16, 49, 30, hr)    # пряди на плечи
    c.VLINE(14, 18, 29, hr_d); c.VLINE(49, 18, 29, hr_d)
    # рваная чёлка над бровями
    c.HLINE(16, 19, 45, hr)
    for (x, y) in ((20, 17), (24, 16), (28, 17), (33, 16), (38, 17), (42, 16)):
        c.P(x, y, hr); c.P(x + 1, y, hr_d)
    # борода-щетина
    d = C(88, 66, 50)
    for y in range(33, 37):
        for x in range(26, 38):
            if (x + y) % 2 == 0:
                c.P(x, y, d)
    # меховая мантия
    fur, fur_d = C(140, 98, 60), C(104, 70, 44)
    c.R(8, 48, 55, 63, fur)
    for x in range(8, 56, 2):
        c.P(x, 48, fur_d); c.P(x + 1, 50, fur_d)
    c.R(10, 46, 22, 49, fur); c.R(41, 46, 53, 49, fur)
    c.P(9, 47, fur_d); c.P(54, 47, fur_d)
    # ожерелье из зубов
    c.HLINE(45, 27, 36, C(96, 68, 44))
    for x in (27, 30, 33, 36):
        c.P(x, 46, C(236, 228, 210)); c.P(x, 47, C(210, 200, 180))
    # шлем-повязка не нужна; грудь голая по центру
    c.R(24, 50, 39, 63, g["skin"])
    c.VLINE(24, 50, 63, g["skin_sh"]); c.VLINE(39, 50, 63, g["skin_sh"])
    c.HLINE(50, 26, 37, g["skin_hi"])
    c.HLINE(45, 25, 38, C(96, 68, 44))                  # ремень топора за спиной
    return finish(c)


def p_bum():
    c = Cv(S, S)
    g = {"skin": C(222, 174, 136), "skin_sh": C(188, 138, 100), "skin_hi": C(244, 202, 164),
         "cloth": C(118, 108, 92), "brow": C(70, 58, 46), "rosy": False}
    bg(c, (70, 90, 60))
    bust(c, g)
    eyes(c, g, C(110, 110, 110), y=22, sad=True, thick_brow=False)
    nose_mouth(c, g, smile=False, wrinkles=True)
    # взъерошенные волосы
    hr, hr_d, hr_hi = C(96, 82, 66), C(70, 58, 46), C(120, 104, 84)
    c.R(19, 6, 44, 14, hr)
    c.R(17, 9, 46, 18, hr)
    for (x, y) in ((17, 9), (46, 9), (19, 6), (44, 6), (17, 10), (46, 10)):
        c.P(x, y, (0, 0, 0, 0))
    for (x, y) in ((18, 5), (23, 4), (28, 3), (35, 3), (40, 4), (45, 5)):
        c.P(x, y, hr); c.P(x, y - 1, hr_d)
    for (x, y) in ((21, 7), (31, 5), (38, 7)):          # проплешины
        c.P(x, y, g["skin"]); c.P(x + 1, y, g["skin_sh"])
    c.HLINE(7, 22, 34, hr_hi)
    # рваный низ волос
    for (x, y) in ((19, 15), (22, 17), (26, 15), (30, 16), (34, 15), (38, 17), (42, 15)):
        c.P(x, y, hr_d)
    c.P(20, 16, hr); c.P(28, 16, hr); c.P(36, 16, hr)
    # щетина
    d = C(96, 84, 70)
    for y in range(33, 37):
        for x in range(26, 38):
            if (x * 3 + y) % 3 != 0:
                c.P(x, y, d)
    # латаная рубаха
    c.R(12, 48, 20, 63, C(104, 96, 82)); c.R(43, 48, 51, 63, C(104, 96, 82))
    c.R(20, 52, 28, 55, C(104, 108, 72))                # заплата
    c.HLINE(53, 21, 27, C(84, 88, 58))
    c.R(36, 56, 44, 59, C(96, 88, 76))
    c.VLINE(24, 48, 52, C(90, 82, 70))                  # разрез
    c.VLINE(39, 48, 56, C(90, 82, 70))
    # мешок за плечом
    c.R(2, 40, 12, 60, C(126, 104, 70))
    c.R(2, 40, 12, 42, C(146, 122, 84))
    c.HLINE(60, 3, 11, C(96, 78, 52))
    c.R(6, 37, 8, 40, C(96, 78, 52))
    return finish(c)


def p_gura():
    c = Cv(S, S)
    g = {"skin": C(240, 190, 150), "skin_sh": C(206, 152, 114), "skin_hi": C(252, 216, 178),
         "cloth": C(240, 240, 246), "brow": C(120, 90, 60), "rosy": True}
    bg(c, (180, 150, 60))
    bust(c, g)
    eyes(c, g, C(110, 90, 70), thick_brow=False)
    nose_mouth(c, g, smile=True)
    # пышные усы
    m = C(130, 112, 96)
    c.R(26, 31, 30, 33, m); c.R(33, 31, 37, 33, m)
    c.P(25, 32, m); c.P(38, 32, m)
    c.P(26, 34, shade(m, -0.2)); c.P(37, 34, shade(m, -0.2))
    c.HLINE(34, 29, 34, C(120, 72, 62))                 # рот под усами
    # волосы по бокам
    hr = C(150, 100, 62)
    c.R(18, 16, 21, 26, hr); c.R(42, 16, 45, 26, hr)
    c.VLINE(18, 18, 25, C(120, 78, 46))
    # колпак повара
    wh, wh_d, wh_hi = C(244, 244, 248), C(208, 210, 220), C(255, 255, 255)
    c.R(17, 0, 46, 12, wh)
    for (x, y) in ((17, 0), (46, 0), (17, 1), (46, 1), (18, 0), (45, 0)):
        c.P(x, y, (0, 0, 0, 0))
    c.R(20, 0, 43, 1, wh)
    c.P(22, 0, wh); c.P(28, 0, wh); c.P(35, 0, wh)
    for x in range(19, 45, 4):                          # сборки
        c.VLINE(x, 2, 9, wh_d)
    c.HLINE(2, 20, 43, wh_hi)
    c.R(16, 12, 47, 15, wh_d)                           # лента
    c.HLINE(12, 17, 46, wh_hi)
    # куртка с красным платком
    c.VLINE(31, 47, 63, C(210, 210, 220)); c.VLINE(32, 47, 63, C(210, 210, 220))
    c.R(28, 44, 35, 47, C(190, 52, 52))                 # платок
    c.R(29, 47, 34, 52, C(170, 44, 44))
    c.P(29, 52, C(140, 34, 34)); c.P(34, 52, C(140, 34, 34))
    c.P(31, 48, C(240, 240, 246)); c.P(32, 48, C(240, 240, 246))  # узел
    c.P(8, 55, C(60, 62, 72)); c.P(9, 55, C(60, 62, 72))          # пуговицы
    c.P(54, 55, C(60, 62, 72)); c.P(55, 55, C(60, 62, 72))
    # кастрюля в углу
    c.R(2, 54, 10, 62, C(120, 128, 142))
    c.R(3, 52, 9, 54, C(150, 158, 172))
    c.HLINE(51, 4, 8, C(96, 102, 114))
    c.P(12, 50, C(200, 200, 210)); c.P(13, 48, C(220, 220, 228))  # пар
    return finish(c)


def p_viras():
    c = Cv(S, S)
    g = {"skin": C(216, 158, 112), "skin_sh": C(182, 124, 84), "skin_hi": C(240, 190, 148),
         "cloth": C(122, 84, 52), "brow": C(66, 50, 40), "rosy": False}
    bg(c, (200, 100, 50))
    bust(c, g)
    eyes(c, g, C(120, 90, 66), thick_brow=True)
    nose_mouth(c, g, smile=False)
    # сажа на щеке
    c.P(41, 26, C(96, 88, 90)); c.P(42, 27, C(96, 88, 90)); c.P(40, 27, C(96, 88, 90))
    # морщины лысины
    for x in range(26, 38, 2):
        c.P(x, 14, g["skin_sh"])
    c.HLINE(11, 28, 34, g["skin_sh"])
    # борода
    bc, bc_d, bc_hi = C(78, 60, 48), C(56, 42, 34), C(104, 82, 64)
    c.R(23, 32, 40, 38, bc)
    c.R(26, 38, 37, 46, bc)
    c.R(19, 33, 23, 40, bc); c.R(40, 33, 44, 40, bc)    # бакенбарды
    c.HLINE(47, 28, 35, bc_d)
    c.HLINE(33, 27, 36, bc_hi)
    c.HLINE(31, 26, 30, bc)
    c.R(27, 30, 36, 31, bc)                             # усы
    c.P(26, 31, bc_hi); c.P(37, 31, bc_hi)
    # фартук и голая грудь
    c.R(26, 47, 37, 49, C(180, 130, 90))                # шея/ключицы
    c.HLINE(49, 27, 36, C(160, 110, 76))
    c.R(8, 48, 55, 63, C(122, 84, 52))
    c.R(12, 46, 51, 48, C(96, 66, 42))
    c.HLINE(46, 13, 50, C(140, 100, 64))
    c.VLINE(31, 49, 63, C(96, 66, 42)); c.VLINE(32, 49, 63, C(96, 66, 42))
    c.R(29, 52, 34, 54, C(146, 104, 66))                # карман
    # молот у плеча (упирается в плечо)
    c.R(54, 42, 60, 46, C(178, 186, 198))
    c.VLINE(60, 42, 46, C(126, 134, 148))
    c.R(56, 46, 58, 60, C(110, 76, 48))
    c.P(57, 58, C(146, 104, 66))
    # искры кузни
    c.P(6, 20, C(255, 190, 90)); c.P(7, 18, C(255, 230, 150)); c.P(58, 16, C(255, 190, 90))
    return finish(c)


def p_zlus():
    c = Cv(S, S)
    g = {"skin": C(228, 180, 142), "skin_sh": C(194, 146, 108), "skin_hi": C(250, 208, 168),
         "cloth": C(108, 74, 164), "brow": C(224, 224, 232), "rosy": False}
    bg(c, (120, 80, 200))
    bust(c, g)
    eyes(c, g, C(140, 220, 240), thick_brow=True)
    nose_mouth(c, g, smile=True)
    # белые волосы по бокам
    hw, hw_d = C(226, 226, 234), C(190, 190, 202)
    c.R(18, 16, 22, 26, hw); c.R(41, 16, 45, 26, hw)
    c.VLINE(18, 18, 25, hw_d)
    # длинная борода
    bc = C(232, 232, 240)
    c.R(23, 32, 40, 39, bc)
    c.R(26, 39, 37, 50, bc)
    c.R(29, 50, 34, 56, bc)
    c.HLINE(51, 28, 35, C(200, 200, 212))
    c.HLINE(33, 27, 36, C(255, 255, 255))
    c.HLINE(31, 26, 30, bc)                             # усы
    c.R(27, 30, 36, 31, bc)
    c.P(26, 31, C(210, 210, 222)); c.P(37, 31, C(210, 210, 222))
    # колпак
    rc, rc_d, rc_hi = C(108, 74, 164), C(78, 52, 124), C(150, 112, 200)
    c.R(19, 2, 44, 10, rc)
    for (x, y) in ((19, 2), (44, 2), (19, 3), (44, 3), (21, 2), (42, 2)):
        c.P(x, y, (0, 0, 0, 0))
    c.R(23, 0, 40, 2, rc)
    c.P(28, 0, rc); c.P(35, 0, rc)
    c.P(24, 3, rc_hi); c.HLINE(4, 24, 38, rc_hi)
    c.HLINE(10, 20, 43, C(226, 182, 78))                # золотая лента
    c.HLINE(11, 22, 41, C(170, 132, 52))
    for (x, y) in ((27, 5), (36, 7), (31, 2)):          # звёзды
        c.P(x, y, C(244, 226, 130))
        c.P(x + 1, y, C(244, 226, 130)); c.P(x, y + 1, C(244, 226, 130))
    c.R(16, 10, 47, 12, rc_d)                           # поля
    c.HLINE(12, 18, 45, C(60, 40, 94))
    # мантия с каймой
    c.R(8, 50, 55, 63, rc)
    c.HLINE(50, 10, 53, rc_hi)
    c.HLINE(60, 8, 55, C(226, 182, 78))
    c.HLINE(61, 9, 54, C(170, 132, 52))
    c.R(12, 52, 20, 60, rc_d); c.R(43, 52, 51, 60, rc_d)  # рукава
    # посох с кристаллом
    c.R(58, 26, 60, 60, C(110, 76, 48))
    c.R(55, 16, 62, 25, C(128, 224, 242))
    for (x, y) in ((55, 16), (62, 16), (55, 25), (62, 25)):
        c.P(x, y, (0, 0, 0, 0))
    c.P(57, 18, C(232, 252, 255)); c.P(60, 22, C(84, 168, 196))
    c.R(56, 25, 61, 26, C(140, 100, 60))
    c.P(10, 14, C(180, 150, 250)); c.P(12, 12, C(220, 200, 255))  # искры
    return finish(c)


def p_lira():
    c = Cv(S, S)
    g = {"skin": C(248, 202, 160), "skin_sh": C(212, 158, 120), "skin_hi": C(255, 226, 190),
         "cloth": C(198, 42, 62), "brow": C(196, 152, 78), "rosy": True}
    bg(c, (220, 80, 110))
    bust(c, g)
    eyes(c, g, C(110, 150, 210), thick_brow=False)
    nose_mouth(c, g, smile=True, lips=C(206, 74, 82))
    hr, hr_d, hr_hi = C(232, 188, 100), C(192, 146, 66), C(252, 224, 148)
    # длинные волосы: верх и стороны
    c.R(18, 2, 45, 10, hr)
    c.R(15, 6, 48, 20, hr)
    for (x, y) in ((15, 6), (48, 6), (18, 2), (45, 2), (15, 7), (48, 7), (16, 6), (47, 6),
                   (17, 4), (46, 4), (18, 3), (45, 3)):
        c.P(x, y, (0, 0, 0, 0))
    c.VLINE(30, 2, 9, hr_d)                             # пробор
    c.VLINE(31, 2, 9, shade(hr_d, -0.1))
    c.HLINE(3, 20, 29, hr_hi); c.HLINE(3, 32, 43, hr_hi)
    c.R(13, 14, 19, 40, hr)                             # пряди на грудь
    c.R(44, 14, 50, 40, hr)
    c.VLINE(13, 18, 39, hr_d); c.VLINE(50, 18, 39, hr_d)
    c.HLINE(40, 14, 18, hr_d); c.HLINE(40, 45, 49, hr_d)
    c.HLINE(15, 14, 18, hr_hi); c.HLINE(15, 45, 49, hr_hi)
    c.HLINE(11, 20, 27, hr)                             # чёлка
    c.HLINE(11, 36, 43, hr)
    c.P(21, 12, hr); c.P(42, 12, hr)
    # цветок
    c.R(14, 4, 18, 8, C(250, 224, 234))
    c.P(16, 6, C(255, 250, 214)); c.P(16, 4, C(233, 170, 190)); c.P(14, 6, C(233, 170, 190))
    c.P(19, 3, C(250, 224, 234)); c.P(18, 8, C(250, 224, 234))
    # серьги
    c.P(17, 30, C(255, 226, 120)); c.P(46, 30, C(255, 226, 120))
    c.P(17, 31, C(220, 180, 70)); c.P(46, 31, C(220, 180, 70))
    # платье: вырез с золотой каймой
    c.R(14, 48, 49, 63, C(198, 42, 62))
    c.R(24, 44, 39, 47, g["skin"])                      # вырез
    c.HLINE(47, 25, 38, C(240, 198, 94))
    c.HLINE(48, 24, 39, C(240, 198, 94))
    c.P(24, 49, C(240, 198, 94)); c.P(39, 49, C(240, 198, 94))
    c.VLINE(49, 48, 63, C(150, 28, 44))
    c.HLINE(50, 15, 48, C(222, 66, 84))
    # подвеска с камнем
    c.VLINE(31, 49, 53, C(240, 198, 94)); c.VLINE(32, 49, 53, C(240, 198, 94))
    c.R(29, 53, 34, 57, C(126, 224, 242))
    c.P(30, 54, C(222, 250, 255)); c.P(33, 56, C(70, 160, 190))
    c.P(29, 57, C(240, 198, 94)); c.P(34, 57, C(240, 198, 94))
    # кулон-блеск
    c.P(56, 20, C(255, 230, 240)); c.P(8, 24, C(255, 214, 230))
    return finish(c)


def p_mage():
    """Маг — играбельный герой (шаг 6): бирюзовая мантия, колпак, посох."""
    c = Cv(S, S)
    g = {"skin": C(240, 196, 156), "skin_sh": C(206, 158, 118), "skin_hi": C(252, 220, 184),
         "cloth": C(44, 96, 128), "brow": C(56, 48, 76), "rosy": True}
    bg(c, (60, 150, 180))
    bust(c, g)
    eyes(c, g, C(120, 210, 230), thick_brow=False)
    nose_mouth(c, g, smile=True)
    # тёмно-фиолетовые волосы по бокам + чёлка
    hr, hr_d, hr_hi = C(56, 48, 76), C(40, 34, 56), C(88, 78, 116)
    c.R(18, 14, 21, 26, hr); c.R(42, 14, 45, 26, hr)
    c.VLINE(18, 16, 25, hr_d)
    c.HLINE(15, 24, 27, hr); c.HLINE(15, 36, 39, hr)
    c.P(23, 14, hr); c.P(40, 14, hr); c.P(31, 14, hr)
    # колпак (бирюзовый, как мантия)
    rc, rc_d, rc_hi = C(44, 96, 128), C(30, 68, 92), C(80, 150, 184)
    c.R(19, 2, 44, 10, rc)
    for (x, y) in ((19, 2), (44, 2), (19, 3), (44, 3), (21, 2), (42, 2)):
        c.P(x, y, (0, 0, 0, 0))
    c.R(23, 0, 40, 2, rc)
    c.P(28, 0, rc); c.P(35, 0, rc)
    c.P(24, 3, rc_hi); c.HLINE(4, 24, 38, rc_hi)
    c.HLINE(10, 20, 43, C(120, 200, 220))               # бирюзовая лента
    c.HLINE(11, 22, 41, C(88, 148, 170))
    for (x, y) in ((27, 5), (36, 7)):                   # звёздочки
        c.P(x, y, C(244, 226, 130))
        c.P(x + 1, y, C(244, 226, 130)); c.P(x, y + 1, C(244, 226, 130))
    c.R(16, 10, 47, 12, rc_d)                           # поля
    c.HLINE(12, 18, 45, C(22, 46, 64))
    # мантия с бирюзовой каймой
    c.R(8, 50, 55, 63, rc)
    c.HLINE(50, 10, 53, rc_hi)
    c.HLINE(60, 8, 55, C(120, 200, 220))
    c.HLINE(61, 9, 54, C(88, 148, 170))
    c.R(12, 52, 20, 60, rc_d); c.R(43, 52, 51, 60, rc_d)
    c.P(31, 50, C(230, 240, 250)); c.P(32, 50, C(200, 220, 236))  # застёжка
    # посох с сияющим кристаллом
    c.R(58, 26, 60, 60, C(110, 76, 48))
    c.R(55, 16, 62, 25, C(120, 210, 230))
    for (x, y) in ((55, 16), (62, 16), (55, 25), (62, 25)):
        c.P(x, y, (0, 0, 0, 0))
    c.P(57, 18, C(232, 252, 255)); c.P(60, 22, C(70, 150, 176))
    c.R(56, 25, 61, 26, C(140, 100, 60))
    c.P(10, 14, C(180, 240, 250)); c.P(12, 12, C(220, 248, 255))  # искры
    return finish(c)


def p_glot():
    """Глот — трактирщик в замке (шаг 6): зелёный камзол, фартук, кружка."""
    c = Cv(S, S)
    g = {"skin": C(238, 188, 148), "skin_sh": C(204, 152, 112), "skin_hi": C(250, 214, 178),
         "cloth": C(86, 122, 74), "brow": C(96, 62, 40), "rosy": True}
    bg(c, (110, 160, 100))
    bust(c, g)
    eyes(c, g, C(110, 90, 70), thick_brow=True)
    nose_mouth(c, g, smile=True)
    # щетина и румяные щёки (уже от nose_mouth rosy)
    d = C(104, 78, 56)
    for y in range(33, 37):
        for x in range(26, 38):
            if (x + y) % 2 == 0:
                c.P(x, y, d)
    # каштановые волосы с пробором
    hr, hr_d, hr_hi = C(96, 62, 40), C(70, 44, 30), C(128, 88, 56)
    c.R(18, 4, 45, 14, hr)
    for (x, y) in ((18, 4), (45, 4), (18, 5), (45, 5), (19, 4), (44, 4)):
        c.P(x, y, (0, 0, 0, 0))
    c.VLINE(31, 5, 11, hr_d); c.VLINE(32, 5, 11, shade(hr_d, -0.1))
    c.HLINE(5, 20, 29, hr_hi); c.HLINE(5, 33, 43, hr_hi)
    c.HLINE(14, 19, 26, hr); c.HLINE(14, 37, 44, hr)    # виски
    c.R(17, 14, 20, 24, hr); c.R(43, 14, 46, 24, hr)
    c.VLINE(17, 16, 23, hr_d); c.VLINE(46, 16, 23, hr_d)
    # зелёный камзол со светлым фартуком
    c.R(8, 48, 55, 63, g["cloth"])
    c.HLINE(48, 12, 51, shade(g["cloth"], 0.25))
    c.VLINE(49, 48, 63, shade(g["cloth"], -0.3))
    c.R(24, 44, 39, 47, g["skin"])                      # вырез
    c.R(12, 50, 51, 63, C(214, 204, 186))               # фартук
    c.HLINE(50, 14, 49, C(238, 230, 214))
    c.VLINE(31, 50, 63, C(186, 174, 154)); c.VLINE(32, 50, 63, C(186, 174, 154))
    c.HLINE(56, 13, 50, C(186, 174, 154))
    # шнурок камзола
    for y in (50, 53, 56):
        c.P(26, y, C(70, 52, 36)); c.P(37, y, C(70, 52, 36))
    # деревянная кружка у плеча
    c.R(4, 46, 14, 60, C(140, 96, 54))
    c.HLINE(46, 5, 13, C(170, 122, 70))
    c.R(6, 44, 12, 46, C(246, 244, 238))                # пена
    c.P(5, 45, C(246, 244, 238)); c.P(13, 45, C(246, 244, 238))
    c.VLINE(14, 48, 58, C(104, 68, 38))
    c.R(2, 50, 4, 56, C(120, 82, 46))                   # ручка
    # капли-блёстки
    c.P(56, 18, C(220, 244, 210)); c.P(8, 20, C(220, 244, 210))
    return finish(c)


def p_zoran():
    """Зоран — оружейный чародей (шаг 6): седые волосы, индиго-мантия, меч."""
    c = Cv(S, S)
    g = {"skin": C(222, 172, 132), "skin_sh": C(188, 140, 104), "skin_hi": C(240, 200, 164),
         "cloth": C(58, 58, 96), "brow": C(150, 152, 168), "rosy": False}
    bg(c, (110, 90, 200))
    bust(c, g)
    eyes(c, g, C(170, 130, 240), thick_brow=True)
    nose_mouth(c, g, smile=False, wrinkles=True)
    # длинные седые волосы
    hr, hr_d, hr_hi = C(168, 170, 186), C(130, 132, 150), C(210, 212, 226)
    c.R(17, 4, 46, 14, hr)
    for (x, y) in ((17, 4), (46, 4), (17, 5), (46, 5), (19, 4), (44, 4)):
        c.P(x, y, (0, 0, 0, 0))
    c.VLINE(30, 5, 11, hr_d); c.VLINE(31, 5, 11, shade(hr_d, -0.1))
    c.HLINE(5, 20, 28, hr_hi); c.HLINE(5, 33, 43, hr_hi)
    c.R(15, 14, 19, 40, hr); c.R(44, 14, 48, 40, hr)    # пряди на грудь
    c.VLINE(15, 18, 39, hr_d); c.VLINE(48, 18, 39, hr_d)
    c.HLINE(40, 16, 19, hr_d); c.HLINE(40, 44, 47, hr_d)
    c.HLINE(12, 20, 26, hr); c.HLINE(12, 37, 43, hr)    # чёлка
    # окладистая седая борода
    bc, bc_d, bc_hi = C(178, 180, 196), C(140, 142, 160), C(214, 216, 230)
    c.R(23, 32, 40, 38, bc)
    c.R(26, 38, 37, 46, bc)
    c.HLINE(47, 28, 35, bc_d)
    c.HLINE(33, 27, 36, bc_hi)
    c.R(27, 30, 36, 31, bc)                             # усы
    c.P(26, 31, bc_hi); c.P(37, 31, bc_hi)
    # мантия индиго с фиолетовой каймой
    c.R(8, 48, 55, 63, g["cloth"])
    c.HLINE(48, 10, 53, shade(g["cloth"], 0.3))
    c.HLINE(60, 8, 55, C(150, 110, 220))
    c.HLINE(61, 9, 54, C(110, 78, 170))
    c.R(12, 52, 20, 60, shade(g["cloth"], -0.3)); c.R(43, 52, 51, 60, shade(g["cloth"], -0.3))
    c.VLINE(31, 48, 63, shade(g["cloth"], -0.35)); c.VLINE(32, 48, 63, shade(g["cloth"], -0.35))
    # аметистовая застёжка
    c.R(29, 50, 34, 54, C(150, 110, 220))
    c.P(30, 51, C(222, 200, 255)); c.P(33, 53, C(96, 60, 160))
    # меч за плечом с фиолетовым свечением
    c.R(56, 8, 58, 44, C(196, 204, 222))
    c.VLINE(56, 8, 44, C(230, 236, 248))
    c.VLINE(58, 8, 44, C(140, 100, 220))                # магическая кромка
    c.R(54, 44, 60, 46, C(226, 182, 78))
    c.R(56, 46, 58, 52, C(80, 58, 44))
    c.P(8, 16, C(220, 200, 255)); c.P(10, 22, C(200, 180, 255))  # искры
    return finish(c)


def p_door():
    """Портрет запертой двери данжа."""
    c = Cv(S, S)
    bg(c, (70, 70, 90))
    door, door_d = C(96, 66, 40), C(70, 46, 30)
    c.R(14, 8, 49, 60, door)
    c.R(16, 10, 47, 58, door_d)
    c.VLINE(31, 8, 60, door_d); c.VLINE(32, 8, 60, C(56, 36, 24))  # створки
    for y in (18, 30, 42):                              # железные полосы
        c.R(14, y, 49, y + 3, C(120, 126, 140))
        c.HLINE(y, 14, 49, C(150, 156, 170))
        c.P(18, y + 1, C(80, 84, 96)); c.P(45, y + 1, C(80, 84, 96))
    c.R(24, 34, 39, 48, C(150, 156, 170))               # замок
    c.R(27, 30, 36, 34, (0, 0, 0, 0))
    c.R(27, 30, 36, 35, C(120, 126, 140))
    c.R(29, 31, 34, 34, (0, 0, 0, 0))
    c.P(31, 40, C(60, 62, 74)); c.P(32, 40, C(60, 62, 74))
    c.R(31, 40, 32, 44, C(90, 92, 104))
    c.P(14, 8, (0, 0, 0, 0)); c.P(49, 8, (0, 0, 0, 0))
    c.P(20, 24, C(226, 200, 120)); c.P(42, 22, C(226, 200, 120))  # блики-вопросы
    c.outline(INK)
    return c.img


if __name__ == "__main__":
    import os
    os.makedirs(OUT + "/sprites/portraits", exist_ok=True)
    items = [("warrior", p_warrior), ("barbarian", p_barbarian), ("bum", p_bum),
             ("gura", p_gura), ("viras", p_viras), ("zlus", p_zlus), ("lira", p_lira),
             ("mage", p_mage), ("glot", p_glot), ("zoran", p_zoran),
             ("door", p_door)]
    cells, labels = [], []
    for cid, fn in items:
        img = fn()
        save(img, f"sprites/portraits/{cid}.png")
        cells.append(img)
        labels.append(cid)
    save(contact(cells, S, S, cols=4, scale=4, bg=(30, 28, 44, 255), labels=labels),
         "/tmp/portraits.png")
    print("OK")

````

#### `tools/gen_world_art.py`

````python
# -*- coding: utf-8 -*-
"""Тайлсет 128x128 (8x8 тайлов 16px), пропы, иконки предметов для «Dungeon Loot»."""
import sys, random
sys.path.insert(0, "/home/z/my-project/scripts")
from px import *

T = 16
random.seed(4)


def tile(fn):
    c = Cv(T, T)
    fn(c)
    return c.img


# ---------------------------------------------------------------- тайлы
def t_wall(c):
    """Кладка стены замка."""
    c.R(0, 0, 15, 15, C(52, 50, 70))                    # раствор
    bricks = [(0, 0, 7, 4), (8, 0, 15, 4), (0, 5, 3, 9), (4, 5, 11, 9), (12, 5, 15, 9),
              (0, 10, 7, 14), (8, 10, 15, 14), (0, 15, 3, 15), (4, 15, 11, 15), (12, 15, 15, 15)]
    for (x0, y0, x1, y1) in bricks:
        c.R(x0, y0, x1, y1, C(96, 94, 116))
        c.HLINE(y0, x0, x1, C(118, 116, 138))
        c.VLINE(x1, y0, y1, C(76, 74, 94))
        c.P(x0, y1, C(76, 74, 94))


def t_wall_v(c):
    t_wall(c)
    c.R(4, 6, 6, 9, C(66, 64, 84))                      # трещина
    c.P(7, 10, C(66, 64, 84))


def t_window(c):
    t_wall(c)
    c.R(3, 2, 12, 13, C(40, 38, 58))                    # арка: рама
    c.R(4, 1, 11, 12, C(30, 28, 48))
    c.HLINE(1, 5, 10, C(30, 28, 48))
    c.R(5, 2, 10, 11, C(12, 10, 24))                    # космос в окне
    c.P(6, 4, C(210, 220, 255)); c.P(9, 7, C(160, 180, 240)); c.P(7, 9, C(240, 240, 250))
    c.VLINE(7, 2, 11, C(40, 38, 58)); c.HLINE(7, 5, 10, C(40, 38, 58))  # переплёт
    c.HLINE(0, 3, 12, C(118, 116, 138)); c.HLINE(13, 4, 11, C(118, 116, 138))
    c.P(4, 1, C(118, 116, 138)); c.P(11, 1, C(118, 116, 138))


def t_door(c):
    t_wall(c)
    c.R(2, 0, 13, 15, C(64, 60, 80))                    # каменная рама
    c.R(3, 1, 12, 15, C(92, 62, 38))                    # дерево
    for x in (5, 8, 11):
        c.VLINE(x, 1, 15, C(72, 48, 30))
    c.HLINE(1, 3, 12, C(72, 48, 30))
    for y in (4, 11):                                   # железные полосы
        c.R(3, y, 12, y + 1, C(116, 122, 136))
        c.HLINE(y, 3, 12, C(146, 152, 166))
    c.R(6, 7, 9, 9, C(150, 156, 170))                   # ригель
    c.P(7, 8, C(190, 196, 210))


def t_pillar(c):
    c.R(0, 0, 15, 15, C(172, 172, 188))
    c.R(4, 0, 11, 12, C(150, 150, 168))
    c.VLINE(4, 0, 12, C(126, 126, 144)); c.VLINE(11, 0, 12, C(190, 190, 204))
    c.VLINE(6, 0, 12, C(136, 136, 154)); c.VLINE(9, 0, 12, C(182, 182, 196))
    c.R(2, 12, 13, 15, C(140, 140, 158))                # база
    c.HLINE(12, 3, 12, C(196, 196, 210))
    c.HLINE(15, 2, 13, C(112, 112, 130))
    c.HLINE(0, 0, 15, C(196, 196, 210))


def t_outer(c):
    """Внешняя стена замка: крупные блоки."""
    c.R(0, 0, 15, 15, C(56, 54, 74))
    for (x0, y0, x1, y1) in [(0, 0, 15, 6), (0, 7, 15, 15)]:
        c.R(x0, y0, x1, y1, C(118, 116, 134))
        c.HLINE(y0, x0, x1, C(140, 138, 156))
        c.HLINE(y1, x0, x1, C(96, 94, 112))
    c.VLINE(7, 0, 6, C(100, 98, 116)); c.VLINE(4, 7, 15, C(100, 98, 116))
    c.P(12, 2, C(140, 138, 156)); c.P(3, 10, C(140, 138, 156))


def t_fence(c):
    c.R(0, 0, 15, 15, (0, 0, 0, 0))
    c.R(2, 2, 6, 15, C(122, 92, 56))                    # доска
    c.R(9, 2, 13, 15, C(122, 92, 56))
    c.P(2, 1, C(122, 92, 56)); c.P(9, 1, C(122, 92, 56))
    c.P(4, 1, C(122, 92, 56)); c.P(11, 1, C(122, 92, 56))
    c.P(4, 0, C(140, 108, 68)); c.P(11, 0, C(140, 108, 68))
    c.VLINE(6, 2, 15, C(94, 70, 42)); c.VLINE(13, 2, 15, C(94, 70, 42))
    c.R(0, 5, 15, 7, C(108, 80, 48))                    # перекладина
    c.HLINE(5, 0, 15, C(134, 102, 62))


def t_railing(c):
    c.R(0, 0, 15, 15, (0, 0, 0, 0))
    c.R(0, 2, 15, 4, C(212, 164, 62))                   # поручень
    c.HLINE(2, 0, 15, C(244, 204, 110))
    c.HLINE(4, 0, 15, C(160, 120, 44))
    for x in (2, 7, 12):                                # стойки
        c.R(x, 5, x + 1, 13, C(180, 136, 52))
        c.VLINE(x, 5, 13, C(244, 204, 110))
    c.R(0, 13, 15, 15, C(150, 114, 46))
    c.HLINE(13, 0, 15, C(190, 148, 56))


def marble(c, light=True):
    base = C(178, 178, 194) if light else C(128, 128, 148)
    line = C(150, 150, 168) if light else C(104, 104, 124)
    c.R(0, 0, 15, 15, base)
    c.HLINE(0, 0, 15, line); c.VLINE(0, 0, 15, line)
    c.HLINE(15, 0, 15, shade(base, -0.08)); c.VLINE(15, 0, 15, shade(base, -0.08))
    for _ in range(5):
        x, y = random.randrange(1, 15), random.randrange(1, 15)
        c.P(x, y, shade(base, 0.12 if random.random() > 0.5 else -0.12))


def t_carpet(c):
    c.R(0, 0, 15, 15, C(172, 44, 58))
    c.HLINE(0, 0, 15, C(212, 92, 84)); c.VLINE(0, 0, 15, C(212, 92, 84))
    c.HLINE(15, 0, 15, C(128, 28, 40)); c.VLINE(15, 0, 15, C(128, 28, 40))
    # ромб-узор
    c.P(7, 5, C(238, 196, 96)); c.P(8, 5, C(238, 196, 96))
    c.P(6, 6, C(238, 196, 96)); c.P(9, 6, C(238, 196, 96))
    c.P(7, 7, C(238, 196, 96)); c.P(8, 7, C(238, 196, 96))
    c.P(5, 12, C(198, 60, 72)); c.P(10, 12, C(198, 60, 72))


def t_path(c):
    """Брусчатка двора."""
    c.R(0, 0, 15, 15, C(96, 94, 110))
    stones = [(0, 0, 6, 6), (7, 0, 15, 4), (7, 5, 12, 9), (13, 5, 15, 9),
              (0, 7, 5, 12), (6, 10, 11, 15), (12, 10, 15, 15), (0, 13, 5, 15)]
    for (x0, y0, x1, y1) in stones:
        c.R(x0, y0, x1, y1, C(138, 134, 152))
        c.HLINE(y0, x0, x1, C(160, 156, 174))
        c.VLINE(x1, y0, y1, C(114, 110, 128))


def t_dirt(c):
    c.R(0, 0, 15, 15, C(134, 108, 76))
    for _ in range(14):
        x, y = random.randrange(16), random.randrange(16)
        c.P(x, y, C(114, 90, 62) if random.random() > 0.5 else C(150, 124, 88))
    c.HLINE(0, 0, 15, C(122, 98, 68))


def t_grass(c, flowers=False):
    c.R(0, 0, 15, 15, C(94, 146, 78))
    for _ in range(10):
        x, y = random.randrange(16), random.randrange(16)
        c.VLINE(x, y, y + 1, C(74, 122, 62))
    for _ in range(4):
        x, y = random.randrange(16), random.randrange(16)
        c.P(x, y, C(116, 166, 96))
    if flowers:
        for (fx, fy, fc) in [(3, 4, C(244, 240, 190)), (11, 3, C(238, 160, 180)),
                             (7, 10, C(244, 240, 190)), (13, 12, C(240, 220, 250))]:
            c.P(fx, fy, fc); c.P(fx + 1, fy, fc)
            c.P(fx, fy + 1, C(210, 200, 140))


def t_void(c, seed=0):
    c.R(0, 0, 15, 15, C(10, 8, 22))
    rnd = random.Random(seed)
    for _ in range(7):
        x, y = rnd.randrange(16), rnd.randrange(16)
        b = rnd.choice([C(200, 210, 240), C(150, 160, 210), C(240, 240, 250), C(120, 110, 180)])
        c.P(x, y, b)


def t_pot(c):
    marble(c)
    c.R(4, 8, 11, 14, C(178, 108, 66))                  # горшок
    c.R(5, 7, 10, 8, C(198, 126, 78))
    c.HLINE(14, 4, 11, C(140, 82, 48))
    c.VLINE(4, 8, 13, C(150, 88, 52))
    c.R(5, 3, 10, 7, C(88, 150, 84))                    # растение
    c.P(6, 2, C(108, 172, 100)); c.P(9, 2, C(108, 172, 100))
    c.P(7, 4, C(108, 172, 100)); c.P(8, 4, C(108, 172, 100))
    c.P(7, 2, C(250, 224, 234)); c.P(8, 3, C(250, 224, 234))  # цветок
    c.P(5, 5, C(74, 128, 72))


def t_slab(c):
    """Плита с звёздной мозаикой (тронная)."""
    marble(c)
    c.P(6, 6, C(110, 130, 200)); c.P(9, 6, C(110, 130, 200))
    c.P(7, 7, C(150, 170, 230)); c.P(8, 7, C(150, 170, 230))
    c.P(6, 8, C(110, 130, 200)); c.P(9, 8, C(110, 130, 200))


# ---------------------------------------------------------------- сборка тайлсета
def build_tiles():
    sheet = Image.new("RGBA", (128, 128), (0, 0, 0, 0))
    grid = {
        (0, 0): t_wall, (1, 0): t_wall_v, (2, 0): t_window, (3, 0): t_door,
        (4, 0): t_pillar, (5, 0): t_outer, (6, 0): t_fence, (7, 0): t_railing,
        (0, 1): lambda c: marble(c, True), (1, 1): lambda c: marble(c, False),
        (2, 1): t_carpet, (3, 1): t_path, (4, 1): t_dirt,
        (5, 1): t_grass, (6, 1): lambda c: t_grass(c, True), (7, 1): lambda c: t_void(c, 1),
        (0, 2): t_pot, (1, 2): t_slab, (2, 2): lambda c: t_void(c, 2),
        (3, 2): lambda c: t_void(c, 3), (4, 2): lambda c: t_void(c, 4),
        (5, 2): lambda c: t_void(c, 5), (6, 2): lambda c: t_void(c, 6),
        (7, 2): lambda c: t_void(c, 7),
    }
    for (cx, cy), fn in grid.items():
        sheet.paste(tile(fn), (cx * T, cy * T))
    return sheet


# ---------------------------------------------------------------- пропы
def p_arch():
    """Ворота замка 64x26."""
    c = Cv(64, 26)
    stone, stone_d, stone_hi = C(120, 118, 136), C(88, 86, 104), C(148, 146, 164)
    # боковые башни
    for x0 in (0, 56):
        c.R(x0, 2, x0 + 7, 25, stone)
        c.R(x0, 0, x0 + 7, 2, stone_hi)
        for bx in range(x0, x0 + 8, 4):
            c.P(bx, 0, stone); c.P(bx + 1, 0, stone_d)
        c.VLINE(x0 + 7, 2, 25, stone_d)
    # арка
    c.R(8, 10, 55, 25, stone)
    c.R(10, 4, 53, 10, stone)
    for (x, y) in [(10, 4), (53, 4), (10, 5), (53, 5), (11, 4), (52, 4)]:
        c.P(x, y, (0, 0, 0, 0))
    c.R(14, 8, 49, 25, (0, 0, 0, 0))                    # проём
    c.R(12, 6, 51, 7, (0, 0, 0, 0))
    c.HLINE(6, 12, 51, stone_hi)
    c.VLINE(8, 10, 25, stone_d); c.VLINE(55, 10, 25, stone_d)
    c.VLINE(13, 8, 25, stone_hi); c.VLINE(50, 8, 25, stone_d)
    # открытые створки
    wd, wd_d = C(104, 72, 44), C(80, 54, 34)
    c.R(14, 12, 20, 25, wd); c.R(43, 12, 49, 25, wd)
    c.VLINE(20, 12, 25, wd_d); c.VLINE(43, 12, 25, wd_d)
    c.P(17, 15, C(212, 164, 62)); c.P(46, 15, C(212, 164, 62))
    # зубцы сверху
    for bx in range(9, 56, 6):
        c.R(bx, 2, bx + 3, 4, stone)
        c.HLINE(2, bx, bx + 3, stone_hi)
    c.outline()
    return c.img


def p_throne():
    """Трон 32x32."""
    c = Cv(32, 32)
    gold, gold_d, gold_hi = C(212, 168, 62), C(160, 122, 44), C(246, 208, 110)
    red, red_d = C(168, 40, 54), C(126, 28, 40)
    c.R(4, 2, 27, 31, gold)                             # спинка
    c.R(6, 4, 25, 31, red)
    c.R(8, 6, 23, 28, red_d)
    c.R(10, 8, 21, 26, red)                             # подушка
    c.HLINE(4, 6, 25, gold_hi)
    c.VLINE(27, 2, 31, gold_d)
    for (x, y) in [(4, 2), (27, 2)]:
        c.P(x, y, (0, 0, 0, 0))
    c.R(2, 0, 5, 3, gold); c.R(26, 0, 29, 3, gold)      # шпили
    c.P(3, 0, gold_hi); c.P(27, 0, gold_hi)
    c.P(15, 12, gold); c.P(16, 12, gold)                # узор
    c.P(14, 13, gold); c.P(17, 13, gold)
    c.P(15, 14, gold); c.P(16, 14, gold)
    c.R(4, 28, 27, 31, gold_d)                          # основание
    c.HLINE(28, 4, 27, gold_hi)
    c.outline()
    return c.img


def p_fountain(frame=0):
    """Фонтан 32x32, 3 кадра воды."""
    c = Cv(32, 32)
    stone, stone_d, stone_hi = C(150, 148, 164), C(112, 110, 128), C(184, 182, 196)
    water, water_hi = C(96, 168, 220), C(170, 220, 246)
    c.R(2, 20, 29, 29, stone)                           # чаша
    c.HLINE(20, 2, 29, stone_hi)
    c.R(2, 18, 29, 19, stone_hi)
    c.VLINE(29, 20, 29, stone_d)
    c.R(4, 22, 27, 26, water)                           # вода в чаше
    for i, x in enumerate(range(5, 27, 2)):
        dy = (frame + i) % 3
        c.P(x, 22 + dy, water_hi)
    c.R(13, 10, 18, 20, stone)                          # колонна
    c.VLINE(18, 10, 20, stone_d)
    c.HLINE(10, 13, 18, stone_hi)
    c.R(12, 8, 19, 9, stone)                            # верхняя чаша
    c.HLINE(8, 12, 19, stone_hi)
    c.R(13, 6, 18, 7, water)
    c.P(14 + frame % 2, 5, water_hi); c.P(16, 4 + frame % 2, water_hi)
    # струи
    for i in range(4):
        x = 11 + i * 3
        h = 3 + ((frame + i) % 3)
        c.VLINE(x, 11 - h, 10, water_hi)
    c.R(6, 26, 25, 29, stone_d)
    c.outline()
    return c.img


def p_torch(frame=0):
    """Настенный факел 16x24."""
    c = Cv(16, 24)
    c.R(6, 10, 9, 20, C(94, 66, 44))                    # держатель
    c.VLINE(9, 10, 20, C(70, 48, 32))
    c.R(4, 8, 11, 10, C(120, 124, 138))                 # обод
    c.R(5, 6, 10, 8, C(60, 56, 76))                     # угли
    f = [(5, 2, 9, 7), (6, 1, 8, 5), (7, 0, 8, 3)][frame % 3]
    c.R(f[0], f[1], f[2], f[3], C(248, 168, 62))        # пламя
    c.R(f[0] + 1, f[1] + 1, f[2] - 1, f[3] - 1, C(252, 216, 110))
    c.P(7, 4 + frame % 2, C(255, 246, 190))
    c.outline()
    return c.img


def p_brazier(frame=0):
    """Жаровня 16x22."""
    c = Cv(16, 22)
    c.R(7, 14, 8, 18, C(100, 98, 116))                  # ножка
    c.R(5, 18, 10, 20, C(120, 118, 136))
    c.R(3, 6, 12, 13, C(140, 138, 154))                 # чаша
    c.HLINE(6, 3, 12, C(172, 170, 186))
    c.VLINE(12, 6, 13, C(104, 102, 120))
    c.R(4, 4, 11, 6, C(200, 110, 40))                   # угли
    c.P(5, 5, C(252, 190, 70)); c.P(9, 4, C(252, 190, 70))
    if frame != 1:
        c.P(6, 2, C(252, 216, 110)); c.P(9, 1 + frame % 2, C(252, 190, 70))
    if frame == 2:
        c.P(7, 0, C(252, 240, 160))
    c.outline()
    return c.img


def p_forge(frame=0):
    """Горн Вираса 32x24."""
    c = Cv(32, 24)
    stone, stone_d = C(108, 104, 122), C(84, 80, 98)
    c.R(0, 8, 31, 23, stone)
    c.HLINE(8, 0, 31, C(132, 128, 146))
    c.VLINE(31, 8, 23, stone_d)
    c.R(4, 4, 20, 8, stone_d)                           # дымоход
    c.VLINE(4, 4, 8, C(132, 128, 146))
    c.R(6, 14, 22, 19, C(40, 36, 52))                   # топка
    glow = [C(200, 90, 40), C(240, 140, 50), C(252, 190, 70)][frame % 3]
    c.R(8, 16, 20, 19, glow)
    c.R(10, 15, 18, 16, C(252, 216, 110) if frame == 2 else glow)
    c.P(12, 14, C(252, 240, 160))
    c.R(24, 12, 30, 15, C(120, 124, 138))               # наковальня-упор
    c.outline()
    return c.img


def p_cart():
    """Тележка Гуры 48x26."""
    c = Cv(48, 26)
    wd, wd_d = C(148, 104, 60), C(112, 76, 44)
    c.R(4, 10, 43, 19, wd)                              # корпус
    c.HLINE(10, 4, 43, C(172, 126, 76))
    c.VLINE(43, 10, 19, wd_d)
    c.R(0, 12, 4, 14, wd_d)                             # ручка
    c.R(6, 5, 41, 10, C(238, 238, 244))                 # навес-тент
    for i, x in enumerate(range(6, 41, 6)):
        c.R(x, 5, x + 2, 10, C(216, 84, 84) if i % 2 == 0 else C(238, 238, 244))
    c.HLINE(5, 6, 41, C(180, 60, 60))
    c.P(14, 3, C(210, 180, 90)); c.P(15, 2, C(230, 200, 110))  # флажок
    c.R(15, 4, 15, 5, C(120, 90, 60))
    c.R(10, 0, 18, 4, (0, 0, 0, 0))
    # кастрюля и окорок на прилавке
    c.R(12, 6, 20, 10, C(140, 146, 160))
    c.R(13, 5, 19, 6, C(170, 176, 190))
    c.R(28, 7, 36, 10, C(198, 120, 84))                 # окорок
    c.P(34, 8, C(232, 168, 130))
    c.R(8, 20, 14, 25, C(70, 64, 58))                   # колесо
    c.R(10, 22, 12, 24, C(46, 42, 40))
    c.R(32, 20, 38, 25, C(70, 64, 58))
    c.R(34, 22, 36, 24, C(46, 42, 40))
    c.outline()
    return c.img


def p_stand_zlus():
    """Стойка зелий Злуса 16x26."""
    c = Cv(16, 26)
    wd, wd_d = C(110, 78, 52), C(84, 58, 40)
    c.R(2, 10, 13, 14, wd)                              # полка
    c.HLINE(10, 2, 13, C(136, 98, 66))
    c.R(3, 14, 4, 24, wd_d); c.R(11, 14, 12, 24, wd_d)
    c.R(2, 24, 13, 25, wd)
    c.R(3, 4, 6, 10, C(126, 224, 242))                  # зелья
    c.P(4, 3, C(90, 60, 40)); c.P(5, 3, C(90, 60, 40))
    c.R(8, 5, 10, 10, C(226, 120, 200))
    c.P(9, 4, C(90, 60, 40))
    c.R(5, 16, 6, 20, C(180, 120, 230))                 # зелья внизу
    c.R(9, 17, 10, 20, C(120, 220, 160))
    c.P(12, 1, C(170, 130, 250)); c.P(13, 2, C(200, 160, 255))  # искра
    c.outline()
    return c.img


def p_stall(color="red"):
    """Рыночный прилавок 48x24."""
    c = Cv(48, 24)
    aw = C(216, 84, 84) if color == "red" else C(84, 130, 208)
    aw2 = C(238, 238, 244)
    wd = C(122, 92, 56)
    for i, x in enumerate(range(0, 48, 8)):             # тент
        c.R(x, 0, x + 3, 6, aw)
        c.R(x + 4, 0, x + 7, 6, aw2)
    c.HLINE(6, 0, 47, shade(aw, -0.3))
    c.R(2, 6, 3, 18, wd); c.R(44, 6, 45, 18, wd)        # стойки
    c.R(1, 12, 46, 19, wd)                              # прилавок
    c.HLINE(12, 1, 46, C(150, 114, 70))
    c.R(2, 20, 45, 23, C(96, 72, 46))
    c.R(8, 7, 14, 11, C(198, 120, 84))                  # товар
    c.R(24, 7, 30, 11, C(126, 224, 242))
    c.R(36, 8, 42, 11, C(198, 168, 90))
    c.outline()
    return c.img


def p_anvil():
    """Наковальня Вираса 16x14."""
    c = Cv(16, 14)
    met, met_d, met_hi = C(126, 132, 148), C(88, 94, 110), C(172, 178, 192)
    c.R(2, 2, 13, 5, met)                               # рог-верх
    c.R(1, 3, 14, 4, met)
    c.P(0, 4, met)
    c.HLINE(2, 2, 13, met_hi)
    c.R(4, 6, 11, 8, met_d)                             # шейка
    c.R(3, 9, 12, 11, met)                              # основание
    c.HLINE(9, 3, 12, met_hi)
    c.R(2, 12, 13, 13, met_d)
    c.P(12, 3, met_d)
    c.outline()
    return c.img


def p_barrel():
    c = Cv(16, 16)
    c.R(2, 2, 13, 15, C(134, 96, 58))
    c.HLINE(2, 2, 13, C(160, 118, 72))
    c.VLINE(2, 2, 15, C(106, 74, 44)); c.VLINE(13, 2, 15, C(106, 74, 44))
    for y in (4, 10):
        c.R(1, y, 14, y + 1, C(96, 98, 112))
        c.HLINE(y, 1, 14, C(126, 128, 142))
    c.P(7, 6, C(106, 74, 44)); c.P(8, 7, C(106, 74, 44))
    c.outline()
    return c.img


def p_crate():
    c = Cv(16, 16)
    c.R(1, 2, 14, 15, C(142, 104, 62))
    c.HLINE(2, 1, 14, C(168, 128, 78))
    c.VLINE(14, 2, 15, C(110, 80, 48))
    c.HLINE(7, 1, 14, C(110, 80, 48)); c.VLINE(7, 2, 15, C(110, 80, 48))
    c.P(2, 2, C(168, 128, 78)); c.P(13, 2, C(168, 128, 78))
    c.outline()
    return c.img


def p_sacks():
    c = Cv(16, 12)
    c.ellipse(5, 8, 4, 3, C(168, 138, 88))
    c.ellipse(11, 9, 4, 2, C(150, 122, 76))
    c.P(5, 4, C(120, 96, 58)); c.P(6, 4, C(120, 96, 58))
    c.P(4, 5, C(120, 96, 58))
    c.outline()
    return c.img


def p_bench():
    c = Cv(32, 16)
    wd, wd_d = C(134, 98, 60), C(102, 74, 46)
    c.R(1, 5, 30, 9, wd)
    c.HLINE(5, 1, 30, C(160, 122, 76))
    c.R(3, 10, 5, 15, wd_d); c.R(26, 10, 28, 15, wd_d)
    c.outline()
    return c.img


def p_lantern():
    """Фонарь на столбе 16x32."""
    c = Cv(16, 32)
    c.R(7, 12, 8, 30, C(70, 68, 84))                    # столб
    c.R(5, 30, 10, 31, C(96, 94, 110))
    c.R(4, 4, 11, 12, C(110, 106, 124))                 # корпус
    c.R(5, 5, 10, 11, C(252, 216, 120))                 # стекло
    c.P(6, 6, C(255, 244, 190)); c.P(9, 8, C(255, 244, 190))
    c.R(3, 3, 12, 4, C(140, 136, 152))                  # крышка
    c.P(7, 1, C(140, 136, 152)); c.P(8, 1, C(140, 136, 152))
    c.R(4, 12, 11, 13, C(140, 136, 152))
    # тёплое сияние
    for y in range(0, 24):
        for x in range(0, 16):
            d = ((x - 7.5) ** 2 + (y - 8) ** 2) ** 0.5
            if d < 9 and not c.has(x, y):
                a = int(60 * max(0, 1 - d / 9.0) ** 2)
                c.P(x, y, C(255, 214, 130, a))
    c.outline()
    return c.img


def p_crystal(violet=False, frame=0):
    """Кристалл 16x22, 2 кадра пульса."""
    c = Cv(16, 22)
    base = C(150, 110, 226) if violet else C(96, 190, 226)
    hi = C(216, 196, 255) if violet else C(190, 240, 252)
    dk = C(104, 74, 168) if violet else C(58, 136, 172)
    c.R(5, 6, 10, 18, base)
    c.R(6, 3, 9, 6, base)
    c.P(7, 1, base); c.P(8, 1, base)
    c.VLINE(10, 6, 18, dk); c.VLINE(5, 8, 18, dk)
    c.VLINE(7, 4, 12, hi)
    c.R(2, 16, 5, 20, dk); c.R(11, 14, 14, 19, dk)      # осколки
    c.P(3, 14, dk); c.P(12, 12, dk)
    if frame == 1:
        c.P(4, 5, hi); c.P(12, 8, hi)
        c.P(7, 0, hi)
    c.outline()
    return c.img


def p_planet():
    """Планета с кольцом 64x64."""
    c = Cv(64, 64)
    body, body_d, body_hi = C(96, 130, 200), C(64, 92, 156), C(140, 176, 232)
    band = C(200, 160, 90)
    c.ellipse(32, 34, 20, 19, body)
    for y in range(15, 54):                             # полосы и пятна
        for x in range(12, 52):
            if c.has(x, y):
                t = (y + x) % 7
                if t == 0:
                    c.P(x, y, body_d)
                elif t == 3 and (x - 32) ** 2 + (y - 34) ** 2 < 300:
                    c.P(x, y, body_hi)
    c.ellipse(24, 28, 4, 3, C(120, 200, 180))           # материки
    c.ellipse(40, 40, 5, 3, C(120, 200, 180))
    c.ellipse(38, 24, 3, 2, C(120, 200, 180))
    c.P(26, 27, C(160, 226, 200)); c.P(39, 39, C(160, 226, 200))
    # кольцо (эллипс, передняя дуга поверх планеты, задняя скрыта)
    import math
    for i in range(180):
        th = i * math.pi / 90.0
        x = int(32 + 29 * math.cos(th))
        y = int(36 + 9 * math.sin(th))
        if not (0 <= x < 64 and 0 <= y < 64):
            continue
        behind = math.sin(th) < 0  # верхняя половина за планетой
        if behind:
            if ((x - 32) / 21.0) ** 2 + ((y - 34) / 20.0) ** 2 <= 1.0:
                continue                      # скрыто планетой
        col = band if (i // 6) % 2 == 0 else C(230, 196, 120)
        c.P(x, y, col)
        if not behind:
            c.P(x, y + 1, shade(col, -0.25))
    c.outline()
    return c.img


def p_moon():
    c = Cv(12, 12)
    c.ellipse(6, 6, 5, 5, C(202, 200, 214))
    c.ellipse(5, 5, 4, 4, C(226, 224, 236))
    c.ellipse(7, 8, 1, 1, C(170, 168, 186)); c.ellipse(4, 4, 1, 1, C(170, 168, 186))
    return c.img


def p_asteroid(seed=0):
    rnd = random.Random(seed)
    c = Cv(14, 12)
    c.ellipse(7, 6, 6, 5, C(118, 112, 132))
    c.ellipse(6, 5, 4, 3, C(146, 140, 160))
    for _ in range(4):
        x, y = 4 + rnd.randrange(6), 3 + rnd.randrange(5)
        c.P(x, y, C(92, 88, 106))
    return c.img


def p_island():
    """Парящий остров 48x30."""
    c = Cv(48, 30)
    c.R(8, 8, 39, 14, C(94, 146, 78))                   # трава
    c.HLINE(8, 10, 37, C(116, 168, 96))
    c.R(6, 14, 41, 18, C(118, 112, 132))                # земля
    c.R(12, 18, 35, 22, C(96, 90, 110))
    c.R(18, 22, 29, 25, C(78, 72, 92))                  # остов
    c.P(22, 25, C(78, 72, 92)); c.P(26, 25, C(78, 72, 92))
    c.P(20, 4, C(108, 172, 100))                        # кустик
    c.R(19, 6, 21, 8, C(94, 146, 78))
    c.P(30, 5, C(250, 224, 234)); c.P(29, 6, C(250, 224, 234))
    c.outline()
    return c.img


def p_banner(color="red"):
    """Знамя 16x30."""
    c = Cv(16, 30)
    main = C(196, 44, 60) if color == "red" else C(70, 96, 180)
    c.R(4, 2, 11, 26, main)
    c.HLINE(2, 4, 11, C(150, 150, 166))                 # крепление
    c.P(4, 24, main); c.P(11, 24, main)                 # хвосты
    c.P(3, 25, main); c.P(12, 25, main)
    c.P(5, 10, C(238, 196, 96)); c.P(10, 10, C(238, 196, 96))
    c.P(6, 11, C(238, 196, 96)); c.P(9, 11, C(238, 196, 96))
    c.P(7, 12, C(238, 196, 96)); c.P(8, 12, C(238, 196, 96))  # эмблема-ромб
    c.VLINE(4, 3, 25, shade(main, -0.28))
    c.outline()
    return c.img


def p_shadow():
    c = Cv(24, 10)
    c.ellipse(12, 5, 10, 4, (0, 0, 0, 70))
    c.ellipse(12, 5, 7, 3, (0, 0, 0, 60))
    return c.img


def p_pointer():
    """Золотой указатель над NPC 10x8."""
    c = Cv(10, 8)
    c.R(2, 0, 7, 3, C(246, 208, 110))
    c.R(3, 4, 6, 4, C(246, 208, 110))
    c.P(4, 5, C(246, 208, 110)); c.P(5, 5, C(246, 208, 110))
    c.P(4, 6, C(212, 168, 62))
    c.P(3, 1, C(255, 240, 170))
    c.outline()
    return c.img


# ---------------------------------------------------------------- иконки
def ic_ham():
    c = Cv(16, 16)
    c.ellipse(8, 9, 6, 5, C(198, 120, 84))
    c.ellipse(8, 9, 4, 3, C(232, 168, 130))
    c.ellipse(8, 9, 2, 2, C(244, 210, 180))
    c.R(11, 3, 13, 5, C(236, 226, 210))                 # косточка
    c.P(10, 5, C(236, 226, 210))
    c.outline()
    return c.img


def ic_beer():
    c = Cv(16, 16)
    c.R(4, 5, 11, 14, C(214, 148, 52))
    c.HLINE(5, 4, 11, C(238, 176, 84))
    c.R(3, 2, 12, 5, C(252, 232, 160))                  # пена
    c.P(2, 4, C(252, 232, 160)); c.P(13, 4, C(252, 232, 160))
    c.P(5, 1, C(252, 232, 160)); c.P(10, 1, C(252, 232, 160))
    c.R(12, 7, 14, 12, C(196, 130, 44))                 # ручка
    c.VLINE(14, 7, 12, C(160, 104, 36))
    c.outline()
    return c.img


# --- шаг 6: напитки Глота (ряд растёт: цена и хп) + магическое оружие Зорана ---
def ic_drink_cv(liquid, liquid_hi):
    """Заготовка стакана напитка: стекло, жидкость, блик. Без обводки."""
    c = Cv(16, 16)
    c.R(4, 3, 11, 14, C(178, 206, 226, 200))            # стекло
    c.R(5, 5, 10, 13, liquid)
    c.HLINE(6, 5, 10, liquid_hi)
    c.P(5, 5, shade(liquid_hi, 0.25))
    c.R(3, 14, 12, 15, C(140, 146, 164))                # дно
    c.VLINE(11, 6, 13, shade(liquid, -0.25))
    return c


def ic_water():
    c = ic_drink_cv(C(120, 170, 228), C(160, 208, 246))
    c.outline()
    return c.img


def ic_mors():
    c = ic_drink_cv(C(198, 74, 92), C(232, 118, 130))
    c.P(6, 2, C(140, 40, 60)); c.P(9, 1, C(140, 40, 60))     # ягодка на ободке
    c.P(7, 1, C(60, 130, 70))
    c.outline()
    return c.img


def ic_juice():
    c = ic_drink_cv(C(232, 148, 52), C(250, 190, 96))
    c.outline()
    return c.img


def ic_wand_lightning():
    c = Cv(16, 16)
    c.VLINE(8, 7, 15, C(96, 66, 44))                    # рукоять
    c.R(6, 5, 10, 7, C(150, 110, 220))                  # головка
    c.P(7, 5, C(222, 200, 255)); c.P(9, 6, C(222, 200, 255))
    # молния из головки
    c.P(8, 2, C(250, 230, 120)); c.P(7, 3, C(250, 230, 120))
    c.P(9, 3, C(250, 230, 120)); c.P(8, 4, C(250, 230, 120))
    c.P(6, 1, C(250, 230, 120)); c.P(11, 2, C(250, 230, 120))
    c.P(5, 4, C(200, 170, 90)); c.P(12, 5, C(200, 170, 90))
    c.outline()
    return c.img


def ic_blade_frost():
    c = Cv(16, 16)
    met, met_hi = C(150, 214, 236), C(210, 244, 252)
    c.VLINE(8, 0, 8, met)
    c.VLINE(9, 1, 8, C(106, 168, 196))
    c.P(7, 1, met_hi); c.P(8, 0, met_hi)
    c.P(6, 3, met_hi); c.P(11, 4, met_hi)               # иней на клинке
    c.P(7, 6, C(236, 252, 255))
    c.R(6, 9, 11, 10, C(120, 180, 210))                 # гарда
    c.R(8, 11, 9, 14, C(96, 130, 160))                  # рукоять
    c.P(8, 15, C(180, 226, 240)); c.P(9, 15, C(180, 226, 240))
    c.outline()
    return c.img


def ic_scepter_comet():
    c = Cv(16, 16)
    c.VLINE(8, 8, 15, C(226, 182, 78))                  # золотое древко
    c.R(5, 4, 11, 7, C(150, 110, 220))                  # аметистовый набалдашник
    c.P(6, 4, C(222, 200, 255)); c.P(9, 5, C(96, 60, 160))
    # хвост кометы
    c.P(3, 2, C(250, 230, 120)); c.P(4, 3, C(250, 230, 120))
    c.P(5, 2, C(250, 230, 120)); c.P(2, 4, C(200, 170, 90))
    c.P(8, 1, C(250, 230, 120)); c.P(11, 3, C(250, 230, 120))
    c.outline()
    return c.img


def ic_magic_bolt():
    """Снаряд «Магической стрелы» (использует мир как спрайт заклинания)."""
    c = Cv(16, 16)
    c.ellipse(8, 8, 6, 6, C(70, 150, 180, 170))
    c.ellipse(8, 8, 4, 4, C(120, 210, 230))
    c.ellipse(8, 8, 2, 2, C(232, 252, 255))
    c.P(4, 5, C(200, 244, 252)); c.P(11, 10, C(140, 220, 240))
    c.outline(C(30, 68, 92))
    return c.img


def ic_sword(big=False):
    c = Cv(16, 16)
    met, met_hi = C(198, 208, 222), C(236, 242, 250)
    c.VLINE(8, 0, 8, met)
    c.VLINE(9, 1, 8, C(150, 160, 178))
    c.P(7, 1, met_hi)
    c.P(8, 0, met_hi)
    c.R(6, 9, 11, 10, C(226, 182, 78))                  # гарда
    c.R(8, 11, 9, 14, C(120, 82, 44))                   # рукоять
    c.P(8, 15, C(226, 182, 78)); c.P(9, 15, C(226, 182, 78))
    c.outline()
    return c.img


def ic_greatsword():
    c = Cv(16, 16)
    met, met_hi = C(168, 178, 196), C(224, 232, 244)
    c.R(6, 0, 8, 8, met)
    c.VLINE(9, 1, 8, C(126, 136, 156))
    c.VLINE(6, 0, 8, met_hi)
    c.R(4, 9, 11, 11, C(196, 152, 66))
    c.R(7, 12, 9, 14, C(104, 70, 40))
    c.R(7, 15, 9, 15, C(196, 152, 66))
    c.outline()
    return c.img


def ic_morgenstern():
    c = Cv(16, 16)
    ball = C(140, 148, 164)
    c.ellipse(8, 6, 4, 4, ball)
    c.ellipse(7, 5, 2, 2, C(186, 194, 208))
    for (x, y) in [(8, 1), (4, 4), (12, 4), (5, 9), (11, 9), (8, 10)]:
        c.R(x - 1, y - 1, x + 1, y + 1, C(196, 204, 218))
        c.P(x, y, C(230, 236, 246))
    c.R(7, 10, 8, 14, C(104, 70, 40))                   # рукоять
    c.P(7, 15, C(226, 182, 78)); c.P(8, 15, C(226, 182, 78))
    c.outline()
    return c.img


def ic_potion(violet=False, size="mid", liquid_color=None):
    """Флакон зелья (шаг 7): size "small"/"mid"/"large" — размер растёт
    вместе с ценой и эффектом; liquid_color — цвет жидкости (мана — синяя)."""
    c = Cv(16, 16)
    glass = C(150, 190, 220, 160)
    if violet:
        liquid = C(180, 100, 236)
    elif liquid_color is not None:
        liquid = liquid_color
    else:
        liquid = C(226, 90, 90)
    if size == "small":                    # маленький флакончик
        c.R(6, 2, 9, 5, glass)             # горлышко
        c.R(5, 6, 10, 12, glass)
        c.R(6, 8, 9, 11, liquid)
        c.HLINE(8, 6, 9, shade(liquid, 0.3))
        c.P(6, 8, shade(liquid, 0.45))
        c.R(4, 12, 11, 13, C(120, 124, 140))
    elif size == "large":                  # большая фляга
        c.R(6, 2, 9, 4, glass)             # горлышко
        c.R(3, 4, 12, 13, glass)
        c.R(4, 6, 11, 12, liquid)
        c.HLINE(6, 4, 11, shade(liquid, 0.3))
        c.P(4, 6, shade(liquid, 0.45))
        c.R(2, 13, 13, 14, C(120, 124, 140))
    else:                                  # классика (средняя)
        c.R(6, 2, 9, 4, glass)             # горлышко
        c.R(4, 5, 11, 13, glass)
        c.R(5, 7, 10, 12, liquid)
        c.HLINE(7, 5, 10, shade(liquid, 0.3))
        c.P(5, 7, shade(liquid, 0.45))
        c.R(3, 13, 12, 14, C(120, 124, 140))
    c.P(6, 1, C(196, 152, 66)); c.P(9, 1, C(196, 152, 66))  # пробка
    c.R(6, 0, 9, 1, C(150, 114, 48))
    c.outline()
    return c.img


def ic_star_blade():
    c = Cv(16, 16)
    met = C(186, 170, 246)
    c.VLINE(8, 0, 8, met)
    c.VLINE(9, 1, 8, C(140, 120, 210))
    c.P(8, 0, C(240, 232, 255)); c.P(6, 3, C(240, 232, 255))
    c.R(6, 9, 11, 10, C(226, 182, 78))
    c.R(8, 11, 9, 14, C(110, 80, 160))
    c.P(4, 2, C(255, 250, 200)); c.P(12, 6, C(255, 250, 200))  # звёздочки
    c.outline()
    return c.img


def ic_cloak():
    c = Cv(16, 16)
    c.R(3, 3, 12, 14, C(84, 62, 148))
    c.R(5, 1, 10, 3, C(84, 62, 148))
    c.VLINE(3, 5, 14, C(60, 44, 116))
    c.VLINE(12, 5, 14, C(108, 82, 180))
    c.HLINE(14, 4, 11, C(60, 44, 116))
    c.P(7, 6, C(226, 182, 78)); c.P(8, 6, C(226, 182, 78))  # застёжка
    c.P(5, 10, C(120, 100, 200)); c.P(10, 11, C(120, 100, 200))  # узор
    c.outline()
    return c.img


def ic_elixir():
    return ic_potion(violet=True)


def ic_pouch(tint=None):
    c = Cv(16, 16)
    col = tint or C(150, 150, 160)
    c.ellipse(8, 10, 5, 4, col)
    c.R(5, 5, 10, 8, col)
    c.P(6, 4, shade(col, -0.2)); c.P(9, 4, shade(col, -0.2))
    c.HLINE(8, 5, 10, shade(col, -0.35))                # завязка
    c.P(7, 13, shade(col, -0.25)); c.P(9, 12, shade(col, 0.2))
    c.outline()
    return c.img


ICONS = {
    "ham": ic_ham, "beer": ic_beer, "sword": ic_sword, "greatsword": ic_greatsword,
    "morgenstern": ic_morgenstern, "hp_potion": ic_potion,
    "star_blade": ic_star_blade, "abyss_cloak": ic_cloak, "comet_elixir": ic_elixir,
    # шаг 6: напитки и магическое оружие
    "water": ic_water, "mors": ic_mors, "juice": ic_juice,
    "wand_lightning": ic_wand_lightning, "blade_frost": ic_blade_frost,
    "scepter_comet": ic_scepter_comet, "magic_bolt": ic_magic_bolt,
}

## Шаг 7: зелья Злуса — три размера лечения и три размера маны.
MANA_LIQUID = C(90, 150, 236)
ICONS_STEP7 = {
    "hp_potion_small": lambda: ic_potion(size="small"),
    "hp_potion_large": lambda: ic_potion(size="large"),
    "mana_potion_small": lambda: ic_potion(size="small", liquid_color=MANA_LIQUID),
    "mana_potion": lambda: ic_potion(liquid_color=MANA_LIQUID),
    "mana_potion_large": lambda: ic_potion(size="large", liquid_color=MANA_LIQUID),
}


if __name__ == "__main__":
    import os
    build_tiles() and save(build_tiles(), "tilesets/world_tiles.png")
    os.makedirs(OUT + "/sprites/props", exist_ok=True)
    os.makedirs(OUT + "/sprites/icons", exist_ok=True)
    save(p_arch(), "sprites/props/arch.png")
    save(p_throne(), "sprites/props/throne.png")
    for f in range(3):
        save(p_fountain(f), f"sprites/props/fountain_{f}.png")
    for f in range(3):
        save(p_torch(f), f"sprites/props/torch_{f}.png")
    for f in range(3):
        save(p_brazier(f), f"sprites/props/brazier_{f}.png")
    for f in range(3):
        save(p_forge(f), f"sprites/props/forge_{f}.png")
    save(p_cart(), "sprites/props/cart_gura.png")
    save(p_anvil(), "sprites/props/anvil.png")
    save(p_stand_zlus(), "sprites/props/stand_zlus.png")
    save(p_stall("red"), "sprites/props/stall_red.png")
    save(p_stall("blue"), "sprites/props/stall_blue.png")
    save(p_barrel(), "sprites/props/barrel.png")
    save(p_crate(), "sprites/props/crate.png")
    save(p_sacks(), "sprites/props/sacks.png")
    save(p_bench(), "sprites/props/bench.png")
    save(p_lantern(), "sprites/props/lantern.png")
    for f in range(2):
        save(p_crystal(False, f), f"sprites/props/crystal_{f}.png")
        save(p_crystal(True, f), f"sprites/props/crystal_violet_{f}.png")
    save(p_planet(), "sprites/props/planet.png")
    save(p_moon(), "sprites/props/moon.png")
    save(p_asteroid(1), "sprites/props/asteroid_1.png")
    save(p_asteroid(2), "sprites/props/asteroid_2.png")
    save(p_island(), "sprites/props/island.png")
    save(p_banner("red"), "sprites/props/banner_red.png")
    save(p_banner("blue"), "sprites/props/banner_blue.png")
    save(p_shadow(), "sprites/props/shadow.png")
    save(p_pointer(), "sprites/props/pointer.png")
    for iid, fn in ICONS.items():
        save(fn(), f"sprites/icons/{iid}.png")
    for iid, fn in ICONS_STEP7.items():
        save(fn(), f"sprites/icons/{iid}.png")   # шаг 7: зелья размеров и маны
    # мешочки добычи по цвету качества
    save(ic_pouch(C(150, 150, 160)), "sprites/icons/pouch_gray.png")
    save(ic_pouch(C(96, 186, 110)), "sprites/icons/pouch_green.png")
    save(ic_pouch(C(240, 200, 90)), "sprites/icons/pouch_gold.png")
    save(ic_pouch(C(186, 130, 255)), "sprites/icons/pouch_violet.png")
    # превью
    cells, labels = [], []
    import glob
    for f in sorted(glob.glob(OUT + "/sprites/props/*.png")) + sorted(glob.glob(OUT + "/sprites/icons/*.png")):
        cells.append(Image.open(f).convert("RGBA"))
        labels.append(os.path.basename(f)[:-4])
    save(contact(cells, 64, 64, cols=8, scale=2, bg=(46, 48, 66, 255), labels=labels), "/tmp/props_preview.png")
    ts = build_tiles()
    save(ts.resize((512, 512), Image.NEAREST), "/tmp/tiles_preview.png")
    print("OK")

````

#### `tools/gen_worldmap.py`

````python
# -*- coding: utf-8 -*-
"""Генератор scripts/data/world_map.gd «Dungeon Loot» (шаг 4).
Замок + двор + край мира; новаяSymbols: m/s (мрамор), d (брусчатка), 1-6 (космос)."""
import random

random.seed(11)

W, H = 30, 56
GATE_L, GATE_R = 13, 16          # колонны ворот/ковра
DOORS = [(4, 5), (11, 12), (17, 18), (24, 25)]
WINDOWS = [2, 14, 20, 27]
TORCHES = [3, 8, 15, 21, 26]

rows = []

# --- ряд 0: стена с дверями, окнами
row = ["#"] * W
for a, b in DOORS:
    row[a] = row[b] = "D"
for x in WINDOWS:
    row[x] = "W"
rows.append("".join(row))

# --- ряды 1..18: замок
def castle_floor(x, y):
    # мраморный шахматный зал у трона
    if 11 <= x <= 18 and 14 <= y <= 18:
        return "c" if (x + y) % 2 == 0 else "m"
    return "c"

pillars = {(3, 3), (26, 3), (3, 8), (26, 8), (3, 13), (26, 13)}
pots = {(1, 2), (28, 2), (1, 7), (28, 7), (1, 11), (28, 11), (1, 17), (28, 17),
        (12, 15), (19, 15)}

for y in range(1, 19):
    row = []
    for x in range(W):
        if x == 0 or x == W - 1:
            row.append("#")
        elif (x, y) in pillars:
            row.append("k")
        elif (x, y) in pots:
            row.append("f")
        elif 13 <= x <= 16 and y >= 16:
            row.append("p")                       # ковёр к трону
        else:
            row.append(castle_floor(x, y))
    rows.append("".join(row))

# --- ряд 19: стена фасада с проёмом ворот
row = ["#"] * W
for x in range(GATE_L, GATE_R + 1):
    row[x] = "p"
rows.append("".join(row))

# --- ряды 20..33: двор вдоль стен замка (B), 34..45: луг (F)
def ground_tile(x, y):
    if GATE_L <= x <= GATE_R:
        return "d"                                # брусчатка к воротам
    if 17 <= x <= 20 and 23 <= y <= 27:
        return "d"                                # площадка фонтана
    r = random.random()
    if y >= 34:
        if r < 0.34:
            return "."
        if r < 0.46:
            return "g"
        return ","
    if r < 0.22:
        return "."
    if r < 0.30:
        return "g"
    return ","

for y in range(20, 46):
    row = []
    for x in range(W):
        if y <= 33 and (x <= 2 or x >= 27):
            row.append("B")
        elif y >= 34 and (x <= 1 or x >= 28):
            row.append("F")
        else:
            row.append(ground_tile(x, y))
    rows.append("".join(row))

# --- ряд 46: ограда края
rows.append("R" * W)

# --- ряды 47..55: космос
void_syms = ["V", "1", "2", "3", "4", "5", "6"]
for _y in range(47, H):
    row = [random.choices(void_syms, weights=[40, 10, 10, 10, 10, 10, 10])[0] for _ in range(W)]
    rows.append("".join(row))

# ---------------------------------------------------------------- GDScript
MAP_LINES = "\n".join(f'\t"{r}",' for r in rows)

def v2(x, y):
    return f"Vector2({x}, {y})"

def prop(name, tile, w, h, solid, layer, texture=None, anim=None, bob=None):
    parts = [f'"name": "{name}"', f'"tile": {v2(*tile)}', f'"w": {w}', f'"h": {h}',
             f'"solid": {"true" if solid else "false"}', f'"layer": "{layer}"']
    if texture:
        parts.append(f'"texture": "{texture}"')
    if anim:
        base, frames, fps = anim
        parts.append(f'"anim": ["{base}", {frames}, {fps}]')
    if bob:
        parts.append(f'"bob": Vector2({bob[0]}, {bob[1]})')
    return "{" + ", ".join(parts) + "}"

PROPS = [
    prop("arch", (13, 19), 4, 2, False, "over", texture="res://assets/sprites/props/arch.png"),
    prop("throne", (13, 14), 2, 2, True, "base", texture="res://assets/sprites/props/throne.png"),
    prop("brazier_l", (11, 16), 1, 2, True, "base", anim=["res://assets/sprites/props/brazier", 3, 5.0]),
    prop("brazier_r", (18, 16), 1, 2, True, "base", anim=["res://assets/sprites/props/brazier", 3, 5.5]),
    prop("stand_zlus", (6, 4), 1, 2, True, "base", texture="res://assets/sprites/props/stand_zlus.png"),
    prop("cart_gura", (7, 29), 3, 2, True, "base", texture="res://assets/sprites/props/cart_gura.png"),
    prop("anvil", (22, 31), 1, 1, True, "base", texture="res://assets/sprites/props/anvil.png"),
    prop("forge", (24, 31), 2, 2, True, "base", anim=["res://assets/sprites/props/forge", 3, 4.0]),
    prop("fountain", (17, 24), 2, 2, True, "base", anim=["res://assets/sprites/props/fountain", 3, 4.0]),
    prop("stall_red", (6, 33), 3, 2, True, "base", texture="res://assets/sprites/props/stall_red.png"),
    prop("stall_blue", (21, 38), 3, 2, True, "base", texture="res://assets/sprites/props/stall_blue.png"),
    prop("barrel_1", (4, 21), 1, 1, True, "base", texture="res://assets/sprites/props/barrel.png"),
    prop("barrel_2", (26, 30), 1, 1, True, "base", texture="res://assets/sprites/props/barrel.png"),
    prop("crate_1", (3, 30), 1, 1, True, "base", texture="res://assets/sprites/props/crate.png"),
    prop("crate_2", (25, 22), 1, 1, True, "base", texture="res://assets/sprites/props/crate.png"),
    prop("sacks_1", (9, 33), 1, 1, True, "base", texture="res://assets/sprites/props/sacks.png"),
    prop("sacks_2", (5, 22), 1, 1, True, "base", texture="res://assets/sprites/props/sacks.png"),
    prop("bench_1", (10, 26), 2, 1, True, "base", texture="res://assets/sprites/props/bench.png"),
    prop("bench_2", (18, 39), 2, 1, True, "base", texture="res://assets/sprites/props/bench.png"),
    prop("banner_r1", (1, 2), 1, 2, False, "over", texture="res://assets/sprites/props/banner_red.png"),
    prop("banner_b1", (28, 2), 1, 2, False, "over", texture="res://assets/sprites/props/banner_blue.png"),
    prop("banner_b2", (1, 7), 1, 2, False, "over", texture="res://assets/sprites/props/banner_blue.png"),
    prop("banner_r2", (28, 7), 1, 2, False, "over", texture="res://assets/sprites/props/banner_red.png"),
    prop("banner_r3", (1, 12), 1, 2, False, "over", texture="res://assets/sprites/props/banner_red.png"),
    prop("banner_b3", (28, 12), 1, 2, False, "over", texture="res://assets/sprites/props/banner_blue.png"),
    prop("moon", (8, 49), 1, 1, False, "base", texture="res://assets/sprites/props/moon.png",
         bob=None),
    prop("planet", (7, 49), 3, 3, False, "base", texture="res://assets/sprites/props/planet.png"),
    prop("island_1", (21, 50), 3, 2, False, "base", texture="res://assets/sprites/props/island.png",
         bob=[2.0, 4.0]),
    prop("island_2", (12, 52), 3, 2, False, "base", texture="res://assets/sprites/props/island.png",
         bob=[3.0, 5.0]),
    prop("asteroid_1", (16, 48), 1, 1, False, "base", texture="res://assets/sprites/props/asteroid_1.png",
         bob=[1.5, 3.0]),
    prop("asteroid_2", (26, 52), 1, 1, False, "base", texture="res://assets/sprites/props/asteroid_2.png",
         bob=[2.0, 3.6]),
    prop("asteroid_3", (3, 53), 1, 1, False, "base", texture="res://assets/sprites/props/asteroid_1.png",
         bob=[1.5, 3.2]),
]
for i, tx in enumerate(TORCHES):
    PROPS.append(prop(f"torch_{i}", (tx, 0), 1, 2, False, "over",
                      anim=["res://assets/sprites/props/torch", 3, 6.0]))
CRYSTALS = [((4, 41), False), ((25, 40), False), ((3, 44), False), ((21, 43), False),
            ((8, 44), True), ((24, 43), True), ((27, 38), True)]
for i, (tile, violet) in enumerate(CRYSTALS):
    base = "crystal_violet" if violet else "crystal"
    PROPS.append(prop(f"crystal_{i}", tile, 1, 2, False, "base",
                      anim=[f"res://assets/sprites/props/{base}", 2, 2.0]))
LANTERNS = [(12, 22), (18, 22), (12, 30), (18, 30), (12, 38), (18, 38)]
for i, tile in enumerate(LANTERNS):
    PROPS.append(prop(f"lantern_{i}", tile, 1, 2, False, "over",
                      texture="res://assets/sprites/props/lantern.png"))

PROPS_GD = ",\n".join(f"\t{p}" for p in PROPS)

NPCS = [
    ("zlus", "Злус", "Придворный маг", (5, 5), "castle"),
    ("lira", "Лира", "Хозяйка замка", (16, 15), "castle"),
    ("gura", "Гура", "Повар", (6, 29), "street"),
    ("viras", "Вирас", "Кузнец", (23, 31), "street"),
]
NPCS_GD = ",\n".join(
    f'\t{{"id": "{i}", "name": "{n}", "role": "{r}", "tile": {v2(*t)}, "zone": "{z}", '
    f'"sheet": "res://assets/sprites/chars/{i}.png", '
    f'"portrait": "res://assets/sprites/portraits/{i}.png"}}'
    for (i, n, r, t, z) in NPCS)

DOORS_GD = ",\n".join(
    f'\t{{"id": "dungeon_{k}", "tiles": [{v2(a, 0)}, {v2(b, 0)}]}}'
    for k, (a, b) in enumerate(DOORS, 1))

GD = f'''## Карта мира «Dungeon Loot» (шаг 4): замок + двор + край мира с космосом.
## Сгенерировано скриптом gen_worldmap.py — вручную не править,
## правки вносить в генератор и перегенерировать.
class_name WorldMap
extends RefCounted

const MAP_W := {W}
const MAP_H := {H}
const RAILING_ROW := 46
const CASTLE_LAST_ROW := 19
const TILE_SIZE := 16
const SOLID_TILES := "#BDFRWkf"
const PLAYER_SPAWN := Vector2(14, 13)

## Символ -> координата в атласе assets/tilesets/world_tiles.png
const TILE_ATLAS := {{
    "#": Vector2i(0, 0),
    "W": Vector2i(2, 0),
    "D": Vector2i(3, 0),
    "k": Vector2i(4, 0),
    "B": Vector2i(5, 0),
    "F": Vector2i(6, 0),
    "R": Vector2i(7, 0),
    "c": Vector2i(0, 1),
    "m": Vector2i(1, 1),
    "p": Vector2i(2, 1),
    "d": Vector2i(3, 1),
    ",": Vector2i(4, 1),
    ".": Vector2i(5, 1),
    "g": Vector2i(6, 1),
    "V": Vector2i(7, 1),
    "f": Vector2i(0, 2),
    "s": Vector2i(1, 2),
    "1": Vector2i(2, 2),
    "2": Vector2i(3, 2),
    "3": Vector2i(4, 2),
    "4": Vector2i(5, 2),
    "5": Vector2i(6, 2),
    "6": Vector2i(7, 2),
}}

const MAP: Array[String] = [
{MAP_LINES}
]

## NPC: id, имя, роль, тайл, зона, лист спрайтов и портрет.
const NPCS: Array[Dictionary] = [
{NPCS_GD},
]

const PROPS: Array[Dictionary] = [
{PROPS_GD},
]

const DOORS: Array[Dictionary] = [
{DOORS_GD},
]
'''

with open("/home/z/my-project/game/mini-rpg/scripts/data/world_map.gd", "w") as f:
    f.write(GD)

# быстрая самопроверка
assert all(len(r) == W for r in rows), "ширина строк!"
assert rows[46] == "R" * W
assert rows[0][4] == "D" and rows[0][25] == "D"
print("world_map.gd записан,", len(rows), "рядов")
print("NPC:", [n[0] for n in NPCS])
print("пропов:", len(PROPS))

````

#### `tools/px.py`

````python
# -*- coding: utf-8 -*-
"""Мини-библиотека пиксель-арта для «Dungeon Loot».
Рисование по пикселям, автообводка, палитры, сохранение листов."""
from PIL import Image

OUT = "/home/z/my-project/work/mini-rpg/assets"

# ---------------------------------------------------------------- палитра
INK = (20, 16, 28, 255)          # общая обводка (тёмно-фиолетовый, не чёрный)
INK_SOFT = (34, 28, 46, 255)

def C(r, g, b, a=255):
    return (r, g, b, a)

SKIN = C(236, 179, 134)
SKIN_SH = C(206, 138, 98)
SKIN_HI = C(249, 208, 172)

def shade(c, k):
    """Затемнить/осветлить цвет: k>0 светлее, k<0 темнее."""
    r, g, b, a = c
    if k >= 0:
        return C(min(255, int(r + (255 - r) * k)), min(255, int(g + (255 - g) * k)),
                 min(255, int(b + (255 - b) * k)), a)
    return C(int(r * (1 + k)), int(g * (1 + k)), int(b * (1 + k)), a)


class Cv:
    """Холст с пиксельными примитивами (координаты включительные)."""

    def __init__(self, w, h):
        self.w, self.h = w, h
        self.img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
        self.px_map = {}

    def P(self, x, y, c):
        if 0 <= x < self.w and 0 <= y < self.h:
            self.img.putpixel((x, y), c)
            self.px_map[(x, y)] = c

    def R(self, x0, y0, x1, y1, c):
        for y in range(y0, y1 + 1):
            for x in range(x0, x1 + 1):
                self.P(x, y, c)

    def HLINE(self, y, x0, x1, c):
        self.R(x0, y, x1, y, c)

    def VLINE(self, x, y0, y1, c):
        self.R(x, y0, x, y1, c)

    def has(self, x, y):
        return self.px_map.get((x, y), (0, 0, 0, 0))[3] > 0

    def outline(self, color=INK, inside=False):
        """Обводка силуэта: снаружи (inside=False) или по краю изнутри."""
        edges = []
        for (x, y), c in self.px_map.items():
            if inside:
                if any(not self.has(x + dx, y + dy) for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))):
                    edges.append((x, y))
            else:
                if any(self.has(x + dx, y + dy) for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))) \
                        and not self.has(x, y):
                    edges.append((x, y))
        for (x, y) in edges:
            self.P(x, y, color)

    def ellipse(self, cx, cy, rx, ry, c):
        for y in range(cy - ry, cy + ry + 1):
            for x in range(cx - rx, cx + rx + 1):
                if ((x - cx) / max(rx, 0.001)) ** 2 + ((y - cy) / max(ry, 0.001)) ** 2 <= 1.0:
                    self.P(x, y, c)

    def img_scaled(self, k, nearest=True):
        return self.img.resize((self.w * k, self.h * k), Image.NEAREST if nearest else Image.BILINEAR)


def save(img, rel):
    import os
    path = os.path.join(OUT, rel)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    img.save(path)
    print("  ->", rel, img.size)


def contact(cells, cell_w, cell_h, cols, scale=3, bg=(40, 40, 60, 255), labels=None):
    """Собрать превью-простыню из списка изображений."""
    from PIL import ImageDraw
    rows = (len(cells) + cols - 1) // cols
    sheet = Image.new("RGBA", (cols * cell_w * scale, rows * cell_h * scale), bg)
    d = ImageDraw.Draw(sheet)
    for i, img in enumerate(cells):
        x = (i % cols) * cell_w * scale
        y = (i // cols) * cell_h * scale
        if img.size != (cell_w, cell_h):
            k = max(1, min(cell_w // img.width, cell_h // img.height))
            img = img.resize((img.width * k, img.height * k), Image.NEAREST)
        else:
            img = img.resize((cell_w * scale, cell_h * scale), Image.NEAREST)
        sheet.paste(img, (x + 2, y + 2), img)
        if labels:
            d.text((x + 4, y + 4), labels[i], fill=(255, 255, 120, 255))
    return sheet

````
