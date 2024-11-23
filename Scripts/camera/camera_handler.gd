class_name CameraHandler
extends CharacterBody3D
## Script qui permet de controller la camera

## Vitesse de la camera
const CAMERA_MOUSE_ROTATION_SPEED := 0.001
## Angle minimum de la camera à la premiere personne
const CAMERA_X_ROT_MIN = deg_to_rad(-89)
## Angle maximum de la camera à la premiere personne 
const CAMERA_X_ROT_MAX = deg_to_rad(70) 

enum camera_state {
	## Premiere personne
	FIRST,
	## Seconde personne
	THIRD,
	## La camera ne fais rien
	NULL
}

## Vitesse de deplacement
@export var move_speed: float = 6
## Attache un character body
@export var link_player: CharacterBody3D = null 
## Axe X de la camera troisieme persone 
@onready var pivot_third_camera_x: Node3D = $ThirdCameraX
## Axe y de la camera troisieme persone
@onready var pivot_third_camera_y: Node3D = $ThirdCameraX/ThirdCameraY 
## Axe x de la camera premiere persone 
@onready var pivot_first_camera_x: Node3D = $FirstCameraX
## Axe y de la camera premiere persone
@onready var pivot_first_camera_y: Node3D = $FirstCameraX/FirstCameraY
## Collision de la camera
@onready var camera_spring: SpringArm3D = $ThirdCameraX/ThirdCameraY/SpringArm3D

## Camera troisièmes personne
@onready var third_camera: Camera3D = $ThirdCameraX/ThirdCameraY/SpringArm3D/ThirdCamera
## Camera Premiere Personne
@onready var first_camera: Camera3D = $FirstCameraX/FirstCameraY/FirstCamera



## Distance minimum de la camera à la troisieme personne
@export var min_dist_third_person: float = 1
## Distance maximum de la camera à la troisieme personne
@export var max_dist_third_person: float = 3.5
## Default third position
@export var default_dist_third_person: float = 2.4
## Marge de la camera avec le sol
@export var margin_third_person_camera: float = 1

## Vitesse de déplacement de la caméra
@export var move_dist_camera: float = 0.5

## Touche pour avancer la camera
@export var input_move_forward: String = "ui_up"
## Touche pour avancer à gauche la caméra
@export var input_move_left: String = "ui_left"
## Touche pour avancer à droite la camera
@export var input_move_right: String = "ui_right"
## Touche pour reculer la camera
@export var input_move_downward: String = "ui_down"

## Touche pour faire changer la camera
@export var input_switch_cam: String = "switch_cam"
## Touche pour faire avancer la camera
@export var input_zoom: String = "wheel_up"
## Touche pour faire reculer la camera
@export var input_unzoom: String = "wheel_down"

## Si la camera est verrouller 
@export var is_lock_cam: bool = true
## Si la camera peut ce déplacer
@export var is_lock_move: bool = true
## Indique si la camera est a la premiere personne
@export var is_first_peson: bool = false
## Indique dans quelle etat est la camera
@export var lock_camera_mode: camera_state = camera_state.NULL

## Chemin du scrip gererique de joueur
var character_default_script = load("res://Scripts/camera/character_camera.gd")

## Si la camera est fixer au personnage ou non
var is_tying_camera: bool = false

## Signal qui prévient du changement d'etat de la camera
signal first_person_mode


func _ready() -> void:
	camera_spring.spring_length = default_dist_third_person
	camera_spring.margin = margin_third_person_camera
	
	if link_player:
		linked_camera_as_player()

	if is_lock_cam:
		lock_camera()
	else:
		unlock_camera()
		
	if is_lock_move:
		lock_movement()
	else:
		unlock_movement()
		
	if is_first_peson:
		switch_cam(camera_state.FIRST)
	else:
		switch_cam(camera_state.THIRD)

## Fixe la camera sur le joueur
func set_tying_player(player: Node3D) -> void:
	link_player = player
	if not character_default_script == link_player.get_script():
		link_player.set_script(character_default_script)
		link_player.set_physics_process(true)
		link_player.auto_generate_marker()

## Reinitialise la camera premières personne
func reset_first_camera() -> void:
	pivot_first_camera_x.set_position(Vector3.ZERO)
	pivot_first_camera_y.set_position(Vector3.ZERO)

## Reinitialise la camera troisieme personne
func reset_third_camera() -> void:
	pivot_third_camera_x.set_rotation(Vector3.ZERO)
	pivot_third_camera_y.set_position(Vector3.ZERO)


## Lie la camera au joueur
func linked_camera_as_player() -> void:
	if not character_default_script == link_player.get_script():
		push_warning("Player dont have script but default script tying apply")
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
		push_error("Error link_player is missing")

## Delie la camera du joueur
func unliked_camera_as_player() -> void:
	is_tying_camera = false
	if link_player:
		link_player.first_camera_position.remove_child(pivot_first_camera_x)
		add_child(pivot_first_camera_x)
		link_player.unlinked()
		reset_first_camera()
		reset_third_camera()
		pivot_third_camera_x.position.y = link_player.camera_third_position().y
	else:
		push_error("Error link_player is missing")

func _input(event) -> void:
	var scale_factor: float = min(
			(float(get_viewport().size.x) / get_viewport().get_visible_rect().size.x),
			(float(get_viewport().size.y) / get_viewport().get_visible_rect().size.y)
	)
	
	if event is InputEventMouseMotion and not is_lock_cam:
		if is_first_peson:
			if is_tying_camera and not is_lock_move:
				rotate_camera(
					event.relative * CAMERA_MOUSE_ROTATION_SPEED * scale_factor,
					pivot_first_camera_y,
					link_player
				)
			else:
				rotate_camera(
					event.relative * CAMERA_MOUSE_ROTATION_SPEED * scale_factor,
					pivot_first_camera_y,
					pivot_first_camera_x
				)
		else:
			rotate_camera(
				event.relative * CAMERA_MOUSE_ROTATION_SPEED * scale_factor,
				pivot_third_camera_y,
				pivot_third_camera_x
			)

func _physics_process(delta: float) -> void:
	if not is_lock_move:
		get_input(delta)
	
	var camera_length = camera_spring.get_length()
	
	print(camera_spring.margin)
	
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
	
func get_input(_delta) -> void:
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
				link_player.global_transform.basis = lerp(
					link_player.global_transform.basis,
					pivot_third_camera_x.basis,
					0.5 + _delta
				)
		
		link_player.move_and_slide()
		position = link_player.position
	else:
		velocity = Vector3(
			move_direction.x * move_speed, 
			velocity.y, 
			move_direction.z * move_speed
		)
		move_and_slide()

## Change la camera de mode
func switch_cam(mode: camera_state) -> void:
	match mode:
		camera_state.FIRST:
			first_camera.make_current()
			is_first_peson = true
		camera_state.THIRD:
			third_camera.make_current()
			is_first_peson = false
		camera_state.NULL:
			lock_camera()
			lock_movement()

	first_person_mode.emit()

## Lance la rotation de la camera
## @experimental
func rotate_camera(move, pivot_y: Node3D, pivot_x: Node3D) -> void:
	# TODO Dois passer la rotation a basis
	pivot_x.rotate_y(-move.x)
	pivot_x.orthonormalize()
	pivot_y.rotation.x = clamp(pivot_y.rotation.x + move.y, CAMERA_X_ROT_MIN, CAMERA_X_ROT_MAX)
	pivot_y.orthonormalize()

## Blocker la camera
func lock_camera() -> void:
	is_lock_cam = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

## Blocke le déplacement de la camera
func lock_movement() -> void:
	is_lock_move = true

## Deblocker la camera
func unlock_camera() -> void:
	is_lock_cam = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

## Déblocke le déplacement de la camera 
func unlock_movement() -> void:
	is_lock_move = false
