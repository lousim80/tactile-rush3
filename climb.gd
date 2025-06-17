extends Area2D

@export var climb_speed := 150.0

var player: CharacterBody2D = null

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player = body
		player.gravity = 0
		player.velocity = Vector2.ZERO
		player.can_climb = true

		var animated_sprite = player.get_node("AnimatedSprite2D")
		if animated_sprite:
			animated_sprite.play("climb")

func _on_body_exited(body):
	if body == player:
		var animated_sprite = player.get_node("AnimatedSprite2D")
		if animated_sprite:
			animated_sprite.stop()

		player.gravity = 20
		player.can_climb = false

		# Apply speed boost
		player.max_speed += player.speed_boost_amount
		player.speed_boost_timer = player.speed_boost_duration

		player = null

func _process(delta):
	if player and player.can_climb:
		var move_input := 0

		if Input.is_action_pressed("move_up"):
			move_input = -1
		elif Input.is_action_pressed("move_down"):
			move_input = 1

		player.position.y += move_input * climb_speed * delta

		var animated_sprite = player.get_node("AnimatedSprite2D")
		if animated_sprite:
			if move_input != 0:
				if animated_sprite.animation != "climb":
					animated_sprite.play("climb")
				animated_sprite.speed_scale = abs(move_input)
			else:
				animated_sprite.speed_scale = lerp(animated_sprite.speed_scale, 0.0, 0.1)  # Fixed type error
