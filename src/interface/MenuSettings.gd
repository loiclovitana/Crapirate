class_name MenuSettings extends VBoxContainer

signal propagate_event(event_name: String, event_data: Dictionary)

## open the menu, making it visible and focusing on the first element
func open_menu():
	set_visible(true)
	%SettingsTabContainer.get_tab_bar().grab_focus()

func process_event(event_name: String, event_data: Dictionary):
	propagate_event.emit(event_name, event_data)
