extends TileMap

# Game main map, instanced as a singleton 

signal kill_em_all

const MAP_SIZE = 48        # Size of the map, which is always square
const MAX_DEPTH = 4        # Recursion depth when generating

# TileSet indexes for walls and floors
const TILE_IDX_UNSET = -1
const TILE_IDX_WALL = 0
const TILE_IDX_FLOOR = 1

const SCENE_UP = preload("res://scenes/Dungeon/exit_up.tscn")
const SCENE_EXIT = preload("res://scenes/Dungeon/exit.tscn")


const SCENE_MONSTER = preload("res://Actors/Monsters/monster.tscn")
const SCENE_TORCH = preload("res://Entities/Decos/torch.tscn")
const SCENE_CHEST = preload("res://Entities/Decos/chest.tscn")
const SCENE_POTION = preload("res://Entities/Decos/potion.tscn")

var rng: = RandomNumberGenerator.new()
var layer = 0

var is_loaded = false

# Will hold each "room" once generation is complete
@export var all_rooms: = []

@export var start_room = {}

@export var exit_pos:Vector2

@export var entry_pos:Vector2

@export var player_restore:Vector2

var exit
var entry

var level_direction = globals.level_direction.DOWN

var exit_up_room 
var exit_room 

var exit_cell
var exit_up_cell

func _unhandled_input(event):
	if event.is_action_pressed("KILL_EM_ALL"):
		kill_em_all.emit()

func _ready():
	
	globals.reduce_monsters_signal.emit()
	
	if is_loaded:
		_setup_exits()
		return
		
	rng.randomize()
	all_rooms.clear()
	
	# IMPORTANT! Generate the whole level by instancing a top level LevelGenZone
	var top_zone = LevelGenZone.new(0, 0, MAP_SIZE, MAP_SIZE, 0) 
	
	# We need to add the zone to the tree so it can access the map node
	add_child(top_zone)
	top_zone.set_owner(self)
	
	# Corridors after room generation but BEFORE pillars
	top_zone.make_corridor()
	
	# Add details to each room, pillars and treasure
	for room in all_rooms:
		_add_pillars(room)
		
		# Normal treasure chance
		var treasure_chance = 0.6
		
		# Small chance of mega treasure room, wow!
		if randf() * 100 < (0.0 + globals.depth):
			treasure_chance = 25.0
			
		# Spawn loop factored on room size
		for mi in range(room.width * room.height):
			# treasure = potions & chests
			if randf() * 100 <= treasure_chance:
				var treasure
				# 50/50 chance of potion or chest
				if randf() * 100 < 50:
					treasure = SCENE_CHEST.instantiate()
				else:
					treasure = SCENE_POTION.instantiate()
					
				# Mega treasure room, only has chests!
				if treasure_chance >= 25.0:
					treasure = SCENE_CHEST.instantiate()
					
				var t_cell = get_random_floor_cell(room["left"], room["top"], room["width"], room["height"])
				treasure.position.x = t_cell.x * globals.GRID_SIZE
				treasure.position.y = t_cell.y * globals.GRID_SIZE
				add_child(treasure)
				treasure.set_owner(self)
				continue
				
			# Random floor decorations, and stuff to make the map more interesting
			# These have no game effect
			if randf() * 100 <= 5.0:
				var deco = Sprite2D.new()
				var r: = randi() % 4
				if r == 0: deco.texture = preload("res://assets/Graficos/Deco/blood.png")
				if r == 1: deco.texture = preload("res://assets/Graficos/Deco/crack.png")
				if r == 2: deco.texture = preload("res://assets/Graficos/Deco/skull.png")
				if r == 3: deco.texture = preload("res://assets/Graficos/Deco/bones.png")
				if randf() > 0.5: deco.flip_h = true
				var m_cell = get_random_floor_cell(room["left"], room["top"], room["width"], room["height"])
				deco.position.x = m_cell.x * globals.GRID_SIZE + 32
				deco.position.y = m_cell.y * globals.GRID_SIZE + 32
				deco.add_to_group("decos")
				deco.scale=deco.scale*0.5
				deco.self_modulate = self_modulate
				add_child(deco)		
				deco.set_owner(self)
	
	# Lastly "paint" the edges with the wall tiles
	_add_walls()
	
	start_room = globals.map.all_rooms[randi() % len(globals.map.all_rooms)]
	
	_add_entry_exit()
	
func get_start_room():
	return start_room
	
func restore_player(level_direction):
	match(level_direction):
		globals.level_direction.DOWN:
			pass
		globals.level_direction.UP:
			pass
	
func _setup_exits():
	exit = SCENE_EXIT.instantiate()
	entry = SCENE_UP.instantiate()
	exit.position = exit_pos
	entry.position = entry_pos
	exit.disable()
	entry.disable()
	add_child(exit)
	add_child(entry)
	
	var restore_cells = entry.get_respawns() if level_direction==globals.level_direction.DOWN else exit.get_respawns()
	
	var player_up_cell 
	while true:
		player_up_cell = globals.map.get_random_floor_cell(restore_cells["left"], restore_cells["top"], restore_cells["width"], restore_cells["height"])
		if player_up_cell != exit_up_cell:
			break
	player_restore = Vector2(player_up_cell.x*globals.GRID_SIZE, player_up_cell.y*globals.GRID_SIZE)
	
	
func _add_entry_exit():
	# Place exit in randomly selected start room
	exit = SCENE_EXIT.instantiate()
	
	# Place exit in any random room which is not the player start room
	while true:
		exit_room = globals.map.all_rooms[randi() % len(globals.map.all_rooms)]
		if exit_room != start_room: 
			break

	# Place exit randomly in selected exit room
	exit_cell = globals.map.get_random_floor_cell(exit_room["left"], exit_room["top"], exit_room["width"], exit_room["height"])
	exit.position.x = exit_cell.x * globals.GRID_SIZE
	exit.position.y = exit_cell.y * globals.GRID_SIZE
	exit_pos = exit.position
	add_child(exit)
	exit.set_owner(self)
	
	# Place exit in randomly selected start room
	entry = SCENE_UP.instantiate()

	# Place entry randomly in start room
	exit_up_cell = globals.map.get_random_floor_cell(start_room["left"], start_room["top"], start_room["width"], start_room["height"])
	entry.position.x = exit_up_cell.x * globals.GRID_SIZE
	entry.position.y = exit_up_cell.y * globals.GRID_SIZE
	entry_pos = entry.position
	add_child(entry)
	entry.set_owner(self)	
	
	var restore_cells = entry.get_respawns()	
	
	var player_up_cell 
	while true:
		player_up_cell = globals.map.get_random_floor_cell(restore_cells["left"], restore_cells["top"], restore_cells["width"], restore_cells["height"])
		if player_up_cell != exit_up_cell:
			break
	player_restore = Vector2(player_up_cell.x*globals.GRID_SIZE, player_up_cell.y*globals.GRID_SIZE)
	
	
	
	lock_exits()
		
	
func _add_monsters():
		# Remove existing monsters (if any)
	
	kill_em_all.emit()
		
		# Add monsters to each room (should this be move to map.gd I don't know)
	for room in globals.map.all_rooms:
		# Spawn loop is factored on room size
		for mi in range(room.width * room.height):
			# Monster spawn rate factored on depth
			if (randf() * 100) <= 0.5 + (globals.depth * 0.7):
				
				# Randomly pick a monster, note we instance the same scene for all monsters
				# But attach different scripts for the different behaviors 
				# Place monster in game (inside Main node)
				
				var r: = randi() % 3
				if r == 0:					
					globals.level_monsters+=1
					addSkelMonster(room)
				if r == 1: 
					globals.level_monsters+=1
					addSlimeMonster(room)
				if r == 2:
					globals.level_monsters+=1
					addGoblinMonster(room)
	print("Monsters in Level: %s"%globals.level_monsters)


func addSkelMonster(room):
	var monster: Monster
	monster = SCENE_MONSTER.instantiate()
	monster.set_script(preload("res://Actors/Monsters/monster-skel.gd"))
	kill_em_all.connect(monster.forced_death)
	# Place monster randomly in room
	add_child(monster)
	monster.setRoom(room)
	pass

func addGoblinMonster(room):
	var monster: Monster
	monster = SCENE_MONSTER.instantiate()
	monster.set_script(preload("res://Actors/Monsters/monster-goblin.gd"))
	kill_em_all.connect(monster.forced_death)

	# Place monster randomly in room
	add_child(monster)
	monster.setRoom(room)
	pass
	
func addSlimeMonster(room):
	var monster: Monster
	monster = SCENE_MONSTER.instantiate()
	monster.set_script(preload("res://Actors/Monsters/monster-slime.gd"))
	kill_em_all.connect(monster.forced_death)

	add_child(monster)
	monster.setRoom(room)
	pass

	
#
# Helper to paint a rect with a given tile 
#
func fill_cells(left, top, width, height, tile_idx, tile_coords):
	for y in range(top, top + height):
		for x in range(left, left + width):
			var coords = Vector2(x,y)
			var atlasCoords = Vector2i(0,0)
			set_cell(layer, coords, tile_idx, tile_coords)

#
# Paint a rect of floor tiles wich are picked randomly
#
func fill_cells_floor(left, top, width, height):
	for y in range(top, top + height):
		for x in range(left, left + width):
			var coords = Vector2(x,y)
			var atlasCoords = Vector2i(0,0)
			set_cell(layer, coords, TILE_IDX_FLOOR, Vector2(rng.randi_range(6, 9), rng.randi_range(0, 2)))
		
#
# Rooms are big empty rectangles, this randomly puts 2x2 "holes" in the rooms
#
func _add_pillars(room):
	if room.width * room.height > 15 and room.width > 4 and room.height > 4:
		var deco_count: = rng.randi_range(3, 8)
		for p in range(deco_count):
			var pillarLeft: = rng.randi_range(1, room.width - 3)
			var pillarTop: = rng.randi_range(1, room.height - 3)
			fill_cells(room.left + pillarLeft, room.top + pillarTop, 2, 2, TILE_IDX_UNSET, Vector2.ZERO)	

#
# OK, wow... 
# This sets the tiles around the edges of rooms to the correct tiles, see dungeon-tiles.tres
# There's a LOT of hard coded logic here based on how the tiles are drawn and their postions in the set
#
func _add_walls():
	for y in range(-2, MAP_SIZE + 2):
		for x in range(-2, MAP_SIZE + 2): 
			var coords = Vector2i(x,y)
			if get_cell_source_id(layer, coords) == TILE_IDX_UNSET:
				# Specal 1 thickness walls - doesn't look that good
				var coords_left = Vector2i(x-1,y)
				var coords_right = Vector2i(x+1,y)
				var coords_top = Vector2i(x,y-1)
				var coords_bottom = Vector2i(x,y+1)
				var coords_top_right = Vector2i(x+1,y-1)
				var coords_top_left = Vector2i(x-1,y-1)
				var coords_bottom_right = Vector2i(x+1,y+1)
				var coords_bottom_left = Vector2i(x-1,y+1)
				if get_cell_source_id(layer, coords_left) == TILE_IDX_FLOOR and get_cell_source_id(layer, coords_right) == TILE_IDX_FLOOR:
					#set_cell(x, y, TILE_IDX_WALL, false, false, false, Vector2(1, 1))
					fill_cells_floor(x, y, 1, 1)
					continue				
				if get_cell_source_id(layer, coords_top) == TILE_IDX_FLOOR and get_cell_source_id(layer, coords_bottom) == TILE_IDX_FLOOR:
					#set_cell(x, y, TILE_IDX_WALL, false, false, false, Vector2(2, 1))
					fill_cells_floor(x, y, 1, 1)
					continue		
									
				# Cardinal directions
				if get_cell_source_id(layer, coords_bottom) == TILE_IDX_FLOOR:
					set_cell(layer, coords, TILE_IDX_WALL, Vector2(rng.randi_range(1, 4), 0))
					if rng.randf() <= 0.2:
						_add_torch(x, y)
					continue
				if get_cell_source_id(layer, coords_top) == TILE_IDX_FLOOR:
					# "north" walls are a special case due to fake perspective
					if get_cell_source_id(layer, coords_left) == TILE_IDX_FLOOR:
						set_cell(layer, coords, TILE_IDX_WALL, Vector2(0, 5))
					elif get_cell_source_id(layer, coords_right) == TILE_IDX_FLOOR:
						set_cell(layer, coords, TILE_IDX_WALL, Vector2(5, 5))						
					else:
						set_cell(layer, coords, TILE_IDX_WALL, Vector2(rng.randi_range(1, 4), 4))
					continue
				if get_cell_source_id(layer, coords_right) == TILE_IDX_FLOOR:
					set_cell(layer, coords, TILE_IDX_WALL, Vector2(0, rng.randi_range(0, 3)))
					continue
				if get_cell_source_id(layer, coords_left) == TILE_IDX_FLOOR:
					set_cell(layer, coords, TILE_IDX_WALL, Vector2(5, rng.randi_range(0, 3)))
					continue		
									
				# Diagonals		
				if get_cell_source_id(layer, coords_top_right) == TILE_IDX_FLOOR:
					set_cell(layer, coords, TILE_IDX_WALL, Vector2(0, 4))
					continue
				if get_cell_source_id(layer, coords_top_left) == TILE_IDX_FLOOR:
					set_cell(layer, coords, TILE_IDX_WALL, Vector2(5, 4))
					continue
				if get_cell_source_id(layer, coords_bottom_right) == TILE_IDX_FLOOR:
					set_cell(layer, coords, TILE_IDX_WALL, Vector2(0, 0))
					continue
				if get_cell_source_id(layer, coords_bottom_left) == TILE_IDX_FLOOR:
					set_cell(layer, coords, TILE_IDX_WALL, Vector2(5, 0))
					continue

#
# Place a torch on a south facing wall
#
func _add_torch(x, y):
	var torch_node: = SCENE_TORCH.instantiate()
	torch_node.position.x = x * globals.GRID_SIZE
	torch_node.position.y = y * globals.GRID_SIZE+15
	torch_node.scale=torch_node.scale*0.7
	add_child(torch_node)
	torch_node.set_owner(self)

#
# Helper to pick an random open floor tile in given rect
# Returns a tuple/dict {x, y}
#
func get_random_floor_cell(left, top, width, height):
	# Build an array of all floor tiles inside given rect
	var cells = []
	for y in range(top, top + height):
		for x in range(left, left + width):
			var coords = Vector2i(x,y)
			if get_cell_source_id(layer, coords) == TILE_IDX_FLOOR:
				cells.push_back({"x": x, "y": y})
			
	# Pick one at random
	return cells[rng.randi_range(0, cells.size()-1)]
	

func lock_exits():
	exit.disable()
	entry.disable()
	

func unlock_exits():
	exit.enable()
	entry.enable()
	

func get_exit():
	return exit
	
func get_entry():
	return entry
