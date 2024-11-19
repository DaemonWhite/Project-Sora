extends Control

func _ready():
	SceneSound.launch_music_menu()
	
	%slider_music.value = SceneSound.get_music_level()
	%slider_effect.value = SceneSound.get_effect_level()

func _on_retour_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")


func _on_graphisme_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/setting/video.tscn")


func _on_audio_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/setting/audio.tscn")


func _on_slider_music_value_changed(value):
	SceneSound.update_music_level(value)
	

func _on_slider_effect_value_changed(value):
	SceneSound.update_effect_level(value)
