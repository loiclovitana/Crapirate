class_name InputsSettings extends PanelContainer

const PLAYER_INPUT_SETTINGS_SCENE: PackedScene = preload ("res://src/interface/PlayerInputSettings.tscn")

var player_input_tab: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for player in PlayersManagement.registered_players:
		_create_player_input(player)
		
	PlayersManagement.new_player.connect(_create_player_input)
	PlayersManagement.player_left.connect(_remove_player_input)

func _create_player_input(player: Boat):
	var p_input_settings = PLAYER_INPUT_SETTINGS_SCENE.instantiate()
	player_input_tab[player] = p_input_settings
	p_input_settings.input_controller = player.controller
	%input_player_tab.add_child(p_input_settings)

func _remove_player_input(player: Boat):
	player_input_tab[player].queue_free()
	player_input_tab.erase(player)
