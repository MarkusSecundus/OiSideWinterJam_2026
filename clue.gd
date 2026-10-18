extends Resource
class_name Clue

@export var row1: int
@export var col1: int
@export var row2: int
@export var col2: int
@export var operation: int # 0 - is true, 1 - not, 2 - xor, 3 - if, 4 - iff
@export var confirmation: int # 0 - unconfirmed, 1 - confirmed truth, 2 - confirmed lie

func _init(r1: int, c1: int, r2: int, c2: int, op: int) -> void:
	row1 = r1
	col1 = c1
	row2 = r2 if op > 1 else -1
	col2 = c2 if op > 1 else -1
	operation = op
	confirmation = 0
	
func _get_part_A(row: int, col: int) -> String:
	if row == 1:
		if col == 1:
			return "Mr. Cat"
		elif col == 2:
			return "Ms. Bird"
		elif col == 3:
			return "Mr. Dog"
		elif col == 4:
			return "Sir Porkinson"
	elif row == 2:
		if col == 1:
			return "The Knife"
		elif col == 2:
			return "The Hammer"
		elif col == 3:
			return "The Pistol"
		elif col == 4:
			return "The Poison"
	elif row == 3:
		if col == 1:
			return "The Kitchen"
		elif col == 2:
			return "The Bathroom"
		elif col == 3:
			return "The Bedroom"
		elif col == 4:
			return "The Attic"
	return "<blank>"
	
func _get_part_B(row: int) -> String:
	if row == 1:
		return "the culprit"
	elif row == 2:
		return "the murder weapon"
	elif row == 3:
		return "the crime scene"
	return "<blank>"
	

func clue_to_text() -> String:
	var clue = self
	var partA1 = _get_part_A(clue.row1, clue.col1)
	var partA2 = _get_part_A(clue.row2, clue.col2)
	var partB1 = _get_part_B(clue.row1)
	var partB2 = _get_part_B(clue.row2)
	
	var text

	if clue.operation == 0: # is true
		text = str(
			partA1, " IS ", partB1, "."
		)
	elif clue.operation == 1: # is not
		text = str(
			partA1, " is NOT ", partB1, "."
		)
	
	elif clue.operation == 2: # xor
		text = str(
			"Either ", partA1, " is ", partB1, ", or",
			partA2, " is ", partB2, "."
		)
	elif clue.operation == 3: # if
		text = str(
			"If ", partA1, " is ", partB1, ", then ",
			partA2, " must be ", partB2, "."
		)
	elif clue.operation == 4: # iff
		text = str(
			partA1, " is ", partB1, " if and only if ",
			partA2, " is ", partB2, "."
		)
	else:
		text = ""
	
	if confirmation == 1:
		text = text + " (CONFIRMED TRUTH)"
	elif confirmation == 2:
		text = text + " (CONFIRMED LIE)"
	
	return text
	
