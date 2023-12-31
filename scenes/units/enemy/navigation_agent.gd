extends NavigationAgent2D
class_name NavigationAgent




@onready var Player:Node2D =  get_tree().get_first_node_in_group("Player")
@onready var timer:Timer = $Timer


var _max_speed:float = 200
var _current_v:Vector2

var _new_target_pos:
	get:
		if Player!=null:
			return Player.global_position
		else:
			return Vector2.ZERO


func _ready():
	timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout():
	target_position = _new_target_pos



func get_target_velocity(current_v:Vector2, max_speed:float):
	var target = get_next_path_position()
	return Dictionary({
		'velocity': Vector2.ZERO,
		'target':target
	})
	
	

