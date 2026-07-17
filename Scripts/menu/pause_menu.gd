class_name PauseMenu
extends BaseLayerUi

func _ready() -> void:
	super._ready()
	get_tree().paused = self.visible

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		self.pause()

func pause() -> void:
	self.visible = !self.visible
	get_tree().paused = self.visible

	if self.visible:
		self.open()
	else:
		self.close()
	
	if get_tree().paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
func _on_exit_button_pressed() -> void:
	self.pause()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")

func _on_option_button_pressed() -> void:
	UiManager.push_ui("SettingsMenu")
