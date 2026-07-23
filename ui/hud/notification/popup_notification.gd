@tool
class_name PopupNotification
extends PanelContainer
## Classe de base pour toute notification du jeu
##
## TODO Luis ajouter un vrai style

## Titre de la notif
@onready var title_label: Label = $HBoxContainer/VBoxContainer/Title
## Message de la noti
@onready var message_rich_text_label: RichTextLabel = $HBoxContainer/VBoxContainer/Message
## Timer de la notif
@onready var timer: Timer = $Timer
## Logo de la notif
@onready var icon_rect: TextureRect = $HBoxContainer/IconRect

# Icônes par défaut configurables dans l'inspecteur Godot
@export var default_icon: Texture2D

signal deid(popup_notification: PopupNotification)

func _ready() -> void:
	self.ready.emit()


## Configuration appliquée après le add_child()
func setup_from_data(data: NotificationData) -> void:
	title_label.text = data.title
	message_rich_text_label.text = data.message
	timer.wait_time = data.duration
	
	# Gestion de l'icône : Spécifique (objet) -> Sinon Par défaut (UI)
	if data.icon != null:
		icon_rect.texture = data.icon

	icon_rect.texture = default_icon

## Lance l'animation d'entrer de la notif
func entrance() -> void:
	self._animate_entrance()

func _animate_entrance() -> void:
	# 1. Attendre une frame pour que Godot calcule la vraie taille du contenu
	if not is_inside_tree():
		await ready
	
	
	# On enregistre la hauteur naturelle que la notification devrait avoir
	var target_height = size.y
	
	# 2. État initial : transparente et hauteur zéro
	self.modulate.a = 0.0
	self.custom_minimum_size.y = 0
	self.clip_children = CanvasItem.CLIP_CHILDREN_ONLY
	
	# 3. Animation d'ouverture
	var tween = self.create_tween().set_parallel(true)
	# Fondu d'apparition (0.0 -> 1.0)
	tween.tween_property(self, "modulate:a", 1.0, 0.3)
	
	# Déroulement vertical fluide qui pousse les autres notifications
	tween.tween_property(self, "custom_minimum_size:y", target_height, 0.3)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)

	self.position.x += 30.0
	tween.tween_property(
		self, 
		"position:x", 
		self.position.x - 30.0, 0.3
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	# Une fois l'apparition terminée, on réinitialise pour laisser le layout flexible
	tween.chain().tween_callback(func():
		clip_children = CanvasItem.CLIP_CHILDREN_DISABLED
		custom_minimum_size.y = 0
	)


## Met la notifiaction en pause
func set_paused(paused: bool) -> void:
	if paused:
		# 1. Fige le timer s'il est en train de compter
		if not self.timer.is_stopped():
			self.timer.paused = true
			
		# 2. Fige le tween de mort si l'animation de disparition a déjà commencé
		if self.has_meta("dead_tween"):
			var t = self.get_meta("dead_tween") as Tween
			if is_instance_valid(t) and t.is_running():
				t.pause()
	else:
		# 1. Reprend le timer
		if self.timer.paused:
			self.timer.paused = false
			
		# 2. Reprend le tween de mort
		if self.has_meta("dead_tween"):
			var t = get_meta("dead_tween") as Tween
			if is_instance_valid(t):
				t.play()

## Lance la notification de sortie
func dead() -> void:
	self.timer.timeout.connect(self._on_timer_timeout)
	self.timer.start()

func _on_timer_timeout() -> void:
	clip_children = CanvasItem.CLIP_CHILDREN_ONLY
	
	var tween = create_tween().set_parallel(true)
	self.set_meta("dead_tween", tween)
	tween.tween_property(self, "modulate:a", 0.0, 0.34)
	tween.tween_property(self, "custom_minimum_size:y", 0, 0.35)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	
	tween.chain().tween_callback(
		func():
			self.visible = false
			self.deid.emit(self)
	)
