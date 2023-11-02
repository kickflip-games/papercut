extends Button
class_name Upgrade


var upgrade_info:UpgradeInfo

@onready var lvl_up_ui:LevelUpUi = %LevelUpUi

var mousePresent

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self._on_pressed)
	self.text = 'Click me for an upgrade'


func _on_pressed():
	lvl_up_ui.upgrade_purchased.emit()

