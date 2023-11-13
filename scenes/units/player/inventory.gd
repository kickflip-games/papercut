extends Node
class_name Inventory

var active_weapon: Weapon = null:
	set(w):
		_enable_weapon(w)
		active_weapon = w
	get:
		return active_weapon
		
var available_weapons: Dictionary = {}
var active_weapon_type: Constants.WeaponType:
	get:
		if (active_weapon):
			return active_weapon.weapon_type
		else:
			return Constants.WeaponType.NONE

func _set_available_weapons():
	for child in get_children():
		print("Child nm:", child.name)
		if child is Weapon:
			print("adding wpn: ", child.weapon_type)
			available_weapons[child.weapon_type] = child
	print("Availible weapons: ", available_weapons)

func _ready():
	# Find all children nodes with "Weapon" as their class name and add them to the available_weapons dictionary.
	_set_available_weapons()

	if available_weapons.size() > 0:
		# Initialize the active weapon to the first weapon found.
		active_weapon = available_weapons.values()[0]
		disable_other_weapons()

func disable_other_weapons():
	# Disable all weapons in the available_weapons dictionary except the active one.
	for weapon in available_weapons.values():
		if weapon != active_weapon:
			_disable_weapon(weapon)

func switch_weapon(weapon_type:Constants.WeaponType):
	# Function to switch to a specific weapon by its type.
	print("Switching to ", str(weapon_type))
	if active_weapon:
		_disable_weapon(active_weapon)

	# Find and assign the new active weapon by its type.
	if available_weapons.has(weapon_type):
		active_weapon = available_weapons[weapon_type]

func cycle_weapons(forward: bool):
	# Cycle through weapons in the available_weapons dictionary.
	if available_weapons.size() == 0:
		return

	print("avail types ", available_weapons)
	var weapon_types = available_weapons.keys()
	print("Weaponn types ", weapon_types)
	var weapon_type_count = weapon_types.size()

	# Find the index of the current active weapon's type and calculate the new index based on direction.
	var current_weapon_type = active_weapon.weapon_type
	var current_weapon_index = weapon_types.find(current_weapon_type)
	var new_weapon_index = 0

	if forward:
		new_weapon_index = (current_weapon_index + 1) % weapon_type_count
	else:
		new_weapon_index = (current_weapon_index - 1 + weapon_type_count) % weapon_type_count

	var new_weapon_type = weapon_types[new_weapon_index]
	switch_weapon(new_weapon_type)


func _disable_weapon(w: Weapon):
	w.hide()
	w.set_process_input(false)
	w.set_process(false)
	w.set_physics_process(false)
	
func _enable_weapon(w:Weapon):
	w.show()
	w.set_process_input(true)
	w.set_process(true)
	w.set_physics_process(true)


func _input(event):
	# Handle user input to cycle weapons (e.g., pressing 'n' for next weapon).
	if Input.is_action_pressed("cycle_weapon_forward"):
		cycle_weapons(true)
	if Input.is_action_pressed("cycle_weapon_backwards"):
		cycle_weapons(false)
