extends CharacterBody3D

## Utilse la graviter des paramètres du jeu
var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")
## Puissance du saut
var JUMP_IMPULSE = 5

## Comportement par défaut du personnage quand il est relier au script
enum controller {
	## Est soumis à la graviter
	GRAVITY, 
	## Est soumis au mouvement 
	MOVEMENT,
	## Est soumis au mouvement et déplace la camera avec
	MOVEMENT_CAMERA, 
	## Ne fait strictement rient
	NULL
}

## Mode de controle de par défaut
@export var contoller_mode: controller = controller.GRAVITY
## Mode de controle quand le personnage est lier
@export var controller_mode_link: controller = controller.MOVEMENT_CAMERA
## Mode de controle quand le personnage est delier
@export var controller_mode_unlink: controller = controller.GRAVITY 

## Indique la posion de la camera premiere personne avec un marker
@export var first_camera_position: Marker3D
## Indique la posion de la camera troisieme personne avec un marker
@export var third_camera_poistion: Marker3D

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

## Vitesse de deplacement du personnage
@export var move_speed: float = 10

func _ready() -> void:
	set_physics_process(true)
	
func set_controller_mode_link(controller_mode: controller):
	controller_mode_link = contoller_mode
	
func set_controller_mode_unlink(controller_mode: controller):
	controller_mode_unlink = contoller_mode

## Genère automatique le marker en fonction de sa collision
##
## Attention ca ne gère que les collision simple
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

## Change le mode de controle quand le personnage est lier 
func linked():
	contoller_mode = controller_mode_link

## Change le mode de controle quand le personnage est delier
func unlinked():
	contoller_mode = controller_mode_unlink
	velocity.x = 0
	velocity.z = 0
	move_and_slide()

## Algorithme qui determine la position des marker
func search_collision() -> markerDataClasss:
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
		controller.MOVEMENT:
			get_input(delta)
			
			if not is_on_floor():
				velocity.y -= GRAVITY * delta
			elif is_on_floor() and Input.is_action_just_released(jump):
				velocity.y = JUMP_IMPULSE
				
			move_and_slide()
		controller.MOVEMENT_CAMERA:
			if not is_on_floor():
				velocity.y -= GRAVITY * delta
			elif is_on_floor() and Input.is_action_just_released(jump):
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

## Permet de connaitre la position de la camera premiere personne
func camera_first_position() -> Vector3:
	return first_camera_position.position

## Permet de connaitre la rotation de la camera premire personne
func camera_first_rotation() -> Vector3:
	return first_camera_position.rotation

## Permet de connaitre la rotation de la camera troisieme personne
func camera_third_position() -> Vector3:
	return third_camera_poistion.position
