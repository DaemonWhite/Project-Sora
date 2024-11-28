class_name CameraHandler
extends CharacterBody3D
## Script qui permet de controller la camera
##
## La camera est conçu pour êtres seul elle comprend différent comportement tel qu'un mode première personne et un mode troisieme. [br]
## Elle permet aussi de ce grefer à une entiter [CharacterBody3D]
## En cas de greffe il vas verifier si il possède une classe aprartenant à [BaseCharacterCamera] si non il lui en gréffera automatiquement [BaseCharacterCamera]  [br]
## Si vous voullez changer le comportement de déplacement du joueur il faudra vous référer à [BaseCharacterCamera] pour créer un script personaliser.
## [br][br]
## [color=red]Ce qui suit n'est pas n'éssaisaire avant longtemps![/color]
## [br]
## [color=orange]TODO![/color] Ajouter la suivie d'une courbe
## [br]
## [color=orange]TODO![/color] Ajouter la suivie de point matrixiel

## Vitesse de la camera
const CAMERA_MOUSE_ROTATION_SPEED := 0.001
## Angle minimum de la camera à la premiere personne
const CAMERA_X_ROT_MIN = deg_to_rad(-89)
## Angle maximum de la camera à la premiere personne 
const CAMERA_X_ROT_MAX = deg_to_rad(70)

enum camera_state {
	## Camera en mode premiere personne
	FIRST,
	## Camera en mode seconde personne
	THIRD,
	## Camera en mode menu
	MENU,
	## Camera en mode overlay emnu
	OVERLAY_MENU,
	## La camera ne fais rien
	NULL
}

# Contient le FOV de la camera
var _fov_first: float = 75
# Contien le FOV de la camera troisieme risque de disparaitre
var _fov_third: float = 75

## Fov de la camera a la premiere personne
@export_range(1, 179, 0.1) var fov_first: float = 75:
	get:
		return _fov_first
	set(fov_first):
		if first_camera:
			first_camera.set_fov(fov_first)

		_fov_first = fov_first

## Fov de la camera à la troisieme personne
@export_range(1, 179, 0.1) var fov_third: float = 75:
	get:
		return _fov_third
	set(fov_third):
		if third_camera:
			third_camera.set_fov(_fov_third)
		_fov_third = fov_third

## Rotation sur l'axe vertical de la camera
@export_range(0.1, 5, 0.1) var camera_speed_axe_x: float = 1
## Rotation sur l'axe horizontal de la camera
@export_range(0.1, 5, 0.1) var camera_speed_axe_y: float = 1


@export_group("Camera Third")
## Axe X de la camera troisieme persone 
@onready var pivot_third_camera_x: Node3D = $ThirdCameraX
## Axe y de la camera troisieme persone
@onready var pivot_third_camera_y: Node3D = $ThirdCameraX/ThirdCameraY 
## Collision de la camera
@onready var camera_spring: SpringArm3D = $ThirdCameraX/ThirdCameraY/SpringArm3D
## Camera troisièmes personne
@onready var third_camera: Camera3D = $ThirdCameraX/ThirdCameraY/SpringArm3D/TMPHack/ThirdCamera
## Vitesse de déplacement du zoom de la caméra
@export var move_dist_camera: float = 0.5

## Distance minimum de la camera à la troisieme personne
@export var min_dist_third_person: float = 1
## Distance maximum de la camera à la troisieme personne
@export var max_dist_third_person: float = 3.5
## Default third position
@export var default_dist_third_person: float = 2.4
## Marge de la camera avec le sol
@export var margin_third_person_camera: float = 1

@export_group("Camera Frist")
## Axe x de la camera premiere persone 
@onready var pivot_first_camera_x: Node3D = $FirstCameraX
## Axe y de la camera premiere persone
@onready var pivot_first_camera_y: Node3D = $FirstCameraX/FirstCameraY
## Camera Premiere Personne
@onready var first_camera: Camera3D = $FirstCameraX/FirstCameraY/FirstCamera

@export_group("Link player")
## Attache un character body
@export var link_player: CharacterBody3D = null
## Chemin du scrip gererique de joueur
var character_default_script: Script = BaseCharacterCamera

## Si la camera est fixer au personnage ou non
var is_tying_camera: bool = false

@export_group("Control")

## Vitesse de deplacement de la caméra
@export var move_speed: float = 6

## Touche pour avancer la camera
@export var input_move_forward: String = "ui_up"
## Touche pour avancer à gauche la caméra
@export var input_move_left: String = "ui_left"
## Touche pour avancer à droite la camera
@export var input_move_right: String = "ui_right"
## Touche pour reculer la camera
@export var input_move_downward: String = "ui_down"

## Touche pour faire avancer la camera
@export var input_zoom: String = "wheel_up"
## Touche pour faire reculer la camera
@export var input_unzoom: String = "wheel_down"

@export_group("Status de la camera")

## Si la camera est verrouller 
@export var is_lock_cam: bool = true
## Si la camera peut ce déplacer
@export var is_lock_move: bool = true

## Indique dans quelle etat est la camera
@export var current_camera_mode: camera_state = camera_state.NULL

## Signal qui prévient du changement d'etat de la camera
signal change_camera_mode
## Previen quand la rotation est blocker ou non
signal change_lock_camera
## Previent quand les mouvement sont blocker ou non
signal change_movement_camera

## Initialise la camera avec ces différentres proprieter
func _ready() -> void:
	# Copy le mask de la classe au bras de la camera troisieme personne.
	camera_spring.collision_mask = collision_mask

	first_camera.fov = fov_first
	third_camera.fov = fov_third
		
	camera_spring.spring_length = default_dist_third_person
	camera_spring.margin = margin_third_person_camera

	if link_player:
		linked_camera_as_player()

	switch_cam(current_camera_mode)

	if is_lock_cam:
		lock_camera()
	else:
		unlock_camera()
		
	if is_lock_move:
		lock_movement()
	else:
		unlock_movement()

## Definie le masque de colisiont du bras de la camera troisiemes persones
func set_camera_spring_mask(mask: int):
	camera_spring.collision_mask = mask

## Récupère le masque de colisiont du bras de la camera troisiemes persones
func get_camera_sping_mask():
	return camera_spring

## Fixe la camera sur le joueur
## [codeblock]
## Il est important de ce deconnecter avant de le relier à un nouveau personnage 
## camera.unliked_camera_as_player()
## camera.set_tying_player(character[2])
## camera.linked_camera_as_player()
## [/codeblock]
func set_tying_player(player: Node3D) -> void:
	
	if not (player is BaseCharacterCamera):
		push_warning("Player dont have script but default script tying apply BaseCharacterCamera")
		player.set_script(character_default_script)
		player.set_physics_process(true)
		player.auto_generate_marker()
		player.native = false

	link_player = player

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
	# Verifier si link player est connectable si non il rattache automatiquement
	if not (link_player is BaseCharacterCamera):
		set_tying_player(link_player)
	print(link_player)
	if link_player:
		is_tying_camera = true

		remove_child(pivot_first_camera_x)
		link_player.first_camera_position.add_child(pivot_first_camera_x)
		link_player.linked(self)
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
	# Recupère le deplacement de la souris et détermine une vitesse correspondant
	# au mouvement
	var scale_factor: float = min(
			(float(get_viewport().size.x) / get_viewport().get_visible_rect().size.x) ,
			(float(get_viewport().size.y) / get_viewport().get_visible_rect().size.y)
	)
	
	if event is InputEventMouseMotion and not is_lock_cam:
		if camera_state.FIRST == current_camera_mode:
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
		move_camera_input(delta)
	
	var camera_length = camera_spring.get_length()
	
	if Input.is_action_just_released(input_zoom) and max_dist_third_person >= camera_length:
		camera_spring.set_length(camera_length + move_dist_camera)
		if camera_state.FIRST == current_camera_mode:
			switch_cam(camera_state.THIRD)
		
	if Input.is_action_just_released(input_unzoom) and min_dist_third_person < camera_length:
		camera_spring.set_length(camera_length - move_dist_camera)
		
	if not (camera_state.FIRST == current_camera_mode) and min_dist_third_person > camera_length:
		switch_cam(camera_state.FIRST)
			
	camera_spring.orthonormalize()

## Deplace la camera
##
## Si la camera est attacher à un objet elle le suivra
## Si elle est detacher elle à son propres sette de déplacement
## TODO Faire monter ou désendre la camera
func move_camera_input(_delta) -> void:
	if is_tying_camera:
		link_player.move_and_slide()
		position = link_player.position
	else:
		var move_direction := Vector3.ZERO
		move_direction.x = Input.get_axis(input_move_left, input_move_right)
		move_direction.z = Input.get_axis(input_move_forward, input_move_downward)
		move_direction.normalized()
		
		var orientation_x: float = pivot_third_camera_x.rotation.y
			
		if (camera_state.FIRST == current_camera_mode):
			orientation_x = link_player.rotation.y
		
		move_direction = move_direction.rotated(Vector3.UP, orientation_x).normalized()
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
		camera_state.THIRD:
			third_camera.make_current()
		camera_state.MENU:
			first_camera.make_current()
			lock_movement()
			lock_camera()
		camera_state.OVERLAY_MENU:
			lock_camera()
			lock_movement()
		camera_state.NULL:
			lock_camera()
			lock_movement()

	current_camera_mode = mode
	change_camera_mode.emit(current_camera_mode)

## Lance la rotation de la camera
func rotate_camera(move, pivot_y: Node3D, pivot_x: Node3D) -> void:
	
	move.y *= camera_speed_axe_y

	# Verifie si la rotation qui vas êtres demander n'est pas superieur à c'elle souhaiter
	# Si supérieur prend move.y prend la valeur maximal de la rotation
	match clampf(pivot_y.rotation.x + move.y , CAMERA_X_ROT_MIN, CAMERA_X_ROT_MAX):
		CAMERA_X_ROT_MAX: 
			move.y = (CAMERA_X_ROT_MAX - pivot_y.rotation.x)
		CAMERA_X_ROT_MIN: 
			move.y = (CAMERA_X_ROT_MIN - pivot_y.rotation.x)
	
	pivot_x.rotate_y(-move.x * camera_speed_axe_x)
	pivot_x.orthonormalize()

	pivot_y.rotate_x(move.y)
	pivot_y.orthonormalize()

## Blocker la camera
func lock_camera() -> void:
	is_lock_cam = true
	change_lock_camera.emit(is_lock_cam)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

## Blocke le déplacement de la camera
func lock_movement() -> void:
	is_lock_move = true
	change_camera_mode.emit(is_lock_move)

## Deblocker la camera
func unlock_camera() -> void:
	is_lock_cam = false
	change_lock_camera.emit(is_lock_cam)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

## Déblocke le déplacement de la camera 
func unlock_movement() -> void:
	is_lock_move = false
	change_movement_camera.emit(is_lock_cam)
