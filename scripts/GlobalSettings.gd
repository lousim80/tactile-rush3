extends Node

# Accessibility toggles
var tts_enabled: bool = false
var sign_enabled: bool = false
var color_mode: int = 0
var subtitles_size: float = 16.0

# Add more if needed later, like:
# var high_contrast_enabled = false
# var game_volume = 1.0


# We need access to those caches — you can pass them in or make global.
# For simplicity, pass dictionaries as arguments.

func apply_color_scheme(root_node: Node, 
						default_font_colors := {}, 
						default_button_styleboxes := {}) -> void:
	match color_mode:
		0:
			_clear_colors(root_node, default_font_colors, default_button_styleboxes)
		1:
			_set_colors(root_node, Color(0.85, 0.9, 1), Color(0.1, 0.2, 0.6))
		2:
			_set_colors(root_node, Color(0, 0, 0), Color(1, 1, 0))

func _set_colors(node: Node, bg_color: Color, fg_color: Color) -> void:
	if node is Sprite2D or node is TileMap:
		node.modulate = fg_color
	elif node is ColorRect:
		node.color = bg_color
	elif node is Label or node is Button or node is CheckBox:
		node.add_theme_color_override("font_color", fg_color)
		if node is Button:
			var box = StyleBoxFlat.new()
			box.bg_color = bg_color
			node.add_theme_stylebox_override("normal", box)
	for child in node.get_children():
		_set_colors(child, bg_color, fg_color)

func _clear_colors(node: Node, default_font_colors: Dictionary, default_button_styleboxes: Dictionary) -> void:
	if node is Sprite2D or node is TileMap:
		node.modulate = Color(1, 1, 1, 1)
	elif node is ColorRect:
		node.color = Color(1, 1, 1, 1)
	elif node is Label or node is Button or node is CheckBox:
		if default_font_colors.has(node):
			node.add_theme_color_override("font_color", default_font_colors[node])
		if node is Button and default_button_styleboxes.has(node):
			node.add_theme_stylebox_override("normal", default_button_styleboxes[node])
	for child in node.get_children():
		_clear_colors(child, default_font_colors, default_button_styleboxes)
