# meta-name: Commande Debug
# meta-description: Template complet pour BaseCommand (Options, Autocomplétion & Réponses)
# meta-default: true

class_name _CLASS_
extends BaseCommand


## Configuration initiale : Nom, description et déclaration des options
func _setup() -> void:
	self._command_name = "nom_de_la_commande"
	self._description = "Description de ce que fait la commande. Usage: nom_de_la_commande [options] [args]"
	
	# Optionnel : Enregistrer des options/flags avec leur callback respectif
	# _add_options("-v", "Exécute en mode verbeux", _exec_verbose)


## Propositions d'autocomplétion dynamiques (Optionnel)
func _get_autocomplete(_args: PackedStringArray) -> Array[String]:
	# Proposer des arguments dynamiques à la touche Tab (ex: liste d'items, cartes, etc.)
	# return ["valeur_1", "valeur_2"]
	return []


## Logique principale exécutée si aucune option n'a été spécifiée
func _exec(args: PackedStringArray) -> String:
	# 1. Exemple de vérification des arguments
	# if args.is_empty():
	# 	return "[color=orange]Erreur : argument requis.[/color]"

	# 2. Logique principale
	# var target_name: String = args[0]

	return "Commande [color=green]exécutée avec succès[/color] !"


# --- Exemple de callback pour option (Facultatif) ---
# func _exec_verbose(args: PackedStringArray) -> Dictionary:
# 	# Utiliser DebugCommands.build_response(message, close_console) si tu veux fermer la console après exécution
# 	return DebugCommands.build_response("Exécution verbeuse terminée !", true)