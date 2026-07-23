class_name HelpCommand
extends BaseCommand


func _setup() -> void:
	self._command_name = "help"
	self._description = "Liste toutes les commandes possibles."


## Propositions d'autocomplétion dynamiques (Optionnel)
func _get_autocomplete(_args: PackedStringArray) -> Array[String]:
	# Proposer des arguments dynamiques à la touche Tab (ex: liste d'items, cartes, etc.)
	# return ["valeur_1", "valeur_2"]
	return []


## Logique principale exécutée si aucune option n'a été spécifiée
func _exec(_args: PackedStringArray) -> String:
	var output: String = ""
	for command in DebugCommands.get_all_commands().values():
		output += "\n%s" % command.get_help()
	return  output


# --- Exemple de callback pour option (Facultatif) ---
# func _exec_verbose(args: PackedStringArray) -> Dictionary:
# 	# Utiliser DebugCommands.build_response(message, close_console) si tu veux fermer la console après exécution
# 	return DebugCommands.build_response("Exécution verbeuse terminée !", true)
