class_name MouseModeCommand
extends BaseCommand

## Configuration initiale : Nom, description et déclaration des options
func _setup() -> void:
	self._command_name = "mouse"
	self._description = "Permet de changer l'états du pointeur de la souris"

	self._add_options(
		&"captured",
		&"Rend la souris invisible",
		self._on_mouse_mode.bind(Input.MOUSE_MODE_CAPTURED)
	)

	self._add_options(
		&"confined",
		&"Bloque la souris dans la fenètre",
		self._on_mouse_mode.bind(Input.MOUSE_MODE_CONFINED)
	)

	self._add_options(
		&"confined_hiden",
		&"Bloque la souris dans la fenètre et la rend invisible",
		self._on_mouse_mode.bind(Input.MOUSE_MODE_CONFINED_HIDDEN)
	)

	self._add_options(
		&"hiden",
		&"rend la souris invisible et libre de la fenétre",
		self._on_mouse_mode.bind(Input.MOUSE_MODE_HIDDEN)
	)

	self._add_options(
		&"visible",
		&"Rend la souris visible et libre de la fenétre",
		self._on_mouse_mode.bind(Input.MOUSE_MODE_VISIBLE)
	)	

	# Optionnel : Enregistrer des options/flags avec leur callback respectif
	# _add_options("-v", "Exécute en mode verbeux", _exec_verbose)

func _on_mouse_mode(_args, mouse) -> String:
	Input.set_mouse_mode(mouse)
	return "Mouse set mode : %s" % mouse 

## Propositions d'autocomplétion dynamiques (Optionnel)
func _get_autocomplete(_args: PackedStringArray) -> Array[String]:
	# Proposer des arguments dynamiques à la touche Tab (ex: liste d'items, cartes, etc.)
	# return ["valeur_1", "valeur_2"]
	return []


## Logique principale exécutée si aucune option n'a été spécifiée
func _exec(_args: PackedStringArray) -> String:
	return self.get_help()


# --- Exemple de callback pour option (Facultatif) ---
# func _exec_verbose(args: PackedStringArray) -> Dictionary:
# 	# Utiliser DebugCommands.build_response(message, close_console) si tu veux fermer la console après exécution
# 	return DebugCommands.build_response("Exécution verbeuse terminée !", true)
