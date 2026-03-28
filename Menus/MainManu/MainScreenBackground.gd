extends TileMapLayer

@export var FakePlayer:AnimatedSprite2D
@export var RandomTimer:Timer

func _ready() -> void:
	RandomTimer.start(randf_range(.1, 2))
	RandomTimer.timeout.connect(AnimateFakePlayer)

func AnimateFakePlayer() -> void:
	FakePlayer.position = Vector2(-16, randi_range(1, 20)*16)
	for i in 22:
		var NewPosition = FakePlayer.position
		NewPosition.x += 32
		FakePlayer.play("MoveRight")
		var MoveTween:Tween = create_tween()
		MoveTween.tween_property(FakePlayer, "position", NewPosition, .1)
		await MoveTween.finished
	RandomTimer.start(randf_range(.1, 2))
