extends BaseLayerUi
## Zone des notification
##
## 

## Limite de notif afficher à l'écrans
@export var limit_display: int = 5
## Espce entre les notif
@export var spacing: float = 5.0

var _display_popup: Array[PopupNotification] = []
var _buffer_popup: Array[NotificationData] = []

var _reposition_queued: bool = false

var _incoming_queue: Array[NotificationData] = []
var _is_processing_queue: bool = false

var is_paused: bool = false

## Simple debounce s'assure que si la méthodeet harceler ne s'execute qu'une foi
func _queue_reposition() -> void:
	if self._reposition_queued:
		return
		
	self._reposition_queued = true
	call_deferred("_do_reposition")

##S Déverouille le debounce
func _do_reposition() -> void:
	self._reposition_queued = false
	self._reposition_notifications()


func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	super._ready()


## Appelée par l'UIManager pour ouvrir l'interface
func _start_open() -> void:
	GameSignals.send_notification.connect(self._on_send_notification)	

func _ended_open() -> void:
	await self.get_tree().process_frame
	NotificationManager.flush()

## Appelée par l'UIManager pour fermer l'interface
func _start_close() -> void:
	GameSignals.send_notification.disconnect(self._on_send_notification)
	await self.get_tree().process_frame

## Permet de mettre les notifation en pause
func set_notifications_paused(paused: bool) -> void:
	is_paused = paused
	
	# On propage l'état de pause à la notification actuellement affichée
	if self._display_popup.size() > 0:
		var active_popup = self._display_popup[0]
		if is_instance_valid(active_popup) and active_popup.has_method("set_paused"):
			active_popup.set_paused(paused)
			
	# Reprendre le traitement de la file d'attente s'il y a de la place et qu'on enlève la pause
	if not is_paused and self._incoming_queue.size() > 0:
		self._process_incoming_queue()

func _on_popup_died(popup: PopupNotification) -> void:
	# 1. Nettoyage de la popup qui vient de terminer son animation
	self._display_popup.erase(popup) # Plus sûr que pop_front au cas où
	popup.queue_free()

	# 2. Si on a du stock dans le buffer, on en fait entrer un nouveau à l'écran
	if self._buffer_popup.size() > 0:
		var data = self._buffer_popup.pop_front()
		var n_popup = self._build_popup(data)

		## Attend que le popup ce redimentione
		await self.get_tree().process_frame
		if n_popup:
			var start_y: float = 0.0
			for p in _display_popup:
				start_y += p.size.y + spacing
			n_popup.position = Vector2(0, start_y)
			await self.get_tree().process_frame
			n_popup.entrance()
			n_popup.visible = true
			self._display_popup.push_back(n_popup)

	# 3. On lance le chrono de la prochaine popup en haut de la liste (s'il y en a une)
	if self._display_popup.size() > 0:
		var next_popup = self._display_popup[0]
		# S'assurer qu'elle n'est pas déjà connectée pour éviter un double appel
		if not next_popup.deid.is_connected(self._on_popup_died):
			next_popup.deid.connect(self._on_popup_died)
			if not is_paused:
				next_popup.dead()

	self._queue_reposition()

func _add_notif_safe(data: NotificationData) -> void:
	# Si on a de la place à l'écran (< au lieu de <=)
	if self._display_popup.size() < limit_display:
		var popup = self._build_popup(data)
		if not popup:
			push_error("Notification: popup don't create", data)
			return
		
		
		var start_y: float = 0.0
		await self.get_tree().process_frame
		for p in _display_popup:
			start_y += p.size.y + spacing
		popup.position = Vector2(0, start_y)
		## Attend qu'il as fini de ce positioner
		await self.get_tree().process_frame
		popup.entrance()
		popup.visible = true

		self._display_popup.push_back(popup)

		# S'il n'y a que cette popup à l'écran, elle devient la première : on la lance
		if self._display_popup.size() == 1:
			popup.deid.connect(self._on_popup_died)
			popup.dead()
	else:
		# L'écran est plein, on met la donnée en attente
		self._buffer_popup.push_back(data)
	
	# On attend que Godot calcule la taille de la popup avant de recalculer les positions
	self._queue_reposition()

func _build_popup(data: NotificationData) -> PopupNotification:
	var scene = NotificationManager.get_scene_for_data(data)
	
	if scene:
		var popup = scene.instantiate() as PopupNotification
		popup.visible = false
		self.add_child(popup)
		popup.setup_from_data(data)
		return popup
	return null

func _process_incoming_queue() -> void:
	if _is_processing_queue:
		return
	
	_is_processing_queue = true
	
	while _incoming_queue.size() > 0:
		var data = _incoming_queue.pop_front()
		await _add_notif_safe(data)
	
	_is_processing_queue = false

func _on_send_notification(data: NotificationData) -> void:
	self._incoming_queue.push_back(data)
	self._process_incoming_queue()

func _reposition_notifications() -> void:
	var current_y: float = 0.0
	
	for notif in self._display_popup:
		# Sécurité : au cas où un nœud aurait été détruit
		if not is_instance_valid(notif): 
			continue
			
		var target_pos = Vector2(0, current_y)

		if notif.has_meta("pos_tween"):
			var old_tween = notif.get_meta("pos_tween") as Tween
			if is_instance_valid(old_tween) and old_tween.is_running():
				old_tween.kill()
		
		var tween = notif.create_tween()
		notif.set_meta("pos_tween", tween)
		
		tween.tween_property(notif, "position", target_pos, 0.35)\
			.set_trans(Tween.TRANS_CUBIC)\
			.set_ease(Tween.EASE_OUT)
			
		current_y += notif.size.y + spacing
