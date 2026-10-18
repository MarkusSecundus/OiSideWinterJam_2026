extends Button

@onready var clues = $"../../../Clues"

@onready var PartA = $"../PartA"
@onready var Operator = $"../Operator"
@onready var PartB = $"../PartB"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if multiplayer.is_server():
		if clues.p1_clue_to_trade == null:
			disabled = false
			text = "Lock in your information"
		else:
			disabled = true
			text = "Already locked in,\nawaiting response..."
	else:
		if clues.p2_clue_to_trade == null:
			disabled = false
			text = "Lock in your information"
		else:
			disabled = true
			text = "Already locked in,\nawaiting response..."
			
			
func _pressed() -> void:
	var a = PartA.selected
	var op = Operator.selected
	var b = PartB.selected
	
	if a < 0 || op < 0 || (op > 1 && b < 0):
		return
	
	var r1 = (a / 4) + 1
	var c1 = (a % 4) + 1
	var r2 = (b / 4) + 1
	var c2 = (b % 4) + 1
	
	disabled = true
	
	clues.add_clue_to_trade.rpc_id(0, r1, c1, r2, c2, op, 0 if multiplayer.is_server() else 1)

@rpc("any_peer", "call_local", "reliable", 0) 
func clear():
	Operator.select(-1)
	PartA.select(-1)
	PartB.select(-1)
