extends Control
##Used for Handling menus
class_name MenuHandler

##This Menu Grabs first
@export var GrabFirst:bool = false
##Position When moving in
@export var InPos:Vector2
##Position when moving out
@export var OutPos:Vector2
##Control node that is first focused
@export var FirstFocus:Control
##Previous menu for going back to
@export var PreviousMenu:Control

@export_category("Possible Buttons")
##Buttons and thier menus
@export var ButtonToMenu:Dictionary[Button, Control]
##Button to go back to previous menu
@export var GoBackButton:Button
##Button to go to level select menu
@export var LevelSelectButton:Button
##UID of level Select menu
var LevelSelectUID:String
##Button to go to Main menu
@export var MainMenuButton:Button
##UID of Main Menu
var MainMenuUID:String = "uid://buvo6k3q5bmq1"
##Button to close the game
@export var QuitGameButton:Button

func _ready() -> void:
	if GrabFirst:
		FirstFocus.grab_focus()
	if GoBackButton != null:
		GoBackButton.pressed.connect(GoToMenu)
	if LevelSelectButton != null:
		LevelSelectButton.pressed.connect(GoToSceneMenu.bind(LevelSelectUID))
	if MainMenuButton != null:
		MainMenuButton.pressed.connect(GoToSceneMenu.bind(MainMenuUID))
	if QuitGameButton != null:
		QuitGameButton.pressed.connect(QuitGame)
	for Butt in ButtonToMenu:
		var PotentialMenu = ButtonToMenu.get(Butt)
		if PotentialMenu != null:
			Butt.pressed.connect(GoToMenu.bind(PotentialMenu))
		else:
			Butt.pressed.connect(GoToMenu)

##Used to move Menu in and out
func MoveInOut(In:bool = true) -> void:
	#Prep Position
	position = OutPos if In else InPos
	show()
	#Create tween
	var MoveTween:Tween = create_tween()
	var CorrectPos:Vector2 = InPos if In else OutPos
	MoveTween.tween_property(self, "position", CorrectPos, .2)
	#Grab focus when enter screen
	if In:
		if FirstFocus != null:
			FirstFocus.grab_focus()
	#Hide if off screen
	else:
		await MoveTween.finished
		hide()

##Go to menu
func GoToMenu(NewMenu:MenuHandler = PreviousMenu) -> void:
	if NewMenu != null:
		MoveInOut(false)
		NewMenu.PreviousMenu = self
		NewMenu.MoveInOut()
	else:
		push_warning("YOU MISSED A MENU AT %s LOOSER" %self)

##Go To Scene Menu
func GoToSceneMenu(UID:String) -> void:
	get_tree().change_scene_to_file.call_deferred(UID)

##Closes the game
func QuitGame() -> void:
	get_tree().quit()
