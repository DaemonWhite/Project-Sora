class_name Player
extends CharacterBody2D

@export_group("Movement Settings")
@export var max_speed: float = 200.0
@export var acceleration: float = 1200.0
@export var friction: float = 1000.0


func _physics_process(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_dir != Vector2.ZERO:
		self.velocity = velocity.move_toward(input_dir * max_speed, acceleration * delta)
	else:
		self.velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	self.move_and_slide()