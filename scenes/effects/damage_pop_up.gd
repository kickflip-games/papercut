extends Node
class_name DamagePopUp


@export var max_size:float = 10
@export var duration:float = 1

var clip_name:String = "damage_pop_up"

var tween:Tween
@onready var popup_container = $popup_container
@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var label:Label = $popup_container/Label


var debug = true


func _ready():
	if debug:
		set_values_and_animate("100", 25* Vector2.ONE, 5, 5)


func stop_anim():
	anim.stop()
	if is_inside_tree():
		get_parent().remove_child(self)


func set_values_and_animate(value:String, start_pos:Vector2, height:float, spread:float) -> void:
	label.text = value
	anim.play(clip_name)
	
	var tween = get_tree().create_tween()
	var end_pos = Vector2(randf_range(-spread,spread),-height) + start_pos
	var tween_length = anim.get_animation(clip_name).length
		
	tween.tween_property(popup_container,"position",end_pos,tween_length).from(start_pos)
