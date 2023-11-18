extends Area2D
class_name Navigation




@onready var navType:Constants.NaviationType = Constants.NaviationType.BOID
@onready var Player:Node2D =  get_tree().get_first_node_in_group("Player")
@onready var view_collider:CollisionShape2D = $ViewCollider


@export var follow_magnitude: = 0.3
@export var cohesion_magnitude: = 0.001
@export var algin_magnitude: = 0.001
@export var avoid_magnitude: = 0.3
@export var avoid_distance: = 45.0
@export var kockback_force = 0.5



var _max_speed:float = 200
var _flock: Array[Node2D] = []
var _current_v:Vector2




var mypos:Vector2:
	get:
		return global_position

var target_pos:
	get:
		if Player!=null:
			return Player.global_position
		else:
			return get_global_mouse_position()


func _ready():
	
	if navType == Constants.NaviationType.BOID:
		area_entered.connect(_on_neighbor_entered)
		area_exited.connect(_on_neighbor_exited)
	

func kockback(dmg:float, dir:Vector2):
	return 


func _on_neighbor_entered(body: Node2D):
	if self != body:
		_flock.append(body)


func _on_neighbor_exited(body: Node2D):
	_flock.erase(body)


func get_target_velocity(current_v:Vector2, max_speed:float):
	_max_speed = max_speed
	_current_v = current_v
	return Dictionary({
		'velocity': _new_vel(current_v),
		'target':target_pos
	})
	

func _get_force_to_target():
	return mypos.direction_to(target_pos) * _max_speed * follow_magnitude
	

func _new_vel(current_v:Vector2)->Vector2:
	var follow_force = _get_force_to_target()
	var flock_forces = _get_flock_vectors(_flock)
	var accel =  follow_force + flock_forces[0] + flock_forces[1] + flock_forces[2]
	return (current_v + accel).limit_length(_max_speed)

	

func _get_flock_vectors(flock: Array):
	# Gets the 
	var center_vector = Vector2()
	var flock_center = Vector2()
	var align_vector = Vector2()
	var avoid_vector = Vector2()
	
	for f in flock:
		var neighbor_pos = f.global_position

		align_vector += f._current_v
		flock_center += neighbor_pos

		var d = mypos.distance_to(neighbor_pos)
		if d > 0 and d < avoid_distance:
			avoid_vector -= (neighbor_pos - mypos).normalized() * (avoid_distance / d * _max_speed)
	
	var flock_size = flock.size()
	if not flock.is_empty():
		align_vector /= flock_size
		flock_center /= flock_size

		var center_dir = mypos.direction_to(flock_center)
		var center_speed = _max_speed * (mypos.distance_to(flock_center) / view_collider.get_shape().radius)
		center_vector = center_dir * center_speed

	return [
		center_vector * cohesion_magnitude, 
		align_vector * algin_magnitude,
		avoid_vector * avoid_magnitude
		]

