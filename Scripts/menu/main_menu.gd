extends BaseLayerUi

func _ready():
	SceneSound.launch_music_menu()

func _on_options_button_pressed():
	UiManager.push_ui(&"SettingsMenu")

func _on_exit_button_pressed():
	get_tree().quit()