class_name NotificationManager
extends RefCounted

# Registre des scènes par défaut selon le Type
static var SCENE_PATHS: Dictionary = {
	NotificationData.Type.INFO: "res://ui/hud/notification/popup_notification.tscn",
	NotificationData.Type.QUEST: "res://ui/hud/notification/popup_notification.tscn",
	NotificationData.Type.ITEM: "res://ui/hud/notification/popup_notification.tscn"
}

# Cache en RAM pour éviter la relecture du disque dur avec load()
static var _scene_cache: Dictionary = {}
# Matient en mémoire les notif impossible à envoyer
static var buffer: Array[NotificationData] = []

## Point d'entrée principal
static func send(data: NotificationData) -> void:
	if GameSignals.send_notification.has_connections():
		GameSignals.send_notification.emit(data)
	else:
		buffer.push_back(data)

# --- RACCOURCIS ---

static func send_info(title: String, message: String, duration: float = 5.0) -> void:
	send(NotificationData.new(title, message, duration, NotificationData.Type.INFO))

static func send_error(message: String) -> void:
	send(NotificationData.new("Erreur", message, 4.0, NotificationData.Type.ERROR))

static func send_item(item_name: String, item_icon: Texture2D) -> void:
	var msg = "Obtenu : " + item_name
	send(NotificationData.new("Objet", msg, 4.0, NotificationData.Type.ITEM, item_icon))

## Récupération intelligente de la scène (Custom -> Cache RAM -> Disk)
static func get_scene_for_data(data: NotificationData) -> PackedScene:
	# 1. Scène sur-mesure si elle a été fournie
	if data.custom_scene != null:
		return data.custom_scene
		
	# 2. Scène en cache RAM
	if _scene_cache.has(data.type):
		return _scene_cache[data.type]
		
	# 3. Chargement initial depuis le disque
	var path = SCENE_PATHS.get(data.type, "")
	if path != "" and ResourceLoader.exists(path):
		var loaded_scene = load(path) as PackedScene
		_scene_cache[data.type] = loaded_scene
		return loaded_scene
		
	push_error("NotificationManager: Aucune scène trouvée pour le type " + str(data.type))
	return null

static func flush() -> void:
	if not GameSignals.send_notification.has_connections():
		return 
	
	for notif_data in NotificationManager.buffer:
		GameSignals.send_notification.emit(notif_data)

	NotificationManager.buffer.clear()

static func clear_buffer() -> void:
	NotificationManager.buffer.clear()