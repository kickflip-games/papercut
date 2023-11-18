extends Area2D
class_name DetectionArea


var nearby_objects:Array[Area2D] = []

var num_frames_to_perform_check = 20
var frame_counter = 0

func _process(delta: float) -> void:
	frame_counter += 1
	if frame_counter % num_frames_to_perform_check == 0:
		set_nearby_objects()
		frame_counter = 0

# Function to set the array
func set_nearby_objects():
	nearby_objects = self.get_overlapping_areas()
#	for obj in nearby_objects:
#		if obj.has_signal("remove_from_array"):
#			if not obj.is_connected("remove_from_array",Callable(self,"cleanup_list")):
#				obj.connect("remove_from_array",Callable(self,"cleanup_list"))



func get_nearest_target()->Vector2:
	set_nearby_objects()
	var target = get_global_mouse_position()
	var minimum_distance = INF
	var current_position = global_transform.origin
	for object in nearby_objects:
		if object:
			# Using Vector2.distance_squared_to() for distance comparisons also improves performance.
			# That's because calculating a regular distance involves a heavy square root operation.
			var distance = object.global_transform.origin.distance_squared_to(current_position)
			if distance < minimum_distance:
				minimum_distance = distance
				target = object.global_position
	return target


func get_random_targets(n:int)->Array:
	# get list of n nearest objects 
	var targets = []
	var max_n = nearby_objects.size()
	n = clamp(n, 0, max_n)
	
	if n > 0:
		var indicies:Array = []
		indicies.resize(max_n)
		indicies.fill(0)
		for i in range(max_n):
			indicies[i] = i
		indicies.shuffle()
		indicies.resize(n)
		for index in indicies:
			targets.append(nearby_objects[index].global_position)

		return targets
	
	return []


#
#
#func cleanup_list(object):
#	if nearby_objects.has(object):
#		nearby_objects.erase(object)
