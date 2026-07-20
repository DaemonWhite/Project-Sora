class_name SoraBoot
extends Node

# var settings = SoraSett

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Boot started")
	self._load_settings()
	self._register_ui_manager()
	self._register_tags_text()

	UiManager.push_ui(&"PauseMenu")
	UiManager.push_ui(&"TestSelect").open()
	print("Boot finished")

func _load_settings() -> void:
	const PATH_SETTINGS = "user://sora_settings.cfg"
	print("Path settings : ", PATH_SETTINGS)
	print("load_settings...")
	BaseSettings.set_path_settings(PATH_SETTINGS)
	BaseSettings.load()
	# Récupération de la liste des fichier
	var files_settings: Array = Utils.auto_load_scripts(
		"res://core/settings/list_setting/",
		"base_settings.gd",
		true
	)

	for file_setting in files_settings :
		print("Loaded : {0} -> {1}".format([file_setting.get_name(), file_setting.get_current_option()]))

	KeyboardSettings.init()

	BaseSettings.save()
	print("Settings loaded")

func _register_ui_manager() -> void:
	UiManager.register_ui(&"MainMenu", "res://ui/screens/menu_main/main_menu.tscn", UiManager.LayerType.GAME_MENU)
	UiManager.register_ui(&"PauseMenu", "res://ui/screens/menu_pause/menu_pause.tscn", UiManager.LayerType.GAME_MENU)
	UiManager.register_ui(&"SettingsMenu", "res://ui/screens/menu_settings/menu_settings.tscn", UiManager.LayerType.SYSTEM_MENU)
	UiManager.register_ui(&"Dialog", "res://ui/components/modal/dialog.tscn", UiManager.LayerType.SYSTEM_MENU, false)
	UiManager.register_ui(&"DialogConfirm", "res://ui/components/modal/dialog_confirm.tscn", UiManager.LayerType.SYSTEM_MENU, false)
	UiManager.register_ui(&"DialogChooseKey", "res://ui/components/modal/dialog_choose_key.tscn", UiManager.LayerType.SYSTEM_MENU)
	UiManager.register_ui(&"DialogOptions", "res://ui/components/modal/dialog_options.tscn", UiManager.LayerType.SYSTEM_MENU, false)
	UiManager.register_ui(&"TestSelect", "res://ui/hud/test_select/test_select.tscn", UiManager.LayerType.CRITICAL)
	UiManager.register_ui(&"Console", "res://ui/hud/console/console.tscn", UiManager.LayerType.DEBUG)
	print("Ui registered")

func _register_tags_text() -> void:
	TextFormatter.register_route("input", InputTranslator.get_action_key_text)
	print("Tags registered")
