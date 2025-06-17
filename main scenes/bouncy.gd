extends Area2D

@export var launch_force: float = -500.0

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if body.has_method("launch_upwards"):
			body.launch_upwards(launch_force)
