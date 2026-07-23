extends Control

var inventaire = false
#
func inventory():
	inventaire = !inventaire
	if inventaire:
		show()
	else:
		hide()

func _input(event):
	if event.is_action_pressed("Inventaire"):
		inventory()
