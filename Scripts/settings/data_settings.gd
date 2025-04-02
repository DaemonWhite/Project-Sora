@tool
class_name DataSettings
extends Object
var name_settings: String = ""
var default: Variant
var list: Array
var group: SoraSettings.GROUP

func _init(group:  SoraSettings.GROUP, name: String, default_settings: Variant, list_settings: Array) -> void:
	self.group = group 
	self.name_settings = name
	self.default = default_settings
	self.list = list_settings
	
func get_group() -> SoraSettings.GROUP :
	return self.group

func get_name() -> String :
	return name_settings
	
func get_default_setting() -> Variant:
	return default
	
func get_list_settings() -> Variant:
	return list
