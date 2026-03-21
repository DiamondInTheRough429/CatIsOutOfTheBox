extends Observable
class_name TileHanlder

signal PlayerEntered(Player:PlayerHandler)
signal PlayerExited(Player:PlayerHandler)

func _ready() -> void:
	area_entered.connect(AreaEnter)
	area_exited.connect(AreaExit)

##Check if enter is player
func AreaEnter(Area:Area2D) -> void:
	if Area is PlayerHandler:
		PlayerEntered.emit(Area)

##check if exit is player
func AreaExit(Area:Area2D) -> void:
	if Area is PlayerHandler:
		PlayerExited.emit(Area)

func PlayerEnter(_Player:PlayerHandler) -> void:
	pass
	
func PlayerExit(_Player:PlayerHandler) -> void:
	pass
