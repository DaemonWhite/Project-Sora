class_name  BaseSettings
extends Object

var _name: String = ""
var _group: BaseSettings.GROUP
var _default_option: Variant = null
var _current_option: Variant = null

static var _list_settings: Array = []
static var _config: ConfigFile = ConfigFile.new()
static var _path_settings: String = ""

enum GROUP {
	OTHER,
	GRAPHICS,
	SOUND,
	KEYBOARD
}

func _init() -> void:
	BaseSettings._list_settings.append(self)
	self._ready()
	self.reset()
	# TODO Ajouter une meilleur vérification d'erreur
	if self._name == null:
		push_warning("Nom non définie de ", self)
	
	if self._default_option == null:
		push_warning("Aucune option par défaut")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func apply():
	print(self._name)
	BaseSettings._config.set_value(
		BaseSettings.get_group_to_string(self._group),
		self._name,
		self._current_option
	)

func reset():
	self._current_option = self._default_option
	self.apply()

func get_current_option() -> Variant:
	return self._current_option

func get_default_option() -> Variant:
	return self._default_option

func get_group() -> BaseSettings.GROUP:
	return self._group

static func get_group_to_string(group_enum: BaseSettings.GROUP) -> String:
	var categorie: String = ""
	match group_enum:
		BaseSettings.GROUP.OTHER:
			categorie = "OTHER"
		BaseSettings.GROUP.GRAPHICS:
			categorie = "GRAPHICS"
		BaseSettings.GROUP.SOUND: 
			categorie = "SOUND"
		BaseSettings.GROUP.KEYBOARD:
			categorie = "KEYBOARD"
			
	return categorie

func get_name() -> String:
	return self._name

static func get_path_settings() -> String:
	return BaseSettings._path_settings

static func get_settings() -> Array:
	return BaseSettings._list_settings

static func get_settings_by_enum(group_enum: BaseSettings) -> Array:
	var list_settings: Array

	for setting in BaseSettings._list_settings:
		if setting.get_group() == group_enum:
			list_settings.append(setting)

	return list_settings

static func get_settings_by_name(group_enum: BaseSettings, name: String) -> Variant:
	for setting in BaseSettings._list_settings:
		if setting.get_group() == group_enum and setting.get_path() == name:
			return setting
	
	return null

func is_diff() -> bool:
	return self._config.get_value(BaseSettings.get_group_to_string(self.group), self.name) != self.default_settings

func set_current_option(option: Variant):
	self._current_option = option

static func set_path_settings(path: String):
	BaseSettings._path_settings = path

static func load():
	BaseSettings._config.load(BaseSettings._path_settings)

static func save():
	BaseSettings._config.save(BaseSettings._path_settings)
