class_name RecordsDisplay extends VBoxContainer

const RECORD_LINE_SCENE = preload ("res://src/interface/MainMenu/RecordLine.tscn")

func set_highscores(high_scores: Array[Array]):
	for c in get_children():
		c.queue_free()
	
	for idx in high_scores.size():
		var time = high_scores[idx][HighScore.TIME_IDX]
		var player_name = high_scores[idx][HighScore.NAME_IDX]
		
		var record_line = RECORD_LINE_SCENE.instantiate()
		record_line.update_data(idx + 1, player_name, time)
		add_child(record_line)
