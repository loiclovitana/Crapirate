class_name GPS extends Node3D

@onready var boat: Boat = get_parent()
@onready var arrowDown: Node3D = %ArrowDown
@onready var arrowDirection: Node3D = %ArrowDirection
@onready var windArrow: Node3D = %WindArrow

const DISTANCE_CLOSE_CHECKPOINT_SQ: float = 10 **2
const DISTANCE_POINTING_ARROW: float  = 4
const DISTANCE_WIND_ARROW: float  = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	arrowDown.set_visible(false)
	arrowDirection.set_visible(false)

	var p_id = int(boat.player_id)
	assert(0<p_id and p_id<=10,'The player id is not between 1 and 10')

	var p_view_id = PlayerView.PLAYER_VIEW_ID_OFFSET +p_id 
	
	# set the layer for all visual instance to be the current player only
	for arrow_child in arrowDown.get_children()+arrowDirection.get_children()+windArrow.get_children():
		for layer_id in range(1,21):
			arrow_child.set_layer_mask_value(layer_id,layer_id==p_view_id)

#region PROCESS ==============================================================
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_update_wind_arrow()
	_update_next_checkpoint_arrow()

## set the position of the arrow that indicates the next checkpoint
func _update_next_checkpoint_arrow():
	if not boat.next_checkpoint:
		arrowDown.set_visible(false)
		arrowDirection.set_visible(false)
		return
	
	var boat_to_checkpoint = boat.next_checkpoint.get_position_to_go() - boat.get_global_position()
	if  boat_to_checkpoint.length_squared() < DISTANCE_CLOSE_CHECKPOINT_SQ  :
		arrowDown.set_visible(true)
		arrowDirection.set_visible(false)
		_update_down_checkpoint_arrow()
	else:
		arrowDown.set_visible(false)
		arrowDirection.set_visible(true)
		_update_pointing_checkpoint_arrow(boat_to_checkpoint)

## set the position of the wind arrow indication
func _update_wind_arrow():
	var arrow_position = boat.get_global_position() - To2DWorld.to_3d(-boat.wind_direction.normalized())*DISTANCE_WIND_ARROW
	windArrow.look_at_from_position(arrow_position,boat.get_global_position())

func _update_down_checkpoint_arrow():
	arrowDown.set_global_position(boat.next_checkpoint.get_position_to_go())
	
func _update_pointing_checkpoint_arrow(boat_to_checkpoint: Vector3):
	var arrow_position = boat.get_global_position() + boat_to_checkpoint.normalized()*DISTANCE_POINTING_ARROW
	arrowDirection.look_at_from_position(arrow_position, boat.next_checkpoint.get_position_to_go())
# ============================================================================
#endregion
