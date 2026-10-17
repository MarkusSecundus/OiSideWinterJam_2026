extends Label

func _ready() -> void:
	self.text = IP.get_local_addresses()[0]
	for i in IP.get_local_addresses():
		print(i)
