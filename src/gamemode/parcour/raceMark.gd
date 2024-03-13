class_name RaceMark
extends RaceCheckpoint

const DISTANCE_INDICATION : float = 1.0

enum GateType {TRIBORD, BABORD}
@export var type: GateType

@onready var mark : Node3D = get_children()[0] as Node3D

var boat_infos :Dictionary = {}

#region PUBLIC
# ===================== PUBLIC ==============================================

## return the position where the boat need to go to pass the checkpoint
func get_position_to_go() -> Vector3:
	var to_last_checkpoint :Vector3 = last_checkpoint.get_global_position() - mark.get_global_position() 
	var angle_mid_checkpoint = _get_angle_between_checkpoint()/2
	if type == GateType.TRIBORD:
		angle_mid_checkpoint = -angle_mid_checkpoint
	return mark.get_global_position() + DISTANCE_INDICATION*to_last_checkpoint.normalized().rotated(Vector3.UP,angle_mid_checkpoint)


## add player as the next mark in the race
func add_player(boat : Boat):
	super(boat)
	
	# Compute initial angle for the boat
	var boat_relative_position= To2DWorld.to_2d(boat.get_global_position() - get_global_position())
	var last_checkpoint_relative_position = To2DWorld.to_2d(last_checkpoint.get_global_position() - get_global_position() )
	
	var angle_done =last_checkpoint_relative_position.angle_to(boat_relative_position)
	if type == GateType.BABORD:
		angle_done= -angle_done
	
	var angle_checkpoint =  _get_angle_between_checkpoint()
	
	boat_infos[boat]={
			"last_relative_position" : boat_relative_position
			,"angle_todo" : (angle_checkpoint/2.0) - angle_done
		}
		
var __cache_angle_checkpoint : float = NAN
func _get_angle_between_checkpoint()-> float:
	if not is_nan(__cache_angle_checkpoint):
		return __cache_angle_checkpoint
	var next_checkpoint_relative_position = To2DWorld.to_2d(next_checkpoint.get_global_position() - get_global_position())
	var last_checkpoint_relative_position = To2DWorld.to_2d(last_checkpoint.get_global_position() - get_global_position())
	var angle_checkpoint = last_checkpoint_relative_position.angle_to(next_checkpoint_relative_position)
	if angle_checkpoint<0:
		angle_checkpoint += 2*PI
	if type == GateType.BABORD:
		angle_checkpoint = 2*PI - angle_checkpoint
	
	__cache_angle_checkpoint = angle_checkpoint
	return angle_checkpoint

## remove player from tracking this mark
func remove_player(boat : Boat):
	
	boat_infos.erase(boat)
	super(boat)

#============================================================================
#endregion


#region READY
# ===================== READY ==============================================

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#============================================================================
#endregion

#region PROCESS
# ===================== PROCESS ==============================================

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_detect_if_player_pass()
	super(delta)


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
		
# ============================================================================
#endregion
