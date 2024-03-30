class_name Parcours extends Node3D

signal player_has_finished(boat: Boat)

@onready var raceGame = get_parent()

var _checkpoints: Array[RaceCheckpoint] = []
var _starting_line: RaceLine
var _finish_line: RaceLine

func start():
	_starting_line.enable()

#region READY ================================================================
# Called when the node enters the scene tree for the first time.
func _ready():
	_setup_checkpoints()
	_setup_racelines()
	# Listen to finish line to get finishing players
	_finish_line.has_passed.connect(_player_finished)
	# Find all player in the scene
	for player in PlayersManagement.registered_players:
		_add_player(player)
	# Listen to new players to add them
	PlayersManagement.new_player.connect(_add_player)
	
func _setup_checkpoints():
	var last_checkpoint = null
	# Setup the checkpoints for this parcours
	for child in get_children():
		if child is RaceCheckpoint:
			var checkpoint: RaceCheckpoint = child as RaceCheckpoint
			_checkpoints.append(checkpoint)
		
			if last_checkpoint:
				last_checkpoint.next_checkpoint = checkpoint
				checkpoint.last_checkpoint = last_checkpoint
			last_checkpoint = checkpoint
	
	assert(len(_checkpoints) != 0, "No checkpoint are defined for the parcour")
	
func _setup_racelines():
	assert(_checkpoints[0] is RaceLine, "First checkpoint need to be a line")
	assert(_checkpoints[- 1] is RaceLine, "Last checkpoint need to be a line")
	
	_starting_line = _checkpoints[0] as RaceLine
	_finish_line = _checkpoints[- 1] as RaceLine
	_starting_line.disable()

func _add_player(boat: Boat):
	_starting_line.add_player(boat)
	boat.next_checkpoint = _starting_line

func _player_finished(boat: Boat):
	player_has_finished.emit(boat)
#endregion ====================================================================
