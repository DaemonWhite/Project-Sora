@abstract
class_name BaseSettingsComponent
extends Control
## Coponent de base pour le menu options

## Le [BaseSettings] releir au component
var setting: BaseSettings = null

## Nom du menu menu
@onready
var label = $Label

## Permet de configurer le component avec BaseSettings [BaseSettings]
## WARNING Doit êtres éxècuter avant [methode BaseSettingsComponent._ready]
func initialize(p_setting: BaseSettings) -> void:
	self.setting = p_setting

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if self.setting:
		label.text = self.setting.get_ui_name()
		self.setting.apply_signal.connect(self._on_apply_signal)

## Méthode permetant la réinitialisation settings
func reset() -> void:
	if self.setting:
		self.setting.reset()

## Méthode permetant de récupérer la description
func get_description() -> String:
	return self.description

func _on_apply_signal(_class, _save) -> void:
	push_error("apply signal is not defined")
