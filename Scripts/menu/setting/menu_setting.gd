extends Control

@onready var tabs = $TabSetting

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tabs.set_tab_title(0, "Contrôle")
	tabs.set_tab_title(1, "Son")
	tabs.set_tab_title(2, "Vidéo")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
