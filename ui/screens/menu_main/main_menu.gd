extends BaseLayerUi

@onready
var title: Label = $Menu/Title

func _ready():
	SceneSound.launch_music_menu()
	self.title.text = ProjectSettings.get_setting("application/config/name")

func _on_options_button_pressed():
	GameSignals.ui_open_requested.emit("SettingsMenu")

func _on_new_game_button_pressed():
	self.close()
	GameSignals.loading_game.emit(
		GameStateManager.State.GAMEPLAY, 
		"res://tests/menu_overlay/test_menu.tscn"
	)

func _on_exit_button_pressed():
	get_tree().quit()
