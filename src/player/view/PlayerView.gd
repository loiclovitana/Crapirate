extends SubViewportContainer
class_name PlayerView

const PLAYER_VIEW_ID_OFFSET = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_observer(node : Node):
	assert(%playerView.get_child_count()==0)
	if node.get_parent():
		node.reparent(%playerView)
	else:
		%playerView.add_child(node)
