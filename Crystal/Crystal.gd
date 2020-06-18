extends RigidBody2D

var shouldIgnoreSound = false
onready var DropSFX = $DropSFX

func _ready() -> void:
	if (shouldIgnoreSound):
		DropSFX.autoplay = false
		DropSFX.stop()
