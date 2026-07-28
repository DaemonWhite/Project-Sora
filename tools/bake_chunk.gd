@tool
class_name WorldSlicer
extends Node2D


@export_category("Configuration du Découpage")
## Taille de chaque chunk en nombre de tuiles (ex: 64x64)
@export var chunk_size: Vector2i = Vector2i(64, 64):
	set(value):
		chunk_size = value
		queue_redraw()

## Nombre de tuiles de chevauchement aux frontières pour l'autotile
@export var overlap: int = 1:
	set(value):
		overlap = value
		queue_redraw()

## Dossier dans lequel enregistrer les sous-scènes .tscn
@export_dir var save_path: String = "res://Chunks/"

@export_category("Visualisation Grille")
## Affiche la grille de découpage dans le viewport 2D
@export var show_grid: bool = true:
	set(value):
		show_grid = value
		queue_redraw()

## Couleur des lignes de la grille
@export var grid_color: Color = Color(0.0, 0.8, 1.0, 0.6):
	set(value):
		grid_color = value
		queue_redraw()

## Affiche le nom des chunks (ex: Chunk 0,0) dans la grille
@export var show_chunk_labels: bool = true:
	set(value):
		show_chunk_labels = value
		queue_redraw()

@export_category("Actions")
## Clique sur ce bouton pour lancer le processus de découpage
@export_tool_button("Découper le Monde", "TileMapLayer")
var run_button: Callable = _run_export


func _process(_delta: float) -> void:
	# Rafraîchit le dessin en temps réel dans l'éditeur pendant que tu peins des tuiles
	if Engine.is_editor_hint() and self.show_grid:
		queue_redraw()


func _draw() -> void:
	if not self.show_grid or not Engine.is_editor_hint():
		return

	var world_map:Node = self._find_world_map()
	if not world_map:
		return

	var global_bounds: Rect2i = self._calculate_global_bounds(world_map)
	if global_bounds.size == Vector2i.ZERO:
		return

	var tile_size: Vector2i = self._get_tile_size(world_map)
	var chunk_px_size: Vector2i = Vector2(self.chunk_size * tile_size)

	var start_chunk: Vector2i = Vector2i(
		int(floor(float(global_bounds.position.x) / self.chunk_size.x)),
		int(floor(float(global_bounds.position.y) / self.chunk_size.y))
	)
	var end_chunk: Vector2i = Vector2i(
		int(ceil(float(global_bounds.end.x) / self.chunk_size.x)),
		int(ceil(float(global_bounds.end.y) / self.chunk_size.y))
	)

	var font: Font  = ThemeDB.fallback_font
	var font_size: int = ThemeDB.fallback_font_size

	for cx: int in range(start_chunk.x, end_chunk.x):
		for cy: int in range(start_chunk.y, end_chunk.y):
			var chunk_coord: Vector2i = Vector2i(cx, cy)
			var global_chunk_pos: Vector2 = Vector2(chunk_coord * self.chunk_size * tile_size)
			
			# Conversion en coordonnées locales pour dessiner au bon endroit
			var local_pos: Vector2i = self.to_local(global_chunk_pos)
			var rect: Rect2 = Rect2(local_pos, chunk_px_size)

			# Dessin du rectangle du chunk
			self.draw_rect(rect, self.grid_color, false, 2.0)

			# Dessin du label (ex: "0, 0")
			if self.show_chunk_labels:
				var label_text: String = "(%d, %d)" % [cx, cy]
				var text_pos: Vector2i = local_pos + Vector2i(8, 24)
				self.draw_string(
					font, 
					text_pos, 
					label_text, 
					HORIZONTAL_ALIGNMENT_LEFT, 
					-1, 
					font_size, 
					self.grid_color
				)


func _run_export() -> void:
	var world_map: Node = self._find_world_map()
	if not world_map:
		print("Erreur : Impossible de trouver le nœud 'WorldMap'.")
		return

	var global_bounds: Rect2i = self._calculate_global_bounds(world_map)
	if global_bounds.size == Vector2i.ZERO:
		print("La carte ne contient aucune tuile.")
		return

	var start_chunk: Vector2i = Vector2i(
		int(floor(float(global_bounds.position.x) / self.chunk_size.x)),
		int(floor(float(global_bounds.position.y) / self.chunk_size.y))
	)
	var end_chunk: Vector2i = Vector2i(
		int(ceil(float(global_bounds.end.x) / self.chunk_size.x)),
		int(ceil(float(global_bounds.end.y) / self.chunk_size.y))
	)

	var formatted_save_path: String = save_path
	if not formatted_save_path.ends_with("/"):
		formatted_save_path += "/"

	DirAccess.make_dir_recursive_absolute(formatted_save_path)

	self._clear_output_folder(formatted_save_path)

	print("Début du découpage... Grille de chunks : de ", start_chunk, " à ", end_chunk)

	var total_saved: int = 0
	for cx: int in range(start_chunk.x, end_chunk.x):
		for cy: int in range(start_chunk.y, end_chunk.y):
			var chunk_coord: Vector2i = Vector2i(cx, cy)
			if self._export_chunk(world_map, chunk_coord, formatted_save_path):
				total_saved += 1

	print("Opération terminée ! %d chunks générés dans %s" % [total_saved, formatted_save_path])


func _clear_output_folder(folder_path: String) -> void:
	var dir: DirAccess = DirAccess.open(folder_path)
	if not dir:
		return

	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	var deleted_count: int = 0

	while file_name != "":
		if not dir.current_is_dir():
			if file_name.ends_with(".tscn") or file_name.ends_with(".tscn.import"):
				var full_file_path: String = folder_path.path_join(file_name)
				if DirAccess.remove_absolute(full_file_path) == OK:
					deleted_count += 1
		file_name = dir.get_next()

	dir.list_dir_end()
	EditorInterface.get_resource_filesystem().scan()

	if deleted_count > 0:
		print("Nettoyage : %d fichier(s) supprimé(s)." % deleted_count)


func _export_chunk(world_map: Node, chunk_coord: Vector2i, destination_path: String) -> bool:
	var chunk_node: Node2D = Node2D.new()
	chunk_node.name = "Chunk_%d_%d" % [chunk_coord.x, chunk_coord.y]

	var tile_start: Vector2i = (chunk_coord * self.chunk_size) - Vector2i(overlap, overlap)
	var tile_end: Vector2i = ((chunk_coord + Vector2i.ONE) * self.chunk_size) + Vector2i(overlap, overlap)

	var has_content: bool = false
	var tile_size: Vector2i = self._get_tile_size(world_map)
	var chunk_origin_px: Vector2 = Vector2(chunk_coord * self.chunk_size * tile_size)

	for child: Node in world_map.get_children():
		if child == self:
			continue

		if child is TileMapLayer:
			var master_layer: TileMapLayer = child as TileMapLayer
			var chunk_layer: TileMapLayer = master_layer.duplicate(
				Node.DUPLICATE_SCRIPTS | Node.DUPLICATE_GROUPS | Node.DUPLICATE_SIGNALS
			) as TileMapLayer

			chunk_layer.name = master_layer.name
			chunk_layer.clear()

			chunk_node.add_child(chunk_layer)
			chunk_layer.owner = chunk_node

			for x in range(tile_start.x, tile_end.x):
				for y in range(tile_start.y, tile_end.y):
					var global_pos: Vector2i = Vector2i(x, y)
					var source_id: int = master_layer.get_cell_source_id(global_pos)

					if source_id != -1:
						var atlas_coords: Vector2i = master_layer.get_cell_atlas_coords(global_pos)
						var alt_tile: int = master_layer.get_cell_alternative_tile(global_pos)

						var local_pos: Vector2i = global_pos - (chunk_coord * self.chunk_size)
						chunk_layer.set_cell(local_pos, source_id, atlas_coords, alt_tile)
						has_content = true

		elif child is Node2D:
			var entity: Node2D = child as Node2D
			var entity_tile_pos: Vector2i = Vector2i(
				int(floor(entity.position.x / float(tile_size.x))),
				int(floor(entity.position.y / float(tile_size.y)))
			)

			if entity_tile_pos.x >= tile_start.x and entity_tile_pos.x < tile_end.x \
			and entity_tile_pos.y >= tile_start.y and entity_tile_pos.y < tile_end.y:

				var dup_entity: Node2D = entity.duplicate(
					Node.DUPLICATE_USE_INSTANTIATION | Node.DUPLICATE_SCRIPTS | Node.DUPLICATE_GROUPS
				) as Node2D

				dup_entity.position = entity.position - chunk_origin_px

				chunk_node.add_child(dup_entity)
				dup_entity.owner = chunk_node
				self._set_owner_recursive(dup_entity, chunk_node)

				has_content = true

	if not has_content:
		chunk_node.queue_free()
		return false

	# Permet de copier la position du noeud
	# Pour l'instant je le desactive.
	# Ça sera au gestionaire de chunk de génèrer dynamiquement la position
	# 
	#chunk_node.position = chunk_origin_px

	var packed_scene: PackedScene = PackedScene.new()
	var pack_result: int = packed_scene.pack(chunk_node)

	if pack_result == OK:
		var file_path: String = destination_path + "Chunk_%d_%d.tscn" % [chunk_coord.x, chunk_coord.y]
		ResourceSaver.save(packed_scene, file_path)

	chunk_node.queue_free()
	return true


func _set_owner_recursive(node: Node, scene_owner: Node) -> void:
	for child: Node in node.get_children():
		if child.owner == node.owner or child.owner == null:
			child.owner = scene_owner
			self._set_owner_recursive(child, scene_owner)


func _find_world_map() -> Node:
	var root: Node = EditorInterface.get_edited_scene_root()
	if not root:
		return null
	if get_parent() and get_parent().name == "WorldMap":
		return get_parent()
	elif name == "WorldMap":
		return self
	return root.get_node_or_null("WorldMap")


func _get_tile_size(world_map: Node) -> Vector2i:
	for child: Node in world_map.get_children():
		var layer: TileMapLayer = child as TileMapLayer
		if layer and layer.tile_set:
			return layer.tile_set.tile_size
	return Vector2i(16, 16)


func _calculate_global_bounds(world_map: Node) -> Rect2i:
	var combined_rect: Rect2i = Rect2i()
	var first: bool = true

	for child: Node in world_map.get_children():
		var layer: TileMapLayer = child as TileMapLayer
		if layer:
			var layer_rect: Rect2i = layer.get_used_rect()
			if layer_rect.size != Vector2i.ZERO:
				if first:
					combined_rect = layer_rect
					first = false
				else:
					combined_rect = combined_rect.merge(layer_rect)

	return combined_rect