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
