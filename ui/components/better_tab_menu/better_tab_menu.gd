@tool
class_name BetterTabMenu
extends TabContainer
## BetterTabMenu est une classe qui permet de gérer les tab par leurs nom.
##
## BetterTabMenu require une refonte à l'origine il étais prévue pour êtres l'overlay
## Maitenant il est juste une simple tab

## Evenement par défaut du menu
@export var event_overlay: String  = "Pause"

## Les sous menu
@export var event_by_submenu: Array[EventBetterTabMenu] = [
	EventBetterTabMenu.new(0,"", ""),
]

## Liste dse racourci clavier
var list_events_keyboad: Array[EventBetterTabMenu]

func _ready() -> void:
	for submenu in self.event_by_submenu:
		self._add_event(submenu)

func _add_event(eventBetterTabMenu: EventBetterTabMenu) -> void:
	if eventBetterTabMenu.name_tab != "":
		self.set_tab_title(eventBetterTabMenu.index, eventBetterTabMenu.name_tab)

	if eventBetterTabMenu.event != "":
		self.list_events_keyboad.push_back(eventBetterTabMenu)

## Permet d'ajouter une tab
func add_tab(eventBetterTabMenu: EventBetterTabMenu, tab: Control) -> void:
	self.add_child(tab)
	self._add_event(eventBetterTabMenu)

## Permet de choisir une page par son nom
func select_tab_by_name(name_tab: String):
	for submenu in event_by_submenu:
		if submenu.name_tab == name_tab:
			self.current_tab = submenu.index
			break

## Permet d'obtenir le nom de la page courante
func get_current_tab_name() -> String:
	for submenu in event_by_submenu:
		if submenu.index == self.current_tab:
			return submenu.name_tab
	return ""

## Permet de retrouver la position de la page
func get_current_tab_index() -> int:
	return self.current_tab

## Permet de récupérer le nombre de tab
func get_tab_size() -> int:
	return self.get_tab_count()

func _input(event: InputEvent) -> void:
	for submenu in self.list_events_keyboad:
		if event.is_action_pressed(submenu.event):
			self.current_tab = submenu.index
			break