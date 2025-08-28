extends Node2D  # Or your UI node type

@onready var player = get_node("/root/Main/Player")

func _process(delta):
	if player:
		global_position = player.global_position + Vector2(0, -50)
