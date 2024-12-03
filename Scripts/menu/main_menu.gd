extends Control

@onready var test_button = $Test

var test : Array =[
	"Test",
]

func _ready():
	SceneSound.launch_music_menu()

	var dir = DirAccess.open("res://Scenes/test/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				test.push_back(file_name)
				print(test)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

	add_name_for_button_test(test, test_button)

func add_name_for_button_test(name_items : Array, option_button : OptionButton):
	for name_item in name_items:
		option_button.add_item(name_item)

func _on_test_item_selected(index: int) -> void:
	get_tree().change_scene_to_file("res://Scenes/test/{0}".format([test[index]]))

func _on_new_game_button_pressed():
	get_tree().change_scene_to_file("res://node.tscn")

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/setting/video.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
