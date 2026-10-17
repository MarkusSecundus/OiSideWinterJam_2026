extends Label

func _ready() -> void:
	self.text = IP.get_local_addresses()[0]
