@static_unload
class_name SoraDefaultSettings
extends  Node

## A brief description of the class's role and functionality.
##
## The description of the script, what it can do,
## and any further detail.

const RESOLUTION_DEFAULT: String = "1440x900"

const RESOLUTIONS : Array = [
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

const WINDOW_MODE_DEFAULT: String = "Fenêtré"
## Liste des modes de fenètrages
const WINDOW_MODE : Array = [
	["plein écran",DisplayServer.WINDOW_MODE_FULLSCREEN],
	["Fenêtré sans bordure",DisplayServer.WINDOW_FLAG_BORDERLESS],
	["Fenêtré",DisplayServer.WINDOW_MODE_WINDOWED]
]

const MSAA_DEFAULT: String = "MSAA Disable"

## Qualiter de l'anticréage
const MSAA : Array = [
	["MSAA Disable", Viewport.MSAA_DISABLED],
	["MSAA 2X", Viewport.MSAA_2X],
	["MSAA 4X", Viewport.MSAA_4X],
	["MSAA 8X", Viewport.MSAA_8X]
]
 
const VSYNC_DEFAULT: String = "Enable"

## Liste des vsync disponible
const VSYNC : Array = [
	["Disable", DisplayServer.VSYNC_DISABLED],
	["Enable", DisplayServer.VSYNC_ENABLED],
	["Adaptive", DisplayServer.VSYNC_ADAPTIVE],
	["Mailbox", DisplayServer.VSYNC_MAILBOX]
]

func _ready():
	print("teste")
	print(RESOLUTION_DEFAULT)

func get_RESOLUTION_DEFAULT() -> String :
	print(RESOLUTION_DEFAULT)
	return RESOLUTION_DEFAULT
