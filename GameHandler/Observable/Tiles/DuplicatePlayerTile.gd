extends TileHanlder
class_name DuplicatePlayerTile

@export var PlayerOutputOne:PlayerHandler.Directions = PlayerHandler.Directions.Up
@export var PlayerOutputTwo:PlayerHandler.Directions = PlayerHandler.Directions.Down
@export var AudioPlayer:AudioStreamPlayer2D

func PlayerEnter(_Player:PlayerHandler) -> void:
	if _Player.DuplicatedPlayer == null:
		Duplicate(_Player)

func Duplicate(Player:PlayerHandler) -> void:
	var DupedPlayer:PlayerHandler = Player.duplicate()
	Player.get_parent().add_child.call_deferred(DupedPlayer)
	Player.DuplicatedPlayer = DupedPlayer
	DupedPlayer.DuplicatedPlayer = Player
	DupedPlayer.CurrentPlayer = false
	Player.CurrentPlayer = false
	DupedPlayer.global_position = global_position
	if AudioPlayer != null:
		AudioPlayer.play()
		await AudioPlayer.finished
	DupedPlayer.set_meta("DefaultPosition", Player.get_meta("DefaultPosition"))
	Player.CurrentPlayer = true
	Player.Move(PlayerOutputOne)
	DupedPlayer.Move(PlayerOutputTwo)
