extends Node2D
class_name EnemySpawner


@export var spawns: Array[SpawnInfo] = []
@onready var player = get_tree().get_first_node_in_group("Player")
@export var time = 0
@onready var timer:Timer = get_node("%SpawnTimer")


const MAX_ENEMY = 100

signal changetime(time)


var spawn_center_pt:Vector2:
	get:
		if player !=null:
			return player.global_position
		else:
			return Vector2.ZERO

func _ready():
#	connect("changetime",Callable(player,"change_time"))
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	# THIS WILL TRIGGER BASED ON THE ATTACHED TIMER
	time += 1

	if Global.enemy_counter > MAX_ENEMY:
		return

	var enemy_spawns = spawns
	for spawn_info in enemy_spawns:


		if time >= spawn_info.time_start and time <= spawn_info.time_end:
			if spawn_info.spawn_delay_counter < spawn_info.enemy_spawn_delay:
				spawn_info.spawn_delay_counter += 1

			else: # waited enough time, time to let 'em rip!!
				spawn_info.spawn_delay_counter = 0
				spawn_n_enemies(spawn_info.enemy_num, spawn_info.enemy)
#	emit_signal("changetime",time)


func spawn_n_enemies(n:int, template_enemy):
	var counter = 0
	for i in range(n):
		Global.enemy_counter += 1
		var enemy_spawn = template_enemy.instantiate()
		enemy_spawn.global_position = get_random_position()
		add_child(enemy_spawn)


func get_random_position():
	var vpr:Vector2 = get_viewport_rect().size * randf_range(1.1,1.4)
	var p:Vector2 = spawn_center_pt
	var top_left = Vector2(p.x - vpr.x/2, p.y - vpr.y/2)
	var top_right = Vector2(p.x + vpr.x/2, p.y - vpr.y/2)
	var bottom_left = Vector2(p.x - vpr.x/2, p.y + vpr.y/2)
	var bottom_right = Vector2(p.x + vpr.x/2, p.y + vpr.y/2)
	var pos_side = ["up","down","right","left"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO

	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left

	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y,spawn_pos2.y)
	return Vector2(x_spawn,y_spawn)
