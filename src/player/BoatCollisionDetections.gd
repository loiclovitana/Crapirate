class_name BoatCollisionDetector extends Node3D

var rays : Array[RayCast3D]
@onready var boat :Boat = get_parent()
var collisions_point : Array[Vector3] = []


# Called when the node enters the scene tree for the first time.
func _ready():
	rays = []
	for ray in  get_children() :
		rays.append(ray as RayCast3D)
		ray.add_exception(boat)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not collisions_point.is_empty():
		collisions_point.clear()
	for ray in rays:
		if ray.is_colliding() and ray.get_collider() is Boat:
			collisions_point.append(to_local(ray.get_collision_point()))
	
		
