extends TileHanlder
class_name DuplicatePlayerTile

@export var PlayerOutputOne:Vector2
@export var PlayerOutputTwo:Vector2

func PlayerEnter(_Player:PlayerHandler) -> void:
	if _Player.DuplicatedPlayer == null:
		Duplicate(_Player)

func Duplicate(Player:PlayerHandler) -> void:
	var DupedPlayer:PlayerHandler = Player.duplicate()
	Player.get_parent().add_child(DupedPlayer)
	Player.DuplicatedPlayer = DupedPlayer
	DupedPlayer.DuplicatedPlayer = Player
	DupedPlayer.CurrentPlayer = false
