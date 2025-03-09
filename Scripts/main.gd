class_name SoraMain
extends Node

var settings: SoraSettings = SoraSettings.new()

# var settings = SoraSett

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var default_settings: SoraDefaultSettings = SoraDefaultSettings.new()
	
	print(default_settings.VSYNC)
	
	settings.add_settings(
		"resolution", 
		default_settings.get_RESOLUTION_DEFAULT(),
		default_settings.RESOLUTIONS
	)
	
	settings.add_settings(
		"window_mode", 
		default_settings.WINDOW_MODE_DEFAULT,
		default_settings.WINDOW_MODE
	)
	
	settings.add_settings(
		"MSAA", 
		default_settings.MSAA_DEFAULT,
		default_settings.MSAA
	)
	
	settings.add_settings(
		"vsync", 
		default_settings.VSYNC_DEFAULT,
		default_settings.VSYNC
	)
	
	settings.save()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
