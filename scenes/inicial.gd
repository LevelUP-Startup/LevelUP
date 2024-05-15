extends Node2D


@onready var theLogoAnim:AnimationPlayer = $Control/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	theLogoAnim.play("LogoStart")
	theLogoAnim.animation_finished.connect(_main_menu)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _main_menu():
	pass
