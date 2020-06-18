extends Node2D

func _on_GiveUpArea_body_entered(body: Node) -> void:
	get_tree().quit()
	get_tree().change_scene("res://MainScreen/MainScreen.tscn")
	

onready var nextLevelArea = $NextLevelArea

func _ready() -> void:
	nextLevelArea.colorRectForTransition = $ColorRect
	nextLevelArea.nextLevel = Global.CURRENT_LEVEL_SCENE
