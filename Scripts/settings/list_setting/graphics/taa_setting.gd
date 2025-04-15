class_name TaaSetting
extends BooleanOptionSettings

func _ready():
    self._name = "TAA"
    self._group = BaseSettings.GROUP.GRAPHICS

    self._default_option = false