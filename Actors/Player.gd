extends CharacterBody2D
class_name Player

@export_category("Variables")
@export var speed: float;

@export_category("Nodes")
@export var animationTree: AnimationTree;
@export var animation: Animation;

@onready var player_sprite = $PlayerSprite;

@export var charSpeed:int = 300

@export var base_speed = Vector2(400, 400)
@export var light_size = 0.19
@export var light_brightness = 2.4
@export var health = 100
@export var attack_cooldown_time = 0.5
@export var weapon_damage = 10.0

var last_move = LPCAnimatedSprite2D.LPCAnimation.IDLE_DOWN
var attack_move = LPCAnimatedSprite2D.LPCAnimation.THRUST_DOWN
@onready var attackWeapon = "ThrustRight"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func hidePowers(value=true):
	$ItemPowers.visible=not value

func start_dungeon():
	pass
	
func end_dungeon():
	pass
	
func _unhandled_input(event):
	if event.is_action_pressed("lantern"):
		$PointLight2D.enabled=!$PointLight2D.enabled
		
func _physics_process(_delta):
	var movement:Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_pressed("attack"):
		return
	velocity = movement*charSpeed
	move_and_slide()
	pass

func add_gold(extragold: int):
	globals.gold += extragold
	$"/root/Main/HUD/Control/GoldLabel".text = str(floor(globals.gold))
	$"/root/Main/HUD/Control/GoldLabel/AnimationPlayer".play("blink")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var movement:Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if Input.is_action_pressed("attack"):
		player_sprite.play(attack_move, 10.0)
		$Weapon.attack(attackWeapon)
		return
	if movement.x<0 and movement.y==0:
		player_sprite.play(LPCAnimatedSprite2D.LPCAnimation.WALK_LEFT)
		last_move = LPCAnimatedSprite2D.LPCAnimation.IDLE_LEFT
		attack_move = LPCAnimatedSprite2D.LPCAnimation.THRUST_LEFT
		attackWeapon = "ThrustLeft"
	if movement.x>0 and movement.y==0:
		player_sprite.play(LPCAnimatedSprite2D.LPCAnimation.WALK_RIGHT)
		last_move = LPCAnimatedSprite2D.LPCAnimation.IDLE_RIGHT
		attack_move = LPCAnimatedSprite2D.LPCAnimation.THRUST_RIGHT
		attackWeapon = "ThrustRight"
	if movement.x==0 and movement.y<0:
		player_sprite.play(LPCAnimatedSprite2D.LPCAnimation.WALK_UP)
		last_move = LPCAnimatedSprite2D.LPCAnimation.IDLE_UP
		attack_move = LPCAnimatedSprite2D.LPCAnimation.THRUST_UP
		attackWeapon = "ThrustUp"
	if movement.x==0 and movement.y>0:
		player_sprite.play(LPCAnimatedSprite2D.LPCAnimation.WALK_DOWN)
		last_move = LPCAnimatedSprite2D.LPCAnimation.IDLE_DOWN
		attack_move = LPCAnimatedSprite2D.LPCAnimation.THRUST_DOWN
		attackWeapon = "ThrustDown"
	if movement.is_zero_approx():
		player_sprite.play(last_move)
