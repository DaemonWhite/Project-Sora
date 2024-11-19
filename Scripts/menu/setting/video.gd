extends Control

@onready var ResOptionButton = $Control/OptionButton

@onready var Change_window = $Control/OptionButton2 as OptionButton


var Resolutions : Dictionary = {"2560x1440": Vector2i(2560,1440),
								"1920x1080": Vector2i(1920,1080),
								"1366x768": Vector2i(1366,768),
								"1536x864": Vector2i(1536,864),
								"1280x720": Vector2i(1280,720),
								"1440x900": Vector2i(1440,900),
								"1600x900": Vector2i(1600,900),
								"1024x600": Vector2i(1024,600),
								"800x600": Vector2i(800,600),
}

const Window_mode_array : Array[String] = [
	"Plein écrans",
	"Fenêtré sans bordure",
	"Fenêtré"
]
 
func _ready():
	add_window_mode_items()
	Change_window.item_selected.connect(on_window_mode_selected)
	AddResolutions()
	Check_variables()
	
func Check_variables():
	var _window = get_window()
	var mode = _window.get_mode()
	#
	if mode == Window.MODE_WINDOWED:
		Change_window.set_pressed_no_signal(true)

func AddResolutions():
	for r in Resolutions:
		ResOptionButton.add_item(r)

func _on_option_button_item_selected(index):
	var ID = ResOptionButton.get_item_text(index)
	get_window().set_size(Resolutions[ID])
	Centre_Window()
	
func Centre_Window():
	var Centre_Screen = DisplayServer.screen_get_position()+DisplayServer.screen_get_size()/2
	var Window_size = get_window().get_size_with_decorations()
	get_window().set_position(Centre_Screen - Window_size/2)

func add_window_mode_items() -> void:
	for window_mode in Window_mode_array:
		Change_window.add_item(window_mode)

func on_window_mode_selected(index : int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			Centre_Window()
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			Centre_Window()
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			Centre_Window()
	
#func _on_full_screen_check_box_toggled(toggled_on):
	#if toggled_on: 
		#get_window().set_mode(Window.MODE_FULLSCREEN)
	#else:
		#get_window().set_mode(Window.MODE_WINDOWED)
		#Centre_Window()
#
#func _on_check_box_toggled(toggled_on):
	#if toggled_on: 
		#get_window().set_mode(Window.MODE_WINDOWED)
		#DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	#else:
		#get_window().set_mode(Window.MODE_WINDOWED)
		#DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		#Centre_Window()

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
