class_name RaceGate
extends Node3D

enum GateType {TRIBORD, BABORD}
@export var type: GateType

var boats_to_cross : Array[Boat] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if boats_to_cross.is_empty():
		return
	
