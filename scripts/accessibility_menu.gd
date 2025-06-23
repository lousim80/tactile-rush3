extends Control

@onready var tts_check = $Panel/VBoxContainer/CheckBox_TTS
@onready var sign_check = $Panel/VBoxContainer/CheckBox_Sign
@onready var color_mode = $Panel/VBoxContainer/OptionButton_Color
@onready var subtitles_slider = $Panel/VBoxContainer/HSlider_Subtitles
@onready var back_button = $Panel/VBoxContainer/Button_Back

func _ready():
	# Set up dropdown options
	color_mode.add_item("Default")
	color_mode.add_item("Colorblind - Deuteranopia")
	color_mode.add_item("High Contrast")

	# Load saved settings if they exist
	if FileAccess.file_exists("user://settings.cfg"):
		var config = ConfigFile.new()
		config.load("user://settings.cfg")
		tts_check.button_pressed = config.get_value("accessibility", "tts_enabled", false)
		sign_check.button_pressed = config.get_value("accessibility", "sign_enabled", false)
		color_mode.select(config.get_value("accessibility", "color_mode", 0))
		subtitles_slider.value = config.get_value("accessibility", "subtitles_size", 16)

func _on_CheckBox_TTS_toggled(button_pressed):
	GlobalSettings.tts_enabled = button_pressed
	save_settings()

func _on_CheckBox_Sign_toggled(button_pressed):
	GlobalSettings.sign_enabled = button_pressed
	save_settings()

func _on_OptionButton_Color_item_selected(index):
	GlobalSettings.color_mode = index
	save_settings()

func _on_HSlider_Subtitles_value_changed(value):
	GlobalSettings.subtitles_size = value
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
