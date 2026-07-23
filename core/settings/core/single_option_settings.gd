class_name  SingleOptionSettings
extends BaseSettings
## Paramètres unique
## 
## Une base pour créer des paramètres avec option connue, intègre une gestion d'erreur primitive.
## Pour plus de détailles sur comment créer votre jeux de règles référer vous à [BaseSettings]
## [br][br]
## Example pris de l'enfant [WindowModeSetting]
## [codeblock]
##	class_name WindowModeSetting
##	extends SingleOptionSettings
##	
##	func _ready() -> void:
##	    self._name = "WINDOW_MODE" # Nom du paramètre obligatoire
##	    self._group = BaseSettings.GROUP.GRAPHICS # Catégorie obligatoire
##	    self._options = { # Liste des options disponible
##	        "full_screen": DisplayServer.WINDOW_MODE_FULLSCREEN,
##	        "full_screen_exclusif": DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN,
##	        "Windowed": DisplayServer.WINDOW_MODE_WINDOWED
##	    }
##		
##	    self._default_option = "Windowed" # Paramètre par défaut
##	
##	# Logique métier si nécessaire à ne pas implémenter si elle est lourde utilisée le signal [BaseSettings.apply_signal] plutôt 
##	func _apply() -> void: 
##	    DisplayServer.window_set_mode(self._options[self._current_option])
##	
## [/codeblock]

## Liste des options disponible
var _options: Dictionary

## Renvoie toute la liste des options disponibles
func get_options() -> Dictionary:
	return _options

## Change l'option par défaut
## ne fait rien si valeurs non existantes dans option 
func set_current_option(value: Variant) -> bool:
	if self.exist_option(value):
		return super.set_current_option(value)
	push_warning("Options non existante", self)
	return false

func get_current_option_index() -> int:
	var keys = self._options.keys()
	for i in range(keys.size()):
		if keys[i] == self._current_option:
			return i
	return -1

## Vérifie la bonne présence de l'option
func exist_option(search: Variant) -> bool:
	if self._options.get(search) != null:
		return true
		
	return false
