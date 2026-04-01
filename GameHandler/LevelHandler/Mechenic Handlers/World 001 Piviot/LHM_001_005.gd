extends LevelMachenicHandler

@export var RightInButtons:Array[ButtonTileHandler]
@export var LeftOuterButtons:Dictionary[GateTile, ButtonTileHandler]
@export var LeftGates:Array[GateTile]
@export var RightGates:Array[GateTile]

func _ready() -> void:
	super._ready()
	for B:ButtonTileHandler in RightInButtons:
		var RanGate:GateTile = LeftGates.pick_random()
		LeftGates.erase(RanGate)
		B.PressChange.connect(RightInner.bind(RanGate))
	for G in LeftOuterButtons:
		var B:ButtonTileHandler = LeftOuterButtons.get(G)
		var RanGate:GateTile = RightGates.pick_random()
		RightGates.erase(RanGate)
		B.PressChange.connect(LeftOuter.bind(RanGate, G))

func RightInner(Press:bool, Gate:GateTile) -> void:
	Gate.Open = Press

func LeftOuter(Press:bool, Gate:GateTile, EnterGate:GateTile) -> void:
	Gate.Open = Press
	EnterGate.Open = Press
	if Press:
		LeftOuterButtons.get(EnterGate).Broken = true
