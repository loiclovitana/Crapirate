class_name Boat extends CharacterBody3D

#Constants
var TIME_TO_HAUL = 3
var TIME_TO_HELM = 1.5
var TIME_TO_HELM_STRAIGHT = TIME_TO_HELM + 1
var TIME_FOR_MAX_SPEED = 10.0
const LIMIT_ANGLE_FULL_BACK_WIND = PI * 0.9
var TIME_TO_FULLTURN = 7.5 # Fixme const

# stats
@export_range(1, 100) var speed_stat = 5
@export_range(0, 1) var sail_influence = 1 # not used yet

@export var player_id = 'p1'
var player_name = ""
#controller FIXME ressource export doesnt work just yet
var controller: BoatController # = InputBoatController.new("p1")

# env state variables
var wind_direction: Vector2 = Vector2.UP;
var wind_knot = 2;

# state variables
var _current_speed = 0

# childs
@onready var canvas: CanvasLayer = $BoatCanvas
@onready var renderer: BoatRendering = $BoatRendering
@onready var shooter: BulletShooter = $Shooter
@onready var boatCollisionDetector: BoatCollisionDetector = $BoatCollisionDetections

#TODO delete
var statsDisplayText = "Stats:"
const UPDATE_DELTA = 1.0
var next_display_update = UPDATE_DELTA

#control_var
var _sail_haul = 0
var _helm_direction = 0

var spinning = 0

## determine the next checkpoint in the race
var next_checkpoint: RaceCheckpoint = null

## signal to the player that he finished the race
func has_finished(player_time: float, won: bool, is_record: bool):
	canvas.display_finish_screen(player_time, won, is_record)

## launch the boat to another position
func project_to(target_position: Vector3):
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, 2)
	tween.parallel().tween_property(self, "global_rotation", Vector3(0, 4 * PI, 0), 2).as_relative()
	tween.tween_callback(stop_boat)

func stop_boat():
	_current_speed = 0

# ==========================================================================================
#		Processing method
# ==========================================================================================

# Called when the node enters the scene tree for the first time.
func _ready():
	renderer.boat = self
	if not controller:
		controller = InputBoatController.new(self)
	PlayersManagement.register_player(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	statsDisplayText = "Stats:\n"
	# check user control
	_update_control(delta)
	
	# compute speed
	var max_possible_speed = _compute_max_possible_speed()
	var intended_max_speed = _sail_haul * max_possible_speed
	
	var new_speed = _compute_new_speed(delta, intended_max_speed)
	var rotation_speed = _rotation_speed()
	
	var s_r = _speed_with_collision(new_speed, rotation_speed)
	new_speed = s_r[0]
	rotation_speed = s_r[1]
	
	# update position
	#set_global_position(get_global_position() 
	#				+( global_transform.basis.x * _current_speed * delta)*0.5
	#	)
	rotate_y(
		rotation_speed * delta
	)
	#set_global_position(get_global_position() +( global_transform.basis.x * new_speed * delta)*0.5 )
	
	_current_speed = new_speed
	
	# FIXME : find better way to keep position to 0
	var altitude_correction = Vector3.ZERO
	if not is_zero_approx(get_global_position().y):
		altitude_correction += Vector3(0, -get_global_position().y, 0)
	
	set_velocity((global_transform.basis.x * new_speed) + altitude_correction)
	move_and_slide()
	
	# update display 
	if OS.is_debug_build():
		next_display_update -= delta
		if next_display_update < 0:
			next_display_update = UPDATE_DELTA
			statsDisplayText += "\n\tFPS :" + str(Engine.get_frames_per_second())
			statsDisplayText += "\n\t_current_speed: " + str(_current_speed)
			statsDisplayText += "\n\t_sail_haul: " + str(_sail_haul)
			statsDisplayText += "\n\t_helm_direction: " + str(_helm_direction)
			statsDisplayText += "\n\tintended_max_speed: " + str(intended_max_speed)
			canvas.debug_set_stats(statsDisplayText)

# ==========================================================================================
#		Control methods
# ==========================================================================================
func _update_control(delta):
	var actions = controller.get_actions()
	for action in actions:
		match action:
			BoatController.CONTROL_ACTION.HAUL:
				_update_haul(delta, 1)
			BoatController.CONTROL_ACTION.UNHAUL:
				_update_haul(delta, -1)
			BoatController.CONTROL_ACTION.HELM_LEFT:
				_update_helm(delta, 1)
			BoatController.CONTROL_ACTION.HELM_RIGHT:
				_update_helm(delta, -1)
			BoatController.CONTROL_ACTION.HELM_STRAIGHT:
				_update_helm_straight(delta)
			BoatController.CONTROL_ACTION.LOOSE:
				_sail_haul = 0
			BoatController.CONTROL_ACTION.SHOOT:
				shooter._is_shooting = true

func _update_haul(delta, haul_direction):
	
	_sail_haul += haul_direction * (delta / TIME_TO_HAUL)
	if _sail_haul > 1:
		_sail_haul = 1
	elif _sail_haul < 0:
		_sail_haul = 0

func _update_helm_straight(delta):
	var update_helm = (delta / TIME_TO_HELM_STRAIGHT)
	if abs(_helm_direction) <= update_helm:
		_helm_direction = 0
	if _helm_direction < 0:
		_helm_direction += update_helm
	elif _helm_direction > 0:
		_helm_direction -= update_helm

func _update_helm(delta, direction):
	_helm_direction += direction * (delta / TIME_TO_HELM)
	if _helm_direction > 1:
		_helm_direction = 1
	elif _helm_direction < - 1:
		_helm_direction = -1

# ==========================================================================================
#		Compute Speed methods
# ==========================================================================================

func _compute_max_possible_speed() -> float:
	var boat_direction3d = get_global_transform().basis.x
	
	var boat_direction = Vector2(boat_direction3d.x, boat_direction3d.z)
	var wind_angle = abs(boat_direction.angle_to(wind_direction))
	
	if LIMIT_ANGLE_FULL_BACK_WIND < wind_angle:
		wind_angle = LIMIT_ANGLE_FULL_BACK_WIND
		
	var wind_power = wind_angle * sin(wind_angle)
	if OS.is_debug_build():
		statsDisplayText += "\n\tBoat direction " + str(boat_direction3d)
		statsDisplayText += "\n\twind angle: " + str(wind_angle)
	return wind_power * speed_stat * wind_knot / (2 * PI)
		
func _compute_new_speed(delta, intended_max_speed) -> float:
	if is_equal_approx(_current_speed, intended_max_speed):
		return intended_max_speed
	if _current_speed < intended_max_speed:
		return _compute_new_speed_accelerating(delta, intended_max_speed)
	else:
		return _compute_new_speed_decelerating(delta, intended_max_speed)
	
func _compute_new_speed_accelerating(delta, intended_max_speed) -> float:
	if is_zero_approx(intended_max_speed):
		return 0
	
	var current_speed_time = pow(_current_speed / intended_max_speed, 3) * TIME_FOR_MAX_SPEED
	var new_speed_time = current_speed_time + delta
	var new_speed = intended_max_speed * pow(new_speed_time / TIME_FOR_MAX_SPEED, 1.0 / 3.0)
	if intended_max_speed < new_speed:
		return intended_max_speed
	return new_speed

func _compute_new_speed_decelerating(delta, intended_max_speed) -> float:
	const TIME_FROM_1_TO_0 = 4
	
	var current_speed_time = -sqrt(_current_speed) * TIME_FROM_1_TO_0
	var new_speed_time = current_speed_time + delta
	if new_speed_time > 0:
		return intended_max_speed
	var new_speed = (new_speed_time / TIME_FROM_1_TO_0) ** 2
	
	if new_speed < intended_max_speed:
		return intended_max_speed
	return new_speed

func _rotation_speed() -> float:
	var r_speed = _helm_direction * max(1, _current_speed * 0.5)
	
	return r_speed * 2 * PI / TIME_TO_FULLTURN

# ==========================================================================================
#		Compute collision
# ==========================================================================================

func _speed_with_collision(speed, rotation_speed) -> Array[float]:
	if not boatCollisionDetector or boatCollisionDetector.collisions_point.is_empty():
		return [speed, rotation_speed]
	var collision_speed = speed
	var collision_rotation = rotation_speed
	
	var front_collision: Vector3 = Vector3.ZERO
	var back_collision: Vector3 = Vector3.ZERO
	for collision in boatCollisionDetector.collisions_point:
		if collision.x < 0.1:
			back_collision += collision
		if collision.x > 0.1:
			front_collision += collision
			
	#set rotation_speed if collision isn't centered
	if (not is_zero_approx(back_collision.z)) or not is_zero_approx(front_collision.z):
		collision_rotation += max(2, _current_speed * 2) * (front_collision.z - back_collision.z)
	
	return [collision_speed, collision_rotation]
