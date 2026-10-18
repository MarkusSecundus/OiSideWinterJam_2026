extends Button

@onready var Buttons = $".."
@export var UIElement: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		Buttons.toggle_off_all(self)
		UIElement.visible = true
	else:
		UIElement.visible = false
