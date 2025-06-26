extends Node

class_name TutorialManager

@export var steps: Array[Dictionary] = []
@onready var subtitle_label: Label = $SubtitleLabel
@onready var audio_player: AudioStreamPlayer = $AudioPlayer

var step_index = 0
var waiting_for_input = false

func _ready():
	start_step(step_index)

func start_step(index: int):
	if index >= steps.size():
		subtitle_label.text = ""
		return

	var step = steps[index]
	subtitle_label.text = step["text"]

	if GlobalSettings.tts_enabled:
		speak_text(step["text"])
		await get_tree().create_timer(step["duration"]).timeout
	elif step.has("audio") and step["audio"] != "":
		audio_player.stream = load(step["audio"])
		audio_player.play()
		await audio_player.finished
	elif not step.has("action_required"):
		await get_tree().create_timer(step["duration"]).timeout

	if step.has("action_required"):
		waiting_for_input = true
	else:
		next_step()

func next_step():
	step_index += 1
	start_step(step_index)

func _process(_delta):
	if not waiting_for_input:
		return

	var step = steps[step_index]
	match step["action_required"]:
		"jump":
			if Input.is_action_just_pressed("ui_accept"):  # Replace with your actual jump input
				waiting_for_input = false
				next_step()
		"move":
			if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
				waiting_for_input = false
				next_step()
		"crouch":
			if Input.is_action_pressed("ui_down"):
				waiting_for_input = false
				next_step()
		"interact":
			if Input.is_action_just_pressed("ui_select"):  # Replace as needed
				waiting_for_input = false
				next_step()

func speak_text(text: String):
	if OS.get_name() == "Windows":
		OS.execute("powershell", ["-Command", "Add-Type –AssemblyName System.Speech; (New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('" + text + "')"], false)
	elif OS.get_name() == "Darwin":
		OS.execute("say", [text], false)
	elif OS.get_name() == "Linux":
		OS.execute("espeak", [text], false)
