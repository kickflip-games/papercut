extends TextureProgressBar
class_name XPBar


@onready var xp_manager:XpManager = %XP
@onready var pickup_box:PickupBox = get_node("%PickupBox")
@onready var xp_label:Label = %xplabel


func _ready():
	max_value = xp_manager.max_xp
	value = xp_manager.xp
	pickup_box.picked_up.connect(_update_bar_current_val)
	xp_manager.leveled_up.connect(_update_lvl_txt)
	_update_lvl_txt()


func _update_lvl_txt():
	xp_label.text = str("Level: ", xp_manager.lvl)
	call_deferred("set_value", 0)
	call_deferred("set", "max_value", xp_manager.max_xp)	

func _update_bar_current_val(__):
	call_deferred("set_value", xp_manager.xp)
	
