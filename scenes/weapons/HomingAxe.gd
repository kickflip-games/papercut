extends Weapon
class_name Axe

enum AXE_STATES{
	ATTACKING,
	IDLE,
	RESETING
}


var _state:AXE_STATES = AXE_STATES.IDLE
var target = Vector2.ZERO
var target_array:Array = []
var paths = 2 # number of targets to chain-in
var direction:Vector2 = Vector2.ZERO
var rotation_speed:float = 15
@onready var reseting:bool = true
@onready var reset_timer:Timer = get_node("ResetTimer")
@onready var change_direction_timer:Timer  = get_node("ChangeDirectionTimer")
@onready var sprite:Sprite2D = get_node("Sprite2D")




# TODO: Make the axe sprite rotate on throw
# TODO: make the axe come back + cooldown after it goes to N paths

func _change_state(new_state):
	var keys = AXE_STATES.keys()
	print("From ", keys[_state], " to ", keys[new_state])
	_state = new_state


func _ready():
	super()
	_change_state(AXE_STATES.IDLE)
	change_direction_timer.timeout.connect(_on_change_direction_timeout)
	reset_timer.timeout.connect(_on_reset_pos_timer_timeout)


func add_paths():
	_change_state(AXE_STATES.ATTACKING)
	emit_signal("remove_from_array",self)
	target_array.clear()
	target_array = detection_area.get_random_targets(paths)
	enable_attack(true)
	print("Targets set: ", target_array)
	if target_array.size()> 0:
		target = target_array[0]
		process_path()



func process_path():
	direction = global_position.direction_to(target)
	change_direction_timer.start()
	var tween = create_tween()
	var new_rotation_degrees = direction.angle() + deg_to_rad(135)
	tween.tween_property(self,"rotation",new_rotation_degrees,0.25).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	reseting = false



func _cooldown_complete_custom_functionality():
	print("COOLDOWN completed")
	reset_timer.stop()
	cooldown_timer.stop()
	add_paths()
	

func _on_attack_collision(body:Node2D):
	pass
	

func _on_change_direction_timeout():
	print("Change direction triggered")
	if target_array.size() > 0:
		target_array.remove_at(0)
		if target_array.size() > 0:
			target = target_array[0]
			process_path()
			emit_signal("remove_from_array",self)
		else:
			_start_reset()
	else:
		_start_reset()
		
		
func _start_reset():
	_change_state(AXE_STATES.RESETING)
	reseting = true
	change_direction_timer.stop()
	reset_timer.start()


func _on_reset_pos_timer_timeout():
	print("RESET completed")
	reseting = true
	cooldown_timer.start()


func _physics_process(delta):
	if reseting:
		var distance_from_player = global_position.distance_to(player.global_position)
		if  distance_from_player > 15:
			sprite.rotation = 0
			direction = global_position.direction_to(player.global_position)
			position += direction*speed*delta*2
	else:	
		sprite.rotation += rotation_speed * delta
		position += direction*speed*delta
		
	



