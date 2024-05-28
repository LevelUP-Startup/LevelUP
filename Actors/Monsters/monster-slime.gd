extends Monster

const SCENE_SLIME = preload("res://Entities/Monsters/slime.tscn")

func _ready():
	$AnimatedSprite.animation = "slime"
	$Particles2D.modulate = Color("97da3f")
	$SfxDeath.stream = load("res://assets/audio/sfx/squish.wav")
	
	health = 15
	gold = 10
	death_sfx = "3"
	speed = randi_range(20, 60)
	#_velocity = Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0))
	_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()	
	
func _physics_process(delta):
	super._physics_process(delta)
	if randf() * 100 < 15:
		var slime = SCENE_SLIME.instantiate()
		slime.position.x = position.x + 8
		slime.position.y = position.y + 8
		globals.map.add_child(slime)
