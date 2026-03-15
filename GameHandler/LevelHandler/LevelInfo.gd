extends Resource
##Info related to the level
class_name LevelInfo

##World
@export var World:int = 0
##Level
@export var Level:int = 0
##Level Name
@export var LevelName:StringName = "Placeholder"
##Level Scene UID
@export var LevelUID:StringName
##Next Levels UID
@export var NextLevelUID:StringName
##Time in seconds need to beat level and get star
@export var TimeStarLimit:float = 10
