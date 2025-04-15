class_name MouseSpeed
extends SlideOptionSettings
## Paramètre en liens avec la vitesse de la souris
## @experimental
## TODO Apply n'est pas implementer car fonction inexistante

func _ready():
    self._name = "MOUSE_SPEED"
    self._group = BaseSettings.GROUP.KEYBOARD

    self._min = 0.0
    self._max = 1.0

    self._default_option = self._max