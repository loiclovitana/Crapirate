extends MarginContainer

@onready var input_controller : InputBoatController =  InputBoatController.new('p1') 

const setInputButton  = preload("res://src/interface/button/SetInputButton.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(input_controller)
	self.set_name(input_controller._player_name)
	_refresh_input()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _refresh_input():
	for action in input_controller.control_event:
		var new_button = setInputButton.instantiate()
		new_button.set_action_label(action)
		var keys = InputMap.action_get_events(input_controller.get_player_action(action))
		new_button.set_key_label(_format_keys(keys))
		%ListInputButton.add_child(new_button)


func _format_keys(keys : Array[InputEvent]) -> String:
	if keys.is_empty():
		return "<None>"
	var label = ""
	for k in keys:
		if label!="":
			label += ","
		label+= k.as_text()
	return label
