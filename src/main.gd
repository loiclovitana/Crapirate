extends Node

const race_scene = preload("res://src/gamemode/Race.tscn")
const player_scene = preload("res://src/player/Boat.tscn")
const gps_scene = preload("res://src/player/view/GPS.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Settings.load()
	%NumberOfPlayer.set_value(Settings.nb_player)
	%NumberOfPlayer.value_changed.connect(
		func(value):
			Settings.nb_player=value
			)
	
	
## Handle notification (such as quit)
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Settings.save()
		get_tree().quit() # default behavior
		
var current_game_preset : Dictionary ={}
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	#update MainMenu
	if %MainMenu.is_visible:
		var new_preset = get_game_preset()
		if new_preset != current_game_preset:
			current_game_preset=new_preset
			var high_scores = HighScore.load_high_score(str(new_preset))
			%RecordsDisplay.set_highscores(high_scores)


func get_nb_player():
	return Settings.nb_player

func get_camera_distance():
	return int(%CameraDistance.get_value())

func get_camera_hauteur():
	return int(%CameraHauteur.get_value())

func get_vitesse():
	const vitesses = [6, 10, 16, 22, 10]
	
	var vitesse_selected = -1
	for idx in  range(%VitesseSelection.get_item_count()):
		if %VitesseSelection.is_selected(idx):
			vitesse_selected = idx
	return vitesses[vitesse_selected]

func get_acceleration():
	const time_max_speed = [20,10,6,3,10]
	
	var acc_selected = -1
	for idx in  range(%AccelerationSelection.get_item_count()):
		if %AccelerationSelection.is_selected(idx):
			acc_selected = idx
	return time_max_speed[acc_selected]

func get_maniability():
	const time_to_turn = [12,7.5,5,7.5,7.5]
	const time_to_haul = [3,3,1,0.1,3]
	const time_to_helm = [1,1.5,1.5,0.5,1.5]
	const time_to_helm_straight = [2,2.5,2.5,1,2.5]
	
	var m_selected = -1
	for idx in  range(%ManiabilitySelection.get_item_count()):
		if %ManiabilitySelection.is_selected(idx):
			m_selected = idx
	return {
		"turn":time_to_turn[m_selected]
		,"haul":time_to_haul[m_selected]
		,"helm":time_to_helm[m_selected]
		,"helm_straight":time_to_helm_straight[m_selected]
	}

func _create_player(player_id:String ,game_preset) -> Boat:
	var player = player_scene.instantiate()
	
	
	# attributes
	player.player_id = player_id
	player.player_name = Settings.player_settings[player_id].player_name
	player.controller =  InputBoatController.new(player)
	#stats
	player.speed_stat=game_preset['speed_stat']
	player.TIME_FOR_MAX_SPEED=game_preset['TIME_FOR_MAX_SPEED']
	
	var maniability = game_preset['maniability']
	player.TIME_TO_FULLTURN = maniability["turn"]
	player.TIME_TO_HAUL = maniability["haul"]
	player.TIME_TO_HELM = maniability["helm"]
	player.TIME_TO_HELM_STRAIGHT = maniability["helm_straight"]
	
	
	#camera
	var camera = OrientedCamera.new()
	player.add_child(camera)
	camera.set_position(Vector3(0,get_camera_hauteur(),get_camera_distance()))
	
	var p_view_id = PlayerView.PLAYER_VIEW_ID_OFFSET +Settings.get_player_index(player_id)
	for layer_id in range(PlayerView.PLAYER_VIEW_ID_OFFSET, PlayerView.PLAYER_VIEW_ID_OFFSET_END):
		camera.set_cull_mask_value(layer_id,layer_id==p_view_id)
	
	
	#gps
	player.add_child(gps_scene.instantiate())
	
	return player
	
## process sent event
func process_event(event_name,_event_data):
	match event_name:
		"restart" : 
			%MainMenu.set_visible(true)
			var high_scores = HighScore.load_high_score(str(current_game_preset))
			%RecordsDisplay.set_highscores(high_scores)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		_ :push_warning("event %s is not handled" % event_name)
		

func get_game_preset() -> Dictionary:
	return {
		"speed_stat" = get_vitesse()
		,"TIME_FOR_MAX_SPEED" = get_acceleration()
		,"maniability" = get_maniability()
	}

func _on_start_button_pressed() -> void:
	
	var game_preset =get_game_preset()
	
	HighScore.load_high_score(str(game_preset))
	
	var race = race_scene.instantiate()
	add_child(race)
	
	for p_idx in range(Settings.nb_player):
		race.add_player(_create_player(Settings.get_player_id(p_idx),game_preset))
	
	%MainMenu.set_visible(false)
	race.send_event.connect(process_event)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
