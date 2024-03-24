class_name RaceCheckpoint extends Node3D

signal has_passed(boat: Boat)

var next_checkpoint: RaceCheckpoint
var last_checkpoint: RaceCheckpoint

var _boats_to_cross: Array[Boat] = []

#region PUBLIC ================================================================
## add player as the next mark in the race
func add_player(boat : Boat):
	_boats_to_cross.append(boat)

## remove player from tracking this mark
func remove_player(boat : Boat):
	_boats_to_cross.erase(boat)

## return the position where the boat need to go to pass the checkpoint
func get_position_to_go() -> Vector3:
	return get_global_position()
#endregion ====================================================================

#region PROTECTED =============================================================
func _pass_checkpoint(boat: Boat):
	remove_player(boat)
	boat.next_checkpoint = next_checkpoint
	has_passed.emit(boat)
	if next_checkpoint:
		next_checkpoint.add_player(boat)
#endregion ====================================================================

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
