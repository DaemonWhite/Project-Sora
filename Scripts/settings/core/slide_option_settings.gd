class_name SlideOptionSettings
extends BaseSettings

var _min: float
var _max: float

func set_current_option(value: Variant):
	if self._min <= value or self._max >= value:
		self._current_option = value
	else:
		push_warning("Valeur hors plage")
