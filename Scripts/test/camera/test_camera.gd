extends Node3D

@export var camera: CharacterBody3D

@onready var list_input = [
	["lock_camera", KEY_L],
	["free_cam", KEY_P],	
]

@onready var list_character = [
	["Scare", KEY_KP_1, $Scare],
	["Capsule", KEY_KP_2, $Capsule],
	["Sphere", KEY_KP_3, $Sphere],
	["Prism", KEY_KP_4, $Prism],
]

func _ready() -> void:
	for input in list_input:
		var ev = InputEventKey.new()
		ev.physical_keycode = input[1]
		InputMap.add_action(input[0])
		InputMap.action_add_event(input[0], ev)
	
	for character in list_character:
		var ev = InputEventKey.new()
		ev.physical_keycode = character[1]
		InputMap.add_action(character[0])
		InputMap.action_add_event(character[0], ev)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_released("lock_camera"):
		if camera.is_lock:
			camera.unlock()
		else:
			camera.lock()

	for character in list_character : 
		if Input.is_action_just_released(character[0]):
			camera.unliked_camera_as_player()
			camera.set_tying_player(character[2])
			camera.linked_camera_as_player()
			
	if Input.is_action_just_released("free_cam"):
		camera.unliked_camera_as_player()