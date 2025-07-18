extends Node
class_name TutorialManager

@export var steps: Array[TutorialStep] = []

@onready var subtitle_label: Label = $SubtitleLabel
@onready var audio_player: AudioStreamPlayer = $AudioPlayer

var step_index: int = 0
var waiting_for_input: bool = false

func _ready():
	if steps.size() > 0:
		start_step(step_index)
	else:
		print("No tutorial steps assigned.")

func start_step(index: int):
	if index >= steps.size():
		subtitle_label.text = ""
		print("Tutorial finished.")
		return

	var step: TutorialStep = steps[index]
	subtitle_label.text = step.text

	if step.audio:
		audio_player.stream = step.audio
		audio_player.play()
		await audio_player.finished
	elif step.duration > 0:
		await get_tree().create_timer(step.duration).timeout

	# **Pause for 1.5 seconds before proceeding**
	await get_tree().create_timer(0.6).timeout

	if step.action_required != "":
		waiting_for_input = true
	else:
		next_step()

func _process(_delta):
	if not waiting_for_input:
		return

	var step: TutorialStep = steps[step_index]
	match step.action_required:
		"jump":
			if Input.is_action_just_pressed("jump"):
				waiting_for_input = false
				next_step()
		"move":
			if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
				waiting_for_input = false
				next_step()
		"crouch":
			if Input.is_action_pressed("crouch"):
				waiting_for_input = false
				next_step()
		"interact":
			if Input.is_action_just_pressed("ui_select"):
				waiting_for_input = false
				next_step()

func next_step():
	step_index += 1
	start_step(step_index)
