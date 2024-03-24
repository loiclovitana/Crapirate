class_name Bullet extends Area3D

## The base speed of a bullet
@export var base_speed = 5.0
## The base range of a bullet
@export var base_range = 15.0

@onready var _active = false

var _shooter: BulletShooter = null
var _keep_when_inactive = true
var _velocity: Vector3 = Vector3(0,0,0)
var _starting_range: float = 0.0
var _starting_height: float = 0.0
var _remaining_range: float = 0.0

#region PUBLIC ================================================================
## Set the origin shooter (to be notified if bullet is ready to be reused)
func set_origin_shooter(shooter: BulletShooter):
	_shooter = shooter
	
## Launch the bullet
func launch(shot_position: Vector3, direction: Vector3, shoot_speed: float = 1,
			additionnal_range: float = 0, relative_speed: Vector3 = Vector3(0,0,0)):
	set_global_position(shot_position)
	_velocity = shoot_speed * base_speed * direction.normalized() + relative_speed
	_starting_height = shot_position.y
	_starting_range = (base_range + additionnal_range)
	_remaining_range = _starting_range
	set_monitorable(true)
	set_monitoring(true)
	set_visible(true)
	_active = true
#endregion ====================================================================

#region PROCESS ===============================================================
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _active:
		var rel_position_y = sqrt(max(_remaining_range, 0) / _starting_range)
		var movement = _velocity * delta
		_remaining_range -= movement.length()
		
		var rel_position_y_2 = sqrt(max(_remaining_range, 0) / _starting_range)
		var down_movement = _starting_height * (rel_position_y - rel_position_y_2) * Vector3.DOWN
		
		set_global_position(get_global_position() + movement + down_movement)
		
		if _remaining_range <= 0:
			_set_inactive()

func _set_inactive():
	# Ready to be reused
	_shooter.signal_bullet_ready(self)
	# Becomes inactive and no visible
	_active = false
	set_visible(false)
	# Removes collision monitoring
	set_monitorable(false)
	set_monitoring(false)
	
	if not _keep_when_inactive:
		queue_free()
#endregion ====================================================================
