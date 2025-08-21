extends Node2D  # Or your UI node type

@onready var player = get_node("/root/Main/Player")
@onready var stamina_bar = $"../StaminaBar"  # Reference to the ProgressBar node

func _process(delta):
	if player:
		global_position = player.global_position + Vector2(0, -50)

	# Update stamina bar value (percentage)
	stamina_bar.value = (GlobalSettings.stamina / GlobalSettings.max_stamina) * 100
