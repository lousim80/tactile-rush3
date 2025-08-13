extends Node2D  # or whatever node you're using for the follower

@onready var player = get_node("/root/Main/Player")  # Adjust if needed

func _process(delta):
	if player:
		global_position = player.global_position + Vector2(0, -50)
