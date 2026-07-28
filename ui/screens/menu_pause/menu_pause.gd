class_name PauseMenu
extends BaseLayerUi
	
func _on_resume_button_pressed() -> void:
	GameSignals.ui_close_requested.emit("PauseMenu")

func _on_exit_button_pressed() -> void:
	self.closed.connect(
		self._on_closed,
		CONNECT_ONE_SHOT
	)
	self.close()
	

func _on_closed(_ui: BaseLayerUi) -> void:
	GameSignals.main_menu.emit()

func _on_options_button_pressed() -> void:
	GameSignals.ui_open_requested.emit("SettingsMenu")
	
