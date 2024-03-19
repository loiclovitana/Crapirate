extends Node


@export var timer : float = -20
var has_started = false

var high_score : Array[Array] = []

var added_player = 0
## add a player to the race to one of the starting position on the race
func add_player(boat : Boat):
	var all_position =  %StartingPositions.get_children()
	var starting_position =all_position[added_player%len(all_position)].get_position()
	boat.set_global_position(starting_position)
	boat.rotate_y(PI/2)
	print(starting_position)
	%SplitscreenView.add_child(boat)
	
	added_player+=1


const HIGH_SCORE_FILE ="user://records.csv"
const TIME_IDX = 0
const NAME_IDX = 1
const FILTER_IDX = 2
const NB_COL = 3
## Load the high score for a given filter
func load_high_score(filter : String):
	high_score.clear()
	if not FileAccess.file_exists(HIGH_SCORE_FILE):
		return 
	
	var highScoreFile = FileAccess.open(HIGH_SCORE_FILE,FileAccess.READ)
	var highScoreData = highScoreFile.get_as_text().split('\n')
	
	var hashFilter = filter.sha256_text()
	
	for line in highScoreData:
		var line_data = line.split(';')
		if len(line_data)!=NB_COL:
			push_error("The record file does not match the expected number of columns %d" % NB_COL)
			return
		if line_data[FILTER_IDX]==hashFilter:
			high_score.append(line_data.slice(0,-1))
	
	var sort_method = func(a,b):
		return a[TIME_IDX]<b[TIME_IDX]
	high_score.sort_custom(sort_method)
	
## Save the score to highscore
func save_score(score : float, name :String ,filter: String):
	
	high_score.append([score,name])
	
	var highScoreFile : FileAccess
	if not FileAccess.file_exists(HIGH_SCORE_FILE):
		highScoreFile = FileAccess.open(HIGH_SCORE_FILE,FileAccess.WRITE)
	else:
		highScoreFile = FileAccess.open(HIGH_SCORE_FILE,FileAccess.READ_WRITE)
	
	var filterHash = filter.sha256_text()
	highScoreFile.seek_end()
	var score_line_data = ';'.join([str(score),name.replace(';',''),filterHash])
	highScoreFile.save(score_line_data)
	
	
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if timer<0:
		%Timer.get_label_settings().set_font_color(Color(1,0,0,1))


	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_timer(delta)
	
	if Input.is_action_pressed("ui_cancel"):
		%Menu.open_menu()
		get_tree().paused = true
		
	
	
func _update_timer(delta):
	if timer<=0 and 0<timer+delta :
		%Timer.get_label_settings().set_font_color(Color(1,1,1,1))
	timer +=delta
	var sign_ = "-" if sign(timer)<0 else ""
	var minutes = int(abs(timer/60))
	var seconds = int(abs(fmod(timer,60)))
	var cent = int(abs(fmod(timer,1)*100))
	var timer_format : String = "%1s%02d:%02d.%02d " % [sign_,minutes , seconds,cent]
	%Timer.set_text(timer_format)
