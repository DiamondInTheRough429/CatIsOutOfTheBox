extends TileHanlder
class_name DuplicatePlayerTile

@export var PlayerScene:PackedScene
@export var PlayerOutputOne:PlayerHandler.Directions = PlayerHandler.Directions.Up
@export var PlayerOutputTwo:PlayerHandler.Directions = PlayerHandler.Directions.Down
@export var AudioPlayer:AudioStreamPlayer2D
@export var DupCamera:Camera2D

func _ready() -> void:
	super._ready()
	z_index = 6
	DupCamera.enabled = false

func PlayerEnter(_Player:PlayerHandler) -> void:
	if _Player.DuplicatedPlayer == null:
		Duplicate(_Player)

func Duplicate(Player:PlayerHandler) -> void:
	var DupedPlayer:PlayerHandler = PlayerScene.instantiate()
	Player.get_parent().add_child.call_deferred(DupedPlayer)
	DupedPlayer.ConnectLevel(Player.Level)
	DupedPlayer.Level.GetLimits(DupedPlayer)
	DupedPlayer.HasDied = Player.HasDied
	Player.DuplicatedPlayer = DupedPlayer
	DupedPlayer.DuplicatedPlayer = Player
	DupedPlayer.CurrentPlayer = false
	Player.CurrentPlayer = false
	
	DupCamera.limit_bottom = Player.Camera.limit_bottom
	DupCamera.limit_left = Player.Camera.limit_left 
	DupCamera.limit_right = Player.Camera.limit_right
	DupCamera.limit_top = Player.Camera.limit_top
	DupCamera.enabled = true
	
	DupedPlayer.global_position = global_position
	if AudioPlayer != null:
		AudioPlayer.play()
		await AudioPlayer.finished
	DupedPlayer.set_meta("DefaultPosition", Player.get_meta("DefaultPosition"))
	DupCamera.enabled = false
	Player.CurrentPlayer = true
	Sprite.play("Off")
	set_collision_layer_value(4, true)
	Player.Move(PlayerOutputOne)
	DupedPlayer.Move(PlayerOutputTwo)
	if !Player.Died.is_connected(PlayerDied):
		Player.Died.connect(PlayerDied)
	if !DupedPlayer.Died.is_connected(PlayerDied):
		DupedPlayer.Died.connect(PlayerDied)

func PlayerDied() -> void:
	Sprite.play("On")
	set_collision_layer_value(4, false)

func RESET() -> void:
	super.RESET()
	set_collision_layer_value(4, false)
