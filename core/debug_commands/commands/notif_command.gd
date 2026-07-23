class_name NotifCommand
extends BaseCommand


## Configuration initiale : Nom, description et déclaration des options
func _setup() -> void:
	self._command_name = "notif_test"
	self._description = "Permet d'envoyer une notif au systéme de notification \notif_test title message"
	
	# Optionnel : Enregistrer des options/flags avec leur callback respectif
	# _add_options("-v", "Exécute en mode verbeux", _exec_verbose)


## Propositions d'autocomplétion dynamiques (Optionnel)
func _get_autocomplete(_args: PackedStringArray) -> Array[String]:
	# Proposer des arguments dynamiques à la touche Tab (ex: liste d'items, cartes, etc.)
	# return ["valeur_1", "valeur_2"]
	return []


## Logique principale exécutée si aucune option n'a été spécifiée
func _exec(args: PackedStringArray) -> String:
	if args.is_empty():
		return "[color=orange]Erreur : argument requis.[/color]"

	if not GameSignals.send_notification.has_connections():
		return "[color=orange]Envoyer dans le buffer[/color] !"

	var message = ""

	if args.size() > 1:
		message = args[1]

	GameSignals.send_notification.emit(
		NotificationData.new(
			args[0],
			message
		)
	)

	return "Commande [color=green]exécutée avec succès[/color] !"


# --- Exemple de callback pour option (Facultatif) ---
# func _exec_verbose(args: PackedStringArray) -> Dictionary:
# 	# Utiliser DebugCommands.build_response(message, close_console) si tu veux fermer la console après exécution
# 	return DebugCommands.build_response("Exécution verbeuse terminée !", true)
