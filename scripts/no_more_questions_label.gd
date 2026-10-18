extends Label

@onready var clues = $"../../Clues"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if clues.player_can_question():
		text = ""
	else:
		text = "HALT!
		The department has noticed that you arn't sharing enough information with your rival!
		You have to TRADE one CLUE before you can continue with your questioning!"
