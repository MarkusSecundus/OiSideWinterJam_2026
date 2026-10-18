extends Control

@onready var TradeButton = $TradeButton
@onready var CluesButton = $CluesButton
@onready var QuestionButton = $QuestionButton
@onready var SolveButton = $SolveButton

@onready var TradeUI = $"../Trade"
@onready var SolveUI = $"../Solve"
@onready var QuestionUI = $"../Question"
@onready var CluesUI = $"../Clues"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func toggle_off_all(except: TextureButton) -> void:
	if except != TradeButton:
		TradeButton.button_pressed = false
	if except != CluesButton:
		CluesButton.button_pressed = false
	if except != QuestionButton:
		QuestionButton.button_pressed = false
	if except != SolveButton:
		SolveButton.button_pressed = false
	
	#TradeUI.visible = false
	#SolveUI.visible = false
	#QuestionUI.visible = false
	#CluesUI.visible = false
