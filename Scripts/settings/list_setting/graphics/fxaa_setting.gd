class_name FxaaSetting
extends BooleanOptionSettings

func _ready() -> void:
	self._name = "Fxaa"
	self._group = BaseSettings.GROUP.GRAPHICS

	self._default_option = true

func _apply() -> void:
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/screen_space_aa", self._current_option)
