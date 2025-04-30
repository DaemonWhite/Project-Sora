class_name VsyncSetting
extends SingleOptionSettings
## Paramètre lier à la Vsync

func _ready():
	self._name = "VSYNC"
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
	
