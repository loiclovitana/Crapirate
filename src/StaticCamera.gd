extends Camera3D
class_name StaticCamera

var relative_parent_position : Vector3
@onready var parent :Node3D = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	relative_parent_position = self.get_global_position() - parent.get_global_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.look_at_from_position(
		parent.get_global_position()+relative_parent_position
		,parent.get_global_position()+Vector3.UP*2
		,Vector3.UP)
