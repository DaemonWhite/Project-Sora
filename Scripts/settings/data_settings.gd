
class_name DataSettings
var name_settings: String = ""
var default_settings: Variant
var list_settings: Array

func _init(name: String, default_settings: Variant, list_settings: Array) -> void:
	name_settings = name
	default_settings = default_settings
	list_settings = list_settings
