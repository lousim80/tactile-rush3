extends Control

@onready var subtitle_label = $Panel/VBoxContainer/HBoxContainer_Subtitles/subtitle_label
@onready var color_mode = $Panel/VBoxContainer/HBoxContainer_Color/OptionButton_Color
@onready var back_button = $Panel/VBoxContainer/Button_Back

func _ready():
	color_mode.clear()
	color_mode.add_item("Default")
	color_mode.add_item("Colorblind - Deuteranopia")
	color_mode.add_item("High Contrast")

	color_mode.item_selected.connect(_on_OptionButton_Color_item_selected)
	back_button.pressed.connect(_on_Button_Back_pressed)

	if FileAccess.file_exists("user://settings.cfg"):
		var config = ConfigFile.new()
		var err = config.load("user://settings.cfg")
		if err == OK:
			GlobalSettings.color_mode = config.get_value("accessibility", "color_mode", 0)
		else:
			GlobalSettings.color_mode = 0
	else:
		GlobalSettings.color_mode = 0

	color_mode.select(GlobalSettings.color_mode)

	GlobalSettings.cache_defaults(get_tree().root)
	GlobalSettings.apply_color_scheme(get_tree().root)

func _on_OptionButton_Color_item_selected(index):
	GlobalSettings.color_mode = index
	GlobalSettings.apply_color_scheme(get_tree().root)
	_save_settings()

func _on_Button_Back_pressed():
	get_tree().change_scene_to_file("res://main scenes/menus/main_menu.tscn")

func _save_settings():
	var config = ConfigFile.new()
	config.set_value("accessibility", "color_mode", GlobalSettings.color_mode)
	config.save("user://settings.cfg")

func _on_SubtitlesSlider_value_changed(value):
	subtitle_label.add_theme_font_size_override("font_size", int(value))
