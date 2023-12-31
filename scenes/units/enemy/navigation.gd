extends Node2D
class_name Navigation



@export var navType:Constants.NaviationType

@onready var _boid:NavigationBoids = $NavigationBoids
@onready var _agent:NavigationAgent = $NavigationAgent2D
var _nav = null

func _ready():
	if navType == Constants.NaviationType.BOID:
		_nav = _boid
		remove_child(_agent)
	elif navType == Constants.NaviationType.AGENT:
		_nav = _agent
		remove_child(_boid)
	


func get_target_velocity(current_v:Vector2, max_speed:float):
	return _nav.get_target_velocity(current_v, max_speed)
	
