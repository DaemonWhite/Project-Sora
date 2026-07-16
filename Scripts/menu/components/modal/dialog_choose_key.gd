@tool
class_name DialogChooseKey
extends DialogConfirm

@onready var labelChooseButton = $CenterContainer/PanelContainer/VBoxContainer/ChildContainer/CenterContainer/LabelChooseButton

var scan_input: bool = true

var start_scan: bool = false

var stocked_event: InputEvent = null 

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

func reset() -> void:
	self.scan_input = true
	self.stocked_event = null
	self.start_scan = false
	self.labelChooseButton.text = tr("Appuyer sur une touche")
	self.confirmed_button.disabled = true

func get_choose_key() -> InputEvent:
	return self.stocked_event

func _on_retry_pressed() -> void:
	self.reset()

func _on_cancel_pressed() -> void:
	self.reset()
	super._on_cancel_pressed()

func open() -> void:
	self.reset()
	super.open()