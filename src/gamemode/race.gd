extends Node


@export var timer : float = -20
var has_started = false


var added_player = 0

func add_player(boat : Boat):
	var all_position =  %StartingPositions.get_children()
	var starting_position =all_position[added_player%len(all_position)].get_position()
	boat.set_global_position(starting_position)
	boat.rotate_y(PI/2)
	print(starting_position)
	%SplitscreenView.add_child(boat)

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
