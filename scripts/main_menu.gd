extends Control

func _ready():
	GlobalSettings.apply_color_scheme(get_tree().root)
	# Set button text and connect signals
	$VBoxContainer/Button.text = "Level Select"
	$VBoxContainer/Button.pressed.connect(_on_start_game_pressed)

	$VBoxContainer/Button2.text = "Accessibility"
	$VBoxContainer/Button2.pressed.connect(_on_accessibility_pressed)

	$VBoxContainer/Button3.text = "Quit"
	$VBoxContainer/Button3.pressed.connect(_on_quit_pressed)
	
	$VBoxContainer/Button4.text = "Tutorial"
	$VBoxContainer/Button4.pressed.connect(_on_tutorial_pressed)


func _on_start_game_pressed():
	var result = get_tree().change_scene_to_file("res://main scenes/menus/level_select.tscn")
	if result != OK:
		print("Failed to load game scene!")

func _on_accessibility_pressed():
	var result = get_tree().change_scene_to_file("res://main scenes/menus/accessibility_menu.tscn")
	if result != OK:
		print("Failed to load accessibility menu!")

func _on_quit_pressed():
	get_tree().quit()

func _on_tutorial_pressed():
	var result = get_tree().change_scene_to_file("res://main scenes/menus/tutorial_scene.tscn")
	if result != OK:
		print("Failed to load accessibility menu!")
		
