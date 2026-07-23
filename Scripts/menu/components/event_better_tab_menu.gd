class_name EventBetterTabMenu
extends Resource
## Classe qui donne les information pour [BetterTabMenu]

## Position du menu
@export var index: int = 0
## Racourci clavier pour l'ouvrir
@export var event: String = ""
## Nom du menu
@export var name_tab: String = ""


func _init(
		p_index: int = 0, 
		p_event: String = "", 
		p_name_tab: String = ""
	) -> void:
	index = p_index
	event = p_event
	name_tab = p_name_tab
