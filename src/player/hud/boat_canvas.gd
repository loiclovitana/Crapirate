extends CanvasLayer

const winLose_hud : PackedScene =preload("res://src/player/hud/finish_race_hud.tscn")

var boat : Boat 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if 0<boat._helm_direction:
		%helmLeftView.value = abs(boat._helm_direction)*100
		%helmRightView.value = 0
	if boat._helm_direction<0:
		%helmLeftView.value = 0
		%helmRightView.value =  abs(boat._helm_direction)*100
	if is_zero_approx(boat._helm_direction):
		%helmLeftView.value = 0
		%helmRightView.value =0
	
	%haulView.value = boat._sail_haul*100
	
	var speed_in_knot = boat._current_speed*1.5
	%SpeedDisplay.set_text("%3.1f KTS" % speed_in_knot)


func debug_set_stats(statsDisplayText):
	%StatsDisplay.set_visible(true)
	%StatsDisplay.set_text(statsDisplayText)

func display_finish_screen(time : float,win : bool=true,is_record :bool =false):
	var win_hud = winLose_hud.instantiate()
	self.add_child(win_hud)
	win_hud.set_winning(win)
	win_hud.set_end_time(time,is_record)
	
