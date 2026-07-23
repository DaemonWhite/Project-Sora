class_name KeyboardSettings
extends Object

## Génère dynamiquement les inputs
## 
## Permet de génèrer dynamiquement la configuration des [KeySettings] à 
## partir de [InputMap] il est recommander de l'activer au lancement du projet
## pour éviter d'ajouter des inputs temporaires non désiré

static var _map_keyboard: Array[KeySettings]

static func init():
	for action in InputMap.get_actions():
		KeyboardSettings._map_keyboard.append(
				KeySettings.new(
					action, 
					InputMap.action_get_events(action))
			)
			
## Retourne toute les entrées clavier enregistrer
static func get_keyboard_settings() -> Array[KeySettings]:
	return KeyboardSettings._map_keyboard
	
## Renvoi une configuration clavier précise
static func get_key_settings(action: String) -> KeySettings:
	var key = null
	
	for key_search in KeyboardSettings._map_keyboard:
		if key_search.get_name() == action:
			key = key_search
			 
	return key
	
