class_name SetInputButton extends HBoxContainer

signal add_event
signal set_event
signal clear_event

func _ready():
	%SetInputButton.pressed.connect(func(): set_event.emit())
	%AddButton.pressed.connect(func(): add_event.emit())
	%ClearButton.pressed.connect(func(): clear_event.emit())
	

func set_action_label(label :String):
	%ActionLabel.set_text(label)
	
func set_key_label(label :String):
	%KeyLabel.set_text(label)

func set_pressed(is_pressed: bool):
	%SetInputButton.set_pressed(is_pressed)
