extends VBoxContainer


signal propagate_event(event_name: String,event_data : Dictionary)

## open the menu manking it visible and focusing the first element
func open_menu():
	set_visible(true)
	%SettingsTabContainer.get_tab_bar().grab_focus()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func process_event(event_name : String,event_data : Dictionary):
	propagate_event.emit(event_name,event_data)
