extends Button

@onready var clues_list: ItemList = $"../TheirCluesList"
@onready var clues = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if clues_list.get_selected_items().size() > 0:
		disabled = false
	else:
		disabled = true
	
func _pressed() -> void:
	var selected_items = clues_list.get_selected_items()
	if selected_items.size() > 0:
		clues.call_bullshit.rpc_id(0, selected_items[0], 0 if multiplayer.is_server() else 1)
