@icon("res://icon.svg")  # Optional
extends Resource
class_name TutorialStep

@export var text: String
@export var audio: AudioStream
@export var duration: float = 2.0
@export var action_required: String = ""  # e.g. "jump", "move"
