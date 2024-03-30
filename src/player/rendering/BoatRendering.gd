class_name BoatRendering extends Node3D

const MAX_HEEL_ANGLE_PER_KNOT = deg_to_rad(10)
const MAX_HEEL_ANGLE = deg_to_rad(70)

var boat: Boat
var sails: Array[SailRendering]
@onready var body: Node3D = %Body

## get the global position of name tag
func get_name_tag_position():
	return %NameTagPosition.get_global_position()

## animate being hit by a canon
func animate_hit(bullet: Bullet):
	var hit_left: bool = to_local(bullet.global_position).z < 0
	var init_direction_rotation : Vector3 = Vector3.RIGHT if hit_left else Vector3.LEFT

	#Tween that oscillates
	var tween: Tween = create_tween()
	tween.tween_property( %Body, "rotation_degrees", %Body.rotation_degrees + init_direction_rotation*20, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property( %Body, "rotation_degrees", %Body.rotation_degrees + -15*init_direction_rotation, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property( %Body, "rotation_degrees", %Body.rotation_degrees + 10*init_direction_rotation, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property( %Body, "rotation_degrees", %Body.rotation_degrees + -5*init_direction_rotation, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property( %Body, "rotation_degrees", %Body.rotation_degrees, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

# Called when the node enters the scene tree for the first time.
func _ready():
	var sails_to_render = %Sails.get_children()
	for s in sails_to_render:
		sails.append(s)

#region PROCESS ==============================================================
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var boat_direction3d = boat.get_global_transform().basis.x
	var boat_direction = Vector2(boat_direction3d.x, boat_direction3d.z)
	var wind_angle = -boat_direction.angle_to(boat.wind_direction)
	
	_render_weathercock(wind_angle)
	_render_sails(wind_angle)
	_render_heel(wind_angle)

func _render_heel(wind_angle):
	var heel_ratio = sin(wind_angle) * boat._sail_haul
	var heel_angle = MAX_HEEL_ANGLE_PER_KNOT * boat.wind_knot * heel_ratio
	if heel_angle < - MAX_HEEL_ANGLE:
		heel_angle = -MAX_HEEL_ANGLE
	if MAX_HEEL_ANGLE < heel_angle:
		heel_angle = MAX_HEEL_ANGLE
	body.set_rotation(Vector3(heel_angle, 0, 0))

func _render_weathercock(wind_angle):
	%windPivot.set_rotation(Vector3(0, wind_angle, 0))
	
func _render_sails(wind_angle):
	var perfect_angle = wind_angle * 0.5
	var sail_angle = lerp(wind_angle, perfect_angle, boat._sail_haul)
	for sail in sails:
		sail.render_sail(sail_angle)
#endregion ====================================================================
