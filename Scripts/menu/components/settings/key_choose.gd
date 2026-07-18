class_name KeyChooseSettingsBox
extends BaseSettingsComponent

@onready var addKeyButton = $AddKeyButton
@onready var resetButton = $ResetButton

@onready var keyListContainer = $KeyListContainer

signal key_add_pressed

var _link_signals: Callable = _fake_link_signals

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
			button.pressed.connect(self._link_signals.bind(self, button, key, value))

func set_link_signals(link_signalls: Callable) -> void:
	self._link_signals = link_signalls

func _fake_link_signals(_key_choose, _button, _key, _value) -> void:
	push_warning("KeyChooseSettingsBox: _fake_link_signals not override")

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
		self.setting.apply(false)

	return result

func modify_key(
			key: InputEvent, 
			old_key: KeySettings.INPUT, 
			old_value: Variant
		) -> KeySettings.ADD_RESULT:
	var result = self.setting.modify_event(key, old_key, old_value)
	self.setting.apply(false)
	return result

func remove_key(key, value) -> void:
	self.setting.remove_event(key, value)
	self.setting.apply(false)

func reset() -> void:
	if self.setting:
		self.setting.reset()
