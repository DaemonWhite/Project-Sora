@tool
class_name DialogChooseKey
extends DialogConfirm
## Dialog permetant de sélèctioner la touche de clavier voulue 
##

@onready var labelChooseButton = $CenterContainer/PanelContainer/VBoxContainer/ChildContainer/CenterContainer/LabelChooseButton

## Autorise l'écoute des évènement clavier
var scan_input: bool = true

## Évite de fermer le scan directement
var start_scan: bool = false

## Stocke le dernier évènement utiliser 
var stocked_event: InputEvent = null 

## TODO définie la zone morte des joystick à changer à l'avenir par un paramètres global
const JOY_AXIS_DEADZONE: float = 0.5

func _ready() -> void:
	super._ready()
	self.reset()


func _input(event: InputEvent) -> void:
	if not scan_input:
		return

	if event.is_pressed():
		self.labelChooseButton.text = InputTranslator.get_event_key_to_string(event)
		self.start_scan = true
	elif event is InputEventJoypadMotion and abs(event.axis_value) > JOY_AXIS_DEADZONE:
		self.labelChooseButton.text = InputTranslator.get_event_key_to_string(event)
		self.stocked_event = event
		self._finalise_detection()
	elif self.start_scan == true and not event.is_pressed():
		self.stocked_event = event
		self._finalise_detection()

func _finalise_detection() -> void:
	self.scan_input = false
	self.confirmed_button.disabled = false

## Remet le modal dans sont états d'avant ouverture.
## WARNING Ne comprend pas [member Dialog.title]  et  [member Dialog.description]
func reset() -> void:
	self.scan_input = true
	self.stocked_event = null
	self.start_scan = false
	self.labelChooseButton.text = tr("Appuyer sur une touche")
	self.confirmed_button.disabled = true

## Permet de récupérer l'evenement intercepter
func get_choose_key() -> InputEvent:
	return self.stocked_event

func _on_retry_pressed() -> void:
	self.reset()

func _on_cancel_pressed() -> void:
	self.reset()
	super._on_cancel_pressed()

## Ouvre le Dialog
func open() -> void:
	self.reset()
	super.open()
