extends TileHanlder
class_name GateTile

@export var Open:bool : set = SetOpen

func SetOpen(Set:bool) -> void:
	print(Set)
	Open = Set
	set_collision_layer_value(4, !Set)
	if Sprite != null:
		var Ani:String = "Open" if Set else "Close"
		if Sprite.sprite_frames.has_animation(Ani):
			Sprite.play(Ani)
