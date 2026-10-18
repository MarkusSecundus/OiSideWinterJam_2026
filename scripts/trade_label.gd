extends Label

@onready var PartA = $"../PartA"
@onready var Operator = $"../Operator"
@onready var PartB = $"../PartB"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var partA = PartA.get_selected_id()
	var op = Operator.get_selected_id()
	var partB = PartB.get_selected_id()
	
	if partA < 0 || op < 0 || (op > 1 && partB < 0):
		text = "(invalid clue)"
		return
	
	var r1 = (partA / 4) + 1
	var c1 = (partA % 4) + 1
	var r2 = (partB / 4) + 1
	var c2 = (partB % 4) + 1
	
	text = Clue.new(r1, c1, r2, c2, op).clue_to_text()
