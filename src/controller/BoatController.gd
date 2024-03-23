class_name BoatController extends Resource

enum CONTROL_ACTION {
	HAUL,
	UNHAUL,
	HELM_RIGHT,
	HELM_LEFT,
	HELM_STRAIGHT,
	SHOOT,
	LOOSE
}

# Get actions - to be overwritten
func get_actions() -> Array[CONTROL_ACTION]:
	push_error("UNIMPLEMENTED ERROR: BoatController.get_actions()")
	return []
