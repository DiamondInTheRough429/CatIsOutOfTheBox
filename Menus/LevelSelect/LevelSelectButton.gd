extends Button
class_name LevelSelectButton

@export var LevelLabel:Label
@export var CompleteStar:AnimatedSprite2D
@export var DeathlessCompleteStar:AnimatedSprite2D
@export var TimeCompleteStar:AnimatedSprite2D
var Info:LevelInfo
var SaveInfo:LevelSaveInfo

func _ready() -> void:
	pressed.connect(LoadLevel)

func SetInfo(NewInfo:LevelInfo) -> void:
	Info = NewInfo
	if Info != null:
		LevelLabel.text = Info.GetName()
		LoadSaveInfo()

func LoadSaveInfo() -> void:
	SaveInfo = SaveHandler.GetLevelInfo(Info.World, Info.Level)
	if SaveInfo != null:
		if SaveInfo.Complete:
			CompleteStar.play("Complete")
		if SaveInfo.CompleteDeathless:
			DeathlessCompleteStar.play("Complete")
		if SaveInfo.CompleteInTime:
			TimeCompleteStar.play("Complete")

func LoadLevel() -> void:
	if Info != null:
		if Info.LevelUID != null:
			get_tree().change_scene_to_file.call_deferred(Info.LevelUID)
