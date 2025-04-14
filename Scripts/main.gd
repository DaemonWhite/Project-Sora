class_name SoraMain
extends Node

# var settings = SoraSett

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BaseSettings.set_path_settings("user://sora_settings.cfg")
	BaseSettings.load()

	ResolutionSetting.new()
	MsaaSetting.new()
	VsyncSetting.new()
	WindowModeSetting.new()

	MasterSoundSetting.new()
	KeyboardSettings.new()
	

	print(BaseSettings.get_path_settings())

	for setting in BaseSettings.get_settings():
		print(setting.get_name())
	
	BaseSettings.save()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
