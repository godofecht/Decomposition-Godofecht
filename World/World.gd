extends Node2D

onready var Shadows = $Map/Shadows

func _ready() -> void:
	Shadows.visible = true
