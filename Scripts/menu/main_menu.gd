extends BaseLayerUi

@onready var test_button = $TestSelect
@onready var tabs = $SwitchMenuTabs


var test : Array =[
	"Test",
]

func _ready():
	SceneSound.launch_music_menu()
	search_rercursif_file("")
	add_name_for_button_test(test, test_button)

func search_rercursif_file(sub_folder : String):
	var dir = DirAccess.open("res://Scenes/test/{0}".format([sub_folder]))
	if dir:
		dir.list_dir_begin()
		var file_and_folder_name = dir.get_next()
		while file_and_folder_name != "":
			if dir.current_is_dir():
				search_rercursif_file("{0}/{1}".format([sub_folder, file_and_folder_name]))
			else:
				test.push_back("{0}/{1}".format([sub_folder, file_and_folder_name]))
			file_and_folder_name = dir.get_next()
	else:
		push_error("An error occurred when trying to access the path.")

func add_name_for_button_test(name_items : Array, option_button : OptionButton):
	for name_item in name_items:
		option_button.add_item(name_item)

func _on_test_item_selected(index: int) -> void:
	get_tree().change_scene_to_file("res://Scenes/test/{0}".format([test[index]]))

func _on_new_game_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/test/menu_overlay/test_menu.tscn")

func _on_options_button_pressed():
	UiManager.push_ui(&"SettingsMenu")

func _on_exit_button_pressed():
	get_tree().quit()

func _on_return_button_pressed() -> void:
	tabs.current_tab = 0