class_name  SingleOptionSettings
extends BaseSettings

var _options: Dictionary

func get_options() -> Dictionary:
	return _options

func set_current_option(value: Variant):
	if self.exist_option(value):
		self._current_option = value
	else:
		push_warning("Options non existante", self)

func exist_option(search: String) -> bool:
	if self._options.get(search) != null:
		return true
		
	return false
