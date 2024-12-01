extends Control

## Si ecoute le clavier
var analyser_entree : bool = false

## Index du bouton cliquer
var select_button_index : int

## Liste des touches clavier par défauts
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

## Liste des touches manettes par défauts
const controle_manette : Array = [
	["A", JOY_BUTTON_A],
	["L3", JOY_BUTTON_LEFT_STICK],
	["Flèche haut", JOY_BUTTON_DPAD_UP],
	["R3", JOY_BUTTON_RIGHT_STICK],
	["X", JOY_BUTTON_X],
	["Flèche droit", JOY_BUTTON_DPAD_RIGHT],
	["Select", JOY_BUTTON_SDL_MAX],
	["Flèche bas", JOY_BUTTON_DPAD_DOWN]
]

## Liste des boutons de controles
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

## Méthode pour désactiver l'interaction de tout les boutons
func disabled_all_boutton(time_sleep: float = 0.5):
	await get_tree().create_timer(time_sleep).timeout
	for bouton in boutons:
		bouton.disabled = true

## Méthode pour activer l'interaction de tout les boutons
func enabled_all_boutton(time_sleep: float = 0.5 ):
	await get_tree().create_timer(time_sleep).timeout
	for bouton in boutons:
		bouton.disabled = false

## Méthode pour afficher lors d'un appuis sur le bouton le texte pour changer de touche
func change_button_for_control(change_button : Button):
	if change_button.pressed and not analyser_entree:
		change_button.text = "Entrer une touche"
		analyser_entree = true
		disabled_all_boutton(0)

# ------------------------------------ EVENEMENT ---------------------------------------------------- #

func _on_avancer_button_pressed() -> void:
	var index: int = 0
	change_button_for_control(boutons[index])
	select_button_index = index
	
func _on_reculer_button_pressed() -> void:
	var index: int = 0
	change_button_for_control(boutons[index])
	select_button_index = index

func _on_gauche_button_pressed() -> void:
	var index: int = 0
	change_button_for_control(boutons[index])
	select_button_index = index

func _on_droite_button_pressed() -> void:
	var index: int = 0
	change_button_for_control(boutons[index])
	select_button_index = index

func _on_sauter_button_pressed() -> void:
	var index: int = 0
	change_button_for_control(boutons[index])
	select_button_index = index

func _on_courir_button_pressed() -> void:
	var index: int = 0
	change_button_for_control(boutons[index])
	select_button_index = index

func _on_vue_button_pressed() -> void:
	var index: int = 0
	change_button_for_control(boutons[index])
	select_button_index = index

func _on_accroupie_button_pressed() -> void:
	var index: int = 0
	change_button_for_control(boutons[index])
	select_button_index = index

func _on_interagir_button_pressed() -> void:
	var index: int = 0
	change_button_for_control(boutons[index])
	select_button_index = index

func _on_inventaire_button_pressed() -> void:
	var index: int = 0
	change_button_for_control(boutons[index])
	select_button_index = index

func _on_carte_button_pressed() -> void:
	var index: int = 0
	change_button_for_control(boutons[index])
	select_button_index = index
	
func _on_marcher_button_pressed() -> void:
	var index: int = 0
	change_button_for_control(boutons[index])
	select_button_index = index
	
func _on_ramper_button_pressed() -> void:
	var index: int = 0
	change_button_for_control(boutons[index])
	select_button_index = index

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

## Méthode hériter qui récupères les touches
## A l'intérieurs on retrouve la verification
## si une touche et appuyer et que le clavier et écouter.
func _input(event: InputEvent) -> void:
	if event.is_pressed() and analyser_entree:
		var thread = Thread.new()
		boutons[select_button_index].text = event.as_text()
		analyser_entree = false
		# Appelle différer
		thread.start(Callable(self, "enabled_all_boutton"))
		
