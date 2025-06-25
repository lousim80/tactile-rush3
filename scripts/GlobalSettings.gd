# GlobalSettings.gd
extends Node

var tts_enabled: bool = false
var sign_enabled: bool = false
var color_mode: int = 0  # 0=Default,1=Deuteranopia,2=HighContrast
var subtitles_size: int = 16

var default_font_colors := {}
var default_button_styleboxes := {}

func cache_defaults(root_node):
	default_font_colors.clear()
	default_button_styleboxes.clear()
	_cache_node_defaults(root_node)

func _cache_node_defaults(node):
	if node is Label or node is Button or node is CheckBox:
		default_font_colors[node] = node.get_theme_color("font_color")
		if node is Button:
			default_button_styleboxes[node] = node.get_theme_stylebox("normal")
	if node is Sprite2D:
		default_font_colors[node] = node.modulate
	for child in node.get_children():
		_cache_node_defaults(child)

func apply_color_scheme(root_node):
	match color_mode:
		0:
			_clear_colors(root_node)
		1:
			_apply_deuteranopia(root_node)
		2:
			_apply_high_contrast(root_node)

func _clear_colors(node):
	if node in default_font_colors:
		if node is Sprite2D:
			node.modulate = default_font_colors[node]
		else:
			node.add_theme_color_override("font_color", default_font_colors[node])
	if node is Button and node in default_button_styleboxes:
		node.add_theme_stylebox_override("normal", default_button_styleboxes[node])
	for child in node.get_children():
		_clear_colors(child)

func _apply_deuteranopia(node):
	if node is Label or node is Button or node is CheckBox:
		node.add_theme_color_override("font_color", Color(0.0, 0.6, 0.6))
	if node is Button:
		node.add_theme_stylebox_override("normal", create_stylebox(Color(0.0, 0.4, 0.4)))
	if node is Sprite2D:
		node.modulate = Color(0.7, 0.9, 0.9)
	for child in node.get_children():
		_apply_deuteranopia(child)

func _apply_high_contrast(node):
	if node is Label or node is Button or node is CheckBox:
		node.add_theme_color_override("font_color", Color.BLACK)
	if node is Button:
		node.add_theme_stylebox_override("normal", create_stylebox(Color.YELLOW))
	if node is Sprite2D:
		node.modulate = Color(1, 1, 0.5)
	for child in node.get_children():
		_apply_high_contrast(child)

func create_stylebox(color: Color) -> StyleBoxFlat:
	var sb = StyleBoxFlat.new()
	sb.bg_color = color
	sb.border_width_left = 2
	sb.border_width_top = 2
	sb.border_width_right = 2
	sb.border_width_bottom = 2
	sb.border_color = Color.BLACK
	return sb
