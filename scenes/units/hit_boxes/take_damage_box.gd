extends Area2D
class_name TakeDamageBox
## take-damage box
##
## this registers if the unit is taking-damge


@export var boxType:Constants.TakeDamageType = Constants.TakeDamageType.COOLDOWN
@onready var collider = $CollisionShape2D
@onready var disable_timer = $DisableTimer

signal take_damage(damage_amt:float, damage_dir:Vector2)

var can_take_damage:bool = true

func _ready():
	self.area_entered.connect(_on_area_entered)
	disable_timer.timeout.connect(_on_disable_timer_timeout)
	
func _on_area_entered(area:Area2D):
	if area is AttackBox:
		match boxType:
			Constants.TakeDamageType.HIT_ONCE: # HitOnce
				pass
			Constants.TakeDamageType.COOLDOWN: # Cooldown
				collider.call_deferred("set", "disabled", true)
				disable_timer.start(1)
			Constants.TakeDamageType.DISABLE_BOX: # Disable box
				area.temp_disable()
		if can_take_damage:
			var dir:Vector2 = area.global_position - global_position
			take_damage.emit(area.damage, dir)
	
	
func _on_disable_timer_timeout():
	# when the disbale timer completes, enable the collider once again
	collider.call_deferred("set", "disabled", false)
	can_take_damage = true



