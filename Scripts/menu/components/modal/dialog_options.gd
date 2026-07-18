@tool
class_name DialogOptions
extends Dialog
## Dialog qui permet de créer un ensemble de choix à partir d'un bouton

@onready var buttonContainer: HFlowContainer = $CenterContainer/PanelContainer/VBoxContainer/ChildContainer/ButtonContainer

## Permet d'ajouter un bouton et retourne le dit bouton créer
func add_option(name_option: String) -> Button:
	var button = Button.new()
	button.text = name_option
	buttonContainer.add_child(button)
	return button
