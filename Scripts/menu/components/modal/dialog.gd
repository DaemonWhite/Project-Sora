@tool
class_name Dialog
extends BaseLayerUi
## Modal de base pour Godot
## 
## Sert de base pour tous les popup/modal du jeu.
## Le script se base sur [BaseLayerUi] et doit être impérativement lancé avec [UIManager]


## Titre de la fenètres
@export var title: String = "" :
	set(value):
		title = value
		if is_node_ready() and titleLabel:
			titleLabel.text = title

## Description de la fenètres
@export_multiline var message: String = "" :
	set(value):
		message = value
		if is_node_ready() and descriptionLabel:
			descriptionLabel.text = message
 
## Active/Desactive le bouton de fermeture de la fenètres
@export var enabledCloseButton: bool = true :
	set(value):
		enabledCloseButton = value
		if is_node_ready() and closeButton:
			closeButton.visible = value

## Bouton de fermeture
@onready var closeButton: Button = $CenterContainer/PanelContainer/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/Close
## Titre de la fenétre
@onready var titleLabel: Label = $CenterContainer/PanelContainer/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/Title
## Texte au centre de la fenétre
@onready var descriptionLabel: RichTextLabel = $CenterContainer/PanelContainer/VBoxContainer/ChildContainer/Description
@onready var childContainer: Container = $CenterContainer/PanelContainer/VBoxContainer/ChildContainer

func _ready() -> void:
	super._ready()
	closeButton.visible = enabledCloseButton
	titleLabel.text = title
	descriptionLabel.text = message

## Définie les info de la fenètre
func setup(d_title: String, d_message: String) -> Dialog:
	self.title = d_title
	self.message = d_message
	return self

## Setter permettant de changer la visibilité du bouton de fermeture
func set_visible_close_button(visible_button: bool) -> void:
	self.enabledCloseButton = visible_button

func _on_close_pressed() -> void:
	self.close()
