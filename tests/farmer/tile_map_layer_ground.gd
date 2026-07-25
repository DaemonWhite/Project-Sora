class_name TileMapLayerGround
extends TileMapLayer

enum SoilState { 
	WELL_DIRT = 0, 
	TILLED = 1,
	DIRT = 2, 
	GRASS = 3,
	PROTECTED = -1
}

var SOIL_TILE_SOURCES: Dictionary[TileMapLayerGround.SoilState, Vector2i] = {
	TileMapLayerGround.SoilState.GRASS: Vector2i(14, 1),
	TileMapLayerGround.SoilState.DIRT: Vector2i(10, 1),
	TileMapLayerGround.SoilState.TILLED: Vector2i(6, 1),
	TileMapLayerGround.SoilState.WELL_DIRT: Vector2i(2, 1)
}

var soil_grid: Dictionary = {}

func enum_to_srtring(soil_state: TileMapLayerGround.SoilState) -> String:
	match soil_state:
		TileMapLayerGround.SoilState.GRASS: return &"herbe"
		TileMapLayerGround.SoilState.DIRT: return &"terre"
		TileMapLayerGround.SoilState.TILLED: return &"terre battue"
		TileMapLayerGround.SoilState.WELL_DIRT: return &"terre battue humidifier"

	return &"protéger"

func resolve_default_soil_state(coords: Vector2i) -> TileMapLayerGround.SoilState:
	var atlas_coords: Vector2i = self.get_cell_atlas_coords(coords)

	for soil_state: TileMapLayerGround.SoilState in self.SOIL_TILE_SOURCES:
		var soil_tile_source: Vector2i = self.SOIL_TILE_SOURCES[soil_state]
		var length_vector: Vector2i = (atlas_coords - soil_tile_source)

		# Si ce n'est pas le bon on retourne au vecteur suivant
		if length_vector.y < -1 or length_vector.y > 2 or length_vector.x > 1 or length_vector.x < -2  :
				continue

		# Autrement on revoie la valeur trouver
		return soil_state

	# Aucune valeur trouver
	return TileMapLayerGround.SoilState.PROTECTED


func set_soil_state(coords: Vector2i, new_state: SoilState) -> void:
	if new_state == SoilState.PROTECTED:
		return

	self.set_cells_terrain_connect([coords], 0, new_state)
