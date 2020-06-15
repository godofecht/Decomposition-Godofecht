extends Node2D


onready var AmmoUI = $CanvasLayer/HUD/Ammo

func _on_Player_AmmoChange(value) -> void:
	AmmoUI.text = "Ammo Left: %s" % value
