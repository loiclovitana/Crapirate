class_name BoatCanvas extends CanvasLayer

const WIN_LOSE_HUD_SCENE: PackedScene = preload ("res://src/player/hud/FinishRaceHud.tscn")
const PLAYER_NAME_LABEL_SCENE: PackedScene = preload ("res://src/player/hud/PlayerNameLabel.tscn")

@onready var boat: Boat = get_parent()

@onready var _player_tags = {}
@onready var _players_cameras: Array[Camera3D] = []

## display the stats in debug mode
func debug_set_stats(statsDisplayText):
	%StatsDisplay.set_visible(true)
	%StatsDisplay.set_text(statsDisplayText)

## display the end screen. with time
func display_finish_screen(time: float, win: bool=true, is_record: bool=false):
	var win_hud = WIN_LOSE_HUD_SCENE.instantiate()
	add_child(win_hud)
	win_hud.set_winning(win)
	win_hud.set_end_time(time, is_record)

#region READY ================================================================
# Called when the node enters the scene tree for the first time.
func _ready():
	%PlayerNameHUD.set_text(boat.player_name)
	
	# get all camera used by player
	for camera in boat.find_children("*", "Camera3D", true, false):
		var camera3d = camera as Camera3D
		_players_cameras.append(camera3d)
	
	# registered player needs a tag for their name
	PlayersManagement.new_player.connect(_add_player_tag)
	PlayersManagement.player_left.connect(_remove_player_tag)
	for player in PlayersManagement.get_registered_players():
		_add_player_tag(player)
		
func _remove_player_tag(player):
	if player in _player_tags:
		_player_tags[player].queue_free()
		_player_tags.erase(player)
		
func _add_player_tag(player):
	if boat != player:
		var label = PLAYER_NAME_LABEL_SCENE.instantiate()
		label.set_playername(player.player_name)
		_player_tags[player] = label
		%OtherPlayersName.add_child(label)
#endregion ===================================================================

#region PROCESS ==============================================================
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_update_hud()
	_update_players_name()

func _update_hud():
	if 0 < boat._helm_direction:
		%helmLeftView.set_value(abs(boat._helm_direction) * 100)
		%helmRightView.value = 0
	if boat._helm_direction < 0:
		%helmLeftView.value = 0
		%helmRightView.value = abs(boat._helm_direction) * 100
	if is_zero_approx(boat._helm_direction):
		%helmLeftView.value = 0
		%helmRightView.value = 0
	
	%haulView.value = boat._sail_haul * 100
	
	var speed_in_knot = boat._current_speed * 1.5
	%SpeedDisplay.set_text("%3.1f KTS" % speed_in_knot)

func _update_players_name():
	var current_camera = _find_current_camera()
	if not current_camera:
		return
	
	for other_player in _player_tags:
		var player_tag_position = other_player.renderer.get_name_tag_position()
		var label = _player_tags[other_player]
		var player_is_visible = not current_camera.is_position_behind(player_tag_position)
		label.set_visible(player_is_visible)
		if player_is_visible:
			var projected_position = current_camera.unproject_position(player_tag_position)
			
			label.set_position(projected_position)

func _find_current_camera() -> Camera3D:
	if _players_cameras.is_empty():
		return null
	for camera in _players_cameras:
		if camera.is_current():
			return camera
	return null
#endregion ===================================================================
