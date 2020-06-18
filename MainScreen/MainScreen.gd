extends Node2D

onready var cr = $ColorRect
onready var nextLvlA = $NextLevelArea

func _ready() -> void:
	nextLvlA.colorRectForTransition = cr
