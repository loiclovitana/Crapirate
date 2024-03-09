extends RaceCheckpoint


@export var portMark : Node3D ## Mark that define the port side of the line
@export var startbordMark : Node3D ## Mark that define the starboard side of the line

@onready var line : RayCast3D = %Line
@onready var lineMesh : MeshInstance3D = %LineVisual

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_raycast_position()
	_update_mesh_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	_update_raycast_position()
	_update_mesh_position()

func _update_mesh_position():
	var new_position = (portMark.get_global_position() +startbordMark.get_global_position()) /2 
	lineMesh.set_global_position(new_position)
	
	lineMesh.mesh.set_height((portMark.get_global_position() -startbordMark.get_global_position()).length())
	
	var line = (portMark.get_global_position() -startbordMark.get_global_position())
	var angle_line = Vector2(line.x,line.z).angle()
	lineMesh.set_global_rotation(Vector3(0,-angle_line,PI/2))
	
	
func _update_raycast_position():
	line.set_global_position(portMark.get_global_position())
	line.set_target_position(startbordMark.get_global_position() -portMark.get_global_position())
