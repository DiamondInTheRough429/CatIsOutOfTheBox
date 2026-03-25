extends Button
class_name CosmeticButton

@export var CosmeticOfButton:SettingsHandler.Cosmetics

@export var CosmeticToIcon:Dictionary[SettingsHandler.Cosmetics, Texture2D]

func _ready() -> void:
	icon = CosmeticToIcon.get(CosmeticOfButton)
	text = SettingsHandler.Cosmetics.keys().get(CosmeticOfButton)
