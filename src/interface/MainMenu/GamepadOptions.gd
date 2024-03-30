extends OptionButton

const GAMEPAD_ICON: Texture2D = preload ("res://ressources/ui/icon-gamepad.png")
const KEYBOARD_ICON: Texture2D = preload ("res://ressources/ui/icon-keyboard.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	clear()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var joypads = Input.get_connected_joypads()
	if len(joypads) + 1 != item_count:
		var previouslySelected = get_selected_metadata()
		var newly_selected = -1
		clear()
		for i in len(joypads):
			var joypad_id = joypads[i]
			add_icon_item(GAMEPAD_ICON, str(joypad_id + 1) + "  ")
			set_item_metadata(i, joypad_id)
			if joypad_id == previouslySelected:
				newly_selected = i
		#add keyboard and select keyboard if no selection
		add_icon_item(KEYBOARD_ICON, "   ")
		set_item_metadata( - 1, -1)
		if newly_selected == - 1:
			newly_selected = len(joypads)
		
		select(newly_selected)
