extends Control

@onready var buttonA1: TextureButton = $ColorRect/A1
@onready var buttonA2: TextureButton = $ColorRect/A2
@onready var buttonA3: TextureButton = $ColorRect/A3
@onready var buttonA4: TextureButton = $ColorRect/A4
var rowA_pressed = -1

@onready var buttonB1: TextureButton = $ColorRect/B1
@onready var buttonB2: TextureButton = $ColorRect/B2
@onready var buttonB3: TextureButton = $ColorRect/B3
@onready var buttonB4: TextureButton = $ColorRect/B4
var rowB_pressed = -1

@onready var buttonC1: TextureButton = $ColorRect/C1
@onready var buttonC2: TextureButton = $ColorRect/C2
@onready var buttonC3: TextureButton = $ColorRect/C3
@onready var buttonC4: TextureButton = $ColorRect/C4
var rowC_pressed = -1

@onready var confirm_button: Button = $ConfirmSollutionButton
@onready var main_clues = $"../Clues"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func confirm_sollution() -> void:
	main_clues.submit_sollution.rpc_id(
		0,
		rowA_pressed,
		rowB_pressed,
		rowC_pressed,
		0 if multiplayer.is_server() else 1	
	)
	
func toggle_off(row: int, col: int) -> void:
	var row_array
	if row == 1:
		row_array = [buttonA1, buttonA2, buttonA3, buttonA4]
		rowA_pressed = col
	elif row == 2:
		row_array = [buttonB1, buttonB2, buttonB3, buttonB4]
		rowB_pressed = col
	elif row == 3:
		row_array = [buttonC1, buttonC2, buttonC3, buttonC4]
		rowC_pressed = col
	
	for i in range(4):
		if col != i + 1:
			row_array[i].button_pressed = false
	
	if rowA_pressed > 0 && rowB_pressed > 0 && rowC_pressed > 0:
		confirm_button.disabled = false
	else:
		confirm_button.disabled = true
		
			
