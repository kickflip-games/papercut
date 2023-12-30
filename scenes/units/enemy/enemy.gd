extends CharacterBody2D
class_name Enemy


@export var speed_mean:int = 50
@export var speed_var:float = 20
@export var health:float = 2
@export var attack_distance:float = 30
@export var knockback_recovery = 3.5 # sec

var knockback:Vector2 = Vector2.ZERO



@export var experience = 1
@export var enemy_damage = 1
@export var NavType:Constants.NaviationType

@onready var speed:float = randfn(speed_mean, speed_var)
@onready var health_manager:Health = $Health
@onready var hurt_box:TakeDamageBox = $TakeDamageBox
@onready var Player:Node2D =  get_tree().get_first_node_in_group("Player")
@onready var PlayerFound:bool = Player!=null
@onready var navigation = $Navigation
@onready var vis_notifier = $VisibleOnScreenNotifier2D
@onready var sprite = $Sprite2D



var xp_drop:PackedScene = preload("res://scenes/pickups/xp_pickup.tscn")
var dmg_popup = preload("res://scenes/effects/popup/damage_pop_up.tscn")

# Signal to remove from manager 
signal remove_from_array(enemy:Enemy)


func _ready():
	hurt_box.take_damage.connect(_on_take_damage)
	health_manager.set_health(health)
	health_manager.Die.connect(_on_death)
	vis_notifier.screen_entered.connect(_show_sprite)
	vis_notifier.screen_exited.connect(_hide_sprite)


func _on_take_damage(dmg:float, dir:Vector2, knkback_amt:float):
	var player_dir = Player.global_position - global_position
	player_dir = player_dir.normalized()
	knockback = player_dir * -knkback_amt
	var generated_popup:DamagePopUp = dmg_popup.instantiate()
	get_tree().get_root().call_deferred("add_child", generated_popup)
	generated_popup.call_deferred("set_values_and_animate", str(dmg), self.global_position, Color.BLACK)
	
	

func _hide_sprite():
	sprite.visible = false
	
func _show_sprite():
	sprite.visible = true


func _draw():
	draw_line(
		global_position,
		global_position + velocity.normalized() * 20,
		Color.GREEN,
	)



func _physics_process(delta):
	var nav_data = navigation.get_target_velocity(velocity, speed)
	
	if NavType == Constants.NaviationType.AGENT:
		var _dir = (nav_data["target"] - global_position).normalized()
		nav_data["velocity"]  = _dir * speed
		velocity = velocity.lerp(_dir*speed, 4 * delta)
	else:
		velocity = nav_data["velocity"] 
	
	
	
	velocity += knockback
	
	
	#if global_position.distance_to(Player.global_position) < attack_distance:
		#velocity = Vector2.ZERO
	move_and_slide()
	if knockback != Vector2.ZERO:
		knockback = lerp(knockback, Vector2.ZERO, 0.1)
		


func _on_death():
	emit_signal("remove_from_array",self)
	var drop = xp_drop.instantiate()
	drop.global_position = self.global_position
	get_tree().get_root().call_deferred("add_child", drop)
	Global.enemy_counter -= 1
	call_deferred("queue_free")
	

