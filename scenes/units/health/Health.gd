extends Node2D
class_name Health

@export var MAX_HEALTH := 100.0

@onready var takeDamageBox:TakeDamageBox = get_node("%TakeDamageBox")

signal Die()

var alive:bool = true

var max_hp = MAX_HEALTH
var _hp: float = MAX_HEALTH:
	set(new_value):
		_hp = clamp(new_value, 0, MAX_HEALTH)


func set_health(hp):
	max_hp = hp
	_hp = hp

func _ready():
	takeDamageBox.take_damage.connect(_on_take_damage)


func _on_take_damage(dmg:float, dir:Vector2):
	_hp -= dmg
	if _hp <= 0 && alive:
		alive = false
		Die.emit()
