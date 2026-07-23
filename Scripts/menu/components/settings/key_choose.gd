class_name KeyChooseSettingsBox
extends BaseSettingsComponent
## Composant permetant de voir les boutons assigner une action
## ainsie que de modifier cette action
##
## [color=Orange][b] ATTENTION [/b][/color][br] Il est important d'initialiser
## [methode set_link_signals] avant d'ajouter le Composant dans le jeu

## Bouton qui permet l'ajout d'une touche
@onready var addKeyButton = $AddKeyButton
## Bouton pour remetre les touche par défaut
@onready var resetButton = $ResetButton

## Le container des modification
@onready var keyListContainer = $KeyListContainer

## Signal qui prévient si l'utilisateur souaite ajouter une touche
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
	for key: InputEvent in keys:
		var button = Button.new()
		button.text = InputTranslator.get_event_key_to_string(
			key
		)
		self.keyListContainer.add_child(button)
		button.pressed.connect(self._link_signals.bind(self, button, key))

## Relie le callback au bouton
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

## Ajoute une touche à [KeySettings]
func add_key(key: InputEvent) -> KeySettings.ADD_RESULT:
	var result = KeySettings.ADD_RESULT.ERROR_INVALID_EVENT_TYPE
	if self.setting:
		result = self.setting.add_event(key)
		self.setting.apply()

	return result

## Modifi une touche de [KeySettings]
func modify_key(
			key: InputEvent, 
			old_key: InputEvent
		) -> KeySettings.ADD_RESULT:
	var result = self.setting.modify_event(key, old_key)
	self.setting.apply()
	return result

## Supprime une touche de [KeySettings]
func remove_key(key: InputEvent) -> void:
	self.setting.remove_event(key)
	self.setting.apply()
