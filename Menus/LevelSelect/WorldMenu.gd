extends ScrollContainer
class_name WorldMenu

@export var WorldInfo:MadeLevelPack
@export var WorldNameLabel:Label
@export var StarAmountLabel:Label
@export var LevelButtonHolder:Control
@export var LevelButtonScene:PackedScene
@export var MainMenuButton:Button
var LevelToButton:Dictionary[int, Button]

func _ready() -> void:
	MainMenuButton.pressed.connect(GoMainMenu)

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
		LevelToButton.set(Level.Level, NewButton)
	ConnectButtons()

func ConnectButtons() -> void:
	for i in LevelToButton.keys():
		var iButton:Button = LevelToButton.get(i)
		iButton.focus_neighbor_left = LevelToButton.get(i-1).get_path() if LevelToButton.has(i-1) else LevelToButton.get(LevelToButton.size()).get_path()
		iButton.focus_neighbor_right = LevelToButton.get(i+1).get_path() if LevelToButton.has(i+1) else LevelToButton.get(1).get_path()

func GoMainMenu() -> void:
	get_tree().change_scene_to_file.call_deferred("uid://buvo6k3q5bmq1")
	
