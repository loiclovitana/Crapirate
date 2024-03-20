extends Control

signal pressed_event(event_name,event_data)

func open_menu():
	set_visible(true)
	%PauseMenu.open_menu()

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
		"goto_settings": goto_menu(%Settings)
		"return":goto_menu(%PauseMenu)
		_ :pressed_event.emit(event_name,event_data)

func goto_menu(menu : Node):
	for container in %MainContainer.get_children():
		container.set_visible(false)
	menu.open_menu()
	

func _continue():
	get_tree().paused = false
	set_visible(false)
