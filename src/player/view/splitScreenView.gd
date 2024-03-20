extends HBoxContainer

const sub_view_player_container : PackedScene = preload("res://src/player/view/sub_viewport_player_container.tscn")

var _next_child = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for player in get_children():
		if player is Boat:
			add_player(player)



func add_player(player : Boat):
	var playerView = sub_view_player_container.instantiate()
	
	var vertical_split : Node = get_child(_next_child%2)
	_next_child += 1
	
	vertical_split.set_visible(true)
	
	vertical_split.add_child(playerView)
	
	playerView.set_observer(player)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
