class_name SliderSettingsBox
extends BaseSettingsComponent

@onready var slider = $HSlider
@onready var resetButton = $ResetButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	self.slider.value_changed.connect(self._on_Slider_value_changed)
	self.resetButton.pressed.connect(self._on_ResetButton_pressed)

	if self.setting:
		self.slider.min_value = self.setting.get_min()
		self.slider.max_value = self.setting.get_max()
		self.slider.step = self.setting.get_step()
		self.slider.value = self.setting.get_current_option()

func _on_Slider_value_changed(value: float) -> void:
	if self.setting:
		self.setting.set_current_option(value)
		self.setting.apply()

func _on_ResetButton_pressed() -> void:
	self.reset()

func _on_apply_signal(_class, _save) -> void:
	if self.setting: 
		self.slider.value = self.setting.get_current_option()

func reset() -> void:
	if self.setting:
		self.setting.reset()
