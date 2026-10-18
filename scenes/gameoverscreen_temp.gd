extends Node2D

func _ready() -> void:
	var playerID : int = !multiplayer.is_server()
	
	var myDetective
	if playerID == 0:
		$CanvasLayer/Detective2.hide()
		myDetective = $CanvasLayer/Detective1
	if playerID == 1:
		$CanvasLayer/Detective1.hide()
		myDetective = $CanvasLayer/Detective2
	
	if playerID == WinnerVariable.winner:
		$CanvasLayer/Label.text = "You win!"
		(myDetective as Node).find_child("GPUParticles2D").hide()
		(myDetective as Node).find_child("GPUParticles2D2").hide()
	
	
