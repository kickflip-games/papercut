extends Line2D
class_name Trail2d

@export_category('Trail')
@export var max_length : = 10
var length

@onready var parent : Node2D = get_parent()
var offset : = Vector2.ZERO

func _ready() -> void:
	offset = position
	
	hide_trail()

func _physics_process(_delta: float) -> void:
	global_position = Vector2.ZERO

	var point : = parent.global_position + offset
	add_point(point, 0)
	
	if get_point_count() > length:
		remove_point(get_point_count() - 1)

func hide_trail():
	length = max_length
	top_level = true

func show_trail():
	length = max_length
	top_level = true
