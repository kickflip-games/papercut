extends Weapon

@export var rotation_amount = 360
@export var swing_duration = 2 # Adjust the duration as needed
@onready var trail:Trail2d = $trail_fx/Trail2D


var MAX_SIZE = 2
var MIN_SIZE = 1
var is_swinging = false

func disable_attack_on_tween_end():
	enable_attack(false)
	trail.hide()
	is_swinging = false


func run_tween():
	# increase scale and rotate 180, and scale back down at the end
	is_swinging = true
	
	var tween = get_tree().create_tween()
	var r = (int(rotation_degrees) + rotation_amount) 
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "rotation_degrees", r, swing_duration)
	var scale_tween = get_tree().create_tween()
	scale_tween.set_trans(Tween.TRANS_LINEAR)
	scale_tween.chain()
	scale_tween.tween_property(self, "scale:y", MAX_SIZE, swing_duration*0.2).set_ease(Tween.EASE_IN)
	scale_tween.tween_property(self, "scale:y", MIN_SIZE, swing_duration*0.2).set_delay(swing_duration*0.2).set_ease(Tween.EASE_IN)
	
	scale_tween.tween_callback(disable_attack_on_tween_end)

	tween.play()
	scale_tween.play()
	

func _on_attack_collision(body:Node2D):
	pass




func swing():
	if not attack_enabled:
		return
	
	if not is_swinging:
		trail.show()
		run_tween()
		cooldown_timer.start(cooldown + swing_duration)


func _physics_process(delta):
	if Input.is_action_pressed("shoot"):
		swing()




 
func set_level(lvl:int):
	# based on lvl, 
	# update cooldown timer
	# update dmg
	# update size 

	match lvl:
		1:
			rotation_amount = 10
			swing_duration = 2
			damage = 1
		2:
			rotation_amount = 90
			swing_duration = 4
			damage = 2
		3:
			rotation_amount = 90
			swing_duration = 2
			damage = 4
		4: 
			rotation_amount = 180
			swing_duration = 2
			damage = 6
		5:
			rotation_amount = 360
			swing_duration = 2
			damage = 8
		6:
			rotation_amount = 720
			swing_duration = 2
			damage = 8
	
	super(lvl)
