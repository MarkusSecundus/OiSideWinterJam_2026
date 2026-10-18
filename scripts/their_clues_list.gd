extends ItemList

@onready var clues = $"../../.."
var last_flag = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var clues_data: Array[Clue]
	if multiplayer.is_server():
		if last_flag == clues.p1_clues_traded_flag:
			return
		clues_data = clues.p1_clues_traded
		last_flag = clues.p1_clues_traded_flag
	else:
		if last_flag == clues.p2_clues_traded_flag:
			return
		clues_data = clues.p2_clues_traded
		last_flag = clues.p2_clues_traded_flag
		
	clear()
	for clue in clues_data:
		add_item(clue.clue_to_text(), null, true if clue.confirmation == 0 else false)
