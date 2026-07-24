extends Node2D

@onready
var cursor: Sprite2D = $Cursor

# Called when the node enters the scene tree for the first time.
func _on_option_button_item_selected(index: int) -> void:
	print(index)
	match index:
		0: self.cursor.mode = TileMapLayerGround.SoilState.WELL_DIRT
		1: self.cursor.mode = TileMapLayerGround.SoilState.TILLED
		2: self.cursor.mode = TileMapLayerGround.SoilState.GRASS