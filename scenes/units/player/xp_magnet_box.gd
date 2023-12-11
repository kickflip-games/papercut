extends Area2D
class_name XpMagnetBox

const MAX_RADIUS = 10000
const MIN_RADIUS = 50

@onready var collider = $CollisionShape2D

var pickup_radius:float:
	set(new_radius):
		pickup_radius = clamp(new_radius, MIN_RADIUS, MAX_RADIUS)
		collider.shape.radius = pickup_radius


func _ready():
	self.area_entered.connect(_on_area_entered)
	pickup_radius = MIN_RADIUS
	

func _on_area_entered(pickup):
	if pickup is XpPickup:
		pickup.target = self
