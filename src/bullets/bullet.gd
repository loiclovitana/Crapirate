class_name Bullet extends Area3D

@export var base_speed = 5.0
@export var base_range = 15.0

var _shooter: BulletShooter = null
var _keep_when_inactive = true
var _velocity: Vector3 = Vector3(0,0,0)
var _starting_range: float = 0.0
var _starting_height: float = 0.0
var _remaining_range: float = 0.0

@onready var _active = false

## Set the origin shooter (to be notified if bullet is ready to be reused)
func set_origin_shooter(shooter: BulletShooter):
	self._shooter = shooter
	
## Launch the bullet
func launch(shot_position: Vector3, direction: Vector3, shoot_speed: float = 1,
			additionnal_range: float = 0, relative_speed: Vector3 = Vector3(0,0,0)):
	self.set_global_position(shot_position)
	self._velocity = shoot_speed * base_speed * direction.normalized() + relative_speed
	self._starting_height = shot_position.y
	self._starting_range = (base_range + additionnal_range)
	self._remaining_range = self._starting_range
	self.set_monitorable(true)
	self.set_monitoring(true)
	self.set_visible(true)
	self._active = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _active:
		var rel_position_y = sqrt(max(self._remaining_range, 0) / self._starting_range)
		var movement = self._velocity * delta
		self._remaining_range -= movement.length()
		
		var rel_position_y_2 = sqrt(max(self._remaining_range, 0) / self._starting_range)
		var down_movement = self._starting_height * (rel_position_y - rel_position_y_2) * Vector3.DOWN
		
		self.set_global_position(get_global_position() + movement + down_movement)
		
		if self._remaining_range <= 0:
			self._set_inactive()

func _set_inactive():
	# Ready to be reused
	_shooter.signal_bullet_ready(self)
	# Becomes inactive and no visible
	self._active = false
	self.set_visible(false)
	# Removes collision monitoring
	self.set_monitorable(false)
	self.set_monitoring(false)
	
	if not _keep_when_inactive:
		self.queue_free()
