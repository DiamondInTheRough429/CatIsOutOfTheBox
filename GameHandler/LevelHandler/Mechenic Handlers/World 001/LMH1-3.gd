extends LevelMachenicHandler

@export var TGHelpers:Array[LMtwogroupHelper]
@export var EndHelper:LMtwogroupHelper

func _ready() -> void:
	super._ready()
	var RanInt:int = 1
	print(RanInt+1)
	var FinalOne:LMtwogroupHelper = TGHelpers.get(RanInt)
	FinalOne.Group1 = EndHelper.Group1
	FinalOne.Group2 = EndHelper.Group2
	FinalOne.Obseerer = EndHelper.Obseerer
	EndHelper.Obseerer = null
