extends Control

@onready
var titre: LineEdit = $GridContainer/LineTitre

@onready
var description: LineEdit = $GridContainer/LineDescription

@onready
var temps: LineEdit = $GridContainer/LineTime

@onready
var enable_notif: CheckButton = $GridContainer/EnableNotif

@onready
var nb: LineEdit = $GridContainer/Nb

@onready var send: Button = $GridContainer/Button

var notif: BaseLayerUi

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.notif = UiManager.push_ui("Notification")
	GameSignals.ui_close_requested.emit("PauseMenu")
	self.enable_notif.set_pressed_no_signal(self.notif.visible)


func _on_enable_notif_pressed() -> void:
	if self.notif.visible:
		self.notif.close()
	else:
		self.notif.open()

func _on_button_pressed() -> void:
	var duration = float(self.temps.text)
	var size = int(self.nb.text)
	
	if not size:
		size = 1

	if not duration:
		duration = 0.7

	for i in size:
		var text: String = ""
		if i > 0:
			text = " %s" % i

		var notif_data = NotificationData.new(
			self.titre.text + text,
			self.description.text,
			duration,
		)
		NotificationManager.send(notif_data)
