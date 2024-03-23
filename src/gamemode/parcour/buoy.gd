class_name Buoy extends RigidBody3D

## Position where the buoy doesn't move if no force is applied to it
@onready var stable_position: Vector3 = get_global_position()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_constant_force(Vector3.UP * 0.05, Vector3(0, 0.2, 0))
	add_constant_force(Vector3.DOWN * 0.05, Vector3(0, -0.2, 0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Called during the physics processing step of the main loop.
func _physics_process(delta):
	var rel_position = stable_position - get_global_position()
	var friction = self.linear_velocity * self.linear_velocity.length()
	apply_central_force(rel_position * 3 - friction)
