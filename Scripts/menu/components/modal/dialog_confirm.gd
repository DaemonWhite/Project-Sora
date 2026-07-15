extends Dialog

signal confirmed
signal canceled

func _on_cancel_pressed() -> void:
	emit_signal("canceled")
	self.close()

func _on_valide_pressed() -> void:
	emit_signal("confirmed")
	self.close()