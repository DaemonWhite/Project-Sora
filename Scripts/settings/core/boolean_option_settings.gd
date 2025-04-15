class_name BooleanOptionSettings
extends BaseSettings

## Permet de creer une configuration avec un simple boolean
##
## Permet de créer une configuratation avec de la gestion d'erreur baser sur boolean[br]
## Example de configuration
## [codeblock]
##  class_name TaaSetting
##  extends BooleanOptionSettings
##  
##  func _ready():
##      self._name = "TAA"
##      self._group = BaseSettings.GROUP.GRAPHICS
##  
##      self._default_option = false
## [/codeblock]

## Change le paramètre courant un [bool] est attendue si non fait rien
func set_current_option(value: Variant) -> void:
	if value is bool:
		self._current_option = value
	else:
		push_warning("Valeur non bollean")