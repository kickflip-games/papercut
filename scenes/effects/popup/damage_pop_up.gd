extends Node
class_name DamagePopUp


@export var max_size:float = 10
@export var duration:float = 1

@onready var popup_container:Node2D = $popup_container as Node2D
@onready var label:Label = $popup_container/Label as Label

func set_values_and_animate(
		value: String, 
		pos: Vector2, 
		color:Color=Color.WHITE,
		height: float=15,
		spread: float=15, 
		t_grow: float=0.2, 
		t_shrink:float=0.5, 
	):
	self.global_position = pos
	label.text = value
	self.modulate = color
	var end_pos = Vector2(randf_range(-spread, spread), -height) + pos
	popup_container.set_deferred("scale",  Vector2.ZERO)
	call_deferred("trigger_tween", end_pos, t_grow, t_shrink)



func trigger_tween(end_pos: Vector2, t_grow: float, t_shrink:float):
	var tween = get_tree().create_tween()
	tween.tween_property(popup_container, "global_position", end_pos, t_grow+t_shrink).set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property(popup_container, "scale",  Vector2.ONE, t_grow).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(popup_container, "scale",  Vector2.ZERO, t_shrink).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(queue_free)
