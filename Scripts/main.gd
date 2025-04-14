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
	
	var s = BaseSettings.get_settings_by_name(
		BaseSettings.GROUP.GRAPHICS, 
		"RESOLUTION"
	)
	
	print("RESOLUTION Recup -> ", s.get_current_option())
	
	print("RESOLUTION Not Default -> ", s.is_not_default())
	
	s.set_current_option("1920") # Doit echouer
	s.set_current_option("1920x1080")
	
	print("RESOLUTION Diffenret -> ", s.is_different())
	
	s.apply()
	# print(BaseSettings.get_path_settings())

	# for setting in BaseSettings.get_settings():
		# print(setting.get_name())
	
	BaseSettings.save()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
