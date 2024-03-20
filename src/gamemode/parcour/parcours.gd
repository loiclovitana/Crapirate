extends Node3D


var checkpoints : Array[RaceCheckpoint] = []
var starting_line : RaceLine
var finish_line : RaceLine
@onready var raceGame =get_parent()

var race_ranking: Array[Dictionary] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var last_checkpoint = null
	for child in get_children():
		if child is RaceCheckpoint:
			var checkpoint : RaceCheckpoint = child as RaceCheckpoint
			checkpoints.append(checkpoint)
			if last_checkpoint:
				last_checkpoint.next_checkpoint = checkpoint
				checkpoint.last_checkpoint=last_checkpoint
			last_checkpoint=checkpoint
	
	assert(len(checkpoints)!= 0,"No checkpoint are defined for the parcour")
	assert(checkpoints[0] is RaceLine,"First checkpoint need to be a line")
	assert(checkpoints[-1] is RaceLine,"Last checkpoint need to be a line")
	starting_line = checkpoints[0] as RaceLine
	finish_line = checkpoints[-1] as RaceLine
	
	starting_line._has_started=false 
	_change_starting_line_color(Color(1,0,0,1))
	
	
	finish_line.has_passed.connect(player_finished)
	
	# find all player in the scene
	for player in PlayersManagement.registered_players:
		add_player(player)
		
	PlayersManagement.new_player.connect(add_player)


func add_player(boat : Boat):
	starting_line.add_player(boat)
	boat.next_checkpoint = starting_line

func player_finished(boat : Boat):
	var player_time = raceGame.timer
	var won = race_ranking.is_empty()
	race_ranking.append(
		{
			"player":boat.player
			,"time":player_time
			,"rank":len(race_ranking)+1
		}
	)
	var new_record = HighScore.get_highest_score().is_empty() or player_time<HighScore.get_highest_score()[HighScore.TIME_IDX]
	boat.has_finished(player_time,won, new_record)
	
	HighScore.save_score(player_time,boat.player_name)
	

func _change_starting_line_color(color : Color):
	var material : Material = starting_line.lineMesh.get_active_material(0)
	if material and material is BaseMaterial3D:
		material.set_albedo(color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not starting_line._has_started:
		if get_parent().timer>=0:
			starting_line._has_started =true
			_change_starting_line_color(Color(0,1,0,1))
