@tool
class_name DialogConfirm
extends Dialog
## Simple dialog pour demander l'opinion de l'utilisateur par oui ou non

@onready 
var canceled_button = $CenterContainer/PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/Cancel
@onready 
var confirmed_button = $CenterContainer/PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/Valide

## Prévient de si ça à étais accepter
signal confirmed

## Prévient de si ça à étais refuser
signal canceled

func _on_cancel_pressed() -> void:
	self.canceled.emit()
	self.close()

func _on_valide_pressed() -> void:
	self.confirmed.emit()
	self.close()
