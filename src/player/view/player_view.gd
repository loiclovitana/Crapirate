extends SubViewportContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_observer(node : Node):
	assert(%playerView.get_child_count()==0)
	if node.owner:
		node.reparent(%playerView)
	else:
		%playerView.add_child(node)
