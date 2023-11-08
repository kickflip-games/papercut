extends Weapon

@onready var shoot_point:Marker2D = $Marker2D


var arrow:PackedScene = preload("res://scenes/weapons/arrow.tscn")

@export_range(0.001,50) var shot_arc_lim:float


func _get_rand_angle():
	var angle = randf_range(-shot_arc_lim, shot_arc_lim)
	return deg_to_rad(angle)

func _get_shot_dir():
	var dir = global_position.direction_to(shoot_point.global_position)
	var shot_dir = dir.rotated(_get_rand_angle())
	return shot_dir
	

func shoot():
	
	if not attack_enabled:
		return
	
	var shot_dir = _get_shot_dir()
	var arrow_instance = arrow.instantiate() 
	
	arrow_instance.global_transform = shoot_point.global_transform
	get_tree().get_root().call_deferred("add_child", arrow_instance)
	arrow_instance.speed = speed
	arrow_instance.direction_vector = shot_dir
	cooldown_timer.start(cooldown)
	enable_attack(false)
	


func _physics_process(delta):
	if Input.is_action_pressed("shoot"):
		shoot()


func _draw():
	draw_line(
		Vector2(),
		shoot_point.position,
		Color.GREEN,
		5
	)
	draw_arc(
		Vector2.ZERO,
		position.distance_to(shoot_point.position) * 0.1,
		-deg_to_rad(shot_arc_lim) + PI/2,
		deg_to_rad(shot_arc_lim) + PI/2,
		10,
		Color.GREEN
	)
