class_name MasterSoundSetting
extends SlideOptionSettings
## Paramètres en liens avec le son principal
## @experimental
## TODO Apply n'est pas implementer car fonction inexistante

func _ready():
    self._name = "MASTER"
    self._group = BaseSettings.GROUP.SOUND

    self._min = 0.0
    self._max = 1.0

    self._default_option = self._max