extends Panel

@onready var player:Player = get_tree().get_first_node_in_group("Player")

var can_restart:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player.get_node("Health").Die.connect(_show_gameover)
	self.visible = false


func _show_gameover():
	self.visible = true
	can_restart = true
	
	
func _input(event: InputEvent) -> void:
	if can_restart and event.is_action_pressed("Restart"):
		get_tree().reload_current_scene()

