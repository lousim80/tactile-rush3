extends Control

func _ready():
	$Panel/Button.pressed.connect(load_level.bind("res://main scenes/levels/level_1.tscn"))
	$Panel/Button2.pressed.connect(load_level.bind("res://main scenes/levels/level_2.tscn"))
	$Panel/Button3.pressed.connect(load_level.bind("res://main scenes/levels/level_3.tscn"))
	$Panel/Button4.pressed.connect(load_level.bind("res://main scenes/levels/level_4.tscn"))
	$Panel/Button5.pressed.connect(back_to_menu)

	_update_buttons()

func load_level(level_path: String):
	if level_path in GlobalSettings.unlocked_levels:
		get_tree().change_scene_to_file(level_path)
	else:
		print("Level locked!")

func back_to_menu():
	get_tree().change_scene_to_file("res://main scenes/menus/title.tscn")

func _update_buttons():
	$Panel/Button.disabled = false # Level 1 always playable
	$Panel/Button2.disabled = not ("res://main scenes/levels/level_2.tscn" in GlobalSettings.unlocked_levels)
	$Panel/Button3.disabled = not ("res://main scenes/levels/level_3.tscn" in GlobalSettings.unlocked_levels)
	$Panel/Button4.disabled = not ("res://main scenes/levels/level_4.tscn" in GlobalSettings.unlocked_levels)
