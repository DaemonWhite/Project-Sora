extends Control

@onready var change_avancer = $ColorRect/Control/Avancer_Button

@onready var change_reculer = $ColorRect/Control/Reculer_Button

@onready var change_gauche = $ColorRect/Control/Gauche_Button

@onready var change_droit = $ColorRect/Control/Droite_Button

@onready var change_saut = $ColorRect/Control/Sauter_Button

@onready var change_courir = $ColorRect/Control/Courir_Button

const controle : Array = [
	["Z", KEY_W],
	["S", KEY_S],
	["Q", KEY_A],
	["D", KEY_D],
	["Espace", KEY_SPACE],
	["Maj G", KEY_SHIFT]
]

func _ready() -> void:
	var boutons : Array = [
		change_avancer,
		change_reculer,
		change_gauche,
		change_droit,
		change_saut,
		change_courir
	]

	for i in range(0, boutons.size()):
		add_name_for_button(controle[i], boutons[i])

func add_name_for_button(key : Array, button : Button):
	button.text = key[0]

func _on_graphisme_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu/setting/video.tscn")


func _on_audio_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu/setting/audio.tscn")


func _on_controlle_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu/setting/control.tscn")


func _on_retour_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")
