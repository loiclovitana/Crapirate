extends Node

signal send_event(event_name,event_data)

## indicates the time before / after the start of the race
@export var timer : float = -20
var has_started = false


var added_player = 0
## add a player to the race to one of the starting position on the race
func add_player(boat : Boat):
	%SplitscreenView.add_player(boat)
	
	var all_position =  %StartingPositions.get_children()
	var starting_position =all_position[added_player%len(all_position)].get_position()
	boat.set_global_position(starting_position)
	boat.rotate_y(PI/2)
	
	
	added_player+=1

	
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
	
	var highscore = HighScore.get_highest_score()
	
	if highscore.is_empty():
		%RecordDisplay.set_text("")
	else:
		highscore = highscore[HighScore.TIME_IDX]
		var minutes = int(abs(highscore/60))
		var seconds = int(abs(fmod(highscore,60)))
		var cent = int(abs(fmod(highscore,1)*100))
		var record_format : String = "Record: %02d:%02d.%02d " % [minutes , seconds,cent]
		%RecordDisplay.set_text(record_format)
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



