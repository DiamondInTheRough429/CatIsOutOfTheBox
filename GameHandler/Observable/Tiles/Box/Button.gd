extends TileHanlder
class_name ButtonTileHandler

@export var PlayerInteracts:bool = false
var Pressed:bool = false : set=SetPress
signal PressChange(Press:bool)

func PrepColision() -> void:
	super.PrepColision()
	set_collision_mask_value(5, true)
	set_collision_layer_value(6, true)

func AreaEnter(Area:Area2D) -> void:
	super.AreaEnter(Area)
	if Area is BoxTile:
		UpdatePressed()

func AreaExit(Area:Area2D) -> void:
	super.AreaExit(Area)
	if Area is BoxTile:
		UpdatePressed()

func PlayerEnter(_Player:PlayerHandler) -> void:
	if PlayerInteracts:
		UpdatePressed()

func PlayerExit(_Player:PlayerHandler) -> void:
	if PlayerInteracts:
		UpdatePressed()

func UpdatePressed() -> void:
	var HeldDown:bool = false
	if monitoring:
		for Area in get_overlapping_areas():
			#player
			if Area.get_collision_layer_value(3):
				if PlayerInteracts:
					HeldDown = true
			#Box
			if Area.get_collision_layer_value(5):
				HeldDown = true
		
		if Pressed != HeldDown:
			Pressed = HeldDown

func SetPress(Set:bool) -> void:
	Pressed = Set
	PressChange.emit(Pressed)
	var PlayAni:String = "Press" if Pressed else "Unpress"
	Sprite.play(PlayAni)
