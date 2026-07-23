class_name ListElementToolTip
extends ToolTip
## ListElementToolTip est une classe qui affiche une simple liste d'élèment
##
## Baser sur [ToolTip] ListElementToolTip est pensser pour êtres une popup
## qui sert à afficher la liste des possibiliter


var _list_elements: Array[Control] = []
## VBox qui contient la liste d'élèment insérer
var container: VBoxContainer = VBoxContainer.new()

var _current_focus_idx: int = -1

func _ready() -> void:
	super._ready()
	self.add_child(container)

## Permet d'ajouter un élément
func add_element(element: Control) -> void:
	if element == null or element in _list_elements:
		return
	
	self._list_elements.append(element)
	self.container.add_child(element)

## Permet d'ajouter des élèmetns
func add_elements(elements: Array[Control]) -> void:
	for element in elements:
		self.add_element(element)

## Permet de supprimer un élèment
func remove_element(element: Control) -> void:
	if element in _list_elements:
		self._list_elements.erase(element)
		self.container.remove_child(element) # Retire du layout immédiatement
		element.queue_free()

## Permet de  supprimer tout les élèments les vide complétemnet de la mémoire
func clear_elements() -> void:
	for element in _list_elements:
		self.container.remove_child(element)
		element.queue_free()
	self._list_elements.clear()
	self._current_focus_idx = -1


func focus_next() -> void:
	if self._list_elements.is_empty():
		return
	
	var next_idx: int = 0 if self._current_focus_idx == -1 else (self._current_focus_idx + 1) % self._list_elements.size()
	self._set_virtual_focus(next_idx)

func focus_prev() -> void:
	if self._list_elements.is_empty():
		return
	
	# Si rien n'est sélectionné, on part du bas. Sinon on recule (en bouclant)
	var prev_idx: int = self._list_elements.size() - 1 if self._current_focus_idx <= 0 else (self._current_focus_idx - 1)
	self._set_virtual_focus(prev_idx)


func _set_virtual_focus(idx: int) -> void:
	# 1. On "relâche" l'ancien bouton
	if self._current_focus_idx >= 0 and self._current_focus_idx < self._list_elements.size():
		var old_btn = self._list_elements[self._current_focus_idx] as Button
		if old_btn:
			old_btn.button_pressed = false

	# 2. On met à jour l'index
	self._current_focus_idx = idx

	# 3. On "enfonce" le nouveau bouton
	if self._current_focus_idx >= 0 and self._current_focus_idx < self._list_elements.size():
		var new_btn = self._list_elements[self._current_focus_idx] as Button
		if new_btn:
			new_btn.button_pressed = true

func get_selected_element() -> Control:
	if self._current_focus_idx >= 0 and self._current_focus_idx < self._list_elements.size():
		return self._list_elements[self._current_focus_idx]
	return null

