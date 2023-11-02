extends Panel
class_name LevelUpUi

# pauses game
# bring up upgrades menu
# on click resumes game

#@onready var upgrade_table = %UpgradeOptions
@onready var label = $labelLvlUp
@onready var xp_manager:XpManager = get_tree().get_first_node_in_group("Player").get_node("XP")

#@export var upgrade_options:Array[UpgradeInfo] = []



@export var max_options = 4


signal upgrade_purchased


func _ready():
	xp_manager.leveled_up.connect(_show_ui)
	self.visible = false
	upgrade_purchased.connect(_upgrade_purchased)
	
	
func _upgrade_purchased():
	self.visible = false
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
#	for i in range(max_options):
#		var option_choice = itemOptions.instantiate()
#		option_choice.item = get_random_item()
#		upgradeOptions.add_child(option_choice)
	get_tree().paused = true


func _on_mouse_enter():
	print("MOUSE ENTERED")
