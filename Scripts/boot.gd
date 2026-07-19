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
    # Récupération de la liste des fichiers
	var files_settings = Utils.search_recursif_file(
        "res://Scripts/settings/list_setting/",
        ["gd", "gdc"]
    )


	for file in files_settings:
		var script = load(file) as GDScript
		
		if not script or not script.can_instantiate():
			continue

		var base_script = script.get_base_script()
		var is_valid_setting = false
		
		while base_script != null:
			if base_script.resource_path.get_file() == "base_settings.gd":
				is_valid_setting = true
				break
			base_script = base_script.get_base_script()
			
		if not is_valid_setting:
			push_warning("Le script ignoré (n'hérite pas de BaseSettings) : ", file)
			continue
			
		var settings = script.new()
		print("Loaded : {0} -> {1}".format([settings.get_name(), settings.get_current_option()]))

	KeyboardSettings.init()

	BaseSettings.save()
	print("Settings loaded")

func _register_ui_manager() -> void:
	UiManager.register_ui(&"MainMenu", "res://Scenes/menu/main_menu.tscn", UiManager.LayerType.GAME_MENU)
	UiManager.register_ui(&"PauseMenu", "res://Scenes/menu/PauseMenu.tscn", UiManager.LayerType.SYSTEM_MENU)
	UiManager.register_ui(&"SettingsMenu", "res://Scenes/menu/menu_setting.tscn", UiManager.LayerType.SYSTEM_MENU)
	UiManager.register_ui(&"Dialog", "res://Scenes/menu/components/modal/Dialog.tscn", UiManager.LayerType.SYSTEM_MENU, false)
	UiManager.register_ui(&"DialogConfirm", "res://Scenes/menu/components/modal/DialogConfirm.tscn", UiManager.LayerType.SYSTEM_MENU, false)
	UiManager.register_ui(&"DialogChooseKey", "res://Scenes/menu/components/modal/DialogChooseKey.tscn", UiManager.LayerType.SYSTEM_MENU)
	UiManager.register_ui(&"DialogOptions", "res://Scenes/menu/components/modal/DialogOptions.tscn", UiManager.LayerType.SYSTEM_MENU, false)
	UiManager.register_ui(&"TestSelect", "res://Scenes/menu/hud/TestSelect.tscn", UiManager.LayerType.CRITICAL)
	print("Ui registered")

func _register_tags_text() -> void:
	TextFormatter.register_route("input", InputTranslator.get_action_key_text)
	print("Tags registered")
