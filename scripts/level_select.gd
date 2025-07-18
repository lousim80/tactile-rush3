extends Control

func _ready():
	$Panel/Button.pressed.connect(load_level_1)
	$Panel/Button2.pressed.connect(load_level_2)
	$Panel/Button3.pressed.connect(load_level_3)
	$Panel/Button4.pressed.connect(load_level_4)
	$Panel/Button5.pressed.connect(back_to_menu)

func load_level_1():
	get_tree().change_scene_to_file("res://main scenes/levels/level_1.tscn")

func load_level_2():
	get_tree().change_scene_to_file("res://main scenes/levels/level_2.tscn")

func load_level_3():
	get_tree().change_scene_to_file("res://main scenes/levels/level_2.tscn")

func load_level_4():
	get_tree().change_scene_to_file("res://main scenes/levels/level_2.tscn")

func back_to_menu():
	get_tree().change_scene_to_file("res://main scenes/menus/title.tscn")
