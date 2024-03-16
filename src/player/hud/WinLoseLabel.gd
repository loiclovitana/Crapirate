extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	set_pivot_offset(size/2)
	
	

func set_winning(win):
	if win:
		_scale_down()
		_rotate_left()
	else:
		self.set_text("YOU LOSE!")
		self.get_label_settings().set_font_color(Color(1,0,0))
		_up()

func _up():
	var tween = create_tween()
	tween.tween_property(self,"position",Vector2(0,-75),2).as_relative()
	tween.tween_callback(_down)

func _down():
	var tween = create_tween()
	tween.tween_property(self,"position",Vector2(0,75),2).as_relative()
	tween.tween_callback(_up)


func _rotate_left():
	var tween = create_tween()
	tween.tween_property(self,"rotation",0.5,0.2)
	tween.tween_callback(_rotate_right)

func _rotate_right():
	var tween = create_tween()
	tween.tween_property(self,"rotation",-0.5,0.2)
	tween.tween_callback(_rotate_left)

func _scale_down():
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(0.5,0.5),0.5)
	tween.tween_callback(_scale_up)

func _scale_up():
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(2,2),0.5)
	tween.tween_callback(_scale_down)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
