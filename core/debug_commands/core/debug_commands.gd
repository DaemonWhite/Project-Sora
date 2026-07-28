class_name DebugCommands
extends RefCounted
## Classe métier gérant et éxécurtant les commandes
##
## 

static var _path_commands: String = "res://core/debug_commands/commands/"

static var _commands: Dictionary[String, BaseCommand] = {}

## Enregistree une nouvelle commande
static func register_command(name_command: String, command: BaseCommand) -> void:
	DebugCommands._commands[name_command] = command

## Récupère une commande
static func get_command(name_command: String) -> BaseCommand:
	if DebugCommands._commands.has(name_command):
		return DebugCommands._commands[name_command]
	return null

static func get_autocomplete(commands_array: PackedStringArray) -> Array[String]:

	if commands_array.size() > 1 and DebugCommands._commands.has(commands_array[0]):
		return DebugCommands._commands[commands_array[0]].get_autocomplete(commands_array)


	return DebugCommands._commands.keys()

## Récupère toute les commandes
static func get_all_commands() -> Dictionary:
	return DebugCommands._commands

static func auto_registered_command():
	var commands: Array = Utils.auto_load_scripts(
		DebugCommands._path_commands,
		"base_command.gd",
		true
	)

	for command in commands:
		command.setup()

	for command in commands:
		DebugCommands.register_command(
			command.get_name(),
			command
		)

static func build_response(response: String, close_console: bool = false) -> Dictionary:
	return {
		"response": response,
		"close_console": close_console
	}
	
## Méthode pour éxecuter une commande
static func exec(text: String) -> Dictionary:
	var raw_text = text.strip_edges()
	
	if raw_text.is_empty():
		return DebugCommands.build_response("")

	var commands_text: PackedStringArray = raw_text.split(" ", false)
	var command_name: String = commands_text[0]

	if not DebugCommands._commands.has(command_name):
		return DebugCommands.build_response(&"Unkow Commands : " + command_name)

	var command_instance: BaseCommand = DebugCommands._commands[command_name]
	
	var args = commands_text.slice(1)

	return command_instance.exec(args)