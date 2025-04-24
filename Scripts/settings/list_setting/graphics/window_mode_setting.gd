class_name WindowModeSetting
extends SingleOptionSettings
## Paramètre lier à WindowMode

func _ready() -> void:
	self._name = "WINDOW_MODE"
	self._group = BaseSettings.GROUP.GRAPHICS
	self._options = {
		"full_screen": DisplayServer.WINDOW_MODE_FULLSCREEN, # Et en réaliter un Bordeless
		# Et le vrais mode plein écrans si pris en charge par le système autrement revient au même
		# que full_screen
		"full_screen_exclusif": DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN,
		"Windowed": DisplayServer.WINDOW_MODE_WINDOWED
	}

	self._default_option = "Windowed"

func _apply() -> void:
	DisplayServer.window_set_mode(self._options[self._current_option])
