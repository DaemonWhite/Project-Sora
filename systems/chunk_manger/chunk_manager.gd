@tool
class_name ChunkManager
extends Node2D

## Noeud suivie pour connaitre la position des chunks
@export var node_listener: Node2D = null
## Taille d'un chunk en tuile
@export var chunk_size: Vector2i = Vector2i(64, 64):
	set(value):
		self._update_true_chunk_size()
		self._update_chunks()
		chunk_size = value
	get:
		return chunk_size

## Taille d'une tuile en pixel
@export var tile_size: Vector2i = Vector2i(64, 64):
	set(value):
		self._update_true_chunk_size()
		self._update_chunks()
		tile_size = value
	get:
		return tile_size

## Distance d'afficheage des chunks
@export var render_distance: int = 1

@export var path_chunk: String = "res://Chunks"

@export_group("Debug Visuals")
## Afficher la grille de débogage
@export var draw_debug_grid: bool = true:
	set(value):
		draw_debug_grid = value
		queue_redraw()

## Couleur des contours de chunks
@export var debug_color: Color = Color(0.1, 0.8, 0.2, 0.6):
	set(value):
		debug_color = value
		queue_redraw()

## Epaisseur des lignes de la grille
@export_range(1.0, 10.0) var line_thickness: float = 2.0:
	set(value):
		line_thickness = value
		queue_redraw()

## Afficher le texte des coordonnées sur chaque chunk
@export var show_chunk_labels: bool = true:
	set(value):
		show_chunk_labels = value
		queue_redraw()

var _true_chunk_size: Vector2i

# Dictionnaire répertoriant les chemins des fichiers : Vector2i -> Chemin du fichier
var chunk_files: Dictionary[Vector2i, String] = {}

# Dictionnaire des chunks actuellement chargés en mémoire : Vector2i -> Node2D
var loaded_chunks: Dictionary[Vector2i, Node2D] = {}

## Chunk ou le noeud suivie ce trouve
var current_chunk: Vector2i = Vector2i(INF, INF)

# Suivi des chunks en cours de chargement asynchrone
var pending_chunks: Array[Vector2i] = []

func _ready() -> void:
	BetterLogger.debug(self._true_chunk_size)
	self._index_chunk_files()
	self._update_true_chunk_size()
	# Premier chargement direct au démarrage si le listener est assigné
	if self.node_listener:
		self._update_chunks()

func _process(_delta: float) -> void:
	if not self.node_listener:
		return

	self._process_pending_chunks()

	# Utilisation de global_position pour éviter les soucis de nœuds parents décalés
	var new_chunk: Vector2i = Vector2i(
		floori(self.node_listener.global_position.x / self._true_chunk_size.x),
		floori(self.node_listener.global_position.y / self._true_chunk_size.y)
	)

	if new_chunk != self.current_chunk:
		self.current_chunk = new_chunk
		self._update_chunks()
		self.queue_redraw()

## Répertorie tous les fichiers de chunks disponibles au lancement
func _index_chunk_files() -> void:
	var _chunks: Array[String] = Utils.search_recursif_file("res://Chunks")
	
	var position_chunk_regex: RegEx = RegEx.create_from_string("\\d+_\\d+")

	for chunk_path: String in _chunks:
		var regex_match: RegExMatch = position_chunk_regex.search(chunk_path)
		if regex_match:
			var chunk_str: String = regex_match.get_string()
			var position_str_chunk: PackedStringArray = chunk_str.split("_")
			var chunk_position: Vector2i = Vector2i(
				int(position_str_chunk[0]),
				int(position_str_chunk[1])
			)
			self.chunk_files[chunk_position] = chunk_path

## Gère le chargement des nouveaux chunks et le déchargement des anciens
func _update_chunks() -> void:
	var required_chunks: Array[Vector2i] = []

	for x: int in range(-self.render_distance, self.render_distance + 1):
		for y: int in range(-self.render_distance, self.render_distance + 1):
			var chunk_coord: Vector2i = self.current_chunk + Vector2i(x, y)
			required_chunks.append(chunk_coord)

			if not self.loaded_chunks.has(chunk_coord) \
					and not chunk_coord in self.pending_chunks\
					and  self.chunk_files.has(chunk_coord):
				self.request_chunk_load(chunk_coord)

	var loaded_coords: Array[Vector2i] = loaded_chunks.keys()
	for coord: Vector2i in loaded_coords:
		if not coord in required_chunks:
			self.unload_chunk(coord)

## Lance la requête de chargement en arrière-plan
func request_chunk_load(coord: Vector2i) -> void:
	var path: String = chunk_files[coord]
	
	# Demande à Godot de charger le fichier dans un thread séparé
	var error: int = ResourceLoader.load_threaded_request(path)
	if error == OK:
		pending_chunks.append(coord)

## Vérifie chaque frame si des ressources ont fini de charger
func _process_pending_chunks() -> void:
	if pending_chunks.is_empty():
		return

	# On parcourt à l'envers pour pouvoir supprimer des éléments du tableau en bouclant
	for i: int in range(pending_chunks.size() - 1, -1, -1):
		var coord: Vector2i = pending_chunks[i]
		var path: String = chunk_files[coord]
		
		var progress: Array = []
		var status: int = ResourceLoader.load_threaded_get_status(path, progress)

		match status:
			ResourceLoader.THREAD_LOAD_LOADED:
				# Le fichier est prêt !
				var chunk_scene: PackedScene = ResourceLoader.load_threaded_get(path) as PackedScene
				self._instantiate_chunk(coord, chunk_scene)
				self.pending_chunks.remove_at(i)
				
			ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				push_error("Échec du chargement asynchrone du chunk : " + path)
				self.pending_chunks.remove_at(i)

func _update_true_chunk_size() -> void:
	self._true_chunk_size = self.chunk_size * self.tile_size

## Instancie la scène une fois le fichier chargé
func _instantiate_chunk(coord: Vector2i, scene: PackedScene) -> void:
	if not scene:
		return

	var chunk_instance: Node2D = scene.instantiate() as Node2D

	chunk_instance.position = Vector2(
		coord * self._true_chunk_size
	)
	
	self.add_child(chunk_instance)
	self.loaded_chunks[coord] = chunk_instance

## Retire le chunk de la scène et libère la mémoire
func unload_chunk(coord: Vector2i) -> void:
	if self.loaded_chunks.has(coord):
		var chunk_node: Node2D = self.loaded_chunks[coord]
		chunk_node.queue_free()
		self.loaded_chunks.erase(coord)

func get_chunk() -> Node2D:
	if not 	self.loaded_chunks.has(self.current_chunk):
		return null

	return self.loaded_chunks[self.current_chunk]

func _draw() -> void:
	if not self.draw_debug_grid or self._true_chunk_size == Vector2i.ZERO:
		return
	
	var center_chunk: Vector2i = current_chunk 
	var font: Font = ThemeDB.fallback_font
	var font_size: int = ThemeDB.fallback_font_size

	for x: int in range(-self.render_distance, self.render_distance + 1):
		for y: int in range(-self.render_distance, self.render_distance + 1):
			var coord: Vector2i = center_chunk + Vector2i(x, y)
			var rect_pos: Vector2i = Vector2(coord * self._true_chunk_size)
			var rect_size: Vector2i = Vector2(self._true_chunk_size)
			var rect: Rect2 = Rect2(rect_pos, rect_size)

			# Dessine le contour du chunk
			self.draw_rect(rect, debug_color, false, line_thickness)

			# Dessine les coordonnées du chunk au centre
			if show_chunk_labels:
				var label_text: String = "(%d, %d)" % [coord.x, coord.y]
				var text_pos: Vector2i = rect_pos + (rect_size / 2) - Vector2i(20, 0)
				draw_string(
					font, 
					text_pos, 
					label_text, 
					HORIZONTAL_ALIGNMENT_CENTER, 
					-1, 
					font_size, 
					debug_color
				)