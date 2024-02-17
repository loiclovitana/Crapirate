class_name Boat extends Area3D

#Constants
const TIME_TO_HAUL = 0.5
const TIME_TO_HELM = 0.5
const TIME_FOR_MAX_SPEED = 5

# stats
@export_range(1,10) var speed_stat = 5
@export_range(0,1) var sail_influence = 1

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
	var currrent_max_speed = _compute_new_speed(delta)


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
	


func _compute_new_speed(delta):
	pass
