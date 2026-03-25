extends Node
##Save Handler Script
class_name Save_Handler_Script

var SaveLocation:String = "user://SaveFile.cfg"
var SaveFile:ConfigFile = ConfigFile.new()

func _ready() -> void:
	Prep()

func Prep() -> void:
	var prepDir:DirAccess = DirAccess.open("user://")
	if !prepDir.file_exists(SaveLocation):
		print("Making SaveFile")
		Save()
	Load()

##Save the cnfig file
func Save() -> void:
	SaveFile.save(SaveLocation)

##Load the file
func Load() -> void:
	SaveFile.load(SaveLocation)

##Set The Level info for a worlds Level
func SetLevelInfo(World:int, Level:int, SaveInfo:LevelSaveInfo) -> void:
	if GetWorldHighestComplete(World) <= Level and SaveInfo.Complete != false:
		SetWorldHighestComplete(World, Level)
	SaveFile.set_value(str(World),  str(Level), SaveInfo)
	Save()

##Check Level info for a worlds Level
func GetLevelInfo(World:int, Level:int) -> LevelSaveInfo:
	if SaveFile.has_section_key(str(World), str(Level)):
		return SaveFile.get_value(str(World), str(Level), null)
	return null

func CalculateWorldStars(World:int) -> int:
	var Levels:int = 3 if World == 0 else 30
	var Stars:int = 0
	for Level in Levels:
		var CheckingInfo:LevelSaveInfo = GetLevelInfo(World, Level+1)
		if CheckingInfo != null:
			if CheckingInfo.Complete:
				Stars += 1
			if CheckingInfo.CompleteDeathless:
				Stars += 1
			if CheckingInfo.CompleteInTime:
				Stars += 1
	return Stars

func SetWorldHighestComplete(World:int, Level:int)->void:
	SaveFile.set_value(str(World),  "HighestComplete", Level)
	Save()

func GetWorldHighestComplete(World:int) -> int:
	if SaveFile.has_section_key(str(World), "HighestComplete"):
		return SaveFile.get_value(str(World), "HighestComplete", 0)
	return 0
