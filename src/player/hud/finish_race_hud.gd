extends CenterContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_end_time(time,is_record=false):
	var minutes = int(abs(time/60))
	var seconds = int(abs(fmod(time,60)))
	var cent = int(abs(fmod(time,1)*100))
	var timer_format : String = "%02d:%02d.%02d s" % [minutes , seconds,cent]
	var new_record_text : String = "NEW RECORD !!!" if is_record else ""
	%TimeLabel.set_text(
		"""TIME :%s\n%s""" % [timer_format,new_record_text]
	)

func set_winning(win : bool):
	%WinLoseLabel.set_winning(win)
