class_name  SingleOptionSettings
extends BaseSettings

var _options: Array

func get_options() -> Array:
	return _options

func set_current_option(value: Variant):
	if self.exist_option(value):
		self._current_option = value
	else:
		push_warning("Options non existante", self)

func exist_option(search: String):
	for option in self._options:
		if option[0] == search:
			return true
			
	return false
