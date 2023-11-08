extends CharacterBody2D
class_name Player


# Publically set attributes
@export var speed:float = 200
@export var walk_speed:float = 100
@export var auto_aim:bool = true

@onready var health_manager:Health = $Health
@onready var detection_area:DetectionArea = $DetectionArea
@onready var take_damage_box:TakeDamageBox = %TakeDamageBox
@onready var screen_shake:ScreenShake = $ScreenShake


var is_alive:bool = true

func _ready():
	health_manager.Die.connect(_on_death)
	take_damage_box.take_damage.connect(_on_take_damage)


func get_inputs():
	var input = Input.get_vector("left", "right", "up", "down")
	return input.normalized()


func _physics_process(delta):
	var _current_speed = speed
	if Input.is_action_pressed("shoot"):
		_current_speed = walk_speed
	velocity = get_inputs() * _current_speed
	if is_alive:
		move_and_slide()
		look_at(detection_area.get_nearest_target())
	



func _on_death():
	is_alive = false
	print("DEAD")


func _on_take_damage(dmg, dir):
	screen_shake.apply_noise_shake()
