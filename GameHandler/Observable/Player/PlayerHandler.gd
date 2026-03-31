extends Observable
##Handles player
class_name PlayerHandler

##Camera that belongs to the player
@export var Camera:Camera2D
##Level Player is in
@export var Level:LevelHandler
#region Moving Var
#Duration of movement (orginal value was 0.1 if you wanna change it back)
var MovementDuration:float = 0.3
#String that holds direction ["up", "side", "down"] for idle
var IdleAnimationDirection:String = "Side"
##Posible directions for moving
enum Directions{Up, Down, Left, Right, None}
##Tells if currently moving
var CurrentlyMoving:bool = false
##Tells if can move
var CanMove:bool = true : set=CanMoveSetter
##Emit when play cant move
signal PlayerFrozen(Frozen:bool)
##Tells if player can move fast
var FastMovement:bool = false
#region Wall Checking var
enum WallCheckPossible{None, Wall, Box}
##Ray cast to check for walls
@export var WallCheck:RayCast2D
#endregion
#endregion

#region Duplication
@export var CurrentOutlineMat:Material
@export var CurrentObservedMat:Material
var StoredObservedMat:Material
var CurrentPlayer:bool = true : set = SetCurrent
var DuplicatedPlayer:PlayerHandler
#endregion

#region UI
var CurrentMenu:MenuHandler
@export var PauseScreen:InGameMenuHandler
@export var PlayerDiesScreen:InGameMenuHandler
@export var LevelEndScreen:LevelEndMenuHandler
#endregion

#region Cosmetic
@export var CosmeticToSprite:Dictionary[SettingsHandler.Cosmetics, SpriteFrames]
#endregion

##Tells if has died in this level
var HasDied:bool = false

signal Died

func _ready() -> void:
	z_index = 5
	CurrentMenu = PauseScreen
	StoredObservedMat = ObservedMat
	if DuplicatedPlayer != null:
		GroupMat = CurrentOutlineMat
	if CosmeticToSprite.has(SettingsHandler.CurrentCosmetic):
		var Frames:SpriteFrames = CosmeticToSprite.get(SettingsHandler.CurrentCosmetic)
		Sprite.sprite_frames = Frames if Frames != null else Sprite.sprite_frames

func _physics_process(_delta: float) -> void:
	if FastMovement == true:
		var inputDir:Vector2 = Input.get_vector("PM_Left", "PM_Right", "PM_Up", "PM_Down").normalized()
		var MoveDir:Directions = Directions.None
		if abs(inputDir.y) >= abs(inputDir.x):
			if abs(inputDir.y) >= .5:
				MoveDir = Directions.Down if inputDir.y >= 0 else Directions.Up
		else:
			if abs(inputDir.x) >= .5:
				MoveDir = Directions.Right if inputDir.x >= 0 else Directions.Left
		if MoveDir != Directions.None:
			Move(MoveDir)

#region Input functions
func _input(event: InputEvent) -> void:
	if CurrentPlayer:
		if event.is_action_pressed("ui_cancel") and CurrentMenu == PauseScreen and PauseScreen.CurrentMenu:
			CanMove = !CanMove
			await PauseScreen.MoveInOut(!CanMove)
			PauseScreen.CurrentMenu = true
			CurrentMenu = PauseScreen
		if event.is_action_pressed("DEV_Kill"):
			KillPlayer()
		if event.is_action_pressed("PL_Switch"):
			SwitchPlayers.call_deferred()
		#region Moving Input
		if event.is_action_pressed("PM_Up") or event.is_action("PM_Up") and event.is_echo():
			Move(Directions.Up)
		if event.is_action_pressed("PM_Down")  or event.is_action("PM_Down") and event.is_echo():
			Move(Directions.Down)
		if event.is_action_pressed("PM_Left") or event.is_action("PM_Left") and event.is_echo():
			Move(Directions.Left)
		if event.is_action_pressed("PM_Right") or event.is_action("PM_Right") and event.is_echo():
			Move(Directions.Right)
		#endregion

##Move player
func Move(Direction:Directions) -> void:
	var CheckedWall:WallCheckPossible = CheckWall(Direction)
	if CanMove and !CurrentlyMoving and CheckedWall != WallCheckPossible.Wall:
		if CheckedWall == WallCheckPossible.Box:
			var Collided:BoxTile = WallCheck.get_collider()
			var Test:int = Direction
			if !Collided.CheckMove(Test):
				return
			else:
				Collided.Move(Test)
		CurrentlyMoving = true
		var NewPosition:Vector2 = position
		Sprite.frame = 0
		#reset the flip, since 3/4 animations do not need flip
		Sprite.set_flip_h(false)
		match Direction:
			Directions.Up:
				NewPosition.y -= 32
				IdleAnimationDirection = "Down"
			Directions.Down:
				NewPosition.y += 32
				IdleAnimationDirection = "Down"
			Directions.Left:
				NewPosition.x -= 32
				#flip and play move right
				Sprite.set_flip_h(true)
				IdleAnimationDirection = "Side"
			Directions.Right:
				NewPosition.x += 32
				IdleAnimationDirection = "Side"
		var MoveTween:Tween = create_tween()
		PlayDirectionalAnimation("Move")
		MoveTween.tween_property(self, "position", NewPosition, MovementDuration)
		await MoveTween.finished
		CurrentlyMoving = false
		
		#only play idle if the player is in a state where they can move
		if CanMove:
			PlayDirectionalAnimation("Idle")

##Return true if wall that direction else flase
func CheckWall(Direction:Directions) -> WallCheckPossible:
	match Direction:
		Directions.Up:
			WallCheck.target_position = Vector2(0,-32)
		Directions.Down:
			WallCheck.target_position = Vector2(0,32)
		Directions.Left:
			WallCheck.target_position = Vector2(-32,0)
		Directions.Right:
			WallCheck.target_position = Vector2(32,0)
	WallCheck.force_raycast_update()
	var Collided:Area2D = WallCheck.get_collider()
	if Collided != null:
		return WallCheckPossible.Wall if Collided.get_collision_layer_value(4) else WallCheckPossible.Box
	return WallCheckPossible.None
#endregion

func PrepColision() -> void:
	#regular
	collision_layer = 0
	collision_mask = 0
	
	set_collision_layer_value(1, true) #Set Observable
	set_collision_layer_value(3, true) #Set Player
	
	set_collision_mask_value(2, true) #Can See Observer
	
	#wall check
	if WallCheck != null:
		WallCheck.collision_mask = 0
		WallCheck.collide_with_areas = true
		WallCheck.set_collision_mask_value(4, true)
		WallCheck.set_collision_mask_value(5, true)

func ConnectLevel(NewLevel:LevelHandler = Level) -> void:
	Level = NewLevel
	if Level != null:
		Level.LevelEnds.connect(LevelEnd)
		PauseScreen.ConnectLevel(Level)
		PlayerDiesScreen.ConnectLevel(Level)
		LevelEndScreen.ConnectLevel(Level)

func CanMoveSetter(Set:bool) -> void:
	CanMove = Set
	PlayerFrozen.emit(!CanMove)

func SwitchPlayers() -> void:
	if CurrentPlayer and DuplicatedPlayer != null:
		CurrentPlayer = false
		DuplicatedPlayer.CurrentPlayer = true

func SetCurrent(Set:bool) -> void:
	CurrentPlayer = Set
	Camera.enabled = Set
	if CurrentPlayer:
		Level.Player = self
	if CurrentPlayer and DuplicatedPlayer != null:
		if CurrentOutlineMat != null and Sprite != null:
			ObservedMat = CurrentObservedMat
			GroupMat = CurrentOutlineMat
			Sprite.material = ObservedMat if Observed == WhenObserved.Currently else CurrentOutlineMat
	else:
		if StoredObservedMat != null and Sprite != null:
			ObservedMat = StoredObservedMat
			GroupMat = null
			Sprite.material = ObservedMat if Observed == WhenObserved.Currently else null

##Handles Killing Payer
func KillPlayer() -> void:
	CanMove = false
	Sprite.play("Dies")
	await Sprite.animation_finished
	Died.emit()
	if DuplicatedPlayer != null:
		CurrentPlayer = false
		DuplicatedPlayer.DuplicatedPlayer = null
		DuplicatedPlayer.CurrentPlayer = true
		queue_free.call_deferred()
	else:
		HasDied = true
		PlayerDiesScreen.MoveInOut()

func PlayDirectionalAnimation(animationName:String) -> void:
	Sprite.play(animationName + IdleAnimationDirection)

func AnimatePlayer(Ani:String, Freeze:bool = true) -> bool:
	if Sprite.sprite_frames.has_animation(Ani):
		Sprite.play(Ani)
		if Freeze:
			CanMove = false
			await Sprite.animation_finished
			#start playing idle after the scratch animation is done
			PlayDirectionalAnimation("Idle")
			CanMove = true
		return true
	return false

func RESET() -> void:
	PlayDirectionalAnimation("Idle")
	CurrentMenu = PauseScreen
	PauseScreen.CurrentMenu = true

func LevelEnd() -> void:
	CanMove = false
	LevelEndScreen.MoveInOut()
