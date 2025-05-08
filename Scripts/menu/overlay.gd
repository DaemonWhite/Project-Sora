class_name Overlay
extends TabContainer

@export var event_overlay: String  = "Pause"
@export var event_by_submenu: Array[EventOverlay]
@export var list_events_keyboad: Array[EventOverlay]

func _ready() -> void:
	for submenu in self.event_by_submenu:
		if submenu.name_tab != "":
			self.set_tab_title(submenu.index, submenu.name_tab)
		
		if submenu.event != "":
			self.list_events_keyboad.push_back(submenu)

func _input(event: InputEvent) -> void:
	if self.visible:
		for submenu in self.list_events_keyboad:
			if event.is_action_pressed(submenu.event):
				self.current_tab = submenu.index
