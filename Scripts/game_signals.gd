extends Node

signal pause_opened()
signal pause_closed()

signal inventory_opened()
signal inventory_closed()

signal loading_game(state: GameStateManager.State, load_file: String)
signal loaded_game(state: GameStateManager.State)

signal saved_game()
signal closed_game()
signal main_menu()