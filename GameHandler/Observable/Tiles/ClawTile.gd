extends TileHanlder
class_name  ClawTile

@export var ScratchPlayer:AudioStreamPlayer2D

func PlayerEnter(_Player:PlayerHandler) -> void:
	_Player.AnimatePlayer("Scratch")
	ScratchPlayer.play()
	
