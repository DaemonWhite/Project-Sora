extends Control

@onready var res_option_button = $ColorRect/OptionButton

@onready var change_window = $ColorRect/OptionButton2 as OptionButton

@onready var change_msaa = $ColorRect/OptionButton3

@onready var change_TAA : CheckBox = $ColorRect/TAA_CheckBox

@onready var change_FXAA : CheckBox = $ColorRect/FXAA_CheckBox

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

#[]

const window_mode_array : Array = [
	["plein écran",DisplayServer.WINDOW_MODE_FULLSCREEN],
	["Fenêtré sans bordure",DisplayServer.WINDOW_FLAG_BORDERLESS],
	["Fenêtré",DisplayServer.WINDOW_MODE_WINDOWED]
]

const msaa : Array = [
	["MSAA Disable", Viewport.MSAA_DISABLED],
	["MSAA 2X", Viewport.MSAA_2X],
	["MSAA 4X", Viewport.MSAA_4X],
	["MSAA 8X", Viewport.MSAA_8X]
]
 

func _ready():
	change_window.item_selected.connect(on_window_mode_selected)
	##add_resolutions()
	add_name_item_for_option_button(resolutions, res_option_button)
	add_name_item_for_option_button(window_mode_array, change_window)
	add_name_item_for_option_button(msaa, change_msaa)
	select_current_window_mode()
	var resolution = get_window().get_size()
	select_current_option(
		"{0}x{1}".format([resolution[0], resolution[1]]),
		res_option_button
	)
	var aliasing = ProjectSettings.get_setting("rendering/anti_aliasing/quality/msaa_3d")
	select_current_option(msaa[aliasing][0] ,change_msaa)
	
	change_TAA.button_pressed = ProjectSettings.get_setting("rendering/anti_aliasing/quality/use_taa")
	
	change_FXAA.button_pressed = ProjectSettings.get_setting("rendering/anti_aliasing/quality/screen_space_aa")


func select_current_option(option : String, option_button : OptionButton):
	for i in range(0,option_button.item_count):
		#print(option, option_button.get_item_text(i))
		if option == option_button.get_item_text(i):
			option_button.select(i)

func add_resolutions():
	var current_resolution = get_window().get_size()
	var ID = 0
	
	for resolution_size in resolutions:
		res_option_button.add_item(resolution_size)

		if resolutions[resolution_size] == current_resolution:
			res_option_button.select(ID)
		
		ID += 1

func _on_option_button_item_selected(index : int):
	get_window().set_size(resolutions[index][1])
	Centre_Window()
	
func Centre_Window():
	var Centre_Screen = DisplayServer.screen_get_position() + DisplayServer.screen_get_size()/2
	var Window_size = get_window().get_size_with_decorations()
	get_window().set_position(Centre_Screen - Window_size/2)
	
func add_name_item_for_option_button(name_items : Array, option_button : OptionButton):
	for name_item in name_items:
		option_button.add_item(name_item[0])

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

	Centre_Window()
	
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


func _on_retour_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")


func _on_audio_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/setting/audio.tscn")

func _on_graphisme_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/setting/video.tscn")

func _on_v_sync_check_box_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _on_option_button_3_item_selected(index : int) -> void:
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", msaa[index][1])
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_2d", msaa[index][1])
	
func _on_taa_check_box_toggled(toggled_on: bool) -> void:
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/use_taa", toggled_on)

func _on_fxaa_check_box_toggled(toggled_on: bool) -> void:
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/screen_space_aa", toggled_on)
