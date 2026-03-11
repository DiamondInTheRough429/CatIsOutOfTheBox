extends TileHanlder
class_name WallTileHandler

func PrepColision() -> void:
	super.PrepColision()
	set_collision_layer_value(4, true)
