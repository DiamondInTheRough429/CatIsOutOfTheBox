extends TileMapLayer
class_name LevelHandler

##Resource handling World and level int, Saving, Complete status, and UID storage
@export var LevelSaveResource:LevelSaveInfo
##Background of this level
@export var Background:TileMapLayer

func _ready() -> void:
	if Background != null:
		Background.z_index = -10
	z_index = -5
	LevelSaveResource.EndLevel(false)
