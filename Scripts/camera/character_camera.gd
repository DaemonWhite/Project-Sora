class_name SimpleCharacterCamera
extends BaseCharacterCamera

func get_input(_delta) -> void:
	move_direction.x = Input.get_axis(move_left, move_right)
	move_direction.z = Input.get_axis(move_forward, move_downward)

	if link_camera and controller.MOVEMENT_CAMERA == contoller_mode:
		var orientation_x: float = link_camera.pivot_third_camera_x.rotation.y
		if (link_camera.camera_state.FIRST == link_camera.current_camera_mode):
			orientation_x = rotation.y
		elif (link_camera.camera_state.FIRST == link_camera.current_camera_mode):
			orientation_x = link_camera.pivot_first_camera_x.rotation.y

		move_direction = move_direction.rotated(Vector3.UP, orientation_x).normalized()
		if link_camera.current_camera_mode == link_camera.camera_state.THIRD and move_direction.z != 0:
			if move_direction.z != 0:
				global_transform.basis = lerp(
					global_transform.basis,
					link_camera.pivot_third_camera_x.basis,
					0.5 + _delta
				)
		
	move_direction.normalized()
	velocity = Vector3( 
		move_direction.x * move_speed,
		velocity.y,
		move_direction.z * move_speed
	)