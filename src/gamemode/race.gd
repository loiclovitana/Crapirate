extends Node

signal send_event(event_name,event_data)

@export var timer : float = -20
var has_started = false

var high_scores : Array[Array] = []

var added_player = 0
## add a player to the race to one of the starting position on the race
func add_player(boat : Boat):
	%SplitscreenView.add_player(boat)
	
	var all_position =  %StartingPositions.get_children()
	var starting_position =all_position[added_player%len(all_position)].get_position()
	boat.set_global_position(starting_position)
	boat.rotate_y(PI/2)
	
	
	added_player+=1


const HIGH_SCORE_FILE ="user://records.csv"
const TIME_IDX = 0
const NAME_IDX = 1
const FILTER_IDX = 2
const NB_COL = 3
var sort_score = func(a,b): return a[TIME_IDX]<b[TIME_IDX]
## Load the high score for a given filter
func load_high_score(filter : String):
	high_scores.clear()
	if not FileAccess.file_exists(HIGH_SCORE_FILE):
		return 
	
	var highScoreFile = FileAccess.open(HIGH_SCORE_FILE,FileAccess.READ)
	var highScoreData = highScoreFile.get_as_text().split('\n')
	
	var hashFilter = filter.sha256_text()
	
	for line in highScoreData:
		var line_data = line.split(';')
		if len(line_data)==1:
			return
		if len(line_data)!=NB_COL:
			push_error("The record file does not match the expected number of columns %d" % NB_COL)
			return
		if line_data[FILTER_IDX]==hashFilter:
			high_scores.append([float(line_data[TIME_IDX]),line_data[NAME_IDX]])
			
	high_scores.sort_custom(sort_score)
	
## Save the score to highscore
## Return:
##		true if saving the score was sucessfull
##		false in case of file error
func save_score(score: float, name: String, filter: String) -> bool:
	
	high_scores.append([score,name])
	high_scores.sort_custom(sort_score)
	
	var highScoreFile : FileAccess
	if not FileAccess.file_exists(HIGH_SCORE_FILE):
		highScoreFile = FileAccess.open(HIGH_SCORE_FILE,FileAccess.WRITE)
	else:
		highScoreFile = FileAccess.open(HIGH_SCORE_FILE,FileAccess.READ_WRITE)
	
	if not highScoreFile:
		return false
	
	var filterHash = filter.sha256_text()
	highScoreFile.seek_end()
	var score_line_data = ';'.join([str(score),name.replace(';',''),filterHash])
	highScoreFile.store_line(score_line_data)
	
	return true
	
## exit the current scene
func exit_race():
	PlayersManagement.clear_players()
	send_event.emit("restart",{})
	get_tree().paused = false
	queue_free()
	

## process sent event
func process_event(event_name,event_data):
	match event_name:
		"restart" : exit_race()
		_ :push_warning("event %s is not handled" % event_name)
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	%Menu.pressed_event.connect(process_event)
	
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



