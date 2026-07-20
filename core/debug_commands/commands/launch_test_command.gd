class_name LaunchTestCommand
extends BaseCommand

const PATH_TEST = "res://tests/"

var _list_scenes: Array[String] = []

## Configuration de la commande
func _setup() -> void:
	self._command_name = "scene_test"
	self._description = "Permet de lancer les scènes de test"

	self._add_options(
		"list", 
		"list les scènes disponible", 
		self._list_commands
	)

	self._add_options(
		"load",
		"Charge la scènes",
		self._load_game
	)

	self._list_scenes = Utils.search_recursif_file(PATH_TEST, ["tscn"])
	print(self._list_scenes)

## Logique principale de la commande (exécutée si aucune option ne correspond)
func _exec(_args: PackedStringArray) -> String:
	return self.get_help()

# --- Callbacks d'options (Facultatif) ---
# func _exec_verbose(args: PackedStringArray) -> String:
# 	return "Commande exécutée en mode verbeux !"

func _list_commands(_args: PackedStringArray):
	var output: String = ""

	print(self._list_scenes)
	for scene in self._list_scenes:
		output += "%s[br]" % scene

	return output

func _load_game(args: PackedStringArray):
	if args.size() == 1:
		return DebugCommands.build_response("Error enter path scene please".format(args))

	if not self._list_scenes.find(args) > -1:
		return DebugCommands.build_response("Error scene {0} not exist".format(args))		

	GameSignals.loading_game.emit(
		GameStateManager.State.GAMEPLAY,
		args[0]
	)

	return DebugCommands.build_response("Load scene: {0}".format(args[0]), true)
