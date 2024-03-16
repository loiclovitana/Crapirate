extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_action_label(label :String):
	%ActionLabel.set_text(label)
	
func set_key_label(label :String):
	%KeyLabel.set_text(label)
