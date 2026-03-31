extends LevelMachenicHandler

@export var TopGroupHelp:LMtwogroupHelper
@export var BottomGroupHelp:LMtwogroupHelper

@export var ScratchMidPos:Vector2i
var ScratchMid:TileHanlder

func _ready() -> void:
	var FirstAvalible = TopGroupHelp if randi_range(0,1) == 0 else BottomGroupHelp
	FirstAvalible.ScratchTilePos = ScratchMidPos
