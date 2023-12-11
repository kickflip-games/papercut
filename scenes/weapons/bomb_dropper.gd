extends Weapon




var bomb:PackedScene = preload("res://scenes/weapons/Bomb.tscn")
var target:Vector2 = Vector2.ZERO

var explosion_size:float = 2
var explosion_lifetime:float = 1


@export var debug:bool = false

func _ready():
	super()
	knockback_amount = 0
	weapon_type = Constants.WeaponType.BOMB_DROPPER
	

func drop():
	var bomb_instance:Bomb = bomb.instantiate() 
	bomb_instance.global_position = global_position
	get_tree().get_root().call_deferred("add_child", bomb_instance)
	bomb_instance.speed = speed
	bomb_instance.explosion_size = explosion_size
	bomb_instance.lifetime = explosion_lifetime
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
			explosion_size = 2
			explosion_lifetime = 1
			cooldown = 1.5
			damage = 1
		2:
			explosion_size = 3
			explosion_lifetime = 1.5
			cooldown = 1.3
			damage = 1
		3:
			explosion_size = 4
			explosion_lifetime = 2
			cooldown = 1.1
			damage = 1
		4: 
			explosion_size = 6
			explosion_lifetime = 2.5
			cooldown = 1.
			damage = 1
		5:
			explosion_size = 8
			explosion_lifetime = 2.5
			cooldown = 1.5
			damage = 1.5
		6:
			explosion_size = 10
			explosion_lifetime = 3
			cooldown = 1.5
			damage = 2
	
	super(lvl)
