class_name SelectSettingsOptions
extends BaseSettingsComponent

@onready
var optionButton = $OptionButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	if setting:
		var options = setting.get_options().keys()
		for option in options:
			self.optionButton.add_item(str(option))


func get_drescription() -> String:
	return self.description

func get_option_button() -> OptionButton:
	return self.optionButton
