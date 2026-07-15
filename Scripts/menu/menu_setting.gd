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
		print("index", index)

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
	print(tab)
	var component_path = COMPOENT_PATH
	print("setting: ", setting)
	match setting:
		var n when n is BooleanOptionSettings:
			print("BooleanOptionSettings")
			component_path += "CheckBox.tscn"
		var n when n is KeySettings:
			print("KeySettings")
			component_path += "KeyChoose.tscn"
			tab.hide_description()
		var n when n is SingleOptionSettings:
			print("SingleOptionSettings")
			component_path += "SelectOptions.tscn"
		var n when n is SlideOptionSettings:
			print("SlideOptionSettings")
			component_path += "Slider.tscn"
	
	var component_scene = load(component_path)
	var component = component_scene.instantiate()
	component.initialize(setting)
	component.mouse_entered.connect(
		self._on_description_changed.bind(setting.get_description(), tab)
	)
	tab.add_component(component)

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
	if not dialogConfirm.confirmed.is_connected(self.resets):
		dialogConfirm.confirmed.connect(self.resets)
