extends CharacterBody2D

@export var speed: float
@export var direction: Vector2
@export var damage = 5
@export var factor = 1.0
#var _velocity: = Vector2.ZERO

func _ready():
	speed = 60.0 + randf_range(0, 50)
	#direction = Vector2(0.0, 1.0)
	#direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	var player = $"/root/Main/Player"
	direction = (player.transform.get_origin() - position).normalized()
	var playback_speed = (speed / 110.0) * 9.0
	$AnimationPlayer.play("spin", playback_speed)
	
func _physics_process(delta):
	var _velocity = direction * speed
	var collision = move_and_collide(_velocity * delta)
	if collision: 
		queue_free()
