extends Node

const port = 12357

var peer = ENetMultiplayerPeer.new()
@onready var menu = $"../menu"

func _ready() -> void:
	
	multiplayer.peer_connected.connect(
		func(pid) -> void:
			print(str(pid) + " connected")
			var root = get_tree().root
			var child: PackedScene = load("res://scenes/questioning.tscn")
			root.add_child(child.instantiate())
			menu.visible = false
	)
	multiplayer.connection_failed.connect(
		func():
			print("failed to connect")
	)

func host():
	if peer.create_server(port) != 0:
		print("failed to create server")
		return false
	print("created server")
	multiplayer.multiplayer_peer = peer
	
	

func join(server_ip):
	print("connecting to "+server_ip+" at "+str(port))
	peer.create_client(server_ip, port)
	multiplayer.multiplayer_peer = peer	
	
