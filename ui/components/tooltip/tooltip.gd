class_name ToolTip
extends PanelContainer
## Tooltip est une infobule concu pour ce placer dynamiquement
##
## Tooltip ce place dynamiquement sur n'importe qu'elle objet de type [Controle]
## Sont parent peut êtres définie à la main ou automatiquement à l'initialisation
## La classe sert de base elle à peut d'intérer seul


## Définie si le tooltip doit ce placer en HAUT, BAS, GAUCHE, DROITE
enum Placement { TOP, BOTTOM, LEFT, RIGHT }

## Postion par défaut de l'élèment
@export var placement: Placement = Placement.TOP:
	get:
		return placement
	set(value):
		placement = value
		self.replace()
	
## La marge du tooltip
@export var margin: float = 5.0 

## L'objet au quel il est relier
var parent: Control = null 

func _ready() -> void:
	# Si le parent n'a pas déjà été défini par set_parent()
	if self.parent == null:
		self.parent = self.get_parent() as Control
		
	self.set_visibility_layer_bit(2, true)
	self.replace()

## Permet de surdéfinir le parent
func set_parent(c_control: Control) -> void:
	self.parent = c_control
	self.replace()

## Sert à reposition l'élèment sur l'image
func replace() -> void:
	if not self.parent is Control:
		push_error("Not parent define")
		return

	self.reset_size()
	
	# Récupération des tailles et positions
	var t_size: Vector2 = self.get_combined_minimum_size()
	var p_pos: Vector2 = self.parent.global_position
	var p_size: Vector2 = self.parent.size
	
	var new_pos: Vector2 = p_pos
	
	# Calcul de la position selon l'option choisie
	match self.placement:
		Placement.TOP:
			new_pos.y = p_pos.y - t_size.y - self.margin
		Placement.BOTTOM:
			new_pos.y = p_pos.y + p_size.y + self.margin
		Placement.LEFT:
			new_pos.x = p_pos.x - t_size.x - self.margin
		Placement.RIGHT:
			new_pos.x = p_pos.x + p_size.x + self.margin

	self.global_position = new_pos
	self.show()