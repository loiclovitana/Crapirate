class_name RaceCheckpoint
extends Node3D


var _boats_to_cross : Array[Boat] = []
var next_checkpoint : RaceCheckpoint
var last_checkpoint : RaceCheckpoint

signal has_passed(boat)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _pass_checkpoint(boat : Boat):
	remove_player(boat)
	has_passed.emit(boat)
	if next_checkpoint:
		next_checkpoint.add_player(boat)

## add player as the next mark in the race
func add_player(boat : Boat):
	_boats_to_cross.append(boat)

## remove player from tracking this mark
func remove_player(boat : Boat):
	_boats_to_cross.erase(boat)
