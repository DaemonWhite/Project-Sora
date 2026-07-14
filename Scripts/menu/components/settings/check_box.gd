class_name CheckSettingsBox
extends BaseSettingsComponent

@onready var checkBox = $CheckBox
@onready var resetButton = $ResetButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	self.checkBox.toggled.connect(_on_CheckBox_toggled)
	self.resetButton.pressed.connect(_on_ResetButton_pressed)

	if self.setting:
		self.checkBox.toggle_mode = self.setting.get_current_option()

func _on_CheckBox_toggled(button_pressed: bool) -> void:
	if self.setting:
		self.setting.set_current_option(button_pressed)
		self.setting.apply()

func _on_ResetButton_pressed() -> void:
	self.reset()

func reset() -> void:
	if self.setting:
		self.setting.reset()
		self.checkBox.pressed = self.setting.get_current_option()
