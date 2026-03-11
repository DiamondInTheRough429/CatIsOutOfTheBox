extends Observable
class_name TileHanlder

func _ready() -> void:
	area_entered.connect(AreaEnter)
	area_exited.connect(AreaExit)

##Check if enter is player
func AreaEnter(Area:Area2D) -> void:
	if Area is PlayerHandler:
		PlayerEntered(Area)

##check if exit is player
func AreaExit(Area:Area2D) -> void:
	if Area is PlayerHandler:
		PlayerExited(Area)

##HAndle Player Entering
func PlayerEntered(_Player:PlayerHandler) -> void:
	pass

##Handle Player Leaving
func PlayerExited(_Player:PlayerHandler) -> void:
	pass
