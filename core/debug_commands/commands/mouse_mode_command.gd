class_name MouseModeCommand
extends BaseCommand

var _mouse_options: Dictionary[String, int]

## Configuration initiale : Nom, description et déclaration des options
func _setup() -> void:
	self._command_name = "mouse"
	self._description = "Permet de changer l'états du pointeur de la sours"
	
	self._mouse_options = {
		"captured" : Input.MOUSE_MODE_CAPTURED,
		"confined" : Input.MOUSE_MODE_CONFINED,
		"confined_hiden" : Input.MOUSE_MODE_CONFINED_HIDDEN,
		"hiden" : Input.MOUSE_MODE_HIDDEN,
		"max": Input.MOUSE_MODE_MAX,
		"visible": Input.MOUSE_MODE_VISIBLE
	}

	# Optionnel : Enregistrer des options/flags avec leur callback respectif
	# _add_options("-v", "Exécute en mode verbeux", _exec_verbose)


## Propositions d'autocomplétion dynamiques (Optionnel)
func _get_autocomplete(_args: PackedStringArray) -> Array[String]:
	# Proposer des arguments dynamiques à la touche Tab (ex: liste d'items, cartes, etc.)
	# return ["valeur_1", "valeur_2"]
	return self._mouse_options.keys()


## Logique principale exécutée si aucune option n'a été spécifiée
func _exec(args: PackedStringArray) -> String:
	if args.is_empty() or not self._mouse_options.has(args[0]):
		var text = "Option disonible:[br]"
		for mouse in self._mouse_options.keys() :
			text += "[ul]%s[/ul]" % mouse 
		return text

	Input.set_mouse_mode(self._mouse_options[args[0]])

	return "Mouse mode set : %s" % args[0]


# --- Exemple de callback pour option (Facultatif) ---
# func _exec_verbose(args: PackedStringArray) -> Dictionary:
# 	# Utiliser DebugCommands.build_response(message, close_console) si tu veux fermer la console après exécution
# 	return DebugCommands.build_response("Exécution verbeuse terminée !", true)
