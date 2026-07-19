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