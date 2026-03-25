extends Resource
##Info related to the level
class_name LevelInfo

##World
@export var World:int = 0
##Level
@export var Level:int = 0
##Level Name Format
var LevelNameFormat:StringName = "LEVEL_NAME_%d-%d"
##Level Scene UID
@export var LevelUID:StringName
##Next Levels UID
@export var NextLevelUID:StringName
##Time in seconds need to beat level and get star
@export var TimeStarLimit:float = 10

func GetName() -> String:
	return LevelNameFormat %[World, Level]
