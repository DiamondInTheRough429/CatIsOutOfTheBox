extends TileMapLayer
class_name LevelHandler

##Resource handling World and level int, Saving, Complete status, and UID storage
@export var LevelSaveResource:LevelSaveInfo
##Background of this level
@export var Background:TileMapLayer
@export var PlayerSpawn:Vector2i
@export var Player:PlayerHandler
@export var PlayerScene:PackedScene = preload("uid://cdjrdvvpwv0w0")

func _ready() -> void:
	if Background != null:
		Background.z_index = -10
	z_index = -5
	LevelSaveResource.EndLevel(false)
	if Player == null:
		var NewPlayer:PlayerHandler = PlayerScene.instantiate()
		NewPlayer.position = PlayerSpawn*32 + Vector2i(16,16)
		add_child(NewPlayer)
