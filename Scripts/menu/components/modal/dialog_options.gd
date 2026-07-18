@tool
class_name DialogOptions
extends Dialog

@onready var buttonContainer: HFlowContainer = $CenterContainer/PanelContainer/VBoxContainer/ChildContainer/ButtonContainer

func add_option(name_option: String) -> Button:
	var button = Button.new()
	button.text = name_option
	buttonContainer.add_child(button)
	return button
