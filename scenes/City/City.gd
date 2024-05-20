extends Node2D


@onready var streamPlayer:AudioStreamPlayer = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	streamPlayer.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_audio_stream_player_2d_finished():
	streamPlayer.play()
	pass # Replace with function body.
