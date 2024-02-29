extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	add_constant_force(Vector3.UP*0.5, Vector3(0,0.2,0))
	add_constant_force(Vector3.DOWN*0.5, Vector3(0,-0.2,0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var rel_position = get_parent().get_global_position() -get_global_position()
	var friction = self.linear_velocity*self.linear_velocity.length()
	apply_central_force(rel_position*3-friction)
	
