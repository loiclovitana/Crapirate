extends MultiMeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(multimesh.instance_count):
		print(i)
		var mesh_position = Transform3D()
		mesh_position = mesh_position.translated(Vector3(randf() * 3-1.5, randf() * 3-1.5, randf() * 3-1.5))

		multimesh.set_instance_transform(i, mesh_position)
		multimesh.set_instance_custom_data(i, Color(randf(), randf(), randf(), randf()))



