class_name KeySettings
extends BaseSettings

## Gère le paramètrage desevenments clavier.
##
## Permet de sauvegarder les paramètres clavier associer à une action.
## Il est pas recomander de l'utiliser directement car [KeyboardSettings] s'occupe de les générer
## tous dynamiquement au moment ou il est instancier.

## Entrer des controlleur prise en charge
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

func _init(action: String, keycodes: Array[InputEvent] ) -> void:
	self._name = action
	self._group = BaseSettings.GROUP.KEYBOARD
	
	# Initialise la stucture du clavier
	self._default_option = {
		KeySettings.INPUT.joypad_button : [], # Bouton de la manetette
		KeySettings.INPUT.joypad_motion : [], # Joystick de la manette
		KeySettings.INPUT.mouse : [], # Touche de la souris
		KeySettings.INPUT.keyboard : [], # Touche clavier
	}
	
	for e in keycodes:
		match KeySettings.detect_event_input(e):
			KeySettings.INPUT.joypad_button:
				self._default_option[KeySettings.INPUT.joypad_button].append(e.button_index)
			KeySettings.INPUT.joypad_motion:
				self._default_option[KeySettings.INPUT.joypad_motion].append(e.axis)
			KeySettings.INPUT.mouse:
				self._default_option[KeySettings.INPUT.mouse].append(e.button_index)
			KeySettings.INPUT.keyboard:
				self._default_option[KeySettings.INPUT.keyboard].append(e.as_text())
			_:
				push_warning("Keyboard Settings: Evenement inconue il sera ignorer", e)
		
	super._init()

## Permet de detecter le type de controleur utiliser
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

## Ajoute un evenement voir [enum KeySettings.INPUT] pour voir les evenments pris en charge
func add_event(event: InputEvent) -> void:
	var value: Variant = null
	
	var type_event = KeySettings.detect_event_input(event)

	match type_event:
		KeySettings.INPUT.joypad_button:
			value = event.button_index
		KeySettings.INPUT.joypad_motion:
			value = event.axis
		KeySettings.INPUT.mouse:
			value = event.button_index
		KeySettings.INPUT.keyboard:
			value = event.as_text()
		_:
			push_warning("Keyboard Settings: Impossible d'ajouter l'evenement inconu", event)
			return
	
	# Empeche le double evenement
	if self._current_option[type_event].find(value) == -1:
		self._current_option[type_event].append(value)
	else:
		push_warning("Evenement deja assigner")
		
## Permet de supprimer l'evenment correspondant
func remove_event(event: InputEvent):
	var value: Variant = null
	
	var type_event = KeySettings.detect_event_input(event)
	
	match type_event:
		KeySettings.INPUT.joypad_button:
			value = event.button_index
		KeySettings.INPUT.joypad_motion:
			value = event.axis
		KeySettings.INPUT.mouse:
			value = event.button_index
		KeySettings.INPUT.keyboard:
			value = event.as_text()
		_:
			push_warning("Keyboard Settings: Impossible d'ajouter l'evenement inconu", event)
			return
	var index: int = self._current_option[type_event].find(value)
	# Empeche le double evenement
	if index  != -1:
		self._current_option[type_event].remove_at(index)
	else:
		push_warning("Evenement innexistant")
	
func _apply() -> void:
	InputMap.action_erase_events(self._name)
	
	for key in self._current_option.keys():
		var input_event: InputEvent = null
		
		match key:
			KeySettings.INPUT.joypad_button:
				for value in self._current_option[key]:
					input_event = InputEventJoypadButton.new()
					input_event.button_index = value
					InputMap.action_add_event(self._name, input_event)
					
			KeySettings.INPUT.joypad_motion:
				for value in self._current_option[key]:
					input_event = InputEventJoypadMotion.new()
					input_event.axis = value
					input_event.axis_value = 0
					InputMap.action_add_event(self._name, input_event)
					
			KeySettings.INPUT.mouse:
				for value in self._current_option[key]:
					input_event = InputEventMouseButton.new()
					input_event.button_index = value
					InputMap.action_add_event(self._name, input_event)
					
			KeySettings.INPUT.keyboard:
				for value in self._current_option[key]:
					input_event = InputEventKey.new()
					input_event.keycode = OS.find_keycode_from_string(value)
					InputMap.action_add_event(self._name, input_event)

## Renvoie le dictionaire contenant toutes les lettres
## [br]
## Format du dictionaires
##	[codeblock]
##	{
##	    KeySettings.INPUT.joypad_button : [], # Bouton de la manetette
##	    KeySettings.INPUT.joypad_motion : [], # Joystick de la manette
##	    KeySettings.INPUT.keyboard : [], # Touche clavier
##	}
## [/codeblock]
func get_current_option() -> Dictionary:
	return super.get_current_option()
