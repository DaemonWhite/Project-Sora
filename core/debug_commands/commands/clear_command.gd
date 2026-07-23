class_name ClearCommand
extends BaseCommand


## Configuration initiale : Nom, description et déclaration des options
func _setup() -> void:
	self._command_name = "clear"
	self._description = "Nettoie la console"
	
	# Optionnel : Enregistrer des options/flags avec leur callback respectif
	# _add_options("-v", "Exécute en mode verbeux", _exec_verbose)


## Propositions d'autocomplétion dynamiques (Optionnel)
func _get_autocomplete(_args: PackedStringArray) -> Array[String]:
	# Proposer des arguments dynamiques à la touche Tab (ex: liste d'items, cartes, etc.)
	# return ["valeur_1", "valeur_2"]
	return []


## Logique principale exécutée si aucune option n'a été spécifiée
func _exec(_args: PackedStringArray) -> String:
	var tree = Engine.get_main_loop() as SceneTree
	if tree:
		var liste = tree.get_nodes_in_group("Debug")
		for node in liste:
			if node is Console:
				node.clear_log()
				return ""

	return "Impossible de nettoyer la console"


# --- Exemple de callback pour option (Facultatif) ---
# func _exec_verbose(args: PackedStringArray) -> Dictionary:
# 	# Utiliser DebugCommands.build_response(message, close_console) si tu veux fermer la console après exécution
# 	return DebugCommands.build_response("Exécution verbeuse terminée !", true)
