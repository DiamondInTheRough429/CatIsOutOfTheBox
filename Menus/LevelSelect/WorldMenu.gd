extends ScrollContainer
class_name WorldMenu

@export var WorldInfo:MadeLevelPack
@export var WorldNameLabel:Label
@export var StarAmountLabel:Label
@export var LevelButtonHolder:Control
@export var LevelButtonScene:PackedScene

func MatchWorld() -> void:
	if WorldInfo != null:
		name = WorldInfo.GetWorldName()
		WorldNameLabel.text = name
		StarAmountLabel.text = " X %d" %WorldInfo.Stars

func MakeButtons() -> void:
	for Level:LevelInfo in WorldInfo.Levels:
		var NewButton:LevelSelectButton = LevelButtonScene.instantiate()
		LevelButtonHolder.add_child(NewButton)
		NewButton.SetInfo(Level)
		if Level.Level > WorldInfo.HighestComplete+1:
			NewButton.disabled = true
