class_name TextFormatter
extends RefCounted

static var _regex: RegEx = null

static var _routes: Dictionary = {}

static func _init_router() -> void:
	if _regex != null:
		return
		
	TextFormatter._regex = RegEx.new()
	# regex format {input:action}
	TextFormatter._regex.compile("\\{([a-zA-Z0-9_]+):([^}]+)\\}")

static func register_route(tag_type: String, handler: Callable) -> void:
	TextFormatter._routes[tag_type] = handler

static func format_text(original_text: String) -> String:
	TextFormatter._init_router()
	
	var formatted_text = original_text
	var results = TextFormatter._regex.search_all(original_text)
	
	for i in range(results.size() - 1, -1, -1):
		var result = results[i]
		var tag_type = result.get_string(1)
		var tag_value = result.get_string(2)
		
        # Par défaut, on remet la balise brute si la route n'existe pas
		var replacement = result.get_string(0)
		
		if TextFormatter._routes.has(tag_type):
			var handler: Callable = TextFormatter._routes[tag_type]
			var handler_result = handler.call(tag_value)
			
			if handler_result is String:
				replacement = handler_result
		
		formatted_text = formatted_text.substr(0, result.get_start()) + replacement + formatted_text.substr(result.get_end())
		
	return formatted_text