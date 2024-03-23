extends Object
class_name  PlayerSettings


const DIR_DEFAULT_PATH = "res://settings/player/"
const DIR_USER_PATH = "user://settings/player/"

#region STATIC ================================================================
static var all_preset :Dictionary = {} 

## get all available preset for players
static func get_all_player_presets() -> Dictionary:
	if all_preset.is_empty():
		## load all cfg in directory
		_get_presets_in(DIR_DEFAULT_PATH)
		_get_presets_in(DIR_USER_PATH)
	print(all_preset)
	return all_preset

static func _get_presets_in(directory_path):
	var dir = DirAccess.open(directory_path)
	if not dir:
		return {}
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			var config = ConfigFile.new()
			var err = config.load(directory_path+file_name)
			if err != OK:
				push_warning("Player setting file couldn't be loaded:\n\tFilename :%s\n\tDirectory: %s" % [file_name,directory_path])
			
			var preset_name_ = config.get_value("main","preset_name",file_name)
			all_preset[preset_name_] = directory_path+file_name
			
		file_name = dir.get_next()

#endregion ====================================================================


#region MAIN ================================================================
var preset_name : String = ""

#endregion

#region PLAYER DATA ============================================================
var player_name : String = ""
#endregion

#region INPUT DATA ============================================================
var _pid = ''
var pid : String :
	get:
		return _pid 
	set(value):
		_change_action_pid(_pid,value)
		_pid = value


func _change_action_pid(old_pid :String,new_pid :String):
	pass # TODO


var _joypad_device_id :int = -1
var joypad_device_id : int :
	get:
		return _joypad_device_id
	set(value):
		_change_action_device(_joypad_device_id,value)
		_joypad_device_id = value
		
func _change_action_device(old_device :int ,new_device :int ):
	pass # TODO
		

var _action_map : Dictionary = {}

## remove all event binded to that action
func clear_action(action :String):
	_action_map[action] = []
	if pid =="":
		return
	InputMap.action_erase_events(_get_player_action(action))

## Bind an event to the action
## Does not clear already binded event
func add_action_event(action,event : InputEvent):
	if action not in _action_map:
		_action_map[action]=[]
	_action_map[action].append(event)
	if pid =="":
		return
	# Only assign joypad button if the joypad is assigned
	if ( event is InputEventJoypadButton
			or event is InputEventJoypadMotion ) and joypad_device_id<0:
				return
	event.device = joypad_device_id
	var player_action = _get_player_action(action)
	if not InputMap.has_action(player_action):
		InputMap.add_action(player_action)
	InputMap.action_add_event(player_action,event)

## Set the action to the single event
## Clear all other event
func set_action_event(action :String,event : InputEvent):
	clear_action(action)
	add_action_event(action,event)
	
## Set the action to activate on the list of event.
## Clear all other event
func set_action_events(action :String,events :Array[InputEvent]):
	clear_action(action)
	for event in events:
		add_action_event(action,event)
## Get the action name for the player
func _get_player_action(action :String):
	return pid + "_" + action


