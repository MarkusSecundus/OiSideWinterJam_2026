extends Button

func _pressed() -> void:
	%connectionManager.join(get_parent().find_child("LineEdit").text)
