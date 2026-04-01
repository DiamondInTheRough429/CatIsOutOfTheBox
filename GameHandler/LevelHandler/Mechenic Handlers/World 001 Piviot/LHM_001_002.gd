extends LevelMachenicHandler

@export_category("Stop backtrack")
@export var TopGate:GateTile
@export var TopButton:ButtonTileHandler
@export var BottomGate:GateTile
@export var BottomButton:ButtonTileHandler

@export_category("Track Buttons")
@export var LeftButtonEnd:ButtonTileHandler
@export var LeftButton1:ButtonTileHandler
@export var LeftButton2:ButtonTileHandler

@export var RightButtonEnd:ButtonTileHandler
@export var RightButton1:ButtonTileHandler
@export var RightButton2:ButtonTileHandler

@export_category("Gates")
@export var EndGate:GateTile
@export var LeftEndGate:GateTile
@export var LeftGate1:GateTile
@export var LeftGate2:GateTile
@export var RightGate1:GateTile
@export var RightGate2:GateTile

func _ready() -> void:
	super._ready()
	TopButton.PressChange.connect(HandleNoBackTrack.bind(TopButton, TopGate))
	BottomButton.PressChange.connect(HandleNoBackTrack.bind(BottomButton, BottomGate))
	LeftButtonEnd.PressChange.connect(HandleEndGate)
	RightButtonEnd.PressChange.connect(HandleLeftGates)
	RightButton1.PressChange.connect(HandleLeftGates)
	RightButton2.PressChange.connect(HandleLeftGates)
	LeftButton1.PressChange.connect(HandleRightGates)
	LeftButton2.PressChange.connect(HandleRightGates)

func HandleNoBackTrack(_PressHold:bool, But:ButtonTileHandler, Gate:GateTile) -> void:
	if _PressHold:
		But.Broken = true
		Gate.Open = false

func HandleLeftGates(_PressHold:bool) -> void:
	var GatesShouldOpen:bool = false
	var LEndOpen:bool = false
	if RightButtonEnd.Pressed:
		GatesShouldOpen = true
	if RightButton1.Pressed and RightButton2.PressChange:
		GatesShouldOpen = true
		LEndOpen = true
		
	if LeftEndGate.Open != LEndOpen:
		LeftEndGate.Open = LEndOpen
	if LeftGate1.Open != GatesShouldOpen:
		LeftGate1.Open = GatesShouldOpen
		LeftGate2.Open = GatesShouldOpen

func HandleRightGates(_PressHold:bool)->void:
	var GatesShouldOpen:bool = false
	if LeftButton1.Pressed and LeftButton2.PressChange:
		GatesShouldOpen = true
	
	RightGate1.Open = GatesShouldOpen
	RightGate2.Open = GatesShouldOpen

func HandleEndGate(Press:bool) -> void:
	EndGate.Open = Press
