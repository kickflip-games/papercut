extends TextureButton
class_name UpgradeButton


var upgrade:UpgradeInfo
@onready var inventory:Inventory = get_tree().get_first_node_in_group("Player").get_node("Inventory")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self._on_pressed)
#	self.text = upgrade.name
#	self.description = upgrade.description 
# 	TODO: show level of upgrade item
	# self.level = current_item_level + 1  
	self.texture_normal = upgrade.icon


func _on_pressed():
	inventory.upgrade_weapon(upgrade.weapon_type)
	


