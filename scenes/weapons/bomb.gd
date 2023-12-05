extends Weapon


@onready var pre_timer:Timer = $PreExplosionTimer
@onready var post_timer:Timer = $PostExplosionTimer
@onready var explosion_fx:GPUParticles2D = $ExplosionFX
@onready var sprite:Sprite2D = $Sprite2D

var time_before_explosion:float = 2




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _ready():
	super()
	
	pre_timer.wait_time = time_before_explosion
	pre_timer.timeout.connect(_blow_up)
	pre_timer.start(time_before_explosion)
	
	post_timer.timeout.connect(cleanup)
	post_timer.wait_time = lifetime
	
	enable_attack(false)
	
	
func cleanup():
	print("CLEANUP")
	explosion_fx.emitting = false
	super()
	

func _on_attack_collision(body):
	pass


func _blow_up():
	print("Blow up")
	pre_timer.stop()
	enable_attack(true)
	sprite.visible = false
	
	explosion_fx.lifetime = lifetime
	explosion_fx.emitting = true
	post_timer.start(lifetime)
