extends Node2D


@onready var streamPlayer:AudioStreamPlayer = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	streamPlayer.play()
	$Player.hidePowers()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_audio_stream_player_2d_finished():
	streamPlayer.play()
	pass # Replace with function body.


func _on_area_2d_area_entered(_area):
	print_debug("Entrou")
	pass # Replace with function body.
