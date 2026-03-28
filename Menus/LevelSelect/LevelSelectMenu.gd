extends MenuHandler
class_name LevelSelectMenu

@export var Worlds:Array[MadeLevelPack]
@export var WorldMenus:PackedScene

signal tab_changed(tab:int)
@export var SelfTabCon:TabContainer
@export var TabToFirstFocus:Dictionary[int, Control]

func _ready() -> void:
	super._ready()
	DisplayServer.window_set_title.call_deferred(tr("GAME_TITLE"))
	MakeTabs.call_deferred()
	if has_signal("tab_changed"):
		tab_changed.connect(SetFirstFocus)

func MakeTabs() -> void:
	for World:MadeLevelPack in Worlds:
		var NewTab:WorldMenu = WorldMenus.instantiate()
		add_child(NewTab)
		NewTab.WorldInfo = World
		NewTab.MatchWorld()
		NewTab.MakeButtons.call_deferred()
		SetFocus.call_deferred.call_deferred(World.World, NewTab)

func SetFocus(World:int, Tab:WorldMenu) -> void:
	TabToFirstFocus.set(World, Tab.LevelButtonHolder.get_child(0))
	SetFirstFocus(SelfTabCon.current_tab)

func _input(event: InputEvent) -> void:
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
