class_name KeyboardSettings
extends Object

## Génère dynamiquement les inputs
## 
## Permet de génèrer dynamiquement la configuration des [KeySettings] à 
## partir de [InputMap] il est recommander de l'activer au lancement du projet
## pour éviter d'ajouter des inputs temporaires non désiré

var _map_keyboard: Array[KeySettings]

func _init():
	for action in InputMap.get_actions():
		self._map_keyboard.append(
				KeySettings.new(
					action, 
					InputMap.action_get_events(action))
			)
			
## Retourne toute les entrées clavier enregistrer
func get_keyboard_settings() -> Array[KeySettings]:
	return self._map_keyboard
	
## Renvoi une configuration clavier précise
func get_key_settings(action: String) -> KeySettings:
	var key = null
	
	for key_search in self._map_keyboard:
		if key_search.get_name() == action:
			key = key_search
			 
	return key
	
