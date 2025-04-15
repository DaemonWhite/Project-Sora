class_name KeyboardSettings
extends Object

## Génère dynamiquement les inputs
## 
## Permet de génèrer dynamquement la configuration des [KeySettings] a 
## partir de [InputMap] il est recomander de l'activer au lancement du projet
## pour eviter d'ajouter des inputs temporaires non désirée

var _map_keyboard: Array[KeySettings]

func _init():
	for action in InputMap.get_actions():
		self._map_keyboard.append(
				KeySettings.new(
					action, 
					InputMap.action_get_events(action))
			)
			
## Retourne tout les entrer clavier enregistrer
func get_keyboard_settings() -> Array[KeySettings]:
	return self._map_keyboard
	
## Renvoi une configuration clavier précise
func get_key_settings(action: String) -> KeySettings:
	var key = null
	
	for key_search in self._map_keyboard:
		if key_search.get_name() == action:
			key = key_search
			 
	return key
	
