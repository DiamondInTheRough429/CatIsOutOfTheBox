extends Node
class_name TileGroup

@export var Level:LevelHandler
@export var GroupPoss:Array[Vector2i]
@export var GroupShader:ShaderMaterial
@export var GroupObserveredShader:ShaderMaterial
var GroupObserved:Observable.WhenObserved
var Group:Array[TileHanlder]

signal GroupChanged(Change:Observable.WhenObserved)

func _ready() -> void:
	GetGroup.call_deferred()

func GetGroup() -> void:
	for Pos in GroupPoss:
		var GotTile = Level.PositionToTiles.get(Pos)
		if GotTile != null and GotTile is TileHanlder:
			Group.append(GotTile)
			GotTile.Sprite.material = GroupShader
			GotTile.GroupMat = GroupShader
			GotTile.ObservedChanged.connect(GroupChange)
			GotTile.ObservedMat = GroupObserveredShader

func GroupChange(ChangeTo:Observable.WhenObserved) -> void:
	for Tile in Group:
		if ChangeTo == Observable.WhenObserved.Was:
			Tile.Sprite.material = GroupShader
		if Tile.Observed != ChangeTo:
			Tile.Observed = ChangeTo
	
	if GroupObserved != ChangeTo:
		GroupObserved = ChangeTo
		GroupChanged.emit(ChangeTo)

##Set if colision is on or off
func ToggleGroupCollsion(Toggle:bool = true, On:bool = true, VisibilityMatch:bool = true) -> void:
	for Tile in  Group:
		Tile.ToggleCollsion(Toggle, On, VisibilityMatch)
