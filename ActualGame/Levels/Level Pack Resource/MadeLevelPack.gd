extends Resource
class_name MadeLevelPack

@export var World:int = -1
var WorldNameFormat:String = "WORLD_NAME_%d"
@export var Levels:Array[LevelInfo]

func GetWorldName() -> String:
	return WorldNameFormat %World
