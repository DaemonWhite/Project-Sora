extends Control

@onready var res_option_button = $ColorRect/OptionButton

@onready var change_window = $ColorRect/OptionButton2 as OptionButton

@onready var change_msaa = $ColorRect/OptionButton3

@onready var change_TAA : CheckBox = $ColorRect/TAA_CheckBox

@onready var change_FXAA : CheckBox = $ColorRect/FXAA_CheckBox

@onready var change_vsync = $ColorRect/VSync_OptionButton4

@onready var change_ecran = $ColorRect/Selec_ecran_OptionButton4


## Liste des résolutions Format 16/9
const resolutions : Array = [
	["2560x1440", Vector2i(2560,1440)],
	["1920x1080", Vector2i(1920,1080)],
	["1366x768", Vector2i(1366,768)],
	["1536x864", Vector2i(1536,864)],
	["1280x720", Vector2i(1280,720)],
	["1440x900", Vector2i(1440,900)],
	["1600x900", Vector2i(1600,900)],
	["1024x600", Vector2i(1024,600)],
	["800x600", Vector2i(800,600)]
]

## Liste des modes de fenètrages
const window_mode_array : Array = [
	["plein écran",DisplayServer.WINDOW_MODE_FULLSCREEN],
	["Fenêtré sans bordure",DisplayServer.WINDOW_FLAG_BORDERLESS],
	["Fenêtré",DisplayServer.WINDOW_MODE_WINDOWED]
]

## Qualiter de l'anticréage
const msaa : Array = [
	["MSAA Disable", Viewport.MSAA_DISABLED],
	["MSAA 2X", Viewport.MSAA_2X],
	["MSAA 4X", Viewport.MSAA_4X],
	["MSAA 8X", Viewport.MSAA_8X]
]
 
## Liste des vsync disponible
const vsync : Array = [
	["Disable", DisplayServer.VSYNC_DISABLED],
	["Enable", DisplayServer.VSYNC_ENABLED],
	["Adaptive", DisplayServer.VSYNC_ADAPTIVE],
	["Mailbox", DisplayServer.VSYNC_MAILBOX]
]

func _ready():
	var liste_ecran : Array
	var nb_ecran = DisplayServer.get_screen_count()
	for i in range(0,nb_ecran):
		liste_ecran.push_back(["Ecran : {0}".format([i+1]), i])

	
	change_window.item_selected.connect(on_window_mode_selected)
	##add_resolutions()
	add_name_item_for_option_button(resolutions, res_option_button)
	add_name_item_for_option_button(window_mode_array, change_window)
	add_name_item_for_option_button(msaa, change_msaa)
	add_name_item_for_option_button(vsync, change_vsync)
	add_name_item_for_option_button(liste_ecran, change_ecran)
	
	select_current_window_mode()
	
	var resolution = get_window().get_size()
	select_current_option(
		"{0}x{1}".format([resolution[0], resolution[1]]),
		res_option_button
	)
	
	
	var aliasing = ProjectSettings.get_setting("rendering/anti_aliasing/quality/msaa_3d")
	select_current_option(msaa[aliasing][0] ,change_msaa)
	
	var v_sync = ProjectSettings.get_setting("display/window/vsync/vsync_mode")
	select_current_option(vsync[v_sync][0], change_vsync)
	
	var ecran_courant = get_viewport().get_window().current_screen
	select_current_option(liste_ecran[ecran_courant][0], change_ecran)
	
	change_TAA.button_pressed = ProjectSettings.get_setting("rendering/anti_aliasing/quality/use_taa")
	
	change_FXAA.button_pressed = ProjectSettings.get_setting("rendering/anti_aliasing/quality/screen_space_aa")

## Méthode pour sélectionner l'option par défaut d'un bouton
func select_current_option(option : String, option_button : OptionButton):
	for i in range(0,option_button.item_count):
		#print(option, option_button.get_item_text(i))
		if option == option_button.get_item_text(i):
			option_button.select(i)

#func add_resolutions():
	#var current_resolution = get_window().get_size()
	#var ID = 0
	#
	#for resolution_size in resolutions:
		#res_option_button.add_item(resolution_size)
#
		#if resolutions[resolution_size] == current_resolution:
			#res_option_button.select(ID)
		#
		#ID += 1

	
## Méthode pour centrer la fenêtre lorsque que l'on change de mode de fenêtrage
## @experimental: Problèmes avec le multiscreen
func centre_Window():
	var Centre_Screen = DisplayServer.screen_get_position() + DisplayServer.screen_get_size()/2
	var Window_size = get_window().get_size_with_decorations()
	get_window().set_position(Centre_Screen - Window_size/2)

## Méthode qui ajoute les choix à un menu déroulant
func add_name_item_for_option_button(name_items : Array, option_button : OptionButton):
	for name_item in name_items:
		option_button.add_item(name_item[0])
	
## Méthode qui permet de sélectionner le mode de fenêtre actuelle
func select_current_window_mode() -> void:
	#permet de récupérer de mode de fenêtre
	var mode = DisplayServer.window_get_mode()
	#ici on récupère l'état des bordures
	var borderless = DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS)
	match mode:
		#sert à garder la même type de fenêtre, ci dessous c'est pour le mode plein écrans
		DisplayServer.WINDOW_MODE_FULLSCREEN:
			change_window.select(0)

		#sert à garder la même type de fenêtre, ci dessous c'est pour le mode fenêtré
		DisplayServer.WINDOW_MODE_WINDOWED:
			if borderless:
				change_window.select(1)
			else:
				change_window.select(2)

# -------------------- EVENEMENT ---------------------------------------------------

## Evenement qui permet de changer le mode de fenêtrage
func on_window_mode_selected(index : int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, true)

		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)

	centre_Window()

## Méthode pour sélectionner la résolution 
func _on_option_button_item_selected(index : int):
	get_window().set_size(resolutions[index][1])
	centre_Window()

## Evenment qui sélectionne le mode de vsync
func _on_v_sync_option_button_4_item_selected(index: int) -> void:
	ProjectSettings.set_setting("display/window/vsync/vsync_mode", vsync[index][1])

## Evenement qui sélectionne le msaa 2d et 3d
func _on_option_button_3_item_selected(index : int) -> void:
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", msaa[index][1])
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_2d", msaa[index][1])

## Evenement qui active ou désactive le taa
func _on_taa_check_box_toggled(toggled_on: bool) -> void:
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/use_taa", toggled_on)

## Evenement qui active ou désactive le fxaa
func _on_fxaa_check_box_toggled(toggled_on: bool) -> void:
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/screen_space_aa", toggled_on)

## Evenement qui sélectionner l'écran
func _on_selec_ecran_option_button_4_item_selected(index: int) -> void:
	# get_viewport retourne la vue qui elle à pour réfèrence l'écran principale
	# get_window nous permet donc de récupérer la fenètres principale
	get_viewport().get_window().current_screen = index

func _on_retour_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")

func _on_audio_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/setting/audio.tscn")

func _on_graphisme_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/setting/video.tscn")

func _on_controlle_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu/setting/control.tscn")
