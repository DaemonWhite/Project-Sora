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
	var project_name = ProjectSettings.get_setting("application/config/name")
	var project_version = ProjectSettings.get_setting("application/config/version")
	var godot_version = Engine.get_version_info()
	var os_name = OS.get_name()
	var os_distro = OS.get_distribution_name()
	var os_version = OS.get_version()


	var output = "[color=light_gray]" 
	output += project_name + " v" + project_version + "\n"
	output += "Godot : {major}.{minor}.{patch} {status} {build}\n".format(godot_version) 
	output += "Os\t" + os_name + " " + os_distro + " " + os_version 
	output += "[/color]"
	return output


# --- Exemple de callback pour option (Facultatif) ---
# func _exec_verbose(args: PackedStringArray) -> Dictionary:
# 	# Utiliser DebugCommands.build_response(message, close_console) si tu veux fermer la console après exécution
# 	return DebugCommands.build_response("Exécution verbeuse terminée !", true)
