extends TileMapLayer

@export var FakePlayer:AnimatedSprite2D
@export var RandomTimer:Timer

func _ready() -> void:
	RandomTimer.start(randi_range(1, 15))
	RandomTimer.timeout.connect(AnimateFakePlayer)

func AnimateFakePlayer() -> void:
	FakePlayer.position = Vector2(-16, randi_range(1, 20)*16)
	for i in 320:
		var NewPosition = FakePlayer.position
		NewPosition.x += 32
		FakePlayer.play("MoveRight")
		var MoveTween:Tween = create_tween()
		MoveTween.tween_property(FakePlayer, "position", NewPosition, .1)
		await MoveTween.finished
	RandomTimer.start(randi_range(1, 15))
