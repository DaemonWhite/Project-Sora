class_name KeyChooseSettingsBox
extends BaseSettingsComponent

@onready var addKeyButton = $AddKeyButton
@onready var resetButton = $ResetButton

@onready var keyListContainer = $KeyListContainer

signal key_add_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	self.addKeyButton.pressed.connect(_on_AddKeyButton_pressed)
	self.resetButton.pressed.connect(_on_ResetButton_pressed)

	if self.setting:
		var keys = self.setting.get_current_option()
		self._append_keys(keys)

func _append_keys(keys) -> void:
	for key in keys:
		for value in keys[key]:
			var button = Button.new()
			button.text = InputTranslator.get_event_key_to_string(
				self.setting.convert_key_code_to_event(
					key, value
				)
			)
			self.keyListContainer.add_child(button)

func _clear_key() -> void:
	for child in self.keyListContainer.get_children():
		child.queue_free()

func _on_AddKeyButton_pressed() -> void:
	key_add_pressed.emit()

func _on_ResetButton_pressed() -> void:
	self.reset()

func _on_apply_signal(_class, _save) -> void:
	if self.setting:
		self._clear_key()
		var keys = self.setting.get_current_option()
		self._append_keys(keys)

func add_key(key: InputEvent) -> KeySettings.ADD_RESULT:
	var result = KeySettings.ADD_RESULT.ERROR_INVALID_EVENT_TYPE
	if self.setting:
		result = self.setting.add_event(key)
		self.setting.apply()

	return result

func reset() -> void:
	if self.setting:
		self.setting.reset()
