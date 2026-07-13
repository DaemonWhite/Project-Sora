class_name BaseSettingsComponent
extends Control

var setting: BaseSettings = null


@onready
var label = $Label

func initialize(p_setting: BaseSettings) -> void:
	self.setting = p_setting

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if setting:
		label.text = setting.get_ui_name()

func get_drescription() -> String:
	return self.description
