class_name TaaSetting
extends BooleanOptionSettings
##  Paramètres lier à Taa 

func _ready() -> void:
	self._name = "TAA"
	self._group = BaseSettings.GROUP.GRAPHICS

	self._default_option = false

func _apply() -> void: 
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/use_taa", self._current_option)
