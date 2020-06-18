extends Node2D

func _on_GiveUpArea_body_entered(body: Node) -> void:
	get_tree().quit()

onready var nextLevelArea = $NextLevelArea

func _ready() -> void:
	nextLevelArea.nextLevel = Global.CURRENT_LEVEL_SCENE
