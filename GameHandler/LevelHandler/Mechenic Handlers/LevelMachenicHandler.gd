extends Node
class_name LevelMachenicHandler

@export var Level:LevelHandler

func _ready() -> void:
	if Level != null:
		Level.ResetingLevel.connect(Reset)
		Level.LevelReady.connect(LevelReady)

func Reset() -> void:
	pass

func LevelReady() -> void:
	pass
