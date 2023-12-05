extends Area2D
class_name AttackBox
## attack_box
##
## This 'attacks' any unit that steps in

@export var damage = 1

@onready var collider = $CollisionShape2D
@onready var disable_timer = $DisableTimer


func _ready():
	self.area_entered.connect(_on_area_entered)
	add_to_group("attack")
	disable_timer.timeout.connect(_on_disable_timer_timeout)
	
func _on_area_entered(body:Node2D):
	pass


func temp_disable():
	disable_timer.start(1)
	collider.call_deferred('set', 'disabled', true)

func _on_disable_timer_timeout():
	collider.call_deferred('set', 'disabled', false)



