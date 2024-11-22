extends Node

@onready var music_menu = $Music_Menu
@onready var sound_click = $click

@onready var music_id = AudioServer.get_bus_index("Music")
@onready var sfx_id = AudioServer.get_bus_index("SFX")

func launch_music_menu():
	music_menu.play()
	
func launch_click():
	sound_click.play()
	
func update_music_level(new_level):
	
	#change le niveau de décibel du bus Music
	AudioServer.set_bus_volume_db(music_id, linear_to_db(new_level))
	
	#Si on met le son à 0 cela mute le bus
	AudioServer.set_bus_mute(music_id, new_level == 0)

func update_sfx_level(new_level):
	AudioServer.set_bus_volume_db(sfx_id, linear_to_db(new_level))

func get_music_level():
	
	#permet de garder le même volume lorsque l'on quitte la page audio
	return db_to_linear(AudioServer.get_bus_volume_db(music_id))
	
func get_sfx_level():
	return db_to_linear((AudioServer.get_bus_volume_db(sfx_id)))
