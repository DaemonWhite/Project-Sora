class_name MasterSoundSetting
extends SlideOptionSettings
## Paramètres en liens avec le son principal
## @experimental
## TODO Apply n'est pas implementer car fonction inexistante

func _ready() -> void:
	self._name = "MASTER"
	self._ui_name = tr("Master Sound")
	self._description = tr("Régle le volume principal du jeu.")	
	self._group = BaseSettings.GROUP.SOUND

	self._min = 0.0
	self._max = 1.0

	self._default_option = 0.2
	
func _apply() -> void:
	SceneSound.update_music_level(self._current_option)
