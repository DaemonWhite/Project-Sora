extends Control

func _ready():
	SceneSound.launch_music_menu()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://node.tscn")

func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/setting/video.tscn")

func _on_button_3_pressed():
	get_tree().quit()
