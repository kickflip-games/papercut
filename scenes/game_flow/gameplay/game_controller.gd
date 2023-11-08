extends Node2D

@onready var pause_menu:PauseMenu = $GUI/Paused

#func _process(_delta: float) -> void:
#	if Input.is_action_pressed("ui_accept"):
#		get_tree().change_scene_to_file(Global.SCENE_MAIN_MENU)


func _input(event: InputEvent) -> void:
	if event.is_action_released("pause"):
		call_deferred("_pause")
		
func _pause() -> void:
	pause_menu.pause()
	get_tree().paused = true
