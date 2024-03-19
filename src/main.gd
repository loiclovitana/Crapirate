extends Node

const race_scene = preload("res://src/gamemode/race.tscn")
const player_scene = preload("res://src/player/boat.tscn")
const gps_scene = preload("res://src/player/view/gps.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_player_name(pid):
	%DynamicPlayerNameInput.get_player_name(pid)

func get_nb_player():
	return int(%NumberOfPlayer.get_value())

func get_vitesse():
	const vitesses = [5,10,15,20,10]
	
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

func _create_player(p_id:int) -> Boat:
	var player = player_scene.instantiate()
	
	# attributes
	player.player = 'p'+str(p_id)
	player.player_name = get_player_name(p_id)
	
	#stats
	player.speed_stat=get_vitesse()
	player.TIME_FOR_MAX_SPEED=get_acceleration()
	
	var maniability = get_maniability()
	player.TIME_TO_FULLTURN = maniability["turn"]
	player.TIME_TO_HAUL = maniability["haul"]
	player.TIME_TO_HELM = maniability["helm"]
	player.TIME_TO_HELM_STRAIGHT = maniability["helm_straight"]
	
	
	#camera
	var camera = StaticCamera.new()
	camera.set_position(Vector3(-6,10,0))
	for i in range(1,10):
		camera.set_cull_mask_value(PlayerView.PLAYER_VIEW_ID_OFFSET+i,false)
	camera.set_cull_mask_value(PlayerView.PLAYER_VIEW_ID_OFFSET+p_id,true)
	player.add_child(camera)
	
	#gps
	player.add_child(gps_scene.instantiate())
	
	return player
	

func _on_start_button_pressed() -> void:
	var race = race_scene.instantiate()
	
	for p_id in range(get_nb_player()):
		race.add_player(_create_player(p_id+1))
	
	add_child(race)
	%MainMenu.queue_free()
