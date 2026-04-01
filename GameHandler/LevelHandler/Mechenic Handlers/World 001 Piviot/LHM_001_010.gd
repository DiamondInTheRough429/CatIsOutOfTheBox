extends LevelMachenicHandler

@export_category("PoisonRiseing")
@export var PosionLevel:PackedScene
@export var TimeTillNext:Timer
var PosionLayers:Dictionary[int, Node]

@export_category("Section 1")

@export_category("Section 2")
@export var S2Button:ButtonTileHandler
@export var S2Gate:GateTile

@export_category("Section 3")
@export var S3RButton:ButtonTileHandler
@export var S3FButton:ButtonTileHandler
@export var S3Gate:GateTile

@export_category("Section 4")
@export var S4Button:ButtonTileHandler
@export var S4Gate:GateTile

@export_category("Section 5")
@export var S5BButton:ButtonTileHandler
@export var S5PButton:ButtonTileHandler
@export var S5Gate1:GateTile
@export var S5Gate2:GateTile

@export_category("Section 6")
@export var ClawL:ClawTile
@export var ClawR:ClawTile
@export var Obserever6:Observer
@export var GroupL:TileGroup
@export var GroupR:TileGroup

func _ready() -> void:
	super._ready()
	S2Button.PressChange.connect(S2BC)
	S3FButton.PressChange.connect(S3BC)
	S3RButton.PressChange.connect(S3BC)
	S4Button.PressChange.connect(S4BC)
	S5BButton.PressChange.connect(S5BC)
	S5PButton.PressChange.connect(S5BC)
	ClawL.PlayerEntered.connect(S6.bind(true))
	ClawR.PlayerEntered.connect(S6.bind(false))
	TimeTillNext.timeout.connect(RaiseLevel)

func RaiseLevel() -> void:
	var NewPosion:Node2D = PosionLevel.instantiate()
	Level.add_child(NewPosion)
	NewPosion.position.y = (PosionLayers.size())*-32
	PosionLayers.set(PosionLayers.size(), NewPosion)
	PosionLayers.size()
	TimeTillNext.start(7)

func S2BC(Press:bool) -> void:
	S2Gate.Open = Press

func S3BC(_PressHold) -> void:
	if S3FButton.Pressed and S3RButton.Pressed:
		S3Gate.Open = true
	elif S3Gate.Open != false:
		S3Gate.Open = false

func S4BC(Press:bool) -> void:
	S4Gate.Open = Press

func S5BC(_PressHold) -> void:
	if S5BButton.Pressed and S5PButton.Pressed:
		S5Gate1.Open = true
		S5BButton.Broken = true
		S5PButton.Broken = true
	elif S5Gate1.Open != false:
		S5Gate1.Open = false
	S5Gate2.Open = S5Gate1.Open

func S6(_PlayerHolder:PlayerHandler, Left:bool) -> void:
	Obserever6.ToggleCollsion(false)
	if Left:
		GroupR.ToggleGroupCollsion(false, false)
		ClawR.ToggleCollsion(false, false)
	else:
		GroupL.ToggleGroupCollsion(false, false)
		ClawL.ToggleCollsion(false, false)

func Reset() -> void:
	for i in PosionLayers:
		var Lay:Node2D = PosionLayers.get(i)
		Lay.queue_free()
	PosionLayers.clear()
	TimeTillNext.start(7)
