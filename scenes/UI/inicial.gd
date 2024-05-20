extends Node2D


@onready var theLogoAnim:AnimationPlayer = $Control/AnimationPlayer
@onready var streamPlayer:AudioStreamPlayer = $AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	theLogoAnim.play("LogoStart")
	streamPlayer.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _main_menu():
	pass


func _on_audio_stream_player_finished():
	streamPlayer.play()
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name):
	$MainMenu.start()
	pass # Replace with function body.
