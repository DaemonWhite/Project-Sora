@tool
class_name BetterTabMenu
extends TabContainer

@export var event_overlay: String  = "Pause"
@export var event_by_submenu: Array[EventOverlay] = [
	EventOverlay.new(0,"", ""),
]
var list_events_keyboad: Array[EventOverlay]

func _ready() -> void:
	for submenu in self.event_by_submenu:
		self._add_event(submenu)

func _add_event(eventOverlay: EventOverlay) -> void:
	if eventOverlay.name_tab != "":
		self.set_tab_title(eventOverlay.index, eventOverlay.name_tab)

	if eventOverlay.event != "":
		self.list_events_keyboad.push_back(eventOverlay)

func add_tab(eventOverlay: EventOverlay, tab: Control) -> void:
	self.add_child(tab)
	self._add_event(eventOverlay)

func select_tab_by_name(name: String):
	for submenu in event_by_submenu:
		if submenu.name_tab == name:
			self.current_tab = submenu.index
			break

func get_current_tab_name() -> String:
	for submenu in event_by_submenu:
		if submenu.index == self.current_tab:
			return submenu.name_tab
	return ""

func get_current_tab_index() -> int:
	return self.current_tab

func get_tab_size() -> int:
	return self.get_tab_count()

func _input(event: InputEvent) -> void:
	for submenu in self.list_events_keyboad:
		if event.is_action_pressed(submenu.event):
			self.current_tab = submenu.index
			print("youpie")
			break
