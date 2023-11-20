extends Node
class_name Inventory



var unlocked_weapons:Array[Constants.WeaponType]
var available_weapons: Dictionary = {}


func _set_available_weapons():
	for child in get_children():
		if child is Weapon:
			available_weapons[child.weapon_type] = child

func _ready():
	# Find all children nodes with "Weapon" as their class name and add them to the available_weapons dictionary.
	_set_available_weapons()

	if available_weapons.size() > 0:
		for wtype in available_weapons.keys():
			_hide_weapon(wtype)
	unlock_next_weapon()
	

func _hide_weapon(wtype: Constants.WeaponType):
	var w = available_weapons[wtype]
	w.hide()
	w.set_process_input(false)
	w.set_process(false)
	w.set_physics_process(false)
	
func _unlock_weapon(wtype: Constants.WeaponType):
	var w = available_weapons[wtype]
	unlocked_weapons.append(wtype)
	w.show()
	w.set_process_input(true)
	w.set_process(true)
	w.set_physics_process(true)
	
	


func unlock_next_weapon():
	for w in available_weapons.keys():
		if w not in unlocked_weapons:
			_unlock_weapon(w)
			break



func _input(event):
	# Handle user input to cycle weapons (e.g., pressing 'n' for next weapon).
	if Input.is_action_pressed("cycle_weapon_forward") or  Input.is_action_pressed("cycle_weapon_backwards"):
		unlock_next_weapon()


func upgrade_weapon(wtype:Constants.WeaponType):
	if wtype in unlocked_weapons:
		var w:Weapon = available_weapons[wtype]
		w.increment_lvl()
	else:
		_unlock_weapon(wtype)
