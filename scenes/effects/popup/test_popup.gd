extends Node2D

# Reference to the scene you want to generate
var popup = preload("res://scenes/effects/popup/damage_pop_up.tscn")

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if Input.is_action_pressed("shoot"):  # Check for left mouse button click
			# Get the mouse click position in the world coordinates
			var click_position = get_global_mouse_position()
			var c = Color(randf(), randf(), randf(), 1.0)
			# Instance the scene at the mouse click location
			var generated_popup:DamagePopUp = popup.instantiate()
			
			generated_popup.call_deferred("set_values_and_animate", "100", click_position, c)
			

			# Add the generated scene to the current scene
			add_child(generated_popup)
