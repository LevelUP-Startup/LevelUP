@tool
extends CharacterBody2D
class_name Monster 

@export var speed = 0
@export var health = 100
@export var damage = 5
@export var gold = 100
@export var factor = 1.0
@export var death_sfx = "1"

var _direction: = Vector2.ZERO
var _recoil_countdown = 0.0
var time_since_hit_player = 2000.0
var _dead = false
const RECOIL_SPEED = 900
const RECOIL_TIME = 0.15

@onready var particles = find_child("Particles2D")

@onready var sfxHit = find_child("SfxHit")
@onready var sfxDeath = find_child("SfxDeath")


func _ready():
	velocity = Vector2.ZERO
	print("Monster Ready")
	pass	


func setRoom(room):
	var m_cell = globals.map.get_random_floor_cell(room["left"], room["top"], room["width"], room["height"])
	position.x = m_cell.x * globals.GRID_SIZE
	position.y = m_cell.y * globals.GRID_SIZE

func monster_account():
	globals.reduce_monsters()


func forced_death():
	print("Oh! NOOOOO!")
	_dead=false
	health=-1

func _physics_process(delta):
	
	if _dead: return
	
	time_since_hit_player += delta
	var current_speed = speed
	
	# If recoiling
	if _recoil_countdown >= 0:
		current_speed = RECOIL_SPEED
		_recoil_countdown -= delta
		
	#var collision: = move_and_collide(_velocity * delta * current_speed * factor)
	velocity = _direction * current_speed * factor
	#set_velocity(_velocity)
	move_and_slide()
	#_velocity = velocity
	for i in get_slide_collision_count():
		var collision: = get_slide_collision(i)
		if collision:
			_direction = _direction.bounce(collision.get_normal())

	if health <= 0 and not _dead:
		monster_account()

		# Disable effects and hitboxes
		_dead = true
		set_collision_mask_value(1, false)
		set_collision_layer_value(2, false)
		# TODO: Fix Collision disabling
		# disableCollision()
		speed = 0
		
		# Show hit particle effect
		particles.one_shot = true
		particles.emitting = true
		particles.scale = Vector2(3, 3)
		
		# Start death anim
		$AnimationPlayer.play("death")
		# Play death sound
		sfxDeath.pitch_scale = randf() + 0.5
		sfxDeath.play(0.0)
		
		# Notch up score
		globals.player.add_gold(gold * factor)
		globals.kills += 1

#
# Finally remove when death sfx is done
#
func _on_SfxDeath_finished():
	queue_free()		
	
#
func _on_Hitbox_body_entered(body):
	# When hit by weapon
	
	if body.name == "Weapon":
		# and *not* recoiling - take damage
		if _recoil_countdown < 0.001:
			particles.one_shot = true
			particles.emitting = true
			particles.scale = Vector2(0.5, 0.5)
			health -= globals.player.weapon_damage / factor

			_direction = position - globals.player.position 
			_direction = _direction.normalized()
			_recoil_countdown = RECOIL_TIME

			sfxHit.pitch_scale = randf() + 0.8
			sfxHit.play(0.0)


func _on_visible_on_screen_enabler_2d_screen_entered():
	set_physics_process(true)
	set_process(true)
	pass # Replace with function body.
