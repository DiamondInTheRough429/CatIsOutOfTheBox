extends Observable
##Handles player
class_name PlayerHandler

##Camera that belongs to the player
@export var Camera:Camera2D
##Level Player is in
@export var Level:LevelHandler
#region Moving Var
##Posible directions for moving
enum Directions{Up, Down, Left, Right, None}
##Tells if currently moving
var CurrentlyMoving:bool = false
##Tells if can move
var CanMove:bool = true
##Tells if player can move fast
var FastMovement:bool = false
#region Wall Checking var
##Ray cast to check for walls
@export var WallCheck:RayCast2D
#endregion
#endregion

#region UI
var CurrentMenu:MenuHandler
@export var PauseScreen:InGameMenuHandler
@export var PlayerDiesScreen:InGameMenuHandler
@export var LevelEndScreen:LevelEndMenuHandler
#endregion

##Tells if has died in this level
var HasDied:bool = false

func _ready() -> void:
	z_index = 5
	CurrentMenu = PauseScreen

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
	if event.is_action_pressed("ui_cancel") and CurrentMenu == PauseScreen and PauseScreen.CurrentMenu:
		CanMove = !CanMove
		await PauseScreen.MoveInOut(!CanMove)
		PauseScreen.CurrentMenu = true
		CurrentMenu = PauseScreen
	if event.is_action_pressed("DEV_Kill"):
		KillPlayer()
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
	if CanMove and !CurrentlyMoving and !CheckWall(Direction):
		CurrentlyMoving = true
		var NewPosition:Vector2 = position
		Sprite.frame = 0
		match Direction:
			Directions.Up:
				NewPosition.y -= 32
				Sprite.play("MoveUp")
			Directions.Down:
				NewPosition.y += 32
				Sprite.play("MoveDown")
			Directions.Left:
				NewPosition.x -= 32
				Sprite.play("MoveLeft")
			Directions.Right:
				NewPosition.x += 32
				Sprite.play("MoveRight")
		var MoveTween:Tween = create_tween()
		MoveTween.tween_property(self, "position", NewPosition, .1)
		await MoveTween.finished
		CurrentlyMoving = false

##Return true if wall that direction else flase
func CheckWall(Direction:Directions) -> bool:
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
	if WallCheck.get_collider() != null:
		return true
	return false
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

func ConnectLevel(NewLevel:LevelHandler = Level) -> void:
	Level = NewLevel
	if Level != null:
		Level.LevelEnds.connect(LevelEnd)
		PauseScreen.ConnectLevel(Level)
		PlayerDiesScreen.ConnectLevel(Level)
		LevelEndScreen.ConnectLevel(Level)

##Handles Killing Payer
func KillPlayer() -> void:
	HasDied = true
	CanMove = false
	PlayerDiesScreen.MoveInOut()

func RESET() -> void:
	CurrentMenu = PauseScreen

func LevelEnd() -> void:
	CanMove = false
	LevelEndScreen.MoveInOut()
