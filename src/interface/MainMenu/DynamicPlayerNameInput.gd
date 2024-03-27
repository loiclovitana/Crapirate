class_name DynamicPlayerNameInput extends Control

const PLAYER_INPUT_NAME_SCENE : PackedScene = preload("res://src/interface/MainMenu/PlayerNameInput.tscn")

func _process(_delta):
	if get_child_count()!=Settings.nb_player:
		_on_number_player_value_changed(Settings.nb_player)

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
