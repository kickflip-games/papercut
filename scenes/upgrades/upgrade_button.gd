extends Button
class_name UpgradeButton


var upgrade:UpgradeInfo
@onready var inventory:Inventory = get_tree().get_first_node_in_group("Player").get_node("Inventory")
@onready var lvl_up_ui:LevelUpUi = get_node("../LevelUpUI")


# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self._on_pressed)
	self.text = upgrade.name
	


func _on_pressed():
	lvl_up_ui.upgrade_purchased.emit(upgrade.weapon_type)
	

