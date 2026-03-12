extends TileMapLayer
##Handles level
class_name LevelHandler

##Back up world # if save resource doesn't exist
@export var World:int = 0
##Back up Level # if save resource doesn't exist
@export var Level:int = -1
##Resource handling World and level int, Saving, Complete status, and UID storage
@export var LevelSaveResource:LevelSaveInfo
##Background of this level
@export var Background:TileMapLayer
##Place on tile map player spawns
@export var PlayerSpawn:Vector2i
##Player 
@export var Player:PlayerHandler
##Player Scene
@export var PlayerScene:PackedScene = preload("uid://cdjrdvvpwv0w0")
##Exit to this level
@export var ExitTile:EndTileHandler
##Timer For Time star
@export var StarTimer:Timer
##Nodes that gotta be reset
@export var NodesToRest:Array[Node]
##Way to look up tiles based on tilemap position
var PositionToTiles:Dictionary[Vector2i, Observable]
##All Wall Tiles
var WallTiles:Dictionary[Vector2i, WallTileHandler]

##Call when reseting level
signal ResetingLevel
##Call when level ready
signal LevelReady
##Tells when level ends
signal LevelEnds

func _ready() -> void:
	child_entered_tree.connect(ChildEnter)
	child_exiting_tree.connect(ChildLeave)
	if LevelSaveResource != null:
		World = LevelSaveResource.World
		Level = LevelSaveResource.Level
	var GotLevelRes:LevelSaveInfo = SaveHandler.GetLevelInfo(World, Level)
	LevelSaveResource = GotLevelRes if GotLevelRes != null else LevelSaveResource
	if Background != null:
		Background.z_index = -10
	z_index = -5
	LevelSaveResource.EndLevel(false)
	if Player == null:
		var NewPlayer:PlayerHandler = PlayerScene.instantiate()
		NewPlayer.position = PlayerSpawn*32 + Vector2i(16,16)
		add_child(NewPlayer)
		Player = NewPlayer
	Player.ConnectLevel(self)
	Player.PlayerFrozen.connect(PauseLevel)
	if Player.Camera != null:
		GetLimits.call_deferred()
	if StarTimer == null:
		var NewT:Timer = Timer.new()
		add_child(NewT)
		StarTimer = NewT
	StarTimer.one_shot = true
	StarTimer.start(LevelSaveResource.TimeStarLimit)
	LevelReady.emit.call_deferred()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DEV_Reset"):
		Reset()

##Handle Child Entering tree
func ChildEnter(Child:Node) -> void:
	if Child.has_method("PrepColision"):
		Child.PrepColision()
		LevelReady.connect(Child.ToggleCollsion.bind(false))
	if Child.has_method("RESET"):
		ResetingLevel.connect(Child.RESET)
		NodesToRest.append(Child)
		if "position" in Child:
			Child.set_meta("DefaultPosition", Child.position)
		if "visible" in Child:
			Child.set_meta("DefaultVisible", Child.visible)
		if "Observed" in Child:
			Child.set_meta("DefaultObserved", Child.Observed)
	if "StartCollisionOff" in Child and Child.has_method("ToggleCollsion"):
			Child.ToggleCollsion(false, !Child.StartCollisionOff)
	if Child is Observable:
		PositionToTiles.set(local_to_map(Child.position), Child)
	if Child is EndTileHandler:
		ExitTile = Child
		Child.PlayerReachedEnd.connect(EndLevel)
	if Child is WallTileHandler:
		WallTiles.set(local_to_map(Child.position), Child)
	

##Handle child exiting tree
func ChildLeave(Child:Node) -> void:
	if Child.has_method("PrepColision"):
		if LevelReady.is_connected(Child.PrepColision):
			LevelReady.disconnect(Child.PrepColision)
	if Child.has_method("RESET"):
		if ResetingLevel.is_connected(Child.RESET):
			ResetingLevel.disconnect(Child.RESET)
			NodesToRest.erase(Child)
	if Child is EndTileHandler:
		Child.PlayerReachedEnd.disconnect(EndLevel)

##get limits of player camara
func GetLimits()->void:
	var MinLimit:Vector2 = WallTiles.keys().front()
	var MaxLimit:Vector2 = WallTiles.keys().front()
	for Wall in WallTiles:
		#min x
		if Wall.x < MinLimit.x:
			MinLimit.x = Wall.x
		#min y
		if Wall.y < MinLimit.y:
			MinLimit.y = Wall.y
		#max x
		if Wall.x > MaxLimit.x:
			MaxLimit.x = Wall.x
		#max y
		if Wall.y > MaxLimit.y:
			MaxLimit.y = Wall.y
	MinLimit = map_to_local(MinLimit) - Vector2(16,16)
	MaxLimit = map_to_local(MaxLimit) + Vector2(16,16)
	Player.Camera.limit_top = int(MinLimit.y)
	Player.Camera.limit_bottom= int(MaxLimit.y)
	Player.Camera.limit_left = int(MinLimit.x)
	Player.Camera.limit_right = int(MaxLimit.x)

##Tells when player is paused
func PauseLevel(Paused:bool) -> void:
	StarTimer.paused = Paused

##Reset Level
func Reset() -> void:
	ResetingLevel.emit()
	StarTimer.stop()
	for Reseting in NodesToRest:
		if Reseting.has_method("ToggleCollsion"):
			Reseting.ToggleCollsion(false, false)
		if Reseting.has_meta("DefaultPosition"):
			Reseting.position = Reseting.get_meta("DefaultPosition")
		if Reseting.has_meta("DefaultVisible"):
			Reseting.visible = Reseting.get_meta("DefaultVisible")
		if Reseting.has_meta("DefaultObserved"):
			Reseting.Observed = Reseting.get_meta("DefaultObserved")
		if "CanMove" in Reseting:
			Reseting.CanMove = false
	ReadyLevel.call_deferred()

##Sets Level To Ready
func ReadyLevel() -> void:
	LevelReady.emit()
	for Reseting in NodesToRest:
		if "StartCollisionOff" in Reseting and Reseting.has_method("ToggleCollsion"):
			Reseting.ToggleCollsion(false, !Reseting.StartCollisionOff)
		if "CanMove" in Reseting:
			Reseting.CanMove = true
	StarTimer.start(LevelSaveResource.TimeStarLimit)

##Run when Level Ends
func EndLevel() -> void:
	LevelSaveResource.EndLevel(true, !Player.HasDied, StarTimer.time_left > 0)
	LevelEnds.emit()

func GoNextLevel() -> void:
	get_tree().change_scene_to_file.call_deferred(LevelSaveResource.NextLevelUID)
