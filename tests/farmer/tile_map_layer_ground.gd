class_name TileMapLayerGround
extends TileMapLayer

enum SoilState { 
	WELL_DIRT = 0, 
	TILLED = 1,
	DIRT = 2, 
	GRASS = 3,
	PROTECTED = -1
}

var SOIL_TILE_SOURCES = {
	SoilState.GRASS: Vector2i(0, 0),
	SoilState.DIRT: Vector2i(1, 0),
	SoilState.TILLED: Vector2i(2, 0),
	SoilState.WELL_DIRT: Vector2i(3, 0)
}

var soil_grid: Dictionary = {}


func get_soil_state(coords: Vector2i) -> SoilState:
	if self.soil_grid.has(coords) and self.soil_grid.has("state"): 
		return self.soil_grid[coords].get("state", SoilState.GRASS)
	return SoilState.GRASS

func set_soil_state(coords: Vector2i, new_state: SoilState):
	if new_state == SoilState.PROTECTED:
		return

	self.set_cells_terrain_connect([coords], 0, new_state)

# Actions du joueur
func till_soil(coords: Vector2i):
	var current_state = self.get_soil_state(coords)
	if current_state == SoilState.DIRT or current_state == SoilState.GRASS:
		self.set_soil_state(coords, SoilState.TILLED)

func water_soil(coords: Vector2i):
	var current_state = self.get_soil_state(coords)
	if current_state == SoilState.TILLED:
		self.set_soil_state(coords, SoilState.WELL_DIRT)
