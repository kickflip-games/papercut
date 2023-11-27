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

	for i in range(max_options):
		var btn:UpgradeButton = upgrade_button.instantiate()
		btn.upgrade = upgrade_options[i]
		
		#set texture of buttons
		var texture = load("res://assets/sid_assets/lvlup_btn" + str(i+1) + ".png")
		
		btn.texture_normal = texture
		
		btn.pressed.connect(trigger_upgrade_purchased_signal)
		table.add_child(btn)
		
	get_tree().paused = true



func trigger_upgrade_purchased_signal():
	upgrade_purchased.emit()


