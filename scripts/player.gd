extends CharacterBody2D

@export var speed = 150
@export var gravity = 20
@export var jump_force = 250
@export var float_gravity = 2           # Gravity while floating (near zero)
@export var slam_force = 800            # Downward force applied on slam
@export var max_stamina = 3.0           # Max stamina seconds for floating
@export var stamina_recharge_rate = 1.0 # Stamina recharge per second

@onready var animated_sprite = $AnimatedSprite2D
@onready var back_button = $BackToMenuButton
@onready var slam_sound = $SlamSound    # Your AudioStreamPlayer node for slam
@onready var Jumps = 0

var can_climb := false
var is_floating := false


var original_scale := Vector2.ONE

func _ready():
	original_scale = scale

func _physics_process(delta):
	# Keep button upright
	if back_button:
		back_button.rotation_degrees = -rotation_degrees

	handle_float(delta)

	if !can_climb:
		if !is_floating:
			# Normal gravity when not floating
			if !is_on_floor():
				velocity.y += gravity
				velocity.y = min(velocity.y, 1000)
			else:
				Jumps = 0

			# Jumping (disabled while floating)
			if Input.is_action_just_pressed("jump") and Jumps < 2 and !is_floating:
				velocity.y = -jump_force
				animated_sprite.play("jump")
				Jumps += 1
		else:
			# While floating, gravity is reduced
			velocity.y += float_gravity
			velocity.y = min(velocity.y, 1000)

		# Horizontal movement (disabled while floating for smoother control)
		if !is_floating:
			var horizontal_direction = Input.get_axis("move_left", "move_right")
			velocity.x = speed * horizontal_direction
		else:
			velocity.x = 0
	else:
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

func handle_float(delta):
	var float_pressed = Input.is_action_pressed("crouch")

	if float_pressed and GlobalSettings.stamina > 0 and !is_on_floor():
		if !is_floating:
			is_floating = true
			print("✨ Started floating!")
		GlobalSettings.stamina = max(GlobalSettings.stamina - delta, 0)
	else:
		if is_floating:
			is_floating = false
			velocity.y = slam_force
			if slam_sound:
				slam_sound.play()
			print("💥 Slam!")

		if is_on_floor():
			GlobalSettings.stamina = min(GlobalSettings.stamina + stamina_recharge_rate * delta, GlobalSettings.max_stamina)


func handle_movement_animation(dir):
	if dir == 0:
		if is_on_floor():
			animated_sprite.play("Idle")
	else:
		animated_sprite.play("walking")
		animated_sprite.flip_h = dir < 0

func launch_upwards(force: float):
	velocity.y = force
