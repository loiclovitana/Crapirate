class_name Bullet extends Area3D



@export var base_speed = 5.0
@export var base_range = 15.0

var _shooter :BulletShooter = null

var keep_when_inactive = true

var active = false
var velocity :Vector3 = Vector3(0,0,0) 
var range_left : float = 0.0
var starting_range : float = 0.0
var starting_height : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	active = false

func set_origin_shooter(shooter:BulletShooter):
	self._shooter = shooter



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		var rel_position_y = sqrt(max(range_left,0)/starting_range)
		var movement = velocity*delta
		range_left -= movement.length()
		
		var down_movement = starting_height*(rel_position_y-sqrt(max(range_left,0)/starting_range))*Vector3.DOWN
		
		
		self.set_global_position(get_global_position()+movement+down_movement)
		
		if range_left<=0:
			set_inactive()



## ========================================
#			Lauch process
## ========================================
func launch(shot_position: Vector3,direction:Vector3,shoot_speed :float=1,additionnal_range :float=0
			, relative_speed : Vector3 = Vector3(0,0,0) ):
	
	self.set_global_position(shot_position)
	self.velocity = shoot_speed*base_speed*direction.normalized() +relative_speed
	self.starting_height = shot_position.y
	self.starting_range = (base_range+additionnal_range)
	self.range_left =self.starting_range
	self.set_monitorable( true) 
	self.set_monitoring( true) 
	self.visible = true
	self.active = true
	

## =========================================
#    Set incative
## =========================================
func set_inactive():
	_shooter.signal_bullet_ready(self)
	self.active=false
	self.visible=false
	self.set_monitorable( false) 
	self.set_monitoring( false) 
	if not keep_when_inactive:
		self.queue_free()
