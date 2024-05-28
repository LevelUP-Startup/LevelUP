extends Node2D

func _ready():
	globals.monster_free.connect(enable)

func _on_area_2d_body_entered(body):
	if body.name == "The_Player":
		queue_free()
		$"/root/Main".previous_level()

func get_respawns():
	return {
		"left":ceil($RespawnLeft.global_transform.get_origin().x/globals.GRID_SIZE), 
		"top":ceil($RespawnTop.global_transform.get_origin().y/globals.GRID_SIZE),
		"width":ceil(($RespawnRight.global_transform.get_origin().x/globals.GRID_SIZE - $RespawnLeft.global_transform.get_origin().x/globals.GRID_SIZE)), 
		"height":ceil(($RespawnBottom.global_transform.get_origin().y/globals.GRID_SIZE-$RespawnTop.global_transform.get_origin().y/globals.GRID_SIZE)),
		"exclude":Vector2(global_transform.get_origin().x,global_transform.get_origin().y)}


func disable():
	$StairUp.visible=false
	$StairBlocked.visible=true
	$Area2D.monitorable=false
	$Area2D.monitoring=false
	
func enable():
	$StairUp.visible=true
	$StairBlocked.visible=false
	$Area2D.monitorable=true
	$Area2D.monitoring=true
