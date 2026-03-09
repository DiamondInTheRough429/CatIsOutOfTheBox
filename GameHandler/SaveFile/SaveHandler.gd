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

##Set level to complete
func SetLevelComplete(World:int, Level:int, SaveInfo:LevelSaveInfo) -> void:
	SaveFile.set_value(str(World),  str(Level), SaveInfo)
	Save()

##Check status of level
func CheckLevelComplete(World:int, Level:int) -> LevelSaveInfo:
	return SaveFile.get_value(str(World), str(Level), null)
