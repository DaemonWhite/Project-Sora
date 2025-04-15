class_name SlideOptionSettings
extends BaseSettings
## Permet de creer une configuration avec une valeurs minimum et maximum
##
## Permet de créer une configuratation avec de la gestion d'erreur baser sur un slider
## avec une limite minimum et maximum [br]
## Example de configuration
## [codeblock]
## class_name MasterSoundSetting
## extends SlideOptionSettings
## 
## func _ready():
##     self._name = "MASTER" " Nom obligatoire
##     self._group = BaseSettings.GROUP.SOUND # Categorie obligatoire
## 
##	   self._min = 0.0 # Valeur minimum obligatoire
##	   self._max = 1.0 # Valeur maximum obligatoire
## 
##	   self._default_option = 0.7 # Valeur par défaut obligatoire
## [/codeblock]


## Valeur minimum
var _min: float
## Valeur maximum
var _max: float

## Change le paramètre courant un [float] est attendue sii non fait rien	
func set_current_option(value: Variant):
	if self._min <= value or self._max >= value:
		self._current_option = value
	else:
		push_warning("Valeur hors plage")
