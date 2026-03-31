extends LevelMachenicHandler

@export var TopButton:ButtonTileHandler
@export var MidButton:ButtonTileHandler
@export var ButButton:ButtonTileHandler

@export var TopRightGate:GateTile
@export var BottomRightGrate:GateTile
@export var EndGate:GateTile

var TotalPushed:int = 0

func _ready() -> void:
	TopButton.PressChange.connect(HandleAmount)
	MidButton.PressChange.connect(HandleAmount)
	ButButton.PressChange.connect(HandleButButton)

func HandleButButton(Pressed:bool) -> void:
	ButButton.Broken = true
	HandleAmount(Pressed)

func HandleAmount(_pressHold:bool) -> void:
	var NewTotal:int = 0
	if TopButton.Pressed:
		NewTotal += 1
	if MidButton.Pressed:
		NewTotal += 1
	if ButButton.Pressed:
		NewTotal += 1
	
	TotalPushed = NewTotal
	
	match TotalPushed:
		0:
			TopRightGate.Open = true
			BottomRightGrate.Open = false
			EndGate.Open = false
		1:
			TopRightGate.Open = false
			BottomRightGrate.Open = true
			EndGate.Open = true
		2:
			TopRightGate.Open = true
			BottomRightGrate.Open = false
			EndGate.Open = false
		3:
			TopRightGate.Open = false
			BottomRightGrate.Open = true
			EndGate.Open = true

func Reset() -> void:
	super.Reset()
	TotalPushed = 0
