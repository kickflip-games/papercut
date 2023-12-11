extends Sprite2D

@onready var timer = $FlashTimer
@onready var damage_box = get_node("%TakeDamageBox")
var flashTween:Tween 
var flash_dur:float = 0.5
var num_flash:int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	damage_box.take_damage.connect(flash)
	


func flash(damage:float, dir:Vector2, knkback_amt:float):
	# material.set_shader_param("flash_modifier", 1)
	flashTween = create_tween()
	var t = flash_dur / (num_flash * 2)
	for i in range(num_flash):
		flashTween.tween_property(self, "modulate", Color.RED, t).set_trans(Tween.TRANS_SINE)
		flashTween.tween_property(self, "modulate", Color.WHITE, t).set_trans(Tween.TRANS_SINE)
	
