extends Control

const OPT_START = 0
const OPT_LOAD = 1
const OPT_CREDITS = 2
const OPT_EXIT = 3

var _selected = 0
var _old_selected = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start():
	# TODO:
	# delete_saved_maps()
	$AnimationPlayer.play("Init")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		if _selected == OPT_START:
			# Let the player know what is happening
			var Label0 = $Plank0/Label0
			Label0.text = "Generating Dungeon ..."
			Label0.modulate = Color.LAWN_GREEN
			$pointer.visible = false
			# Without this, the label change is never visible before the scene switch
			await get_tree().process_frame
			# Now start the game by switching to the main scene
			globals.reset()
			get_tree().change_scene_to_file("res://scenes/City/City.tscn")
			
		if _selected == OPT_LOAD:
			pass
		if _selected == OPT_CREDITS:
			pass
		if _selected == OPT_EXIT:
			get_tree().quit()
			
	if Input.is_action_just_pressed("ui_down"):
		_old_selected = _selected
		_selected += 1
	if Input.is_action_just_pressed("ui_up"):
		_old_selected = _selected
		_selected -= 1
				
	if _selected > OPT_EXIT: 
		_selected = OPT_START
	if _selected < OPT_START: 
		_selected = OPT_EXIT
			
	# Move pointer next to selected option label
	var labelNode:Sprite2D = get_node("Plank"+str(_selected))
	$pointer.position.y = labelNode.position.y 
	$pointer.position.x = labelNode.position.x - (labelNode.get_rect().size.x / 2 + 5)
	
	# Change the animation which makes the labels "glow"
	var ani = $PointerAnimation.get_animation("selected")
	get_node("Plank"+str(_old_selected)+"/Label"+str(_old_selected)).modulate = Color.WHITE
	# We can modify the property the animation path animates on the fly, how clever!
	ani.track_set_path(1, "Plank"+str(_selected)+"/Label"+str(_selected)+":modulate")				

func start_UI():
	$PointerAnimation.play("selected")

func _on_button_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _novo_jogo():
	get_tree().change_scene_to_file("res://scenes/City/City.tscn")
	pass # Replace with function body.


func _carregar_jogo():
	get_tree().change_scene_to_file("res://scenes/City/City.tscn")
	pass # Replace with function body.


func _creditos():
	pass # Replace with function body.
