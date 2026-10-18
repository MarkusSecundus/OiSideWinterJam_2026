extends TextureButton

@export var row: int
@export var col: int

@onready var buttons = $"../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		modulate = Color("White")
		buttons.toggle_off(row, col)
	else:
		buttons.toggle_off_self(row, col)
		modulate = Color(0.5, 0.5, 0.5, 0.9)
