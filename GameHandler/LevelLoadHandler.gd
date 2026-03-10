extends Node
##Used to handle loading and Reseting of level
class_name LeveloadHandler_Script

##Call when reseting level
signal ResetingLevel
##Call when level ready
signal LevelReady

##Nodes that gotta be reset
var NodesToRest:Array[Node]

func _ready() -> void:
	child_entered_tree.connect(ChildEnter)
	child_exiting_tree.connect(ChildLeave)

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
			Child.ToggleCollision(false, !Child.StartCollisionOff)

##Handle child exiting tree
func ChildLeave(Child:Node) -> void:
	if Child.has_method("PrepColision"):
		if LevelReady.is_connected(Child.PrepColision):
			LevelReady.disconnect(Child.PrepColision)
	if Child.has_method("RESET"):
		if ResetingLevel.is_connected(Child.RESET):
			ResetingLevel.disconnect(Child.RESET)
			NodesToRest.erase(Child)

##Reset Level
func Reset() -> void:
	ResetingLevel.emit()
	for Reseting in NodesToRest:
		if Reseting.has_method("ToggleCollsion"):
			Reseting.ToggleCollision(false, false)
		if Reseting.has_meta("DefaultPosition"):
			Reseting.position = Reseting.get_meta("DefaultPosition")
		if Reseting.has_meta("DefaultVisible"):
			Reseting.visible = Reseting.get_meta("DefaultVisible")
		if "CanMove" in Reseting:
			Reseting.CanMove = false

##Sets Level To Ready
func ReadyLevel() -> void:
	LevelReady.emit()
	for Reseting in NodesToRest:
		if "StartCollisionOff" in Reseting and Reseting.has_method("ToggleCollsion"):
			Reseting.ToggleCollision(false, !Reseting.StartCollisionOff)
		if "CanMove" in Reseting:
			Reseting.CanMove = true
