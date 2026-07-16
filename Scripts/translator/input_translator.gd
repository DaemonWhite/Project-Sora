class_name InputTranslator
extends RefCounted

const KEY: String = "[%s]"
const UNKNOW_KEY: String = "[?]"
const KEYS_SEPARATOR: String = ", "
const UNDEFINED_KEY: String = "Undefined key"

enum GAMEPAD_MAP {
	XBOX,
	SWITCH,
	PS
}

enum KEY_TYPE {
	DEFAULT = -1,
	ALL = 0,
	KEYBOAR_MOUSE = 10,
	GAMEPAD = 20
}

static var _default_filter_key = InputTranslator.KEY_TYPE.ALL
static var _default_filter_gamepad_map = InputTranslator.GAMEPAD_MAP.XBOX

static func set_default_filter_key(filter_key: InputTranslator.KEY_TYPE) -> void:
	InputTranslator._default_filter_key = filter_key

static func set_default_filter_gamepad_map(filter_gamepad_map: GAMEPAD_MAP) -> void:
	InputTranslator._default_filter_gamepad_map = filter_gamepad_map

static func get_default_filter_key() -> InputTranslator.KEY_TYPE:
	return InputTranslator._default_filter_key

static func get_default_filter_gamepad_map() -> GAMEPAD_MAP:
	return InputTranslator._default_filter_gamepad_map

static func _get_true_key_type_filter(key_type: InputTranslator.KEY_TYPE) -> InputTranslator.KEY_TYPE:
	if InputTranslator.KEY_TYPE.DEFAULT == key_type:
		return InputTranslator._default_filter_key

	return key_type

static func get_event_key_to_string(
		event: Variant, 
		d_filter: InputTranslator.KEY_TYPE = InputTranslator.KEY_TYPE.DEFAULT
	) -> String:

	var filter: InputTranslator.KEY_TYPE = InputTranslator._get_true_key_type_filter(d_filter)

	var text_keys: String = ""

	if text_keys != "":
			text_keys += KEYS_SEPARATOR

	var key = UNDEFINED_KEY
	if event is InputEventKey and (
			filter == InputTranslator.KEY_TYPE.ALL 
			or filter == InputTranslator.KEY_TYPE.KEYBOAR_MOUSE):

		key = event.as_text()

	elif event is InputEventMouseButton and (
			filter == InputTranslator.KEY_TYPE.ALL 
			or filter == InputTranslator.KEY_TYPE.KEYBOAR_MOUSE):

		key = get_mouse_button_name(event.button_index)

	elif event is InputEventJoypadButton and (
			filter == InputTranslator.KEY_TYPE.ALL 
			or filter == InputTranslator.KEY_TYPE.GAMEPAD):

		key = get_joypad_button_name(event.button_index)

	elif event is InputEventJoypadMotion and (
			filter == InputTranslator.KEY_TYPE.ALL 
			or filter == InputTranslator.KEY_TYPE.GAMEPAD):
		key = get_joypad_axis_name(event.axis)

	text_keys += InputTranslator.KEY % key

	return text_keys


# --- Logique d'extraction de la touche ---
static func get_action_key_text(
		action_name: String, 
		d_filter: InputTranslator.KEY_TYPE = InputTranslator.KEY_TYPE.DEFAULT
	) -> String:

	var filter: InputTranslator.KEY_TYPE = InputTranslator._get_true_key_type_filter(d_filter)

	var text_keys: String = ""

	# Sécurité : vérifier si l'action existe bien dans les paramètres du projet
	if not InputMap.has_action(action_name):
		push_warning("InputTranslator : L'action '" + action_name + "' n'existe pas.")
		return InputTranslator.KEY % action_name

	var events = InputMap.action_get_events(action_name)
	if events.is_empty():
		return InputTranslator.UNDEFINED_KEY
	
	for event in events:
		if text_keys != "":
			text_keys += InputTranslator.KEYS_SEPARATOR

		text_keys += InputTranslator.get_event_key_to_string(event, filter)
		
	return text_keys

# --- Traduction Souris ---
static func get_mouse_button_name(button_index: int) -> String:
	match button_index:
		MOUSE_BUTTON_LEFT: return "Clic Gauche"
		MOUSE_BUTTON_RIGHT: return "Clic Droit"
		MOUSE_BUTTON_MIDDLE: return "Clic Milieu"
		MOUSE_BUTTON_XBUTTON1: return "Bouton Souris 4"
		MOUSE_BUTTON_XBUTTON2: return "Bouton Souris 5"
		MOUSE_BUTTON_WHEEL_UP: return "Molette Haut"
		MOUSE_BUTTON_WHEEL_DOWN: return "Molette Bas"
		_: return "Bouton Souris " + str(button_index)

# --- Traduction Boutons Manette ---
static func get_joypad_button_name(button_index: int, map_type: GAMEPAD_MAP = _default_filter_gamepad_map) -> String:
	match button_index:
		JOY_BUTTON_A:
			return "A" if map_type == GAMEPAD_MAP.XBOX else ("B" if map_type == GAMEPAD_MAP.SWITCH else "Croix")
		JOY_BUTTON_B:
			return "B" if map_type == GAMEPAD_MAP.XBOX else ("A" if map_type == GAMEPAD_MAP.SWITCH else "Rond")
		JOY_BUTTON_X:
			return "X" if map_type == GAMEPAD_MAP.XBOX else ("Y" if map_type == GAMEPAD_MAP.SWITCH else "Carré")
		JOY_BUTTON_Y:
			return "Y" if map_type == GAMEPAD_MAP.XBOX else ("X" if map_type == GAMEPAD_MAP.SWITCH else "Triangle")
		JOY_BUTTON_LEFT_SHOULDER:
			return "LB" if map_type == GAMEPAD_MAP.XBOX else "L" if map_type == GAMEPAD_MAP.SWITCH else "L1"
		JOY_BUTTON_RIGHT_SHOULDER:
			return "RB" if map_type == GAMEPAD_MAP.XBOX else "R" if map_type == GAMEPAD_MAP.SWITCH else "R1"
		# ... (ajoute le reste des correspondances selon le même modèle)
		JOY_BUTTON_DPAD_UP: return "Croix Haut"
		_: 
			return "Bouton " + str(button_index)

# --- Traduction Axes Manette (Gâchettes) ---
static func get_joypad_axis_name(axis: int, map_type: GAMEPAD_MAP = _default_filter_gamepad_map) -> String:
	match axis:
		JOY_AXIS_TRIGGER_LEFT:
			return "LT" if map_type == GAMEPAD_MAP.XBOX else ("ZL" if map_type == GAMEPAD_MAP.SWITCH else "L2")
		JOY_AXIS_TRIGGER_RIGHT:
			return "RT" if map_type == GAMEPAD_MAP.XBOX else ("ZR" if map_type == GAMEPAD_MAP.SWITCH else "R2")
	return "Axe " + str(axis)