class_name GamepadSetting
extends SingleOptionSettings
## Paramètre lier à la resolution

func _ready():
	self._name = "INPUT_KEYBOAD"
	self._ui_name = tr("Layout gamepad")
	self._description = tr("Choose layout for the gamepad UI")

	self._group = BaseSettings.GROUP.KEYBOARD
	self._options = {
		"Switch": InputTranslator.GAMEPAD_MAP.SWITCH,
		"Xbox": InputTranslator.GAMEPAD_MAP.XBOX,
		"PS": InputTranslator.GAMEPAD_MAP.PS
	}

	self._default_option = "Xbox"

## Evenement qui applique le changement graphique en cas de modification extene
func event_apply(_Class: BaseSettings, _save: bool):
	self._apply()

func _apply() -> void:
	InputTranslator.set_default_filter_gamepad_map(
        self._options[self._current_option]
    )