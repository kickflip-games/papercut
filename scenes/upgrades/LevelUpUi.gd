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

var upgrade_options:Array[UpgradeInfo]
var upgrade_info_path : String = "res://scenes/upgrades/upgrade_cards/"


@export var max_options = 3




signal upgrade_purchased



func _ready():
	load_upgrade_options()
	xp_manager.leveled_up.connect(_show_ui)
	self.visible = false
	upgrade_purchased.connect(_upgrade_purchased)
	
	
func _upgrade_purchased():
	self.visible = false
	Log.debug("Upgrade purchased")
	get_tree().paused = false


func _get_rand_option_idxes(n_options:int)->Array:
	var option_idxes = []
	for i in range(len(upgrade_options)):
		option_idxes.append(i)
	option_idxes.shuffle()
	return option_idxes.slice(0, 3)

func _show_ui():
	Log.info("Showing lvl up UI")
	# PLAY LVL SFX HERE AS EVERYTHING ELSE PASUED	
	label.text = str("Level: ", xp_manager.lvl)

	# clear past options 
	for c in table.get_children():
		table.remove_child(c)
		c.queue_free()
	
	# get new options
	var random_options = _get_rand_option_idxes(3)
	for i in range(max_options):
		var upgrd:UpgradeInfo = upgrade_options[random_options[i]]
		var btn:UpgradeButton = upgrade_button.instantiate()
		btn.upgrade = upgrd
		btn.pressed.connect(trigger_upgrade_purchased_signal)
		table.add_child(btn)
		Log.info("Adding %s as upgrade option"%upgrd.name)
		
	# play anim to show options
	var tween = self.create_tween()
	tween.tween_property(
		self,
		"position", 
		Vector2(323,65),0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	self.visible = true
	get_tree().paused = true



func trigger_upgrade_purchased_signal():
	upgrade_purchased.emit()


func load_upgrade_options() -> void:
	var dir = DirAccess.open(upgrade_info_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			# Check if the file has the .tres extension
			if file_name.get_extension() == "tres":
				var resource_path:String = upgrade_info_path + file_name
				var resource:UpgradeInfo = ResourceLoader.load(resource_path)
				if resource != null:
					upgrade_options.append(resource)
				else:
					print("Failed to load resource:", resource_path)

			file_name = dir.get_next()

	Log.debug("Loaded %d upgrde options" % len(upgrade_options))
