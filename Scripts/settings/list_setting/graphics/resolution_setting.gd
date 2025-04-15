class_name ResolutionSetting
extends SingleOptionSettings
## Paramètre lier à la resolution

func _ready():
	self._name = "RESOLUTION"
	self._group = BaseSettings.GROUP.GRAPHICS
	# TODO Support des autres format d'écrans
	self._options = {
		"2560x1440": Vector2i(2560,1440),
		"1920x1080": Vector2i(1920,1080),
		"1366x768": Vector2i(1366,768),
		"1536x864": Vector2i(1536,864),
		"1280x720": Vector2i(1280,720),
		"1440x900": Vector2i(1440,900),
		"1600x900": Vector2i(1600,900),
		"1024x600": Vector2i(1024,600),
		"800x600": Vector2i(800,600)
	}

	self._default_option = "800x600"

## Evenment qui applique le changement graphique en cas de modification extene
func event_apply(_Class: BaseSettings, _save: bool):
	self._apply()

func _apply() -> void:
	DisplayServer.window_set_size(self._options[self._current_option])
