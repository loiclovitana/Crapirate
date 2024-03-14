extends TextureButton
class_name EventButton

@export var event_name : String
@export var event_data : Dictionary = {}

signal pressed_event(event_name : String, event_data : Dictionary)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self._button_pressed)
	if event_name =="":
		push_warning("The button %s does not have an event" % self.get_name())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _button_pressed():
	pressed_event.emit(event_name,event_data)
