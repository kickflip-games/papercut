extends Pickup
class_name XpPickup





@export var experience:float = 40

#var spr_green = preload("res://Textures/Items/Gems/Gem_green.png")
#var spr_blue= preload("res://Textures/Items/Gems/Gem_blue.png")
#var spr_red = preload("res://Textures/Items/Gems/Gem_red.png")
#
var target:Node2D = null
#var speed = 10
var speed = 5


var distance_to_target = null:
	get:
		return global_position.distance_to(target.global_position) 



func _ready():
	type = Constants.PickupTypes.XP




#@onready var sound = $snd_collected

#func _ready():
#	if experience < 5:
#		return
#	elif experience < 25:
#		sprite.texture = spr_blue
#	else:
#		sprite.texture = spr_red



func _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2*delta
		if distance_to_target < 10:
			self.cleanup(0.1)
		
		

func collect()->float:
#	sound.play()
#	collision.call_deferred("set","disabled",true)
#	sprite.visible = falses
	
	return experience


func _on_snd_collected_finished():
	queue_free()
