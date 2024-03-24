class_name DynamicPlayerNameInput extends Control

const PLAYER_INPUT_NAME_SCENE : PackedScene = preload("res://src/interface/MainMenu/PlayerNameInput.tscn")

func _process(delta):
	if get_child_count()!=Settings.nb_player:
		_on_number_player_value_changed(Settings.nb_player)

func get_player_name(p_id: int):
	var p_name = get_child(p_id-1).get_child(1).get_text()
	if p_name:
		return p_name
	return "Player " + str(p_id)

func _on_number_player_value_changed(value: float) -> void:
	var children = get_children()
	
	for i in range(value, len(children)):
		children[i].queue_free()

	for i in range(len(children),value):
		var p_input = PLAYER_INPUT_NAME_SCENE.instantiate()
		p_input.get_child(0).set_text("Nom joueur %d" % [i+1])
		p_input.get_child(1).set_text(Settings.get_player_settings(i).player_name)
		p_input.get_child(1).text_changed.connect(func(): Settings.get_player_settings(i).player_name = p_input.get_child(1).get_text() )
		add_child(p_input)
