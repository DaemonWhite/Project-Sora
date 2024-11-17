extends CharacterBody3D

var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")
var JUMP_IMPULSE = 5

enum controller {GRAVITY, MOVEMENT, MOVEMENT_CAMERA, NULL}

@export var contoller_mode: controller = controller.GRAVITY 
@export var controller_mode_link: controller = controller.MOVEMENT_CAMERA
@export var controller_mode_unlink: controller = controller.GRAVITY 

@export var first_camera_position: Marker3D
@export var third_camera_poistion: Marker3D

@export var camera_forward: String
@export var camera_left: String
@export var camera_right: String
@export var camera_downard: String

@export var move_forward: String = "ui_up"
@export var move_left: String = "ui_left"
@export var move_right: String = "ui_right"
@export var move_downward: String = "ui_down"

@export var jump: String = "ui_accept"

@export var move_speed: float = 10

func _ready() -> void:
	set_physics_process(true)

func auto_generate_marker() -> void:
	var marker: markerDataClasss = search_collision()
	
	if not first_camera_position or marker.first_person_marker:
		if marker.first_person_marker and not first_camera_position:
			first_camera_position = Marker3D.new()
			first_camera_position.position = marker.first_person_marker
		elif not first_camera_position:
			first_camera_position = Marker3D.new()
			first_camera_position.position = Vector3.ZERO
			
		if marker.third_person_marker and not third_camera_poistion:
			third_camera_poistion = Marker3D.new()
			third_camera_poistion.position = marker.third_person_marker
		elif not third_camera_poistion:
			third_camera_poistion = Marker3D.new()
			third_camera_poistion.position = Vector3.ZERO
		
		add_child(first_camera_position)
		add_child(third_camera_poistion)
		
func linked():
	contoller_mode = controller_mode_link
	
func unlinked():
	contoller_mode = controller_mode_unlink
		
func search_collision() -> markerDataClasss:
	var marker_camera = markerDataClasss.new()
	 
	var collision_shape: CollisionShape3D = get_node("CollisionShape3D")
	if collision_shape:
		
		match collision_shape.shape.get_class():
			"SphereShape3D":
				marker_camera.set_first_person_marker_state(true)
				marker_camera.set_third_person_marker_state(true)
				marker_camera.third_person_marker = collision_shape.position
				marker_camera.first_person_marker.y -= collision_shape.shape.radius
				marker_camera.first_person_marker.z = (collision_shape.shape.radius - collision_shape.shape.radius / 4 ) * -1 
			"CapsuleShape3D":
				marker_camera.set_first_person_marker_state(true)
				marker_camera.set_third_person_marker_state(true)
				marker_camera.third_person_marker = collision_shape.position
				marker_camera.third_person_marker.x += collision_shape.shape.radius
				marker_camera.third_person_marker.y += collision_shape.shape.height / 2
				marker_camera.first_person_marker = collision_shape.position
				marker_camera.first_person_marker.y += collision_shape.shape.height - collision_shape.shape.radius * 2
				marker_camera.first_person_marker.z = (collision_shape.shape.radius * -1)
			"CylinderShape3D":
				marker_camera.set_first_person_marker_state(true)
				marker_camera.set_third_person_marker_state(true)
				marker_camera.third_person_marker = collision_shape.position
				marker_camera.third_person_marker.x += collision_shape.shape.radius
				marker_camera.third_person_marker.y += collision_shape.shape.height / 2
				marker_camera.first_person_marker = collision_shape.position
				marker_camera.first_person_marker.y += collision_shape.shape.height - collision_shape.shape.radius * 2
				marker_camera.first_person_marker.z = (collision_shape.shape.radius * -1)
			"BoxShape3D":
				marker_camera.set_first_person_marker_state(true)
				marker_camera.set_third_person_marker_state(true)
				marker_camera.third_person_marker = collision_shape.position + collision_shape.shape.size / 2
				marker_camera.first_person_marker = collision_shape.position + collision_shape.shape.size
				marker_camera.first_person_marker.x -= collision_shape.shape.size.x
				marker_camera.first_person_marker.y -= collision_shape.shape.size.y / 16
				marker_camera.first_person_marker.z *= -1
			_:
				marker_camera.set_third_person_marker_state(true)
				marker_camera.third_person_marker = collision_shape.position
				
	return marker_camera
	
func _physics_process(delta: float) -> void:
	
	if contoller_mode == controller.MOVEMENT:
		if is_on_floor() and Input.is_action_just_released(jump):
			velocity.y = JUMP_IMPULSE
	
	match contoller_mode:
		controller.MOVEMENT:
			if not is_on_floor():
				velocity.y -= GRAVITY * delta
			
			get_input(delta)
			
			if is_on_floor() and Input.is_action_just_released(jump):
				velocity.y = JUMP_IMPULSE
				
			move_and_slide()
		controller.MOVEMENT_CAMERA:
			if not is_on_floor():
				velocity.y -= GRAVITY * delta
				
			if is_on_floor() and Input.is_action_just_released(jump):
				velocity.y = JUMP_IMPULSE
				
		controller.GRAVITY:
			if not is_on_floor():
				velocity.y -= GRAVITY * delta
				
			move_and_slide()
		controller.NULL:
			pass
			
func get_input(_delta):
	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_axis(move_left, move_right)
	move_direction.z = Input.get_axis(move_forward, move_downward)
	move_direction.normalized()
	
	velocity = move_direction * move_speed

func camera_first_position() -> Vector3:
	return first_camera_position.position
	
func camera_first_rotation() -> Vector3:
	return first_camera_position.rotation
	
func camera_third_position() -> Vector3:
	return third_camera_poistion.position
