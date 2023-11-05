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
var already_hurt_by = []

func _ready():
	self.area_entered.connect(_on_area_entered)
	disable_timer.timeout.connect(_on_disable_timer_timeout)
	
func _on_area_entered(area:Area2D):
	if area is AttackBox:
		match boxType:
			Constants.TakeDamageType.HIT_ONCE: # HitOnce
				handle_hit_once_attacktype(area)
			Constants.TakeDamageType.COOLDOWN: # Cooldown
				handle_cooldown_attacktype(area)
			Constants.TakeDamageType.DISABLE_BOX: # Disable box
				area.temp_disable()
		
		if can_take_damage:
			var dir:Vector2 = area.global_position - global_position
			take_damage.emit(area.damage, dir)
	
	
func _on_disable_timer_timeout():
	# when the disbale timer completes, enable the collider once again
	collider.call_deferred("set", "disabled", false)
	can_take_damage = true



func handle_hit_once_attacktype(attackbox:AttackBox):
	if already_hurt_by.has(attackbox)==false:
		already_hurt_by.append(attackbox)
		if attackbox.has_signal("remove_from_array"):
			if not attackbox.is_connected("remove_from_array",Callable(self,"cleanup_list")):
				attackbox.connect("remove_from_array",Callable(self,"cleanup_list"))
	else:
		return

func handle_cooldown_attacktype(attackbox:AttackBox):
	collider.call_deferred("set", "disabled", true)
	disable_timer.start(1)



func cleanup_list(object):
	if already_hurt_by.has(object):
		already_hurt_by.erase(object)
