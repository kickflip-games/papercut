extends Weapon
class_name Arrow




var direction_vector:Vector2:
	set(d):
		direction_vector = d
		var point_at:Vector2 = position + direction_vector*speed*0.1
		self.look_at(point_at + Vector2.RIGHT)
		


func _ready():
	super()
	call_deferred("enable_attack", true)

func _on_death():
	cleanup()

func _on_attack_collision(body:Node2D):
	attack_box.disconnect("area_entered", _on_attack_collision)
#	call_deferred("attach_to_new_body", body)
	
#	await get_tree().create_timer(5).timeout
	cleanup()
	

func _physics_process(delta):
	position += direction_vector*speed*delta

func _draw():
	draw_line(Vector2.ZERO, direction_vector, Color.AQUAMARINE)
