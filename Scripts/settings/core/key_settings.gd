class_name KeySettings
extends BaseSettings

## Gère le paramètrage des évenements du clavier.
##
## Permet de sauvegarder les paramètres clavier associé à une action.
## Il est pas recommandé de l'utiliser directement car [KeyboardSettings] s'occupe de les générer
## tous dynamiquement au moment ou il est instancié.

## Entrer des controlleurs prise en charge
enum INPUT {
	## Prise en charge du controlleur [InputEventJoypadButton]
	joypad_button,
	## Prise en charge du controlleur [InputEventJoypadMotion]
	joypad_motion,
	## Prise en charge du controlleur [InputEventMouseButton]
	mouse,
	## Prise en charge du controlleur [InputEventKey]
	keyboard,
	## Enum d'erreur
	error
}

enum ADD_RESULT {
	SUCCESS,
	ERROR_DUPLICATE,
	ERROR_INVALID_EVENT_TYPE,
}

func _init(action: String, events: Array[InputEvent] ) -> void:
	self._name = action
	self._ui_name = tr(action)
	self._group = BaseSettings.GROUP.KEYBOARD
	
	# Initialise la stucture du clavier
	self._default_option = {
		KeySettings.INPUT.joypad_button : [], # Bouton de la manette
		KeySettings.INPUT.joypad_motion : [], # Joystick de la manette
		KeySettings.INPUT.mouse : [], # Touche de la souris
		KeySettings.INPUT.keyboard : [], # Touche clavier
	}
	


	for event in events:
		var data = self._process_input_event(event)
		if data.type != KeySettings.INPUT.error:
			self._default_option[data.type].append(data.value)
		else:
			push_warning("Keyboard Settings: Evenement inconnu, il sera ignoré", event)
		
	super._init()

## Fonction utilitaire pour extraire la valeur et le type d'un événement
func _process_input_event(event: InputEvent) -> Dictionary:
	var type = detect_event_input(event)
	var value: Variant = null
    
	match type:
		KeySettings.INPUT.joypad_button:
			value = event.button_index
		KeySettings.INPUT.joypad_motion:
			value = [event.axis, event.axis_value]
		KeySettings.INPUT.mouse:
			value = event.button_index
		KeySettings.INPUT.keyboard:
			value = event.keycode
    
	return {"type": type, "value": value}

## Permet de detecter le type de controleur utilisé
static func detect_event_input(input: InputEvent) -> KeySettings.INPUT:
	var event = KeySettings.INPUT.error

	if input is InputEventJoypadButton:
		event = KeySettings.INPUT.joypad_button
	elif input is InputEventJoypadMotion:
		event = KeySettings.INPUT.joypad_motion
	elif input is InputEventMouseButton:
		event = KeySettings.INPUT.mouse
	elif input is InputEventKey:
		event = KeySettings.INPUT.keyboard

	return event

## Ajoute un evenement voir [enum KeySettings.INPUT] pour voir les évenements pris en charge
func add_event(event: InputEvent) -> KeySettings.ADD_RESULT:
	
	var data = self._process_input_event(event)
	
	if data.type == KeySettings.INPUT.error:
		push_warning("Keyboard Settings: Impossible d'ajouter l'evenement inconnu", event)
		return KeySettings.ADD_RESULT.ERROR_INVALID_EVENT_TYPE

	# Empeche le double évenement
	if self._current_option[data["type"]].find(data["value"]) == -1:
		self._current_option[data["type"]].append(data["value"])
	else:
		push_warning("Keyboard Settings: Evenement deja assigner")
		return KeySettings.ADD_RESULT.ERROR_DUPLICATE

	return KeySettings.ADD_RESULT.SUCCESS
		
## Permet de supprimer l'évenement correspondant
func remove_event(event: InputEvent):
	var data = self._process_input_event(event)

	if data.type == KeySettings.INPUT.error:
		push_warning("Keyboard Settings: Impossible de supprimer l'evenement inconnu", event)
		return

	var index: int = self._current_option[data["type"]].find(data["value"])
	# Empeche le double évenement
	if index  != -1:
		self._current_option[data["type"]].remove_at(index)
	else:
		push_warning("Evenement innexistant")

func convert_key_code_to_event(key: Variant, value) -> InputEvent:
	var input_event = null

	match key:
		KeySettings.INPUT.joypad_button:
				input_event = InputEventJoypadButton.new()
				input_event.button_index = value

		KeySettings.INPUT.joypad_motion:
				input_event = InputEventJoypadMotion.new()
				input_event.axis = value[0]
				input_event.axis_value = value[1]
					
		KeySettings.INPUT.mouse:
				input_event = InputEventMouseButton.new()
				input_event.button_index = value
					
		KeySettings.INPUT.keyboard:
				input_event = InputEventKey.new()
				input_event.keycode = value
		_: push_warning("KeySettings: Input not supported", key)
		

	return input_event

func _apply() -> void:
	InputMap.action_erase_events(self._name)
	
	for key in self._current_option.keys():
		for value in self._current_option[key]:
			var event = self.convert_key_code_to_event(key, value)
			InputMap.action_add_event(self._name, event)
		
		

## Renvoie le dictionaire contenant toutes les lettres
## [br]
## Format du dictionnaire
##	[codeblock]
##	{
##	    KeySettings.INPUT.joypad_button : [button_gamepad], # Bouton de la manetette
##	    KeySettings.INPUT.joypad_motion : [[axis], [axis_value]], # Joystick de la manette
##		KeySettings.INPUT.joypad_mouse : [button_louse], # Touche de la souris
##	    KeySettings.INPUT.keyboard : [key], # Touche clavier
##	}
## [/codeblock]
func get_current_option() -> Dictionary:
	return super.get_current_option()
