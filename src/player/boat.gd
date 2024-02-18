class_name Boat extends Area3D

#Constants
const TIME_TO_HAUL = 3
const TIME_TO_HELM = 1.5
const TIME_FOR_MAX_SPEED = 5.0
const LIMIT_ANGLE_FULL_BACK_WIND = PI*0.9
const TIME_TO_FULLTURN = 1.0
const SPEED_SCALE = 0.1

# stats
@export_range(1,10) var speed_stat = 5
@export_range(0,1) var sail_influence = 1 #not used yet

# env state variables
var wind_direction : Vector2 = Vector2.UP;
var wind_knot = 2;

# state variables
var _current_speed = 0

# childs
@onready var canvas :CanvasLayer = $BoatCanvas
@onready var renderer :BoatRendering = $BoatRendering

#TODO delete
var statsDisplayText = "Stats:"
const UPDATE_DELTA = 1.0
var next_display_update = UPDATE_DELTA

#control_var
var _sail_haul = 0
var _helm_direction = 0

# ==========================================================================================
#		Processing method
# ==========================================================================================

# Called when the node enters the scene tree for the first time.
func _ready():
	canvas.boat = self
	renderer.boat = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	statsDisplayText = "Stats:\n"
	# check user control
	_update_control(delta)
	
	# compute speed
	var max_possible_speed = _compute_max_possible_speed()
	var intended_max_speed = _sail_haul*max_possible_speed
	
	var new_speed = _compute_new_speed(delta,intended_max_speed)
	
	
	
	
	# update position
	set_global_position(self.get_global_position() 
					+( self.global_transform.basis.x * _current_speed * delta)*0.5
		)
	set_global_rotation(
		self.get_global_rotation()
		+ Vector3(0,_helm_direction*delta/TIME_TO_FULLTURN,0)
	)
	set_global_position(self.get_global_position() +( self.global_transform.basis.x * new_speed * delta)*0.5 )
	
	_current_speed=new_speed
	
	# update display 
	next_display_update-= delta
	if next_display_update<0:
		next_display_update = UPDATE_DELTA
		if OS.is_debug_build():
			statsDisplayText += "\n\tFPS :" + str(Engine.get_frames_per_second())
			statsDisplayText += "\n\t_current_speed: "+str(_current_speed)
			statsDisplayText += "\n\t_sail_haul: "+str(_sail_haul)
			statsDisplayText += "\n\t_helm_direction: "+str(_helm_direction)
			statsDisplayText += "\n\tintended_max_speed: "+str(intended_max_speed)
			canvas.debug_set_stats(statsDisplayText)
		


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
	if Input.is_action_pressed("p1_helm_left"):
		dir=1
	if Input.is_action_pressed("p1_helm_right"):
		dir-=1
	_helm_direction += dir * (delta / TIME_TO_HELM)
	if _helm_direction>1:
		_helm_direction = 1
	elif _helm_direction<-1 : 
		_helm_direction= -1
	


func _compute_max_possible_speed() -> float:
	var boat_direction3d = self.get_global_transform().basis.x
	statsDisplayText += "\n\tBoat direction "+str(boat_direction3d)
	
	var boat_direction = Vector2(boat_direction3d.x,boat_direction3d.z)
	var wind_angle = abs(boat_direction.angle_to(wind_direction))
	
	if LIMIT_ANGLE_FULL_BACK_WIND<wind_angle:
		wind_angle = LIMIT_ANGLE_FULL_BACK_WIND
		
	var wind_power =  wind_angle*sin(wind_angle)
	statsDisplayText+= "\n\twind angle: "+str(wind_angle)
	return wind_power*speed_stat*wind_knot/(2*PI)
		
func _compute_new_speed(delta,intended_max_speed):
	if is_equal_approx(_current_speed,intended_max_speed):
		return _current_speed
	if _current_speed< intended_max_speed:
		return _compute_new_speed_accelerating(delta,intended_max_speed)
	else :
		return _compute_new_speed_decelerating(delta,intended_max_speed)
	
	
	
func _compute_new_speed_accelerating(delta,intended_max_speed) -> float:
	if is_zero_approx(intended_max_speed):
		return intended_max_speed
	
	var current_speed_time = pow(_current_speed/intended_max_speed,3) * TIME_FOR_MAX_SPEED
	var new_speed_time = current_speed_time+delta
	var new_speed = intended_max_speed * pow( new_speed_time/TIME_FOR_MAX_SPEED, 1.0/3.0)
	if intended_max_speed<new_speed:
		return intended_max_speed
	return new_speed
	
func _compute_new_speed_decelerating(delta,intended_max_speed):
	var adjusted_intended_speed = intended_max_speed+1
	var speed_relative = (_current_speed+1)/adjusted_intended_speed if adjusted_intended_speed>1 else _current_speed+1
	
	var current_speed_time =  pow(2-speed_relative,3) * TIME_FOR_MAX_SPEED 
	if current_speed_time<=0:
		current_speed_time=0
	var new_speed_time = current_speed_time+delta 
	var new_speed = adjusted_intended_speed*(2 - pow(new_speed_time/TIME_FOR_MAX_SPEED,1.0/3.0)) -1
	
	if new_speed<intended_max_speed:
		return intended_max_speed
	return new_speed
	




