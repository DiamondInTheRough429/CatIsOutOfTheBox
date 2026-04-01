extends LevelMachenicHandler

@export var TopPlayerGate:GateTile
@export var BottomPlayerGate:GateTile
@export var EnterGate:GateTile
@export var ExitGate:GateTile

@export var PrepPlayerButton:ButtonTileHandler
@export var LetOutButton:ButtonTileHandler
@export var Puzzel1Button:ButtonTileHandler
@export var Puzzel2Button:ButtonTileHandler
@export var Puzzel3Button:ButtonTileHandler

func _ready() -> void:
	super._ready()
	PrepPlayerButton.PressChange.connect(PrepPlayerPush)
	LetOutButton.PressChange.connect(LetOutPush)
	Puzzel1Button.PressChange.connect(CalcEndPush)
	Puzzel2Button.PressChange.connect(CalcEndPush)
	Puzzel3Button.PressChange.connect(CalcEndPush)

func PrepPlayerPush(_Press:bool) -> void:
	if _Press:
		TopPlayerGate.Open = true
		BottomPlayerGate.Open = false

func LetOutPush(_Press:bool) -> void:
	EnterGate.Open = _Press

func CalcEndPush(_Press:bool) -> void:
	if Puzzel1Button.Pressed and Puzzel2Button.Pressed and Puzzel3Button.Pressed:
		ExitGate.Open = true
	else:
		ExitGate.Open = false
