extends Panel
class_name LevelUpUi

# pauses game
# bring up upgrades menu
# on click resumes game

@onready var label = $labelLvlUp
@onready var table = %UpgradesTable

@onready var xp_manager:XpManager = get_tree().get_first_node_in_group("Player").get_node("XP")
@onready var inventory:Inventory = get_tree().get_first_node_in_group("Player").get_node("Inventory")

@onready var upgrade_button:PackedScene = preload("res://scenes/upgrades/upgrade_button.tscn")
@export var upgrade_options:Array[UpgradeInfo] = []



@export var max_options = 3


signal upgrade_purchased

func hard_code_upgrade_options():
	var upgrade_option_1: UpgradeInfo = UpgradeInfo.new()
	var upgrade_option_2: UpgradeInfo = UpgradeInfo.new()
	var upgrade_option_3: UpgradeInfo = UpgradeInfo.new()
	
	print(upgrade_option_1)
	
	upgrade_option_1.name = "Pencil"
	upgrade_option_1.description = "Shoots a pencil"
	upgrade_option_1.weapon_type = 1
	
	upgrade_option_2.name = "Ruler"
	upgrade_option_2.description = "A ruler like sword that scales"
	upgrade_option_2.weapon_type = 3
	
	upgrade_option_3.name = "Axe"
	upgrade_option_3.description = "An axe thing"
	upgrade_option_3.weapon_type = 4
	
	upgrade_options[0] = upgrade_option_1
	upgrade_options[1] = upgrade_option_2
	upgrade_options[2] = upgrade_option_3
	
	print("PRINTING UPGRADE OPTIONS INDEX 2, WHICH SHOULD HAVE WEAPON_TYPE = 4")
	print(upgrade_options[2])
	


func _ready():
	xp_manager.leveled_up.connect(_show_ui)
	self.visible = false
	upgrade_purchased.connect(_upgrade_purchased)
	
	
func _upgrade_purchased():
	self.visible = false
	print("Upgrade purchased")
	get_tree().paused = false


func _show_ui():
	print("Showing lvl up UI")
	# PLAY LVL SFX HERE AS EVERYTHING ELSE PASUED
	
	label.text = str("Level: ", xp_manager.lvl)
	var tween = self.create_tween()
	tween.tween_property(
		self,
		"position", 
		Vector2(323,65),0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	self.visible = true
#	var options = 0
	for c in table.get_children():
		table.remove_child(c)
		c.queue_free()
		
	
	hard_code_upgrade_options()

	for i in range(max_options):
		var btn:UpgradeButton = upgrade_button.instantiate()
		btn.upgrade = upgrade_options[i]
		
		print("TESTESTRERE")
		print(upgrade_options[i].weapon_type)
		
		#set texture of buttons
		var texture = load("res://assets/sid_assets/lvlup_btn" + str(i+1) + ".png")
		
		btn.texture_normal = texture
		
		btn.pressed.connect(trigger_upgrade_purchased_signal)
		table.add_child(btn)
		
	get_tree().paused = true



func trigger_upgrade_purchased_signal():
	upgrade_purchased.emit()


