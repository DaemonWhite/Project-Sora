class_name CheckSettingsBox
extends BaseSettingsComponent
## Composant settings pour les check box

## Le checkbox du composant
@onready var checkBox = $CheckBox

## Le bouton de remise à zero
@onready var resetButton = $ResetButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	self.checkBox.toggled.connect(self._on_CheckBox_toggled)
	self.resetButton.pressed.connect(self._on_ResetButton_pressed)

	if self.setting:
		self.checkBox.toggle_mode = true
		self.checkBox.button_pressed = self.setting.get_current_option()

func _on_CheckBox_toggled(button_pressed: bool) -> void:
	if self.setting:
		self.setting.set_current_option(button_pressed)
		self.setting.apply()

func _on_ResetButton_pressed() -> void:
	self.reset()

func _on_apply_signal(_class, _save) -> void:
	if self.setting: 
		self.checkBox.button_pressed = self.setting.get_current_option()	
