extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	set_visible(false)
	for c in find_children("*","EventButton"):
		c.pressed_event.connect(process_event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func process_event(event_name,event_data):
	match event_name:
		"exit" : get_tree().quit()
		"continue" :  _continue()
		"restart" : get_tree().reload_current_scene()
		"goto_settings": goto_menu(%SettingsTabContainer)

func goto_menu(menu : Node):
	for container in %MainContainer.get_children():
		container.set_visible(false)
	menu.set_visible(true)
	

func _continue():
	get_tree().paused = false
	set_visible(false)
