class_name DefaultSettings

const resolution_default = "1440x900"
const resolutions : Array = [
	["2560x1440", Vector2i(2560,1440)],
	["1920x1080", Vector2i(1920,1080)],
	["1366x768", Vector2i(1366,768)],
	["1536x864", Vector2i(1536,864)],
	["1280x720", Vector2i(1280,720)],
	["1440x900", Vector2i(1440,900)],
	["1600x900", Vector2i(1600,900)],
	["1024x600", Vector2i(1024,600)],
	["800x600", Vector2i(800,600)]
]

const window_mode_default = "Fenêtré"
## Liste des modes de fenètrages
const window_mode : Array = [
	["plein écran",DisplayServer.WINDOW_MODE_FULLSCREEN],
	["Fenêtré sans bordure",DisplayServer.WINDOW_FLAG_BORDERLESS],
	["Fenêtré",DisplayServer.WINDOW_MODE_WINDOWED]
]

const msaa_default = "MSAA Disable"
## Qualiter de l'anticréage
const msaa : Array = [
	["MSAA Disable", Viewport.MSAA_DISABLED],
	["MSAA 2X", Viewport.MSAA_2X],
	["MSAA 4X", Viewport.MSAA_4X],
	["MSAA 8X", Viewport.MSAA_8X]
]
 
const vsync_default = "Enable"
## Liste des vsync disponible
const vsync : Array = [
	["Disable", DisplayServer.VSYNC_DISABLED],
	["Enable", DisplayServer.VSYNC_ENABLED],
	["Adaptive", DisplayServer.VSYNC_ADAPTIVE],
	["Mailbox", DisplayServer.VSYNC_MAILBOX]
]
