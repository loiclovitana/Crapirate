class_name RecordsDisplay extends VBoxContainer

const record_line_scene = preload("res://src/interface/MainMenu/record_line.tscn")

func set_highscores(high_scores : Array[Array]):
	for c in get_children():
		c.queue_free()
	
	for idx in high_scores.size():
		var time = high_scores[idx][HighScore.TIME_IDX]
		var player_name = high_scores[idx][HighScore.NAME_IDX]
		
		var recordLine =  record_line_scene.instantiate()
		recordLine.update_data(idx+1,player_name,time)
		add_child(recordLine)
