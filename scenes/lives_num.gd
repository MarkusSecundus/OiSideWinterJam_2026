extends Label

@onready var clues = $"../../Clues"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# dirty sollution:
	# checking number of lives every frame, ending game if either player's lives reach 0
	if multiplayer.is_server():
		text = str(clues.p1_lives)
	else:
		text = str(clues.p2_lives)
