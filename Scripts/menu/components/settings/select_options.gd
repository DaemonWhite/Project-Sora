class_name SelectSettingsOptions
extends BaseSettingsComponent

@onready
var optionButton = $OptionButton

@onready
var resetButton = $ResetButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	# Connect the signal for when an option is selected
	self.optionButton.item_selected.connect(self._on_OptionButton_item_selected)
	# Connect the signal for when the reset button is pressed
	self.resetButton.pressed.connect(self._on_ResetButton_pressed)

	# initialize the option button with the options from the setting
	if self.setting:
		var options = self.setting.get_options().keys()
		for option in options:
			self.optionButton.add_item(str(option))
	
		var index = self.setting.get_current_option_index()
		if index >= 0:
			self.optionButton.select(index)

func _on_OptionButton_item_selected(index: int) -> void:
	if self.setting:
		var option = self.optionButton.get_item_text(index)
		self.setting.set_current_option(option)
		self.setting.apply(false)

func _on_ResetButton_pressed() -> void:
	self.reset()

func _on_apply_signal(_class, _save) -> void:
	if self.setting:
		var index = self.setting.get_current_option_index()
		if index >= 0:
			self.optionButton.select(index)

func reset() -> void:
	if self.setting:
		self.setting.reset()

func get_description() -> String:
	return self.description

func get_option_button() -> OptionButton:
	return self.optionButton
