class_name BaseCharacterCamera
extends CharacterBody3D
## Systeme de deplacement de base qui est conçu pour gérer les êtres relier à CameraHandler
##
## Ce systéme de déplacement est conçu pour gérer les déplacements pour autant il n'est pas recomandé de l'utiliser en tant que tel.
## Si vous avez besoin d'un script de déplacement préfèrer [SimpleCharacterCamera]. Il propose un systéme de déplacment plus complexe
## et qui correspondra beaucoup plus au déplacement traditionel du monde du jeux vidéo. Cela dit il est recommander de créer votre propre déplacement  
## Pour relier la camera au personage référé vous à [CameraHandler].

## Utilise la graviter des paramètres du jeu
var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")

## Comportement par défaut du personnage quand il est relier au script
enum ControllerCharacter {
	## Est soumis à la graviter
	GRAVITY, 
	## Est soumis au mouvement 
	MOVEMENT,
	## Est soumis au mouvement et déplace la camera avec
	MOVEMENT_CAMERA, 
	## Ne fait strictement rien
	NULL
}

## Si la camera ce deconnecte le script sera détacher du personnage
@export var native: bool = true

## Puissance du saut
@export var JUMP_IMPULSE = 5

## Vitesse de deplacement du personnage
@export var move_speed: float = 10

@export_group("Camera Position")

## Mode de controle par défaut
@export var contoller_mode: ControllerCharacter = ControllerCharacter.GRAVITY
## Mode de controle quand le personnage est lier à la caméra
@export var controller_mode_link: ControllerCharacter = ControllerCharacter.MOVEMENT_CAMERA
## Mode de controle quand le personnage est delier à la caméra
@export var controller_mode_unlink: ControllerCharacter = ControllerCharacter.GRAVITY 

## Indique la position de la camera premiere personne avec un marker
@export var first_camera_position: Marker3D
## Indique la posion de la camera troisieme personne avec un marker
@export var third_camera_position: Marker3D

@export_group("Controlle")

## Touche de déplacement avant du personnage
@export var move_forward: String = "ui_up"
## Touche de déplacement gauche du personnage
@export var move_left: String = "ui_left"
## Touche de déplacement droite du personnage
@export var move_right: String = "ui_right"
## Touche de déplacement arrière du personnage
@export var move_downward: String = "ui_down"

## Touche de saut du personnage
@export var jump: String = "ui_accept"


var _link_camera: CameraHandler = null
var _move_direction := Vector3.ZERO

func _ready() -> void:
	set_physics_process(true)


## Choisir le mode du controlleur en cas de liens avec le joueur
func set_controller_mode_link(controller_mode: ControllerCharacter) -> void:
	controller_mode_link = contoller_mode

## Choisir le mode de controller en cas de déliens avec le joueur
func set_controller_mode_unlink(controller_mode: ControllerCharacter) -> void:
	controller_mode_unlink = contoller_mode

## Genère automatique le marker en fonction de sa collision
##
## Attention ca ne gère que les collisions simple
func auto_generate_marker() -> void:
	var marker: markerDataClasss = search_placement_camera()
	
	if not first_camera_position or marker.first_person_marker:
		if marker.first_person_marker and not first_camera_position:
			first_camera_position = Marker3D.new()
			first_camera_position.position = marker.first_person_marker
		elif not first_camera_position:
			first_camera_position = Marker3D.new()
			first_camera_position.position = Vector3.ZERO
			
		if marker.third_person_marker and not third_camera_position:
			third_camera_position = Marker3D.new()
			third_camera_position.position = marker.third_person_marker
		elif not third_camera_position:
			third_camera_position = Marker3D.new()
			third_camera_position.position = Vector3.ZERO
		
		add_child(first_camera_position)
		add_child(third_camera_position)

## Change le mode de controle quand le personnage est lié
func linked(_camera: CameraHandler) -> void:
	contoller_mode = controller_mode_link
	_link_camera = _camera

## Change le mode de controle quand le personnage est delier
func unlinked() -> void:
	_link_camera = null
	contoller_mode = controller_mode_unlink
	velocity.x = 0
	velocity.z = 0
	move_and_slide()

## Algorithme qui determine la position des marker
func search_placement_camera() -> markerDataClasss:
	var marker_camera = markerDataClasss.new()
	 
	var collision_shape: CollisionShape3D = get_node("CollisionShape3D")
	if collision_shape:
		
		match collision_shape.shape.get_class():
			"SphereShape3D":
				marker_camera.set_first_person_marker_state(true)
				marker_camera.set_third_person_marker_state(true)
				marker_camera.third_person_marker = collision_shape.position
				marker_camera.first_person_marker.y = collision_shape.shape.radius
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
				push_warning("camera_hadler: Colision non connue ou non définie")
				marker_camera.set_third_person_marker_state(true)
				marker_camera.third_person_marker = collision_shape.position
				
	return marker_camera
	
func _physics_process(delta: float) -> void:
	match contoller_mode:
		ControllerCharacter.MOVEMENT:
			move_character_input(delta)
			
			if not is_on_floor():
				velocity.y = -GRAVITY * delta
			elif is_on_floor() and Input.is_action_just_pressed(jump):
				velocity.y = JUMP_IMPULSE

			_process_movement(delta)
				
			move_and_slide()
		ControllerCharacter.MOVEMENT_CAMERA:
			if not is_on_floor():
				velocity.y -= GRAVITY * delta
			elif is_on_floor() and Input.is_action_just_pressed(jump):
				velocity.y = JUMP_IMPULSE

			_process_movement_camera(delta)
				
			move_character_input(delta)
		ControllerCharacter.GRAVITY:
			if not is_on_floor():
				velocity.y -= GRAVITY * delta

			_process_movement_gravity(delta)
			move_and_slide()
		ControllerCharacter.NULL:
			_process_movement_null(delta)

## Virtual methode appeler quand [enum ControllerCharacter.MOVEMENT] selectione un mouvement 
func _process_movement(_delta):
	pass

## Virtual methode appeler quand [enum ControllerCharacter.MOVEMENT_CAMERA] selectione un mouvement
func _process_movement_camera(_delta):
	pass

## Virtual methode appeler quand [enum ControllerCharacter.GRAVITY] selectione un mouvement
func _process_movement_gravity(_delta):
	pass

## Virtual methode appeler quand [enum ControllerCharacter.NULL] selectione un mouvement
func _process_movement_null(_delta):
	pass

## Gère le déplacement du personage
## Cette méthode est prévue pour êtres modifier par sont enfant
## Un example ce trouver dans le code de [SimpleCharacterCamera]
## Ici il y'a un comportement de base qui est quand même appliquer
## [codeblock]
## func move_character_input(_delta) -> void:
## 	_move_direction.x = Input.get_axis(move_left, move_right)
## 	_move_direction.z = Input.get_axis(move_forward, move_downward)
## 
## 	if _link_camera and ControllerCharacter.MOVEMENT_CAMERA == contoller_mode:
## 		if _link_camera.current_camera_mode == _link_camera.camera_state.THIRD:
## 			global_transform.basis = _link_camera.pivot_third_camera_x.basis
## 		_move_direction = _move_direction.rotated(Vector3.UP, rotation.y).normalized()
## 
## 
## 	_move_direction.normalized()
## 	velocity = Vector3( 
## 		_move_direction.x * move_speed,
## 		velocity.y,
## 		_move_direction.z * move_speed
## 	)
## [/codeblock]
## 
func move_character_input(_delta) -> void:
	_move_direction.x = Input.get_axis(move_left, move_right)
	_move_direction.z = Input.get_axis(move_forward, move_downward)

	if _link_camera and ControllerCharacter.MOVEMENT_CAMERA == contoller_mode:
		if _link_camera.current_camera_mode == _link_camera.CameraState.THIRD:
			global_transform.basis = _link_camera.pivot_third_camera_x.basis
		_move_direction = _move_direction.rotated(Vector3.UP, rotation.y).normalized()


	_move_direction.normalized()
	velocity = Vector3( 
		_move_direction.x * move_speed,
		velocity.y,
		_move_direction.z * move_speed
	)

## Permet de connaitre la position de la camera premiere personne
func camera_first_position() -> Vector3:
	return first_camera_position.position

## Permet de connaitre la rotation de la camera premiere personne
func camera_first_rotation() -> Vector3:
	return first_camera_position.rotation

## Permet de connaitre la rotation de la camera troisieme personne
func camera_third_position() -> Vector3:
	return third_camera_position.position
