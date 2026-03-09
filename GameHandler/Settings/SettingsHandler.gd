extends Node
##Handles Settings
class_name Settings_Handler_Script

#region General

#endregion

#region Visual
enum Resolutions{X1, X2, X3, X4}
var CurrentResolution:Resolutions
#endregion

#region Audio

#endregion

#region Controls

#endregion

#region Costumes

#endregion

#region SettingsLogic
var SettingsConfig:ConfigFile = ConfigFile.new()
#endregion

func SaveSettingConf()->void:
	pass

func LoadSettingConf()->void:
	pass

func _ready() -> void:
	SetResolution(Resolutions.X3)

func SetResolution(res:Resolutions)->void:
	SettingsConfig.set_value("Visaul", "Resolution", res)
	var ResV2:Vector2
	match res:
		Resolutions.X1:
			ResV2 = Vector2(640, 320)
		Resolutions.X2:
			ResV2 = Vector2(1280, 640)
		Resolutions.X3:
			ResV2 = Vector2(1920, 960)
		Resolutions.X4:
			ResV2 = Vector2(2560, 1280)
	DisplayServer.window_set_size(ResV2)
	var ScreenSize:Vector2 = DisplayServer.screen_get_size()
	var Centered:Vector2 = Vector2(ScreenSize.x/2 - ResV2.x/2, ScreenSize.y/2 - ResV2.y/2)
	DisplayServer.window_set_position(Centered)
