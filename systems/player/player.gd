class_name Player
extends CharacterBody2D

@export var chunks_manager: ChunkManager = null

@export_group("Movement Settings")
@export var max_speed: float = 200.0
@export var acceleration: float = 1200.0
@export var friction: float = 1000.0

## TODO Ajouter une meilleur gestion de la direction du curseur !

@export_group("Debug")
@export var visible_cursor: bool = false
@onready var cursor: Sprite2D = $Cursor 

var direction: Vector2 = Vector2.ZERO

var _last_chunk_node: Node2D = null
var _last_ground: TileMapLayerGround = null

func _ready() -> void:
	self.cursor.visible = self.visible_cursor

func _physics_process(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	

	if input_dir != Vector2.ZERO:
		self.direction = input_dir
		self.velocity = velocity.move_toward(input_dir * max_speed, acceleration * delta)
	else:
		self.velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	if chunks_manager:
		self._update_cursor()


	self.move_and_slide()



func _update_cursor() -> void:
	var chunk: Node2D = self.chunks_manager.get_chunk()
	if not chunk:
		return

	if chunk != self._last_chunk_node:
		self._last_chunk_node = chunk
		self._last_ground = null
		for node: Node in chunk.get_children():
			if node is TileMapLayerGround:
				self._last_ground = node
				break

	if self._last_ground:
		var target_global_pos: Vector2 = self.global_position + (
			self.direction * self.chunks_manager.tile_size.x
		)
		
		var local_pos: Vector2 = self._last_ground.to_local(target_global_pos)
		
		var cell: Vector2i = self._last_ground.local_to_map(local_pos)
		
		self.cursor.global_position = self._last_ground.to_global(
			self._last_ground.map_to_local(cell)
		)
