extends CharacterBody2D

@export var speed = 150
@export var gravity = 20
@export var jump_force = 250

@onready var animated_sprite = $AnimatedSprite2D
@onready var back_button = $BackToMenuButton  # Reference the button here
@onready var Jumps = 0

var can_climb := false

func _physics_process(delta):
	# Keep button upright
	if back_button:
		back_button.rotation_degrees = -rotation_degrees

	if !can_climb:
		# Gravity
		if !is_on_floor():
			velocity.y += gravity
			velocity.y = min(velocity.y, 1000)
		else:
			Jumps = 0

		# Jumping
		if Input.is_action_just_pressed("jump") and Jumps < 2:
			velocity.y = -jump_force
			animated_sprite.play("jump")
			Jumps += 1

		# Horizontal movement
		var horizontal_direction = Input.get_axis("move_left", "move_right")
		velocity.x = speed * horizontal_direction
	else:
		# Disable movement while climbing
		velocity = Vector2.ZERO

	move_and_slide()

	# Collision check
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider and collider.name == "sign":
			print("✅ Collided with a sign!")

	if !can_climb:
		handle_movement_animation(Input.get_axis("move_left", "move_right"))

func handle_movement_animation(dir):
	if dir == 0:
		animated_sprite.play("Idle")
	else:
		animated_sprite.play("walking")
		animated_sprite.flip_h = dir < 0

func launch_upwards(force: float):
	velocity.y = force
