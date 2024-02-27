class_name Bullet extends Area3D



@export var base_speed = 5.0
@export var base_range = 15.0

var _shooter :BulletShooter = null

var keep_when_inactive = true

var active = false
var velocity :Vector3 = Vector3(0,0,0) 
var range_left = 0
var starting_range = 0
var starting_height = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	active = false

func set_origin_shooter(shooter:BulletShooter):
	self._shooter = shooter



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		var rel_position_y = sqrt(range_left/starting_range)
		var movement = velocity*delta
		range_left -= movement.length()
		
		var down_movement = starting_height*(rel_position_y-sqrt(range_left/starting_range))*Vector3.DOWN
		
		
		self.set_global_position(get_global_position()+movement+down_movement)
		
		if range_left<=0:
			set_inactive()



## ========================================
#			Lauch process
## ========================================
func launch(position: Vector3,direction:Vector3,shoot_speed :float=1,range :float=1
			, relative_speed : Vector3 = Vector3(0,0,0) ):
	self.visible = true
	self.active = true
	self.set_global_position(position)
	self.velocity = shoot_speed*base_speed*direction.normalized() +relative_speed
	self.starting_height = position.y
	self.starting_range = (base_range+range)
	self.range_left =self.starting_range
	

## =========================================
#    Set incative
## =========================================
func set_inactive():
	_shooter.signal_bullet_ready(self)
	self.active=false
	# TODO disable collision
	self.visible=false
	if not keep_when_inactive:
		self.queue_free()
