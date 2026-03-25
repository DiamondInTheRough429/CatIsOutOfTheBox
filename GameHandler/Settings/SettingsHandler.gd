extends Node
##Handles Settings
class_name Settings_Handler_Script

#region General

#endregion

#region Visual
##Posible resolutions of game
enum Resolutions{X1, X2, X3, X4}
##Current resolution of game
var CurrentResolution:Resolutions : set = SetResolution
##Tells if currently full screen 
var CurrentFullscreen:bool = false : set = SetFullScreen
var CurrentlyVsynced:bool = false : set = SetVsync
#endregion

#region Audio
##Master volume
@export_range(0, 1.5, .01) var MasterVolume:float = 1: set = SetMasterVol
##Music Volume
@export_range(0, 1.5, .01) var MusicVolume:float = 1: set = SetMusicVol
##Sound effect volume
@export_range(0, 1.5, .01) var SoundEffectVolume:float = 1: set = SetSoundEffectVol
#endregion

#region Controls

#endregion

#region Costumes
enum Cosmetics{DEFAULT_COSMETIC, GOJO_COSMETIC, JELLIE_COSMETIC, SNAKE_COSMETIC, ROBOTCAT_COSMETIC, RAT_COSMETIC, CATCAT_COSMETIC, DEVART_COSMETIC}
var CurrentCosmetic:Cosmetics = Cosmetics.DEFAULT_COSMETIC : set = SetCurrentCosmetic
#endregion

#region SettingsLogic
var SettingsConfig:ConfigFile = ConfigFile.new()
var SettingsLocation:String = "user://Settings.cfg"
#endregion

func _ready() -> void:
	PrepSettingsConf()

func PrepSettingsConf()->void:
	var prepDir:DirAccess = DirAccess.open("user://")
	if !prepDir.file_exists(SettingsLocation):
		print("Making Settings")
		SaveSettingConf()
	LoadSettingConf()

func SaveSettingConf()->void:
	SettingsConfig.save(SettingsLocation)

func LoadSettingConf()->void:
	SettingsConfig.load(SettingsLocation)
	#region video
	CurrentFullscreen = SettingsConfig.get_value("Video", "FullScreen", false)
	CurrentlyVsynced = SettingsConfig.get_value("Video", "Vsync", false)
	CurrentResolution = SettingsConfig.get_value("Video", "Resolution", Resolutions.X1)
	#endregion
	#region Audio
	MasterVolume = SettingsConfig.get_value("Audio", "MasterVolume", 1)
	MusicVolume = SettingsConfig.get_value("Audio", "MusicVolume", 1)
	SoundEffectVolume = SettingsConfig.get_value("Audio", "SoundEffectVolume", 1)
	#endregion
	#region Cosmetics
	CurrentCosmetic = SettingsConfig.get_value("Cosmetic", "Current", Cosmetics.DEFAULT_COSMETIC)
	#endregion
	SaveSettingConf()

#region video
func SetFullScreen(Set:bool) -> void:
	CurrentFullscreen = Set
	SettingsConfig.set_value("Video", "FullScreen", Set)
	var Mode:DisplayServer.WindowMode = DisplayServer.WINDOW_MODE_FULLSCREEN if CurrentFullscreen else DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(Mode)
	SaveSettingConf()

func SetVsync(Set:bool) -> void:
	CurrentlyVsynced = Set
	SettingsConfig.set_value("Video", "Vsync", Set)
	var Mode:DisplayServer.VSyncMode = DisplayServer.VSYNC_ENABLED if Set else DisplayServer.VSYNC_DISABLED
	DisplayServer.window_set_vsync_mode(Mode)
	SaveSettingConf()

func SetResolution(res:Resolutions)->void:
	SettingsConfig.set_value("Video", "Resolution", res)
	CurrentResolution = res
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
	DisplayServer.window_set_size(ResV2+Vector2(1,1))
	var ScreenSize:Vector2 = DisplayServer.screen_get_size()
	var Centered:Vector2 = Vector2(ScreenSize.x/2 - ResV2.x/2, ScreenSize.y/2 - ResV2.y/2)
	DisplayServer.window_set_position(Centered)
	DisplayServer.window_set_size.call_deferred(ResV2)
	SaveSettingConf()
#endregion

#region Audio
##Set master volume
func SetMasterVol(NewVal:float) -> void:
	SettingsConfig.set_value("Audio", "MasterVolume", NewVal)
	SaveSettingConf()
	MasterVolume = NewVal
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), MasterVolume)

##Set music volume
func SetMusicVol(NewVal:float) -> void:
	SettingsConfig.set_value("Audio", "MusicVolume", NewVal)
	SaveSettingConf()
	MusicVolume = NewVal
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), MusicVolume)

##set sound effects voulume
func SetSoundEffectVol(NewVal:float) -> void:
	SettingsConfig.set_value("Audio", "SoundEffectVolume", NewVal)
	SaveSettingConf()
	SoundEffectVolume = NewVal
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SoundEffects"), SoundEffectVolume)
#endregion

#region Cosmetics
func SetCurrentCosmetic(NewCurrent:Cosmetics) -> void:
	CurrentCosmetic = NewCurrent
	SettingsConfig.set_value("Cosmetic", "Current", CurrentCosmetic)
	SaveSettingConf()
#endregion
