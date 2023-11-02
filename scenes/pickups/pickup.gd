extends Area2D
class_name Pickup
# PICKUP
#
# This has a 2D collider on the 'pickup' layer
# this will be hold some information on the pickup type


var type: Constants.PickupTypes

@onready var collider:CollisionShape2D = $CollisionShape2D
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D



func cleanup(wait_for_s:float=0.2):
	collision.call_deferred("set","disabled",true)
	sprite.visible = false
	var timer := Timer.new()
	add_child(timer)
	timer.timeout.connect(queue_free)
	timer.set_wait_time(1)
	timer.start()
	queue_free()
	
	

