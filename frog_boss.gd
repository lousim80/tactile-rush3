extends CharacterBody2D

@export var gravity: float = 600.0
@export var qte_sequence: Array[String] = ["ui_left", "ui_right", "jump"] # Keys you must press in order
@export var fall_height: float = 200.0 # Y position where cat starts falling

var qte_index: int = 0
var is_falling: bool = false
var is_qte_active: bool = false
var is_defeated: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	# Cat starts idle above the fight zone
	position.y -= fall_height

func _physics_process(delta):
	if is_falling and not is_defeated:
		velocity.y += gravity * delta
		move_and_slide()
		
		# Check if cat has landed
		if is_on_floor():
			is_falling = false
			start_qte()

func start_fight():
	if not is_falling and not is_defeated:
		is_falling = true

func start_qte():
	is_qte_active = true
	qte_index = 0
	animation_player.play("idle") # Or a ready pose animation

func _process(_delta):
	if not is_qte_active or is_defeated:
		return

	var required_action = qte_sequence[qte_index]
	if Input.is_action_just_pressed(required_action):
		qte_index += 1
		animation_player.play("pose_" + str(qte_index)) # Play new pose
		if qte_index >= qte_sequence.size():
			defeat_cat()

func defeat_cat():
	is_qte_active = false
	is_defeated = true
	animation_player.play("defeat") # Death or defeat animation
	# You can queue_free() after animation if desired
