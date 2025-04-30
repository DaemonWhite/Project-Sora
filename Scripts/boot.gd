class_name SoraBoot
extends Node

# var settings = SoraSett

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BaseSettings.set_path_settings("user://sora_settings.cfg")
	BaseSettings.load()

	var resolution = ResolutionSetting.new()
	MsaaSetting.new()
	VsyncSetting.new()
	TaaSetting.new()
	FxaaSetting.new()
	var screen = ScreenSetting.new() # Teste screen
	# screen.set_current_option(1)
	# screen.apply(false)
	var window = WindowModeSetting.new()
	window.apply_signal.connect(Callable(resolution, "event_apply"))
	window.apply(false)
	MasterSoundSetting.new()
	var keyboard = KeyboardSettings.new()
	
	var s = BaseSettings.get_settings_by_name(
		BaseSettings.GROUP.GRAPHICS, 
		"RESOLUTION"
	)
	
	print("RESOLUTION Recup -> ", s.get_current_option())
	
	print("RESOLUTION Not Default -> ", s.is_not_default())
	
	s.set_current_option("1920") # Doit echouer
	s.set_current_option("1920x1080")
	
	print("RESOLUTION Diffenret -> ", s.is_different())
	
	s.apply()
	
	var input_event = InputEventKey.new()
	input_event.keycode = KEY_F2
	var event_key = keyboard.get_key_settings("ui_up")
	event_key.add_event(input_event)
	event_key.apply(false)
	# event_key.remove_event(input_event) # Pour supprimer l'action tester
	BaseSettings.save()
