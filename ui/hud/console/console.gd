class_name Console
extends BaseLayerUi
## Console est un menu qui permet d'afficher les ligne de commande disponible

## Le texte pour envoyer la command
@onready
var input_command: SuggestionLineEdit = $PanelContainer/VBoxContainer/HBoxContainer/InputCommand
## Le bouton pour envoyer la command
@onready
var enter_command: Button = $PanelContainer/VBoxContainer/HBoxContainer/EnterCommand
## les log du text
@onready
var log_text: RichTextLabel = $PanelContainer/VBoxContainer/LogText

var _history: Array[String] = []
var _index_history: int = 0

var exit_state_mode: GameStateManager.State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	self.active_process_mode = Node.PROCESS_MODE_ALWAYS

	self.input_command.set_suggestion([
		"abrico",
		"péche",
		"périer",
		"chaussette",
		"paria"
	])

func open() -> void:
	super.open()
	self.input_command.process_mode = Node.PROCESS_MODE_INHERIT
	self.input_command.grab_focus()

func close() -> void:
	self.input_command.process_mode = Node.PROCESS_MODE_DISABLED
	super.close()

## methode pour envoyer une command
func send_command(command: String) -> void:
	var result = DebugCommands.exec(command)

	if result["response"] == "":
		return

	self._history.push_back(command)

	log_text.text +=  "> %s [br]" % command  
	log_text.text +=  result["response"] + "[br]"
	input_command.text = ""

	if result["close_console"]:
		self.close()

func clear_log() -> void:
	self.log_text.text = ""

func _on_input_command_text_submitted(new_text: String) -> void:
	self.send_command(new_text)
	self.input_command.panel_suggestion.hide()
	self._index_history = 0


func _on_input_command_text_changed(new_text: String) -> void:
	if new_text.length() != 0:
		self._index_history = -1
	else:
		self._index_history = 0

	var raw_text = new_text.strip_edges()

	if raw_text.is_empty():
		return

	var commands_array: PackedStringArray = raw_text.split(" ", false)


	var suggestions: Array[String] = DebugCommands.get_autocomplete(commands_array)
	self.input_command.set_suggestion(suggestions)


## methode pour changer la position de l'historique
func select_history(increment: int) -> String:
	if self._history.size() == 0 or self._index_history == -1:
		return ""

	self._index_history += increment

	if self._history.size() <= self._index_history:
		self._index_history = 0
	elif self._index_history <= -1:
		self._index_history = self._history.size() -1


	return self._history[self._index_history]

func _on_input_command_up() -> void:
	var history = self.select_history(-1)
	if not history.is_empty():
		self.input_command.text = history

func _on_input_command_down() -> void:
	var history = self.select_history(1)
	if not history.is_empty():
		self.input_command.text = history

func _on_enter_command_pressed() -> void:
	self.send_command(self.input_command.text)
	

