class_name InputBoatController extends BoatController

const CONTROL_EVENTS = {
	"haul": CONTROL_ACTION.HAUL,
	"ease": CONTROL_ACTION.UNHAUL,
	"loose": CONTROL_ACTION.LOOSE,
	"helm_right": CONTROL_ACTION.HELM_RIGHT,
	"helm_left": CONTROL_ACTION.HELM_LEFT,
	"shoot": CONTROL_ACTION.SHOOT
}

const ACTION_NAMES = {
	"haul": "Border la voile",
	"ease": "Choquer la voile",
	"loose": "Choquer complètement",
	"helm_right": "Tourner à droite",
	"helm_left": "Tourner à gauche",
	"shoot": "Tir (canon)"
}

var player_id: String:
	get: return self.boat.player_id

func _init(boat_: Boat) -> void:
	super(boat_)

#region PUBLIC ================================================================
## Get the player name
func get_player_id() -> String:
	return player_id
	
## Get actions to be performed by the boat (based on controller inputs)
func get_actions() -> Array[CONTROL_ACTION]:
	var actions: Array[CONTROL_ACTION] = []
	for event in CONTROL_EVENTS:
		var player_action = get_player_action(event)
		if InputMap.has_action(player_action) and Input.is_action_pressed(player_action):
			actions.append(CONTROL_EVENTS[event])
	if not (CONTROL_ACTION.HELM_RIGHT in actions or CONTROL_ACTION.HELM_LEFT in actions):
		actions.append(CONTROL_ACTION.HELM_STRAIGHT)
	return actions

## Get the action name for the player
func get_player_action(action):
	return player_id + "_" + action
#endregion ====================================================================
