extends Control

func _ready():
	
	$Control2/Slider_music.value = SceneSound.get_music_level()
	$Control2/Slider_effect.value = SceneSound.get_sfx_level()

func _on_retour_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")


func _on_graphisme_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/setting/video.tscn")


func _on_audio_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/setting/audio.tscn")


func _on_slider_music_value_changed(value):
	SceneSound.update_music_level(value)
	
#
func _on_slider_effect_value_changed(value):
	SceneSound.update_sfx_level(value)
