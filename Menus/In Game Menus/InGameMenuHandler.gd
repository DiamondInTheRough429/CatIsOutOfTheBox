extends MenuHandler
class_name InGameMenuHandler

@export var Level:LevelHandler
@export var ResetButton:Button
@export var ContinueButton:Button
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

func ConnectLevel(NewLevel:LevelHandler = Level) -> void:
	Level = NewLevel
	if Level != null:
		ResetButton.pressed.connect(ResetButtonPressed)

func ContinuePressed() -> void:
	Player.CanMove = !Player.CanMove
	await MoveInOut(!Player.CanMove)
	CurrentMenu = true

func ResetButtonPressed() -> void:
	await MoveInOut(false)
	Level.Reset()
