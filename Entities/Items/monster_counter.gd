extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	globals.reduce_monsters_signal.connect(_on_reduce_monsters)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if globals.level_monsters==0:
		visible=false
	else:
		visible = true
	pass

func _on_reduce_monsters():
	$Panel/CounterLabel.text = str(globals.level_monsters)
