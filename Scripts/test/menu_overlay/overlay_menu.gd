extends Control

var pause = false
@export var option_graphique:Control = null


func pause_unpause():
	pause = !pause
	if pause:
		get_tree().paused = true
		show()
	else:
		get_tree().paused = false
		hide()

func _input(event):
	if event.is_action_pressed("Pause"):
		pause_unpause()

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	hide()

func _on_option_button_pressed() -> void:
	hide()
	option_graphique.show()
	
func _on_retour_button_pressed() -> void:
	option_graphique.hide()
	show()

func _on_quitter_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")
