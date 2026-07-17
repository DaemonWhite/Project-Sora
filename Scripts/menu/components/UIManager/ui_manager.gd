class_name UIManager
extends Node

enum LayerType {
	DEFAULT = -1,
	HUD = 0,
	GAME_MENU = 100,
	SYSTEM_MENU = 200,
	TRANSITION = 250,
	CRITICAL = 300
}

var _ui_registry: Dictionary = {}

var _ui_stack: Array[BaseLayerUi] = []
var _cached_uis: Dictionary = {}

@onready var _layers: Dictionary = {
	LayerType.HUD: $HUDLayer,
	LayerType.GAME_MENU: $GameMenuLayer,
	LayerType.SYSTEM_MENU: $SystemMenuLayer,
	LayerType.TRANSITION: $TransitionLayer,
	LayerType.CRITICAL: $CriticalLayer
}


func register_ui(ui_id: StringName, ui_resource: Variant, layer: LayerType) -> void:
	if not (ui_resource is PackedScene or ui_resource is String):
		push_error("Ressource invalide pour l'enregistrement de l'UI : ", ui_id)
		return
	
	self._ui_registry[ui_id] = { 
		"resource": ui_resource, 
		"layer": layer 
	}

func unregister_ui(ui_id: StringName) -> void:
	self._ui_registry.erase(ui_id)
	if self._cached_uis.has(ui_id):
		self._cached_uis[ui_id].queue_free()
		self._cached_uis.erase(ui_id)


func push_ui(ui_id: StringName, layer: LayerType = LayerType.DEFAULT ) -> BaseLayerUi:
	var target_layer: LayerType = layer
	if layer == LayerType.DEFAULT:
		if not self._ui_registry.has(ui_id):
			push_error("L'UI suivante n'est pas enregistrée : ", ui_id)
			return null
		target_layer = self._ui_registry[ui_id]["layer"]

	var ui_instance = self._get_or_create_ui(ui_id, target_layer)
	if not ui_instance:
		return null
		
	if not self._ui_stack.is_empty():
		var active_ui = self._ui_stack.back()
		if ui_instance.is_modal:
			active_ui.process_mode = PROCESS_MODE_DISABLED
			
	self._ui_stack.append(ui_instance)
	ui_instance.open()
	return ui_instance


func pop_ui(ui_id: StringName, c_clear_chache: bool = false) -> void:
	if not _cached_uis.has(ui_id):
		push_warning("Tentative de fermer une UI qui n'est pas instanciée : ", ui_id)
		return
    	
	var ui_instance = _cached_uis[ui_id]
    
	if _ui_stack.has(ui_instance):
		ui_instance.close()
		if c_clear_chache:
			self.clear_cache(ui_id)

func clear_cache(ui_id: StringName):
	if not _cached_uis.has(ui_id):
		push_warning("Tentative de supprimer une UI qui n'est pas instanciée : ", ui_id)

	var ui_instance = _cached_uis[ui_id]
	self._cached_uis.erase(ui_id)
	self.ui_instance.queue_free()

func clear_all_cache():
	for ui_id in _cached_uis:
		var ui_instance = _cached_uis[ui_id]
		if is_instance_valid(ui_instance):
			ui_instance.queue_free()
	self._cached_uis.clear()

func _get_or_create_ui(ui_id: StringName, layer: LayerType) -> BaseLayerUi:
	if self._cached_uis.has(ui_id):
		return self._cached_uis[ui_id]
		
	var source = self._ui_registry[ui_id]["resource"]
	var packed_scene: PackedScene

	print("UIManager: Creating UI instance for ", ui_id)
	print("UIManager: Source type: ", typeof(source))
	
	if source is String:
		packed_scene = load(source) as PackedScene # Lazy Loading (chargement à la demande)
	else:
		packed_scene = source # Déjà chargée en mémoire
		
	var raw_instance = packed_scene.instantiate()

	if not raw_instance is BaseLayerUi:
		push_error("L'UI suivante n'est pas une instance de BaseLayerUi : ", ui_id)
		return null

	var instance: BaseLayerUi = raw_instance as BaseLayerUi

	instance.closed.connect(_on_ui_closed)

	if layer == LayerType.DEFAULT:
		layer = self._ui_registry[ui_id]["layer"]

	self._layers[layer].add_child(instance)
	self._cached_uis[ui_id] = instance
	
	return instance

func _on_ui_closed(ui_instance: BaseLayerUi) -> void:
	if _ui_stack.has(ui_instance):
		_ui_stack.erase(ui_instance)
        
	var modal_to_reactivate: BaseLayerUi = null
    
	for i in range(_ui_stack.size() - 1, -1, -1):
		var ui = _ui_stack[i]
		if ui.is_modal:
			modal_to_reactivate = ui
			break
            
	if modal_to_reactivate:
		modal_to_reactivate.process_mode = PROCESS_MODE_INHERIT
		modal_to_reactivate.grab_focus_on_default()
