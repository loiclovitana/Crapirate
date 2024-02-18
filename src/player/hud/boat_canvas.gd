extends CanvasLayer


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
	
	%haulView.value = boat._sail_haul*100


func debug_set_stats(statsDisplayText):
	%StatsDisplay.set_visible(true)
	%StatsDisplay.set_text(statsDisplayText)
