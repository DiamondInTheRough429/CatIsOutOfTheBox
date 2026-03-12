extends Node
class_name TileGroup

@export var Level:LevelHandler
@export var GroupPoss:Array[Vector2i]
var Group:Array[TileHanlder]

func GetGroup() -> void:
	for Pos in GroupPoss:
		print(Pos)
