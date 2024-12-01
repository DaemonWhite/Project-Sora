extends Resource

class_name markerDataClasss

var first_person_marker: Vector3 = Vector3.ZERO
var third_person_marker: Vector3 = Vector3.ZERO
var first_person_marker_activate: bool = false
var third_person_marker_activate: bool = false
	
func set_first_person_marker_state(activate: bool) -> void:
	first_person_marker_activate = activate
	
func set_third_person_marker_state(activate: bool) -> void:
	third_person_marker_activate = activate
