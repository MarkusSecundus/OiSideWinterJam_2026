extends TextureButton

@onready var buttons = $"../../../Buttons"
@onready var clues = $"../../../Clues"
@onready var dialogue_box = $"../../../DialogueBox"
@export var row: int
@export var col: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _pressed() -> void:
	disabled = true
	modulate = Color(0.5, 0.5, 0.5, 0.9)
	clues.generate_clue.rpc_id(0, row, col, 0 if multiplayer.is_server() else 1)
