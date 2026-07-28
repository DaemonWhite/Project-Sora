class_name BaseLayerUi
extends Control

## BaseLayerUi est une classe abstraite permetant la création d'élèment graphique
##
## BaseLayerUi et une base pour tout les élèment graphique qui apparaisse sous la forme
## de menu ou d'HUD il est concue pour êtres utiliser par [UIManager]

## Signal émis lorsque l'UI est complètement fermée
signal closed(ui: BaseLayerUi)

## Signal émis loreque l'ui est ouverte
signal  opened(ui: BaseLayerUi)

## Signal émis lorsque l'UI est complètement ouverte
signal openfinished

## Definie le type de menu cible
@export var target_game_state: GameStateManager.State = GameStateManager.State.MENU

## Définie si le menu à besoin d'une souris
@export var require_visible_mouse: bool = true

## Détermine si cette UI bloque les inputs des UIs situées en dessous (comportement modal)
@export var is_modal: bool = true

## Noeud qui doit prendre le focus par défaut (crucial pour le support manette/clavier)
@export var default_focus_node: Control = self

## Définie le process qu'il doit prendre l'ors de son ouverture
## [color=Orange][b] WARNING [/b][/color][br] open() ne change pas ça propriétée seul UIManager le fait
@export var active_process_mode: Node.ProcessMode = Node.PROCESS_MODE_INHERIT


## Définie le process qu'il doit prendre l'ors de sa fermeture 
## [color=Orange][b] WARNING [/b][/color][br] close() ne change pas ça propriétée seul UIManager le fait
## 
## Si il as bien étais ouvert avec [UIManger] il il sera appeler automatiquement
## Bien penser rampeler le emit
@export var closed_process_mode: Node.ProcessMode = Node.PROCESS_MODE_DISABLED

func _ready() -> void:
	hide()

## Avant que l'ui s'ouvre
func _start_open() -> void:
	pass

## Après que l'ui soit ouverte
func _ended_open() -> void:
	pass

## Appelée par l'UIManager pour ouvrir l'interface
func open() -> void:
	self.opened.emit(self)
	self._start_open()
	show()
	self.grab_focus_on_default()
	self._ended_open()
	openfinished.emit()


## Avant que l'ui ce ferme
func _start_close() -> void:
	pass

## Après que l'ui soit fermer
func _ended_close() -> void:
	pass


## Appelée par l'UIManager pour fermer l'interface
func close() -> void:
	self._start_close()
	hide()
	self._ended_close()
	closed.emit(self)

### Permet de donner le focus au noeud par défaut
func grab_focus_on_default() -> void:
	if default_focus_node and default_focus_node.is_inside_tree():
		# S'assure que le nœud autorise le focus s'il était sur FOCUS_NONE
		if default_focus_node.focus_mode == Control.FOCUS_NONE:
			push_warning("BaseLayerUi: Not focus mod in default", self)
			default_focus_node.focus_mode = Control.FOCUS_ALL	
		default_focus_node.grab_focus()
