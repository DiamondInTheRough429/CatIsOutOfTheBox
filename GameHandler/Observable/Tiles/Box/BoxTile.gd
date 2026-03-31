extends TileHanlder
class_name BoxTile

##Posible directions for moving
enum Directions{Up, Down, Left, Right, None}
@export var OnTracks:bool = true
@export var CheckRay:RayCast2D

@export var PushPlayer:AudioStreamPlayer2D

func _ready() -> void:
	super._ready()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DEV_BoxPush"):
		Move(Directions.Up)

func PrepColision() -> void:
	#regular
	collision_layer = 0
	collision_mask = 0
	
	set_collision_layer_value(1, true) #Set Observable
	set_collision_layer_value(5, true) #Set Box
	
	set_collision_mask_value(2, true) #Can See Observer
	
	#Check ray
	if CheckRay != null:
		CheckRay.collision_mask = 0
		CheckRay.collide_with_areas = true
		CheckRay.set_collision_mask_value(4, true)
		CheckRay.set_collision_mask_value(7, true)

##Returns true if can move that direction
func CheckMove(Direct:Directions) -> bool:
	match Direct:
		Directions.Up:
			CheckRay.target_position = Vector2(0,-32)
		Directions.Down:
			CheckRay.target_position = Vector2(0,32)
		Directions.Left:
			CheckRay.target_position = Vector2(-32,0)
		Directions.Right:
			CheckRay.target_position = Vector2(32,0)
	CheckRay.force_raycast_update()
	var Colide:Node = CheckRay.get_collider()
	if Colide != null:
		return false if Colide.get_collision_layer_value(4) else true
	return true if !OnTracks else false

func Move(Direct:Directions) -> void:
	var MoveTween:Tween = create_tween()
	var NewPosition:Vector2 = position
	match Direct:
		Directions.Up:
			NewPosition.y -= 32
		Directions.Down:
			NewPosition.y += 32
		Directions.Left:
			NewPosition.x -= 32
		Directions.Right:
			NewPosition.x += 32
	MoveTween.tween_property(self, "position", NewPosition, 0.3)
	PushPlayer.play()
