class_name Overlay
extends TabContainer

@export var event_overlay: String  = "Pause"
@export var event_by_submenu: Array[EventOverlay]
var list_events_keyboad: Array[EventOverlay]

func _ready() -> void:
	for submenu in self.event_by_submenu:
		if submenu.name_tab != "":
			self.set_tab_title(submenu.index, submenu.name_tab)
		
		if submenu.event != "":
			self.list_events_keyboad.push_back(submenu)
			
func select_tab_by_name(name: String):
	for submenu in event_by_submenu:
		if submenu.name_tab == name:
			self.current_tab = submenu.index
			break

func _input(event: InputEvent) -> void:
	for submenu in self.list_events_keyboad:
		if event.is_action_pressed(submenu.event):
			self.current_tab = submenu.index
			print("youpie")
			break
