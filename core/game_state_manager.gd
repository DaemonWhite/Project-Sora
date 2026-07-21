extends Node
## Classe qui permet de gérer les états du jeu

enum State { MENU, GAMEPLAY, PAUSE, DIALOGUE, LOADING_GAME }

var current_state: State = State.GAMEPLAY

## Mémorise l'état exact du jeu avant la mise en pause
var state_before_pause: State = State.GAMEPLAY

## Stocke le mode de la souris
var last_mouse_mode: Input.MouseMode = Input.MOUSE_MODE_VISIBLE

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS
    
    GameSignals.pause_opened.connect(self._on_pause_opened)
    GameSignals.pause_closed.connect(self._on_pause_closed)
    GameSignals.main_menu.connect(self._on_main_menu)
    GameSignals.loading_game.connect(self._on_loading_game)
    GameSignals.ui_open_requested.connect(self._on_ui_open_requested)


func change_state(new_state: State) -> void:
    if current_state == new_state: 
        return
        
    self.current_state = new_state
    
    get_tree().paused = (
        self.current_state == State.PAUSE or 
        self.current_state == State.MENU
    )


func _on_pause_opened() -> void:
    if current_state in [State.MENU, State.LOADING_GAME, State.PAUSE]: 
        return

    # On sauvegarde l'état exact avant d'entrer en pause
    self.state_before_pause = self.current_state
    self.change_state(State.PAUSE)
    
    self.last_mouse_mode = Input.get_mouse_mode()
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    
    var ui = UiManager.push_ui("PauseMenu")
    ui.open()


func _on_pause_closed() -> void:
    if current_state != State.PAUSE: 
        return
        
    self.change_state(self.state_before_pause)
    Input.set_mouse_mode(last_mouse_mode)
    UiManager.pop_ui("PauseMenu")


func _on_ui_open_requested(menu_name: String) -> BaseLayerUi:
    var ui: BaseLayerUi = UiManager.push_ui(menu_name)

    var state_to_restore := self.current_state

    ui.closed.connect(
        self._on_ui_closed.bind(state_to_restore), 
        CONNECT_ONE_SHOT
    )

    self.change_state(State.MENU)
    ui.open() 
    return ui


func _on_ui_closed(_ui: BaseLayerUi, saved_state: State) -> void:
    self.change_state(saved_state)


func _on_main_menu() -> void:
    GameSignals.pause_closed.emit()
    self.change_state(State.MENU)
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    UiManager.push_ui("MainMenu").open()


func _on_loading_game(target_state: State, load_file: String) -> void:
    UiManager.pop_ui("MainMenu")
    GameSignals.pause_closed.emit()
    self.change_state(State.LOADING_GAME)
    
    if load_file != "":
        get_tree().change_scene_to_file(load_file)
        
    await get_tree().process_frame
    
    self.change_state(target_state)
    GameSignals.loaded_game.emit(target_state)