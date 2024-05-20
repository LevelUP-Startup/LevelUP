extends CharacterBody2D
class_name Player

@export_category("Variables")
@export var speed: float;

@export_category("Nodes")
@export var animationTree: AnimationTree;
@export var animation: Animation;

@onready var player_sprite = $PlayerSprite;
var last_move = LPCAnimatedSprite2D.LPCAnimation.IDLE_DOWN
var attack_move = LPCAnimatedSprite2D.LPCAnimation.THRUST_DOWN
var collision_shape = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var movement:Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_pressed("attack"):
		return
	velocity = movement*200
	move_and_slide()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement:Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if Input.is_action_pressed("attack"):
		player_sprite.play(attack_move, 10.0)
		collision_shape.disabled = false
		return
	else:
		$ThrusRight.disabled = true
		$ThrustLeft.disabled = true
		$ThrustDown.disabled = true
		$ThrustUp.disabled = true
	if movement.x<0 and movement.y==0:
		player_sprite.play(LPCAnimatedSprite2D.LPCAnimation.WALK_LEFT)
		last_move = LPCAnimatedSprite2D.LPCAnimation.IDLE_LEFT
		attack_move = LPCAnimatedSprite2D.LPCAnimation.THRUST_LEFT
		collision_shape = $ThrustLeft
	if movement.x>0 and movement.y==0:
		player_sprite.play(LPCAnimatedSprite2D.LPCAnimation.WALK_RIGHT)
		last_move = LPCAnimatedSprite2D.LPCAnimation.IDLE_RIGHT
		attack_move = LPCAnimatedSprite2D.LPCAnimation.THRUST_RIGHT
		collision_shape = $ThrusRight
	if movement.x==0 and movement.y<0:
		player_sprite.play(LPCAnimatedSprite2D.LPCAnimation.WALK_UP)
		last_move = LPCAnimatedSprite2D.LPCAnimation.IDLE_UP
		attack_move = LPCAnimatedSprite2D.LPCAnimation.THRUST_UP
		collision_shape = $ThrustUp
	if movement.x==0 and movement.y>0:
		player_sprite.play(LPCAnimatedSprite2D.LPCAnimation.WALK_DOWN)
		last_move = LPCAnimatedSprite2D.LPCAnimation.IDLE_DOWN
		attack_move = LPCAnimatedSprite2D.LPCAnimation.THRUST_DOWN
		collision_shape = $ThrustDown
	if movement.is_zero_approx():
		player_sprite.play(last_move)
