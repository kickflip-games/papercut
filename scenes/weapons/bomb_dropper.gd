extends Weapon




var bomb:PackedScene = preload("res://scenes/weapons/Bomb.tscn")
var target:Vector2 = Vector2.ZERO

@export var debug:bool = false

func _ready():
	super()
	weapon_type = Constants.WeaponType.BOMB_DROPPER
	

func drop():
	var bomb_instance = bomb.instantiate() 
	bomb_instance.global_position = global_position
	get_tree().get_root().call_deferred("add_child", bomb_instance)
	bomb_instance.speed = speed
	cooldown_timer.start(cooldown)
	enable_attack(false)


func _process(delta):
	if attack_enabled:
		if debug:
			global_position = get_viewport().get_mouse_position()
		drop()


 
func set_level(lvl:int):
	# based on lvl, 
	# update cooldown timer
	# update dmg
	# update size 

	match lvl:
		1:
			
			speed = 300
			knockback_amount = 50
			cooldown = 1.5
			damage = 1
		2:
			speed = 500
			knockback_amount = 100
			cooldown = 0.8
			damage = 1
		3:
			speed = 500
			knockback_amount = 100
			
			cooldown = 0.8
			damage = 5
		4: 
			speed = 600
			knockback_amount = 100
			cooldown = 0.5
			damage = 10
		5:
			speed = 600
			knockback_amount = 100
			cooldown = 0.3
			damage = 10
		6:
			speed = 600
			knockback_amount = 100
			cooldown = 0.05
			damage = 10
	
	super(lvl)
