extends Control

@onready var tabSettings = $TabSetting;

var settings = BaseSettings;

const COMPOENT_PATH = "res:///Scenes/menu/components/settings/"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self._init_tab_settings()


func _init_tab_settings() -> void:
	const groups = BaseSettings.GROUP

	var index = 3

	for group in groups.values():
		var name = BaseSettings.get_group_to_string(group)
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

		self._init_settings_by_group(group, tabContainer)

func _init_settings_by_group(group_enum: BaseSettings.GROUP, tab: ContainerSettings) -> void:
	var list_settings = BaseSettings.get_settings_by_enum(group_enum)
	for setting in list_settings:
		self._auto_build_component(setting, tab)
		

func _auto_build_component(setting: BaseSettings, tab: Control) -> void:
	var component_path = COMPOENT_PATH
	print("setting: ", setting)
	match setting:
		var n when n is BooleanOptionSettings:
			print("BooleanOptionSettings")
			component_path += "CheckBox.tscn"
		var n when n is KeySettings:
			push_warning("KeySettings n'est pas encore supporté dans le menu", self)
			return
		var n when n is SingleOptionSettings:
			print("SingleOptionSettings")
			component_path += "SelectOptions.tscn"
		var n when n is SlideOptionSettings:
			print("SlideOptionSettings")
			component_path += "Slider.tscn"
		
	print("component_path: ", component_path)

	var component_scene = load(component_path)
	var component = component_scene.instantiate()
	component.initialize(setting)
	tab.add_component(component)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
