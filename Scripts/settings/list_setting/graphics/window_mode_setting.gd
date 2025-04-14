class_name WindowModeSetting
extends SingleOptionSettings

func _ready():
	self._name = "WINDOW_MODE"
	self._group = BaseSettings.GROUP.GRAPHICS
	self._options = [
		["plein écran",DisplayServer.WINDOW_MODE_FULLSCREEN],
		["Fenêtré sans bordure",DisplayServer.WINDOW_FLAG_BORDERLESS],
		["Fenêtré",DisplayServer.WINDOW_MODE_WINDOWED]
	]

	self._default_option = "Fenêtré"
