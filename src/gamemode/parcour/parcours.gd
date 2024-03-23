class_name Parcours extends Node3D

signal player_has_finished(boat: Boat)

@onready var raceGame = get_parent()

var _checkpoints: Array[RaceCheckpoint] = []
var _starting_line: RaceLine
var _finish_line: RaceLine
var _race_started: bool = false

func start():
	_starting_line.enable()

#region READY
# ===================== READY ==============================================
# Called when the node enters the scene tree for the first time.
func _ready():
	self._setup_checkpoints()
	self._setup_racelines()
	# Listen to finish line to get finishing players
	self._finish_line.has_passed.connect(self._player_finished)
	# Find all player in the scene
	for player in PlayersManagement.registered_players:
		self._add_player(player)
	# Listen to new players to add them
	PlayersManagement.new_player.connect(self._add_player)
	
func _setup_checkpoints():
	var last_checkpoint = null
	# Setup the checkpoints for this parcours
	for child in get_children():
		if child is RaceCheckpoint:
			var checkpoint: RaceCheckpoint = child as RaceCheckpoint
			self._checkpoints.append(checkpoint)
		
			if last_checkpoint:
				last_checkpoint.next_checkpoint = checkpoint
				checkpoint.last_checkpoint = last_checkpoint
			last_checkpoint = checkpoint
	
	assert(len(_checkpoints) != 0,"No checkpoint are defined for the parcour")
	
func _setup_racelines():
	assert(_checkpoints[0] is RaceLine, "First checkpoint need to be a line")
	assert(_checkpoints[-1] is RaceLine, "Last checkpoint need to be a line")
	
	self._starting_line = _checkpoints[0] as RaceLine
	self._finish_line = _checkpoints[-1] as RaceLine
	self._starting_line.disable()

func _add_player(boat: Boat):
	_starting_line.add_player(boat)
	boat.next_checkpoint = _starting_line

func _player_finished(boat: Boat):
	self.player_has_finished.emit(boat)
#============================================================================
#endregion
