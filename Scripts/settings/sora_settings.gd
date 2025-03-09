## Simple Description
##  coucou 
@static_unload
class_name  SoraSettings

static var _config: ConfigFile = ConfigFile.new()
static var _list_settings: Dictionary

var _path_settings: String = "user://sora_settings.cfg"

func add_settings(settings_name: String, default_settings, list_settings) -> void:
	_list_settings[settings_name] = DataSettings.new(
		settings_name,
		default_settings,
		list_settings
	)

func default_settings(settings_name):
	return _list_settings[settings_name].default_settings

func get_settings(settings_name: String):
	return _list_settings[settings_name].list_settings

func load():
	_config.load(_path_settings)

func save():
	for setting in _list_settings:
		_config.set_value("teste", _list_settings[setting].get_name(), _list_settings[setting].get_default_setting())
	_config.save(_path_settings)
