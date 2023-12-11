extends TextureButton
class_name UpgradeButton


var upgrade:UpgradeInfo
@onready var inventory:Inventory = get_tree().get_first_node_in_group("Player").get_node("Inventory")
@onready var label:Label = $Label
@onready var icon:TextureRect = $IconContainer/Icon


func set_upgrade(u:UpgradeInfo):
	self.upgrade = u
	self.pressed.connect(self._on_pressed)
	self.icon.texture = u.icon
	self.label.text = u.name
	#	self.description = upgrade.description 
	# 	TODO: show level of upgrade item
	# self.level = current_item_level + 1  

func _ready():
	print("BUTTON READY")


func _on_pressed():
	inventory.upgrade_weapon(upgrade.weapon_type)
	


