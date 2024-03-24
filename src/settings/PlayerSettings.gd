extends RefCounted
class_name  PlayerSettings


const DIR_DEFAULT_PATH: String = "res://settings/player/"
const DIR_USER_PATH: String = "user://settings/player/"

const SECTION_MAIN: String = "main"
const SECTION_PLAYER_DATA: String = "player_data"
const SECTION_INPUT: String = "input"


#region STATIC ================================================================
static var all_preset :Dictionary = {} 

## get all available preset for players
static func get_all_player_presets() -> Dictionary:
	if all_preset.is_empty():
		## load all cfg in directory
		_get_presets_in(DIR_DEFAULT_PATH)
		_get_presets_in(DIR_USER_PATH)
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
				push_warning("Player setting file couldn't be loaded:\n\tFilename :%s\n\tDirectory: %s\nError : " % [file_name,directory_path,error_string(err)])
			
			var preset_name_ = config.get_value(SECTION_MAIN,"preset_name",file_name.replace('.cfg',''))
			all_preset[preset_name_] = directory_path+file_name
			
		file_name = dir.get_next()


static func load(preset_name : String, pid = "") -> PlayerSettings:
	
	var player_settings = PlayerSettings.new()
	var loaded_player_settings = ConfigFile.new()
	#Load and check error
	if preset_name not in get_all_player_presets():
		push_warning("Preset %s does not exists" % preset_name)
	else:
		var err = loaded_player_settings.load(all_preset[preset_name])
		if err != OK:
			push_warning(
				"Couldn't load player settings %s : \n%s\nError : %s" % [preset_name,all_preset[preset_name],error_string(err)]
			)
	
	# main
	player_settings.preset_name =preset_name
	
	# player_data
	player_settings.player_name = loaded_player_settings.get_value(SECTION_PLAYER_DATA,"player_name","Player "+str(int(pid)))
	
	# input_data
	player_settings.pid = pid
	player_settings.joypad_device_id = loaded_player_settings.get_value(SECTION_INPUT,"joypad_device_id",-1)
	var action_map = loaded_player_settings.get_value(SECTION_INPUT,"action_map",{})
	for action in action_map:
		player_settings.set_action_events(action,action_map[action])
	
	return player_settings

#endregion ====================================================================

func save():
	var player_settings_file = DIR_USER_PATH + '/' + preset_name.validate_filename()+'.cfg'
	var saved_player_settings = ConfigFile.new()
	
	# main
	saved_player_settings.set_value(SECTION_MAIN,"preset_name",preset_name)
	
	# player_data
	saved_player_settings.set_value(SECTION_PLAYER_DATA,"player_name",player_name)
	
	# input_data
	saved_player_settings.set_value(SECTION_INPUT,"joypad_device_id",joypad_device_id)
	saved_player_settings.set_value(SECTION_INPUT,"action_map",_action_map)
	
	DirAccess.make_dir_recursive_absolute( DIR_USER_PATH )
	saved_player_settings.save(player_settings_file)


#region MAIN ================================================================
var preset_name : String = ""

#endregion

#region PLAYER DATA ============================================================
var player_name : String = ""
#endregion

#region INPUT DATA ============================================================
#check that there does not exist 2 settings with the same pid
static var assigned_pids :Array[String] = []

#region pid
var _pid = ''
## represent an id of the player
var pid : String :
	get:
		return _pid 
	set(value):
		if value in assigned_pids:
			value = assigned_pids.max()+"_copy"
		assigned_pids.append(value)
		assigned_pids.erase(_pid)
		_pid = value
		_change_action_pid(_pid,value)
		

## change all action to the new pid
func _change_action_pid(old_pid :String,new_pid :String):
	for action in _action_map:
		# remove old binding
		if old_pid!="":
			InputMap.action_erase_events(_get_player_action(action,old_pid))
		
		# recreates new binding
		for event in _action_map[action]:
			_bind_action_event(_get_player_action(action,new_pid),event)
#endregion

#region joypad_device_id
var _joypad_device_id :int = -1
#joypad used by player
var joypad_device_id : int :
	get:
		return _joypad_device_id
	set(value):
		_joypad_device_id = value
		_change_action_device(_joypad_device_id,value)
		
		
func _change_action_device(old_device: int, new_device: int):
	for action in _action_map:
		if pid!="":
			InputMap.action_erase_events(_get_player_action(action,pid))
			for event in _action_map[action]:
				_bind_action_event(_get_player_action(action),event)
#endregion

#region action_map
var _action_map : Dictionary = {}

## remove all event binded to that action
func clear_action(action :String):
	
	if pid =="":
		_action_map[action] = []
		return
	InputMap.action_erase_events(_get_player_action(action))

## Bind an event to the action
## Does not clear already binded event
func add_action_event(action: String, event: InputEvent):
	if action not in _action_map:
		_action_map[action]=[]
	_action_map[action].append(event)
	if pid =="":
		return
	
	var player_action = _get_player_action(action)
	_bind_action_event(player_action,event)

func _bind_action_event(player_action,event):
	# Only assign joypad button if the joypad is assigned
	if ( event is InputEventJoypadButton
			or event is InputEventJoypadMotion ) and joypad_device_id<0:
				return
	event.device = joypad_device_id
	if not InputMap.has_action(player_action):
		InputMap.add_action(player_action)
	InputMap.action_add_event(player_action,event)

## Set the action to the single event
## Clear all other event
func set_action_event(action: String, event: InputEvent):
	clear_action(action)
	add_action_event(action,event)
	
## Set the action to activate on the list of event.
## Clear all other event
func set_action_events(action: String, events: Array[InputEvent]):
	clear_action(action)
	for event in events:
		add_action_event(action,event)

## Get the action name for the player
func _get_player_action(action: String, pid: String = ""):
	if pid=="":
		pid = self.pid
	return pid + "_" + action
#endregion

#endregion

