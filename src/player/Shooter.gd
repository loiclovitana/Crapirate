extends Node3D

##
##	Shooter Class
##	Allows a Boat (or anything) to shoot bullet
##

@export var bullet_tyoe: PackedScene
@export_range(0.1,10) var fire_delay = 1
# Attributes
var shooters :Array = []

# Stats


# variables
var _is_shooting = false
var _delay_next_shoot = 0

var instantiated_bullet = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child.get_type() == Marker3D:
			shooters.append(child)


##	==================================================================
##			PROCESSING
##	==================================================================
func _process(delta: float) -> void:
	_update_next_shoot(delta)
	if _is_shooting and _delay_next_shoot<=0:
		_delay_next_shoot+=fire_delay
		_shoot()


func _update_next_shoot(delta):
	if 0<=_delay_next_shoot:
		_delay_next_shoot-=delta
	else:
		_delay_next_shoot=0



func _shoot():
	pass
