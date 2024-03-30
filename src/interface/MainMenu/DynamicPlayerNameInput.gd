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
		p_input.label.set_text("Nom joueur %d" % [i+1])
		p_input.player_name_line_edit.set_text(Settings.get_player_settings(i).player_name)
		p_input.player_name_line_edit.text_changed.connect(func(new_name): Settings.get_player_settings(i).player_name = new_name )
		p_input.joypad_option.item_selected.connect(func(selected_item_id): Settings.get_player_settings(i).joypad_device_id=p_input.joypad_option.get_item_metadata(selected_item_id))

		add_child(p_input)
		
