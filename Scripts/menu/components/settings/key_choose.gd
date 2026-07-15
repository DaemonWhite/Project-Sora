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
		var type_keys = self.setting.get_current_option()
		self._append_keys(type_keys)

func _append_keys(type_keys) -> void:
	print("type_keys: ", type_keys)
	for keys in type_keys:
		print("keys: ", keys)
		for key in type_keys[keys]:
			var button = Button.new()
			button.text = str(key)
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
		var type_keys = self.setting.get_current_option()
		self._append_keys(type_keys)

func add_key(key: InputEventKey) -> void:
	if self.setting:
		self.setting.add_key(key)
		self.setting.apply()

func reset() -> void:
	if self.setting:
		self.setting.reset()
