extends Node

const port = 12357

var peer = ENetMultiplayerPeer.new()

func _ready() -> void:
	
	multiplayer.peer_connected.connect(
		func(pid) -> void:
			print(str(pid) + " connected")
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
	
