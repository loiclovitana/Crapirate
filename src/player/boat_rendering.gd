extends Node3D
class_name  BoatRendering

var boat: Boat

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_render_weathercock()
	
func _render_weathercock():
	var boat_direction3d = boat.get_global_transform().basis.x
	var boat_direction = Vector2(boat_direction3d.x,boat_direction3d.z)
	var wind_angle = boat_direction.angle_to(boat.wind_direction)
	%windPivot.set_rotation(Vector3(0,-wind_angle,0))
