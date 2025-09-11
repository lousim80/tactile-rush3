extends Node2D

@export var next_level_path: String          # e.g. "res://main scenes/levels/level_2.tscn"
@export var next_house_path: String          # e.g. "res://houses/House2.tscn"

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"): # make sure only the player triggers
		_unlock_progress()

func _unlock_progress():
	GlobalSettings.unlock_level(next_level_path)   # unlock the next level
	GlobalSettings.set_next_house(next_house_path) # set the next house upgrade
	GlobalSettings.save_progress()

	# Load the next level
	get_tree().change_scene_to_file(next_level_path)
