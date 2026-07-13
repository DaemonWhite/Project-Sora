class_name EventOverlay
extends Resource

@export var index: int = 0
@export var event: String = ""
@export var name_tab: String = ""


func _init(
		p_index: int = 0, 
		p_event: String = "", 
		p_name_tab: String = ""
	) -> void:
	index = p_index
	event = p_event
	name_tab = p_name_tab
