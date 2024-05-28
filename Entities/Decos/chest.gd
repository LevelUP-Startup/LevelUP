extends Node2D

func _on_Area2D_body_entered(_body):
	globals.player.add_gold(100)
	$Area2D.queue_free()
	$Sprite2D.queue_free()
	$"GPUParticles2D-Anim".queue_free()
	$Sfx.play(0.0)
	$GPUParticles2D.emitting = true
	$GPUParticles2D.one_shot = true

func _on_Sfx_finished():
	queue_free()
