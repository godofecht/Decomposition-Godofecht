extends Node2D

onready var AmmoUI = $UI/HUD/Ammo
onready var Shadows = $Map/Shadows

func _on_Player_AmmoChange(value) -> void:
	AmmoUI.text = "Ammo Left: %s" % value

func _ready() -> void:
	Shadows.visible = true

