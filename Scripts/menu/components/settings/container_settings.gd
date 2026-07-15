class_name ContainerSettings
extends Control

@onready var container = $HBoxContainer/VBoxContainer/ScrollContainer/VBoxContainer
@onready var description = $HBoxContainer/VBoxContainer/Description

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func add_component(component: BaseSettingsComponent) -> void:
	container.add_child(component)
	container.queue_sort()

func set_description(text: String) -> void:
	description.text = text

func hide_description() -> void:
	description.text = ""
	description.hide()

func show_description() -> void:
	description.show()