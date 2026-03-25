extends Resource
##Info for level save info
class_name LevelSaveInfo

##World
@export var World:int = 0
##Level
@export var Level:int = 0
##Completed
var Complete:bool = false
##Completed Deathless
var CompleteDeathless:bool = false
##Completed in time
var CompleteInTime:bool = false

func EndLevel(Finished:bool = true, Deathless:bool = false, InTime:bool = false) -> void:
	if !Complete:
		Complete = Finished
	if !CompleteDeathless:
		CompleteDeathless = Deathless
	if !CompleteInTime:
		CompleteInTime = InTime
	
	SaveHandler.SetLevelInfo(World, Level, self)
