extends TileHanlder
class_name PoisonTile

func PlayerEnter(_Player:PlayerHandler) -> void:
	_Player.KillPlayer()
