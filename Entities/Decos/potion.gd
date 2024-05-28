extends Node

func _ready():
	$Sprite2D/AnimationPlayer.play("glow")


func _on_Area2D_body_entered(_body):
	globals.player.heal(10 + randi() % 10)
	$Area2D.queue_free()
	$PointLight2D.queue_free()
	$GPUParticles2D.queue_free()
	$Sprite2D.queue_free()
	$Sfx.play(0.0)

func _on_Sfx_finished():
	queue_free()
