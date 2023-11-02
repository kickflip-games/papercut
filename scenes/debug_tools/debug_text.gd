extends Label

@onready var timer = $Timer
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var xp_manager:XpManager = get_tree().get_first_node_in_group("Player").get_node("XP")

var _fps:float

var fmt:String = """
Enemies: {enemy_active}/{enemy_max}
XP: {current_xp}/{max_xp}
"""


# Called when the node enters the scene tree for the first time.
func _ready():
	_update_txt()
	timer.timeout.connect(_update_txt) # Replace with function body.
	

func _update_txt():
	text = fmt.format({
		'enemy_active': Global.enemy_counter,
		'enemy_max': EnemySpawner.MAX_ENEMY,
		'current_xp': xp_manager.xp,
		'max_xp': xp_manager.max_xp
	})
