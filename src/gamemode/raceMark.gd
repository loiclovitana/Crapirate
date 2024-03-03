class_name RaceMark
extends Node3D

enum GateType {TRIBORD, BABORD}
@export var type: GateType

var _boats_to_cross : Array[Boat] = []


# Called when the node enters the scene tree for the first time.
func _ready():
	%Arrow.visible=false
	for child in %Arrow.get_children():
		for layer in range(1,20):
			child.set_layer_mask_value(layer,false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _boats_to_cross.is_empty():
		if %Arrow.visible:
			%Arrow.visible=false
	else:
		if not %Arrow.visible:
			%Arrow.visible

func add_player_(boat : Boat):
	_boats_to_cross.append(boat)
	for child in %Arrow.get_children():
		var p_id = boat.player
		child.set_layer_mask_value(10 +1 ,false)
	
