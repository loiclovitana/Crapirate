class_name To2DWorld extends Object

## return the vector in 2d world (y acis is ignored
static func to_2d(vector_3d : Vector3) -> Vector2:
	return Vector2(vector_3d.x,vector_3d.z)

## return the vector in 3d world on XZ plane
static func to_3d(vector_2d : Vector2) -> Vector3:
	return Vector3(vector_2d.x,0,vector_2d.y)
