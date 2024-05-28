extends Node

var player: CharacterBody2D
var map: TileMap
const GRID_SIZE = 64

signal monster_free
signal reduce_monsters_signal

enum level_direction {UP, DOWN}

var gold = 50
var depth = 0
var last_depth = 0
var kills = 0
var start_game = true
var level_monsters = 0

var gamedata = {}

func screenshot():
		var date = Time.get_datetime_dict_from_system()
		await RenderingServer.frame_post_draw
		
		var image:Image = player.get_node("Camera2D").get_viewport().get_texture().get_image()
		image.save_png("user://LevelUp_Status_%s-%s-%s_%s-%s-%s.png" % [date.year, date.month, date.day, date.hour, date.minute, date.second])
		globals.save_game()
		print("Data: %s"%globals.gamedata)
	

func persist_level(_depth):
	var packed_scene = PackedScene.new()
	packed_scene.pack(map)
	var scene_save = "user://dungeon_level_%s.tscn"%_depth
	print("Scene Saved: %s"%scene_save)
	ResourceSaver.save(packed_scene,scene_save)

func restore_level(_depth):
	var scene_load = "user://dungeon_level_%s.tscn"%_depth
	print("Scene Load: %s"%scene_load)
	var packed_scene = load(scene_load)
	var ret_map = packed_scene.instantiate()
	ret_map.is_loaded = true
	
	return ret_map

func save_game():
	gamedata["player"]=player
	gamedata["map"]=map
	gamedata["gold"]=gold
	gamedata["last_depth"]=last_depth
	gamedata["depth"]=depth
	gamedata["kills"]=kills
	gamedata["level_monsters"]=level_monsters

func reduce_monsters():
	reduce_monsters_signal.emit()
	level_monsters -= 1
	if level_monsters==0:
		monster_free.emit()
	
func reset():
	gold=50
	depth=0
	last_depth=0
	kills=0
	level_monsters=0
	start_game=true
	gamedata={}
