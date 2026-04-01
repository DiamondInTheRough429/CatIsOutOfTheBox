extends LevelMachenicHandler

@export var MasterButton1:ButtonTileHandler
@export var MasterButton2:ButtonTileHandler
@export var ExitButton:ButtonTileHandler

@export var ExitGate:GateTile
@export var Button1Gates:Array[GateTile]
@export var Button2Gates:Array[GateTile]

func _ready() -> void:
	super._ready()
	MasterButton1.PressChange.connect(M1Press)
	MasterButton2.PressChange.connect(M2Press)
	ExitButton.PressChange.connect(ExitPress)

func M1Press(Press:bool) -> void:
	for B in Button1Gates:
		B.Open = Press

func M2Press(Press:bool) -> void:
	for B in Button2Gates:
		B.Open = Press

func ExitPress(Press:bool) -> void:
	ExitGate.Open = Press
