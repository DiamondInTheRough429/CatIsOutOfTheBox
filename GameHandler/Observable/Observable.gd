extends Area2D
class_name Observable

##Possible whens for when observed
enum WhenObserved{Never, Currently, Was}

##Sprite of Observable
@export var Sprite:AnimatedSprite2D
##Current status of when observed
@export var Observed:WhenObserved = WhenObserved.Never
##Tells if starting with collision off
@export var StartCollisionOff:bool = false

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
func ToggleCollsion(Toggle:bool = true, On:bool = true, VisibilityMatch:bool = false) -> void:
	On = !monitorable if Toggle else On
	monitorable = On
	monitoring = On
	visible = On if VisibilityMatch else visible
#endregion

##Reset with level
func RESET() -> void:
	pass 
