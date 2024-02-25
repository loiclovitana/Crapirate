extends Node


var camera_rel_position: Vector3 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera_rel_position= %Camera.get_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	%Camera.set_position(%Boat.get_position() +camera_rel_position)
