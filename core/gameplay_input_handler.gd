# class_name GameplayInputHandler
extends Node

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("ui_pause"):
		match GameStateManager.current_state:
			GameStateManager.State.PAUSE:
				GameSignals.ui_close_requested.emit("PauseMenu")
			GameStateManager.State.GAMEPLAY:
				GameSignals.ui_open_requested.emit("PauseMenu")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_console"):
		GameSignals.debug_toggle.emit()
