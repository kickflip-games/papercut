extends Area2D
class_name DetectionArea



func get_nearest_target()->Vector2:
	var target = get_global_mouse_position()
	var interactive_objects = self.get_overlapping_areas()
	var minimum_distance = INF
	var current_position = global_transform.origin
	for object in interactive_objects:
		# Using Vector2.distance_squared_to() for distance comparisons also improves performance.
		# That's because calculating a regular distance involves a heavy square root operation.
		var distance = object.global_transform.origin.distance_squared_to(current_position)
		if distance < minimum_distance:
			minimum_distance = distance
			target = object.global_position
	return target
