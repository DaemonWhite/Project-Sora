extends Control

@onready var change_avancer = $ColorRect/Control/Avancer_Button

@onready var change_reculer = $ColorRect/Control/Reculer_Button

@onready var change_gauche = $ColorRect/Control/Gauche_Button

@onready var change_droit = $ColorRect/Control/Droite_Button

@onready var change_saut = $ColorRect/Control/Sauter_Button

@onready var change_courir = $ColorRect/Control/Courir_Button

var analyser_entree : bool = false

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

	for j in range(0, boutons.size()):
		change_button_for_control(boutons[j])
		
func add_name_for_button(key : Array, button : Button):
	button.text = key[0]

func change_button_for_control(change_button : Button):
	if change_button.pressed:
		change_button.text = "Assigner une nouvelle touche"
		analyser_entree = true

#func _on_avancer_button_pressed() -> void:
	#change_avancer.text = "Assigner une nouvelle touche"
	#analyser_entree = true

func _input(event: InputEvent) -> void:
	if event.is_pressed() and analyser_entree:
		change_avancer.text = event.as_text()
		analyser_entree = false

func _on_graphisme_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu/setting/video.tscn")


func _on_audio_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu/setting/audio.tscn")


func _on_controlle_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu/setting/control.tscn")


func _on_retour_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")


func _on_sensibilite_souris_value_changed(value: float) -> void:
	pass # Replace with function body.
