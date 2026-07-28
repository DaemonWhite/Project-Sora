class_name NotificationData
extends RefCounted

enum Type { INFO, SUCCESS, ERROR, QUEST, ITEM }

var title: String
var message: String
var duration: float
var type: Type
var icon: Texture2D            # null = utilise l'icône par défaut de l'UI
var custom_scene: PackedScene  # null = utilise la scène par défaut liée au Type

func _init(
	p_title: String = "", 
	p_message: String = "", 
	p_duration: float = 5.0, 
	p_type: Type = Type.INFO, 
	p_icon: Texture2D = null,
	p_custom_scene: PackedScene = null
) -> void:
	title = p_title
	message = p_message
	duration = p_duration
	type = p_type
	icon = p_icon
	custom_scene = p_custom_scene