extends Resource
class_name LevelSaveInfo

##World
@export var World:int = 0
##Level
@export var Level:int = 0
##Level Name
@export var LevelName:StringName = "Placeholder"
##Level Scene UID
@export var LevelUID:StringName = "uid://Placholder"
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
	
	SaveHandler.SetLevelComplete(World, Level, self)
