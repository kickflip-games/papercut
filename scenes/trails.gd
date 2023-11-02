extends Line2D
class_name Trails
 
var queue : Array
@export var MAX_LENGTH : int = 10
@export var follow_target:Node2D = null

func _process(_delta):
	var pos = _get_position()
	queue.push_front(pos)
	if queue.size() > MAX_LENGTH:
		queue.pop_back()
	clear_points()

	for point in queue:
		add_point(point)

func _get_position():
	if follow_target != null:
		return follow_target.global_position
	return get_global_mouse_position()
	
#
#

