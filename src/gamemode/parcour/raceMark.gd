class_name RaceMark
extends RaceCheckpoint

enum GateType {TRIBORD, BABORD}
@export var type: GateType



# Called when the node enters the scene tree for the first time.
func _ready():
	%Arrow.visible=false
	for child in %Arrow.get_children():
		for layer in range(1,20):
			child.set_layer_mask_value(layer,false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)
	if _boats_to_cross.is_empty():
		if %Arrow.visible:
			%Arrow.visible=false
	else:
		if not %Arrow.visible:
			%Arrow.visible=true

## add player as the next mark in the race
func add_player_(boat : Boat):
	super(boat)
	for child in %Arrow.get_children():
		var p_id = int(boat.player)
		if 0<p_id<10:
			child.set_layer_mask_value(10 +p_id ,true)
			
## remove player from tracking this mark
func remove_player(boat : Boat):
	super(boat)
	var p_id = int(boat.player)
	for child in %Arrow.get_children():
		if 0<p_id<10:
			child.set_layer_mask_value(10 +p_id ,false)
