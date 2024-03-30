class_name SailRendering extends Node3D

func render_sail(sail_angle):
	set_rotation(Vector3(0, sail_angle, 0))
