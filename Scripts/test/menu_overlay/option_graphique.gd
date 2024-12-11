extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _on_retour_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/test/menu_overlay/overlay_menu.tscn")
