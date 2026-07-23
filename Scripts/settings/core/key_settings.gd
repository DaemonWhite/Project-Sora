class_name KeySettings
extends BaseSettings

## Gère le paramètrage des évenements.
##
## Permet de sauvegarder les paramètres clavier associé à une action.
## Il est pas recommandé de l'utiliser directement car [KeyboardSettings] s'occupe de les générer
## tous dynamiquement au moment ou il est instancié.


enum ADD_RESULT {
	SUCCESS = 1,
	ERROR_DUPLICATE = 2,
	ERROR_MISSING_EVENT = 3,
	ERROR_INVALID_EVENT_TYPE = 4
}

func _init(action: String, events: Array[InputEvent]) -> void:
	self._name = action
	self._ui_name = tr(action)
	self._group = BaseSettings.GROUP.KEYBOARD
	
	# _default_option et _current_option stockent désormais directement 
	# un tableau d'objets InputEvent. C'est tout !
	self._default_option = events.duplicate()
	
	super._init()

## Ajoute un événement à l'action actuelle
func add_event(event: InputEvent) -> KeySettings.ADD_RESULT:
	if not event is InputEvent:
		return KeySettings.ADD_RESULT.ERROR_INVALID_EVENT_TYPE

	for current_event in self._current_option:
		if current_event.is_match(event):
			push_warning("KeySettings: Événement déjà assigné")
			return KeySettings.ADD_RESULT.ERROR_DUPLICATE

	self._current_option.append(event)
	return KeySettings.ADD_RESULT.SUCCESS

## Permet de modifier un évènement
func modify_event(
		input_event: InputEvent,
		old_event: InputEvent
	) -> KeySettings.ADD_RESULT:
	var index_to_remove = self.get_match_event_pos(old_event)

	if index_to_remove == -1:
		push_warning("KeySettings: Événement inexistant")
		return KeySettings.ADD_RESULT.ERROR_MISSING_EVENT


	self._current_option[index_to_remove] = input_event
	
	return KeySettings.ADD_RESULT.SUCCESS


## Supprime un événement
func remove_event(event: InputEvent) -> void:
	var index_to_remove = self.get_match_event_pos(event)

	if index_to_remove != -1:
		self._current_option.remove_at(index_to_remove)
	else:
		push_warning("KeySettings: Événement inexistant")

## Applique directement les modifications à l'InputMap de Godot
func _apply() -> void:
	InputMap.action_erase_events(self._name)
	
	# Plus besoin de décortiquer les enums et les types ! 
	# On réinjecte les objets bruts directement dans Godot.
	for event in self._current_option:
		InputMap.action_add_event(self._name, event)

func get_match_event_pos(event: InputEvent) -> int:
	var index_to_remove = -1
	for i in range(self._current_option.size()):
		if self._current_option[i].is_match(event):
			index_to_remove = i
			break

	return index_to_remove

func set_current_option(option: Variant) -> bool:
	print(option)
	if option is Array[InputEvent]:
		return super.set_current_option(option)
	push_warning("KeySettings: paramètres inconune")
	return false
