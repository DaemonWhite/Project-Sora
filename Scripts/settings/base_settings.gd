@static_unload
class_name  BaseSettings
extends Object

var name: String = ""
var group: BaseSettings.GROUP
var default_settings: Variant
var current_settings: Variant

static var list_settings: Array = []
static var __config: ConfigFile = ConfigFile.new()
static var path_settings: String = ""

enum GROUP {
	OTHER,
	GRAPHICS,
	SOUND,
	KEYBOARD
}

func _init(group:  BaseSettings.GROUP, name: String) -> void:
	self.group = group 
	self.name_settings = name
	BaseSettings.list_settings.append(self)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func apply():
	BaseSettings.__config.set_value(
		BaseSettings.get_group_to_string(self.group),
		self.get_name(),
		self.current_settings
	)

func reset():
	self.current_settings = self.default_settings
	self.apply()

func get_current_settings() -> Variant:
	return self.current_settings

func get_default_settings() -> Variant:
	return self.default_settings

func get_group() -> BaseSettings.GROUP:
	return self.group

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

static func get_settings_by_enum(group_enum: BaseSettings) -> Array:
	list_settings = []

	for setting in BaseSettings.list_settings:
		if setting.get_group() == group_enum:
			list_settings.append(setting)

	return list_settings

func get_name() -> String:
	return self.name

func is_diff() -> bool:
	return self.__config.get_value(BaseSettings.get_group_to_string(self.group), self.name) != self.default_settings
	
func set_current_settings(value: Variant):
	self.current_settings = value

static func load():
	BaseSettings.__config.load(BaseSettings.path_settings)

static func save():
	BaseSettings.__config.save(BaseSettings.path_settings)
