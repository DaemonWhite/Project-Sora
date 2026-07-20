class_name Utils
extends Object
## Classe utilitaire du jeu

## Recherche de manière récursif des fichier avec option de filtrage
static func search_recursif_file(folder: String, extensions: Array[String] = []) -> Array[String]:
	var files: Array[String] = []
	var dir = DirAccess.open(folder)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if file_name != "." and file_name != "..":
				var path = folder.path_join(file_name)
				
				if dir.current_is_dir():
					files.append_array(search_recursif_file(path, extensions))
				else:
					if extensions.is_empty() or extensions.has(file_name.get_extension()):
						files.append(path)
			
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		push_error("An error occurred when trying to access the path: " + folder)
		
	return files

static func auto_load_scripts(
			path: String,
			parent_file: String,
			instanciate: bool
		) -> Array:
		
	var scripts: Array = []
	var files = Utils.search_recursif_file(path, ["gd", "gdc"])
	for file in files:
		var script = load(file) as GDScript
		
		if not script or not script.can_instantiate():
			continue

		var base_script = script.get_base_script()
		var is_valid_setting = false
		
		while base_script != null:
			if base_script.resource_path.get_file() == parent_file:
				is_valid_setting = true
				break
			base_script = base_script.get_base_script()
			
		if not is_valid_setting:
			push_warning("Le script ignoré (n'hérite pas de BaseSettings) : ", file)
			continue
		
		if instanciate: scripts.push_back(script.new())
		else: scripts.push_back(script) 	
	
	print(scripts)
	return scripts