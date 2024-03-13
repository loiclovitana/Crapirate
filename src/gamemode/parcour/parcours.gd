extends Node3D


var checkpoints : Array[RaceCheckpoint] = []
var starting_line : RaceLine
var finish_line : RaceLine

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
	
	# find all player in the scene
	# FIXME not very clean
	var boats = get_tree().get_root().find_children("*","Boat",true,false)
	for b in boats:
		starting_line.add_player(b)
		b.next_checkpoint = starting_line
		

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
