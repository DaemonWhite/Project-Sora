class_name MasterSoundSetting
extends SlideOptionSettings

func _ready():
    self._name = "MASTER"
    self._group = BaseSettings.GROUP.SOUND

    self._min = 0.0
    self._max = 1.0

    self._default_option = self._max