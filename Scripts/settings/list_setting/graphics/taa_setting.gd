class_name TaaSetting
extends BooleanOptionSettings
##  Paramètres lier à Taa 

func _ready() -> void:
	self._name = "TAA"
	self._ui_name = tr("TAA")
	self._description = tr("Active ou désactive le TAA. Le TAA est un filtre anti-aliasing qui permet de lisser les bords des objets dans le jeu. Plus couteux en performance que le FXAA mais plus efficace.")
	self._group = BaseSettings.GROUP.GRAPHICS

	self._default_option = false

func _apply() -> void: 
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/use_taa", self._current_option)
