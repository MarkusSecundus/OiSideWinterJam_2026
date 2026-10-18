extends Control

var sollution_murderer: int = -1
var sollution_weapon: int = -1
var sollution_location: int = -1

var p1_lives: int = 3
var p2_lives: int = 3

var p1_clues: Array[Clue] # clues P1 acquired from their questioning
var p2_clues: Array[Clue] # clues P2 acquired from their questioning

var p1_clues_flag: int = 0
var p2_clues_flag: int = 0 

var p1_clues_traded: Array[Clue] # clues P1 acquired by trading info with P2
var p2_clues_traded: Array[Clue] # clues P2 acquired by trading info with P1

var p1_clue_to_trade: Clue # clue that P1 is about to trade to P2
var p2_clue_to_trade: Clue # clue that P2 is about to trade to P1

var p1_clues_traded_flag: int = 0
var p2_clues_traded_flag: int = 0 

@onready
var rng = RandomNumberGenerator.new()
@onready var dialogue_box = $"../DialogueBox"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if multiplayer.is_server():
		generate_sollution()


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	pass

func generate_sollution() -> void:
	sollution_murderer = rng.randi_range(1, 4)
	sollution_weapon = rng.randi_range(1, 4)
	sollution_location = rng.randi_range(1, 4)
	
	print("Correct sollution: ", sollution_murderer, sollution_weapon, sollution_location)

# This function should be called with rpc_id(0) so that it gets called only once.
@rpc("any_peer", "call_local", "reliable", 0)
func generate_clue(row: int, col: int, playerID: int) -> Clue:
	var clue: Clue
	while true:
		clue = Clue.new(row, col, rng.randi_range(1, 3), rng.randi_range(1, 4), rng.randi_range(0, 4))
		if _evaluate_clue(clue) && (clue.col1 != clue.col2 || clue.row1 != clue.row2):
			break # clue is valid, stop rerolling
			
	if playerID == 0:
		p1_clues.push_back(clue)
		p1_clues_flag += 1
	else:
		p2_clues.push_back(clue)
		p2_clues_flag += 1
	return clue

func _evaluate_clue(clue: Clue) -> bool:
	var var1 = _is_var_true(clue.row1, clue.col1)
	var var2 = _is_var_true(clue.row2, clue.col2) if clue.operation > 1 else false
	
	if clue.operation == 0: # is true
		return var1
	elif clue.operation == 1: # is false
		return !var1
	elif clue.operation == 2: # xor
		return var1 != var2
	elif clue.operation == 3: # if
		return (!var1) || var2
	elif clue.operation == 4: # iff
		return var1 == var2
	
	print("Error: Impossible branch reached at _evaluate_clue!")
	return false

func _is_var_true(row: int, col: int) -> bool:
	if row == 1:
		return sollution_murderer == col
	elif row == 2:
		return sollution_weapon == col
	elif row == 3:
		return sollution_location == col
		
	print("Error: Impossible branch reached at _is_var_true!", " r=", row, ";c=", col)
	return false

# This function should be called with rpc_id(0) so that it gets called only once.
@rpc("any_peer", "call_local", "reliable", 0)
func add_clue_to_trade(r1: int, c1: int, r2: int, c2:int, op:int, playerID: int) -> void:
	var clue = Clue.new(r1, c1, r2, c2, op)
	if playerID == 0:
		p1_clue_to_trade = clue
	else:
		p2_clue_to_trade = clue
	
	if p1_clue_to_trade != null && p2_clue_to_trade != null:
		trade_clues()

# This function should be called with rpc_id(0) so that it gets called only once.
@rpc("any_peer", "call_local", "reliable", 0)
func trade_clues() -> void:
	if p1_clue_to_trade == null || p2_clue_to_trade == null:
		print("Error: Clue trade has commenced, but atleast one of the clues is null!")
	
	p2_clues_traded.push_back(p1_clue_to_trade)
	p1_clues_traded.push_back(p2_clue_to_trade)
	
	p1_clues_traded_flag += 1
	p2_clues_traded_flag += 1
	
	p1_clue_to_trade = null
	p2_clue_to_trade = null

# This function should be called with rpc_id(0) so that it gets called only once.
@rpc("any_peer", "call_local", "reliable", 0)
func call_bullshit(clueID: int, playerID: int) -> void:
	var clues_traded = p1_clues_traded if playerID == 0 else p2_clues_traded
	var clue = clues_traded[clueID]
	
	var is_bullshit = !_evaluate_clue(clue)
	if is_bullshit:
		if playerID == 0:
			p2_lives -= 1
		else:
			p1_lives -= 1
		clue.confirmation = 2 # confirmed bullshit
	else:
		if playerID == 0:
			p1_lives -= 1
		else:
			p2_lives -= 1
		clue.confirmation = 1 # confirmed not bullshit
		
	if playerID == 0:
		p1_clues_traded_flag += 1
	else:
		p2_clues_traded_flag += 1

# This function should be called with rpc() so that it gets called for all players.
@rpc("any_peer", "call_local", "reliable", 0)
func submit_sollution(m: int, w: int, l: int, playerID: int):
	var winner: int
	if sollution_murderer == m && sollution_weapon == w && sollution_location == l:
		winner = playerID
	else:
		winner = 0 if playerID == 1 else 1
	
	var is_server = multiplayer.is_server()
	
	var level = get_tree().root.get_node("Questioning")
	level.visible = false
	#level.call_deffered("free")
	
	if is_server:
		if winner == 0:
			get_tree().change_scene_to_file("res://scenes/victoryscreen_temp.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/gameoverscreen_temp.tscn")
	else:
		if winner == 1:
			get_tree().change_scene_to_file("res://scenes/victoryscreen_temp.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/gameoverscreen_temp.tscn")
