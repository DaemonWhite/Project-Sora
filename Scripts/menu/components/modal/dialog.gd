@tool
class_name Dialog
extends BaseLayerUi

@export var title: String = "" :
	set(value):
		title = value
		if is_node_ready() and titleLabel:
			titleLabel.text = title

@export_multiline var message: String = "" :
	set(value):
		message = value
		if is_node_ready() and descriptionLabel:
			descriptionLabel.text = message
 
@export var enabledCloseButton: bool = true :
	set(value):
		enabledCloseButton = value
		if is_node_ready() and closeButton:
			closeButton.visible = value

@onready var closeButton: Button = $CenterContainer/PanelContainer/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/Close
@onready var titleLabel: Label = $CenterContainer/PanelContainer/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/Title
@onready var descriptionLabel: RichTextLabel = $CenterContainer/PanelContainer/VBoxContainer/ChildContainer/Description
@onready var childContainer: Container = $CenterContainer/PanelContainer/VBoxContainer/ChildContainer

func _ready() -> void:
	closeButton.visible = enabledCloseButton
	titleLabel.text = title
	descriptionLabel.text = message

func setup(d_title: String, d_message: String) -> Dialog:
	self.title = d_title
	self.message = d_message
	return self

func set_visible_close_button(visible_button: bool) -> void:
	self.enabledCloseButton = visible_button

func _on_close_pressed() -> void:
	self.close()
