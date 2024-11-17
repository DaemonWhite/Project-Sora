extends CharacterBody3D

const CAMERA_MOUSE_ROTATION_SPEED := 0.001
const CAMERA_X_ROT_MIN = deg_to_rad(-89)
const CAMERA_X_ROT_MAX = deg_to_rad(70)

enum camera_state {FIRST, THIRD, NULL}

var GRAVITY_PLAYER: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var move_speed: float = 6

@export var link_player: CharacterBody3D = null
@onready var pivot_third_camera_x = $ThirdCameraX
@onready var pivot_third_camera_y = $ThirdCameraX/ThirdCameraY
@onready var pivot_first_camera_x = $FirstCameraX
@onready var pivot_first_camera_y = $FirstCameraX/FirstCameraY
@onready var camera_spring = $ThirdCameraX/ThirdCameraY/SpringArm3D

@onready var third_camera: Camera3D = $ThirdCameraX/ThirdCameraY/SpringArm3D/ThirdCamera
@onready var first_camera: Camera3D = $FirstCameraX/FirstCameraY/FirstCamera

@export var min_dist_third_person: float = 1
@export var max_dist_third_person: float = 3.5
@export var move_dist_camera: float = 0.5

@export var input_move_forward: String = "ui_up"
@export var input_move_left: String = "ui_left"
@export var input_move_right: String = "ui_right"
@export var input_move_downward: String = "ui_down"

@export var input_switch_cam: String = "switch_cam"
@export var input_zoom: String = "wheel_up"
@export var input_unzoom: String = "wheel_down"

@export var is_lock: bool = true
@export var is_first_peson: bool = false
@export var lock_camera_mode: camera_state = camera_state.NULL

var character_default_script = load("res://Scripts/camera/character_camera.gd")

var motion = Transform3D()

var is_tying_camera: bool = false


signal first_person_mode


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linked_camera_as_player()
	if is_lock:
		lock()
	else:
		unlock()
		
	if is_first_peson:
		switch_cam(camera_state.FIRST)
	else:
		switch_cam(camera_state.THIRD)
		
func set_tying_player(player: Node3D):
	link_player = player
	if not character_default_script == link_player.get_script():
		link_player.set_script(character_default_script)
		link_player.set_physics_process(true)
		link_player.auto_generate_marker()
		
func reset_first_camera():
	pivot_first_camera_x.set_position(Vector3.ZERO)
	pivot_first_camera_x.set_rotation(Vector3.ZERO)
	pivot_first_camera_y.set_position(Vector3.ZERO)
	pivot_first_camera_y.set_rotation(Vector3.ZERO)
	
func reset_third_camera():
	if is_tying_camera:
		pivot_third_camera_x.set_rotation(Vector3.ZERO)
		pivot_third_camera_x.set_rotation(Vector3.ZERO)
		pivot_third_camera_y.set_position(Vector3.ZERO)
		pivot_third_camera_y.set_rotation(Vector3.ZERO)
	else:
		pivot_third_camera_x.set_position(Vector3.ZERO)
		pivot_third_camera_x.set_rotation(Vector3.ZERO)
		pivot_third_camera_y.set_position(Vector3.ZERO)
		pivot_third_camera_y.set_rotation(Vector3.ZERO)

func linked_camera_as_player():
	if not character_default_script == link_player.get_script():
		set_tying_player(link_player)
	
	if link_player:
		is_tying_camera = true

		remove_child(pivot_first_camera_x)
		link_player.first_camera_position.add_child(pivot_first_camera_x)
		link_player.linked()
		reset_first_camera()
		reset_third_camera()
		velocity = link_player.velocity
		pivot_third_camera_x.position.y = link_player.camera_third_position().y
	else:
		is_tying_camera = false
		print("Error link_player is missing")

func unliked_camera_as_player():
	is_tying_camera = false
	if link_player:
		link_player.first_camera_position.remove_child(pivot_first_camera_x)
		add_child(pivot_first_camera_x)
		link_player.unlinked()
		reset_first_camera()
		reset_third_camera()
		pivot_third_camera_x.position.y = link_player.camera_third_position().y

func _input(event):
	var scale_factor: float = min(
			(float(get_viewport().size.x) / get_viewport().get_visible_rect().size.x),
			(float(get_viewport().size.y) / get_viewport().get_visible_rect().size.y)
	)
	
	if event is InputEventMouseMotion and not is_lock:
		if is_first_peson:
			if is_tying_camera:
				rotate_camera_teste(
					event.relative * CAMERA_MOUSE_ROTATION_SPEED * scale_factor,
					pivot_first_camera_y,
					link_player
				)
			else:
				rotate_camera_teste(
					event.relative * CAMERA_MOUSE_ROTATION_SPEED * scale_factor,
					pivot_first_camera_y,
					pivot_first_camera_x
				)
		else:
			rotate_camera_teste(
				event.relative * CAMERA_MOUSE_ROTATION_SPEED * scale_factor,
				pivot_third_camera_y,
				pivot_third_camera_x
			)

func _physics_process(delta: float) -> void:
	get_input(delta)
	
	var camera_length = camera_spring.get_length()
	
	if Input.is_action_just_pressed(input_switch_cam):
		if is_first_peson:
			switch_cam(camera_state.THIRD)
		else:
			switch_cam(camera_state.FIRST)
	
	if Input.is_action_just_released(input_zoom) and max_dist_third_person >= camera_length:
		camera_spring.set_length(camera_length + move_dist_camera)
		if is_first_peson:
			switch_cam(camera_state.THIRD)
		
	if Input.is_action_just_released(input_unzoom) and min_dist_third_person < camera_length:
		camera_spring.set_length(camera_length - move_dist_camera)
		
	if not is_first_peson and min_dist_third_person > camera_length:
		switch_cam(camera_state.FIRST)
			
	camera_spring.orthonormalize()
	
func get_input(_delta):
	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_axis(input_move_left, input_move_right)
	move_direction.z = Input.get_axis(input_move_forward, input_move_downward)
	move_direction.normalized()
	
	var orientation_x: float = pivot_third_camera_x.rotation.y
		
	if is_first_peson and is_tying_camera:
		orientation_x = link_player.rotation.y
	elif is_first_peson:
		orientation_x = pivot_first_camera_x.rotation.y
	
	move_direction = move_direction.rotated(Vector3.UP, orientation_x).normalized()
	
	if is_tying_camera:
		link_player.velocity = Vector3(
			move_direction.x * move_speed, 
			link_player.velocity.y, 
			move_direction.z * move_speed
		)
		
		if move_direction.z != 0:
			if not is_first_peson: 
				link_player.global_transform.basis = pivot_third_camera_x.basis
		
		link_player.move_and_slide()
		position = link_player.position
	else:
		velocity = Vector3(
			move_direction.x * move_speed, 
			velocity.y, 
			move_direction.z * move_speed
		)
		move_and_slide()

func switch_cam(mode: camera_state):

	if lock_camera_mode != camera_state.NULL:
		mode = lock_camera_mode
		
	match mode:
		camera_state.FIRST:
			first_camera.make_current()
			is_first_peson = true
		camera_state.THIRD:
			third_camera.make_current()
			is_first_peson = false

	first_person_mode.emit()

func rotate_camera_teste(move, pivot_y, pivot_x):
	pivot_x.rotate_y(-move.x)
	pivot_x.orthonormalize()
	pivot_y.rotation.x = clamp(pivot_y.rotation.x + move.y, CAMERA_X_ROT_MIN, CAMERA_X_ROT_MAX)

func lock():
	is_lock = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func unlock():
	is_lock = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
