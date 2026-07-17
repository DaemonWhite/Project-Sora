extends BaseLayerUi

@onready var tabSettings = $VBoxContainer/TabSetting;

var settings = BaseSettings;

const COMPOENT_PATH = "res:///Scenes/menu/components/settings/"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self._init_tab_settings()


func _init_tab_settings() -> void:
	const groups = BaseSettings.GROUP

	var index = 3

	for group in groups.values():
		index = self._init_settings_by_group(group, index)

func _init_settings_by_group(group_enum: BaseSettings.GROUP, index: int) -> int:
	var list_settings = BaseSettings.get_settings_by_enum(group_enum)

	if len(list_settings) <= 0:
		return index

	var name = BaseSettings.get_group_to_string(group_enum)
	var tab = Control.new()
	var tabContainer = load(COMPOENT_PATH + "containerSettings.tscn").instantiate()
	tab.add_child(tabContainer)
	tab.name = name

	tabSettings.add_tab(
		EventOverlay.new(
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

	tab.add_component(component)

func _on_key_add_pressed(component: KeyChooseSettingsBox) -> void:
	var dialog_choose_key = UiManager.push_ui(&"DialogChooseKey")
	dialog_choose_key.closed.connect(
		self._on_closed_key_choose_setting.bind(component)
	)
	dialog_choose_key.open()

func _on_closed_key_choose_setting( 
			dialog_choose_key: DialogChooseKey,
			component: KeyChooseSettingsBox
		) -> void:
	var choose_key = dialog_choose_key.get_choose_key()

	if choose_key != null:
		match component.add_key(choose_key):
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
	self.close()

func _on_description_changed(text: String, tab: Control) -> void:
	tab.set_description(text)

func resets() -> void:
	BaseSettings.resets()
	BaseSettings.save()

func _on_reset_pressed() -> void:
	var dialogConfirm = UiManager.push_ui(&"DialogConfirm")
	dialogConfirm.setup(
		tr("Reset Settings"), 
		tr("Are you sure you want to reset all settings to their default values?")
	)
	dialogConfirm.open()
	if not dialogConfirm.confirmed.is_connected(self.resets):
		dialogConfirm.confirmed.connect(self.resets)
