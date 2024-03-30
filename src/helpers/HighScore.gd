extends Node

const HIGH_SCORE_FILE = "user://records.csv"
const TIME_IDX = 0
const NAME_IDX = 1
const FILTER_IDX = 2
const NB_COL = 3

var _sort_score = func(a, b): return a[TIME_IDX] < b[TIME_IDX]
var _current_filter = ""
var _high_scores: Array[Array] = []

## Get the highest loaded score
func get_highest_score() -> Array:
	if _high_scores.is_empty():
		return []
	return _high_scores[0]

#region LOAD ==================================================================
## Load the high score for a given filter
func load_high_score(filter: String) -> Array:
	var hash_filter = filter.sha256_text()
	if hash_filter == _current_filter:
		return _high_scores
	_current_filter = hash_filter
	_high_scores.clear()
	_update_score_from_file()
	_high_scores.sort_custom(_sort_score)
	return _high_scores
	
func _update_score_from_file():
	if not FileAccess.file_exists(HIGH_SCORE_FILE):
		return
	
	var high_score_file = FileAccess.open(HIGH_SCORE_FILE, FileAccess.READ)
	if not high_score_file:
		push_error("Cannot open HIGH_SCORE_FILE: %s" % FileAccess.get_open_error())
		return
	
	var high_score_data = high_score_file.get_as_text().split('\n')
	for line in high_score_data:
		var line_data = line.split(';')
		if len(line_data) == 1:
			continue
		if len(line_data) != NB_COL:
			push_error("The record file does not match the expected number of columns %d" % NB_COL)
			continue
		if line_data[FILTER_IDX] == _current_filter:
			_high_scores.append([float(line_data[TIME_IDX]), line_data[NAME_IDX]])
#endregion ====================================================================

#region SAVE ==================================================================
## Save the score to highscore with the current filter, return whether saved
func save_score(score: float, player_name: String) -> bool:
	_high_scores.append([score, player_name])
	_high_scores.sort_custom(_sort_score)
	return _append_score_to_file([str(score), player_name.replace(';', ''), _current_filter])
	
func _append_score_to_file(score_data: Array):
	var high_score_file: FileAccess
	if not FileAccess.file_exists(HIGH_SCORE_FILE):
		high_score_file = FileAccess.open(HIGH_SCORE_FILE, FileAccess.WRITE)
	else:
		high_score_file = FileAccess.open(HIGH_SCORE_FILE, FileAccess.READ_WRITE)
	
	if not high_score_file:
		return false
	
	high_score_file.seek_end()
	var score_line_data = ';'.join(score_data)
	high_score_file.store_line(score_line_data)
	return true
#endregion ====================================================================
