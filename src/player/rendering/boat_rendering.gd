extends Node3D
class_name  BoatRendering


const MAX_HEEL_ANGLE_PER_KNOT = deg_to_rad(10)
const MAX_HEEL_ANGLE = deg_to_rad(70)

var boat: Boat
var sails : Array[SailRendering]

# Called when the node enters the scene tree for the first time.
func _ready():
	var sails_to_render = $Sails.get_children()
	for s in sails_to_render:
		sails.append(s)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var boat_direction3d = boat.get_global_transform().basis.x
	var boat_direction = Vector2(boat_direction3d.x,boat_direction3d.z)
	var wind_angle = -boat_direction.angle_to(boat.wind_direction)
	
	_render_weathercock(wind_angle)
	_render_sails(wind_angle)
	_render_heel(wind_angle)

func _render_heel(wind_angle):
	var heel_ratio = sin(wind_angle)*boat._sail_haul
	var heel_angle = MAX_HEEL_ANGLE_PER_KNOT*boat.wind_knot*heel_ratio
	if heel_angle < -MAX_HEEL_ANGLE:
		heel_angle=-MAX_HEEL_ANGLE
	if MAX_HEEL_ANGLE<heel_angle:
		heel_angle=MAX_HEEL_ANGLE
	set_rotation ( Vector3(heel_angle,0,0))

func _render_weathercock(wind_angle):
	%windPivot.set_rotation(Vector3(0,wind_angle,0))
	
func _render_sails(wind_angle):
	var perfect_angle = wind_angle*0.5
	var sail_angle = lerp(wind_angle,perfect_angle,boat._sail_haul)
	for sail in sails:
		sail.render_sail(sail_angle)
