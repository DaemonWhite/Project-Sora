class_name SuggestionLineEdit
extends LineEdit
## SuggestionLineEdit est un texte avec autocompletion
##
## 

var _suggestions: Array[String] = []

## Le [ListElementToolTip] enfant qui permet d'afficher l'autocompletion
var panel_suggestion: ListElementToolTip = ListElementToolTip.new()
@export var placement_suggestion: ToolTip.Placement = ToolTip.Placement.TOP:
	get:
		return self.panel_suggestion.placement
	set(value):
		self.panel_suggestion.placement = value


## Singal qui prévient de si la touche haut du clavier à étais apuyer
## Il est baser sur ui_up
signal up 
## Singal qui prévient de si la touche bas du clavier à étais apuyer
## Il est baser sur ui_up
signal down

func _ready() -> void:
	self.add_child(self.panel_suggestion)
	self.panel_suggestion.container.alignment = BoxContainer.ALIGNMENT_END
	self.panel_suggestion.placement = self.placement_suggestion

	self.text_changed.connect(self._on_changed_text)

## Retourne la taille de la suggestion
func suggestion_size() -> int:
	return self._suggestions.size()

## Permet de définir la liste des suggestions
func set_suggestion(suggestion: Array[String]) -> void:
	if self._suggestions == suggestion:
		return
	self._suggestions.clear()
	self._suggestions = suggestion.duplicate()
	self.panel_suggestion.show()

func _on_changed_text(new_text: String) -> void:
	if new_text.strip_edges().is_empty():
		panel_suggestion.hide()
		return

	var words = new_text.split(" ", false)
	var word = words[-1]
	var matches: Array[String] = []
	for item in self._suggestions:
		if item.begins_with(word) or item.to_lower().begins_with(word.to_lower()):
			matches.append(item)

	if matches.is_empty():
		self.panel_suggestion.hide()

	elif matches.size() == 1 and matches[0] == word:
		self.panel_suggestion.hide()
	else:
		self.panel_suggestion.clear_elements()
		for match_item in matches:
			self.panel_suggestion.add_element(
				self._build_button(match_item)
			)
		self.panel_suggestion.replace()

func _build_button(suggestion: String) -> Button:
	var button: Button = Button.new()
	button.text = suggestion
	button.pressed.connect(self._on_suggetions_selected.bind(button))
	button.set_text_alignment(HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT)
	return button

func _on_suggetions_selected(button: Button):
	var texts: PackedStringArray = self.text.split(" ", false)
	var tmp_text: String = ""
	for i in range(0, texts.size() -1):
		tmp_text += texts[i] + " "

	tmp_text += button.text + " "
	self.text = tmp_text
	self.caret_column = self.text.length()
	self.text_changed.emit(self.text)
	self.grab_focus()

## Permet de nettoyer les suggestions
func clear_suggestion() -> void:
	self._suggestions.clear()

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		if self.panel_suggestion.visible:
			self.panel_suggestion.focus_prev()
		self.up.emit()
	elif event.is_action_pressed("ui_down"):
		if self.panel_suggestion.visible:
			self.panel_suggestion.focus_next()
		self.down.emit()

