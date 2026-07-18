# class_name GameplayInputHandler
extends Node


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("ui_pause"):
		match GameStateManager.current_state:
			GameStateManager.State.PAUSE:
				GameSignals.pause_closed.emit()
			GameStateManager.State.GAMEPLAY:
				GameSignals.pause_opened.emit()
