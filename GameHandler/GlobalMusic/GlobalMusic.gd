extends Node
class_name GlobalMusic_Script

var MusicPlayer:AudioStreamPlayer
var DefaultMusic:AudioStream
var Music:Dictionary[int, Variant.Type] = {
	
}

func _ready() -> void:
	if MusicPlayer == null:
		var NewPlayer:AudioStreamPlayer = AudioStreamPlayer.new()
		NewPlayer.bus = "Music"
		NewPlayer.autoplay = true
		NewPlayer.stream = Music.get(-1, DefaultMusic)
		add_child(NewPlayer)
		MusicPlayer = NewPlayer

func SetMusic(World:int) -> void:
	MusicPlayer.stream = Music.get(World, DefaultMusic)
