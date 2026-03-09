extends Area2D
class_name Observer

##Tells if starting with collision off
@export var StartCollisionOff:bool = false

func _ready() -> void:
	z_index = 10

#region Collsion Functions
##Prepare Colision
func PrepColision() -> void:
	collision_layer = 0
	collision_mask = 0
	
	set_collision_layer_value(2, true) #Set Observer
	
	set_collision_mask_value(1, true) #Can See Observable

##Set if colision is on or off
func ToggleCollsion(Toggle:bool = true, On:bool = true, VisibilityMatch:bool = true) -> void:
	On = !monitorable if Toggle else On
	monitorable = On
	monitoring = On
	visible = On if VisibilityMatch else visible
#endregion

##Reset with level
func RESET() -> void:
	pass 
