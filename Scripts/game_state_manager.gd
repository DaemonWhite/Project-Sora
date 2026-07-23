extends Node
## Classe qui permet de gérer les états du jeu


## États du jeu
enum State { 
    ## État du menu principal
    MAIN_MENU,
    ## État en jeu
    GAMEPLAY, 
    ## État jeu en pause
    PAUSE, 
    ## État dialogue ouvert
    DIALOGUE,
    ## État chargement du jeu
    LOADING_GAME 
}

## État actuelle du jeu
var current_state: State = State.GAMEPLAY

## Dernier état du jeu
var last_input_mode = State.GAMEPLAY

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS
    GameSignals.pause_opened.connect(self._on_pause_opened)
    GameSignals.pause_closed.connect(self._on_pause_closed)
    GameSignals.main_menu.connect(self._on_main_menu)
    GameSignals.loaded_game.connect(self._on_loaded_game)
    GameSignals.loading_game.connect(self._on_loading_game)

func _on_pause_opened() -> void:
    if current_state == State.PAUSE: return
    if current_state == State.MAIN_MENU: return
    if current_state == State.LOADING_GAME: return

    print(self.current_state)

    current_state = State.PAUSE
    get_tree().paused = true
    self.last_input_mode = Input.get_mouse_mode()
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    UiManager.push_ui("PauseMenu").open()


func _on_pause_closed() -> void:
    current_state = State.GAMEPLAY
    get_tree().paused = false
    Input.set_mouse_mode(self.last_input_mode)
    UiManager.pop_ui("PauseMenu")

func _on_main_menu() -> void:
    GameSignals.pause_closed.emit()
    current_state = State.MAIN_MENU
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    UiManager.push_ui("MainMenu").open()

func _on_loading_game(state: GameStateManager.State, load_file: String) -> void:
    print("LOADING GAME", load_file)
    self.current_state = State.LOADING_GAME
    if load_file != "":
        get_tree().change_scene_to_file(load_file)

    GameSignals.loaded_game.emit(state)

func _on_loaded_game(state: GameStateManager.State) -> void: 
    self.current_state = state
    print("LOADED GAME")