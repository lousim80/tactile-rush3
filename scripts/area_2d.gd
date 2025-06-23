extends Area2D

@onready var animated_sprite = $AnimatedSprite2D

@export var launch_force: float = -500.0

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		animated_sprite.play("jumpy_jump")
		if body.has_method("launch_upwards"):
			body.launch_upwards(launch_force)
