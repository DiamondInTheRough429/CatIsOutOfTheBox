extends TileHanlder
class_name EndTileHandler

signal PlayerReachedEnd

func PlayerEntered(_Player:PlayerHandler) -> void:
	PlayerReachedEnd.emit()
