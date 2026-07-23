class_name ContainerSettings
extends Control
## Container pour accuellir les composant basée sur [BaseSettingsComponent]

## Le container de composant
@onready var container = $HBoxContainer/VBoxContainer/ScrollContainer/VBoxContainer
## Le menu de description des composants
@onready var description = $HBoxContainer/VBoxContainer/Description

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

## Méthode permetant l'ajout de composant
func add_component(component: BaseSettingsComponent) -> void:
	container.add_child(component)
	container.queue_sort()

## Méthode permetant de changer le texte de la description
func set_description(text: String) -> void:
	description.text = text

## Méthode permetant de cacher la description
func hide_description() -> void:
	description.text = ""
	description.hide()

## Méthode permetant de montrer la description
func show_description() -> void:
	description.show()
