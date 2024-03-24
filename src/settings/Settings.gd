class_name Settings
extends Object
 

const DEFAULT_SETTINGS_PATH = "res://settings/config.cfg"
const USER_SETTINGS_PATH = "user://settings/config.cfg"



#region player
const SECTION_PLAYERS = "players"
static var nb_player: int = 1
static var player_configs: Array[PlayerSettings] = []

#region input
static var action_map: Dictionary = {}

#endregion


static func save():
	pass
	 
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
