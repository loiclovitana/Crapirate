class_name PlayerInputSettings extends MarginContainer

const SET_INPUT_BUTTON_SCENE: PackedScene = preload("res://src/interface/button/SetInputButton.tscn")

var input_controller: InputBoatController 

var remaping_button: Button = null
var remaping_action: String = ""
var old_key_label = ""

var _player_settings: PlayerSettings:
	get: return Settings.player_settings[input_controller.player_id]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if input_controller:
		set_name(_player_settings.player_name)
		_create_input()
	else:
		queue_free()

func _create_input():
	for c in %ListInputButton.get_children():
		c.queue_free()
	
	for action in input_controller.CONTROL_EVENTS:
		var new_button = SET_INPUT_BUTTON_SCENE.instantiate()
		new_button.set_action_label(_format_action(action))
		_refresh_button_info(new_button, action)
		%ListInputButton.add_child(new_button)
		new_button.pressed.connect(_on_button_pressed.bind(new_button,action))

func _format_action(action: String) -> String:
	if action in input_controller.ACTION_NAMES:
		return input_controller.ACTION_NAMES[action]
	return action
	

func _format_keys(keys: Array[InputEvent]) -> String:
	if keys.is_empty():
		return "<None>"
	var label = ""
	for k in keys:
		if label!="":
			label += ","
		label+= k.as_text()
	return label.replace('(Physical)','').rstrip(' ')


func _refresh_button_info(button, action):
	var keys = _player_settings.action_get_events(action)
	button.set_key_label(_format_keys(keys))


func _release_button():
	_refresh_button_info(remaping_button,remaping_action)
	remaping_button.set_pressed(false)
	remaping_button=null
	remaping_action = ""
	
func _on_button_pressed(button : Button, action :String):
	if remaping_button:
		_release_button()
	
	if button.is_pressed():
		remaping_button=button
		remaping_action=action
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
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
			
			_player_settings.set_action_event(remaping_action,event)
			_player_settings.save()
			
			_release_button()
			accept_event()
			
