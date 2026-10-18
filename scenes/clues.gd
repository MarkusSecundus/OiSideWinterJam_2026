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

var last_life_loss_reason = 0 # 0 - bullshit called out, 1 - false accusation

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
		#clue = Clue.new(row, col, rng.randi_range(1, 3), rng.randi_range(1, 4), rng.randi_range(0, 4))
		var op = rng.randi_range(0, 4)
		
		if op == 0 || op == 1: # is or not
			clue = Clue.new(row, col, -1, -1, op)
			
		elif op == 2: # xor
			var col2 = rng.randi_range(1, 3)
			if col2 >= col:
				col2 += 1
			clue = Clue.new(row, col, row, col2, op)
			
		else: # op == 3 || op == 4 # if or iff
			var row2 = rng.randi_range(1,2)
			var col2 = rng.randi_range(1,4)
			if row2 >= row:
				row2 += 1
			clue = Clue.new(row, col, row2, col2, op)
		
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
		%TradeButton.rpc("clear")

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
		last_life_loss_reason = 0
		clue.confirmation = 2 # confirmed bullshit
	else:
		if playerID == 0:
			p1_lives -= 1
		else:
			p2_lives -= 1
		last_life_loss_reason = 1
		clue.confirmation = 1 # confirmed not bullshit
		
	if playerID == 0:
		p1_clues_traded_flag += 1
	else:
		p2_clues_traded_flag += 1
		
	if p1_lives <= 0 || p2_lives <= 0:
		var winner = 0 if p2_lives <= 0 else 1
		if last_life_loss_reason == 0:
			end_game.rpc(
				winner,
				"You lost your last life by being called out on your bullshit!",
				"You calling out your rival's lies was the last straw!\nTheir reputation is in the mud!"
			)
		else:
			end_game.rpc(
				winner,
				"You lost your last life by falsely accusing your rival of lying!",
				"Your rival lost their last bit of reputation by falsely accusing you of lying!"
			)

# This function should be called with rpc_id(0) so that it gets called only once.
@rpc("any_peer", "call_local", "reliable", 0)
func submit_sollution(m: int, w: int, l: int, playerID: int):
	var winner: int
	var sollution_is_correct = sollution_murderer == m && sollution_weapon == w && sollution_location == l
	if sollution_is_correct:
		winner = playerID
		end_game.rpc(
			winner,
			"Your rival solved the murder case before you did!",
			"You solved the murder case before the rival! Congratulations!"
			)
	else:
		winner = 0 if playerID == 1 else 1
		end_game.rpc(
			winner,
			"The sollution to the murder case that you presented was incorrect!",
			"Your rival submitted a wrong sollution to the murder case...\nYou win by default!"
			)


# This function should be called with rpc() so that it gets called for all players.
@rpc("any_peer", "call_local", "reliable", 0)		
func end_game(winner_playerID: int, loser_msg: String, winner_msg: String):
	var level = get_tree().root.get_node("Questioning")
	level.visible = false
	
	var local_playerID = 0 if multiplayer.is_server() else 1
	var scene_root_str = ""
	if winner_playerID == 0:
		get_tree().change_scene_to_file("res://scenes/P1victory.tscn")
		scene_root_str = "root/P1Victory/"
	else:
		get_tree().change_scene_to_file("res://scenes/P2victory.tscn")
		scene_root_str = "root/P2Victory/"
	
	await get_tree().process_frame
	
	var label1: Label = %Label1
	var label2: Label = %Label2
	
	#while(label1 == null && label2 == null):
	#	label1 = get_tree().root.get_node_or_null(scene_root_str + "Label1")
	#	label2 = get_tree().root.get_node_or_null(scene_root_str + "Label2")
	#	await get_tree().process_frame
	#if local_playerID == winner_playerID:
	#	label1.text = "YOU WIN!"
	#	label2.text = winner_msg
	#else:
	#	label1.text = "YOU LOSE!"
	#	label2.text = loser_msg
