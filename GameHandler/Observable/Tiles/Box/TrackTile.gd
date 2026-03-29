extends TileHanlder
class_name TrackTileHandler

func PrepColision() -> void:
	super.PrepColision()
	set_collision_layer_value(7, true)
