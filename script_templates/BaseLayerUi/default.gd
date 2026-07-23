# meta-name: UI Layer
# meta-description: Template complet pour UIManger (Options, Autocomplétion & Réponses)
# meta-default: true

class_name _CLASS_
extends BaseLayerUi

func _ready() -> void:
	super._ready()


## Appelée par l'UIManager pour ouvrir l'interface
func open() -> void:
	# Ajouter votre traitement avant ouverture
	super.open()

## Appelée par l'UIManager pour fermer l'interface
func close() -> void:
	# Ajouter votre traitemnt arpès fermeture
	super.close()
