class_name ScreenSetting
extends SingleOptionSettings
## Permet de choisir l'écran sur lequel afficher le jeu

func _ready() -> void:
	self._name = "SCREEN_SELECTED"
	self._ui_name = tr("Sélèction de l'écran")
	self._description = tr("Permet de choisir l'écran à utiliser")
	self._group = BaseSettings.GROUP.GRAPHICS
	
	self._default_option = 0
	
	for i in DisplayServer.get_screen_count():
		self._options.get_or_add(i,i)

func _apply() -> void:
	var target_screen = self._options[self._current_option]
	
	var current_mode = DisplayServer.window_get_mode(0)
	
	# Si le joueur est en mode plein écran, on passe en mode fenêtré pour pouvoir changer d'écran
	if current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN or current_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED, 0)
	
	DisplayServer.window_set_current_screen(target_screen, 0)
	
	# Restore le mode d'affichage précédent si le joueur était en mode plein écran ou exclusif plein écran, sinon on recentre la fenêtre sur le nouvel écran
	if current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN or current_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(current_mode, 0)
		
	else:
		# Si le joueur est en mode fenêtré, on recentre la fenêtre sur le nouvel écran
		var screen_size = DisplayServer.screen_get_size(target_screen)
		var window_size = DisplayServer.window_get_size(0)
		var screen_position = DisplayServer.screen_get_position(target_screen)
		
		var new_pos = screen_position + ((screen_size - window_size) / 2)
		DisplayServer.window_set_position(new_pos, 0)
