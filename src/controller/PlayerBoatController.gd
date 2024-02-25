class_name InputBoatController extends BoatController

#should be comst
var control_event = {
	"haul":CONTROL_ACTION.HAUL,
	"unhaul":CONTROL_ACTION.UNHAUL,
	"helm_right":CONTROL_ACTION.HELM_RIGHT,
	"helm_left":CONTROL_ACTION.HELM_LEFT
}

@export var _player_name :String=""

func _init(player_name) -> void:
	self._player_name=player_name

func get_actions(_boat : Boat) -> Array[CONTROL_ACTION]:
	var actions:  Array[CONTROL_ACTION]  = []
	for event in control_event:
		if Input.is_action_pressed(_player_name +"_"+event):
			actions.append(control_event[event])
	if not ( CONTROL_ACTION.HELM_RIGHT in actions or CONTROL_ACTION.HELM_LEFT in actions):
		actions.append(CONTROL_ACTION.HELM_STRAIGHT)
	return actions


