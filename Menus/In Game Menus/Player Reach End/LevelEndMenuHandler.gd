extends InGameMenuHandler
class_name LevelEndMenuHandler

#region End Level Vars
@export var NextLevelButton:Button
@export var LevelEndLabel:Label
@export var CompleteStar:AnimatedSprite2D
@export var DeathlessStar:AnimatedSprite2D
@export var TimeStar:AnimatedSprite2D

func ConnectLevel(NewLevel:LevelHandler = Level) -> void:
	super.ConnectLevel(NewLevel)
	if Level != null:
		NextLevelButton.pressed.connect(Level.GoNextLevel)
		if LevelEndLabel != null:
			var FormatNumber:String = "%03d" %Level.LevelSaveResource.Level
			LevelEndLabel.text = tr("LEVEL_END_DYNAMIC").format({"Number" : FormatNumber, "Name" : tr(Level.LevelSaveResource.LevelName)})
		MatchStars()

func MatchStars() -> void:
	if Level != null:
		pass
