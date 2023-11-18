extends Weapon
class_name Axe

var target = Vector2.ZERO
var target_array:Array = []
var paths = 2 # number of targets to chain-in
var direction:Vector2 = Vector2.ZERO
@onready var reset_pos = position


@onready var change_direction_timer:Timer  = get_node("ChangeDirectionTimer")


func _ready():
	super()
	change_direction_timer.timeout.connect(_on_change_direction_timeout)
	


func add_paths():
	emit_signal("remove_from_array",self)
	target_array.clear()
	target_array = detection_area.get_random_targets(paths)
	enable_attack(true)
	process_path()
	target = target_array[0]

func process_path():
	direction = global_position.direction_to(target)
	change_direction_timer.start()
	var tween = create_tween()
	var new_rotation_degrees = direction.angle() + deg_to_rad(135)
	tween.tween_property(self,"rotation",new_rotation_degrees,0.25).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

#func enable_attack(atk = true):
#	if atk:
#		collision.call_deferred("set","disabled",false)
##		sprite.texture = spr_jav_atk
#	else:
#		collision.call_deferred("set","disabled",true)
##		sprite.texture = spr_jav_reg

func _cooldown_complete_custom_functionality():
	add_paths()

func _on_attack_collision(body:Node2D):
	print("Attacked!")
	

func _on_change_direction_timeout():
	if target_array.size() > 0:
		target_array.remove_at(0)
		if target_array.size() > 0:
			target = target_array[0]
			process_path()
#			snd_attack.play()
			emit_signal("remove_from_array",self)
		else:
			change_direction_timer.stop()
			cooldown_timer.start()
	else:
		change_direction_timer.stop()
		cooldown_timer.start()

func _physics_process(delta):
	position += direction*speed*delta


func _on_reset_pos_timer_timeout():
	var choose_direction = randi() % 4
	reset_pos = player.global_position
	match choose_direction:
		0:
			reset_pos.x += 50
		1:
			reset_pos.x -= 50
		2:
			reset_pos.y += 50
		3:
			reset_pos.y -= 50
