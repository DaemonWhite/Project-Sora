extends Control

@onready var change_avancer = $ColorRect/Control/Avancer_Button

@onready var change_reculer = $ColorRect/Control/Reculer_Button

@onready var change_gauche = $ColorRect/Control/Gauche_Button

@onready var change_droit = $ColorRect/Control/Droite_Button

@onready var change_saut = $ColorRect/Control/Sauter_Button

@onready var change_courir = $ColorRect/Control/Courir_Button

@onready var change_vue = $ColorRect/Control/Vue_Button

@onready var change_accroupie = $ColorRect/Control/accroupie_Button

@onready var change_interagir = $ColorRect/Control/interagir_Button

@onready var change_inventaire = $ColorRect/Control/inventaire_Button

@onready var change_carte = $ColorRect/Control/carte_Button

@onready var change_marcher = $ColorRect/Control/marcher_Button

@onready var change_ramper = $ColorRect/Control/ramper_Button

var analyser_entree : bool = false

var select_button_index : int

const controle : Array = [
	["Z", KEY_W],
	["S", KEY_S],
	["Q", KEY_A],
	["D", KEY_D],
	["Espace", KEY_SPACE],
	["Maj G", KEY_SHIFT],
	["F", KEY_F],
	["Ctrl", KEY_CTRL],
	["E", KEY_E],
	["I", KEY_I],
	["M", KEY_M],
	["Lock Maj", KEY_CAPSLOCK],
	["C", KEY_C]
]

@onready var boutons : Array = [
	$ColorRect/Control/Avancer_Button,
	$ColorRect/Control/Reculer_Button,
	$ColorRect/Control/Gauche_Button,
	$ColorRect/Control/Droite_Button,
	$ColorRect/Control/Sauter_Button,
	$ColorRect/Control/Courir_Button,
	$ColorRect/Control/Vue_Button,
	$ColorRect/Control/accroupie_Button,
	$ColorRect/Control/interagir_Button,
	$ColorRect/Control/inventaire_Button,
	$ColorRect/Control/carte_Button,
	$ColorRect/Control/marcher_Button,
	$ColorRect/Control/ramper_Button
]

func _ready() -> void:

	for i in range(0, boutons.size()):
		add_name_for_button(controle[i], boutons[i])


func add_name_for_button(key : Array, button : Button):
	button.text = key[0]

##Fonction pour désactiver tout les boutons
func disabled_all_boutton(time_sleep: float = 0.5):
	await get_tree().create_timer(time_sleep).timeout
	for bouton in boutons:
		bouton.disabled = true

##Fonction pour activer tout les boutons
func enabled_all_boutton(time_sleep: float = 0.5 ):
	await get_tree().create_timer(time_sleep).timeout
	for bouton in boutons:
		bouton.disabled = false

##Fonction pour afficher lors d'un appuis sur le bouton le texte pour changer de touche
func change_button_for_control(change_button : Button):
	if change_button.pressed and not analyser_entree:
		change_button.text = "Entrer une touche"
		analyser_entree = true
		disabled_all_boutton(0)

func _on_avancer_button_pressed() -> void:
	change_button_for_control(change_avancer)
	select_button_index = 0
	
func _on_reculer_button_pressed() -> void:
	change_button_for_control(change_reculer)
	select_button_index = 1

func _on_gauche_button_pressed() -> void:
	change_button_for_control(change_gauche)
	select_button_index = 2

func _on_droite_button_pressed() -> void:
	change_button_for_control(change_droit)
	select_button_index = 3

func _on_sauter_button_pressed() -> void:
	change_button_for_control(change_saut)
	select_button_index = 4

func _on_courir_button_pressed() -> void:
	change_button_for_control(change_courir)
	select_button_index = 5

func _on_vue_button_pressed() -> void:
	change_button_for_control(change_vue)
	select_button_index = 6

func _on_accroupie_button_pressed() -> void:
	change_button_for_control(change_accroupie)
	select_button_index = 7

func _on_interagir_button_pressed() -> void:
	change_button_for_control(change_interagir)
	select_button_index = 8

func _on_inventaire_button_pressed() -> void:
	change_button_for_control(change_inventaire)
	select_button_index = 9

func _on_carte_button_pressed() -> void:
	change_button_for_control(change_carte)
	select_button_index = 10
	
func _on_marcher_button_pressed() -> void:
	change_button_for_control(change_marcher)
	select_button_index = 11
	
func _on_ramper_button_pressed() -> void:
	change_button_for_control(change_ramper)
	select_button_index = 12

##Fonction pour changer les touches
func _input(event: InputEvent) -> void:
	if event.is_pressed() and analyser_entree:
		var thread = Thread.new()
		boutons[select_button_index].text = event.as_text()
		analyser_entree = false
		thread.start(Callable(self, "enabled_all_boutton"))
		

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
