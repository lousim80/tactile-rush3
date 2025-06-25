extends Node

@export var steps: Array[TutorialStep]
@onready var audio_player = $AudioStreamPlayer
@onready var subtitle_label = $"../UI/SubtitlesBackground/SubtitlesLabel"

var current_step = 0
var waiting_for_input = false

func _ready():
	start_step(current_step)

func start_step(index: int):
	if index >= steps.size():
		subtitle_label.text = ""
		return

	var step = steps[index]
	subtitle_label.text = step.text

	# TTS not implemented here — you can add if needed
	if step.audio_path != "":
		audio_player.stream = load(step.audio_path)
		audio_player.play()

	if step.action_required == "":
		# No input required → wait for audio or time
		if step.audio_path != "":
			await audio_player.finished
		else:
			await get_tree().create_timer(step.duration).timeout
		next_step()
	else:
		waiting_for_input = true

func _input(event):
	if not waiting_for_input:
		return

	var required = steps[current_step].action_required
	if required != "" and Input.is_action_just_pressed(required):
		waiting_for_input = false
		next_step()

func next_step():
	current_step += 1
	start_step(current_step)
