extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start():
	$AnimationPlayer.play("Init")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _novo_jogo():
	get_tree().change_scene_to_file("res://scenes/City/City.tscn")
	pass # Replace with function body.


func _carregar_jogo():
	get_tree().change_scene_to_file("res://scenes/City/City.tscn")
	pass # Replace with function body.


func _creditos():
	pass # Replace with function body.
