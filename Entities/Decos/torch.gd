extends Node2D

func _ready():
	# Stop all torches moving in sync
	$AnimatedSprite2D.frame = randi() % 4
	$AnimatedSprite2D.speed_scale = randf_range(0.8, 3)
	$AnimatedSprite2D.play("default")
