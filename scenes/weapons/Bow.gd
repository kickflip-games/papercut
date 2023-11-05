extends Weapon

@onready var shootPoint:Marker2D = $Marker2D


var arrow:PackedScene = preload("res://scenes/weapons/arrow.tscn")



func shoot():
	
	if not attack_enabled:
		return
	
	var arrow_instance = arrow.instantiate()
	get_tree().get_root().call_deferred("add_child", arrow_instance)
	arrow_instance.global_transform = shootPoint.global_transform
	arrow_instance.direction_vector = global_position.direction_to(shootPoint.global_position)
	cooldown_timer.start(cooldown)
	enable_attack(false)
	


func _physics_process(delta):
	if Input.is_action_pressed("shoot"):
		shoot()


