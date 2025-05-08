class_name PauseMenu
extends Overlay

func _ready() -> void:
	super._ready()
	get_tree().paused = !self.visible

func _input(event: InputEvent) -> void:
	super._input(event)
	if event.is_action_pressed("Pause"):
		self.pause()

func pause() -> void:
	self.visible = !self.visible
	get_tree().paused = self.visible

func _on_exit_button_pressed() -> void:
	self.pause()
	get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")

func _on_option_button_pressed() -> void:
	self.select_tab_by_name("Options")

func _on_return_button_pressed() -> void:
	self.select_tab_by_name("Pause")
