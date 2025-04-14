class_name MsaaSetting
extends SingleOptionSettings

func _ready():
	self._name = "MSAA"
	self._group = BaseSettings.GROUP.GRAPHICS
	self._options = [
		["MSAA Disable", Viewport.MSAA_DISABLED],
        ["MSAA 2X", Viewport.MSAA_2X],
        ["MSAA 4X", Viewport.MSAA_4X],
        ["MSAA 8X", Viewport.MSAA_8X]
    ]

	self._default_option = "MSAA Disable"
