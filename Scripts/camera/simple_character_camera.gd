class_name SimpleCharacterCamera
extends BaseCharacterCamera
## Deplacement d'un personnage simple
##
## Comparer à [BaseCharacterCamera] il peut êtres réèlement utiliser il sert aussi d'example pour la creation d'un mouvement
## Il érite bien évidement de [BaseCharacterCamera] et comme lui il est conçu pour êtres utilisée par [CameraHandler]


## Gère le déplacement du personage
func move_character_input(_delta) -> void:
	_move_direction.x = Input.get_axis(move_left, move_right)
	_move_direction.z = Input.get_axis(move_forward, move_downward)

	if _link_camera and ControllerCharacter.MOVEMENT_CAMERA == contoller_mode:
		_move_direction = _move_direction.rotated(Vector3.UP,  rotation.y).normalized()
		if _link_camera.current_camera_mode == _link_camera.CameraState.THIRD and _move_direction.z != 0:
			if _move_direction.z != 0:
				global_transform.basis = lerp(
					global_transform.basis,
					_link_camera.pivot_third_camera_x.basis,
					0.5 + _delta
				)
		
	_move_direction.normalized()
	velocity = Vector3( 
		_move_direction.x * move_speed,
		velocity.y,
		_move_direction.z * move_speed
	)
