extends Node2D


const LONG_WAIT = 10


@export var cooldownTime:float = 0.3:
	set(new_val):
		return clamp(new_val, 0.001, LONG_WAIT)
		
@export var arrowSpeed = 500
@onready var cooldownTimer = $CooldownTimer


@onready var shootPoint:Marker2D = $Marker2D

var shootEnabled: bool = true
var arrow:PackedScene = preload("res://scenes/weapons/arrow.tscn")


func _ready():
	cooldownTimer.timeout.connect(_enable_shooting)
	update_cooldown_duration()



func update_cooldown_duration():
	cooldownTimer.wait_time = cooldownTime

func _enable_shooting():
	shootEnabled = true

func shoot():
	if not shootEnabled:
		return
	
	var arrow_instance = arrow.instantiate() as RigidBody2D
	get_tree().get_root().call_deferred("add_child", arrow_instance)
	arrow_instance.transform = shootPoint.global_transform
	arrow_instance.linear_velocity = arrowSpeed * global_transform.y
	arrow_instance.apply_impulse(
		Vector2(),
		Vector2(arrowSpeed, 0)
	)
	cooldownTimer.start(cooldownTime)
	shootEnabled = false
	


func _physics_process(delta):
	if Input.is_action_pressed("shoot"):
		shoot()


