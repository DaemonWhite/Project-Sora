class_name ContainerSettings
extends Control

@onready var container = $VBoxContainer
@onready var description = $Description

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func add_component(component: BaseSettingsComponent) -> void:
	container.add_child(component)
	container.queue_sort()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
