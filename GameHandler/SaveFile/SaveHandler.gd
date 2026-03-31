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
		SetCosmeticUnlocked(SettingsHandler.Cosmetics.DEFAULT_COSMETIC, true)
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
	var Levels:int = 30 
	match World:
		0:
			Levels = 4
		1:
			Levels = 15
		2:
			Levels = 20
		_:
			Levels = 30
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

func SetCosmeticUnlocked(Cosmetic:SettingsHandler.Cosmetics, Unlocked:bool) -> void:
	SaveFile.set_value("Cosmetics", str(Cosmetic), Unlocked)
	Save()

func GetCosmeticUnlocked(Cosmetic:SettingsHandler.Cosmetics) -> bool:
	if SaveFile.has_section_key("Cosmetics", str(Cosmetic)):
		return SaveFile.get_value("Cosmetics", str(Cosmetic), false)
	return false

func HelpContinue() -> Vector2i:
	var HighestComplete:Vector2i = Vector2i(0,0)
	for Sec:String in SaveFile.get_sections():
		if SaveFile.has_section_key(Sec, "HighestComplete"):
			var HighLevel:int = SaveFile.get_value(Sec, "HighestComplete")
			var World:int = int(Sec)
			if World == HighestComplete.x:
				HighestComplete = Vector2i(World, HighLevel)
			elif World > HighestComplete.x:
				var NeededLevel:int
				match HighestComplete.x:
					0:
						NeededLevel = 4
					1:
						NeededLevel = 15
					2:
						NeededLevel = 20
					_:
						NeededLevel = 30
				if HighestComplete.y == NeededLevel:
					HighestComplete = Vector2i(World, HighLevel)
	return HighestComplete
			
