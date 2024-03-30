class_name PlayerInputSettings extends MarginContainer

const SET_INPUT_BUTTON_SCENE: PackedScene = preload ("res://src/interface/button/SetInputButton.tscn")
const GAMEPAD_ICON: Resource = preload ("res://ressources/ui/icon-gamepad.png")

var input_controller: InputBoatController

var remaping_button: SetInputButton = null
var remaping_action: String = ""
var remaping_append: bool = false

var _player_settings: PlayerSettings:
	get: return Settings.player_settings[input_controller.player_id]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not input_controller:
		# erase any settings that is not associated to an inputcontroller
		queue_free()
		return
		
	set_name(_player_settings.player_name)
	_create_input()
	%GamepadSelection.item_selected.connect(set_device)
	%KeyBoardButton.pressed.connect(clear_devices)

func _create_input():
	for c in %ListInputButton.get_children():
		if c is SetInputButton:
			c.queue_free()
	
	for action in input_controller.CONTROL_EVENTS:
		var new_button: SetInputButton = SET_INPUT_BUTTON_SCENE.instantiate()
		new_button.set_action_label(_format_action(action))
		_refresh_button_info(new_button, action)
		%ListInputButton.add_child(new_button)
		new_button.set_event.connect(_wait_for_event.bind(new_button, action))
		new_button.add_event.connect(_wait_for_event.bind(new_button, action, true))
		new_button.clear_event.connect(_clear_event.bind(new_button, action))

func _process(_delta):
	var joypads = Input.get_connected_joypads()
	if len(joypads) != %GamepadSelection.item_count:
		%GamepadSelection.clear()
		for i in joypads:
			%GamepadSelection.add_item(str(i + 1), GAMEPAD_ICON)

func _clear_event(button: SetInputButton, action: String):
	_player_settings.clear_action(action)
	_refresh_button_info(button, action)

func _format_action(action: String) -> String:
	if action in input_controller.ACTION_NAMES:
		return input_controller.ACTION_NAMES[action]
	return action
	
func _format_keys(keys: Array[InputEvent]) -> String:
	if keys.is_empty():
		return "<None>"
	var label = ""
	for k in keys:
		if label != "":
			label += ","
		label += k.as_text()
	return label.replace('(Physical)', '').rstrip(' ')

func _refresh_button_info(button, action):
	var keys = _player_settings.action_get_events(action)
	button.set_key_label(_format_keys(keys))

func _release_button():
	_refresh_button_info(remaping_button, remaping_action)
	remaping_button.set_pressed(false)
	remaping_button = null
	remaping_action = ""
	
func _wait_for_event(button: SetInputButton, action: String, append: bool=false):
	if remaping_button:
		_release_button()
	else:
		
		remaping_button = button
		remaping_action = action
		remaping_append = append
		button.set_key_label("Press Key to assign ...")
		button.release_focus()

func _input(event):
	if remaping_button:
		if (event is InputEventKey
			or event is InputEventMouseButton
			or event is InputEventJoypadButton
			or event is InputEventJoypadMotion
		):
			remaping_button.grab_focus()
			if event is InputEventMouseButton and event.double_click:
				event.double_click = false
			if remaping_append:
				_player_settings.add_action_event(remaping_action, event)
			else:
				_player_settings.set_action_event(remaping_action, event)
			_player_settings.save()
			
			_release_button()
			accept_event()

func set_device(idx: int):
	_player_settings.joypad_device_id = Input.get_connected_joypads()[idx]

func clear_devices():
	_player_settings.joypad_device_id = -1
	%GamepadSelection.deselect_all()
