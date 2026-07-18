class_name PauseMenu
extends BaseLayerUi
	
func _on_exit_button_pressed() -> void:
	GameSignals.main_menu.emit()
	self.close()

func _on_options_button_pressed() -> void:
	print("option")
	var settings_menu = UiManager.push_ui("SettingsMenu")
	settings_menu.open()
	
