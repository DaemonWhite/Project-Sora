class_name BaseSettingsComponent
extends Control

var setting: BaseSettings = null


@onready
var label = $Label

func initialize(p_setting: BaseSettings) -> void:
	self.setting = p_setting

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if self.setting:
		label.text = self.setting.get_ui_name()

func reset() -> void:
	push_warning("Reset non implémenté pour le composant de base", self)

func get_description() -> String:
	return self.description
