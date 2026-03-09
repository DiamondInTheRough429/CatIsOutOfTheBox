extends Observable
class_name TileHanlder

func _ready() -> void:
	area_entered.connect(AreaEnter)
	area_exited.connect(AreaExit)

func AreaEnter(Area:Area2D) -> void:
	if Area is PlayerHandler:
		pass

func AreaExit(Area:Area2D) -> void:
	if Area is PlayerHandler:
		pass
