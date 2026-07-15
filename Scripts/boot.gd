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
	MouseSpeed.new()
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

	print(len(keyboard.get_keyboard_settings()))
	# event_key.remove_event(input_event) # Pour supprimer l'action tester
	BaseSettings.save()
	print("Settings saved to user://sora_settings.cfg")
	self._register_ui_manager()

	UiManager.push_ui(&"MainMenu")

func _register_ui_manager() -> void:
	UiManager.register_ui(&"MainMenu", "res://Scenes/menu/main_menu.tscn", UiManager.LayerType.SYSTEM_MENU)
	UiManager.register_ui(&"SettingsMenu", "res://Scenes/menu/menu_setting.tscn", UiManager.LayerType.SYSTEM_MENU)
	UiManager.register_ui(&"Dialog", "res://Scenes/menu/components/modal/Dialog.tscn", UiManager.LayerType.SYSTEM_MENU)
	UiManager.register_ui(&"DialogConfirm", "res://Scenes/menu/components/modal/DialogConfirm.tscn", UiManager.LayerType.SYSTEM_MENU)