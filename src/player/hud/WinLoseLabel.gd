class_name WinLoseLabel extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	set_pivot_offset(size / 2)

func set_winning(win):
	if win:
		_scale_down() # scaling
		_rotate_left() # rotation
	else:
		set_text("YOU LOSE!")
		get_label_settings().set_font_color(Color(1, 0, 0))
		_up() # up down

#region UPDOWN ================================================================
func _up():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0, -75), 2).as_relative()
	tween.tween_callback(_down)

func _down():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0, 75), 2).as_relative()
	tween.tween_callback(_up)
#endregion ====================================================================

#region ROTATE ================================================================
func _rotate_left():
	var tween = create_tween()
	tween.tween_property(self, "rotation", 0.5, 0.2)
	tween.tween_callback(_rotate_right)

func _rotate_right():
	var tween = create_tween()
	tween.tween_property(self, "rotation", -0.5, 0.2)
	tween.tween_callback(_rotate_left)
#endregion ROTATE ============================================================

#region SCALING ==============================================================
func _scale_down():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.5, 0.5), 0.5)
	tween.tween_callback(_scale_up)

func _scale_up():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(2, 2), 0.5)
	tween.tween_callback(_scale_down)
#endregion ====================================================================
