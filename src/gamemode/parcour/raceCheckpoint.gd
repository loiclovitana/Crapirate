class_name RaceCheckpoint
extends Node3D


var _boats_to_cross : Array[Boat] = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## add player as the next mark in the race
func add_player_(boat : Boat):
	_boats_to_cross.append(boat)
			
## remove player from tracking this mark
func remove_player(boat : Boat):
	_boats_to_cross.erase(boat)
