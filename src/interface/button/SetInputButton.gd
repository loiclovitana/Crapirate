extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(self._button_pressed) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func set_action_label(label :String):
	%ActionLabel.set_text(label)
	
func set_key_label(label :String):
	%KeyLabel.set_text(label)

func _button_pressed():
	self.release_focus()
