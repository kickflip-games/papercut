extends Control
class_name PauseMenu

var sfx


func _ready():
	sfx = get_node_or_null("../SelectSfx")

func _input(event: InputEvent) -> void:
	if event.is_action_released("pause"):
		call_deferred("_resume")

func _resume() -> void:
	hide()
	get_parent().get_tree().paused = false

func pause() -> void:
	if sfx:
		Sound.play_sfx(sfx)
	show()
	$PauseOptions.focus()
