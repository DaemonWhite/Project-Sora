class_name VersionCommand
extends BaseCommand


## Configuration initiale : Nom, description et déclaration des options
func _setup() -> void:
	self._command_name = "version"
	self._description = "Donne la version actuelle et autre inforamtion complémentaire"
	
	# Optionnel : Enregistrer des options/flags avec leur callback respectif
	# _add_options("-v", "Exécute en mode verbeux", _exec_verbose)


## Propositions d'autocomplétion dynamiques (Optionnel)
func _get_autocomplete(_args: PackedStringArray) -> Array[String]:
	# Proposer des arguments dynamiques à la touche Tab (ex: liste d'items, cartes, etc.)
	# return ["valeur_1", "valeur_2"]
	return []


## Logique principale exécutée si aucune option n'a été spécifiée
func _exec(_args: PackedStringArray) -> String:
	var output = "[color=light_gray]" 
	output += Utils.get_version()  
	output += "[/color]"
	return output


# --- Exemple de callback pour option (Facultatif) ---
# func _exec_verbose(args: PackedStringArray) -> Dictionary:
# 	# Utiliser DebugCommands.build_response(message, close_console) si tu veux fermer la console après exécution
# 	return DebugCommands.build_response("Exécution verbeuse terminée !", true)
