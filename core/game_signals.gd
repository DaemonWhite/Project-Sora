extends Node

## Debug toggle
@warning_ignore("unused_signal")
signal debug_toggle

## Signal pour ouvrir un menu
@warning_ignore("unused_signal")
signal ui_open_requested(state: GameStateManager.State, load_file: String)
## Signal pour fermer un menu
@warning_ignore("unused_signal")
signal ui_close_requested(menu_name: String)

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

@warning_ignore("unused_signal")
signal send_notification(notification_data: NotificationData)