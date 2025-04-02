## Simple Description
##  coucou 
@static_unload
class_name  SoraSettings

static var _config: ConfigFile = ConfigFile.new()
static var _list_settings: Dictionary

enum GROUP {
	OTHER,
	GRAPHICS,
	SOUND,
	KEYBOARD
}

var _path_settings: String = "user://sora_settings.cfg"

func add_settings(categorie: GROUP, settings_name: String, default_settings, list_settings) -> void:
	self._list_settings[settings_name] = DataSettings.new(
		categorie,
		settings_name,
		default_settings,
		list_settings
	)

func default_settings(settings_name):
	return self._list_settings[settings_name].default_settings

func get_settings(settings_name: String):
	return self._list_settings[settings_name].list_settings
	
static func get_group_to_string(group: GROUP) -> String:
	var categorie: String = ""
	match group:
		GROUP.OTHER:
			categorie="OTHER"
		GROUP.GRAPHICS:
			categorie="GRAPHICS"
		GROUP.SOUND: 
			categorie="SOUND"
		GROUP.KEYBOARD:
			categorie="KEYBOARD"
			
	return categorie 

func load():
	self._config.load(_path_settings)

func save():
	for setting in self._list_settings:
		self._config.set_value(
			self.get_group_to_string(
				self._list_settings[setting].get_group()
			), 
			self._list_settings[setting].get_name(), 
			self._list_settings[setting].get_default_setting()
		)
	self._config.save(_path_settings)
