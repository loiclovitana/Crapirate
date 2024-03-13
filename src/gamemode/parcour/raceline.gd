class_name RaceLine extends RaceCheckpoint


@export var portMark : Node3D ## Mark that define the port side of the line
@export var startbordMark : Node3D ## Mark that define the starboard side of the line

@onready var _line : RayCast3D = %Line
@onready var lineMesh : MeshInstance3D = %LineVisual

var _has_started = true



## return the position where the boat need to go to pass the checkpoint
func get_position_to_go() -> Vector3:
	return (portMark.get_global_position() +startbordMark.get_global_position()) /2 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_raycast_position()
	_update_mesh_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	_update_raycast_position()
	_update_mesh_position()
	_detect_if_player_pass()

func _update_mesh_position():
	var new_position = (portMark.get_global_position() +startbordMark.get_global_position()) /2 
	lineMesh.set_global_position(new_position)
	
	lineMesh.mesh.set_height((portMark.get_global_position() -startbordMark.get_global_position()).length())
	
	var line_vector = (portMark.get_global_position() -startbordMark.get_global_position())
	var angle_line = Vector2(line_vector.x,line_vector.z).angle()
	lineMesh.set_global_rotation(Vector3(0,-angle_line,PI/2))
	
	
func _update_raycast_position():
	_line.set_global_position(portMark.get_global_position())
	_line.set_target_position(_line.to_local(startbordMark.get_global_position()) )

func _detect_if_player_pass():
	if _line.is_colliding():
		var boat = _line.get_collider()
		if boat not in _boats_to_cross:
			return
			
		if _has_started :
			_pass_checkpoint(boat)
			_line.add_exception(boat)


