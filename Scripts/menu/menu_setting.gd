extends BaseLayerUi

@onready var tabSettings = $VBoxContainer/TabSetting;

var settings = BaseSettings;

const COMPOENT_PATH = "res:///Scenes/menu/components/settings/"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self._init_tab_settings()


func _init_tab_settings() -> void:
	const groups = BaseSettings.GROUP

	var index = 0

	for group in groups.values():
		index = self._init_settings_by_group(group, index)

func _init_settings_by_group(group_enum: BaseSettings.GROUP, index: int) -> int:
	var list_settings = BaseSettings.get_settings_by_enum(group_enum)

	if len(list_settings) <= 0:
		return index

	var name = BaseSettings.get_group_to_ui_name(group_enum)
	var tab = Control.new()
	var tabContainer = load(COMPOENT_PATH + "containerSettings.tscn").instantiate()
	tab.add_child(tabContainer)
	tab.name = name

	tabSettings.add_tab(
		EventBetterTabMenu.new(
			index, 
			"", 
			name
		),
		tab
	)
	index += 1

	for setting in list_settings:
		self._auto_build_component(setting, tabContainer)

	return index
		

func _auto_build_component(setting: BaseSettings, tab: Control) -> void:
	var component_path = COMPOENT_PATH
	match setting:
		var n when n is BooleanOptionSettings:
			component_path += "CheckBox.tscn"
		var n when n is KeySettings:
			component_path += "KeyChoose.tscn"
			tab.hide_description()
		var n when n is SingleOptionSettings:
			component_path += "SelectOptions.tscn"
		var n when n is SlideOptionSettings:
			component_path += "Slider.tscn"
	
	var component_scene = load(component_path)
	var component = component_scene.instantiate()
	component.initialize(setting)
	component.mouse_entered.connect(
		self._on_description_changed.bind(setting.get_description(), tab)
	)

	if component is KeyChooseSettingsBox:
		component.key_add_pressed.connect(self._on_key_add_pressed.bind(component))
		component.set_link_signals(self._on_event_change_key)

	tab.add_component(component)

func _on_key_add_pressed(component: KeyChooseSettingsBox) -> void:
	var dialog_choose_key = UiManager.push_ui(&"DialogChooseKey")
	dialog_choose_key.closed.connect(
		self._on_closed_key_choose_setting.bind(component)
	)
	dialog_choose_key.open()

func _on_closed_key_choose_setting( 
			dialog_choose_key: DialogChooseKey,
			component: KeyChooseSettingsBox,
			old_key: InputEvent = null
		) -> void:
	var choose_key = dialog_choose_key.get_choose_key()

	var call_event: Callable = component.add_key.bind(choose_key)
	if old_key != null:
		print("MODIFY")
		call_event = component.modify_key.bind(choose_key, old_key)

	if choose_key != null:
		match call_event.call():
			KeySettings.ADD_RESULT.ERROR_DUPLICATE:
				var ui = UiManager.push_ui("Dialog")
				ui.setup(
					tr("Error Add Key"),
					tr("Key already exist")
				)
				ui.open()
			KeySettings.ADD_RESULT.ERROR_INVALID_EVENT_TYPE:
				var ui = UiManager.push_ui("Dialog")
				ui.setup(
					tr("Error Add Key"),
					tr("Key not supported ")
				)
				ui.open()
	dialog_choose_key.closed.disconnect(
		self._on_closed_key_choose_setting.bind(component)
	)

func _on_return_pressed() -> void:
	if BaseSettings.is_differents():
		var dialog: DialogConfirm = UiManager.push_ui("DialogConfirm")
		dialog.setup(
			tr("Do you don't save ?"),
			tr("No changes have been saved. Are you sure you don't want to apply them?")
		)
	else:
		self.close()

func _on_description_changed(text: String, tab: Control) -> void:
	tab.set_description(text)

func _on_event_change_key(
		key_choose: KeyChooseSettingsBox,
		button: Button, 
		key: InputEvent
	) -> void:
	var dialogOptions: DialogOptions = UiManager.push_ui("DialogOptions")
	print(button.text)
	dialogOptions.setup(
		tr("Would you like to edit or delete a key %s?") % button.text,
		("")
	)

	var mon_theme = preload("res://Theme/menu.tres")

	var delete_button: Button = dialogOptions.add_option("Delete")
	var modify_button: Button = dialogOptions.add_option("Modify")

	delete_button.theme = mon_theme
	modify_button.theme = mon_theme

	delete_button.theme_type_variation = "ButtonError"
	modify_button.theme_type_variation = "ButtonSuccess"


	delete_button.pressed.connect(key_choose.remove_key.bind(key))
	delete_button.pressed.connect(dialogOptions.close)

	modify_button.pressed.connect(
		self._on_event_change_key_modify.bind(
			key_choose,
			key
		)
	)
	modify_button.pressed.connect(dialogOptions.close)

	dialogOptions.open()

func _on_event_change_key_modify(component, key) -> void:
	var dialog_choose_key = UiManager.push_ui(&"DialogChooseKey")
	dialog_choose_key.closed.connect(
		self._on_closed_key_choose_setting.bind(component, key)
	)
	dialog_choose_key.open()

## Remet à zero tout les paramètres
func resets() -> void:
	BaseSettings.resets()
	BaseSettings.save()

func _on_reset_pressed() -> void:
	var dialogConfirm = UiManager.push_ui(&"DialogConfirm")
	dialogConfirm.setup(
		tr("Reset Settings"), 
		tr("Are you sure you want to reset all settings to their default values?")
	)
	dialogConfirm.process_mode = Node.PROCESS_MODE_ALWAYS
	dialogConfirm.open()
	if not dialogConfirm.confirmed.is_connected(self.resets):
		dialogConfirm.confirmed.connect(self.resets)
