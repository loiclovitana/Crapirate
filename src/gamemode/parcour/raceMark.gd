class_name RaceMark
extends RaceCheckpoint

enum GateType {TRIBORD, BABORD}
@export var type: GateType

@onready var mark : Node3D = get_children()[0] as Node3D

var boat_infos :Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	%Arrow.visible=false
	for child in %Arrow.get_children():
		for layer in range(1,20):
			child.set_layer_mask_value(layer,false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_detect_if_player_pass()
	super(delta)
	if _boats_to_cross.is_empty():
		if %Arrow.visible:
			%Arrow.visible=false
	else:
		if not %Arrow.visible:
			%Arrow.visible=true

## add player as the next mark in the race
func add_player(boat : Boat):
	super(boat)
	
	# Compute initial angle for the boat
	var boat_relative_position= To2DWorld.to_2d(boat.get_global_position() - get_global_position())
	var last_checkpoint_relative_position = To2DWorld.to_2d(last_checkpoint.get_global_position() - get_global_position() )
	
	var angle_done =last_checkpoint_relative_position.angle_to(boat_relative_position)
	if type == GateType.BABORD:
		angle_done= -angle_done
	
	if type == GateType.TRIBORD:
		pass
	var angle_checkpoint =  _get_angle_between_checkpoint()
	
	boat_infos[boat]={
			"last_relative_position" : boat_relative_position
			,"angle_todo" : (angle_checkpoint/2.0) - angle_done
		}
	
	for child in %Arrow.get_children():
		var p_id = int(boat.player)
		if 0<p_id and p_id<=10:
			child.set_layer_mask_value(10 +p_id ,true)
			
## remove player from tracking this mark
func remove_player(boat : Boat):
	
	boat_infos.erase(boat)
	super(boat)
	var p_id = int(boat.player)
	for child in %Arrow.get_children():
		if 0<p_id and p_id<=10:
			child.set_layer_mask_value(10 +p_id ,false)


func _get_angle_between_checkpoint()-> float:
	var next_checkpoint_relative_position = To2DWorld.to_2d(next_checkpoint.get_global_position() - get_global_position())
	var last_checkpoint_relative_position = To2DWorld.to_2d(last_checkpoint.get_global_position() - get_global_position())
	var angle_checkpoint = last_checkpoint_relative_position.angle_to(next_checkpoint_relative_position)
	if angle_checkpoint<0:
		angle_checkpoint += 2*PI
	if type == GateType.BABORD:
		angle_checkpoint = 2*PI - angle_checkpoint
	return angle_checkpoint

func _detect_if_player_pass():
	for boat in _boats_to_cross:
		var boat_relative_position = To2DWorld.to_2d(boat.get_global_position() - get_global_position())
		var angle_delta =  boat_relative_position.angle_to(boat_infos[boat]["last_relative_position"])
		if type == GateType.TRIBORD:
			angle_delta= -angle_delta
		if type == GateType.TRIBORD:
			pass
		boat_infos[boat]["angle_todo"] -= angle_delta
		boat_infos[boat]["last_relative_position"] = boat_relative_position
		if boat_infos[boat]["angle_todo"]<0:
			_pass_checkpoint(boat)
		
		
		
