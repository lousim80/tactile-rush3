extends CharacterBody2D

@export var max_speed = 150
@export var acceleration = 35
@export var deceleration = 100
@export var gravity = 20
@export var jump_force = 250

@export var speed_boost_amount = 200
@export var speed_boost_duration = 3.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var Jumps = 0

var current_speed = 0
var can_climb := false
var speed_boost_timer := 0.0
var base_max_speed = 0  # Store original max speed after ready

func _ready():
	base_max_speed = max_speed  # ✅ Correctly assign after exports are set

func _physics_process(delta):
	# Handle speed boost duration
	if speed_boost_timer > 0:
		speed_boost_timer -= delta
		if speed_boost_timer <= 0:
			max_speed = base_max_speed  # Reset to original speed

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

		if horizontal_direction != 0:
			current_speed = min(current_speed + acceleration * delta, max_speed)
		else:
			current_speed = max(current_speed - deceleration * delta, 0)

		velocity.x = current_speed * horizontal_direction
	else:
		# Disable all movement while climbing (handled by climb zone)
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
