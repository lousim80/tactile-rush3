extends Node

# Accessibility settings
var tts_enabled: bool = false
var sign_enabled: bool = false
var color_mode: int = 0  # 0 = Default, 1 = Deuteranopia, 2 = High Contrast
var subtitles_size: int = 16  # Global subtitle font size

# Cached defaults for restoring original themes
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
			_restore_defaults(root_node)
		1:
			_apply_deuteranopia(root_node)
		2:
			_apply_high_contrast(root_node)

func _restore_defaults(node):
	if node in default_font_colors:
		if node is Sprite2D:
			node.modulate = default_font_colors[node]
		else:
			node.add_theme_color_override("font_color", default_font_colors[node])
	if node is Button and node in default_button_styleboxes:
		node.add_theme_stylebox_override("normal", default_button_styleboxes[node])
	for child in node.get_children():
		_restore_defaults(child)

func _apply_deuteranopia(node):
	if node is Label or node is Button or node is CheckBox:
		node.add_theme_color_override("font_color", Color(0.0, 0.5, 0.7))
	if node is Button:
		node.add_theme_stylebox_override("normal", create_stylebox(Color(0.1, 0.5, 0.6)))
	if node is Sprite2D:
		node.modulate = Color(0.7, 0.9, 0.9)
	for child in node.get_children():
		_apply_deuteranopia(child)

func _apply_high_contrast(node):
	if node is Label or node is Button or node is CheckBox:
		node.add_theme_color_override("font_color", Color(0, 0, 0))
	if node is Button:
		node.add_theme_stylebox_override("normal", create_stylebox(Color(1, 1, 0)))
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

# Apply subtitle size to all labels named "subtitle"
func apply_subtitle_size(root_node):
	_apply_subtitle_size_recursive(root_node)

func _apply_subtitle_size_recursive(node):
	if node is Label and "subtitle" in node.name.to_lower():
		node.add_theme_font_size_override("font_size", subtitles_size)
	for child in node.get_children():
		_apply_subtitle_size_recursive(child)

# Existing stamina variables
var stamina: float = 3.0
var max_stamina: float = 3.0

# -------------------
# Progression variables
# -------------------

var unlocked_levels: Array[String] = [
	"res://main scenes/levels/level_1.tscn"  # Level 1 always unlocked
]
var current_house: String = "res://houses/House1.tscn"

func unlock_level(level_path: String):
	if not level_path in unlocked_levels:
		unlocked_levels.append(level_path)

func set_next_house(house_path: String):
	current_house = house_path

func save_progress():
	var data = {
		"unlocked_levels": unlocked_levels,
		"current_house": current_house,
	}
	var file = FileAccess.open("user://progress.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()

func load_progress():
	if FileAccess.file_exists("user://progress.json"):
		var file = FileAccess.open("user://progress.json", FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		unlocked_levels = data.get("unlocked_levels", unlocked_levels)
		current_house = data.get("current_house", current_house)
