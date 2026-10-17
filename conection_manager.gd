extends Node

const port = 12357

var peer = ENetMultiplayerPeer.new()

func host():
	if peer.create_server(port) != 0:
		return false
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(
		func(pid) -> void:
			print(str(pid) + " connected")
	)

func join(server_ip):
	peer.create_client(server_ip, port)
	multiplayer.multiplayer_peer = peer
	
