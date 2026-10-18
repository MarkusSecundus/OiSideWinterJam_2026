@tool
extends GridContainer

func _ready() -> void:
	self.add_theme_constant_override("h_separation", 50)
	self.add_theme_constant_override("v_separation", 10)
