extends Sprite2D

var cell: Vector2i
var tile_size: Vector2
var sprite_size: Vector2

var mode: TileMapLayerGround.SoilState = TileMapLayerGround.SoilState.WELL_DIRT

@export var tilemap: TileMapLayer = null


func _ready() -> void:
	if tilemap != null:
		tile_size = self.tilemap.tile_set.tile_size
		sprite_size = self.texture.get_size()
		scale = Vector2(tile_size.y, tile_size.y) / sprite_size
		self.set_scale(scale)


func _process(_delta: float) -> void:
	if tilemap == null:
		return
	cell = self.tilemap.local_to_map(self.tilemap.get_local_mouse_position())
	global_position = self.tilemap.to_global(self.tilemap.map_to_local(cell))


	if Input.is_action_pressed("mouse_valide"):
		self.tilemap.set_soil_state(cell,  mode)
	
