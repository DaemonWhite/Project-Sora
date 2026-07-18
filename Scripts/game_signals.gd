class_name Game_Sginals
extends Node

@warning_ignore("unused_signal")
signal pause_opened()
@warning_ignore("unused_signal")
signal pause_closed()

@warning_ignore("unused_signal")
signal inventory_opened()
@warning_ignore("unused_signal")
signal inventory_closed()

@warning_ignore("unused_signal")
signal loading_game(state: GameStateManager.State, load_file: String)
@warning_ignore("unused_signal")
signal loaded_game(state: GameStateManager.State)

@warning_ignore("unused_signal")
signal saved_game()
@warning_ignore("unused_signal")
signal closed_game()
@warning_ignore("unused_signal")
signal main_menu()