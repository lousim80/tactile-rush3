extends Control

@onready var tts_check = $Panel/VBoxContainer/CheckBox_TTS
@onready var sign_check = $Panel/VBoxContainer/CheckBox_Sign
@onready var color_mode = $Panel/VBoxContainer/HBoxContainer_Color/OptionButton_Color
@onready var subtitles_slider = $Panel/VBoxContainer/HBoxContainer_Subtitles/HSlider_Subtitles
@onready var subtitle_preview = $Panel/VBoxContainer/HBoxContainer_Subtitles/Label_SubtitlePreview
@onready var back_button = $Panel/VBoxContainer/Button_Back

# Dictionaries to store original theme data
var default_font_colors = {}
var default_button_styleboxes = {}

func _ready():
	# Set up dropdown options
	color_mode.clear()
	color_mode.add_item("Default")
	color_mode.add_item("Colorblind - Deuteranopia")
	color_mode.add_item("High Contrast")

	# Connect signals
	tts_check.toggled.connect(_on_CheckBox_TTS_toggled)
	sign_check.toggled.connect(_on_CheckBox_Sign_toggled)
	color_mode.item_selected.connect(_on_OptionButton_Color_item_selected)
	subtitles_slider.value_changed.connect(_on_HSlider_Subtitles_value_changed)
	back_button.pressed.connect(_on_Button_Back_pressed)

	# Load saved settings
	if FileAccess.file_exists("user://settings.cfg"):
		var config = ConfigFile.new()
		config.load("user://settings.cfg")
		tts_check.button_pressed = config.get_value("accessibility", "tts_enabled", false)
		sign_check.button_pressed = config.get_value("accessibility", "sign_enabled", false)
		color_mode.select(config.get_value("accessibility", "color_mode", 0))
		subtitles_slider.value = config.get_value("accessibility", "subtitles_size", 16)

	# Update subtitle preview font size on load
	subtitle_preview.add_theme_font_size_override("font_size", int(subtitles_slider.value))

	# Cache original theme colors and styleboxes so we can restore them later
	cache_defaults(get_tree().root)

	# Apply saved color mode live immediately
	GlobalSettings.color_mode = color_mode.get_selected()
	GlobalSettings.apply_color_scheme(get_tree().root)

func cache_defaults(node: Node) -> void:
	# Recursively store original font colors and button styleboxes
	if node is Label or node is Button or node is CheckBox:
		default_font_colors[node] = node.get_theme_color("font_color")
		if node is Button:
			default_button_styleboxes[node] = node.get_theme_stylebox("normal")
	for child in node.get_children():
		cache_defaults(child)

func _on_CheckBox_TTS_toggled(button_pressed):
	GlobalSettings.tts_enabled = button_pressed
	save_settings()

func _on_CheckBox_Sign_toggled(button_pressed):
	GlobalSettings.sign_enabled = button_pressed
	GlobalSettings.apply_color_scheme(get_tree().root)  # updates live
	save_settings()

func _on_OptionButton_Color_item_selected(index):
	GlobalSettings.color_mode = index
	GlobalSettings.apply_color_scheme(get_tree().root)  # apply live update
	save_settings()

func _on_HSlider_Subtitles_value_changed(value):
	GlobalSettings.subtitles_size = value
	subtitle_preview.add_theme_font_size_override("font_size", int(value))
	save_settings()

func _on_Button_Back_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func save_settings():
	var config = ConfigFile.new()
	config.set_value("accessibility", "tts_enabled", GlobalSettings.tts_enabled)
	config.set_value("accessibility", "sign_enabled", GlobalSettings.sign_enabled)
	config.set_value("accessibility", "color_mode", GlobalSettings.color_mode)
	config.set_value("accessibility", "subtitles_size", GlobalSettings.subtitles_size)
	config.save("user://settings.cfg")
