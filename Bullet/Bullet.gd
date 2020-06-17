extends RigidBody2D

onready var animationPlayer = $Sprite/AnimationPlayer

export var color = "green"

func _ready() -> void:
	animationPlayer.play(color)
