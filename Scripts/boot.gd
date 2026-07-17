class_name SoraBoot
extends Node

# var settings = SoraSett

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Boot started")
	self._load_settings()
	self._register_ui_manager()
	self._register_tags_text()

	UiManager.push_ui(&"TestSelect")
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
        ["gd"]
    )


	for file in files_settings:
		var script = load(file)
		if script and script.can_instantiate():
			var settings = script.new()
			# Vérification de sécurité avant d'appeler les méthodes
			if settings is BaseSettings:
				print("Loaded : {0} -> {1}".format([settings.get_name(), settings.get_current_option()]))
			else:
				push_warning("Le script {0} n'hérite pas de BaseSettings".format([file]))

	KeyboardSettings.init()

	BaseSettings.save()
	print("Settings loaded")

func _register_ui_manager() -> void:
	UiManager.register_ui(&"MainMenu", "res://Scenes/menu/main_menu.tscn", UiManager.LayerType.GAME_MENU)
	UiManager.register_ui(&"SettingsMenu", "res://Scenes/menu/menu_setting.tscn", UiManager.LayerType.SYSTEM_MENU)
	UiManager.register_ui(&"Dialog", "res://Scenes/menu/components/modal/Dialog.tscn", UiManager.LayerType.SYSTEM_MENU)
	UiManager.register_ui(&"DialogConfirm", "res://Scenes/menu/components/modal/DialogConfirm.tscn", UiManager.LayerType.SYSTEM_MENU)
	UiManager.register_ui(&"DialogChooseKey", "res://Scenes/menu/components/modal/DialogChooseKey.tscn", UiManager.LayerType.SYSTEM_MENU)
	UiManager.register_ui(&"TestSelect", "res://Scenes/menu/hud/TestSelect.tscn", UiManager.LayerType.CRITICAL)
	print("Ui registered")

func _register_tags_text() -> void:
	TextFormatter.register_route("input", InputTranslator.get_action_key_text)
	print("Tags registered")