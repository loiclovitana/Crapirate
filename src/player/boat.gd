class_name Boat extends Area3D

#Constants
const TIME_TO_HAUL = 0.5
const TIME_TO_HELM = 0.5
const TIME_FOR_MAX_SPEED = 5.0
const LIMIT_ANGLE_FULL_BACK_WIND = PI*0.9

# stats
@export_range(1,10) var speed_stat = 5
@export_range(0,1) var sail_influence = 1 #not used yet

# env state variables
var wind_direction : Vector2 = Vector2.DOWN;
var wind_knot = 10;

# state variables
var _current_speed = 0


#control_var
var _sail_haul = 0
var _helm_direction = 0

# ==========================================================================================
#		Processing method
# ==========================================================================================

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_control(delta)
	var max_possible_speed = _compute_max_possible_speed()
	var intended_max_speed = _sail_haul*max_possible_speed
	
	var new_speed = _compute_new_speed(delta,intended_max_speed)
	
	# update position
	self.translation += self.global_transform.basis.z * _current_speed * delta*0.5
	self.translation += self.global_transform.basis.z * new_speed * delta*0.5
	
	_current_speed=new_speed
	
	


# ==========================================================================================
#		Control methods
# ==========================================================================================
func _update_control(delta):
	_update_haul(delta)
	_update_helm(delta)
	

func _update_haul(delta):
	var haul = 0;
	if Input.is_action_pressed("p1_haul"):
		haul=1
	if Input.is_action_pressed("p1_unhaul"):
		haul-=1
	_sail_haul += haul * (delta / TIME_TO_HAUL)
	if _sail_haul>1:
		_sail_haul = 1
	elif _sail_haul<0 : 
		_sail_haul= 0
	
func _update_helm(delta):
	var dir = 0;
	if Input.is_action_pressed("p1_haul"):
		dir=1
	if Input.is_action_pressed("p1_unhaul"):
		dir-=1
	_helm_direction += dir * (delta / TIME_TO_HELM)
	if _helm_direction>1:
		_helm_direction = 1
	elif _helm_direction<-1 : 
		_helm_direction= -1
	


func _compute_max_possible_speed() -> float:
	var boat_direction3d = self.get_global_transform().basis.x
	var boat_direction = Vector2(boat_direction3d.x,boat_direction3d.z)
	var wind_angle = abs(boat_direction.angle_to(wind_direction))
	
	if LIMIT_ANGLE_FULL_BACK_WIND<wind_angle:
		wind_angle = LIMIT_ANGLE_FULL_BACK_WIND
		
	var wind_power =  wind_angle*sin(wind_angle)
	return wind_power*speed_stat*wind_knot/(2*PI)
		
func _compute_new_speed(delta,intended_max_speed):
	if _current_speed==intended_max_speed:
		return _current_speed
	if _current_speed< intended_max_speed:
		return _compute_new_speed_accelerating(delta,intended_max_speed)
	else :
		return _compute_new_speed_decelerating(delta,intended_max_speed)
	
	
	
func _compute_new_speed_accelerating(delta,intended_max_speed) -> float:
	var current_speed_time = pow(_current_speed/intended_max_speed,3) * TIME_FOR_MAX_SPEED
	var new_speed_time = current_speed_time+delta
	var new_speed = intended_max_speed * pow( new_speed_time/TIME_FOR_MAX_SPEED, 1.0/3.0)
	
	if intended_max_speed<new_speed:
		return intended_max_speed
	return new_speed
	
func _compute_new_speed_decelerating(delta,intended_max_speed):
	var current_speed_time =  pow(2-_current_speed/intended_max_speed,3) * TIME_FOR_MAX_SPEED
	var new_speed_time = current_speed_time+delta
	var new_speed = intended_max_speed*(2 - pow(new_speed_time/TIME_FOR_MAX_SPEED,1.0/3.0))
	
