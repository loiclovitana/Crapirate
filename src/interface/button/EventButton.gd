class_name EventButton extends TextureButton

signal pressed_event(event_name: String, event_data: Dictionary)

@export var event_name : String
@export var event_data : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(_button_pressed)
	if event_name =="":
		push_warning("The button %s does not have an event" % get_name())

func _button_pressed():
	pressed_event.emit(event_name, event_data)
