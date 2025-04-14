class_name SoraMain
extends Node

# var settings = SoraSett

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BaseSettings.set_path_settings("user://sora_settings.cfg")

	ResolutionSetting.new()
	MsaaSetting.new()
	VsyncSetting.new()
	WindowModeSetting.new()

	MasterSoundSetting.new()
	
	

	print(BaseSettings.get_path_settings())

	for setting in BaseSettings.get_settings():
		print("a")
	
	BaseSettings.save()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
