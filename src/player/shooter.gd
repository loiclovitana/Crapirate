class_name BulletShooter extends Node3D

##
##	Shooter Class
##	Allows a Boat (or anything) to shoot bullet
##


# Stats
@export var bullet_type: PackedScene
@export_range(0.1,10) var fire_delay = 1
@export_range(0.3,4) var shot_speed = 1
@export var shot_range: float = 0
# Attributes
var shooters :Array[Marker3D] = []
@onready var boat : Boat = get_parent()
@onready var bullets = %Bullets


# variables
var _is_shooting = false
var _delay_next_shoot = 0

var bullets_ready : Array[Bullet] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Marker3D:
			shooters.append(child)


##	==================================================================
##			PROCESSING
##	==================================================================
func _process(delta: float) -> void:
	_update_next_shoot(delta)
	if _is_shooting and _delay_next_shoot<=0:
		_delay_next_shoot+=fire_delay
		_shoot()
	_is_shooting = false


func _update_next_shoot(delta):
	if 0<=_delay_next_shoot:
		_delay_next_shoot-=delta
	else:
		_delay_next_shoot=0


func _get_bullet() -> Bullet:
	var bullet : Bullet = bullets_ready.pop_back()
	if bullet:
		return bullet
	
	bullet =  bullet_type.instantiate()
	bullet.set_origin_shooter(self)
	bullets.add_child(bullet)
	return bullet
	


func _shoot():
	for canon in shooters:
		var bullet : Bullet= _get_bullet()
		var relative_speed = boat._current_speed * boat.get_global_transform().basis.x
		bullet.launch(
			canon.get_global_position()
			,canon.get_global_transform().basis.x
			,shot_speed
			,shot_range
			,relative_speed *0.5
		)

func signal_bullet_ready(bullet:Bullet):
	bullets_ready.push_back(bullet)
