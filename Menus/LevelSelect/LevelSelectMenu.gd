extends MenuHandler
class_name LevelSelectMenu

@export var Worlds:Array[MadeLevelPack]
@export var WorldMenus:PackedScene

func _ready() -> void:
	super._ready()
	MakeTabs.call_deferred()

func MakeTabs() -> void:
	for World:MadeLevelPack in Worlds:
		var NewTab:WorldMenu = WorldMenus.instantiate()
		add_child(NewTab)
		NewTab.WorldInfo = World
		NewTab.MatchWorld()
		NewTab.MakeButtons.call_deferred()
