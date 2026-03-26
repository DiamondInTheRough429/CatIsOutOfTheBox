extends Button
class_name CosmeticButton

@export var CosmeticOfButton:SettingsHandler.Cosmetics
@export var LockedIcon:Texture2D
@export var CurrentLabel:Label
@export var CosmeticToIcon:Dictionary[SettingsHandler.Cosmetics, Texture2D] ={
	SettingsHandler.Cosmetics.DEFAULT_COSMETIC : null,
	SettingsHandler.Cosmetics.GOJO_COSMETIC : null,
	SettingsHandler.Cosmetics.JELLIE_COSMETIC : null,
	SettingsHandler.Cosmetics.SNAKE_COSMETIC : null,
	SettingsHandler.Cosmetics.ROBOTCAT_COSMETIC : null,
	SettingsHandler.Cosmetics.RAT_COSMETIC : null,
	SettingsHandler.Cosmetics.CATCAT_COSMETIC : null,
	SettingsHandler.Cosmetics.DEVART_COSMETIC : null 
}

func _ready() -> void:
	UpdateLook()
	pressed.connect(Choose)

func UpdateLook() -> void:
	if SaveHandler.GetCosmeticUnlocked(CosmeticOfButton):
		icon = CosmeticToIcon.get(CosmeticOfButton)
		text = SettingsHandler.Cosmetics.keys().get(CosmeticOfButton)
	else:
		icon = LockedIcon
		text = "NOT_UNLOCKED_COSMETIC"
		disabled = true
	CurrentLabel.visible = true if SettingsHandler.CurrentCosmetic == CosmeticOfButton else false

func Choose() -> void:
	SettingsHandler.CurrentCosmetic = CosmeticOfButton
