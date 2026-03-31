extends LevelMachenicHandler

@export var TGHelpers:Array[LMtwogroupHelper]
@export var EndHelper:LMtwogroupHelper

func _ready() -> void:
	super._ready()
	var RanInt:int = randi_range(0,6)
	var FinalOne:LMtwogroupHelper = TGHelpers.get(RanInt)
	if FinalOne != EndHelper:
		FinalOne.Group1 = EndHelper.Group1
		FinalOne.Group2 = EndHelper.Group2
		FinalOne.Obseerer = EndHelper.Obseerer
		EndHelper.Obseerer = null
