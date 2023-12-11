extends Node2D
class_name XpManager
# XP Manager
#
# 1) Pulls in pickups
# 2) Keeps track of current XP
# 3) Decides when to send the "level up" signal
# 4) Provides an update to the Xp bar


@onready var pickupBox:PickupBox = get_node("%PickupBox")

signal leveled_up()


var lvl = 0

var max_xp = 10:
	get:
		var _max = lvl
		if lvl == 0:
			_max = 1
			return 1
		elif lvl < 20:
			_max = lvl*5
		elif lvl < 40:
			_max = lvl * 10
		else:
			_max = lvl * 15
		return clamp(_max, 5, 1000)


var xp:float = 0 :
	set(new_value):
		xp = clamp(new_value, 0, max_xp)
	get:
		return xp


func _ready():
	pickupBox.picked_up.connect(on_xp_pickedup)


func on_xp_pickedup(xp_pickup):
	if xp_pickup is XpPickup:
		xp += xp_pickup.collect()
		xp_pickup.target = self
		if xp >= max_xp:
			call_deferred("lvl_up")

func lvl_up():
	lvl += 1
	Log.info("Leveled up : %d->%d" % [lvl-1,lvl])
	xp = 0
	leveled_up.emit()

