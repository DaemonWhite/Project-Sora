class_name VsyncSetting
extends SingleOptionSettings
## Paramètre lier à la Vsync

func _ready():
	self._name = "VSYNC"
	self._ui_name = tr("Vsync")
	self._description = tr("Active ou désactive la Vsync. La Vsync permet de synchroniser le nombre d'image par seconde du jeu avec le taux de rafraichissement de l'écran. Cela permet d'éviter le tearing mais peut causer du lag et du stuttering. (Non nécessaire sur linux avec wayland)")
	self._group = BaseSettings.GROUP.GRAPHICS

	self._options =  {
		"Disable": DisplayServer.VSYNC_DISABLED,
		"Enable": DisplayServer.VSYNC_ENABLED,
		"Adaptive": DisplayServer.VSYNC_ADAPTIVE,
		"Mailbox": DisplayServer.VSYNC_MAILBOX
	}

	self._default_option = "Enable"

func _apply() -> void:
	ProjectSettings.set_setting("display/window/vsync/vsync_mode", self._options[self._current_option])
	
