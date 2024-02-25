class_name BoatController extends Resource

enum CONTROL_ACTION  {
	HAUL,
	UNHAUL,
	HELM_RIGHT,
	HELM_LEFT,
	HELM_STRAIGHT
}

func get_actions(_boat : Boat) -> Array[CONTROL_ACTION]:
	return []
