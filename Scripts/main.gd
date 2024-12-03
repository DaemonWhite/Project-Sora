
class_name SoraMain
extends Node

var settings: SoraSettings = SoraSettings.new()

# var settings = SoraSett

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var list_settings: DefaultSettings = DefaultSettings.new()
	
	settings.add_settings(
		"resolution", 
		list_settings.resolution_default,
		list_settings.resolutions
	)
	
	settings.add_settings(
		"window_mode", 
		list_settings.window_mode_default,
		list_settings.window_mode
	)
	
	settings.add_settings(
		"MSAA", 
		list_settings.msaa_default,
		list_settings.msaa
	)
	
	settings.add_settings(
		"vsync", 
		list_settings.vsync_default,
		list_settings.vsync
	)
	
	settings.save()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
