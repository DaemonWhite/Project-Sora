extends Node

@onready var music_menu = $Music_Menu
@onready var sound_click = $click


func launch_music_menu():
	music_menu.play()
	music_menu.stop()
	
func launch_click():
	sound_click.play()
