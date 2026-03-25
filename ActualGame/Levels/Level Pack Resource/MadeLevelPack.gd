extends Resource
class_name MadeLevelPack

@export var World:int = -1
var WorldNameFormat:String = "WORLD_NAME_%d"
@export var Levels:Array[LevelInfo]
var HighestComplete:int
var Stars:int

var StarsHave

func _init() -> void:
	MatchSave.call_deferred()

func GetWorldName() -> String:
	return WorldNameFormat %World

func MatchSave() -> void:
	HighestComplete = SaveHandler.GetWorldHighestComplete(World)
	Stars = SaveHandler.CalculateWorldStars(World)
