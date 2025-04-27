class_name MsaaSetting
extends SingleOptionSettings
## Paramètres lier à MSAA 3D et 2D

func _ready():
	self._name = "MSAA"
	self._group = BaseSettings.GROUP.GRAPHICS
	self._options = {
		"MSAA Disable": Viewport.MSAA_DISABLED,
		"MSAA 2X": Viewport.MSAA_2X,
		"MSAA 4X": Viewport.MSAA_4X,
		"MSAA 8X": Viewport.MSAA_8X
	}

	self._default_option = "MSAA Disable"

func _apply() -> void:
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", self._options[self._current_option])
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_2d", self._options[self._current_option])
