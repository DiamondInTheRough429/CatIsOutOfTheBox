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
		Level.LevelEnds.connect(MatchStars)
		NextLevelButton.pressed.connect(Level.GoNextLevel)
		if LevelEndLabel != null:
			var FormatNumber:String = "%03d" %Level.LevelSaveResource.Level
			LevelEndLabel.text = tr("LEVEL_END_DYNAMIC").format({"Number" : FormatNumber, "Name" : tr(Level.LevelInfoResource.GetName())})
		MatchStars()

func MatchStars() -> void:
	if Level != null:
		var CompletePlay:String = "Complete" if Level.LevelSaveResource.Complete else "default"
		CompleteStar.play(CompletePlay)
		var DeathlessPlay:String = "Complete" if Level.LevelSaveResource.CompleteDeathless else "default"
		DeathlessStar.play(DeathlessPlay)
		var TimePlay:String = "Complete" if Level.LevelSaveResource.CompleteInTime else "default"
		TimeStar.play(TimePlay)
