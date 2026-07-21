class_name BaseCommand
extends RefCounted

## Nom de la commande
var _command_name: String = ""
## Description de la commande
var _description: String = ""

## Dictionnaire stockant les options disponibles
var _options: Dictionary = {}

func _init() -> void:
	_setup()

## À surcharger pour définir le nom, la description et les options
func _setup() -> void:
	pass

func setup():
	self._setup()

func _add_options(arg_name: String, arg_description: String, callback: Callable) -> void:
	self._options[arg_name] = {
		"name": arg_name,
		"description": arg_description,
		"exec": callback
	}

## À surcharger dans les commandes filles pour proposer des arguments dynamiques (ex: noms de maps, items...)
func _get_autocomplete(_args: PackedStringArray) -> Array[String]:
	return []

## Retourne la liste des suggestions d'autocomplétion filtrées
func get_autocomplete(args: PackedStringArray) -> Array[String]:
	if args.size() >= 3 or self._options.is_empty():
		return self._get_autocomplete(args)

	if  args.size() == 2:
		var suggestions: Array[String] = []
		for value in self._options.values():
			suggestions.push_back(value["name"])
		return suggestions

	return []

## À surcharger pour la logique principale
func _exec(_args: PackedStringArray) -> String:
	push_error("Erreur : La méthode _exec() n'a pas été surchargée pour la commande ", self._command_name)
	return ""

## Méthode d'exécution principale
func exec(args: PackedStringArray) -> Dictionary:
	var final_args: PackedStringArray = []
	var option_callback: Callable = Callable()

	for arg in args:
		if self._options.has(arg):
			option_callback = self._options[arg]["exec"]
		else:
			final_args.append(arg)

	if option_callback.is_valid():
		var res = option_callback.call(final_args)
		if res is Dictionary:
			return res
		return DebugCommands.build_response(str(res))
	
	return DebugCommands.build_response(self._exec(final_args))

func get_name() -> String:
	return self._command_name

func get_description() -> String:
	return self._description

func get_help() -> String:
	var output: String = "%s" % self._command_name
	output += "\n%s" % self.get_description()
	output += "[color=light_gray]"
	for option in self._options.values():
		output += "[ul]{name} -> {description}[/ul]".format(option)
	output += "[/color]"

	if self._options.is_empty():
		output += "\n"
	return output