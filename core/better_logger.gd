class_name BetterLogger
extends Logger
## Classe qui permet d'afficher des logs Formater


enum Level { DEBUG, INFO, WARNING, ERROR }

static var min_level: Level = Level.DEBUG

var _mutex: Mutex = Mutex.new()

func _init() -> void:
	OS.add_logger(self)


## Formate les logs de type debug
static func debug(message: Variant) -> void:
	BetterLogger._log(str(message), Level.DEBUG)

## Formate les logs de type info
static func info(message: Variant) -> void:
	BetterLogger._log(str(message), Level.INFO)


static func _log(message: String, level: Level) -> void:
	if level < min_level:
		return

	var prefix: String = ""
	var color_tag: String = ""

	match level:
		Level.DEBUG:
			prefix = "[DEBUG]"
			color_tag = "gray"
		Level.INFO:
			prefix = "[INFO]"
			color_tag = "white"
		Level.WARNING:
			prefix = "[WARN]"
			color_tag = "yellow"
		Level.ERROR:
			prefix = "[ERROR]"
			color_tag = "red"

	var formatted_log: String = "%s %s %s" % [_get_timestamp(), prefix, message]

	# Affichage coloré dans la console
	print_rich("[color=%s]%s[/color]" % [color_tag, formatted_log])


# Intercepte toutes les erreurs (push_error, crashs de scripts, shaders, etc.)
func _log_error(
	function: String, 
	file: String, 
	line: int, 
	code: String, 
	rationale: String, 
	_editor_notify: bool, 
	error_type: int, 
	_script_backtraces: Array[ScriptBacktrace]
) -> void:
	_mutex.lock()
	
	var type_str: String = "ERROR"
	var level: BetterLogger.Level = Level.ERROR
	match error_type:
		ERROR_TYPE_WARNING: 
			type_str = "WARN"
			level = Level.WARNING
		ERROR_TYPE_SCRIPT: type_str = "SCRIPT_ERR"
		ERROR_TYPE_SHADER: type_str = "SHADER_ERR"

	var message = "[%s] %s:%d (dans %s) -> %s %s" % [
		type_str,
		file.get_file(), # Nom du fichier sans le chemin complet
		line,
		function,
		code,
		rationale
	]

	BetterLogger._log(
		message,
		level
	)

# Intercepte les messages standards (print, print_rich, stderr)
func _log_message(_message: String, _error: bool) -> void:
	pass

static func _get_timestamp() -> String:
	var time = Time.get_datetime_dict_from_system()
	return "[%02d/%02d %02d:%02d:%02d]" % [time.day, time.month, time.hour, time.minute, time.second]
