extends Node

# Main game script, handles initialisation and changing levels

const SCENE_PLAYER = preload("res://Actors/player.tscn")
const SCENE_MAP = preload("res://Scenes/Dungeon/Dungeon.tscn")
#const exit_finder = preload("res://items/exit_finder.tscn")
var rng: = RandomNumberGenerator.new()
#var exit_finder_inst

func _ready():
	randomize()
	
	
	#TODO: Fix the HUD
	#$HUD/Control/HealthBar.value = globals.player.health
	globals.depth = 0
	globals.player = SCENE_PLAYER.instantiate()
	
	if(globals.start_game):
		globals.gold = 50
		globals.kills = 0
		globals.last_depth=0
		globals.start_game=false
	# Start at depth 1 !
	next_level()
	print("Number of nodes: %s"%get_tree().get_node_count())
	# Start game, add a player and reset globals
	add_child(globals.player)
	globals.player.hidePowers(false)
	globals.player.start_dungeon()

# 
# Start a level, at current depth, level will be randomly generated
#
func start_level():
	# Nuke old map if any
	if globals.depth > 1: 
		if get_node_or_null("Map") != null: 
			var oldMap = $Map
			remove_child(oldMap)
		#if globals.map != null: globals.map.queue_free()
		
	# This creates a new map, which in turn will call the random generator
	# Hold map in globals for conveniance
	globals.map = SCENE_MAP.instantiate()
	
	# Random colors for deeper dungeons, adds variety 
	if globals.depth > 1:
		var r = randi() % 8
		if r == 0: globals.map.self_modulate = Color(1.0, 1.8, 1.0)
		if r == 1: globals.map.self_modulate = Color(1.6, 1.0, 1.0)
		if r == 2: globals.map.self_modulate = Color(1.0, 1.0, 1.9)
		if r == 3: globals.map.self_modulate = Color(1.8, 1.5, 1.0)
		if r == 4: globals.map.self_modulate = Color(1.0, 1.8, 1.6)
		if r == 5: globals.map.self_modulate = Color(1.5, 1.0, 1.5)
		
	# Add map to Main node
	add_child(globals.map)
	globals.map._add_monsters()
	$HUD/Control/DepthLabel.text = str(globals.depth * 100) + " ft"
	

	
	# Move player to a randomly selected start room
	var start_room = $Dungeon.get_start_room()
	var player_cell = globals.map.get_random_floor_cell(start_room["left"], start_room["top"], start_room["width"], start_room["height"])
	globals.player.position.x = player_cell.x * globals.GRID_SIZE
	globals.player.position.y = player_cell.y * globals.GRID_SIZE


	$DoorCloseTimer.start()
	#exit_finder_inst = exit_finder.instantiate()
	#$HUD/Control.add_child(exit_finder_inst)
	
	

func enable_exit():
	print("Current_Level: %s"%str(globals.depth))
	if globals.depth>0:
		globals.persist_level(globals.depth)
	$DoorOpenTimer.start()

#
# Helper to move to next level
#
func next_level():

	globals.monster_free.disconnect(enable_exit)
	$SfxExit.play(0.0)
	globals.depth += 1
	print("Calling next level")
	if globals.depth > globals.last_depth:
		print("This is a new level")
		# IMPORTANT! Use call_deferred to prevent "flushing queries" errors/warnings
		globals.last_depth=globals.depth
		call_deferred("start_level")
		globals.monster_free.connect(enable_exit)
	else:
		print("Level already loaded")
		call_deferred("load_level")
		
		
func assemble_level(level_data):
	globals.map = level_data
	add_child(globals.map)
	
	globals.map.lock_exits()
	
	$HUD/Control/DepthLabel.text = str(globals.depth * 100) + " ft"


	globals.player.position.x = $Map.player_restore.x
	globals.player.position.y = $Map.player_restore.y
	#exit_finder_inst = exit_finder.instantiate()
	#$HUD/Control.add_child(exit_finder_inst)

	$DoorOpenTimer.start(2)
		
func load_level(level_direction = globals.level_direction.DOWN):
	if($Map!=null):
		var oldMap = $Map
		remove_child(oldMap)

	var level_data = globals.restore_level(globals.depth)
	level_data.level_direction = level_direction
	call_deferred("assemble_level", level_data)

func previous_level():
	globals.depth-=1
	print("Previous_Level: %s"%str(globals.depth))
	if globals.depth<1:
		globals.depth=0
		get_tree().change_scene_to_file("res://Scenes/Village.tscn")
		pass
	else:
		print("Going back one level")
		load_level(globals.level_direction.UP)


func _on_door_close_timer_timeout():
	$SfxDoorClose.play()
	$DoorCloseTimer.stop()
	pass # Replace with function body.


func _on_door_open_timer_timeout():
	$SfxDoorOpen.play()
	$DoorOpenTimer.stop()
	$Dungeon.unlock_exits()
	
	pass # Replace with function body.
