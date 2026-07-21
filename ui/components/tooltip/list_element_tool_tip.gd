class_name ListElementToolTip
extends ToolTip
## ListElementToolTip est une classe qui affiche une simple liste d'élèment
##
## Baser sur [ToolTip] ListElementToolTip est pensser pour êtres une popup
## qui sert à afficher la liste des possibiliter


var _list_elements: Array[Control] = []
## VBox qui contient la liste d'élèment insérer
var container: VBoxContainer = VBoxContainer.new()


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
		self.container.remove_child(element) # Retire du layout immédiatement
		element.queue_free()
	self._list_elements.clear()


func focus_next() -> void:
	if self._list_elements.is_empty():
		return
	
	var current_idx: int = self._get_focused_index()
	var next_idx: int = 0 if current_idx == -1 else (current_idx + 1) % self._list_elements.size()
	self._list_elements[next_idx].grab_focus()

func focus_prev() -> void:
	if self._list_elements.is_empty():
		return
	
	var current_idx: int = self._get_focused_index()
	# Si aucun élément n'a le focus, on commence au dernier.
	var prev_idx: int = self._list_elements.size() - 1 if current_idx == -1 else (current_idx - 1 + self._list_elements.size()) % self._list_elements.size()
	self._list_elements[prev_idx].grab_focus()


# Méthode utilitaire pour trouver quel élément possède actuellement le focus
func _get_focused_index() -> int:
	for i in range(self._list_elements.size()):
		if self._list_elements[i].has_focus():
			return i
	return -1