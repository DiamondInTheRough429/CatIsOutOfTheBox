extends Node

func _ready() -> void:
	MakeThirty()

func MakeThirty() -> void:
	for i in 30:
		print(i+1)
		var MadeLevelinfo:LevelInfo = LevelInfo.new()
		MadeLevelinfo.World = 3
		MadeLevelinfo.Level = i+1
		ResourceSaver.save(MadeLevelinfo, "res://ActualGame/Levels/(003)/InfoResource/0%s.tres" %MadeLevelinfo.Level)
