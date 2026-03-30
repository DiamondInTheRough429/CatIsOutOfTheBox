extends Area2D
class_name Observable

##Possible whens for when observed
enum WhenObserved{Never, Currently, Was}

##Sprite of Observable
@export var Sprite:AnimatedSprite2D
##Tells if starting with collision off
@export var StartCollisionOff:bool = false
##Current status of when observed
@export var Observed:WhenObserved = WhenObserved.Never : 
	set(value):
		Observed = value
		ObservedChanged.emit(Observed)
		ObservedVisualUpdate()
@export var GroupMat:ShaderMaterial
##Material Used for when observed
@export var ObservedMat:ShaderMaterial

signal ObservedChanged(Change:WhenObserved)

#region Collsion Functions
##Prepare Colision
func PrepColision() -> void:
	collision_layer = 0
	collision_mask = 0
	
	set_collision_layer_value(1, true) #Set Observable
	
	set_collision_mask_value(2, true) #Can See Observer
	set_collision_mask_value(3, true) #Can See Player

##Set if colision is on or off
func ToggleCollsion(Toggle:bool = true, On:bool = true, VisibilityMatch:bool = true) -> void:
	On = !monitorable if Toggle else On
	set_deferred("monitorable", On)
	monitoring = On
	visible = On if VisibilityMatch else visible
#endregion

##Update visuals of Observable
func ObservedVisualUpdate() -> void:
	match Observed:
		WhenObserved.Never:
			if Sprite != null:
				if Sprite.sprite_frames.has_animation("default"):
					Sprite.play("default")
				Sprite.material = GroupMat
		WhenObserved.Currently:
			if Sprite != null:
				if Sprite.sprite_frames.has_animation("Observered"):
					Sprite.play("Observered")
				if ObservedMat != null:
					Sprite.material = ObservedMat
		WhenObserved.Was:
			if Sprite != null:
				if Sprite.sprite_frames.has_animation("WasObservered"):
					Sprite.play("WasObservered")
				Sprite.material = GroupMat

##Reset with level
func RESET() -> void:
	pass 
