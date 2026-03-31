extends Node
class_name LMtwogroupHelper

@export var LevelMachenic:LevelMachenicHandler
@export var Group1:TileGroup
@export var Group2:TileGroup
@export var ScratchTilePos:Vector2i
var Scratch:TileHanlder
@export var Obseerer:Observer
var Determained:bool = false

signal Changed

func _ready() -> void:
	if  LevelMachenic.Level != null:
		LevelMachenic.Level.ResetingLevel.connect(Reset)
		LevelMachenic.Level.LevelReady.connect(LevelReady)

func Reset() -> void:
	Determained = false

func LevelReady() -> void:
	if !Group1.GroupChanged.is_connected(GroupChange):
		Group1.GroupChanged.connect(GroupChange)
	if !Group2.GroupChanged.is_connected(GroupChange):
		Group2.GroupChanged.connect(GroupChange)
	Scratch = LevelMachenic.Level.PositionToTiles.get(ScratchTilePos)
	if Scratch != null:
		if !Scratch.PlayerEntered.is_connected(StartObserving):
			Scratch.PlayerEntered.connect(StartObserving)

func StartObserving(_player:PlayerHandler) -> void:
	Obseerer.ToggleCollsion()

func GroupChange(NewState:Observable.WhenObserved) -> void:
	if !Determained and NewState == Observable.WhenObserved.Currently:
		Determained = true
		var UnLuckyGroup:TileGroup = Group1 if randi_range(0,1) == 1 else Group2
		var LuckyGroup:TileGroup = Group1 if UnLuckyGroup == Group2 else Group2
		if LuckyGroup.Group.front().monitoring == UnLuckyGroup.Group.front().monitoring:
			UnLuckyGroup.ToggleGroupCollsion(false, false)
		Changed.emit()
