extends CharacterBody2D
class_name Player

@export_category("Variables")
@export var speed: float;

@export_category("Nodes")
@export var animationTree: AnimationTree;
@export var animation: Animation;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
