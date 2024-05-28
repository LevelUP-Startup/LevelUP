extends Node2D

func _ready():
	globals.monster_free.connect(enable)
	print_debug("Initialising Exit")

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		queue_free()
		var mainNode = get_node("/root/Main")
		if(mainNode!=null):
			$"/root/Main".next_level()
		else:
			get_tree().change_scene_to_file("res://Scenes/UI/Main.tscn")

func get_respawns():
	return {
		"left":ceil($RespawnLeft.global_transform.get_origin().x/globals.GRID_SIZE), 
		"top":ceil($RespawnTop.global_transform.get_origin().y/globals.GRID_SIZE),
		"width":ceil(($RespawnRight.global_transform.get_origin().x/globals.GRID_SIZE - $RespawnLeft.global_transform.get_origin().x/globals.GRID_SIZE)), 
		"height":ceil(($RespawnBottom.global_transform.get_origin().y/globals.GRID_SIZE-$RespawnTop.global_transform.get_origin().y/globals.GRID_SIZE)),
		"exclude":Vector2(global_transform.get_origin().x,global_transform.get_origin().y)}

func disable():
	$StairDown.visible=false
	$StairBlocked.visible=true
	$Area2D.monitorable=false
	$Area2D.monitoring=false
	
func enable():
	$StairDown.visible=true
	$StairBlocked.visible=false
	$Area2D.monitorable=true
	$Area2D.monitoring=true
