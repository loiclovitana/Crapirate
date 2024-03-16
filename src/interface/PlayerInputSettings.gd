extends MarginContainer

var input_controller : InputBoatController 

const setInputButton : PackedScene = preload("res://src/interface/button/SetInputButton.tscn")


var remaping_button :Button = null
var remaping_action : String = ""
var old_key_label = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if input_controller:
		self.set_name(input_controller._player_name)
		_create_input()
	else:
		self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _create_input():
	for c in %ListInputButton.get_children():
		c.queue_free()
	
	for action in input_controller.control_event:
		var player_action : String = input_controller.get_player_action(action)
		var new_button = setInputButton.instantiate()
		new_button.set_action_label(_format_action(action))
		refresh_button_info(new_button, player_action)
		%ListInputButton.add_child(new_button)
		new_button.pressed.connect(_on_button_pressed.bind(new_button,player_action))


func _format_action(action :String) -> String:
	if action in input_controller.action_name:
		return input_controller.action_name[action]
	return action
	

func _format_keys(keys : Array[InputEvent]) -> String:
	if keys.is_empty():
		return "<None>"
	var label = ""
	for k in keys:
		if label!="":
			label += ","
		label+= k.as_text()
	return label.replace('(Physical)','').rstrip(' ')


func refresh_button_info(button, action):
	var keys = InputMap.action_get_events(action)
	button.set_key_label(_format_keys(keys))


func _release_button():
	refresh_button_info(remaping_button,remaping_action)
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

func _input(event):
	if remaping_button:
		if (event is InputEventKey
			or event is InputEventMouseButton
			or event is InputEventJoypadButton
			or event is InputEventJoypadMotion
		):
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
			
			if not InputMap.has_action(remaping_action):
				InputMap.add_action(remaping_action)
			InputMap.action_erase_events(remaping_action)
			InputMap.action_add_event(remaping_action,event)
			_release_button()
			accept_event()
