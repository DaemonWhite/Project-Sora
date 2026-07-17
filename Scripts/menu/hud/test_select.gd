extends BaseLayerUi

@onready var select: OptionButton = $Select

const PATH_TEST = "res://Scenes/test/"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var list_scenes = Utils.search_recursif_file(PATH_TEST, ["tscn"])

	self.add_name_for_button_test("Test")
	
	for scene in list_scenes:
		self.add_name_for_button_test(scene.replace(PATH_TEST, ""))


func add_name_for_button_test(name_item : String):
	self.select.add_item(name_item)

func _on_select_item_selected(index: int) -> void:
	if index > 0:
		UiManager.pop_ui("MainMenu")
		var path = PATH_TEST + str(self.select.get_item_text(index))
		get_tree().change_scene_to_file(path)
		
