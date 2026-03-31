extends LevelMachenicHandler

@export var Button1:ButtonTileHandler
@export var Button2:ButtonTileHandler
@export var Gate:GateTile

func _ready() -> void:
	super._ready()
	Button1.PressChange.connect(ButtonsUpdated)
	Button2.PressChange.connect(ButtonsUpdated)

func ButtonsUpdated(_PressHold:bool) -> void:
	if Button1.Pressed == true and Button2.Pressed == true:
		Gate.Open = true
	else:
		Gate.Open = false
