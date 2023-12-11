extends Weapon
class_name Bomb

@onready var pre_timer:Timer = $PreExplosionTimer
@onready var post_timer:Timer = $PostExplosionTimer
@onready var explosion_fx:GPUParticles2D = $InkParticlesFX
@onready var grow_fx:GPUParticles2D = $GrowFX
@onready var sprite:Sprite2D = $Sprite2D

var time_before_explosion:float = 2
var explosion_size:float = 2



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _ready():
	super()
	knockback_amount = 0
	pre_timer.wait_time = time_before_explosion
	pre_timer.timeout.connect(_blow_up)
	pre_timer.start(time_before_explosion)
	
	post_timer.timeout.connect(cleanup)
	post_timer.wait_time = lifetime
	
	enable_attack(false)
	
	
func cleanup():
	Log.debug("CLEANUP")
	explosion_fx.emitting = false
	grow_fx.emitting = false
	super()
	

func _on_attack_collision(body):
	pass


func _blow_up():
	Log.debug("Blow up")
	pre_timer.stop()
	enable_attack(true)
	sprite.visible = false
	
	attack_box.scale = Vector2.ONE * explosion_size
	explosion_fx.emitting = true
	grow_fx.process_material.set("scale_min", explosion_size * 2 )
	grow_fx.process_material.set("scale_max", explosion_size * 2 )
	grow_fx.lifetime = lifetime
	grow_fx.emitting = true
	
	
	post_timer.start(lifetime)
	
