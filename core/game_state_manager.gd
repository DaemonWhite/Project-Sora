extends Node
## Classe qui permet de gérer les états du jeu

enum State { MENU, GAMEPLAY, PAUSE, DIALOGUE, LOADING_GAME }

var current_state: State = State.GAMEPLAY
var last_mouse_mode: Input.MouseMode = Input.MOUSE_MODE_VISIBLE

var debug_mode: bool = false

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS
    
    # Les signaux sont beaucoup plus propres
    GameSignals.main_menu.connect(self._on_main_menu)
    GameSignals.loading_game.connect(self._on_loading_game)
    GameSignals.ui_open_requested.connect(self._on_ui_open_requested)
    GameSignals.ui_close_requested.connect(self._on_ui_close_requested)
    GameSignals.debug_toggle.connect(self._on_debug_toggle)


func change_state(new_state: State) -> void:
    if current_state == new_state: 
        return
        
    self.current_state = new_state
    
    # L'arbre se met en pause automatiquement si le target_state le demande
    get_tree().paused = (
        self.current_state == State.PAUSE
    )

func _on_close_console(console):
    self.debug_mode = false
    self.change_state(console.exit_state_mode)

func _on_debug_toggle() -> void:
    self.debug_mode = not self.debug_mode
    if self.debug_mode:
        var console = UiManager.push_ui("Console")
        console.closed.connect(
            self._on_close_console,
            CONNECT_ONE_SHOT
        )
        change_state(State.PAUSE)
        console.open()
    else:
        UiManager.pop_ui("Console")

func _on_ui_open_requested(menu_name: String) -> BaseLayerUi:
    if current_state == State.LOADING_GAME:
        return null

    var ui: BaseLayerUi = UiManager.push_ui(menu_name)

    if ui.visible:
        push_warning("UI it's already open")
        return ui

    var state_to_restore := self.current_state

    if ui.require_visible_mouse:
        self.last_mouse_mode = Input.get_mouse_mode()
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

    ui.closed.connect(
        self._on_ui_closed.bind(state_to_restore, ui.require_visible_mouse), 
        CONNECT_ONE_SHOT
    )

    if not self.current_state == State.PAUSE:
        self.change_state(ui.target_game_state)
    ui.open() 
    return ui


func _on_ui_close_requested(menu_name: String = "") -> void:
    UiManager.pop_ui(menu_name)


func _on_ui_closed(_ui: BaseLayerUi, saved_state: State, restore_mouse: bool) -> void:
    self.change_state(saved_state)
    if restore_mouse:
        Input.set_mouse_mode(last_mouse_mode)


func _on_main_menu() -> void:
    self.change_state(State.MENU)
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    UiManager.push_ui("MainMenu").open()


func _on_loading_game(target_state: State, load_file: String) -> void:
    UiManager.pop_ui("MainMenu")
    self.change_state(State.LOADING_GAME)
    
    if load_file != "":
        get_tree().change_scene_to_file(load_file)
        
    await get_tree().process_frame
    
    self.change_state(target_state)
    GameSignals.loaded_game.emit(target_state)