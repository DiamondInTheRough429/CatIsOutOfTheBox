extends TileHanlder
class_name EndTileHandler

signal PlayerReachedEnd

func PlayerEnter(_Player:PlayerHandler) -> void:
	PlayerReachedEnd.emit()
