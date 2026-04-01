extends TileHanlder
class_name ButtonTileHandler

@export var PlayerInteracts:bool = false
@export var SecondSprite:AnimatedSprite2D
@export var BoxOnlyFrames:SpriteFrames
@export var BothFrames:SpriteFrames
@export var Broken:bool : set = SetButtonBroken
@export_color_no_alpha var ButtonColor:Color
var Pressed:bool = false : set=SetPress
signal PressChange(Press:bool)


@export var OnPlayer:AudioStreamPlayer2D
@export var OffPlayer:AudioStreamPlayer2D

func _ready() -> void:
	super._ready()
	SecondSprite.modulate = ButtonColor
	SecondSprite.sprite_frames = BothFrames if PlayerInteracts else BoxOnlyFrames
	z_index = -1

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
	if !Broken:
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
	PlayButtonSound()
	PressChange.emit(Pressed)
	var PlayAni:String = "Press" if Pressed else "Unpress"
	Sprite.play(PlayAni)
	SecondSprite.play(PlayAni)
	
func PlayButtonSound() -> void:
	if is_inside_tree():
		if Pressed:
			if OnPlayer.is_inside_tree():
				OnPlayer.play()
		else:
			if OffPlayer.is_inside_tree():
				OffPlayer.play()

func SetButtonBroken(Set:bool) -> void:
	Broken = Set
	if Broken:
		Sprite.play("Broken")
		SecondSprite.play("Broken")
	else:
		Pressed = Pressed
