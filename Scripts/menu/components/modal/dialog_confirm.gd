@tool
class_name DialogConfirm
extends Dialog

@onready 
var canceled_button = $CenterContainer/PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/Cancel
@onready 
var confirmed_button = $CenterContainer/PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/Valide

signal confirmed
signal canceled

func _on_cancel_pressed() -> void:
	self.canceled.emit()
	self.close()

func _on_valide_pressed() -> void:
	self.confirmed.emit()
	self.close()