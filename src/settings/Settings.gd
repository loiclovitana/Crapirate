class_name Settings
extends Object
 

const DEFAULT_SETTINGS_PATH = "res://settings/config.cfg"
const USER_SETTINGS_DIR ="user://settings/"
const USER_SETTINGS_PATH = USER_SETTINGS_DIR+"config.cfg"



#region player
const SECTION_PLAYERS = "players"
static var nb_player: int = 1
static var player_configs: Dictionary = {}

# TODO
const SECTION_INPUT = "input"
static var action_map: Dictionary = {}

#endregion


static func save():
	var config = ConfigFile.new()
	
	config.set_value(SECTION_PLAYERS,"nb_players",nb_player)
	for p_c in player_configs:
		p_c.save()
	var player_preset = player_configs.values().map(func(x) : return x.preset_name)
	config.set_value(SECTION_PLAYERS,"player_configs",player_preset)
	
	config.set_value(SECTION_INPUT,"action_map",action_map)
	
	DirAccess.make_dir_recursive_absolute(USER_SETTINGS_DIR)
	config.save(USER_SETTINGS_PATH)
	 
static func load():
	_load(DEFAULT_SETTINGS_PATH)
	_load(USER_SETTINGS_PATH)

static func _load(path):
	var config = ConfigFile.new()
	var err = config.load(path)
	if err != OK and err!=Error.ERR_FILE_NOT_FOUND :
		push_warning(
			"Couldn't load player settings : \n%s\nError : %s" % [path,error_string(err)]
		)
		return
	
	nb_player = config.get_value(SECTION_PLAYERS,"nb_players",nb_player)
	var player_configs_to_load = config.get_value(SECTION_PLAYERS,"player_configs",[])
	if not player_configs_to_load.is_empty():
		player_configs.clear()
		for player_config_preset in player_configs_to_load:
			player_configs[] = PlayerSettings.load(player_config_preset)
