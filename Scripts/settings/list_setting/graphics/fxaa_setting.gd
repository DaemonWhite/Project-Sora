class_name FxaaSetting
extends BooleanOptionSettings
## Paramètres lier à Fxaa 

func _ready() -> void:
	self._name = "FXAA"
	self._group = BaseSettings.GROUP.GRAPHICS

	self._default_option = true

func _apply() -> void:
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/screen_space_aa", self._current_option)
