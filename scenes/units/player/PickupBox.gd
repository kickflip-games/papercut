extends Area2D
class_name PickupBox
## pickup box
##
## this registers if the unit has walked into a 'pickup'

@onready var collider = $CollisionShape2D


signal picked_up(itm)


func _ready():
	self.area_entered.connect(_on_area_entered)
	

func _on_area_entered(pickup):
	if pickup is Pickup:
		picked_up.emit(pickup)
