@tool
class_name DataSettings
extends Object
var name_settings: String = ""
var default: Variant
var list: Array

func _init(name: String, default_settings: Variant, list_settings: Array) -> void:
	name_settings = name
	default = default_settings
	list_settings = list_settings

func get_name() -> String :
	return name_settings
	
func get_default_setting() -> Variant:
	return default
	
func get_list_settings() -> Variant:
	return list
