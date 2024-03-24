class_name PlayerView extends SubViewportContainer

const PLAYER_VIEW_ID_OFFSET = 10

func set_observer(node : Node):
	assert(%playerView.get_child_count() == 0)
	if node.get_parent():
		node.reparent(%playerView)
	else:
		%playerView.add_child(node)
