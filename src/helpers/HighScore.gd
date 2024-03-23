extends Node

const HIGH_SCORE_FILE ="user://records.csv"
const TIME_IDX = 0
const NAME_IDX = 1
const FILTER_IDX = 2
const NB_COL = 3
var sort_score = func(a,b): return a[TIME_IDX]<b[TIME_IDX]

var current_filter = ""
var high_scores : Array[Array] = []


func get_highest_score() -> Array:
	if high_scores.is_empty():
		return []
	return high_scores[0]

## Load the high score for a given filter
func load_high_score(filter : String) -> Array:
	var hashFilter = filter.sha256_text()
	if hashFilter==current_filter:
		return high_scores
	
	current_filter =hashFilter
	
	high_scores.clear()
	if not FileAccess.file_exists(HIGH_SCORE_FILE):
		return high_scores
	
	var highScoreFile = FileAccess.open(HIGH_SCORE_FILE,FileAccess.READ)
	if not highScoreFile:
		push_error("Cannot open HIGH_SCORE_FILE : %s" % FileAccess.get_open_error())
		return high_scores
	
	var highScoreData = highScoreFile.get_as_text().split('\n')
	
	for line in highScoreData:
		var line_data = line.split(';')
		if len(line_data)==1:
			continue
		if len(line_data)!=NB_COL:
			push_error("The record file does not match the expected number of columns %d" % NB_COL)
			continue
		if line_data[FILTER_IDX]==hashFilter:
			high_scores.append([float(line_data[TIME_IDX]),line_data[NAME_IDX]])
			
	high_scores.sort_custom(sort_score)
	return high_scores

## Save the score to highscore with the current filter
## Return:
##		true wether the save was sucessfull
func save_score(score: float, name: String) -> bool:
	
	high_scores.append([score,name])
	high_scores.sort_custom(sort_score)
	
	var highScoreFile : FileAccess
	if not FileAccess.file_exists(HIGH_SCORE_FILE):
		highScoreFile = FileAccess.open(HIGH_SCORE_FILE,FileAccess.WRITE)
	else:
		highScoreFile = FileAccess.open(HIGH_SCORE_FILE,FileAccess.READ_WRITE)
	
	if not highScoreFile:
		return false
	
	
	highScoreFile.seek_end()
	var score_line_data = ';'.join([str(score),name.replace(';',''),current_filter])
	highScoreFile.store_line(score_line_data)
	
	return true
