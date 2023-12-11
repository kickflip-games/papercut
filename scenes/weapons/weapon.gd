extends Area2D
class_name Weapon
# will either shoot projectiles or have a damage area



## ATTACK STATS
var level = 1
@export var weapon_type:Constants.WeaponType
@export var knockback_amount:float = 100
@export var attack_size:float = 1.0
@export var cooldown:float = 0.3
@export var hp:float = 1 # HP for projectiles 
@export var speed:float = 500
@export var damage:float = 1
@export var attack_enabled = true
@export var lifetime:float = -1 # < 0 means doesnt die due to 'old age'

## MANAGERS
var cooldown_timer:Timer
var lifetime_timer:Timer
var hp_manager:Health
var attack_box:AttackBox
var screen_notifier:VisibleOnScreenNotifier2D
var detection_area:DetectionArea
var detection_area_present:bool
var attack_box_present:bool
var hp_manager_present:bool
var player:Player



## CLEANUP SIGNAL
signal remove_from_array(object)


func _ready():
	set_init_references()
	set_level(1)


func _input(event):
	if event.is_action_pressed("click") && Global.DEBUG_MODE:
		increment_lvl()

func set_init_references():
	# A bit hacky but will make inheritance 
	# a bit cleaner and keep 
	var root = String(get_path())
	
	detection_area =  get_node_or_null("../../DetectionArea")
	if detection_area:
		detection_area_present = true
	
	hp_manager = get_node_or_null(root + "/HpManager")
	if hp_manager:
		hp_manager_present = true
		hp_manager.set_health(hp)
		hp_manager.Die.connect(_on_death)

	attack_box = get_node_or_null(root + "/AttackBox")
	if attack_box:
		attack_box_present = true
		attack_box.damage = damage
		attack_box.knockback_amount = knockback_amount
		attack_box.area_entered.connect(_on_attack_collision)
		call_deferred("enable_attack", false)

	screen_notifier = get_node_or_null(root + "/VisibleOnScreenNotifier2D")
	if screen_notifier:
		screen_notifier.screen_exited.connect(_on_screen_exited)

	cooldown_timer = get_node_or_null(root + "/CooldownTimer")
	if cooldown_timer:
		cooldown_timer.timeout.connect(_cooldown_complete)
		cooldown_timer.wait_time = cooldown

	lifetime_timer = get_node_or_null(root + "/LifetimeTimer")
	if lifetime_timer and lifetime > 0:
		lifetime_timer.timeout.connect(cleanup)
		lifetime_timer.wait_time = lifetime
		lifetime_timer.start(lifetime)
		
		
	player = get_tree().get_first_node_in_group("Player")
		
		
func set_vars():
	if hp_manager_present:
		hp_manager.set_health(hp)
	if cooldown_timer:
		cooldown_timer.wait_time = cooldown
	
		
	
func cleanup():
	emit_signal("remove_from_array",self)
	enable_attack(false)
	queue_free()

func _on_screen_exited():
	cleanup()

func _on_death():
	push_error("ON_DEATH NOT IMPLEMENTED")

func _on_attack_collision(body:Node2D):
	push_error("ON_ATTACK NOT IMPLEMENTED")


func unlock_weapon():
	show()
	set_process_input(true)
	set_process(true)
	set_physics_process(true)
	_cooldown_complete()
	
	

func enable_attack(enable:bool=true):
	attack_enabled = enable
	if !(attack_box_present):
		return
		
	if (enable):
		attack_box.call_deferred('set_disabled', false)
		attack_box.scale = Vector2.ONE 
		attack_box.damage = damage
		attack_box.knockback_amount = knockback_amount
		Log.info("ENABLING attack for %s" %name)
	else:
		attack_box.call_deferred('set_disabled', true)
		attack_box.scale = Vector2.ZERO
		attack_box.damage = 0
		Log.info("DISABLING attack for %s" %name)



func set_level(lvl:int):
	# based on lvl, 
	# update cooldown timer
	# update dmg
	# update size 
	
	level = clamp(lvl, 1, 5)
	set_vars()	
	
	
func increment_lvl():
	set_level(level + 1)
	
func _cooldown_complete():
	Log.info("Cooldown complete! ")
	enable_attack(true)
	cooldown_timer.stop()
	_cooldown_complete_custom_functionality()
	
func _cooldown_complete_custom_functionality():
	pass
	


func _on_lifetime_over():
	cleanup()
	
