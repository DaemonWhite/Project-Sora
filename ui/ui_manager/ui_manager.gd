class_name UIManager
extends Node
## UIManager est une classe qui permet la gestion des UI
##
## Le but de UIManager et de s'assurer que les menu ce superpose bien dans l'ordre voulue
## et que les focus sont bien donnée à tout les menu 


## Permet de choisir le layer voulue
enum LayerType {
	## Layer définie l'ors de l'eregistrement du menu
	DEFAULT = -1,
	## Layer des HUD
	HUD = 0,
	## Layer des MENU
	GAME_MENU = 100,
	## Layer des Menu Systeme
	SYSTEM_MENU = 200,
	## Layer des transition
	TRANSITION = 250,
	## Layer des Élément critique
	CRITICAL = 300,
	## Layer pour le debugage
	DEBUG = 1000
}

var _ui_registry: Dictionary[String, Variant] = {}

var _ui_stack: Array[BaseLayerUi] = []
var _cached_uis: Dictionary = {}

@onready var _layers: Dictionary = {
	LayerType.HUD: $HUDLayer,
	LayerType.GAME_MENU: $GameMenuLayer,
	LayerType.SYSTEM_MENU: $SystemMenuLayer,
	LayerType.TRANSITION: $TransitionLayer,
	LayerType.CRITICAL: $CriticalLayer,
	LayerType.DEBUG: $DebugLayer
}


## Permet l'enregistrement d'un nouvelle UI
##
## Note: Unique doit êtres mis à false pour les menu non unique
func register_ui(ui_id: StringName, ui_resource: Variant, layer: LayerType, unique: bool = true) -> void:
	if not (ui_resource is PackedScene or ui_resource is String):
		push_error("Ressource invalide pour l'enregistrement de l'UI : ", ui_id)
		return
	
	self._ui_registry[ui_id] = { 
		"resource": ui_resource, 
		"layer": layer,
		"unique": unique
	}

## Peremt de désenregistrer un menu
func unregister_ui(ui_id: StringName) -> void:
	self._ui_registry.erase(ui_id)
	if self._cached_uis.has(ui_id):
		self._cached_uis[ui_id].queue_free()
		self._cached_uis.erase(ui_id)

## Permet d'ajouter un menu à une scène 
##
## Note il n'affiche pas les menu
## Seul les menu modal désactive les élèment du dessous
func push_ui(ui_id: StringName, layer: LayerType = LayerType.DEFAULT) -> BaseLayerUi:
	# Calque cible
	var target_layer: LayerType = layer
	## Nombre de calque actif
	var insert_index_stack = self._ui_stack.size()

	if layer == LayerType.DEFAULT:
		if not self._ui_registry.has(ui_id):
			push_error("L'UI suivante n'est pas enregistrée : ", ui_id)
			return null
		target_layer = self._ui_registry[ui_id]["layer"]

	# Vas récupérer l'ui dans le cache si présent
	var ui_instance = self._get_or_create_ui(ui_id, target_layer)
	if not ui_instance:
		return null

	# Regarde ou il doit insérer le calque
	for i in range(self._ui_stack.size() - 1, -1, -1):
		var prev_ui = _ui_stack[i]
		var prev_layer = prev_ui.get_meta("layer_priority")
		
		# Si le menu qu'on insère est plus (ou aussi) prioritaire, il va au-dessus
		if target_layer >= prev_layer:
			insert_index_stack = i + 1
			break
		else:
			insert_index_stack = i
	
	if _ui_stack.has(ui_instance):
		_ui_stack.erase(ui_instance)
	

	self._ui_stack.insert(insert_index_stack, ui_instance)
	
	self._update_stack_states()
	
	return ui_instance


## Ferme l'ui désirer ATTENTION Les UI non Unique ne sont pas supporter
func pop_ui(ui_id: StringName, c_clear_chache: bool = false) -> void:
	if not _cached_uis.has(ui_id):
		push_warning("Tentative de fermer une UI qui n'est pas instanciée : ", ui_id)
		return
		
	var ui_instance: BaseLayerUi = _cached_uis[ui_id]
	
	if _ui_stack.has(ui_instance):
		ui_instance.close()
		if c_clear_chache:
			self.clear_cache(ui_id)

## Permet de supprimer un élèment du cache
##
## A utiliser pour des menu gourmand comme MainMenu
## cela évitera au de garder des information lourd en mémoire 
func clear_cache(ui_id: StringName):
	if not _cached_uis.has(ui_id):
		push_warning("Tentative de supprimer une UI qui n'est pas instanciée : ", ui_id)

	var ui_instance = _cached_uis[ui_id]
	self._cached_uis.erase(ui_id)
	ui_instance.queue_free()

## Permet de vider le cache
##
## Vider le cache fermera tout les menu faites attention
func clear_all_cache():
	for ui_id in _cached_uis:
		var ui_instance = _cached_uis[ui_id]
		if is_instance_valid(ui_instance):
			ui_instance.queue_free()
	self._cached_uis.clear()

func _get_or_create_ui(ui_id: StringName, layer: LayerType) -> BaseLayerUi:
	var is_unique = self._ui_registry[ui_id]["unique"]

	if self._cached_uis.has(ui_id) and is_unique:
		return self._cached_uis[ui_id]
	
	var source = self._ui_registry[ui_id]["resource"]
	var packed_scene: PackedScene
	
	if source is String:
		packed_scene = load(source) as PackedScene 
	else:
		packed_scene = source

	## TODO Ajouter une sécuritée ICI
		
	var raw_instance = packed_scene.instantiate()

	if not raw_instance is BaseLayerUi:
		push_error("L'UI suivante n'est pas une instance de BaseLayerUi : ", ui_id)
		return null

	var instance: BaseLayerUi = raw_instance as BaseLayerUi

	# Permet la fermeture automatique de décaharger correctement l'ui
	instance.closed.connect(self._on_ui_closed)
	instance.opened.connect(self._on_ui_opened)

	# Récupère le layer par défaut
	if layer == LayerType.DEFAULT:
		layer = self._ui_registry[ui_id]["layer"]

	# Définie ça priorité
	instance.set_meta("layer_priority", layer)

	self._layers[layer].add_child(instance)
	
	if is_unique:
		self._cached_uis[ui_id] = instance
	
	return instance

func _update_stack_states() -> void:
	var has_modal_above: bool = false
	var focus_ui: BaseLayerUi = null 

	for i in range(_ui_stack.size() - 1, -1, -1):
		var ui = _ui_stack[i]
		
		if focus_ui == null:
			focus_ui = ui 

		if has_modal_above:
			# Un menu modal est au-dessus, on gèle celui-ci
			ui.process_mode = Node.PROCESS_MODE_DISABLED
		else:
			# Ce menu est actif
			ui.process_mode = ui.active_process_mode
			if ui.is_modal:
				has_modal_above = true

	if focus_ui.is_modal and focus_ui != null and focus_ui.process_mode != Node.PROCESS_MODE_DISABLED :
		focus_ui.grab_focus_on_default()


func _on_ui_opened(ui_instance: BaseLayerUi) -> void:
	## Rajoute à la stack si l'ui à dispaure
	if self._ui_stack.find(ui_instance) > -1:
		return

	var key_ui: String = self._cached_uis.find_key(ui_instance)
	print(key_ui)
	if key_ui:
		print("ok")
		self.push_ui(
			key_ui
		)

func _on_ui_closed(ui_instance: BaseLayerUi) -> void:
	if self._ui_stack.has(ui_instance):
		self._ui_stack.erase(ui_instance)

	ui_instance.process_mode = ui_instance.closed_process_mode
		
	self._update_stack_states()

	## Evite les fuites de mémoire en détruisant les objet non unique
	if not self._cached_uis.values().has(ui_instance):
		ui_instance.queue_free()
