class_name KeySettings
extends BaseSettings

func _init(action: String, keycodes: Array[InputEvent] ) -> void:
	self._name = action
	self._group = BaseSettings.GROUP.KEYBOARD
	
	self._default_option = []
	
	for keycode in keycodes:
		self._default_option.append(keycode.as_text())
		
	super._init()

## Ajoute une lettre à la configuration
func add_keycode(key: Key) -> void:
	var input = InputEventKey.new()
	
	input.keycode = key
	
	InputMap.action_get_events(self._name).append(input)

## Recupères tout les lettres associer à l'evenement
func get_keycodes() -> Array[Key]:
	var list_keycode: Array[Key]
	
	for key_string in self._default_option:
		list_keycode.append(OS.find_keycode_from_string(self._default_option))
	
	return list_keycode
