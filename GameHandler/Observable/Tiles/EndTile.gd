extends TileHanlder
class_name EndTileHandler

signal PlayerReachedEnd

func _ready() -> void:
	super._ready()
	z_index = 6

func PlayerEnter(_Player:PlayerHandler) -> void:
	PlayerReachedEnd.emit()
