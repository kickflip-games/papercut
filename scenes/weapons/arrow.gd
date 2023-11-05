extends Weapon


var direction_vector:Vector2



func _on_death():
	cleanup()

func _on_attack_collision(body:Node2D):
	attack_box.disconnect("area_entered", _on_attack_collision)
#	call_deferred("attach_to_new_body", body)
	
#	await get_tree().create_timer(5).timeout
	cleanup()
	



func _physics_process(delta):
	position += direction_vector*speed*delta


