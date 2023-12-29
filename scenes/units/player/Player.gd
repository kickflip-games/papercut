extends CharacterBody2D
class_name Player


# Publically set attributes
var speed:float = 150
var walk_speed:float = 100
var auto_aim:bool = true

var sprite

@onready var health_manager:Health = $Health
@onready var detection_area:DetectionArea = $DetectionArea
@onready var take_damage_box:TakeDamageBox = %TakeDamageBox
@onready var screen_shake:ScreenShake = $ScreenShake


var is_alive:bool = true

var down_state:bool = true
var right_state:bool = true

func _ready():
	health_manager.Die.connect(_on_death)
	take_damage_box.take_damage.connect(_on_take_damage)
	
	sprite = $Sprite
	
	down_state = true
	right_state = true


func get_inputs():
	var input_mouse = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	var input_keyboard = Input.get_vector("left", "right", "up", "down").normalized()
	
	if input_mouse.length() > 0:
		return input_mouse
		
	return input_keyboard


func _physics_process(delta):
	var _current_speed = speed
#	if Input.is_action_pressed("shoot"):
#		_current_speed = walk_speed
	velocity = get_inputs() * _current_speed
	
	if Input.is_action_pressed("ui_up"):
		down_state = false
	elif Input.is_action_pressed("ui_down"):
		down_state = true
		
	if Input.is_action_pressed("ui_right"):
		right_state = true
	elif Input.is_action_just_pressed("ui_left"):
		right_state = false
	
	if (down_state == true) && (right_state == false):
		sprite.texture = load("res://assets/bla_assets/protagonist_downleft.png")
		
	elif (down_state == true) && (right_state == true):
		sprite.texture = load("res://assets/bla_assets/protagonist.png")
		
	elif (down_state == false) && (right_state == false):
		sprite.texture = load("res://assets/bla_assets/protagonist-upleft.png")
		
	elif (down_state == false) && (right_state == true):
		sprite.texture = load("res://assets/bla_assets/protagonist-upright.png")
		
	if is_alive:
		move_and_slide()




func _on_death():
	is_alive = false
	Log.debug("DEAD")


func _on_take_damage(dmg:float, dir:Vector2, knkback_amt:float):
	screen_shake.apply_noise_shake()
