class_name Camera2DHandler
extends Camera2D

enum CameraMode {
	LINKED, 
	UNLINKED,
	AUTONOME
}

@export var camera_speed: int = 900

@export var current_camera_mode: CameraMode = CameraMode.AUTONOME:
	set(value):
		current_camera_mode = value
		BetterLogger.debug("Mode caméra changé : %s" % current_camera_mode)

@export var target_node: Node2D = null

@export var follow_speed: int = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match current_camera_mode:
		CameraMode.LINKED:
			self._handle_linked_mode(delta)
		CameraMode.UNLINKED:
			pass
		CameraMode.AUTONOME:
			self._handle_autonome_mode(delta)

func _handle_linked_mode(delta: float) -> void:
	if not is_instance_valid(self.target_node):
		return
	var weight: float = 1.0 - exp(-self.follow_speed * delta)
	self.global_position = self.global_position.lerp(self.target_node.global_position, weight)


func _handle_autonome_mode(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	self.global_position += input_dir * self.camera_speed * delta