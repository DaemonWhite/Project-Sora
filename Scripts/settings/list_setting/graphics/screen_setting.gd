class_name ScreenSetting
extends SingleOptionSettings
## Permet de choisir l'écran sur lequel afficher le jeu

func _ready() -> void:
	self._name = "SCREEN_SELECTED"
	self._group = BaseSettings.GROUP.GRAPHICS
	
	self._default_option = 0
	
	for i in DisplayServer.get_screen_count():
		self._options.get_or_add(i,i)

func _apply():
	DisplayServer.window_set_current_screen(self._options[self._current_option], 0)
