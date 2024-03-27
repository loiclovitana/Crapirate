class_name PauseMenu extends Control

signal pressed_event(event_name: String, event_data: Dictionary)

func open_menu():
	set_visible(true)
	%PauseMenu.open_menu()

#region READY =================================================================
# Called when the node enters the scene tree for the first time.
func _ready():
	set_visible(false)
	for c in find_children("*", "EventButton"):
		c.pressed_event.connect(_process_event)

func _process_event(event_name: String, event_data: Dictionary):
	match event_name:
		"exit": get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		"continue":  _continue()
		"goto_settings": _go_to_menu(%Settings)
		"return": _go_to_menu(%PauseMenu)
		_: pressed_event.emit(event_name, event_data)

func _go_to_menu(menu: Node):
	for container in %MainContainer.get_children():
		container.set_visible(false)
	menu.open_menu()

func _continue():
	get_tree().paused = false
	set_visible(false)
#endregion ====================================================================
