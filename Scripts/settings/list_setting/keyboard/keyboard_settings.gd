class_name KeyboardSettings
extends Object

class Map:
	var keycode: Array
	var input_name

var _map_keyboard: Array[KeySettings]

func _init():
	for action in InputMap.get_actions():
		self._map_keyboard.append(
				KeySettings.new(
					action, 
					InputMap.action_get_events(action))
			)
			
func get_keyboard_settings() -> Array[KeySettings]:
	return self._map_keyboard
	
func get_key_settings(action: String) -> KeySettings:
	var key = null
	
	for key_search in self._map_keyboard:
		if key_search.get_name() == action:
			key = key_search
			 
	return key
	
