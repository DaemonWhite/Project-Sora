extends BaseLayerUi

@onready var notif_container: VBoxContainer = $NotifContainer

func _ready() -> void:
	super._ready()

## Appelée par l'UIManager pour ouvrir l'interface
func open() -> void:
	# Ajouter votre traitement avant ouverture
	GameSignals.send_notification.connect(self._on_send_notification)
	super.open()

## Appelée par l'UIManager pour fermer l'interface
func close() -> void:
	GameSignals.send_notification.disconnect(self._on_send_notification)
	super.close()

func _on_send_notification(data: NotificationData) -> void:
	var scene = NotificationManager.get_scene_for_data(data)
	if scene:
		var popup = scene.instantiate()
		# On l'ajoute à l'arbre EN PREMIER pour débloquer les @onready du popup
		notif_container.add_child(popup)
		# On injecte la donnée et on lance la notification
		popup.setup_from_data(data)
		popup.send()
