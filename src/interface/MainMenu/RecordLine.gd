class_name RecordLine extends ColorRect

func update_data(idx : int ,player_name : String ,time : float):
	%Id.set_text(str(idx))
	%Name.set_text(player_name)
	var minutes = int(abs(time/60))
	var seconds = int(abs(fmod(time,60)))
	var cent = int(abs(fmod(time,1)*100))
	var timer_format : String = "%02d:%02d.%02d s" % [minutes , seconds,cent]
	%Time.set_text(timer_format)
