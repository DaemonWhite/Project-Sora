class_name Game_Sginals
extends Node

## Signal poour prévenir de l'ouverture du menu pause
@warning_ignore("unused_signal")
signal pause_opened()
## Signal poour prévenir de la fermeture du menu pause
@warning_ignore("unused_signal")
signal pause_closed()

## Signal poour prévenir de l'ouverture de l'inventaire
@warning_ignore("unused_signal")
signal inventory_opened()
## Signal poour prévenir de la fermeture du menu pause 
@warning_ignore("unused_signal")
signal inventory_closed()

## Signal pour prévenir du chargement
@warning_ignore("unused_signal")
signal loading_game(state: GameStateManager.State, load_file: String)
## Signal pour prévenir de la fin du chargement
@warning_ignore("unused_signal")
signal loaded_game(state: GameStateManager.State)

## Signal pour prévenir de la sauvegarde du jeu
@warning_ignore("unused_signal")
signal saved_game()
## Signal pour prévenir de la fermeture du jeu
@warning_ignore("unused_signal")
signal closed_game()

## Signal pour prévenir de l'ouverture du menu principal
@warning_ignore("unused_signal")
signal main_menu()