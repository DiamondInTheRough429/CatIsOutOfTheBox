extends MenuHandler
class_name SettingsMenuHandler

#region Video Vars
@export var ResolutionButton:OptionButton
@export var FullScreenButton:CheckButton
@export var VsyncButton:CheckButton
#endregion

#region Audio Vars
@export var MasterVolumeSlider:Range
@export var MusicVolumeSlider:Range
@export var SoundEffectVolumeSlider:Range
#endregion

signal tab_changed(tab:int)
@export var SelfTabCon:TabContainer
@export var TabToFirstFocus:Dictionary[int, Control] = {
	0 : null,
	1 : null,
	2 : null,
	3 : null,
}

func _ready() -> void:
	super._ready()
	#region Video Ready
	if ResolutionButton != null:
		ResolutionButton.select(SettingsHandler.CurrentResolution)
		ResolutionButton.item_selected.connect(SettingsHandler.SetResolution)
	if FullScreenButton != null:
		FullScreenButton.button_pressed = SettingsHandler.CurrentFullscreen
		FullScreenButton.toggled.connect(SettingsHandler.SetFullScreen)
	if VsyncButton != null:
		VsyncButton.button_pressed = SettingsHandler.CurrentlyVsynced
		VsyncButton.toggled.connect(SettingsHandler.SetVsync)
	#endregion
	#region Audio Ready
	if MasterVolumeSlider != null:
		MasterVolumeSlider.value_changed.connect(SettingsHandler.SetMasterVol)
		MasterVolumeSlider.step = .01
		MasterVolumeSlider.max_value = 1.5
		MasterVolumeSlider.value = SettingsHandler.MasterVolume
	if MusicVolumeSlider != null:
		MusicVolumeSlider.value_changed.connect(SettingsHandler.SetMusicVol)
		MusicVolumeSlider.step = .01
		MusicVolumeSlider.max_value = 1.5
		MusicVolumeSlider.value = SettingsHandler.MusicVolume
	if SoundEffectVolumeSlider != null:
		SoundEffectVolumeSlider.value_changed.connect(SettingsHandler.SetSoundEffectVol)
		SoundEffectVolumeSlider.step = .01
		SoundEffectVolumeSlider.max_value = 1.5
		SoundEffectVolumeSlider.value = SettingsHandler.SoundEffectVolume
	#endregion
	if has_signal("tab_changed"):
		tab_changed.connect(SetFirstFocus)

func _input(event: InputEvent) -> void:
		if CurrentMenu:
			if event.is_action_pressed("UI_TabSwitchLeft"):
				ChangeTab(true)
			if event.is_action_pressed("UI_TabSwitchRight"):
				ChangeTab(false)

func ChangeTab(Left:bool) -> void:
	if SelfTabCon != null:
		var PossibleTab:int = SelfTabCon.current_tab
		PossibleTab += 1 if !Left else -1
		if PossibleTab < 0:
			PossibleTab = SelfTabCon.get_tab_count()-1
		elif PossibleTab >= SelfTabCon.get_tab_count():
			PossibleTab = 0
		SelfTabCon.current_tab = PossibleTab

func SetFirstFocus(Tab:int) -> void:
	var NewFirst:Control = TabToFirstFocus.get(Tab)
	if NewFirst != null:
		FirstFocus = NewFirst
		NewFirst.grab_focus.call_deferred()
