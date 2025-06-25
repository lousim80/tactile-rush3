extends Resource
class_name TutorialStep

@export var text: String  # What to display on screen
@export var audio_path: String  # Path to the voice line (or leave blank if using TTS)
@export var action_required: String = ""  # Input action name (e.g. "jump", "ui_accept")
@export var duration: float = 3.0  # Time to wait if no action required
