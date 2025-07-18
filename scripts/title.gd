extends Control

func _ready():
	GlobalSettings.apply_color_scheme(get_tree().root)
	
	$VBoxContainer/Button.text = "Start Game"
	$VBoxContainer/Button.pressed.connect(_on_start_game_pressed)

	$VBoxContainer/Button2.text = "Level Select"
	$VBoxContainer/Button2.pressed.connect(_on_level_select_pressed)

	$VBoxContainer/Button3.text = "Quit"
	$VBoxContainer/Button3.pressed.connect(_on_quit_pressed)


func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://main scenes/menus/main_menu.tscn")

func _on_level_select_pressed():
	get_tree().change_scene_to_file("res://main scenes/menus/level_select.tscn")

func _on_quit_pressed():
	get_tree().quit()
