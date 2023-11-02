extends RigidBody2D


@onready var screen_noitifyer = $VisibleOnScreenNotifier2D
@onready var attackBox = $AttackBox 


func _ready():
	screen_noitifyer.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)
	attackBox.area_entered.connect(_on_area_2d_body_entered)
	

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_2d_body_entered(body):
	attackBox.disconnect("area_entered", _on_area_2d_body_entered)
#	call_deferred("attach_to_new_body", body)
	
#	await get_tree().create_timer(5).timeout
	queue_free()
	
	
#func attach_to_new_body(body):	
#	print("arrow hit " + body.name)
#	attackBox.set("disabled", true)
#	sleeping = true
#	reparent(body.get_parent(), true)
