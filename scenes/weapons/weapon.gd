extends Area2D
class_name Weapon
# will either shoot projectiles or have a damage area

## ATTACK STATS
var level = 1
var knockback_amount:float = 100
var attack_size:float = 1.0
var cooldown:float = 0.3
var hp:float = 1 # HP for projectiles 
var speed:float = 500
var damage:float = 1
var attack_enabled = true
var lifetime:float = -1 # < 0 means doesnt die due to 'old age'

## MANAGERS
var cooldown_timer:Timer
var lifetime_timer:Timer
var hp_manager:Health
var attack_box:AttackBox
var screen_notifier:VisibleOnScreenNotifier2D
var attack_box_present:bool
var hp_manager_present:bool



## CLEANUP SIGNAL
signal remove_from_array(object)

func _ready():
	set_init_references()
	print("Setup ", get_path(), " : ", cooldown_timer)


func set_init_references():
	print("set_init_refs")
	# A bit hacky but will make inheritance 
	# a bit cleaner and keep 
	var root = String(get_path())
	

	hp_manager = get_node_or_null(root + "/HpManager")
	if hp_manager:
		hp_manager_present = true
		hp_manager.set_health(hp)
		hp_manager.Die.connect(_on_death)

	attack_box = get_node_or_null(root + "/AttackBox")
	if attack_box:
		attack_box_present = true
		attack_box.area_entered.connect(_on_attack_collision)

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

func cleanup():
	print("Cleaning ", self.name)
	emit_signal("remove_from_array",self)
	queue_free()

func _on_screen_exited():
	cleanup()

func _on_death():
	push_error("ON_DEATH NOT IMPLEMENTED")

func _on_attack_collision(sbody:Node2D):
	push_error("ON_ATTACK NOT IMPLEMENTED")


func enable_attack(enable:bool=true):
	attack_enabled = enable
	if !(attack_box_present):
		return
		
	if (enable):
		attack_box.set_deferred("disabled", false)
	else:
		attack_box.set_deferred("disabled", true)



func set_vars(lvl:int):
	# based on lvl, 
	# update cooldown timer
	# update dmg
	# update size 
	
	if hp_manager_present:
		hp_manager.set_health(hp)
	
	
	pass
	
	
func _cooldown_complete():
	enable_attack(true)
	cooldown_timer.stop()
	


func _on_lifetime_over():
	cleanup()
	
