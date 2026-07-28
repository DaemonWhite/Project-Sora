extends LineEdit

signal up
signal down

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		self.up.emit
	elif event.is_action_pressed("ui_down"):
		self.down.emit