extends TextureProgressBar
class_name HealthBar

# Attributes attached to node
@onready var health:Health = get_node("%Health")
@onready var takeDamageBox:TakeDamageBox = get_node("%TakeDamageBox")


func _ready():
	max_value = health.MAX_HEALTH
	value = health._hp
	takeDamageBox.take_damage.connect(_update)


func _update(_dmg, _dir):
	call_deferred("set_value", health._hp)

