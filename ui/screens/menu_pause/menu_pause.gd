class_name PauseMenu
extends BaseLayerUi
	
func _on_resume_button_pressed() -> void:
	GameSignals.pause_closed.emit()

func _on_exit_button_pressed() -> void:
	GameSignals.main_menu.emit()
	self.close()

func _on_options_button_pressed() -> void:
	GameSignals.ui_open_requested.emit("SettingsMenu")
	
