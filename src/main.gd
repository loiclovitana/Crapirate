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


func _on_start_button_pressed() -> void:
	var race = race_scene.instantiate()
	var player = player_scene.instantiate()
	var camera = StaticCamera.new()
	camera.set_position(Vector3(-6,10,0))
	for i in range(10,20):
		camera.set_cull_mask_value(PlayerView.PLAYER_VIEW_ID_OFFSET+i,false)
	camera.set_cull_mask_value(PlayerView.PLAYER_VIEW_ID_OFFSET+1,true)
	player.add_child(camera)
	player.add_child(gps_scene.instantiate())
	race.add_player(player)
	
	add_child(race)
	%MainMenu.queue_free()
