extends Control

var playerNameInput : PackedScene = preload("res://src/interface/MainMenu/player_name_input.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_player_name(p_id: int):
	var p_name = get_child(p_id-1).get_child(1).get_text()
	if p_name:
		return p_name
	return "Player "+str(p_id)

func _on_number_player_value_changed(value: float) -> void:
	var children = get_children()
	
	for i in range(value,len(children)):
		children[i].queue_free()

	for i in range(len(children),value):
		var p_input = playerNameInput.instantiate()
		p_input.get_child(0).set_text("Nom joueur %d" % [i+1])
		add_child(p_input)
