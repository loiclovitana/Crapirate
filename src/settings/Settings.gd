class_name Settings
extends Object
 

const DEFAULT_SETTINGS_PATH = "res://settings/config.cfg"
const USER_SETTINGS_DIR ="user://settings/"
const USER_SETTINGS_PATH = USER_SETTINGS_DIR+"config.cfg"


#region player
const SECTION_PLAYERS = "players"
static var _nb_player: int = 1
static var nb_player: int:
	get: return _nb_player
	set(value):
		if value>len(player_settings):
			for p_idx in range(_nb_player,value):
				var p_id = get_next_player_id()
				player_settings[p_id] = PlayerSettings.load(PlayerSettings.DEFAULT_JOYPAD_PRESET,p_id)
				player_settings[p_id].preset_name = p_id
		_nb_player=value
	
static var player_settings: Dictionary = {}

static func get_next_player_id():
	var all_ids = player_settings.keys()
	var max_p_id = int(all_ids.max())
	return "p"+str(max_p_id+1)

static func get_player_index(player_id : String) -> int:
	var all_ids = player_settings.keys()
	all_ids.sort()
	return all_ids.find(player_id)
	
static func get_player_id(idx: int) -> String:
	var all_ids = player_settings.keys()
	if all_ids.is_empty() or idx >len(all_ids):
		return ""
		
	all_ids.sort()
	return all_ids[idx]

static func get_player_settings(idx: int):
	var player_id = get_player_id(idx)
	if player_id not in player_settings:
		return null
	return player_settings[player_id]

# TODO
const SECTION_INPUT = "input"
static var action_map: Dictionary = {}

#endregion

## save the settings
static func save():
	var config = ConfigFile.new()
	
	config.set_value(SECTION_PLAYERS,"nb_players",nb_player)
	for p_id in player_settings:
		player_settings[p_id].save()
	var player_preset ={}
	for player_id in  player_settings:
		player_preset[player_id] = player_settings[player_id].preset_name
	config.set_value(SECTION_PLAYERS,"player_configs",player_preset)
	
	config.set_value(SECTION_INPUT,"action_map",action_map)
	
	DirAccess.make_dir_recursive_absolute(USER_SETTINGS_DIR)
	config.save(USER_SETTINGS_PATH)

## load the settings from file
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
	
	
	var player_configs_to_load = config.get_value(SECTION_PLAYERS,"player_configs",{})
	if not player_configs_to_load.is_empty():
		player_settings.clear()
		for player_config_id in player_configs_to_load:
			player_settings[player_config_id] = PlayerSettings.load(player_configs_to_load[player_config_id],player_config_id)
			print(player_settings[player_config_id].pid)
	nb_player = config.get_value(SECTION_PLAYERS,"nb_players",nb_player)
