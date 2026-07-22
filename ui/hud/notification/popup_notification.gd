@tool
class_name PopupNotification
extends PanelContainer

@onready var title_label: Label = $HBoxContainer/VBoxContainer/Title
@onready var message_rich_text_label: RichTextLabel = $HBoxContainer/VBoxContainer/Message
@onready var timer: Timer = $Timer
@onready var icon_rect: TextureRect = $HBoxContainer/IconRect

# Icônes par défaut configurables dans l'inspecteur Godot
@export var default_icon: Texture2D

## Configuration appliquée après le add_child()
func setup_from_data(data: NotificationData) -> void:
	title_label.text = data.title
	message_rich_text_label.text = data.message
	timer.wait_time = data.duration
	
	# Gestion de l'icône : Spécifique (objet) -> Sinon Par défaut (UI)
	if data.icon != null:
		icon_rect.texture = data.icon

	icon_rect.texture = default_icon

func send() -> void:
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout() -> void:
	clip_children = CLIP_CHILDREN_ONLY
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "modulate:a", 0.0, 0.35)
	tween.tween_property(self, "custom_minimum_size:y", 0, 0.35)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	
	tween.chain().tween_callback(queue_free)
