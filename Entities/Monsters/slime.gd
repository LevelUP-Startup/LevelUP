extends Node2D

func _ready():
	$Sprite2D.self_modulate = Color(0.0, 0.6, 0.0, 0.2)
	var _scale = randf_range(0.7, 1.1)
	$Sprite2D.scale.x = _scale
	$Sprite2D.scale.y = _scale
	rotate(randf())
	$Timer.wait_time = randf_range(1.0, 1.5)

func _on_Timer_timeout():
	queue_free()
