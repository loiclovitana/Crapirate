extends HBoxContainer

const sub_view_player_container : PackedScene = preload("res://src/player/view/sub_viewport_player_container.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var players = []
	for player in get_children():
		var playerView = sub_view_player_container.instantiate()
		self.add_child(playerView)
		playerView.set_observer(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
