extends MenuHandler
class_name InGameMenuHandler

##Level menu comunicates with
@export var Level:LevelHandler
##The reset level button
@export var ResetButton:Button
##Continue game button
@export var ContinueButton:Button
##Player this menu comunicates with
@export var Player:PlayerHandler

func _ready() -> void:
	super._ready()
	ConnectLevel()
	if ContinueButton != null:
		ContinueButton.pressed.connect(ContinuePressed)

func MoveInOut(In:bool = true) -> void:
	await super.MoveInOut(In)
	if CurrentMenu:
		Player.CurrentMenu = self

##Connects menu to level
func ConnectLevel(NewLevel:LevelHandler = Level) -> void:
	Level = NewLevel
	if Level != null:
		if !ResetButton.pressed.is_connected(ResetButtonPressed):
			ResetButton.pressed.connect(ResetButtonPressed)

##Continue game when button pressed
func ContinuePressed() -> void:
	Player.CanMove = !Player.CanMove
	await MoveInOut(!Player.CanMove)
	CurrentMenu = true

##REset the level when button is pressed
func ResetButtonPressed() -> void:
	await MoveInOut(false)
	Level.Reset()
